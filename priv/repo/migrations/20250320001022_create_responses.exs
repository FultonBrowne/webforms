defmodule Forms.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :data, :map
      add :submitted_at, :utc_datetime
      add :form_id, references(:web_forms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:responses, [:form_id])
  end
end
