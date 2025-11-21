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

  @doc """
  Download a QR code image.
  """
  @spec download_qr_code_image(Config.t(), String.t(), integer()) :: Client.sdk_response(binary())
  def download_qr_code_image(%Config{} = config, id, size \\ 1024) when is_integer(size) do
    path = "/openpix/charge/brcode/image/#{id}.png"

    with :ok <- validate_qr_code_size(size),
         {:ok, body} <-
           Client.get(config, path, [accept: ["image/png"]], query_params: [size: size]) do
      {:ok, body}
    end
  end

  @doc """
  Get a base64 encoded QR Code image from a charge.
  """
  @spec get_qr_code_base64_encoded(Config.t(), String.t(), integer()) ::
          Client.sdk_response(String.t())
  def get_qr_code_base64_encoded(%Config{} = config, id, size \\ 1024) when is_integer(size) do
    with :ok <- validate_qr_code_size(size),
         {:ok, %{"imageBase64" => imageBase64}} <-
           Client.get(config, "/api/image/qrcode/base64/#{id}", [], query_params: [size: size]) do
      {:ok, imageBase64}
    end
  end

  defp validate_qr_code_size(size) when size < 600, do: {:error, "qr code size must be >= 600"}
  defp validate_qr_code_size(size) when size > 4096, do: {:error, "qr code size must be <= 4096"}
  defp validate_qr_code_size(_size), do: :ok

  @doc """
  Edit expiration date of a charge
  """
  @spec patch(Config.t(), String.t(), Charge.patch_payload()) ::
          Client.sdk_response(Charge.patch_response())
  def patch(%Config{} = config, charge_id, data) do
    Client.patch(config, "/api/v1/charge/#{charge_id}", data)
  end
end
