defmodule Wcsbot.Commands do
  use Alchemy.Cogs
  alias Alchemy.Embed
  require Alchemy.Embed

  Cogs.def ping do
    Cogs.say "pong!"
  end
end
