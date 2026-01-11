defmodule Pento.Catalog.Product.Query do
  @moduledoc false

  import Ecto.Query

  alias Pento.Catalog.Product
  alias Pento.Survey.Rating.Query, as: RatingQuery

  def base do
    from(p in Product)
  end

  def with_user_ratings(query, scope) do
    ratings_query = RatingQuery.preload_user(scope)

    from(p in query, preload: [ratings: ^ratings_query])
  end
end
