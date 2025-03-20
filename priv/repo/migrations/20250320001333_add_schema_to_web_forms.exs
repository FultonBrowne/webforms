defmodule Forms.Repo.Migrations.AddSchemaToWebForms do
  use Ecto.Migration

  def change do
    alter table(:web_forms) do
      add :schema, :map, null: false, default: %{}
    end
  end
end
