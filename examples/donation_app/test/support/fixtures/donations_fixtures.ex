defmodule DonationApp.DonationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DonationApp.Donations` context.
  """

  @doc """
  Generate a donation.
  """
  def donation_fixture(attrs \\ %{}) do
    {:ok, donation} =
      attrs
      |> Enum.into(%{
        amount_cents: 42,
        name: "some name"
      })
      |> DonationApp.Donations.create_donation()

    donation
  end
end
