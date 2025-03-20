defmodule Forms.WebFormsTest do
  use Forms.DataCase

  alias Forms.WebForms

  describe "web_forms" do
    alias Forms.WebForms.WebForm

    import Forms.WebFormsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_web_forms/0 returns all web_forms" do
      web_form = web_form_fixture()
      assert WebForms.list_web_forms() == [web_form]
    end

    test "get_web_form!/1 returns the web_form with given id" do
      web_form = web_form_fixture()
      assert WebForms.get_web_form!(web_form.id) == web_form
    end

    test "create_web_form/1 with valid data creates a web_form" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %WebForm{} = web_form} = WebForms.create_web_form(valid_attrs)
      assert web_form.description == "some description"
      assert web_form.title == "some title"
    end

    test "create_web_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WebForms.create_web_form(@invalid_attrs)
    end

    test "update_web_form/2 with valid data updates the web_form" do
      web_form = web_form_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %WebForm{} = web_form} = WebForms.update_web_form(web_form, update_attrs)
      assert web_form.description == "some updated description"
      assert web_form.title == "some updated title"
    end

    test "update_web_form/2 with invalid data returns error changeset" do
      web_form = web_form_fixture()
      assert {:error, %Ecto.Changeset{}} = WebForms.update_web_form(web_form, @invalid_attrs)
      assert web_form == WebForms.get_web_form!(web_form.id)
    end

    test "delete_web_form/1 deletes the web_form" do
      web_form = web_form_fixture()
      assert {:ok, %WebForm{}} = WebForms.delete_web_form(web_form)
      assert_raise Ecto.NoResultsError, fn -> WebForms.get_web_form!(web_form.id) end
    end

    test "change_web_form/1 returns a web_form changeset" do
      web_form = web_form_fixture()
      assert %Ecto.Changeset{} = WebForms.change_web_form(web_form)
    end
  end
end
