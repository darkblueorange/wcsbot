defmodule WcsBot.Repo do
  use Ecto.Repo,
    otp_app: :wcs_bot,
    adapter: Ecto.Adapters.Postgres
end
