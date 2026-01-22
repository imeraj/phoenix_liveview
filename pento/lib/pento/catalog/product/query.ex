defmodule Pento.Catalog.Product.Query do
  @moduledoc false

  import Ecto.Query

  alias Pento.Catalog.Product
  alias Pento.Survey.Rating
  alias Pento.Survey.Rating.Query, as: RatingQuery

  def base do
    from(p in Product)
  end

  def with_user_ratings(query, scope) do
    ratings_query = RatingQuery.preload_user(scope)

    from(p in query, preload: [ratings: ^ratings_query])
  end

  def with_average_ratings(query) do
    query
    |> join_ratings()
    |> average_ratings()
  end

  defp join_ratings(query) do
    join(query, :inner, [p], r in Rating, on: r.product_id == p.id)
  end

  defp average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, fragment("?::float", avg(r.stars))})
    |> order_by([p, r], [{:asc, p.name}])
  end
end
