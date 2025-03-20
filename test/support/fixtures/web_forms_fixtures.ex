defmodule Forms.WebFormsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forms.WebForms` context.
  """

  @doc """
  Generate a web_form.
  """
  def web_form_fixture(attrs \\ %{}) do
    {:ok, web_form} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Forms.WebForms.create_web_form()

    web_form
  end
end
