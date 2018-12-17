defmodule PacketApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :packet_api,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :tesla]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "1.1.2"},
      {:tesla, "1.2.1"}
    ]
  end
end
