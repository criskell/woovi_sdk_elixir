defmodule WooviSdk.Client.TransactionTest do
  use WooviSdk.ApiCase, async: true
  import Mox
  import WooviSdk.Test.HttpMockHelpers

  alias WooviSdk.Client.Transaction

  test "get/2 returns a transaction", %{config: config} do
    transaction_id = "transaction_id"

    response = %{
      "transaction" => %{
        "customer" => %{
          "name" => "Dan",
          "email" => "email0@example.com",
          "phone" => "5511999999999",
          "taxID" => %{
            "taxID" => "31324227036",
            "type" => "BR:CPF"
          },
          "correlationID" => "9134e286-6f71-427a-bf00-241681624586"
        },
        "payer" => %{
          "name" => "Dan",
          "email" => "email0@example.com",
          "phone" => "5511999999999",
          "taxID" => %{
            "taxID" => "31324227036",
            "type" => "BR:CPF"
          },
          "correlationID" => "9134e286-6f71-427a-bf00-241681624586"
        },
        "charge" => %{
          "status" => "ACTIVE",
          "customer" => "603f81fcc6bccc24326ffb43",
          "correlationID" => "9134e286-6f71-427a-bf00-241681624586",
          "createdAt" => "2021-03-03T12:33:00.546Z",
          "updatedAt" => "2021-03-03T12:33:00.546Z"
        },
        "withdraw" => %{
          "value" => 100,
          "time" => "2021-03-03T12:33:00.536Z",
          "infoPagador" => "payer info 1",
          "endToEndId" => "E18236120202012032010s01345689XBY",
          "createdAt" => "2021-03-03T12:33:00.546Z"
        },
        "infoPagador" => "payer info 0",
        "value" => 100,
        "time" => "2021-03-03T12:33:00.536Z",
        "transactionID" => "transactionID",
        "type" => "PAYMENT",
        "endToEndId" => "E18236120202012032010s0133872GZA",
        "globalID" => "UGl4VHJhbnNhY3Rpb246NzE5MWYxYjAyMDQ2YmY1ZjUzZGNmYTBi",
        "creditParty" => %{
          "account" => %{
            "account" => "00000000000005469660",
            "accountType" => "CACC",
            "branch" => "8615"
          },
          "holder" => %{
            "name" => "CREDIT PARTY NAME",
            "nameFriendly" => "CREDIT PARTY NAME FRIENDLY",
            "taxID" => %{
              "taxID" => "28613271892",
              "type" => "BR:CPF"
            }
          },
          "psp" => %{
            "id" => "00000001",
            "name" => "BCO DO BRASIL S.A."
          }
        },
        "debitParty" => %{
          "account" => %{
            "account" => "1235678",
            "accountType" => "TRAN",
            "branch" => "1"
          },
          "holder" => %{
            "name" => "Awesome Company 1",
            "nameFriendly" => "Call me Awesome"
          },
          "psp" => %{
            "code" => "54811417",
            "id" => "FROZEN-ID",
            "name" => "WOOVI IP LTDA"
          }
        }
      }
    }

    mock_request(:get, "/api/v1/transaction/#{transaction_id}", nil, body: response)

    assert {:ok, ^response} = Transaction.get(config, transaction_id)
  end

  test "list/2 returns a page with transactions", %{config: config} do
    response = %{
      "pageInfo" => %{
        "skip" => 0,
        "limit" => 10,
        "totalCount" => 20,
        "hasPreviousPage" => false,
        "hasNextPage" => true
      },
      "transactions" => [
        %{
          "customer" => %{
            "name" => "Dan",
            "email" => "email0@example.com",
            "phone" => "5511999999999",
            "taxID" => %{
              "taxID" => "31324227036",
              "type" => "BR:CPF"
            },
            "correlationID" => "9134e286-6f71-427a-bf00-241681624586"
          },
          "payer" => %{
            "name" => "Dan",
            "email" => "email0@example.com",
            "phone" => "5511999999999",
            "taxID" => %{
              "taxID" => "31324227036",
              "type" => "BR:CPF"
            },
            "correlationID" => "9134e286-6f71-427a-bf00-241681624586"
          },
          "charge" => %{
            "status" => "ACTIVE",
            "customer" => "603f81fcc6bccc24326ffb43",
            "correlationID" => "9134e286-6f71-427a-bf00-241681624586",
            "createdAt" => "2021-03-03T12:33:00.546Z",
            "updatedAt" => "2021-03-03T12:33:00.546Z"
          },
          "withdraw" => %{
            "value" => 100,
            "time" => "2021-03-03T12:33:00.536Z",
            "infoPagador" => "payer info 1",
            "endToEndId" => "E18236120202012032010s01345689XBY"
          },
          "type" => "PAYMENT",
          "infoPagador" => "payer info 0",
          "value" => 100,
          "time" => "2021-03-03T12:33:00.536Z",
          "transactionID" => "transactionID",
          "endToEndId" => "E18236120202012032010s0133872GZA"
        }
      ]
    }

    mock_request(:get, "/api/v1/transaction", nil, body: response)

    assert {:ok, ^response} = Transaction.list(config)
  end

  test "list/2 sends query params", %{config: config} do
    opts = [
      start: "2025-11-21",
      charge: "charge_id"
    ]

    response_body = %{
      "status" => "ok",
      "transactions" => [],
      "pageInfo" => %{"hasNextPage" => false}
    }

    mock_request(:get, "/api/v1/transaction", nil, body: response_body, query_params: opts)

    assert {:ok, ^response_body} = Transaction.list(config, opts)
  end
end
