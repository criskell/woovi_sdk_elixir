defmodule WooviSdk.Resource.Customer do
  @type t :: %{
          optional(:name) => String.t(),
          optional(:correlationID) => String.t(),
          optional(:email) => String.t(),
          optional(:phone) => String.t(),
          optional(:taxID) => String.t(),
          optional(:address) => address()
        }

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
