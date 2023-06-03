defmodule WcsBotWeb.PageController do
  use WcsBotWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    href_link = WcsBotWeb.Router.Helpers.static_path(WcsBotWeb.Endpoint, "/docs/index.html")

    render(conn, :home, layout: false, href_link: href_link)
  end
end
