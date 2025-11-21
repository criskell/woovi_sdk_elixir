defmodule WooviSdk.Client.SubaccountTest do
  use WooviSdk.ApiCase, async: true
  import Mox
  import WooviSdk.Test.HttpMockHelpers

  alias WooviSdk.Client.Subaccount

  test "get/2 returns a subaccount", %{config: config} do
    pix_key = "c4249323-b4ca-43f2-8139-8232aab09b93"

    response = %{
      "SubAccount" => %{
        "name" => "test-sub-account",
        "pixKey" => pix_key,
        "balance" => 100
      }
    }

    mock_request(:get, "/api/v1/subaccount/#{pix_key}", nil, body: response)

    assert {:ok, ^response} = Subaccount.get(config, pix_key)
  end

  test "list/2 returns paginated subaccounts", %{config: config} do
    response = %{
      "subAccounts" => [
        %{
          "name" => "test-sub-account",
          "pixKey" => "c4249323-b4ca-43f2-8139-8232aab09b93",
          "balance" => 100
        }
      ],
      "pageInfo" => %{
        "skip" => 0,
        "limit" => 10,
        "totalCount" => 20,
        "hasPreviousPage" => false,
        "hasNextPage" => true
      }
    }

    mock_request(:get, "/api/v1/subaccount", nil, body: response)

    assert {:ok, ^response} = Subaccount.list(config)
  end

  test "list/2 sends query params", %{config: config} do
    opts = [skip: 10, limit: 20]

    response = %{
      "subAccounts" => [],
      "pageInfo" => %{
        "skip" => 10,
        "limit" => 20,
        "totalCount" => 0,
        "hasPreviousPage" => false,
        "hasNextPage" => false
      }
    }

    mock_request(:get, "/api/v1/subaccount", nil, body: response, query_params: opts)

    assert {:ok, ^response} = Subaccount.list(config, opts)
  end

  test "delete/2 deletes a subaccount successfully", %{config: config} do
    pix_key = "c4249323-b4ca-43f2-8139-8232aab09b93"

    response = %{
      "status" => "OK",
      "pixKey" => "destination@test.com"
    }

    mock_request(:delete, "/api/v1/subaccount/#{pix_key}", nil, body: response)

    assert {:ok, ^response} = Subaccount.delete(config, pix_key)
  end

  test "create/2 sends correct payload and returns subaccount", %{config: config} do
    payload = %{
      "pixKey" => "c4249323-b4ca-43f2-8139-8232aab09b93",
      "name" => "test-sub-account"
    }

    response = %{
      "SubAccount" => payload
    }

    mock_request(:post, "/api/v1/subaccount", payload, body: response)

    assert {:ok, ^response} = Subaccount.create(config, payload)
  end

  test "withdraw/3 makes a withdraw from a sub account", %{config: config} do
    pix_key = "c4249323-b4ca-43f2-8139-8232aab09b93"

    payload = %{
      "value" => 1000
    }

    response = %{
      "transaction" => %{
        "status" => "CREATED",
        "value" => 100,
        "endToEndId" => "ENDTOEND_1234567890",
        "correlationID" => "TESTING123",
        "destinationAlias" => "pixKeyTest@test.com",
        "comment" => "testing-transaction"
      }
    }

    mock_request(:post, "/api/v1/subaccount/#{pix_key}/withdraw", payload, body: response)

    assert {:ok, ^response} = Subaccount.withdraw(config, pix_key, payload)
  end

  test "debit/3 debits from a subaccount and returns the debit response", %{config: config} do
    pix_key = "subaccount@test.com"

    payload = %{
      "value" => 50,
      "description" => "Monthly payment"
    }

    response = %{
      "pixKey" => "subaccount@test.com",
      "value" => 50,
      "description" => "Monthly payment",
      "success" => "Sub-account withdrawal has been successfully debited, 50"
    }

    mock_request(:post, "/api/v1/subaccount/#{pix_key}/debit", payload, body: response)

    assert {:ok, ^response} = Subaccount.debit(config, pix_key, payload)
  end

  test "transfer/2 transfers between subaccounts and returns the transfer response", %{
    config: config
  } do
    payload = %{
      "value" => 65,
      "fromPixKey" => "c4249323-b4ca-43f2-8139-874baab09b93",
      "fromPixKeyType" => "RANDOM",
      "toPixKey" => "3143da48-2bc7-49a4-89bd-4e22f73bfb0c",
      "toPixKeyType" => "RANDOM"
    }

    response = %{
      "value" => 65,
      "destinationSubaccount" => %{
        "name" => "test-sub-account-1",
        "pixKey" => "c4249323-b4ca-43f2-8139-874baab09b93",
        "balance" => 100
      },
      "originSubaccount" => %{
        "name" => "test-sub-account-2",
        "pixKey" => "3143da48-2bc7-49a4-89bd-4e22f73bfb0c",
        "balance" => 100
      }
    }

    mock_request(:post, "/api/v1/subaccount/transfer", payload, body: response)

    assert {:ok, ^response} = Subaccount.transfer(config, payload)
  end
end
