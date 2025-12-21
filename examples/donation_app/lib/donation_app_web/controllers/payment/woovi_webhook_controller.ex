defmodule DonationAppWeb.Payment.WooviWebhookController do
  use DonationAppWeb, :controller

  alias DonationAppWeb.Endpoint
  alias DonationApp.Donations

  def receive_webhook(conn, params) do
    event = params["evento"] || params["event"]

    handle_webhook(conn, event, params)
  end

  def handle_webhook(conn, "teste_webhook", _params) do
    send_resp(conn, 200, "ok")
  end

  def handle_webhook(conn, "OPENPIX:CHARGE_COMPLETED", params) do
    %{"charge" => charge} = params

    correlation_id = charge["correlationID"]

    case Donations.confirm_donation(correlation_id) do
      {:ok, donation} ->
        Endpoint.broadcast("donation:#{donation.id}", "payment_confirmed", %{})

        send_resp(conn, 200, "ok")

      {:error, _} ->
        send_resp(conn, 400, "error")
    end
  end
end
