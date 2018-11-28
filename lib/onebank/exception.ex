defprotocol OneBank.Exception do
  @moduledoc """

  """

  @fallback_to_any true

  @doc """
  Receives an exception and returns its details.
  """
  @spec details(t) :: term
  def details(exception)
end

defimpl OneBank.Exception, for: Any do
  def details(%{details: details}), do: details
  def details(_), do: %{}
end

defmodule OneBank.ValidationError do
  @moduledoc """

  """

  defexception message: "could not process command due to validation errors",
               details: %{},
               plug_status: 422
end

defmodule OneBank.NotImplementedError do
  @moduledoc """

  """

  defexception message: "command is not implemented yet",
               details: %{},
               plug_status: 500
end

defmodule OneBank.ConflictError do
  @moduledoc """

  """

  defexception message: "processing this command would lead to an inconsistent state",
               details: %{},
               plug_status: 409
end

defmodule OneBank.InternalError do
  @moduledoc """

  """

  defexception message: "something went wrong while processing the command",
               details: %{},
               plug_status: 500
end

defmodule OneBank.AuthenticationError do
  @moduledoc """

  """

  defexception message: "failed to authenticate user",
               details: %{},
               plug_status: 401
end

defmodule OneBank.InsufficientFundsError do
  @moduledoc """

  """

  defexception message: "account has no funds to fulfil the transaction",
               details: %{},
               plug_status: 422
end

