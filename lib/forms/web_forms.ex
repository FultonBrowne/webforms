defmodule Forms.WebForms do
  @moduledoc """
  The WebForms context.
  """

  import Ecto.Query, warn: false
  alias Forms.Repo

  alias Forms.WebForms.WebForm

  @doc """
  Returns the list of web_forms.

  ## Examples

      iex> list_web_forms()
      [%WebForm{}, ...]

  """
  def list_web_forms do
    Repo.all(WebForm)
  end

  @doc """
  Gets a single web_form.

  Raises `Ecto.NoResultsError` if the Web form does not exist.

  ## Examples

      iex> get_web_form!(123)
      %WebForm{}

      iex> get_web_form!(456)
      ** (Ecto.NoResultsError)

  """
  def get_web_form!(id), do: Repo.get!(WebForm, id)

  @doc """
  Creates a web_form.

  ## Examples

      iex> create_web_form(%{field: value})
      {:ok, %WebForm{}}

      iex> create_web_form(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_web_form(attrs \\ %{}) do
    %WebForm{}
    |> WebForm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a web_form.

  ## Examples

      iex> update_web_form(web_form, %{field: new_value})
      {:ok, %WebForm{}}

      iex> update_web_form(web_form, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_web_form(%WebForm{} = web_form, attrs) do
    web_form
    |> WebForm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a web_form.

  ## Examples

      iex> delete_web_form(web_form)
      {:ok, %WebForm{}}

      iex> delete_web_form(web_form)
      {:error, %Ecto.Changeset{}}

  """
  def delete_web_form(%WebForm{} = web_form) do
    Repo.delete(web_form)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking web_form changes.

  ## Examples

      iex> change_web_form(web_form)
      %Ecto.Changeset{data: %WebForm{}}

  """
  def change_web_form(%WebForm{} = web_form, attrs \\ %{}) do
    WebForm.changeset(web_form, attrs)
  end
end
