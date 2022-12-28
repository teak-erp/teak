defmodule Teak.Document.View.Field do
  @moduledoc "A UI representation of an attribute or an argument of form action"
  defstruct [
    :name,
    :label,
    colspan: 1,
    rowspan: 1
  ]
  
  @schema [
    name: [
      type: :atom,
      required: true,
      doc: "Attribute or argument name"
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

  def field_schema, do: @schema
end
