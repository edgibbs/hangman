defmodule HangmanTest do
  use ExUnit.Case

  test "can create a new game state" do
    game = Hangman.new_game
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) >= 1
    assert Enum.all?(game.letters, fn letter -> Regex.match?(~r/[a-z]/, letter) end)
  end

  test "state is unchanged for won and lost game" do
    for state <- [ :won, :lost ] do
      game = Hangman.new_game |> Map.put(:game_state, state)
      assert { ^game, _ } = Hangman.make_move(game, "x")
    end
  end
end
