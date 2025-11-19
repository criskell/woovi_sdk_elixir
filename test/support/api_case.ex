defmodule WooviSdk.ApiCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Mox
      alias WooviSdk.Config

      setup :verify_on_exit!

      setup_all do
        config = %Config{
          access_token: "test_token",
          api_url: "https://api.woovi.com"
        }

        {:ok, config: config}
      end
    end
  end
end
