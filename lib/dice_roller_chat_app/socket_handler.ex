defmodule DiceRollerChatApp.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.DiceRollerChatApp
    |> Registry.register(state.registry_key, {})

    for message <- Enum.reverse(MessageStore.messages()) do
      Process.send(self(), Poison.encode!(message), [])
    end

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    payload = Poison.decode!(json)
    message = payload["data"]["message"]
    name = payload["data"]["name"]

    if response = create_answer(name, message) do
      Registry.DiceRollerChatApp
      |> Registry.dispatch(state.registry_key, fn entries ->
        for {pid, _} <- entries do
          Process.send(pid, "#{Poison.encode!(response)}", [])
        end
      end)

      MessageStore.append(response)
    end

    {:ok, state}
  end

  def create_answer(name, message) do
    if not (String.trim(name) == "") and not (String.trim(message) == "") do
      reg = Regex.named_captures(~r/(?<num_dice>\d*)d(?<num_sides>\d+)/, message)

      diceResults =
        case reg do
          nil ->
            nil

          reg ->
            dices =
              case Integer.parse(reg["num_dice"]) do
                :error -> 1
                {number, _} -> number
              end

            {sides, _} = Integer.parse(reg["num_sides"])
            results = for _ <- 1..dices, do: :rand.uniform(sides)
            results
        end

      %{name: name, message: message, diceResults: diceResults}
    end
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
