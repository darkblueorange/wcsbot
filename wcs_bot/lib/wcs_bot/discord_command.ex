defmodule WcsBot.DiscordCommand do
  @moduledoc """
  Discord Commands Module.

  Will contain every bot command available to user (and admin) in Discord.
  """
  alias WcsBot.DiscordCommand.{ChitChat, Schools, Events, Parties, StrictlyAskings}
  alias Nostrum.Api

  require Logger

  @prefix "!"
  # Bot ID is used to ignore our own message
  @bot_id 1_114_822_453_336_756_276
  @guild_id 1_113_880_444_413_419_530
  @interaction_message_type 4

  def handle_msg(%{author: %{id: @bot_id}}), do: :noop

  def handle_msg(%{content: @prefix <> content} = msg) do
    content
    |> String.trim()
    |> String.split(" ", parts: 2)
    |> ChitChat.answer(msg)
  end

  def handle_msg(_), do: :noop

  def handle_interaction(%{data: %{name: "school_list"}} = interaction) do
    %{
      interaction: interaction,
      with_details: find_recursive("with_details", interaction.data.options),
      queryable: %{
        country: find_recursive("by_country", interaction.data.options),
        city: find_recursive("by_city", interaction.data.options)
      }
    }
    |> Schools.list_schools()
  end

  def handle_interaction(%{data: %{name: "event_list"}} = interaction) do
    %{
      interaction: interaction,
      with_details: find_recursive("with_details", interaction.data.options),
      queryable: %{
        country: find_recursive("by_country", interaction.data.options),
        city: find_recursive("by_city", interaction.data.options),
        timeframe: find_recursive("timeframe", interaction.data.options)
      }
    }
    |> Events.list_events()
  end

  def handle_interaction(%{data: %{name: "party_list"}} = interaction) do
    %{
      interaction: interaction,
      with_details: find_recursive("with_details", interaction.data.options),
      queryable: %{
        country: find_recursive("by_country", interaction.data.options),
        city: find_recursive("by_city", interaction.data.options),
        timeframe: find_recursive("timeframe", interaction.data.options)
      }
    }
    |> Parties.list_parties()
  end

  def handle_interaction(%{data: %{name: "strictly_asking_list"}} = interaction) do
    %{
      interaction: interaction,
      with_details: find_recursive("with_details", interaction.data.options),
      queryable: %{
        event_id: find_recursive("by_event", interaction.data.options),
        timeframe: find_recursive("timeframe", interaction.data.options)
      }
    }
    |> StrictlyAskings.list_strictly_askings()
  end

  def handle_interaction(%{data: %{name: "school_add"}} = interaction) do
    Schools.add_school(%{
      interaction: interaction,
      data: interaction.data
    })
  end

  def handle_interaction(%{data: %{name: "event_add"}} = interaction) do
    Events.add_event(%{
      interaction: interaction,
      data: interaction.data
    })
  end

  def handle_interaction(%{data: %{name: "party_add"}} = interaction) do
    Parties.add_party(%{
      interaction: interaction,
      data: interaction.data
    })
  end

  def handle_interaction(%{data: %{name: "strictly_asking_add"}} = interaction) do
    StrictlyAskings.add_strictly_asking(%{
      interaction: interaction,
      data: interaction.data
    })
  end

  def handle_interaction(_), do: :noop

  # We receive a data_list of the form
  # [_ | %{name: "country", value: country} | _]
  # we return the value of the country if we have that key given
  defp find_recursive(_, nil), do: false

  defp find_recursive(data_elem, data_list) do
    data_list
    |> Enum.find_value(fn %{name: lookup_key, value: lookup_value} ->
      (lookup_key == data_elem)
      |> if do
        lookup_value
      end
    end)
    |> case do
      nil -> false
      val -> val
    end
  end

  @doc """
  Creates a bot answer to a simple user message (with !).

  """
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
  Creates a bot answer.
  We needs this (instead of create_message/1-2) when it is an "interaction" (user command with /)

  """
  def create_interaction_response(message, interaction) when message |> is_list() do
    message_list =
      message
      |> Enum.join("\r")

    interaction
    |> Api.create_interaction_response(%{
      type: @interaction_message_type,
      data: %{content: message_list}
    })
  end

  def create_interaction_response(message, interaction) do
    interaction
    |> Api.create_interaction_response(%{
      type: @interaction_message_type,
      data: %{content: message}
    })
  end

  @doc """
  Registers business commands.
  Actually registers school_list and school_add.

  """
  def register_command() do
    Application.get_env(:nostrum, WcsBot.DiscordCommand)[:register_guild]
    |> String.to_existing_atom()
    |> if do
      Logger.info("Updating and registering commands on Discord server ")

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
        Parties.create_discord_command("party_list")
      )

      Nostrum.Api.create_guild_application_command(
        @guild_id,
        StrictlyAskings.create_discord_command("strictly_asking_list")
      )

      Nostrum.Api.create_guild_application_command(
        @guild_id,
        Schools.create_discord_command("school_add")
      )

      Nostrum.Api.create_guild_application_command(
        @guild_id,
        Events.create_discord_command("event_add")
      )

      Nostrum.Api.create_guild_application_command(
        @guild_id,
        Parties.create_discord_command("party_add")
      )

      Nostrum.Api.create_guild_application_command(
        @guild_id,
        StrictlyAskings.create_discord_command("strictly_asking_add")
      )
    end
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
          name: "by_country",
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
        },
        %{
          type: @application_command_type_string,
          name: "mail",
          description: "School mail contact",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "website_url",
          description: "School website URL",
          required: false
        }
      ]
    }
  end

  def list_schools(%{
        interaction: interaction,
        with_details: with_details,
        queryable: queryable
      }) do
    queryable
    |> list_schools_give_query()
    |> case do
      [] ->
        "No schools registered yet on this scope!"
        |> DiscordCommand.create_interaction_response(interaction)

      school_list ->
        school_list
        |> Enum.map(fn
          school ->
            (with_details &&
               "Name: #{school.name}, Boss: #{school.boss}, Country: #{school.country}, City: #{school.city}") ||
              school.name
        end)
        |> DiscordCommand.create_interaction_response(interaction)
    end
  end

  defp list_schools_give_query(queryable) do
    queryable |> Teachings.list_dance_schools_by()
  end

  def add_school(%{interaction: interaction, data: %{options: data_list}}) do
    data_list
    |> Enum.reduce(%{}, fn %{name: data_field, value: data_value}, map_acc ->
      map_acc
      |> Map.put(data_field, data_value)
    end)
    |> Teachings.create_dance_school()
    |> case do
      {:ok, dance_school} ->
        "#{dance_school.name} created !"
        |> DiscordCommand.create_interaction_response(interaction)

      {:error, %Ecto.Changeset{errors: [{attribute, {error_message, _}} | _]}} ->
        "Couldn't insert this Dance School because #{attribute} #{inspect(error_message)}"
        |> DiscordCommand.create_interaction_response(interaction)
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
          name: "timeframe",
          description: "timeframe",
          choices: [
            %{
              name: "in the coming week",
              value: "week"
            },
            %{
              name: "in the coming month",
              value: "month"
            },
            %{
              name: "in the coming year",
              value: "year"
            }
          ],
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "by_country",
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

  def list_events(%{
        interaction: interaction,
        with_details: with_details,
        queryable: queryable
      }) do
    queryable
    |> list_events_give_query()
    |> case do
      [] ->
        "No events registered yet on this scope!"
        |> DiscordCommand.create_interaction_response(interaction)

      # https://discord-date.shyked.fr/
      event_list ->
        event_list
        |> Enum.map(fn
          event ->
            (with_details &&
               "Name: #{event.name}, Begin date: #{event.begin_date |> date_to_discord_format()}, End date: #{event.end_date |> date_to_discord_format()}, Country: #{event.country}") ||
              event.name
        end)
        |> DiscordCommand.create_interaction_response(interaction)
    end
  end

  defp date_to_discord_format(stupid_date) do
    unix_time =
      ((stupid_date |> Date.to_string()) <> "T00:00:00Z")
      |> DateTime.from_iso8601()
      |> elem(1)
      |> DateTime.to_unix()

    "<t:#{unix_time}:D>"
  end

  defp list_events_give_query(queryable) do
    queryable |> Parties.list_events_by()
  end

  def add_event(%{interaction: interaction, data: %{options: data_list}}) do
    data_list
    |> Enum.reduce(%{}, fn %{name: data_field, value: data_value}, map_acc ->
      map_acc
      |> Map.put(data_field, data_value)
    end)
    |> Parties.create_event()
    |> case do
      {:ok, event} ->
        "#{event.name} created !" |> DiscordCommand.create_interaction_response(interaction)

      {:error, %Ecto.Changeset{errors: [{attribute, {error_message, _}} | _]}} ->
        "Couldn't insert this Event because #{attribute} #{inspect(error_message)}"
        |> DiscordCommand.create_interaction_response(interaction)
    end
  end
end

defmodule WcsBot.DiscordCommand.Parties do
  @moduledoc """
  Provide the list of parties (as an API through Discord bot).

  """
  alias WcsBot.DiscordCommand
  alias WcsBot.Parties
  require Logger

  @application_command_type_string 3
  @application_command_type_boolean 5

  def create_discord_command("party_list") do
    %{
      name: "party_list",
      description: "Lists upcoming parties. ",
      options: [
        %{
          type: @application_command_type_string,
          name: "timeframe",
          description: "timeframe",
          choices: [
            %{
              name: "in the coming week",
              value: "week"
            },
            %{
              name: "in the coming month",
              value: "month"
            },
            %{
              name: "in the coming year",
              value: "year"
            }
          ],
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "by_country",
          description: "location by country",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "by_city",
          description: "location by city",
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

  def create_discord_command("party_add") do
    %{
      name: "party_add",
      description: "Adds a party. ",
      options: [
        %{
          type: @application_command_type_string,
          name: "name",
          description: "Party name",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "city",
          description: "Party city",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "country",
          description: "Party country",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "address",
          description: "Party address",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "description",
          description: "Party description",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "party_date",
          description: "Party date",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "begin_hour",
          description: "Party begin hour",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "end_hour",
          description: "Party end hour",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "DJ",
          description: "Party DJ",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "fb_link",
          description: "Party FB link",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "url_party",
          description: "Party website URL",
          required: false
        }
      ]
    }
  end

  def list_parties(%{
        interaction: interaction,
        with_details: with_details,
        queryable: queryable
      }) do
    queryable
    |> list_parties_give_query()
    |> case do
      [] ->
        "No parties registered yet on this scope!"
        |> DiscordCommand.create_interaction_response(interaction)

      party_list ->
        party_list
        |> Enum.map(fn
          party ->
            (with_details &&
               "Name: #{party.name}, Party date: #{party.party_date |> date_to_discord_format()}, City: #{party.city}, Country: #{party.country}") ||
              party.name
        end)
        |> DiscordCommand.create_interaction_response(interaction)
    end
  end

  defp date_to_discord_format(stupid_date) do
    unix_time =
      ((stupid_date |> Date.to_string()) <> "T00:00:00Z")
      |> DateTime.from_iso8601()
      |> elem(1)
      |> DateTime.to_unix()

    "<t:#{unix_time}:D>"
  end

  defp list_parties_give_query(queryable) do
    queryable |> Parties.list_small_parties_by()
  end

  def add_party(%{interaction: interaction, data: %{options: data_list}}) do
    data_list
    |> Enum.reduce(%{}, fn %{name: data_field, value: data_value}, map_acc ->
      map_acc
      |> Map.put(data_field, data_value)
    end)
    |> Parties.create_small_party()
    |> case do
      {:ok, party} ->
        "#{party.name} created !" |> DiscordCommand.create_interaction_response(interaction)

      {:error, %Ecto.Changeset{errors: [{attribute, {error_message, _}} | _]}} ->
        "Couldn't insert this Party because #{attribute} #{inspect(error_message)}"
        |> DiscordCommand.create_interaction_response(interaction)
    end
  end
end

defmodule WcsBot.DiscordCommand.StrictlyAskings do
  @moduledoc """
  Provide the list of strictly_askings (as an API through Discord bot).

  """
  alias WcsBot.DiscordCommand
  alias WcsBot.Competitions
  require Logger

  @application_command_type_string 3
  @application_command_type_boolean 5

  def create_discord_command("strictly_asking_list") do
    %{
      name: "strictly_asking_list",
      description: "Lists pending strictly askings. ",
      options: [
        %{
          type: @application_command_type_string,
          name: "timeframe",
          description: "timeframe",
          choices: [
            %{
              name: "in the coming week",
              value: "week"
            },
            %{
              name: "in the coming month",
              value: "month"
            },
            %{
              name: "in the coming year",
              value: "year"
            }
          ],
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "by_event",
          description: "by event",
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

  def create_discord_command("strictly_asking_add") do
    %{
      name: "strictly_asking_add",
      description: "Adds a strictly_asking. ",
      options: [
        %{
          type: @application_command_type_string,
          name: "name",
          description: "Asker name",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "wcsdc_level",
          description: "Asker WCSDC level",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "dancing_role",
          description: "Asker dancing role",
          required: true
        },
        %{
          type: @application_command_type_string,
          name: "party_date",
          description: "Party date",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "description",
          description: "Asking 'fun' (or not) description",
          required: false
        },
        %{
          type: @application_command_type_string,
          name: "event",
          description: "Event",
          required: true
        }
      ]
    }
  end

  def list_strictly_askings(%{
        interaction: interaction,
        with_details: with_details,
        queryable: queryable
      }) do
    queryable
    |> list_strictly_askings_give_query()
    |> case do
      [] ->
        "No strictly_asking registered yet on this scope!"
        |> DiscordCommand.create_interaction_response(interaction)

      strictly_asking_list ->
        strictly_asking_list
        |> Enum.map(fn
          strictly_asking ->
            (with_details &&
               "Name: #{strictly_asking.name}, Event: #{strictly_asking.event.name}, Event date: #{strictly_asking.event.begin_date |> date_to_discord_format()}") ||
              strictly_asking.name
        end)
        |> DiscordCommand.create_interaction_response(interaction)
    end
  end

  defp date_to_discord_format(stupid_date) do
    unix_time =
      ((stupid_date |> Date.to_string()) <> "T00:00:00Z")
      |> DateTime.from_iso8601()
      |> elem(1)
      |> DateTime.to_unix()

    "<t:#{unix_time}:D>"
  end

  defp list_strictly_askings_give_query(queryable) do
    queryable |> Competitions.list_strictly_askings_by()
  end

  def add_strictly_asking(%{interaction: interaction, data: %{options: data_list}}) do
    data_list
    |> Enum.reduce(%{}, fn %{name: data_field, value: data_value}, map_acc ->
      map_acc
      |> Map.put(data_field, data_value)
    end)
    |> Competitions.create_strictly_asking()
    |> case do
      {:ok, strictly_asking} ->
        "Strictly asking for #{strictly_asking.name} created !"
        |> DiscordCommand.create_interaction_response(interaction)

      {:error, %Ecto.Changeset{errors: [{attribute, {error_message, _}} | _]}} ->
        "Couldn't insert this Strictly asking because #{attribute} #{inspect(error_message)}"
        |> DiscordCommand.create_interaction_response(interaction)
    end
  end
end
