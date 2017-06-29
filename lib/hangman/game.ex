defmodule Hangman.Game do

  alias Hangman.Game, as: Game

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
  )


  def new_game do
    %Game{
      letters: Dictionary.random_word |> String.codepoints
    }
  end

  def make_move(game = %{ game_state: state }, _) when state in [:won, :lost] do
    { game, tally(game) }
  end

  defp tally(game) do
    123
  end
end
