use Timex

defmodule StarWarsWeb.Schema do
  @luke %Human{
    id: "1000",
    name: "Luke Skywalker",
    avatar_url: "http://www.diszine.com/wp-content/uploads/2013/02/luke-skywalker-mark-hamill.jpg",
    friends: ["1002", "1003", "2000", "2001"],
    appears_in: [4, 5, 6],
    home_planet: "Tatooine"
  }
  @vader %Human{
    id: "1001",
    name: "Darth Vader",
    avatar_url: "https://avatarfiles.alphacoders.com/468/46847.jpg",
    friends: ["1004"],
    appears_in: [4, 5, 6],
    home_planet: "Tatooine",
  }

   @han %Human{
    id: "1002",
    name: "Han Solo",
    avatar_url: "http://comic-cons.xyz/wp-content/uploads/Star-Wars-avatars-Movie-Han-Solo-Harrison-Ford.jpg",
    friends: ["1000", "1003", "2001"],
    appears_in: [4, 5, 6]
  }

   @leia %Human{
    id: "1003",
    name: "Leia Organa",
    avatar_url: "https://78.media.tumblr.com/avatar_60b17e7d34ad_128.pnj",
    friends: ["1000", "1002", "2000", "2001"],
    appears_in: [4, 5, 6],
    home_planet: "Alderaan"
  }

   @tarkin %Human{
    id: "1004",
    name: "Wilhuff Tarkin",
    avatar_url: "https://timedotcom.files.wordpress.com/2016/12/grand-moff-tarkin1.jpg?quality=30",
    friends: ["1001"],
    appears_in: [4]
  }

  @threepio %Droid{
    id: "2000",
    name: "C-3PO",
    avatar_url: "https://pbs.twimg.com/profile_images/22039052/03.01.c3po_400x400.jpg",
    friends: ["1000", "1002", "1003", "2001"],
    appears_in: [4, 5, 6],
    primary_function: "Protocol",
  }

  @artoo %Droid{
    id: "2001",
    name: "R2-D2",
    avatar_url: "https://giffiles.alphacoders.com/884/thumb-8849.jpg",
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

  @desc "Represents posix milliseconds (milliseconds since Jan. 1, 1970)."
  scalar :posix_time do
    serialize &DateTime.to_unix(&1, :millisecond)
    parse &DateTime.from_unix(&1, :millisecond)
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
    @desc "Url to a profile picture for the character."
    field :avatar_url, type: non_null(:string)
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
    @desc "The ID of the human."
    field :id, non_null(:id)
    @desc "The name of the human."
    field :name, non_null(:string)
    @desc "Url to a profile picture for the character."
    field :avatar_url, type: non_null(:string)
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
    @desc "Url to a profile picture for the character."
    field :avatar_url, type: non_null(:string)
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
  enum :episode do
    @desc "Released in 1977."
    value :newhope
    @desc "Released in 1980."
    value :empire
    @desc "Released in 1983."
    value :jedi
  end

  @desc "Phrases for StarChat"
  enum :phrase do
    @desc "Originally said by Leia."
    value :help
    @desc "Originally said by Vader."
    value :faith
    @desc "Originally said by Obi-Wan."
    value :the_force
    @desc "Originally said by Yoda."
    value :try
    @desc "Originally said by Vader."
    value :father
    @desc "Originally said by Obi-Wan"
    value :droids
    @desc "Originally said by Han Solo"
    value :bad_feeling
    @desc "Originally said by Admiral Ackbar"
    value :trap
    @desc "Originally said by Vader"
    value :traitor
  end

  object :chat_message do
    field :phrase, non_null(:phrase)
    field :character, :character
  end

  mutation do
    field :increment, non_null(:integer) do
      resolve fn _, _ , _ ->
        {:ok, StarWars.CounterAgent.increment}
      end

    end
    field :send_message, :chat_message do
      arg :phrase, non_null(:phrase)
      arg :character_id, non_null(:id)

      resolve fn _, %{phrase: phrase, character_id: character_id} , _ ->
        chat_message = %{phrase: phrase, character: get_character(character_id)}
        Absinthe.Subscription.publish(StarWarsWeb.Endpoint, chat_message,
          new_message: "*")
        {:ok, chat_message}
      end

    end

  end

  subscription do
    field :new_message, non_null(:chat_message) do

      config fn _args, _info ->
        {:ok, topic: "*"}
      end
    end
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

  enum :language do
    @desc "English"
    value :en
    @desc "Norwegian"
    value :no
    @desc "Spanish"
    value :es
  end

  input_object :greeting_options do
    field :prefix, :string
  end

  input_object :greeting do
    field :name, non_null(:string)
    field :language, :language
    field :options, :greeting_options
  end

  query do
      @desc "Getting this field will result in an error."
      field :forced_error, type: :string do
      resolve fn
        _, _, _ ->
          {:error, "Artificial error..."}
        end
      end

      field :now, type: non_null(:posix_time) do
        resolve fn
          _, _, _ ->
            {:ok, DateTime.utc_now }
          end
      end


    field :hello, non_null(:string) do
      resolve fn
        _, _, _ ->
          {:ok, "Hello from GraphQL!"}
        end
    end

    field :today, non_null(:string) do
      resolve fn
        _, _, _ ->
          {:ok, Timex.local |> Timex.format!("{WDfull}, {Mfull} {D}") }
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

    field :human, :human do
      @desc "ID of the human."
      arg :id, type: non_null(:id)
        resolve fn
          %{id: id}, _ ->
              {:ok, get_human(id)}
          _, _ ->
            {:ok, @luke}
        end
    end

    field :droid, :droid do
      @desc "ID of the droid."
      arg :id, type: non_null(:id)
        resolve fn
          %{id: id}, _ ->
              {:ok, get_droid(id)}
        end
    end

    field :hero_union, non_null(:character_union) do
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

end
