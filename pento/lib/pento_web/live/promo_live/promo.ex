defmodule PentoWeb.PromoLive.Promo do
  @moduledoc false

  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _sessions, socket) do
    {:ok, socket |> assign_recipient() |> clear_form()}
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient |> Promo.change_recipient(recipient_params) |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event(
        "save",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    case Promo.send_promo(
           recipient,
           recipient_params
         ) do
      {:ok, _receipient} ->
        {:noreply,
         socket
         |> put_flash(:info, "Promo sent successfully!")
         |> push_navigate(to: ~p"/guess")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_recipient(socket) do
    assign(socket, :recipient, %Recipient{})
  end

  defp clear_form(socket) do
    changeset = socket.assigns.recipient |> Promo.change_recipient()

    assign_form(socket, changeset)
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
