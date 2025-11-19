defmodule WooviSdk.Client.Charge do
  @moduledoc """
  Client for charges.
  """

  alias WooviSdk.Resource.Charge
  alias WooviSdk.{Client, Config}

  @doc """
  Get one charge.
  """
  @spec get(Config.t(), String.t()) ::
          Client.sdk_response(Charge.charge_response())
  def get(%Config{} = config, id) do
    Client.get(config, "/api/v1/charge/#{id}")
  end

  @doc """
  Get a list of charges.
  """
  @spec list(Config.t(), keyword()) ::
          Client.sdk_response(Charge.charge_response())
  def list(%Config{} = config, opts \\ []) do
    raw_params =
      opts
      |> Keyword.take([:start_date_time, :end_date_time, :status, :customer, :subscription])
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)

    query_params =
      Enum.map(raw_params, fn
        {:start_date_time, value} -> {:start, value}
        {:end_date_time, value} -> {:end, value}
        other -> other
      end)

    Client.get(config, "/api/v1/charge", query_params: query_params)
  end

  @doc """
  Create a new charge.
  """
  @spec create(Config.t(), Charge.create_payload()) ::
          Client.sdk_response(Charge.charge_response())
  def create(%Config{} = config, data) do
    Client.post(config, "/api/v1/charge", data)
  end

  @doc """
  Delete a charge.
  """
  @spec delete(Config.t(), String.t()) ::
          Client.sdk_response(Charge.charge_response())
  def delete(%Config{} = config, id) do
    Client.delete(config, "/api/v1/charge/#{id}")
  end
end
