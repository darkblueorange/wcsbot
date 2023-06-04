defmodule WcsBot.Consumer do
  @moduledoc """
  Discord Consumer Module.

  Catch the events and dispatch them, to the WcsBot.Command Module.
  """
  use Nostrum.Consumer

  alias WcsBot.Command
  alias Nostrum.Api

  # Documentation is WRONG !!
  # def start_link do
  #   Consumer.start_link(__MODULE__)
  # end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # Command.handle(msg)
    msg
    |> IO.inspect(label: ":: message received :: ")

    case msg.content do
      "!hello" ->
        Api.create_message(msg.channel_id, "world!")

      _anything ->
        :ignore
    end
  end

  def handle_event(_event) do
    :noop
  end
end
