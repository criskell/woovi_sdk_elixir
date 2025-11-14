defmodule WooviSdk.Client.CustomerTest do
  use ExUnit.Case, async: true
  import Mox

  alias WooviSdk.{Config, HttpClientMock}
  alias WooviSdk.Client.Customer

  @config %Config{access_token: "test_token", api_url: "https://api.woovi.com"}

  test "create/2 returns success" do
    payload = %{
      "name" => "Dan"
    }

    HttpClientMock
    |> expect(:request, fn "POST", "https://api.woovi.com/v1/customers", _headers, body, _opts ->
      assert payload == Jason.decode!(body)

      {:ok,
       %{
         status: 201,
         body: Jason.encode!(%{"customer" => %{"name" => "Dan"}}),
         headers: []
       }}
    end)

    assert {:ok, %{"customer" => %{"name" => "Dan"}}} = Customer.create(@config, payload)
  end
end
