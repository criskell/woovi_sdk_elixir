defmodule WooviSdk.Client do
  @moduledoc """
  Primary client of the SDK.
  """

  alias WooviSdk.HttpClient
  alias WooviSdk.Config

  @type error_response(body_t) ::
          {:error,
           %{
             optional(:status) => non_neg_integer(),
             optional(:headers) => HttpClient.headers(),
             optional(:body) => body_t,
             optional(:message) => any()
           }}

  @type sdk_response(body_t) ::
          {:ok, body_t}
          | error_response(body_t)

  @type body :: map()

  @doc """
  Send a request to the Woovi API.

  ## Returns

  `{:ok, response}` on success, or `{:error, response}` on failure.
  The response body is decoded using the configured JSON library if possible.
  """
  @spec request(
          Config.t(),
          String.t(),
          String.t(),
          body(),
          HttpClient.headers(),
          keyword()
        ) :: sdk_response(any())
  def request(
        %Config{api_url: api_url, access_token: access_token},
        method,
        path,
        body \\ %{},
        headers \\ [],
        opts \\ []
      ) do
    query_params = Keyword.get(opts, :query_params, [])

    query_string =
      if query_params == [] do
        ""
      else
        "?" <> URI.encode_query(query_params)
      end

    endpoint_url = api_url <> path <> query_string

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", access_token}
      | headers
    ]

    encoded_body =
      case body do
        nil -> nil
        %{} -> Config.json_library().encode!(body)
        _ -> body
      end

    response = Config.http_client().request(method, endpoint_url, headers, encoded_body, opts)

    case response do
      {:ok, %{status: status, body: response_body} = response} ->
        decoded =
          try do
            Config.json_library().decode!(response_body, keys: :atoms)
          rescue
            _ -> response_body
          end

        cond do
          is_map(decoded) and Map.has_key?(decoded, "error") ->
            {:error, %{response | message: decoded["error"]}}

          status in 200..299 ->
            {:ok, decoded}

          true ->
            {:error, %{response | body: decoded}}
        end

      {:error, reason} ->
        {:error, %{message: reason}}
    end
  end

  @doc """
  Sends a **GET** request to the Woovi API.
  """
  @spec get(Config.t(), String.t(), HttpClient.headers(), keyword()) :: sdk_response(any())
  def get(config, path, headers \\ [], opts \\ []) do
    request(config, "GET", path, %{}, headers, opts)
  end

  @doc """
  Sends a **POST** request to the Woovi API.
  """
  @spec post(Config.t(), String.t(), body(), HttpClient.headers(), keyword()) ::
          sdk_response(any())
  def post(config, path, body, headers \\ [], opts \\ []) do
    request(config, "POST", path, body, headers, opts)
  end

  @doc """
  Sends a **PATCH** request to the Woovi API.
  """
  @spec patch(Config.t(), String.t(), body(), HttpClient.headers(), keyword()) ::
          sdk_response(any())
  def patch(config, path, body, headers \\ [], opts \\ []) do
    request(config, "PATCH", path, body, headers, opts)
  end

  @doc """
  Sends a **PATCH** request to the Woovi API.
  """
  @spec delete(Config.t(), String.t(), HttpClient.headers(), keyword()) :: sdk_response(any())
  def delete(config, path, headers \\ [], opts \\ []) do
    request(config, "DELETE", path, %{}, headers, opts)
  end
end
