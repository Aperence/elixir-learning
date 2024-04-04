defmodule ServerWeb.PageController do
  use ServerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    self_node = inspect(node())
    nodes = inspect(Node.list())

    conn
    # |> put_status(200)
    # |> put_flash(:error, "Pretended error")
    |> render(:home, layout: false, node: self_node, nodes: nodes)
  end

  def redirect_home(conn, _params) do
    redirect(conn, to: ~p"/")
  end
end
