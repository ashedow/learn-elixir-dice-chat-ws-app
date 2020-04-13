defmodule DiceRollerChatAppTest do
  use ExUnit.Case
  use Plug.Test

  @opts DiceRollerChatApp.Router.init([])

  doctest DiceRollerChatApp

  test "get / 200" do
    conn = conn(:get, "/")
    conn = DiceRollerChatApp.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "get /something 404" do
    conn = conn(:get, "/something")
    conn = DiceRollerChatApp.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
