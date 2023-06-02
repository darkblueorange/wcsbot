defmodule Wcsbot.Commands do
  use Alchemy.Cogs
  # alias Alchemy.Embed
  # require Alchemy.Embed
  alias WcsBot.Teachings

  Cogs.def ping do
    IO.inspect("receiving some ping")
    Cogs.say "pong !!"
  end

  Cogs.def echo do
    Cogs.say "please give me a word to echo"
  end

  Cogs.def echo(word) do
    Cogs.say word
  end

  Cogs.def schools do
    Teachings.list_dance_schools()
    |> IO.inspect(label: "dance school list :: ")
    |> Enum.map(fn school ->
      school.name
      |> Cogs.say
    end)
  end

  Cogs.def schools(country) do
    country
    |> Teachings.list_dance_schools()
    |> IO.inspect(label: "dance school list from this country #{country}:: ")
    |> case do
      [] ->
        "No schools registered for this country yet ! "
        |> Cogs.say
        school_list ->
          school_list|> Enum.map(fn
          school ->
            school.name
            |> Cogs.say

        end)
    end
  end

end
