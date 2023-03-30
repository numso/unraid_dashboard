defmodule DashyWeb.Router do
  use DashyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DashyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DashyWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/borrows", BorrowLive.Index, :index
    live "/borrows/new", BorrowLive.Index, :new
    live "/borrows/:id/edit", BorrowLive.Index, :edit

    live "/borrows/:id", BorrowLive.Show, :show
    live "/borrows/:id/show/edit", BorrowLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", DashyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dashy, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DashyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
