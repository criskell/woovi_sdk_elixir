defmodule WooviSdk.Resource.Charge do
  @type t :: %{
          value: integer(),
          correlationID: String.t()
        }

  @type charge_response :: %{
          charge: t()
        }

  @type create_payload :: %{
          required(:correlationID) => String.t(),
          required(:value) => integer()
        }
end
