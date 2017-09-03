defmodule HangmanTest do
  use ExUnit.Case

  test "can create a new game state" do
    {:ok, pid } = Hangman.new_game
    game = Hangman.tally(pid)
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.used == MapSet.new()
    assert length(game.letters) >= 1
    assert Enum.all?(game.letters, fn letter -> letter == "_" end)
  end

  @tag :capture_log
  test "must guess with a lower case ascii letter not upper case" do
    Process.flag :trap_exit, true
    { :ok, game_pid } = Hangman.new_game
    catch_exit do
      Hangman.make_move(game_pid, "X")
    end
    assert_received({:EXIT, ^game_pid, _})
  end

  @tag :capture_log
  test "must guess with a lower case ascii letter not a number" do
    Process.flag :trap_exit, true
    { :ok, game_pid } = Hangman.new_game
    catch_exit do
      Hangman.make_move(game_pid, "1")
    end
    assert_received({:EXIT, ^game_pid, _})
  end

  test "first occurance of a letter not already used" do
    { :ok, game_pid } = Hangman.new_game
    tally = Hangman.make_move(game_pid, "x")
    assert tally.game_state != :already_used
  end

  test "state is also unchanged for prior guessed letter" do
    { :ok, game_pid } = Hangman.new_game
    tally = Hangman.make_move(game_pid, "x")
    assert tally.game_state != :already_used
    new_tally = Hangman.make_move(game_pid, "x")
    assert new_tally.game_state == :already_used
  end

  test "a good guess is recognized" do
    { :ok, game_pid } = Hangman.new_game("wible")

    tally = Hangman.make_move(game_pid, "w")
    assert tally.game_state == :good_guess
    assert tally.turns_left == 7
  end

  test "guessing the whole word wins the game" do
    { :ok, game_pid } = Hangman.new_game("wible")
    Hangman.make_move(game_pid, "w")
    Hangman.make_move(game_pid, "i")
    Hangman.make_move(game_pid, "b")
    Hangman.make_move(game_pid, "l")
    tally = Hangman.make_move(game_pid, "e")
    assert tally.game_state == :won
    assert tally.turns_left == 7
  end

  test "state is unchanged for won game" do
    { :ok, game_pid } = Hangman.new_game("x")
    tally = Hangman.make_move(game_pid, "x")
    assert tally.game_state == :won
    tally = Hangman.make_move(game_pid, "f")
    assert tally.game_state == :won
  end

  test "making a bad guess" do
    { :ok, game_pid } = Hangman.new_game("burdell")
    tally = Hangman.make_move(game_pid, "w")
    assert tally.turns_left == 6
    assert tally.game_state == :bad_guess
  end

  test "losing the game" do
    { :ok, game_pid } = Hangman.new_game("z")
    Hangman.make_move(game_pid, "a")
    Hangman.make_move(game_pid, "b")
    Hangman.make_move(game_pid, "c")
    Hangman.make_move(game_pid, "d")
    Hangman.make_move(game_pid, "e")
    Hangman.make_move(game_pid, "f")
    tally = Hangman.make_move(game_pid, "g")
    assert tally.game_state == :lost
  end

  test "state is unchanged for lost game" do
    { :ok, game_pid } = Hangman.new_game("z")
    Hangman.make_move(game_pid, "a")
    Hangman.make_move(game_pid, "b")
    Hangman.make_move(game_pid, "c")
    Hangman.make_move(game_pid, "d")
    Hangman.make_move(game_pid, "e")
    Hangman.make_move(game_pid, "f")
    tally = Hangman.make_move(game_pid, "g")
    assert tally.game_state == :lost
    tally = Hangman.make_move(game_pid, "z")
    assert tally.game_state == :lost
  end

  test "can get the tally of existing game" do
    { :ok, game_pid } = Hangman.new_game("wible")
    Hangman.make_move(game_pid, "w")
    tally = Hangman.tally(game_pid)
    assert tally.game_state == :good_guess
    assert tally.turns_left == 7
    assert tally.letters == ~w[w _ _ _ _]
    assert tally.used == MapSet.new(["w"])
  end
end
