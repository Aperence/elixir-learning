defmodule ServerWeb.UserController do
  use ServerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
  end

  def index(conn, _params) do
    json(conn, "Hello")
  end

  def call(conn, _params) do
    # example on how to close connexion if invalid token per example
    r = Req.get!("https://httpbin.org/anything", params: %{"token" => "some_token"})
    body = r.body
    IO.inspect(body)
    if r.status != 200 do
      IO.puts("Invalid user, aborting...")
      conn
      |> put_status(400)
      |> text("invalid api key")
      |> halt()
    end
    IO.puts("Valid user, continuing...")
    conn
  end
end
