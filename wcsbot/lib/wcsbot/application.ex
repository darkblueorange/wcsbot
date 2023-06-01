# defmodule Wcsbot.Application do
#   # See https://hexdocs.pm/elixir/Application.html
#   # for more information on OTP Applications
#   @moduledoc false

#   use Application

#   @impl true
#   def start(_type, _args) do
#     children = [
#       # Starts a worker by calling: Wcsbot.Worker.start_link(arg)
#       # {Wcsbot.Worker, arg}
#     ]

#     # See https://hexdocs.pm/elixir/Supervisor.html
#     # for other strategies and supported options
#     opts = [strategy: :one_for_one, name: Wcsbot.Supervisor]
#     Supervisor.start_link(children, opts)
#   end
# end
defmodule Wcsbot.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do

      IO.inspect("discord active", label: "we are here ")
      children = [
        Wcsbot.Repo
      ]

      # run =
      Alchemy.Client.start(discord_token())
      |> IO.inspect(label: "RUN RESULT :: ")
      load_modules()
      # We supply this to satisfy the application callback
      # run


      opts = [strategy: :one_for_one, name: Wcsbot.Supervisor]
      Supervisor.start_link(children, opts)
  end

  defp discord_token do
    System.fetch_env!("TOKEN")
  end

  defp load_modules do
    use Wcsbot.Commands
  end
end
