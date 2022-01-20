defmodule DynHacks.MixProject do
  use Mix.Project

  def project do
    [
      app: :dyn_hacks,
      description: "Exploiting the fact that Elixir is unityped",
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  def package do
  [
    licenses: ["WTFPL"],
    links: %{
      "Github" => "https://github.com/doma-engineering/dyn_hacks",
      "Support" => "https://social.doma.dev/@jonn",
      "Matrix" => "https://matrix.to/#/#uptight:matrix.org"
    }
  ]
  end
end
