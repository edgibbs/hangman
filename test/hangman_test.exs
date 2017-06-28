defmodule HangmanTest do
  use ExUnit.Case

  test "can create a new game state" do
    game = Hangman.new_game
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) >= 1
    assert Regex.match?(~r/[a-z]/, List.first(game.letters))
  end
end
