defmodule MyBot do
  use Application
  alias Alchemy.Client

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def ping do
      Cogs.say "pong!"
    end
  end

  def start(_type, _args) do
    run = Client.start("e9511491512bd407a1bf60b377916cde96816010446403ca2010c78e0335bb1d")
    use Commands
    run
  end
end
