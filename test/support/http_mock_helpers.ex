defmodule WooviSdk.Test.HttpMockHelpers do
  import Mox
  import ExUnit.Assertions

  alias WooviSdk.HttpClientMock

  @doc """
  Mock a request.

  ## Parameters

  - `method`: Expected method.
  - `payload`: Expected payload sent to Woovi API.
  - `opts`: Customize response.
  """
  def mock_request(method, path, payload \\ nil, opts) do
    expect(HttpClientMock, :request, fn req_method, url, headers, body, _req_opts ->
      assert String.upcase(to_string(method)) == req_method

      %URI{path: path_from_url, query: query_from_url} = URI.parse(url)
      assert path_from_url == path

      if query = opts[:query_params] do
        assert URI.encode_query(query) == query_from_url
      end

      content_type = headers |> List.keyfind("Content-Type", 0, "")
      is_json = payload && content_type == "application/json"

      if is_json do
        assert payload == Jason.decode!(body)
      end

      {:ok,
       %{
         status: Keyword.get(opts, :status, 200),
         headers: Keyword.get(opts, :headers, []),
         body: Jason.encode!(Keyword.get(opts, :body, %{}))
       }}
    end)
  end
end
