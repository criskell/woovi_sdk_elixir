defmodule DonationApp.Donations do
  import Ecto.Query
  alias DonationApp.Repo

  alias DonationApp.Donations.Donation

  def list_donations do
    Repo.all(from d in Donation, order_by: [desc: d.inserted_at])
  end

  def get_donation!(id) do
    Repo.get!(Donation, id)
  end

  def create_donation(attrs \\ %{}) do
    %Donation{}
    |> Donation.changeset(attrs)
    |> Repo.insert()
  end

  def change_donation(%Donation{} = donation, attrs \\ %{}) do
    Donation.changeset(donation, attrs)
  end

  def delete_donation(%Donation{} = donation) do
    Repo.delete(donation)
  end
end
