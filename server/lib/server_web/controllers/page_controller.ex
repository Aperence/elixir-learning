defmodule ServerWeb.PageController do
  use ServerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    # |> put_status(200)
    # |> put_flash(:error, "Pretended error")
    |> render(:home, layout: false)
  end

  def redirect_home(conn, _params) do
    redirect(conn, to: ~p"/")
  end
end
