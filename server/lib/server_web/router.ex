defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ServerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :introspect
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ServerWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/hello", HelloController, :hello
    get "/hello/:messenger", HelloController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ServerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:server, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ServerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def introspect(conn, _opts) do
    IO.puts """
    Verb: #{inspect(conn.method)}
    Host: #{inspect(conn.host)}
    Headers: #{inspect(conn.req_headers)}
    """

    conn
  end
end
