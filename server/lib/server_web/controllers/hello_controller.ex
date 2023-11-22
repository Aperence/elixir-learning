defmodule ServerWeb.HelloController do
  use ServerWeb, :controller

  def hello(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :hello)
  end

  def show(conn, %{"messenger" => messenger} = _params) do
    render(conn, :name, messenger: messenger)
  end
end
