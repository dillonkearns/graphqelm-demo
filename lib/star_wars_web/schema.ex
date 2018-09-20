defmodule Character do
  defstruct [:id, :name, :avatar_url, :friends, :home_planet]
end

defmodule StarWarsWeb.Schema do
  @luke %Character{
    id: "1000",
    name: "Luke Skywalker",
    avatar_url:
      "http://www.diszine.com/wp-content/uploads/2013/02/luke-skywalker-mark-hamill.jpg",
    friends: ["1002", "1003", "2000", "2001"],
    home_planet: "Tatooine"
  }
  @vader %Character{
    id: "1001",
    name: "Darth Vader",
    avatar_url: "https://avatarfiles.alphacoders.com/468/46847.jpg",
    friends: ["1004"],
    home_planet: "Tatooine"
  }

  @han %Character{
    id: "1002",
    name: "Han Solo",
    avatar_url:
      "http://comic-cons.xyz/wp-content/uploads/Star-Wars-avatars-Movie-Han-Solo-Harrison-Ford.jpg",
    friends: ["1000", "1003", "2001"]
  }

  @leia %Character{
    id: "1003",
    name: "Leia Organa",
    avatar_url: "https://78.media.tumblr.com/avatar_60b17e7d34ad_128.pnj",
    friends: ["1000", "1002", "2000", "2001"],
    home_planet: "Alderaan"
  }

  @tarkin %Character{
    id: "1004",
    name: "Wilhuff Tarkin",
    avatar_url:
      "https://timedotcom.files.wordpress.com/2016/12/grand-moff-tarkin1.jpg?quality=30",
    friends: ["1001"]
  }

  @threepio %Character{
    id: "2000",
    name: "C-3PO",
    avatar_url: "https://pbs.twimg.com/profile_images/22039052/03.01.c3po_400x400.jpg",
    friends: ["1000", "1002", "1003", "2001"]
  }

  @artoo %Character{
    id: "2001",
    name: "R2-D2",
    avatar_url: "https://giffiles.alphacoders.com/884/thumb-8849.jpg",
    friends: ["1000", "1002", "1003"]
  }

  use Absinthe.Schema

  @desc "A character in the Star Wars universe."
  object :character do
    @desc "The ID of the character."
    field(:id, non_null(:id))
    @desc "The name of the character."
    field(:name, non_null(:string))
    # @desc "Url to a profile picture for the character."
    # field(:avatar_url, type: non_null(:string))
    @desc "The friends of the character, or an empty list if they have none."
    field :friends, type: non_null(list_of(non_null(:character))) do
      resolve(fn character, _, _ ->
        {:ok, character.friends |> Enum.map(&get_character/1)}
      end)
    end

    @desc "The home planet of the character, or null if unknown."
    field(:home_planet, :string)
  end

  defp get_character(id) do
    %{
      "1000" => @luke,
      "1001" => @vader,
      "1002" => @han,
      "1003" => @leia,
      "1004" => @tarkin,
      "2000" => @threepio,
      "2001" => @artoo
    }[id]
  end

  query do
    # @desc "Get all known characters."
    # field :all, type: non_null(list_of(non_null(:character))) do
    #   resolve(fn _, _, _ ->
    #     {:ok, [@luke, @leia, @han, @vader, @threepio, @artoo]}
    #   end)
    # end

    field :character, :character do
      @desc "ID of the character."
      arg(:id, type: non_null(:id))

      resolve(fn %{id: id}, _ ->
        {:ok, get_character(id)}
      end)
    end
  end
end
