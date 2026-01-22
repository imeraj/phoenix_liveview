defmodule PentoWeb.Admin.DashboardLive.Index do
  @moduledoc false

  use PentoWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-6">
      <h1 class="text-3xl font-bold mb-6">Admin Dashboard</h1>
      <.live_component
        module={PentoWeb.Admin.DashboardLive.SurveyResults}
        id={@survey_results_component_id} />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:survey_results_component_id, "survey-results")}
  end
end
