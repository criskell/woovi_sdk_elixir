defmodule WooviSdk.Client.ChargeTest do
  use WooviSdk.ApiCase, async: true
  import Mox
  import WooviSdk.Test.HttpMockHelpers

  alias WooviSdk.Client.Charge

  test "create/2 returns full charge response", %{config: config} do
    payload = %{
      "correlationID" => "9134e286-6f71-427a-bf00-241681624587",
      "value" => 100,
      "comment" => "good",
      "customer" => %{
        "name" => "Dan",
        "taxID" => "31324227036",
        "email" => "email0@example.com",
        "phone" => "5511999999999"
      },
      "additionalInfo" => [
        %{
          "key" => "Product",
          "value" => "Pencil"
        },
        %{
          "key" => "Invoice",
          "value" => "18476"
        },
        %{
          "key" => "Order",
          "value" => "302"
        }
      ]
    }

    response = %{
      "charge" => %{
        "status" => "ACTIVE",
        "customer" => %{
          "name" => "Dan",
          "email" => "email0@example.com",
          "phone" => "5511999999999",
          "taxID" => %{
            "taxID" => "31324227036",
            "type" => "BR:CPF"
          }
        },
        "value" => 100,
        "comment" => "good",
        "correlationID" => "9134e286-6f71-427a-bf00-241681624586",
        "paymentLinkID" => "7777a23s-6f71-427a-bf00-241681624586",
        "paymentLinkUrl" => "https://woovi.com/pay/9134e286-6f71-427a-bf00-241681624586",
        "qrCodeImage" =>
          "https://api.woovi.com/openpix/charge/brcode/image/9134e286-6f71-427a-bf00-241681624586.png",
        "expiresIn" => 2_592_000,
        "expiresDate" => "2021-04-01T17:28:51.882Z",
        "createdAt" => "2021-03-02T17:28:51.882Z",
        "updatedAt" => "2021-03-02T17:28:51.882Z",
        "brCode" =>
          "000201010212261060014br.gov.bcb.pix2584https://api.woovi.com/openpix/testing?transactionID=867ba5173c734202ac659721306b38c952040000530398654040.015802BR5909LOCALHOST6009Sao Paulo62360532867ba5173c734202ac659721306b38c963044BCA",
        "additionalInfo" => [
          %{
            "key" => "Product",
            "value" => "Pencil"
          },
          %{
            "key" => "Invoice",
            "value" => "18476"
          },
          %{
            "key" => "Order",
            "value" => "302"
          }
        ],
        "paymentMethods" => %{
          "pix" => %{
            "method" => "PIX_COB",
            "transactionID" => "9134e286-6f71-427a-bf00-241681624586",
            "identifier" => "9134e286-6f71-427a-bf00-241681624586",
            "additionalInfo" => [],
            "fee" => 50,
            "value" => 200,
            "status" => "ACTIVE",
            "txId" => "9134e286-6f71-427a-bf00-241681624586",
            "brCode" =>
              "000201010212261060014br.gov.bcb.pix2584https://api.woovi.com/openpix/testing?transactionID=867ba5173c734202ac659721306b38c952040000530398654040.015802BR5909LOCALHOST6009Sao Paulo62360532867ba5173c734202ac659721306b38c963044BCA",
            "qrCodeImage" =>
              "https://api.woovi.com/openpix/charge/brcode/image/9134e286-6f71-427a-bf00-241681624586.png"
          }
        }
      }
    }

    mock_request(
      :post,
      "/api/v1/charge",
      payload,
      status: 201,
      body: response
    )

    assert {:ok, _} = Charge.create(config, payload)
  end

  test "delete/2 deletes a charge successfully", %{config: config} do
    charge_id = "fe7834b4060c488a9b0f89811be5f5cf"

    response = %{
      "status" => "OK",
      "id" => "fe7834b4060c488a9b0f89811be5f5cf"
    }

    mock_request(
      :delete,
      "/api/v1/charge/#{charge_id}",
      nil,
      body: response
    )

    assert {:ok, _} = Charge.delete(config, charge_id)
  end

  test "get/2 returns charge data", %{config: config} do
    charge_id = "fe7834b4060c488a9b0f89811be5f5cf"

    response = %{
      "charge" => %{
        "status" => "ACTIVE",
        "customer" => %{
          "name" => "Dan",
          "email" => "email0@example.com",
          "phone" => "5511999999999",
          "taxID" => %{
            "taxID" => "31324227036",
            "type" => "BR:CPF"
          }
        },
        "value" => 100,
        "comment" => "good",
        "correlationID" => "9134e286-6f71-427a-bf00-241681624586",
        "paymentLinkID" => "7777-6f71-427a-bf00-241681624586",
        "paymentLinkUrl" => "https://woovi.com/pay/9134e286-6f71-427a-bf00-241681624586",
        "globalID" => "Q2hhcmdlOjcxOTFmMWIwMjA0NmJmNWY1M2RjZmEwYg==",
        "qrCodeImage" =>
          "https://api.woovi.com/openpix/charge/brcode/image/9134e286-6f71-427a-bf00-241681624586.png",
        "brCode" =>
          "000201010212261060014br.gov.bcb.pix2584https://api.woovi.com/openpix/testing?transactionID=867ba5173c734202ac659721306b38c952040000530398654040.015802BR5909LOCALHOST6009Sao Paulo62360532867ba5173c734202ac659721306b38c963044BCA",
        "additionalInfo" => [
          %{
            "key" => "Product",
            "value" => "Pencil"
          },
          %{
            "key" => "Invoice",
            "value" => "18476"
          },
          %{
            "key" => "Order",
            "value" => "302"
          }
        ],
        "expiresIn" => 2_592_000,
        "expiresDate" => "2021-04-01T17:28:51.882Z",
        "createdAt" => "2021-03-02T17:28:51.882Z",
        "updatedAt" => "2021-03-02T17:28:51.882Z",
        "paymentMethods" => %{
          "pix" => %{
            "method" => "PIX_COB",
            "transactionID" => "9134e286-6f71-427a-bf00-241681624586",
            "identifier" => "9134e286-6f71-427a-bf00-241681624586",
            "additionalInfo" => [],
            "fee" => 50,
            "value" => 200,
            "status" => "ACTIVE",
            "txId" => "9134e286-6f71-427a-bf00-241681624586",
            "brCode" =>
              "000201010212261060014br.gov.bcb.pix2584https://api.woovi.com/openpix/testing?transactionID=867ba5173c734202ac659721306b38c952040000530398654040.015802BR5909LOCALHOST6009Sao Paulo62360532867ba5173c734202ac659721306b38c963044BCA",
            "qrCodeImage" =>
              "https://api.woovi.com/openpix/charge/brcode/image/9134e286-6f71-427a-bf00-241681624586.png"
          }
        }
      }
    }

    mock_request(
      :get,
      "/api/v1/charge/#{charge_id}",
      nil,
      body: response
    )

    assert {:ok, _} = Charge.get(config, charge_id)
  end

  test "list/2 returns charge list with items and page info", %{config: config} do
    response = %{
      "pageInfo" => %{
        "skip" => 0,
        "limit" => 10,
        "totalCount" => 1,
        "hasPreviousPage" => false,
        "hasNextPage" => false
      },
      "charges" => [
        %{
          "status" => "ACTIVE",
          "customer" => %{
            "name" => "Dan",
            "email" => "email0@example.com",
            "phone" => "5511999999999",
            "taxID" => %{
              "taxID" => "31324227036",
              "type" => "BR:CPF"
            }
          },
          "value" => 100,
          "comment" => "good",
          "correlationID" => "9134e286-6f71-427a-bf00-241681624586",
          "paymentLinkID" => "7777a23s-6f71-427a-bf00-241681624586",
          "paymentLinkUrl" => "https://woovi.com/pay/9134e286-6f71-427a-bf00-241681624586",
          "qrCodeImage" =>
            "https://api.woovi.com/openpix/charge/brcode/image/9134e286-6f71-427a-bf00-241681624586.png",
          "brCode" =>
            "000201010212261060014br.gov.bcb.pix2584https://api.woovi.com/openpix/testing?transactionID=867ba5173c734202ac659721306b38c952040000530398654040.015802BR5909LOCALHOST6009Sao Paulo62360532867ba5173c734202ac659721306b38c963044BCA",
          "additionalInfo" => [
            %{
              "key" => "Product",
              "value" => "Pencil"
            },
            %{
              "key" => "Invoice",
              "value" => "18476"
            },
            %{
              "key" => "Order",
              "value" => "302"
            }
          ],
          "expiresIn" => 2_592_000,
          "expiresDate" => "2021-04-01T17:28:51.882Z",
          "createdAt" => "2021-03-02T17:28:51.882Z",
          "updatedAt" => "2021-03-02T17:28:51.882Z",
          "paymentMethods" => %{
            "pix" => %{
              "method" => "PIX_COB",
              "transactionID" => "9134e286-6f71-427a-bf00-241681624586",
              "identifier" => "9134e286-6f71-427a-bf00-241681624586",
              "additionalInfo" => [],
              "fee" => 50,
              "value" => 200,
              "status" => "ACTIVE",
              "txId" => "9134e286-6f71-427a-bf00-241681624586",
              "brCode" =>
                "000201010212261060014br.gov.bcb.pix2584https://api.woovi.com/openpix/testing?transactionID=867ba5173c734202ac659721306b38c952040000530398654040.015802BR5909LOCALHOST6009Sao Paulo62360532867ba5173c734202ac659721306b38c963044BCA",
              "qrCodeImage" =>
                "https://api.woovi.com/openpix/charge/brcode/image/9134e286-6f71-427a-bf00-241681624586.png"
            }
          }
        }
      ]
    }

    mock_request(:get, "/api/v1/charge", nil, body: response)

    assert {:ok, %{"charges" => charges, "pageInfo" => page_info}} = Charge.list(config)

    assert length(charges) == 1

    assert hd(charges)["status"] == "ACTIVE"
    assert page_info["limit"] == 10
    assert page_info["totalCount"] == 1
  end

  test "download_qr_code_image/3 returns image binary", %{config: config} do
    image_binary = <<1, 2, 3, 4, 5>>

    mock_request(
      :get,
      "/openpix/charge/brcode/image/charge-id.png",
      nil,
      query_params: [size: "738"],
      body: image_binary,
      headers: [{"content-type", "image/png"}]
    )

    assert {:ok, ^image_binary} =
             Charge.download_qr_code_image(config, "charge-id", 738)
  end

  test "download_qr_code_image/3 errors when size < 600", %{config: config} do
    assert {:error, msg} = Charge.download_qr_code_image(config, "charge-id", 500)
    assert msg =~ ">= 600"
  end

  test "download_qr_code_image/3 errors when size > 4096", %{config: config} do
    assert {:error, msg} = Charge.download_qr_code_image(config, "charge-id", 5000)
    assert msg =~ "<= 4096"
  end

  test "get_qr_code_base64_encoded/3 returns base64 encoded PNG image with data URL format", %{
    config: config
  } do
    response_body = %{imageBase64: "image-base-64"}

    mock_request(
      :get,
      "/api/image/qrcode/base64/charge-id",
      nil,
      query_params: [size: "738"],
      body: response_body,
      headers: [{"content-type", "image/png"}]
    )

    assert {:ok, "image-base-64"} = Charge.get_qr_code_base64_encoded(config, "charge-id", 738)
  end

  test "get_qr_code_base64_encoded/3 errors when size < 600", %{config: config} do
    assert {:error, msg} = Charge.get_qr_code_base64_encoded(config, "charge-id", 500)
    assert msg =~ ">= 600"
  end

  test "get_qr_code_base64_encoded/3 errors when size > 4096", %{config: config} do
    assert {:error, msg} = Charge.get_qr_code_base64_encoded(config, "charge-id", 5000)
    assert msg =~ "<= 4096"
  end

  test "patch_charge/3 should allow editing expiration date of a charge", %{config: config} do
    payload = %{
      "expiresDate" => "2021-04-01T17:28:51.882Z"
    }

    response = %{
      "charge" => %{
        "status" => "ACTIVE",
        "customer" => %{
          "name" => "Dan",
          "email" => "email0@example.com",
          "phone" => "5511999999999",
          "taxID" => %{
            "taxID" => "31324227036",
            "type" => "BR:CPF"
          }
        },
        "value" => 100,
        "comment" => "good",
        "correlationID" => "9134e286-6f71-427a-bf00-241681624586",
        "paymentLinkID" => "7777a23s-6f71-427a-bf00-241681624586",
        "paymentLinkUrl" => "https://woovi.com/pay/9134e286-6f71-427a-bf00-241681624586",
        "qrCodeImage" =>
          "https://api.woovi.com/openpix/charge/brcode/image/9134e286-6f71-427a-bf00-241681624586.png",
        "expiresIn" => 2_592_000,
        "expiresDate" => "2021-04-01T17:28:51.882Z",
        "createdAt" => "2021-03-02T17:28:51.882Z",
        "updatedAt" => "2021-03-02T17:28:51.882Z",
        "brCode" =>
          "000201010212261060014br.gov.bcb.pix2584https://api.woovi.com/openpix/testing?transactionID=867ba5173c734202ac659721306b38c952040000530398654040.015802BR5909LOCALHOST6009Sao Paulo62360532867ba5173c734202ac659721306b38c963044BCA",
        "additionalInfo" => [
          %{
            "key" => "Product",
            "value" => "Pencil"
          },
          %{
            "key" => "Invoice",
            "value" => "18476"
          },
          %{
            "key" => "Order",
            "value" => "302"
          }
        ],
        "paymentMethods" => %{
          "pix" => %{
            "method" => "PIX_COB",
            "transactionID" => "9134e286-6f71-427a-bf00-241681624586",
            "identifier" => "9134e286-6f71-427a-bf00-241681624586",
            "additionalInfo" => [],
            "fee" => 50,
            "value" => 200,
            "status" => "ACTIVE",
            "txId" => "9134e286-6f71-427a-bf00-241681624586",
            "brCode" =>
              "000201010212261060014br.gov.bcb.pix2584https://api.woovi.com/openpix/testing?transactionID=867ba5173c734202ac659721306b38c952040000530398654040.015802BR5909LOCALHOST6009Sao Paulo62360532867ba5173c734202ac659721306b38c963044BCA",
            "qrCodeImage" =>
              "https://api.woovi.com/openpix/charge/brcode/image/9134e286-6f71-427a-bf00-241681624586.png"
          }
        }
      }
    }

    mock_request(
      :patch,
      "/api/v1/charge/charge-id",
      payload,
      body: response
    )

    assert {:ok, _} = Charge.patch(config, "charge-id", payload)
  end
end
