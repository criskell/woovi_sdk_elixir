defmodule DonationApp.Donations do
  import Ecto.Query
  alias WooviSdk.Client.Charge
  alias DonationApp.Repo
  alias DonationApp.Payment.Woovi

  alias DonationApp.Donations.Donation

  def list_donations do
    Repo.all(from d in Donation, order_by: [desc: d.inserted_at])
  end

  def get_donation!(id) do
    Repo.get!(Donation, id)
  end

  def create_donation(attrs) do
    correlation_id = Ecto.UUID.generate()

    with {:ok, donation} <-
           %Donation{}
           |> Donation.changeset(Map.put(attrs, "correlation_id", correlation_id))
           |> Repo.insert(),
         {:ok, charge_response} <-
           Woovi.config()
           |> Charge.create(%{
             correlationID: correlation_id,
             value: attrs["amount_cents"],
             comment: "Donation",
             customer: %{
               name: donation.name,
               taxID: attrs["tax_id"]
             }
           }) do
      %{charge: charge} = charge_response

      {:ok, %{donation: donation, brcode: charge.brCode, qrcode_image_url: charge.qrCodeImage}}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}

      {:error, woovi_error} ->
        {:error, {:payment_failed, woovi_error}}
    end
  end

  def change_donation(%Donation{} = donation, attrs \\ %{}) do
    Donation.changeset(donation, attrs)
  end

  def delete_donation(%Donation{} = donation) do
    Repo.delete(donation)
  end

  def confirm_donation(correlation_id) do
    donation = Repo.get_by!(Donation, correlation_id: correlation_id)

    donation
    |> Donation.changeset(%{status: "paid"})
    |> Repo.update()
  end
end
