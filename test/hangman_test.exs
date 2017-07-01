defmodule HangmanTest do
  use ExUnit.Case

  test "can create a new game state" do
    game = Hangman.new_game
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.used == MapSet.new()
    assert length(game.letters) >= 1
    assert Enum.all?(game.letters, fn letter -> Regex.match?(~r/[a-z]/, letter) end)
  end

  test "state is unchanged for won and lost game" do
    for state <- [ :won, :lost ] do
      game = Hangman.new_game |> Map.put(:game_state, state)
      assert { ^game, _ } = Hangman.make_move(game, "x")
    end
  end

  test "first occurance of a letter not already used" do
    game = Hangman.new_game
    { game, _tally } = Hangman.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "state is also unchanged for prior guessed letter" do
    game = Hangman.new_game
    { game, _tally } = Hangman.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Hangman.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Hangman.new_game("wible")
    { game, _tally } = Hangman.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "guessing the whole word wins the game" do
    game = Hangman.new_game("wible")
    { game, _tally } = Hangman.make_move(game, "w")
    { game, _tally } = Hangman.make_move(game, "i")
    { game, _tally } = Hangman.make_move(game, "b")
    { game, _tally } = Hangman.make_move(game, "l")
    { game, _tally } = Hangman.make_move(game, "e")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "making a bad guess" do
    game = Hangman.new_game("burdell")
    { game, _tally } = Hangman.make_move(game, "w")
    assert game.turns_left == 6
    assert game.game_state == :bad_guess
  end

  test "losing the game" do
    game = Hangman.new_game("z")
    { game, _tally } = Hangman.make_move(game, "a")
    { game, _tally } = Hangman.make_move(game, "b")
    { game, _tally } = Hangman.make_move(game, "c")
    { game, _tally } = Hangman.make_move(game, "d")
    { game, _tally } = Hangman.make_move(game, "e")
    { game, _tally } = Hangman.make_move(game, "f")
    { game, _tally } = Hangman.make_move(game, "g")
    assert game.game_state == :lost
  end

  test "can get the tally of existing game" do
    game = Hangman.new_game("wible")
    { game, _tally } = Hangman.make_move(game, "w")
    tally = Hangman.tally(game)
    assert tally.game_state == :good_guess
    assert tally.turns_left == 7
    assert tally.letters == ~w[w _ _ _ _]
  end
end
