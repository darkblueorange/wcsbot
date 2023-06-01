import Config

config :wcsbot,
  ecto_repos: [Wcsbot.Repo]


# Configures Elixir's Logger
# config :logger,
#   backends: [:console, {LoggerFileBackend, :error_log}],
#   # :console,
#   # Normal level log => level: :info
#   level: :debug,
#   format: "$time $metadata[$level] $message\n",
#   metadata: [:request_id]

config :wcsbot, Wcsbot.Repo,
  database: "wcsbot_repo",
  username: "test",
  password: "passtest",
  hostname: "localhost"
