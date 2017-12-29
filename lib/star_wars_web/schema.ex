defmodule Human do
  defstruct [:id, :name, :friends, :appears_in, :home_planet]

end
defmodule Droid do
  defstruct [:id, :name, :friends, :appears_in, :primary_function]

end
defmodule StarWarsWeb.Schema do
  @luke %Human{
    id: "1000",
    name: "Luke Skywalker",
    friends: ["1002", "1003", "2000", "2001"],
    appears_in: [4, 5, 6],
    home_planet: "Tatooine"
  }
  @vader %Human{
    id: "1001",
    name: "Darth Vader",
    friends: ["1004"],
    appears_in: [4, 5, 6],
    home_planet: "Tatooine",
  }

   @han %Human{
    id: "1002",
    name: "Han Solo",
    friends: ["1000", "1003", "2001"],
    appears_in: [4, 5, 6]
  }

   @leia %Human{
    id: "1003",
    name: "Leia Organa",
    friends: ["1000", "1002", "2000", "2001"],
    appears_in: [4, 5, 6],
    home_planet: "Alderaan"
  }

   @tarkin %Human{
    id: "1004",
    name: "Wilhuff Tarkin",
    friends: ["1001"],
    appears_in: [4]
  }

  @threepio %Droid{
    id: "2000",
    name: "C-3PO",
    friends: ["1000", "1002", "1003", "2001"],
    appears_in: [4, 5, 6],
    primary_function: "Protocol",
  }

  @artoo %Droid{
    id: "2001",
    name: "R2-D2",
    friends: ["1000", "1002", "1003"],
    appears_in: [4, 5, 6],
    primary_function: "Astromech",
  }

  use Absinthe.Schema

  @desc "A character in the Star Wars Trilogy"
  interface :character do
    @desc "The id of the character."
    field :id, non_null(:id)
    @desc "The name of the character."
    field :name, non_null(:string)
    @desc  "The friends of the character, or an empty list if they have none."
    field :friends, type: non_null(list_of(non_null(:character))) do
      resolve fn
        character, _, _ ->
          {:ok, character.friends |> Enum.map(&get_character/1)}
      end
    end
    @desc "Which movies they appear in."
    field :appears_in, type: non_null(list_of(non_null(:episode)))
    resolve_type fn
      %Human{}, _ -> :human
      %Droid{}, _ -> :droid
      _, _ -> nil
    end
  end

  @desc "A humanoid creature in the Star Wars universe."
  object :human do
    @desc "The id of the human."
    field :id, non_null(:id)
    @desc "The name of the human."
    field :name, non_null(:string)
    @desc "The friends of the human, or an empty list if they have none."
    field :friends, type: non_null(list_of(non_null(:character))) do
      resolve fn
        human, _, _ ->
          {:ok, human.friends |> Enum.map(&get_character/1)}
      end
    end
    @desc "Which movies they appear in."
    field :appears_in, type: non_null(list_of(non_null(:episode))) do
      resolve fn
        human, _, _ ->
          {:ok, human.appears_in |> Enum.map(&to_episode/1)}
      end
    end
    @desc "The home planet of the human, or null if unknown."
    field :home_planet, :string
    interface :character
  end

  object :droid do
    field :id, non_null(:id)
    field :name, non_null(:string)
        field :friends, type: non_null(list_of(non_null(:character))) do
      resolve fn
        human, _, _ ->
          {:ok, human.friends |> Enum.map(&get_character/1)}
      end
    end
    field :appears_in, type: non_null(list_of(non_null(:episode)))
    field :primary_function, non_null(:string)
    interface :character
  end

  @desc "One of the films in the Star Wars Trilogy"
  enum :episode do
    @desc "Released in 1977."
    value :newhope
    @desc "Released in 1980."
    value :empire
    @desc "Released in 1983."
    value :jedi
  end

  defp to_episode(n) do
    case n do
      4 ->
        :newhope
      5 ->
        :empire
      6 ->
        :jedi
    end
  end

  defp get_character(id) do
    get_human(id) || get_droid(id)
  end

  defp get_human(id) do
    %{
      "1000" => @luke,
      "1001" => @vader,
      "1002" => @han,
      "1003" => @leia,
      "1004" => @tarkin
    }[id]
  end
  defp get_droid(id) do
    %{
      "2000" => @threepio,
      "2001" => @artoo
    }[id]
  end

  query do
    field :human, :human do
      arg :id, type: non_null(:id)
        resolve fn
          %{id: id}, _ ->
              {:ok, get_human(id)}
          _, _ ->
            {:ok, @luke}
        end
    end

    field :droid, :droid do
      arg :id, type: non_null(:id)
        resolve fn
          %{id: id}, _ ->
              {:ok, get_droid(id)}
        end
    end

    field :hero, :character do
      arg :episode, type: :episode
      resolve fn
        %{episode: episode}, _ ->
          case episode do
            :empire ->
              {:ok, @luke}
            _ ->
              {:ok, @artoo}
          end
        _, _ ->
          {:ok, @luke}
      end

    end

  end

end
