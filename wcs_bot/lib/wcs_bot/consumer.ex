defmodule WcsBot.Consumer do
  @moduledoc """
  Discord Consumer Module.

  Catch the events and dispatch them, to the WcsBot.Command Module.
  """
  use Nostrum.Consumer
  alias WcsBot.DiscordCommand

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    DiscordCommand.handle_msg(msg)
  end

  alias Nostrum.Struct.Interaction

  def handle_event({:INTERACTION_CREATE, %Interaction{} = interaction, _ws_state}) do
    interaction
    |> DiscordCommand.handle_interaction()
  end

  def handle_event(_event) do
    :noop
  end
end
