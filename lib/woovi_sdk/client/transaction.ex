defmodule WooviSdk.Client.Transaction do
  @moduledoc """
  Client for transactions.
  """

  alias WooviSdk.Resource.Transaction
  alias WooviSdk.{Client, Config}

  @doc """
  Get a transaction by ID.
  """
  @spec get(Config.t(), String.t()) :: Client.sdk_response(Transaction.transaction_response())
  def get(%Config{} = config, id) do
    Client.get(config, "/api/v1/transaction/#{id}")
  end

  @doc """
  List transactions using optional filters.
  """
  @spec list(Config.t(), keyword()) ::
          Client.sdk_response(Transaction.transaction_list_response())
  def list(%Config{} = config, opts \\ []) do
    allowed = [:start, :end, :charge, :pixQrCode, :withdrawal]

    query_params = opts |> Keyword.take(allowed) |> Enum.reject(fn {_k, v} -> is_nil(v) end)

    Client.get(config, "/api/v1/transaction", [], query_params: query_params)
  end
end
