defmodule WooviSdk.Client.Subaccount do
  @moduledoc """
  Client for subaccounts.
  """

  alias WooviSdk.Resource.Subaccount
  alias WooviSdk.Config
  alias WooviSdk.Client

  @doc """
  Retrieve a subaccount by its pix key.

  ## Parameters

  - `pix_key`: Pix key registered to the subaccount.
  """
  @spec get(Config.t(), String.t()) :: Client.sdk_response(Subaccount.subaccount_response())
  def get(%Config{} = config, pix_key) do
    Client.get(config, "/api/v1/subaccount/#{pix_key}")
  end

  @doc """
  List subaccounts with pagination.

  ## Parameters

  - `opts`: A keyword list with following options:
    - `:skip`: skip results
    - `:limit`: limit results
  """
  @spec list(Config.t(), keyword()) :: Client.sdk_response(Subaccount.subaccount_list_response())
  def list(%Config{} = config, opts \\ []) do
    allowed = [:skip, :limit]

    query_params = opts |> Keyword.take(allowed) |> Enum.reject(fn {_k, v} -> is_nil(v) end)

    Client.get(config, "/api/v1/subaccount", [], query_params: query_params)
  end

  @doc """
  Create a subaccount.

  If a subaccount with the same pixKey already exists, the API return the existing one.
  """
  @spec create(Config.t(), Subaccount.subaccount_payload()) ::
          Client.sdk_response(Subaccount.subaccount_response())
  def create(%Config{} = config, payload) do
    Client.post(config, "/api/v1/subaccount", payload)
  end

  @doc """
  Delete a subaccount by its pix key.

  Only works if the subaccount has zero balance.
  """
  @spec delete(Config.t(), String.t()) ::
          Client.sdk_response(Subaccount.subaccount_delete_response())
  def delete(%Config{} = config, pix_key) do
    Client.delete(config, "/api/v1/subaccount/#{pix_key}")
  end

  @doc """
  Withdraw from a sub account.
  """
  @spec withdraw(Config.t(), String.t(), Subaccount.withdraw_payload()) ::
          Client.sdk_response(Subaccount.withdraw_response())
  def withdraw(%Config{} = config, pix_key, payload) do
    Client.post(config, "/api/v1/subaccount/#{pix_key}/withdraw", payload)
  end

  @doc """
  Debit from a subaccount and send the amount to the main account.
  """
  @spec debit(Config.t(), String.t(), Subaccount.debit_payload()) ::
          Client.sdk_response(Subaccount.debit_response())
  def debit(%Config{} = config, pix_key, payload) do
    Client.post(config, "/api/v1/subaccount/#{pix_key}/debit", payload)
  end

  @doc """
  Transfer between subaccounts.
  """
  @spec transfer(Config.t(), Subaccount.transfer_payload()) ::
          Client.sdk_response(Subaccount.transfer_response())
  def transfer(%Config{} = config, payload) do
    Client.post(config, "/api/v1/subaccount/transfer", payload)
  end
end
