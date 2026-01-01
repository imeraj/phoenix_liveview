defmodule Pento.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Survey` context.
  """

  import Pento.AccountsFixtures
  import Pento.CatalogFixtures

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        gender: "male",
        year_of_birth: 1990,
        user_id: user_fixture().id
      })

    {:ok, demographic} = Pento.Survey.create_demographic(scope, attrs)
    demographic
  end

  @doc """
  Generate a rating.
  """
  def rating_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        stars: 4,
        user_id: user_fixture().id,
        product_id: product_fixture(scope).id
      })

    {:ok, rating} = Pento.Survey.create_rating(scope, attrs)
    rating
  end
end
