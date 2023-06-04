defmodule WcsBot.DiscordCommand do
  @moduledoc """
  Discord Commands Module.

  Will contain every bot command available to user (and admin) in Discord.
  """
  alias WcsBot.Command.Docs
  alias WcsBot.DiscordCommand.Schools
  alias Nostrum.Api

  @prefix "!"
  # Bot ID is used to ignore our own message
  @bot_id 1_114_822_453_336_756_276
  @guild_id 1_113_880_444_413_419_530

  def handle_msg(%{author: %{id: @bot_id}}), do: :noop

  def handle_msg(%{content: @prefix <> content} = msg) do
    content
    |> String.trim()
    |> String.split(" ", parts: 2)
    |> execute(msg)
  end

  def handle_msg(_), do: :noop

  def handle_interaction(%{data: %{name: "school_list"}} = interaction) do
    Schools.list_schools(%{
      channel_id: interaction.channel_id,
      with_details: find_details(interaction.data.options),
      with_country: find_country(interaction.data.options)
    })
  end

  def handle_interaction(%{data: %{name: "school_add"}} = interaction) do
    Schools.add_school(%{
      channel_id: interaction.channel_id,
      data: interaction.data
    })
  end

  defp find_details([%{name: "with_details", value: with_details} | _]), do: with_details
  defp find_details([_, %{name: "with_details", value: with_details}]), do: with_details
  defp find_details(_), do: false

  defp find_country([%{name: "country", value: country} | _]), do: country
  defp find_country([_, %{name: "country", value: country}]), do: country
  defp find_country(_), do: false

  defp execute(["ping"], msg) do
    "pong"
    |> create_message(msg.channel_id)
  end

  defp execute(["echo"], msg) do
    "Give me something to echo"
    |> create_message(msg.channel_id)
  end

  defp execute(["echo", to_echo], msg) do
    to_echo |> create_message(msg.channel_id)
  end

  defp execute(["docs", module_name], msg) do
    Docs.get_docs(module_name)
    |> create_message(msg.channel_id)
  end

  defp execute(_, msg) do
    "This command doesnt exist, sorry"
    |> create_message(msg.channel_id)
  end

  def create_message(message, channel_id) do
    channel_id
    |> Api.create_message(message)
  end

  def register_command() do
    Nostrum.Api.create_guild_application_command(
      @guild_id,
      Schools.create_command("school_list")
    )

    Nostrum.Api.create_guild_application_command(
      @guild_id,
      Schools.create_command("school_add")
    )
  end
end

defmodule WcsBot.DiscordCommand.Schools do
  @moduledoc """
  Provide the list of dance schools (as an API through Discord bot).

  """
  alias WcsBot.DiscordCommand
  alias WcsBot.Teachings
  alias Nostrum.Api

  @application_command_type_string 3
  @application_command_type_boolean 5

  def create_command("school_list") do
    %{
      name: "school_list",
      description: "Lists a dance school. ",
      options: [
        %{
          type: @application_command_type_string,
          name: "country",
          description: "by country",
          required: false
        },
        %{
          type: @application_command_type_boolean,
          name: "with_details",
          description: "With or without details",
          required: false
        }
      ]
    }
  end

  def create_command("school_add") do
    %{
      name: "school_add",
      description: "Adds a dance school. ",
      options: [
        %{
          type: @application_command_type_string,
          name: "name",
          description: "School name",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "city",
          description: "School city",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "country",
          description: "School country",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "boss",
          description: "School owner",
          required: true
        }
      ]
    }
  end

  def list_schools(
        %{
          channel_id: channel_id,
          with_details: with_details
        } = data_struct
      ) do
    list_schools_give_query(data_struct)
    |> case do
      [] ->
        "No schools registered for this country yet !"
        |> create_message(channel_id)

      school_list ->
        school_list
        |> Enum.map(fn
          school ->
            ((with_details &&
                "Name: #{school.name}, Boss: #{school.boss}, Country: #{school.country}, City: #{school.city}") ||
               school.name)
            |> DiscordCommand.create_message(channel_id)
        end)
    end
  end

  defp list_schools_give_query(%{with_country: country}) when country != false do
    country |> Teachings.list_dance_schools_by_country()
  end

  defp list_schools_give_query(_), do: Teachings.list_dance_schools()

  def add_school(%{channel_id: channel_id, data: %{options: data_list}}) do
    data_list
    |> Enum.reduce(%{}, fn %{name: data_field, value: data_value}, map_acc ->
      map_acc
      |> Map.put(data_field, data_value)
    end)
    |> Teachings.create_dance_school()
    |> case do
      {:ok, dance_school} ->
        "#{dance_school.name} created !" |> DiscordCommand.create_message(channel_id)

      {:error, %Ecto.Changeset{errors: [{attribute, {error_message, _}} | _]}} ->
        "Couldn't insert this Dance School because #{attribute} #{inspect(error_message)}"
        |> DiscordCommand.create_message(channel_id)
    end
  end
end
