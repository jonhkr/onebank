defmodule OneBank.Router do
  use Plug.Router
  use Plug.ErrorHandler
  require Logger

  alias OneBank.Command.CreateUser
  alias OneBank.Command.CreateSession

  plug Plug.Logger
  plug Plug.RequestId
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason

  plug :match
  plug :dispatch

  get "/_health" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "ok"}))
  end

  post "/users" do
    handle_command(conn, CreateUser)
  end

  post "/users/:username/sessions" do
    handle_command(conn, CreateSession)
  end

  match _ do
    send_resp(conn, 404, "")
  end

  defp handle_command(conn, command_type) do
    result = conn.params
      |> to_struct(struct(command_type))
      |> OneBank.CommandHandler.handle

    send_resp(conn, 200, Jason.encode!(result))
  end

  defp to_struct(map, kind) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn({k, _}, acc) ->
      case Map.fetch(map, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    Logger.info "Something went wrong. #{inspect reason}"

    error_code = reason.__struct__
      |> Module.split
      |> List.last

    send_resp(conn, conn.status, Jason.encode!(%{
      code: error_code,
      message: Exception.message(reason),
      details: OneBank.Exception.details(reason)
      }))
  end
end
