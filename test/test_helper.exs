ExUnit.start()
Mox.defmock(WooviSdk.HttpClientMock, for: WooviSdk.HttpClient)
Application.put_env(:woovi_sdk, :http_client, WooviSdk.HttpClientMock)
Application.put_env(:woovi_sdk, :json_library, Jason)
