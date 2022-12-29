defmodule Teak.Document.Customizations.Resource do
  @moduledoc "Customizations to add to existing resource"

  defstruct [:resource, attributes: [], actions: []]

  @schema [
    resource: [
      type: :atom,
      required: true,
      doc: "Resource to customize"
    ]
  ]

  def schema, do: @schema
end
