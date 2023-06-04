defmodule WcsBot.Command.Docs do
  @moduledoc """
  Discord Docs Command Module.

  I don't know yet the exact usage of this one.
  """

  def get_docs(module_name) do
    {:docs_v1, _, :elixir, _, %{"en" => module_doc}, _, _} =
      module_name
      # |> String.capitalize() # does not work -_-
      |> modularize
      |> Code.fetch_docs()

    module_doc
  end

  defp modularize(module_name) do
    String.to_existing_atom("Elixir." <> module_name)
  end
end

# {{:function, :at, 3}, _ ,_, %{"en" => docs}, _} = alo |> Enum.at(2)
# {_, _, _, _, _, _, {{:function, :at,3}, _,_, %{"en" => docs}, _ }, _} = Code.fetch_docs(Enum)
