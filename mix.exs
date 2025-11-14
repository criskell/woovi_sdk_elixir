defmodule WooviSdk.MixProject do
  use Mix.Project

  def project do
    [
      app: :woovi_sdk,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {WooviSdk.Application, []}
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.20", only: :test},
      {:jason, "~> 1.4", only: :test},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
