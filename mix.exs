defmodule NervesFlutterpi.MixProject do
  use Mix.Project

  def project do
    [
      app: :nerves_flutterpi,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:muontrap, "~> 1.2.0"},
      {:nimble_options, "~> 0.5.0"},
      {:wait_for_it, "~>2.1.0"}
    ]
  end
end
