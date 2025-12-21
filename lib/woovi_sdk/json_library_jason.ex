defmodule WooviSdk.JsonLibraryJason do
  @moduledoc false

  def encode!(input) do
    Jason.encode!(input)
  end

  def decode!(input) do
    Jason.decode!(input, keys: :atoms)
  end
end
