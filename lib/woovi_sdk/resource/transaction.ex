defmodule WooviSdk.Resource.Transaction do
  @moduledoc """
  Transaction resource.
  """

  alias WooviSdk.Resource.Pagination
  alias WooviSdk.Resource.Charge

  @typedoc """
  Transaction entity.
  """
  @type t :: %{
          optional(:charge) => Charge | nil,
          :value => integer(),
          :time => String.t(),
          optional(:payer) => customer() | nil,
          optional(:globalID) => String.t() | nil,
          optional(:pixQrCode) => pix_qrcode() | nil,
          optional(:withdraw) => pix_withdraw() | nil,
          optional(:endToEndID) => String.t() | nil,
          optional(:endToEndId) => String.t() | nil,
          optional(:infoPagador) => String.t() | nil,
          optional(:customer) => customer() | nil,
          :type => String.t()
        }

  @typedoc """
  Response for a single transaction.
  """
  @type transaction_response :: %{
          :transaction => t()
        }

  @typedoc """
  List response of transactions.
  """
  @type transaction_list_response :: %{
          :status => String.t(),
          :transactions => [t()],
          :pageInfo => Pagination.page_info()
        }

  @typedoc """
  Basic customer data inside a transaction.
  """
  @type customer :: %{
          optional(:name) => String.t(),
          optional(:email) => String.t(),
          optional(:phone) => String.t(),
          optional(:taxID) => String.t()
        }

  @typedoc """
  QrCode data (if present).
  """
  @type pix_qrcode :: %{
          optional(:id) => String.t(),
          optional(:image) => String.t(),
          optional(:payload) => String.t()
        }

  @typedoc """
  Withdraw transaction info.
  """
  @type pix_withdraw :: %{
          optional(:value) => integer() | nil,
          optional(:time) => String.t() | nil,
          optional(:payer) => customer() | nil,
          optional(:type) => String.t(),
          optional(:infoPagador) => String.t() | nil,
          optional(:endToEndID) => String.t() | nil,
          optional(:endToEndId) => String.t() | nil
        }
end
