defmodule Forms.WebForms.WebForm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "web_forms" do
    field :description, :string
    field :title, :string
    field :user_id, :id
    field :schema, :map, default: %{}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(web_form, attrs) do
    web_form
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
