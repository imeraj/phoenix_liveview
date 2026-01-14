defmodule PentoWeb.DemographicLive.Show do
  @moduledoc false
  use Phoenix.Component

  alias Pento.Survey.Demographic
  alias PentoWeb.CoreComponents

  attr(:demographic, Demographic, required: true)

  def details(assigns) do
    ~H"""
    <div>
      <h2 class="font-medium text-2xl">
        Demographics {Phoenix.HTML.raw("&#x2713;")}
      </h2>​
     <CoreComponents.table id="demographics" rows={[@demographic]}>
      <:col :let={demographic} label="Gender">
        <%= demographic.gender %>
      </:col>
      <:col :let={demographic} label="Year of Birth">
        <%= demographic.year_of_birth %>
      </:col>
     </CoreComponents.table>
    </div>
    """
  end
end
