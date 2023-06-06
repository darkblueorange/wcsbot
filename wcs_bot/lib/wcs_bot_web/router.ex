defmodule WcsBotWeb.Router do
  use WcsBotWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WcsBotWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WcsBotWeb do
    pipe_through :browser

    get "/", PageController, :home

    # live_session :default do
    live "/dance_schools", DanceSchoolLive.Index, :index
    live "/dance_schools/new", DanceSchoolLive.Index, :new
    live "/dance_schools/:id/edit", DanceSchoolLive.Index, :edit

    live "/dance_schools/:id", DanceSchoolLive.Show, :show
    live "/dance_schools/:id/show/edit", DanceSchoolLive.Show, :edit
    live "/events", EventLive.Index, :index
    live "/events/new", EventLive.Index, :new
    live "/events/:id/edit", EventLive.Index, :edit

    live "/events/:id", EventLive.Show, :show
    live "/events/:id/show/edit", EventLive.Show, :edit

    live "/small_parties", SmallPartyLive.Index, :index
    live "/small_parties/new", SmallPartyLive.Index, :new
    live "/small_parties/:id/edit", SmallPartyLive.Index, :edit

    live "/small_parties/:id", SmallPartyLive.Show, :show
    live "/small_parties/:id/show/edit", SmallPartyLive.Show, :edit

    live "/strictly_askings", StrictlyAskingLive.Index, :index
    live "/strictly_askings/new", StrictlyAskingLive.Index, :new
    live "/strictly_askings/:id/edit", StrictlyAskingLive.Index, :edit

    live "/strictly_askings/:id", StrictlyAskingLive.Show, :show
    live "/strictly_askings/:id/show/edit", StrictlyAskingLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", WcsBotWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:wcs_bot, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WcsBotWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
