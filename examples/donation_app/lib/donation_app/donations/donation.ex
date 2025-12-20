defmodule DonationApp.Donations.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :name, :string
    field :amount_cents, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:name, :amount_cents])
    |> validate_required([:name, :amount_cents])
    |> validate_number(:amount_cents, greater_than: 0)
  end
end
