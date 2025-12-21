defmodule DonationApp.Payment.Woovi do
  alias WooviSdk.Config

  def config do
    Config.new(Application.fetch_env!(:donation_app, :woovi_sdk_token), Mix.env() != :prod)
  end
end
