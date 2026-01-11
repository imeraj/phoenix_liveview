defmodule Pento.Survey.Rating.Query do
  @moduledoc false

  import Ecto.Query
  alias Pento.Survey.Rating

  def base do
    from(r in Rating)
  end

  def preload_user(scope) do
    for_user(base(), scope)
  end

  def for_user(query, %{user: user}) do
    where(
      query,
      [r],
      r.user_id == ^user.id
    )
  end
end
