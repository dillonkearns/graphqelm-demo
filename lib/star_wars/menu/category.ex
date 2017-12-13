defmodule StarWars.Menu.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias StarWars.Menu.Category


  schema "categories" do
    field :description, :string
    field :name, :string, null: false

    has_many :items, StarWars.Menu.Item

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:description, :name])
    |> validate_required([:name])
  end
end
