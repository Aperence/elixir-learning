defmodule ServerWeb.TestProductController do
  use ServerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
  end

  def index(conn, _params) do
    json(conn, %{"Apple" => %{
      "price" => 3,
      "img" => "some image"
    }})
  end
end
