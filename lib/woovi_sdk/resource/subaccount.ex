defmodule WooviSdk.Resource.Subaccount do
  @moduledoc """
  Subaccount resource.
  """
  alias WooviSdk.Resource.Pagination

  @typedoc """
  Subaccount entity.
  """
  @type t :: %{
          name: String.t(),
          pixKey: String.t(),
          balance: integer()
        }

  @typedoc """
  Payload to create a subaccount.
  """
  @type subaccount_payload :: %{
          required(:pixKey) => String.t(),
          required(:name) => String.t()
        }

  @typedoc """
  Response for a single subaccount.
  """
  @type subaccount_response :: %{
          SubAccount: t()
        }

  @typedoc """
  List response of subaccounts.
  """
  @type subaccount_list_response :: %{
          subaccounts: [t()],
          pageInfo: Pagination.page_info()
        }

  @typedoc """
  Response to the deletion of a subaccount.
  """
  @type subaccount_delete_response :: %{
          status: String.t(),
          pixKey: String.t()
        }

  @type withdraw_payload :: %{
          required(:value) => integer()
        }

  @type withdraw_transaction :: %{
          required(:status) => String.t(),
          required(:value) => integer(),
          required(:endToEndId) => String.t(),
          required(:correlationID) => String.t(),
          required(:destinationAlias) => String.t(),
          required(:comment) => String.t()
        }

  @type withdraw_response :: %{
          required(:transaction) => withdraw_transaction()
        }

  @typedoc """
  Payload to debit from a SubAccount.
  """
  @type debit_payload :: %{
          required(:value) => integer(),
          optional(:description) => String.t()
        }

  @typedoc """
  Response returned after debiting from a SubAccount.
  """
  @type debit_response :: %{
          required(:pixKey) => String.t(),
          required(:value) => integer(),
          required(:description) => String.t(),
          required(:success) => String.t()
        }

  @typedoc """
  Payload to perform a transfer between subaccounts.
  """
  @type transfer_payload :: %{
          required(:value) => integer(),
          required(:fromPixKey) => String.t(),
          required(:fromPixKeyType) => String.t(),
          required(:toPixKey) => String.t(),
          required(:toPixKeyType) => String.t(),
          optional(:correlationID) => String.t()
        }

  @typedoc """
  Response returned after transferring between two subaccounts.
  """
  @type transfer_response :: %{
          required(:value) => integer(),
          required(:destinationSubaccount) => t(),
          required(:originSubaccount) => t()
        }
end
