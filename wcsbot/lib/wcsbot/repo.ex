defmodule Wcsbot.Repo do
  use Ecto.Repo,
    otp_app: :wcsbot,
    adapter: Ecto.Adapters.Postgres
end

# defmodule Wcsbot.Repo do
#   use Ecto.Repo,
#     otp_app: :wcsbot,
#     adapter: Ecto.Adapters.Postgres


#   def listen([]) do
#     {:ok, 1, 1}
#   end

#   def listen([head | tail]) do
#     # La gestion d'erreur arrête tout, et la propagation des PID/ REF n'est pas correcte ici, mais peu important après tout car l'important est qu'on s'arrête
#     with {:ok, pid, ref} <- listen(head),
#          {:ok, _pid, _ref} <- listen(tail) do
#       {:ok, pid, ref}
#     else
#       error -> {:stop, error}
#     end
#   end

#   def listen(event_name) do
#     with {:ok, pid} <- Postgrex.Notifications.start_link(__MODULE__.config()),
#          {:ok, ref} <- Postgrex.Notifications.listen(pid, event_name) do
#       {:ok, pid, ref}
#     end
#   end
# end
