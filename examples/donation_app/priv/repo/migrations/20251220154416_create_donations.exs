defmodule DonationApp.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :name, :string
      add :amount_cents, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
