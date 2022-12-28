defmodule Teak.Document.View.Grid do
  @moduledoc "A UI section with a title that contains a set of fields"

  defstruct [
    size: 1,
    orientation: :row,
    contents: [] 
  ]

  @schema [
    size: [
      type: :integer,
    ],
    orientation: [
      type: { :in, [:row, :col] }
    ]
  ]

  def grid_schema, do: @schema
end
