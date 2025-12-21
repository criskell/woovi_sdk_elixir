defmodule WooviSdk.Resource.Charge do
  alias WooviSdk.Resource.Customer

  @typedoc """
  Represents a specific charge.

  Fields:
        - `value`: Amount of charge.
        - `correlationID`: Correlation ID of charge.
  """
  @type t :: %{
          value: integer(),
          correlationID: String.t()
        }

  @typedoc """
  Payload of a create charge request.

  Fields:
        - `correlationID`: Correlation ID of charge.
        - `value`: Amount of charge.
        - `comment`: Optional comment.
        - `customer`: Customer data.
  """
  @type create_payload :: %{
          required(:correlationID) => String.t(),
          required(:value) => integer(),
          optional(:comment) => String.t(),
          optional(:customer) => Customer.t()
        }

  @typedoc """
  Payload of a create charge response.

  Fields:
        - `charge`: Returned charge.
  """
  @type charge_response :: %{
          charge: t()
        }

  @typedoc """
  Payload of a charge patch request.

  Fields:
        - `expiresDate`: Expiration date of the charge. Only in ISO 8601 format.
  """
  @type patch_payload :: %{
          required(:expiresDate) => String.t()
        }

  @typedoc """
  Response of a charge patch request.

  Fields:
        - `status`: Status of charge.
        - `id`: The id previously informed to be found and deleted.
        - `expiresDate`: New date to expire specfic charge.
  """
  @type patch_response :: %{
          required(:status) => String.t(),
          required(:id) => String.t(),
          required(:expiresDate) => String.t()
        }
end
