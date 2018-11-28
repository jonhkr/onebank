defmodule OneBank.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias OneBank.{Router, Repo}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  @opts Router.init([])

  test "validate create user" do
    conn =
      conn(:post, "/users", "{}")
      |> put_req_header("content-type", "application/json")

    assert_raise OneBank.ValidationError, fn ->
      Router.call(conn, @opts)
    end

    assert_received {:plug_conn, :sent}

    {status, _headers, body} = sent_resp(conn)

    assert status == 422

    decoded_body = Jason.decode!(body)

    assert %{"code" => "ValidationError"} = decoded_body

    %{"details" => details} = decoded_body

    %{"name" => name_errors} = details
    assert ["must be present"] = name_errors

    %{"raw_password" => raw_password_errors} = details
    assert ["must have a length of at least 6", "must be present"] = raw_password_errors

    %{"username" => username_errors} = details
    assert ["must have a length of at least 4", "must be present"] = username_errors
  end

  test "handle create user" do
    create_user = %{name: "Jonas Trevisan", username: "jonast", raw_password: "abc123"}

    conn =
      conn(:post, "/users", Jason.encode!(create_user))
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.status == 200

    %{"name" => name, "username" => username} = Jason.decode!(conn.resp_body)

    assert create_user.name == name
    assert create_user.username == username
  end

  test "handle creating user with duplicate username" do
    create_user = %{name: "Jonas Trevisan", username: "jonast", raw_password: "abc123"}

    conn =
      conn(:post, "/users", Jason.encode!(create_user))
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.status == 200

    %{"name" => name, "username" => username} = Jason.decode!(conn.resp_body)

    assert create_user.name == name
    assert create_user.username == username

    conn =
      conn(:post, "/users", Jason.encode!(create_user))
      |> put_req_header("content-type", "application/json")

    assert_raise OneBank.ConflictError, fn ->
      Router.call(conn, @opts)
    end

    assert_received {:plug_conn, :sent}

    {status, _headers, body} = sent_resp(conn)

    assert status == 409

    decoded_body = Jason.decode!(body)
    assert %{"code" => "ConflictError"} = decoded_body

    %{"details" => details} = decoded_body
    %{"username" => username_errors} = details
    assert ["has already been taken"] = username_errors
  end

  test "create session" do
    create_user = %{name: "Jonas Trevisan", username: "jonast", raw_password: "abc123"}

    conn =
      conn(:post, "/users", Jason.encode!(create_user))
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.status == 200

    %{"id" => user_id} = Jason.decode!(conn.resp_body)

    session_request = Jason.encode!(%{raw_password: create_user.raw_password})

    conn =
      conn(:post, "/users/#{create_user.username}/sessions", session_request)
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.status == 200

    %{"id" => session_id, "user_id" => session_user_id, "revoked_at" => revoked_at} =
      Jason.decode!(conn.resp_body)

    assert session_id != nil
    assert session_user_id == user_id
    assert revoked_at == nil
  end
end
