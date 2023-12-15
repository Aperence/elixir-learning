defmodule ServerWeb.LoginController do
  use ServerWeb, :controller

  def login(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
