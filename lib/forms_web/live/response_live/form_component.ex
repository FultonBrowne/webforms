defmodule FormsWeb.ResponseLive.FormComponent do
  use FormsWeb, :live_component

  alias Forms.Responses

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage response records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="response-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:submitted_at]} type="datetime-local" label="Submitted at" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Response</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{response: response} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Responses.change_response(response))
     end)}
  end

  @impl true
  def handle_event("validate", %{"response" => response_params}, socket) do
    changeset = Responses.change_response(socket.assigns.response, response_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"response" => response_params}, socket) do
    save_response(socket, socket.assigns.action, response_params)
  end

  defp save_response(socket, :edit, response_params) do
    case Responses.update_response(socket.assigns.response, response_params) do
      {:ok, response} ->
        notify_parent({:saved, response})

        {:noreply,
         socket
         |> put_flash(:info, "Response updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_response(socket, :new, response_params) do
    case Responses.create_response(response_params) do
      {:ok, response} ->
        notify_parent({:saved, response})

        {:noreply,
         socket
         |> put_flash(:info, "Response created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
