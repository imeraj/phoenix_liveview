defmodule PentoWeb.SurveyLive.Index do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Survey
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.DemographicLive

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <Component.hero content="Survey">
        Please fill out our survey
      </Component.hero>
      <div class="container mx-auto px-4 py-8 max-w-4xl">
        <%= if @demographic do %>
          <DemographicLive.Show.details demographic={@demographic} />
        <% else %>
          <h3>Demographic form coming soon...</h3>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_demographic()
      |> assign_products()

    {:ok, socket}
  end

  defp assign_demographic(socket) do
    demographic = Survey.get_demographic_by_user(socket.assigns.current_scope)
    assign(socket, :demographic, demographic)
  end

  defp assign_products(socket) do
    products = Catalog.list_products(socket.assigns.current_scope)
    assign(socket, :products, products)
  end
end
