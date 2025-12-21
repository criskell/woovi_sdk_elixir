defmodule WooviSdk.Config do
  @moduledoc """
  Configuration for the Woovi SDK.
  """
  alias WooviSdk.HttpClientFinch

  @api_url "https://api.woovi.com"
  @sandbox_api_url "https://api.woovi-sandbox.com"

  @type t :: %__MODULE__{
          access_token: String.t(),
          api_url: String.t()
        }

  defstruct [:access_token, :api_url]

  @doc """
  Creates new configuration using the provided access token.

  If `sandbox` is `true`, the sandbox API will be used.
  Otherwise, the production URL is used.

  ## Examples

        iex> WooviSdk.Config.new("ACCESS_TOKEN", true)
        %WooviSdk.Config{
          access_token: "ACCESS_TOKEN",
          api_url: "https://api-sandbox.woovi.com"
        }
  """
  @spec new(String.t(), boolean()) :: t()
  def new(access_token, sandbox?) when is_boolean(sandbox?) do
    api_url = if sandbox?, do: @sandbox_api_url, else: @api_url

    new(access_token, api_url)
  end

  @spec new(String.t(), String.t()) :: t()
  def new(access_token, api_url) do
    %__MODULE__{
      access_token: access_token,
      api_url: api_url
    }
  end

  def json_library do
    Application.get_env(:woovi_sdk, :json_library, Jason)
  end

  def http_client do
    Application.get_env(:woovi_sdk, :http_client, HttpClientFinch)
  end
end
