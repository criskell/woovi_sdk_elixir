defmodule WooviSdk.Application do
  alias WooviSdk.Config
  use Application

  @impl true
  def start(_type, _args) do
    http_client = Config.http_client()

    children =
      if function_exported?(http_client, :child_spec, 0) do
        [http_client.child_spec()]
      else
        []
      end

    opts = [strategy: :one_for_one, name: WooviSdk.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
