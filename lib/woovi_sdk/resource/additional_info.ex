defmodule WooviSdk.Resource.AdditionalInfo do
  @type t :: %{
          required(:key) => String.t(),
          required(:value) => String.t()
        }
end
