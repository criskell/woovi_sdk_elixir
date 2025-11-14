defmodule WooviSdk.Resource.Split do
  @type split_type :: :split_internal_transfer | :split_sub_account | :split_partner

  @type t :: %{
          required(:value) => integer(),
          required(:pixKey) => String.t(),
          required(:splitType) => String.t()
        }
end
