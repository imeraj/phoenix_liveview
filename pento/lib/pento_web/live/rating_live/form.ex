defmodule PentoWeb.RatingLive.Form do
  @moduledoc false
  use PentoWeb, :live_component

  alias PentoWeb.RatingLive

  alias Pento.Survey
  alias Pento.Survey.Rating

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign_rating() |> assign_form()}
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    save_rating(socket, rating_params)
  end

  defp save_rating(socket, rating_params) do
    case Survey.create_rating(socket.assigns.current_scope, rating_params) do
      {:ok, rating} ->
        product = %{socket.assigns.product | ratings: [rating]}
        send(self(), {:created_rating, product, socket.assigns.index})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_rating(socket) do
    rating = %Rating{
      user_id: socket.assigns.current_scope.user.id,
      product_id: socket.assigns.product.id
    }

    assign(socket, :rating, rating)
  end

  defp assign_form(socket, changeset \\ nil) do
    form =
      case changeset do
        nil ->
          current_scope = socket.assigns.current_scope
          rating = socket.assigns.rating
          to_form(Survey.change_rating(current_scope, rating))

        changeset ->
          to_form(changeset)
      end

    assign(socket, :form, form)
  end
end
