defmodule FormsWeb.WebFormLive.FormComponent do
  use FormsWeb, :live_component

  alias Forms.WebForms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage web_form records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="web_form-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Web form</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{web_form: web_form} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(WebForms.change_web_form(web_form))
     end)}
  end

  @impl true
  def handle_event("validate", %{"web_form" => web_form_params}, socket) do
    changeset = WebForms.change_web_form(socket.assigns.web_form, web_form_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"web_form" => web_form_params}, socket) do
    save_web_form(socket, socket.assigns.action, web_form_params)
  end

  defp save_web_form(socket, :edit, web_form_params) do
    case WebForms.update_web_form(socket.assigns.web_form, web_form_params) do
      {:ok, web_form} ->
        notify_parent({:saved, web_form})

        {:noreply,
         socket
         |> put_flash(:info, "Web form updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_web_form(socket, :new, web_form_params) do
    case WebForms.create_web_form(web_form_params) do
      {:ok, web_form} ->
        notify_parent({:saved, web_form})

        {:noreply,
         socket
         |> put_flash(:info, "Web form created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
