defmodule WooviSdk.Client.CustomerTest do
  use WooviSdk.ApiCase, async: true
  import Mox
  import WooviSdk.Test.HttpMockHelpers

  alias WooviSdk.{Config, HttpClientMock}
  alias WooviSdk.Client.Customer

  @config %Config{access_token: "test_token", api_url: "https://api.woovi.com"}

  test "get/2 returns a customer", %{config: config} do
    customer_id = "fe7834b4060c488a9b0f89811be5f5cf"

    response = %{
      "customer" => %{
        "name" => "Dan",
        "email" => "email0@example.com",
        "phone" => "5511999999999",
        "taxID" => %{
          "taxID" => "31324227036",
          "type" => "BR:CPF"
        },
        "correlationID" => customer_id
      }
    }

    mock_request(:get, "/api/v1/customer/#{customer_id}", nil, body: response)

    assert {:ok, ^response} = Customer.get(config, customer_id)
  end

  test "list/2 returns customer list and pageInfo", %{config: config} do
    response = %{
      "pageInfo" => %{
        "skip" => 0,
        "limit" => 10,
        "totalCount" => 20,
        "hasPreviousPage" => false,
        "hasNextPage" => true
      },
      "customers" => %{
        "customer" => %{
          "name" => "Dan",
          "email" => "email0@example.com",
          "phone" => "5511999999999",
          "taxID" => %{
            "taxID" => "31324227036",
            "type" => "BR:CPF"
          }
        }
      }
    }

    mock_request(:get, "/api/v1/customer", nil, body: response)

    assert {:ok, ^response} = Customer.list(config)
  end

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

  test "update/2 sends correct payload to endpoint and returns parsed response", %{config: config} do
    customer_id = "customer_id"

    payload = %{
      "name" => "Dan",
      "email" => "email0@example.com",
      "phone" => "5511999999999",
      "address" => %{
        "zipcode" => "30421322",
        "street" => "Street",
        "number" => "100",
        "neighborhood" => "Neighborhood",
        "city" => "Belo Horizonte",
        "state" => "MG",
        "complement" => "APTO",
        "country" => "BR"
      }
    }

    response = %{
      "customer" => %{
        "name" => "Dan",
        "email" => "email0@example.com",
        "phone" => "5511999999999",
        "taxID" => %{
          "taxID" => "31324227036",
          "type" => "BR:CPF"
        },
        "address" => %{
          "zipcode" => "30421322",
          "street" => "Street",
          "number" => "100",
          "neighborhood" => "Neighborhood",
          "city" => "Belo Horizonte",
          "state" => "MG",
          "complement" => "APTO",
          "country" => "BR"
        }
      }
    }

    mock_request(:patch, "/api/v1/customer/#{customer_id}", nil, body: response)

    assert {:ok, ^response} = Customer.update(config, customer_id, payload)
  end
end
