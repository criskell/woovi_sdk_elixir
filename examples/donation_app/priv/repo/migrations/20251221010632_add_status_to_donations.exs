defmodule DonationApp.Repo.Migrations.AddStatusToDonations do
  use Ecto.Migration

  def change do
    alter table(:donations) do
      add :status, :string, null: false, default: "pending"
    end
  end
end
