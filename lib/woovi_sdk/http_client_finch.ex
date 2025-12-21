defmodule WooviSdk.HttpClientFinch do
  @moduledoc """
  Default HTTP client adapter using Finch.
  """

  alias WooviSdk.HttpClient
  @behaviour HttpClient

  @impl true
  def child_spec do
    if Code.ensure_loaded?(Finch) do
      Supervisor.child_spec({Finch, name: __MODULE__}, id: __MODULE__)
    else
      raise "Finch not available."
    end
  end

  @impl true
  @spec request(
          HttpClient.method(),
          String.t(),
          HttpClient.headers(),
          HttpClient.body(),
          keyword()
        ) :: HttpClient.response()
  def request(method, url, headers, body, opts \\ []) do
    if Code.ensure_loaded?(Finch) do
      finch_name = Keyword.get(opts, :finch_name, __MODULE__)

      request =
        Finch.build(method, url, headers, body)
        |> Finch.request(finch_name)

      case request do
        {:ok, %{status: status, body: body, headers: headers}} ->
          {:ok, %{status: status, body: body, headers: headers}}

        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, :finch_not_available}
    end
  end
end
