defmodule DonationApp.Repo.Migrations.AddCorrelationIdToDonations do
  use Ecto.Migration

  def change do
    alter table(:donations) do
      add :correlation_id, :string
    end

    create unique_index(:donations, [:correlation_id])
  end
end
