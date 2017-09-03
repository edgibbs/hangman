defmodule Hangman do
  alias Hangman.Game

  # defdelegate new_game, to: Game
  # defdelegate new_game(word), to: Game
  # defdelegate tally(game), to: Game
  # defdelegate make_move(game, guess), to: Game

  def new_game() do
    Hangman.Server.start_link()
  end

  def new_game(word) do
    Hangman.Server.start_link(word)
  end

  def tally(game_pid) do
    GenServer.call(game_pid, { :tally })
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, { :make_move, guess })
  end

end
