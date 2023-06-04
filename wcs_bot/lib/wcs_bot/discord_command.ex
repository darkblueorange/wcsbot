defmodule WcsBot.Command do
  @moduledoc """
  Discord Commands Module.

  Will contain every bot command available to user (and admin) in Discord.
  """
  alias WcsBot.Command.Docs
  alias Nostrum.Api

  @prefix "!"
  # @bot_id 747_816_914_826_297_394
  # @bot_id 1_113_881_396_159_713_432
  @bot_id 1_114_822_453_336_756_276

  def handle(%{author: %{id: @bot_id}}), do: :noop

  def handle(msg = %{content: @prefix <> content}) do
    content
    |> IO.inspect(label: ":: message received :: ")
    |> String.trim()
    |> String.split(" ", parts: 3)
    |> execute(msg)
  end

  def handle(_), do: :noop

  defp execute(["ping"], msg) do
    create_message(msg.channel_id, "pong")
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
