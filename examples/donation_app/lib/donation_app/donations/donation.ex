defmodule DonationApp.Donations.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :name, :string
    field :amount_cents, :integer
    field :correlation_id, :string
    field :status, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:name, :amount_cents, :correlation_id, :status])
    |> validate_required([:name, :amount_cents])
    |> validate_number(:amount_cents, greater_than: 0)
  end
end
