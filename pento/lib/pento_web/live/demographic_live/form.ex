defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> clear_form()
    }
  end

  defp assign_demographic(%{assigns: %{current_scope: current_scope}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: current_scope.user.id})
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp clear_form(%{assigns: %{demographic: demographic, current_scope: current_scope}} = socket) do
    assign_form(socket, Survey.change_demographic(current_scope, demographic))
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    params = params_with_user_id(demographic_params, socket)
    {:noreply, save_demographic(socket, params)}
  end

  def handle_event("validate", %{"demographic" => demographic_params}, socket) do
    params = params_with_user_id(demographic_params, socket)
    {:noreply, validate_demographic(socket, params)}
  end

  defp save_demographic(%{assigns: %{current_scope: current_scope}} = socket, demographic_params) do
    case Survey.create_demographic(current_scope, demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end

  defp validate_demographic(
         %{assigns: %{current_scope: current_scope, demographic: demographic}} = socket,
         demographic_params
       ) do
    changeset =
      current_scope
      |> Survey.change_demographic(demographic, demographic_params)
      |> Map.put(:action, :validate)

    assign_form(socket, changeset)
  end

  def params_with_user_id(params, %{assigns: %{current_scope: current_scope}}) do
    params
    |> Map.put("user_id", current_scope.user.id)
  end
end
