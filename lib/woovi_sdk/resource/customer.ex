defmodule WooviSdk.Resource.Customer do
  @type t :: %__MODULE__{
          name: String.t(),
          correlationID: String.t(),
          email: String.t(),
          phone: String.t(),
          taxID: String.t(),
          address: address()
        }
  defstruct [:name, :correlationID, :email, :phone, :taxID, :address]

  @type address :: %{
          zipcode: String.t(),
          street: String.t(),
          number: String.t(),
          neighborhood: String.t(),
          city: String.t(),
          state: String.t(),
          country: String.t(),
          complement: String.t()
        }

  @type customer_payload :: t()

  @type customer_response :: %{
          customer: t()
        }

  @type customer_list_response :: %{
          required(:customers) => [t()],
          required(:pageInfo) => map()
        }
end
