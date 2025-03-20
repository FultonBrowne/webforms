defmodule Forms.ResponsesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forms.Responses` context.
  """

  @doc """
  Generate a response.
  """
  def response_fixture(attrs \\ %{}) do
    {:ok, response} =
      attrs
      |> Enum.into(%{
        data: %{},
        submitted_at: ~U[2025-03-19 00:10:00Z]
      })
      |> Forms.Responses.create_response()

    response
  end
end
