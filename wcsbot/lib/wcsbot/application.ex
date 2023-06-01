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
    if discord_active?() do

      IO.inspect("discord active", label: "we are here ")

      run = Alchemy.Client.start(discord_token())
      |> IO.inspect(label: "RUN RESULT :: ")
      load_modules()
      # We supply this to satisfy the application callback
      run
    else
      IO.inspect("discord not active", label: "we are here ")

      opts = [strategy: :one_for_one, name: Wcsbot.Supervisor]
      Supervisor.start_link([], opts)
    end
  end

  defp discord_active? do
    :wcsbot
    |> Application.get_env(:active, false)
    # |> WannabeBool.to_boolean()
    true
  end

  defp discord_token do
    # Application.fetch_env!(:discord, :token)
    # "e9511491512bd407a1bf60b377916cde96816010446403ca2010c78e0335bb1d"
    "MTExMzg4MTM5NjE1OTcxMzQzMg.GW143Z.cc7Ros-EKKOu-dAU52intGKRbXAo70Qb8IdPVE"
  end

  defp load_modules do
    use Wcsbot.Commands
  end
end
