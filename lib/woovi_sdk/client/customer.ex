defmodule WooviSdk.Client.Customer do
  @moduledoc """
  Client for customers.
  """

  alias WooviSdk.Resource.Customer
  alias WooviSdk.{Client, Config}

  @doc """
  Get a customer by ID.
  """
  @spec get(Config.t(), String.t()) :: Client.sdk_response(Customer.customer_response())
  def get(%Config{} = config, id) do
    Client.get(config, "/api/v1/customer/#{id}")
  end

  @doc """
  Get a list of customers.
  """
  @spec list(Config.t(), keyword()) :: Client.sdk_response(Customer.customer_list_response())
  def list(%Config{} = config, opts \\ []) do
    query_params =
      opts
      |> Keyword.take([:limit, :skip])
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)

    Client.get(config, "/api/v1/customer", query_params: query_params)
  end

  @doc """
  Create a new customer.
  """
  @spec create(Config.t(), Customer.customer_payload()) ::
          Client.sdk_response(Customer.customer_response())
  def create(%Config{} = config, data) do
    Client.post(config, "/v1/customers", data)
  end

  @doc """
  Update a customer.
  """
  @spec update(Config.t(), String.t(), Customer.customer_payload()) ::
          Client.sdk_response(Customer.customer_response())
  def update(%Config{} = config, customer_id, data) do
    Client.patch(config, "/api/v1/customer/#{customer_id}", data)
  end
end
