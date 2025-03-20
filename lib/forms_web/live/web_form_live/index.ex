defmodule FormsWeb.WebFormLive.Index do
  use FormsWeb, :live_view

  alias Forms.WebForms
  alias Forms.WebForms.WebForm

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :web_forms, WebForms.list_web_forms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Web form")
    |> assign(:web_form, WebForms.get_web_form!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Web form")
    |> assign(:web_form, %WebForm{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Web forms")
    |> assign(:web_form, nil)
  end

  @impl true
  def handle_info({FormsWeb.WebFormLive.FormComponent, {:saved, web_form}}, socket) do
    {:noreply, stream_insert(socket, :web_forms, web_form)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    web_form = WebForms.get_web_form!(id)
    {:ok, _} = WebForms.delete_web_form(web_form)

    {:noreply, stream_delete(socket, :web_forms, web_form)}
  end
end
