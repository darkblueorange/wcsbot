defmodule WcsBot.DiscordCommand do
  @moduledoc """
  Discord Commands Module.

  Will contain every bot command available to user (and admin) in Discord.
  """
  alias WcsBot.DiscordCommand.{ChitChat, Schools, Events}
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
    |> ChitChat.answer(msg)
  end

  def handle_msg(_), do: :noop

  def handle_interaction(%{data: %{name: "school_list"}} = interaction) do
    Schools.list_schools(%{
      channel_id: interaction.channel_id,
      with_details: find_details(interaction.data.options),
      with_country: find_country(interaction.data.options)
    })
  end

  def handle_interaction(%{data: %{name: "event_list"}} = interaction) do
    Events.list_events(%{
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

  def handle_interaction(%{data: %{name: "event_add"}} = interaction) do
    Events.add_event(%{
      channel_id: interaction.channel_id,
      data: interaction.data
    })
  end

  def handle_interaction(_), do: :noop

  defp find_details([%{name: "with_details", value: with_details} | _]), do: with_details
  defp find_details([_, %{name: "with_details", value: with_details}]), do: with_details
  defp find_details(_), do: false

  defp find_country([%{name: "country", value: country} | _]), do: country
  defp find_country([_, %{name: "country", value: country}]), do: country
  defp find_country(_), do: false

  def create_message(message, channel_id) when message |> is_list() do
    message_list =
      message
      |> Enum.join("\r")

    channel_id
    |> Api.create_message(message_list)
  end

  def create_message(message, channel_id) do
    channel_id
    |> Api.create_message(message)
  end

  @doc """
  Registers business commands.
  Actually registers school_list and school_add.

  """
  def register_command() do
    Nostrum.Api.get_guild_application_commands(@guild_id)
    |> elem(1)
    |> Enum.each(fn app_cmd ->
      app_cmd.application_id
      |> Nostrum.Api.delete_guild_application_command(app_cmd.guild_id, app_cmd.id)
    end)

    Nostrum.Api.create_guild_application_command(
      @guild_id,
      Schools.create_discord_command("school_list")
    )

    Nostrum.Api.create_guild_application_command(
      @guild_id,
      Events.create_discord_command("event_list")
    )

    Nostrum.Api.create_guild_application_command(
      @guild_id,
      Schools.create_discord_command("school_add")
    )

    Nostrum.Api.create_guild_application_command(
      @guild_id,
      Events.create_discord_command("event_add")
    )
  end
end

defmodule WcsBot.DiscordCommand.ChitChat do
  @moduledoc """
  Basic Chitchat for "nothing".

  """
  alias WcsBot.DiscordCommand
  alias WcsBot.DiscordCommand.Docs

  def answer(["ping"], msg) do
    "pong"
    |> DiscordCommand.create_message(msg.channel_id)
  end

  def answer(["echo"], msg) do
    "Give me something to echo"
    |> DiscordCommand.create_message(msg.channel_id)
  end

  def answer(["echo", to_echo], msg) do
    to_echo |> DiscordCommand.create_message(msg.channel_id)
  end

  def answer(["docs", module_name], msg) do
    Docs.get_docs(module_name)
    |> DiscordCommand.create_message(msg.channel_id)
  end

  def answer(_, msg) do
    "This command doesnt exist, sorry"
    |> DiscordCommand.create_message(msg.channel_id)
  end
end

defmodule WcsBot.DiscordCommand.Schools do
  @moduledoc """
  Provide the list of dance schools (as an API through Discord bot).

  """
  alias WcsBot.DiscordCommand
  alias WcsBot.Teachings

  @application_command_type_string 3
  @application_command_type_boolean 5

  def create_discord_command("school_list") do
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

  def create_discord_command("school_add") do
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
        "No schools registered yet on this scope!"
        |> DiscordCommand.create_message(channel_id)

      school_list ->
        school_list
        |> Enum.map(fn
          school ->
            (with_details &&
               "Name: #{school.name}, Boss: #{school.boss}, Country: #{school.country}, City: #{school.city}") ||
              school.name
        end)
        |> DiscordCommand.create_message(channel_id)
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

defmodule WcsBot.DiscordCommand.Events do
  @moduledoc """
  Provide the list of events (as an API through Discord bot).

  """
  alias WcsBot.DiscordCommand
  alias WcsBot.Parties

  @application_command_type_string 3
  @application_command_type_boolean 5

  def create_discord_command("event_list") do
    %{
      name: "event_list",
      description: "Lists upcoming events. ",
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

  def create_discord_command("event_add") do
    %{
      name: "event_add",
      description: "Adds an event. ",
      options: [
        %{
          type: @application_command_type_string,
          name: "name",
          description: "Event name",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "country",
          description: "Event country",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "address",
          description: "Event address",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "description",
          description: "Event description",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "lineup",
          description: "Event lineup",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "begin_date",
          description: "Event begin date",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "end_date",
          description: "Event end date",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "url_event",
          description: "Event URL",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "wcsdc",
          description: "WCDCS affiliation",
          required: false
        }
      ]
    }
  end

  def list_events(
        %{
          channel_id: channel_id,
          with_details: with_details
        } = data_struct
      ) do
    list_events_give_query(data_struct)
    |> case do
      [] ->
        "No events registered yet on this scope!"
        |> DiscordCommand.create_message(channel_id)

      # https://discord-date.shyked.fr/
      event_list ->
        event_list
        |> Enum.map(fn
          event ->
            (with_details &&
               "Name: #{event.name}, Begin date: #{event.begin_date |> date_to_discord_format()}, End date: #{event.end_date |> date_to_discord_format()}, Country: #{event.country}") ||
              event.name
        end)
        |> DiscordCommand.create_message(channel_id)
    end
  end

  # 2023-10-16
  defp date_to_discord_format(stupid_date) do
    unix_time =
      ((stupid_date |> Date.to_string()) <> "T00:00:00Z")
      |> DateTime.from_iso8601()
      |> elem(1)
      |> DateTime.to_unix()

    "<t:#{unix_time}:D>"
  end

  defp list_events_give_query(%{with_country: country}) when country != false do
    country |> Parties.list_future_events_by_country()
  end

  defp list_events_give_query(_), do: Parties.list_events()

  def add_event(%{channel_id: channel_id, data: %{options: data_list}}) do
    data_list
    |> Enum.reduce(%{}, fn %{name: data_field, value: data_value}, map_acc ->
      map_acc
      |> Map.put(data_field, data_value)
    end)
    |> Parties.create_event()
    |> case do
      {:ok, event} ->
        "#{event.name} created !" |> DiscordCommand.create_message(channel_id)

      {:error, %Ecto.Changeset{errors: [{attribute, {error_message, _}} | _]}} ->
        "Couldn't insert this Event because #{attribute} #{inspect(error_message)}"
        |> DiscordCommand.create_message(channel_id)
    end
  end
end
