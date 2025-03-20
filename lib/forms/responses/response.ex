defmodule Forms.Responses.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :data, :map
    field :submitted_at, :utc_datetime
    field :form_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(response, attrs) do
    response
    |> cast(attrs, [:data, :submitted_at])
    |> validate_required([:submitted_at])
  end
end
