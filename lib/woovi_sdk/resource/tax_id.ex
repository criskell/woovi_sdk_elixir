defmodule WooviSdk.Resource.TaxId do
  @typedoc """
  Represents a legal identification.

  Fields:
  - `taxID`: Store a CPF/CNPJ.
  - `type`: "CPF" | "CNPJ"
  """
  @type t :: %{
          optional(:taxID) => String.t(),
          optional(:type) => String.t()
        }
end
