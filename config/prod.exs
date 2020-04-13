config :dice_roller_chat_app, DiceRollerChatApp,
  port: "PORT" |> System.get_env() |> String.to_integer()
