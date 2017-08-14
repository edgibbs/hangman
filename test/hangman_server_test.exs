defmodule ServerTest do
  use ExUnit.Case

  test "can make a move" do
    { :ok, game } = Hangman.Server.start_link()
     tally = GenServer.call(game, {:make_move, "a"})
    assert tally.used |> MapSet.to_list == ["a"]
  end
end
