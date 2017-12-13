defmodule StarWars.Menu.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias StarWars.Menu.Item


  schema "items" do
    field :added_on, :date
    field :description, :string
    field :name, :string
    field :price, :decimal

    belongs_to :category, StarWars.Menu.Category

    many_to_many :tags, StarWars.Menu.ItemTag,
      join_through: "items_taggings"

    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :added_on])
    |> validate_required([:name, :price])
    |> foreign_key_constraint(:category)
  end
end
