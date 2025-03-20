defmodule FormsWeb.WebFormLive.Show do
  use FormsWeb, :live_view

  alias Forms.WebForms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:web_form, WebForms.get_web_form!(id))}
  end

  defp page_title(:show), do: "Show Web form"
  defp page_title(:edit), do: "Edit Web form"
end
