defmodule Wcsbot.Commands do
  use Alchemy.Cogs
  alias Alchemy.Embed
  require Alchemy.Embed

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

end
