defmodule Teak.Document.View.Section do
  @moduledoc "A UI section with a title that contains a set of fields"

  defstruct [
    :title,
    size: 1,
    orientation: :row,
    contents: []
  ]

  @schema [
    title: [
      type: :string,
      required: true,
    ],
    size: [
      type: :integer,
    ],
    orientation: [
      type: { :in, [:row, :col] }
    ]
  ]

  def section_schema, do: @schema
end
