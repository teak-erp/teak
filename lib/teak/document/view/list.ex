defmodule Teak.Document.View.List do
  @moduledoc "A UI representation of a list table inside form to manage related records"
  defstruct [
    :resource,
    :label,
    colspan: 1,
    rowspan: 1
  ]
  
  @schema [
    resource: [
      type: :atom,
      required: true,
      doc: "Resource to be displayed in the list"
    ],
    label: [
      type: :string,
      required: true,
      doc: "User friendly label"
    ],
    colspan: [
      type: :integer,
      doc: "Field size relative to parent grid columns"
    ],
    rowspan: [
      type: :integer,
      doc: "Field size relative to parent grid rows"
    ]
  ]

  def list_schema, do: @schema
end
