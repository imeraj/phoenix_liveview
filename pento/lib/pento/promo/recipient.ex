defmodule Pento.Promo.Recipient do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :first_name, :string
    field :email, :string
  end

  def changeset(recipient \\ %__MODULE__{}, attrs) do
    recipient
    |> cast(attrs, [:first_name, :email])
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end
