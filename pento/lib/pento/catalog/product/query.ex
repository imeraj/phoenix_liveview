defmodule Pento.Catalog.Product.Query do
  @moduledoc false

  import Ecto.Query

  alias Pento.Accounts.User
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating
  alias Pento.Survey.Demographic
  alias Pento.Survey.Rating.Query, as: RatingQuery

  def base do
    from(p in Product)
  end

  def join_ratings(query) do
    join(query, :inner, [p], r in Rating, on: r.product_id == p.id)
  end

  def join_users(query) do
    join(query, :left, [p, r], u in User, on: r.user_id == u.id)
  end

  def join_demographics(query) do
    join(query, :left, [p, r, u], d in Demographic, on: d.user_id == u.id)
  end

  def filter_by_age_group(query, filter) do
    apply_age_group_filter(query, filter)
  end

  defp apply_age_group_filter(query, "18 and under") do
    birth_year = DateTime.utc_now().year - 18

    where(query, [p, r, u, d], d.year_of_birth >= ^birth_year)
  end

  defp apply_age_group_filter(query, "18 to 25") do
    birth_year_max = DateTime.utc_now().year - 18
    birth_year_min = DateTime.utc_now().year - 25

    where(
      query,
      [p, r, u, d],
      d.year_of_birth >= ^birth_year_min and d.year_of_birth <= ^birth_year_max
    )
  end

  defp apply_age_group_filter(query, "25 to 35") do
    birth_year_max = DateTime.utc_now().year - 25
    birth_year_min = DateTime.utc_now().year - 35

    where(
      query,
      [p, r, u, d],
      d.year_of_birth >= ^birth_year_min and d.year_of_birth <= ^birth_year_max
    )
  end

  defp apply_age_group_filter(query, "35 and up") do
    birth_year = DateTime.utc_now().year - 35

    where(query, [p, r, u, d], d.year_of_birth <= ^birth_year)
  end

  defp apply_age_group_filter(query, _filter), do: query

  def with_user_ratings(query, scope) do
    ratings_query = RatingQuery.preload_user(scope)

    from(p in query, preload: [ratings: ^ratings_query])
  end

  def with_average_ratings(query) do
    query
    |> join_ratings()
    |> average_ratings()
  end

  defp average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, fragment("?::float", avg(r.stars))})
    |> order_by([p, r], [{:asc, p.name}])
  end
end
