defmodule FormsWeb.WebFormLiveTest do
  use FormsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Forms.WebFormsFixtures

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  defp create_web_form(_) do
    web_form = web_form_fixture()
    %{web_form: web_form}
  end

  describe "Index" do
    setup [:create_web_form]

    test "lists all web_forms", %{conn: conn, web_form: web_form} do
      {:ok, _index_live, html} = live(conn, ~p"/web_forms")

      assert html =~ "Listing Web forms"
      assert html =~ web_form.description
    end

    test "saves new web_form", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/web_forms")

      assert index_live |> element("a", "New Web form") |> render_click() =~
               "New Web form"

      assert_patch(index_live, ~p"/web_forms/new")

      assert index_live
             |> form("#web_form-form", web_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#web_form-form", web_form: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/web_forms")

      html = render(index_live)
      assert html =~ "Web form created successfully"
      assert html =~ "some description"
    end

    test "updates web_form in listing", %{conn: conn, web_form: web_form} do
      {:ok, index_live, _html} = live(conn, ~p"/web_forms")

      assert index_live |> element("#web_forms-#{web_form.id} a", "Edit") |> render_click() =~
               "Edit Web form"

      assert_patch(index_live, ~p"/web_forms/#{web_form}/edit")

      assert index_live
             |> form("#web_form-form", web_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#web_form-form", web_form: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/web_forms")

      html = render(index_live)
      assert html =~ "Web form updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes web_form in listing", %{conn: conn, web_form: web_form} do
      {:ok, index_live, _html} = live(conn, ~p"/web_forms")

      assert index_live |> element("#web_forms-#{web_form.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#web_forms-#{web_form.id}")
    end
  end

  describe "Show" do
    setup [:create_web_form]

    test "displays web_form", %{conn: conn, web_form: web_form} do
      {:ok, _show_live, html} = live(conn, ~p"/web_forms/#{web_form}")

      assert html =~ "Show Web form"
      assert html =~ web_form.description
    end

    test "updates web_form within modal", %{conn: conn, web_form: web_form} do
      {:ok, show_live, _html} = live(conn, ~p"/web_forms/#{web_form}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Web form"

      assert_patch(show_live, ~p"/web_forms/#{web_form}/show/edit")

      assert show_live
             |> form("#web_form-form", web_form: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#web_form-form", web_form: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/web_forms/#{web_form}")

      html = render(show_live)
      assert html =~ "Web form updated successfully"
      assert html =~ "some updated description"
    end
  end
end
