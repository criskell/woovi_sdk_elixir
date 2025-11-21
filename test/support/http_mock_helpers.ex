defmodule WooviSdk.Test.HttpMockHelpers do
  import Mox
  import ExUnit.Assertions

  alias WooviSdk.HttpClientMock

  def mock_request(method, path, payload \\ nil, opts) do
    expect(HttpClientMock, :request, fn req_method, url, _headers, body, _req_opts ->
      assert String.upcase(to_string(method)) == req_method

      %URI{path: path_from_url, query: query_from_url} = URI.parse(url)
      assert path_from_url == path

      if query = opts[:query_params] do
        assert URI.encode_query(query) == query_from_url
      end

      if payload do
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
