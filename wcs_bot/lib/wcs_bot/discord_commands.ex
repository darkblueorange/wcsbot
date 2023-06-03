defmodule Wcsbot.Commands do
  @moduledoc """
  Discord Commands Module.

  Will contain every bot command available to user (and admin) in Discord.
  """
  use Alchemy.Cogs
  # alias Alchemy.Embed
  # require Alchemy.Embed
  alias WcsBot.{Teachings, Parties}

  Cogs.def help do
    command_list =
      Cogs.all_commands()
      |> Map.keys()
      |> Enum.reduce("", fn
        elem, "" -> "!#{elem}"
        elem, string_acc -> "#{string_acc}, !#{elem}"
      end)

    "List of available commands: \n#{command_list}"
    |> Cogs.say()
  end

  Cogs.def ping do
    Cogs.say("pong !!")
  end

  Cogs.def echo do
    Cogs.say("please give me a word to echo")
  end

  Cogs.def echo(word) do
    Cogs.say(word)
  end

  @doc """
  Provide the list of dance schools (as an API through Discord bot).

  """
  Cogs.def schools do
    Teachings.list_dance_schools()
    |> Enum.map(fn school ->
      school.name
      |> Cogs.say()
    end)
  end

  Cogs.def schools("help") do
    "!schools [options]\r
    options can be: \r
    -> \"help\" => displays this menu\r
    -> <country> => displays all schools from a country\r
    -> \"with_details\" => displays all schools with all their details \r
    -> \"add_school\" {keyword_list} => add a new school. You need to provide each school attribute to create a new one. \n

    N.B. If no option provided, retrieves all dance schools from all over the world. "
    |> Cogs.say()
  end

  Cogs.def(schools("add_school"),
    do:
      "add_school takes an argument mandatory list: \nadd_school name:{name}, boss:{boss}, country:{country}, city:{city}"
      |> Cogs.say()
  )

  Cogs.def schools("with_details") do
    Teachings.list_dance_schools()
    |> case do
      [] ->
        "No schools registered yet ! Insert one with !schools add_school command. "
        |> Cogs.say()

      school_list ->
        school_list
        |> Enum.map(fn
          school ->
            "Name: #{school.name}, Boss: #{school.boss}, Country: #{school.country}, City: #{school.city}"
            |> Cogs.say()
        end)
    end
  end

  Cogs.def schools(country) do
    country
    |> Teachings.list_dance_schools_by_country()
    |> case do
      [] ->
        "No schools registered for this country yet !"
        |> Cogs.say()

      school_list ->
        school_list
        |> Enum.map(fn
          school ->
            school.name
            |> Cogs.say()
        end)
    end
  end

  Cogs.def schools("add_school", "help") do
    "!schools add_school name: XXX boss: YYY city: AAA country: BBB"
    |> Cogs.say()
  end

  Cogs.def schools("add_school", school) do
    school
    |> String.split(~r/ ?, ?/)
    |> Enum.reduce(%{}, fn token, map_acc ->
      [field, data_value] =
        token
        |> String.split(~r/: ?/)

      map_acc
      |> Map.put(field, data_value)
    end)
    |> Teachings.create_dance_school()
    |> case do
      {:ok, dance_school} ->
        "#{dance_school.name} created !" |> Cogs.say()

      {:error, %Ecto.Changeset{errors: [{attribute, {error_message, _}} | _]}} ->
        "Couldn't insert this Dance School because #{attribute} #{inspect(error_message)}"
        |> Cogs.say()
    end
  end

  Cogs.def(schools("[options]", _), do: nil)
  Cogs.def(schools(_, _), do: "Unrecognized plural command. " |> Cogs.say())

  @doc """
  Provide the list of dance schools (as an API through Discord bot).

  """
  Cogs.def events do
    Parties.list_future_events()
    |> Enum.map(fn event ->
      event.name
      |> Cogs.say()
    end)
  end

  Cogs.def events("help") do
    "!events [options]\r
    options can be: \r
    -> \"help\" => displays this menu\r
    -> <country> => displays all events from a country\r
    -> \"with_details\" => displays all events with all their details \r
    -> \"add_event\" {keyword_list} => add a new event. You need to provide each event attribute to create a new one. \n

    N.B. If no option provided, retrieves all events from all over the world. "
    |> Cogs.say()
  end

  Cogs.def events("with_details") do
    Parties.list_future_events()
    |> case do
      [] ->
        "No events registered yet ! Insert one with !events add_event command. "
        |> Cogs.say()

      event_list ->
        event_list
        |> Enum.map(fn
          event ->
            event.dance_school_id
            |> case do
              nil ->
                "Name: #{event.name}, Beginning: #{event.begin_date}, End: #{event.end_date}, Country: #{event.country}, Lineup: #{event.lineup}, event URL: #{event.url_event}, Address: #{event.address}, WCSDC: #{event.wcsdc}"

              dance_school_id ->
                dance_school = dance_school_id |> Teachings.get_dance_school!()

                "Name: #{event.name}, Beginning: #{event.begin_date}, End: #{event.end_date}, Country: #{event.country}, Lineup: #{event.lineup}, event URL: #{event.url_event}, Address: #{event.address}, WCSDC: #{event.wcsdc}, Dance School : #{dance_school.name}"
            end
            |> Cogs.say()
        end)
    end
  end

  Cogs.def events(country) do
    country
    |> Parties.list_future_events_by_country()
    |> case do
      [] ->
        "No events registered for this country yet !"
        |> Cogs.say()

      event_list ->
        event_list
        |> Enum.map(fn
          event ->
            event.name
            |> Cogs.say()
        end)
    end
  end

  @doc """
  Assign specific parser to each Discord command.

  """
  Cogs.set_parser(:schools, &Wcsbot.Commands.school_parser/1)

  @doc """
  Returns a list of parsed tokens from the user input message.

  ## Examples

      iex> school_parser(args)
      [keyword, message_remainder]

      We keep the message_remainder as a string, to ease following pattern matching.
  """

  def school_parser("add_school"), do: ["add_school"]
  def school_parser("help"), do: ["help"]

  def school_parser("add_school " <> message) do
    ["add_school", message]
  end

  # Garbage collector
  def school_parser(message), do: message |> String.split()
end
