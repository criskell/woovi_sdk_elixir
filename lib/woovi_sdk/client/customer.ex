defmodule WooviSdk.Client.Customer do
  @moduledoc """
  Client for customers.
  """

  alias WooviSdk.Resource.Customer
  alias WooviSdk.{Client, Config}

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
  @spec update(Config.t(), Customer.customer_payload()) ::
          Client.sdk_response(Customer.customer_response())
  def update(%Config{} = config, data) do
    Client.patch(config, "/v1/customers", data)
  end
end
