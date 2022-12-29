defmodule Teak.Document.Customizations do
  use Spark.Dsl, default_extensions: [
    extensions: [Teak.Document.Customizations.Dsl]
  ]

  @customizations Mix.Project.config()[:app] |> Application.compile_env(:document_customizations)

  def all(customization) do
    Spark.Dsl.Extension.get_entities(customization, [:customizations])
  end

  def resource(res) do
    # customizations = Mix.Project.config()[:app] |> Application.get_env(:document_customizations)
    case @customizations do
      nil ->
        nil
      customizations ->
        customizations
        |> Enum.flat_map(&all/1)
        |> Enum.find(&(&1.resource == res))
    end
  end
end
