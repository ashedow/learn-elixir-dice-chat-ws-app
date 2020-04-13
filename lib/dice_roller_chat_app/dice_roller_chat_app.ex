defmodule DiceRollerChatApp do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: DiceRollerChatApp.Router,
        options: [
          dispatch: dispatch()
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.DiceRollerChatApp
      )
    ]

    opts = [strategy: :one_for_one, name: DiceRollerChatApp.Application]
    Supervisor.start_link(children, opts)
    MessageStore.start_link([])
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/[...]", DiceRollerChatApp.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {DiceRollerChatApp.Router, []}}
       ]}
    ]
  end
end
