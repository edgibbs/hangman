defmodule Hangman.Server do

  use GenServer
  alias Hangman.Game

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def start_link(word) do
    GenServer.start_link(__MODULE__, word)
  end

  def init(word) do
    start_game(word)
  end

  def handle_call({:make_move, guess}, _from, game) do
    { game, tally } = Game.make_move(game, guess)
    { :reply, tally, game }
  end

  def handle_call({:tally}, _from, game) do
    { :reply, Game.tally(game), game }
  end

  defp start_game(word) when is_nil(word) do
    {:ok, Game.new_game() }
  end

  defp start_game(word) do
    {:ok, Game.new_game(word) }
  end

end
