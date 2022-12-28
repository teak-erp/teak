defmodule Teak.Document do
  defmacro __using__(opts) do
    quote do
      use Ash.Resource,
        data_layer: AshPostgres.DataLayer,
        authorizers: [Ash.Policy.Authorizer],
        extensions: [Teak.Document.ResourceExtension, Teak.Document.View]
    end
  end
end
