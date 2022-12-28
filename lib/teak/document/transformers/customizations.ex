defmodule Teak.Document.Transformers.Customizations do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  # import Teak.Core.DocumentCustomization

  # def after?(Teak.Document.Transformers.Defaults), do: true

  # def transform(dsl_state) do
  #   case for_resource(Transformer.get_persisted(dsl_state, :module)) do
  #     nil ->
  #       {:ok, dsl_state}
  #     customization ->
  #       dsl_state = attributes(customization)
  #       |> Enum.reduce(dsl_state, fn attr, acc ->
  #           Transformer.add_entity(acc, [:attributes], attr)
  #         end)
  #       {:ok, dsl_state}
  #   end
  # end
end
