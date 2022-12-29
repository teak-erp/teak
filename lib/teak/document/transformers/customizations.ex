defmodule Teak.Document.Transformers.Customizations do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  import Teak.Document.Customizations

  # def after?(Teak.Document.Transformers.Defaults), do: true

  def transform(dsl_state) do
    case resource(Transformer.get_persisted(dsl_state, :module) |> IO.inspect(label: "Cust"))  do
      nil ->
        {:ok, dsl_state}
      customization ->
        dsl_state = customization.attributes
          |> Enum.reduce(dsl_state, fn attr, acc ->
              Transformer.add_entity(acc, [:attributes], attr)
            end)
        {:ok, dsl_state}
    end
  end
end
