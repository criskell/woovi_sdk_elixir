defmodule DonationApp.DonationsTest do
  use DonationApp.DataCase

  alias DonationApp.Donations

  describe "donations" do
    alias DonationApp.Donations.Donation

    import DonationApp.DonationsFixtures

    @invalid_attrs %{name: nil, amount_cents: nil}

    test "list_donations/0 returns all donations" do
      donation = donation_fixture()
      assert Donations.list_donations() == [donation]
    end

    test "get_donation!/1 returns the donation with given id" do
      donation = donation_fixture()
      assert Donations.get_donation!(donation.id) == donation
    end

    test "create_donation/1 with valid data creates a donation" do
      valid_attrs = %{name: "some name", amount_cents: 42}

      assert {:ok, %Donation{} = donation} = Donations.create_donation(valid_attrs)
      assert donation.name == "some name"
      assert donation.amount_cents == 42
    end

    test "create_donation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Donations.create_donation(@invalid_attrs)
    end

    test "update_donation/2 with valid data updates the donation" do
      donation = donation_fixture()
      update_attrs = %{name: "some updated name", amount_cents: 43}

      assert {:ok, %Donation{} = donation} = Donations.update_donation(donation, update_attrs)
      assert donation.name == "some updated name"
      assert donation.amount_cents == 43
    end

    test "update_donation/2 with invalid data returns error changeset" do
      donation = donation_fixture()
      assert {:error, %Ecto.Changeset{}} = Donations.update_donation(donation, @invalid_attrs)
      assert donation == Donations.get_donation!(donation.id)
    end

    test "delete_donation/1 deletes the donation" do
      donation = donation_fixture()
      assert {:ok, %Donation{}} = Donations.delete_donation(donation)
      assert_raise Ecto.NoResultsError, fn -> Donations.get_donation!(donation.id) end
    end

    test "change_donation/1 returns a donation changeset" do
      donation = donation_fixture()
      assert %Ecto.Changeset{} = Donations.change_donation(donation)
    end
  end
end
