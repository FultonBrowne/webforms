defmodule FormsWeb.WebFormLive.FormComponent do
  use FormsWeb, :live_component

  alias Forms.WebForms

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage web form records and define its schema.</:subtitle>
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

        <div>
          <h3>Schema Fields</h3>
          <ul>
            <%= for field <- @schema do %>
              <li>
                {field.id}.
                <input
                  type="text"
                  name="field_name"
                  value={field.name}
                  placeholder="Field name"
                  phx-blur="update_field_name"
                  phx-value-id={field.id}
                  phx-target={@myself}
                />

                <select
                  name="field_type"
                  phx-blur="update_field_type"
                  phx-value-id={field.id}
                  phx-target={@myself}
                >
                  <option value="string" selected={field.type == "string"}>String</option>
                  <option value="integer" selected={field.type == "integer"}>Integer</option>
                  <option value="boolean" selected={field.type == "boolean"}>Boolean</option>
                  <option value="datetime" selected={field.type == "datetime"}>Datetime</option>
                </select>

                <button
                  type="button"
                  phx-click="remove_field"
                  phx-value-id={field.id}
                  phx-target={@myself}
                >
                  Remove
                </button>
              </li>
            <% end %>
          </ul>
        </div>

        <div>
          <.button type="button" phx-click="add_field" phx-target={@myself}>Add Field</.button>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Web Form</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{web_form: web_form} = assigns, socket) do
    schema_list =
      case web_form.schema do
        %{} -> Map.values(web_form.schema)
        nil -> []
        list when is_list(list) -> list
      end

    max_id = schema_list |> Enum.map(& &1.id) |> Enum.max(fn -> 0 end)

    changeset = WebForms.change_web_form(web_form)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))
     |> assign(:schema, schema_list)
     |> assign(:next_field_id, max_id + 1)}
  end

  @impl true
  def handle_event("add_field", _params, socket) do
    new_field = %{
      id: socket.assigns.next_field_id,
      name: "",
      type: "string"
    }

    {:noreply,
     socket
     |> assign(:schema, [new_field | socket.assigns.schema])
     |> assign(:next_field_id, socket.assigns.next_field_id + 1)}
  end

  @impl true
  def handle_event("remove_field", %{"id" => id}, socket) do
    updated_schema =
      socket.assigns.schema
      |> Enum.reject(&(&1.id == String.to_integer(id)))

    {:noreply, assign(socket, schema: updated_schema)}
  end

  @impl true
  def handle_event("update_field_name", %{"id" => id, "value" => name}, socket) do
    updated_schema =
      Enum.map(socket.assigns.schema, fn field ->
        if field.id == String.to_integer(id) do
          %{field | name: name}
        else
          field
        end
      end)

    {:noreply, assign(socket, schema: updated_schema)}
  end

  @impl true
  def handle_event("update_field_type", %{"id" => id, "value" => type}, socket) do
    updated_schema =
      Enum.map(socket.assigns.schema, fn field ->
        if field.id == String.to_integer(id) do
          %{field | type: type}
        else
          field
        end
      end)

    {:noreply, assign(socket, schema: updated_schema)}
  end

  @impl true
  def handle_event("validate", %{"web_form" => web_form_params}, socket) do
    changeset =
      socket.assigns.web_form
      |> WebForms.change_web_form(web_form_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"web_form" => web_form_params}, socket) do
    updated_params =
      web_form_params
      |> Map.put("schema", socket.assigns.schema)

    save_web_form(socket, socket.assigns.action, updated_params)
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
