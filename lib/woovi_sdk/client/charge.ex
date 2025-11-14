defmodule WooviSdk.Client.Charge do
  @moduledoc """
  Client for charges.
  """

  alias WooviSdk.Resource.Charge
  alias WooviSdk.{Client, Config}

  @doc """
  Create a new charge.
  """
  @spec create(Config.t(), Charge.create_payload()) ::
          Client.sdk_response(Charge.charge_response())
  def create(%Config{} = config, data) do
    Client.post(config, "/v1/charges", data)
  end
end
