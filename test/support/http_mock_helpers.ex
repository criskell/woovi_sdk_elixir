defmodule WooviSdk.Test.HttpMockHelpers do
  import Mox
  import ExUnit.Assertions

  alias WooviSdk.HttpClientMock

  def mock_request(method, path, payload \\ nil, opts) do
    expect(HttpClientMock, :request, fn req_method, url, _headers, body, req_opts ->
      assert String.upcase(to_string(method)) == req_method

      assert url_ends_with?(url, path)

      if query = opts[:query] do
        assert Keyword.equal?(req_opts[:query], query)
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

  defp url_ends_with?(url, path) do
    String.ends_with?(url, path)
  end
end
