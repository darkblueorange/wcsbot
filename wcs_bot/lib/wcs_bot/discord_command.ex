defmodule WcsBot.Command do
  @moduledoc """
  Discord Commands Module.

  Will contain every bot command available to user (and admin) in Discord.
  """
  alias WcsBot.Command.Docs
  alias Nostrum.Api

  @prefix "!"
  # Bot ID is used to ignore our own message
  @bot_id 1_114_822_453_336_756_276

  def handle(%{author: %{id: @bot_id}}), do: :noop

  def handle(msg = %{content: @prefix <> content}) do
    content
    |> String.trim()
    |> String.split(" ", parts: 2)
    |> execute(msg)
  end

  def handle(_), do: :noop

  defp execute(["ping"], msg) do
    create_message(msg.channel_id, "pong")
  end

  defp execute(["echo"], msg) do
    create_message(msg.channel_id, "Give me something to echo")
  end

  defp execute(["echo", to_echo], msg) do
    create_message(msg.channel_id, to_echo)
  end

  defp execute(["schools" | msg_content], msg_struct) do
    Wcsbot.CommandsSchools.execute(
      msg_struct.channel_id,
      msg_content |> IO.inspect(label: "msg content to school :: ")
    )

    # Wcsbot.CommandsSchools.execute(msg_struct.channel_id, msg_content)
  end

  defp execute(["docs", module_name], msg) do
    doc = Docs.get_docs(module_name)
    create_message(msg.channel_id, doc)
  end

  defp execute(_, msg) do
    create_message(msg.channel_id, "This command doesnt exist, sorry")
  end

  defp create_message(channel_id, message) do
    Api.create_message(channel_id, message)
  end
end

defmodule Wcsbot.CommandsSchools do
  @moduledoc """
  Provide the list of dance schools (as an API through Discord bot).

  """
  alias WcsBot.Teachings
  alias Nostrum.Api

  defp create_message(message, channel_id) do
    Api.create_message(channel_id, message)
  end

  def execute(channel_id, []) do
    Teachings.list_dance_schools()
    |> Enum.map(fn school ->
      school.name
      |> create_message(channel_id)
    end)
  end

  def execute(channel_id, ["help"]) do
    "!schools [options]\r
    options can be: \r
    -> \"help\" => displays this menu\r
    -> <country> => displays all schools from a country\r
    -> \"with_details\" => displays all schools with all their details \r
    -> \"add_school\" {keyword_list} => add a new school. You need to provide each school attribute to create a new one. \n

    N.B. If no option provided, retrieves all dance schools from all over the world. "
    |> create_message(channel_id)
  end

  def execute(channel_id, ["add_school"]),
    do:
      "add_school takes an argument mandatory list: \nadd_school name:{name}, boss:{boss}, country:{country}, city:{city}"
      |> create_message(channel_id)

  def execute(channel_id, ["with_details"]) do
    Teachings.list_dance_schools()
    |> case do
      [] ->
        "No schools registered yet ! Insert one with !schools add_school command. "
        |> create_message(channel_id)

      school_list ->
        school_list
        |> Enum.map(fn
          school ->
            "Name: #{school.name}, Boss: #{school.boss}, Country: #{school.country}, City: #{school.city}"
            |> create_message(channel_id)
        end)
    end
  end

  def execute(channel_id, ["add_school help"]) do
    "!schools add_school name: XXX, boss: YYY, city: AAA, country: BBB\n
    (don't forget the commas!)"
    |> create_message(channel_id)
  end

  def execute(channel_id, ["add_school " <> school]) do
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
        "#{dance_school.name} created !" |> create_message(channel_id)

      {:error, %Ecto.Changeset{errors: [{attribute, {error_message, _}} | _]}} ->
        "Couldn't insert this Dance School because #{attribute} #{inspect(error_message)}"
        |> create_message(channel_id)
    end
  end

  def execute(channel_id, [country]) do
    country
    |> Teachings.list_dance_schools_by_country()
    |> case do
      [] ->
        "No schools registered for this country yet !"
        |> create_message(channel_id)

      school_list ->
        school_list
        |> Enum.map(fn
          school ->
            school.name
            |> create_message(channel_id)
        end)
    end
  end

  # Cogs.def(schools("[options]", _), do: nil)
end
