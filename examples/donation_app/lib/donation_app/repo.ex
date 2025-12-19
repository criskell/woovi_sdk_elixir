defmodule DonationApp.Repo do
  use Ecto.Repo,
    otp_app: :donation_app,
    adapter: Ecto.Adapters.Postgres
end
