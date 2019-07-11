defmodule ToyRobot.MixProject do
  use Mix.Project

  def project do
    [
      app: :toy_robot,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {ToyRobot, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
    ]
  end

defp aliases do
    [
    test: "test --no-start"
    ]
    end
end
