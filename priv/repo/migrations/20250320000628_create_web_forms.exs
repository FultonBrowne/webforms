defmodule Forms.Repo.Migrations.CreateWebForms do
  use Ecto.Migration

  def change do
    create table(:web_forms) do
      add :title, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:web_forms, [:user_id])
  end
end
