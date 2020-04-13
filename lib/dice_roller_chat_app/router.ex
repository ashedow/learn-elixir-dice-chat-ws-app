defmodule DiceRollerChatApp.Router do
  use Plug.Router
  require EEx

  require Logger

  plug(Plug.Logger, log: :debug)
  plug(:match)

  plug(Plug.Static,
    at: "/",
    from: :dice_roller_chat_app
  )

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:poison],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  EEx.function_from_file(:defp, :application_html, "lib/application.html.eex", [])

  get "/" do
    conn
    |> send_resp(200, application_html())
  end

  match _ do
    conn
    |> send_resp(404, "404\n This is not the page you are looking for")# the same: send_resp(conn, 404, "404\n This is not the page you are looking for")
  end
end
