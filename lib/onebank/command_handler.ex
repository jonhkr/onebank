defmodule OneBank.CommandHandler do
  @moduledoc """
  A module responsible for validating and executing commands.

  """

  alias OneBank.CommandExecutor

  @typedoc "The command"
  @type command :: struct

  @doc """
  Receives a command, validates and executes it.
  
  Raises OneBank.ValidationError for invalid commands

  """
  @spec handle(command) :: term
  def handle(command) do
    command
      |> Vex.validate
      |> validate
  end

  defp validate({:ok, command}) do
    CommandExecutor.execute(command)
  end

  defp validate({:error, results}) do
    details = results
      |> Enum.reduce(%{}, fn({_, field, _, message}, acc) ->
        case Map.fetch(acc, field) do
          {:ok, v} -> Map.put(acc, field, [message | v])
          :error -> Map.put(acc, field, [message])
        end
      end)

    raise OneBank.ValidationError, details: details
  end
end