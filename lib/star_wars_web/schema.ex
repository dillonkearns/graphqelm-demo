defmodule Cat do
  defstruct [:id]
end

defmodule Dog do
  defstruct [:id]
end

defmodule MaybeId do
  defstruct [:id]
end

defmodule ListId do
  defstruct [:id]
end

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

  @desc "A union alternative to the character interface for learning purposes."
  union :character_union do
    types [:human, :droid]
    resolve_type fn
      %Human{}, _ -> :human
      %Droid{}, _ -> :droid
      _, _ -> nil
    end
  end

  object :cat do
    field :id, non_null(:cat_id)
  end

  object :dog do
    field :id, non_null(:dog_id)
  end

  object :maybe_id do
    field :id, :dog_id
  end

  object :list_id do
    field :id, list_of(:dog_id)
  end

  scalar :cat_id do
    serialize(&(&1))
    parse(&(&1))
  end

  scalar :dog_id do
    serialize(&(&1))
    parse(&(&1))
  end

  @desc "A union with fields of the same name but different types. For testing ambiguous union selections, see https://facebook.github.io/graphql/draft/#example-54e3d."
  union :conflicting_types_union do
    types [:dog, :cat, :maybe_id, :list_id]
    resolve_type fn
      %Cat{}, _ -> :cat
      %Dog{}, _ -> :dog
      %MaybeId{}, _ -> :maybe_id
      %ListId{}, _ -> :list_id
      _, _ -> nil
    end
  end



  @desc "A character in the Star Wars Trilogy"
  interface :character do
    @desc "The ID of the character."
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
  object :human, name: "_human" do
    @desc "The ID of the human."
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

  @desc "A mechanical creature in the Star Wars universe."
  object :droid do
    @desc "The ID of the droid."
    field :id, non_null(:id)
    @desc "The name of the droid."
    field :name, non_null(:string)
    @desc "The friends of the droid, or an empty list if they have none."
    field :friends, type: non_null(list_of(non_null(:character))) do
      resolve fn
        human, _, _ ->
          {:ok, human.friends |> Enum.map(&get_character/1)}
      end
    end
    @desc "Which movies they appear in."
    field :appears_in, type: non_null(list_of(non_null(:episode)))
    @desc "The primary function of the droid."
    field :primary_function, :string
    interface :character
  end

  @desc "One of the films in the Star Wars Trilogy"
  enum :episode, name: "_Episode" do
    @desc "Released in 1977."
    value :newhope, name: "_newhope"
    @desc "Released in 1980."
    value :empire, name: "empire"
    @desc "Released in 1983."
    value :jedi, name: "jedi_"
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
  input_object :greeting_options do
    field :prefix, :string
  end

  input_object :greeting do
    field :name, non_null(:string)
    field :language, :language
    field :options, :greeting_options
  end

  enum :language do
    @desc "English"
    value :en
    @desc "Norwegian"
    value :no
    @desc "Spanish"
    value :es
  end

  query do
    field :conflicting_types_union, non_null(:conflicting_types_union) do
      resolve fn
        _, _ ->
          {:ok, %Cat{id: "123"}}
      end
    end

    field :type, non_null(:string) do
      arg :input, :reserved_word
      resolve fn
        _, _ ->
          {:ok, "Hello!"}
      end
    end
    field :greet, non_null(:string) do
      arg :input, non_null(:greeting)
      resolve fn
        %{input: %{language: :no, name: name}}, _ ->
          {:ok, "Hei, #{name}!"}
        %{input: %{language: :es, name: name}}, _ ->
            {:ok, "¡Hola, #{name}!"}
        %{input: %{name: name, options: %{prefix: prefix}}}, _ ->
          {:ok, "#{prefix}Hello, #{name}!"}
        %{input: %{name: name}}, _ ->
          {:ok, "Hello, #{name}!"}
      end
    end

    field :human, type: :human  do
      @desc "ID of the human."
      arg :id, type: non_null(:id)
        resolve fn
          %{id: id}, _ ->
              {:ok, get_human(id)}
          _, _ ->
            {:ok, @luke}
        end
    end

    field :recursive_input, type: :string  do
      @desc "Test recursive input."
      arg :input, type: non_null(:recursive)
        resolve fn
          _, _ ->
            {:ok, "Hello!"}
        end
    end

    field :circular_input, type: :string  do
      @desc "Test circular input."
      arg :input, type: non_null(:circular_one)
        resolve fn
          _, _ ->
            {:ok, "Hello circular!"}
        end
    end


    field :droid, type: :droid, name: "_droid" do
      @desc "ID of the droid."
      arg :_ID, type: non_null(:id)
        resolve fn
          %{id: id}, _ ->
              {:ok, get_droid(id)}
        end
    end

    field :hero_union, :character_union do
      @desc "If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode."
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

    field :hero, non_null(:character) do
      @desc "If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode."
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

  input_object :reserved_word do
    field :type, non_null(:string)
  end

  input_object :recursive do
    field :recursive, :recursive
  end

  input_object :circular_one do
    field :circular_two, :circular_two
  end

  input_object :circular_two do
    field :circular_one, :circular_one
  end

end
