defmodule WooviSdk.Resource.Pagination do
  @moduledoc """
  Define types related to pagination in Woovi API.
  """

  @typedoc """
  Stores pagination metadata.
  """
  @type page_info :: %{
          optional(:hasNextPage) => boolean(),
          optional(:endCursor) => String.t() | nil
        }
end
