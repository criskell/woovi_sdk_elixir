defmodule WooviSdk.Client.ChargeTest do
  use ExUnit.Case, async: true
  import Mox

  alias WooviSdk.{Config, HttpClientMock}
  alias WooviSdk.Client.Charge

  @config %Config{access_token: "test_token", api_url: "https://api.woovi.com"}

  test "create/2 returns success" do
    payload = %{
      "correlationID" => "correlationID",
      "value" => 1000
    }

    HttpClientMock
    |> expect(:request, fn "POST", "https://api.woovi.com/v1/charges", _headers, body, _opts ->
      assert payload == Jason.decode!(body)

      {:ok,
       %{status: 201, body: Jason.encode!(%{"correlationID" => "correlationID"}), headers: []}}
    end)

    assert {:ok, %{"correlationID" => "correlationID"}} = Charge.create(@config, payload)
  end
end
