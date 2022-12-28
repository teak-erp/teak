defmodule Teak.Document.View do
  @field %Spark.Dsl.Entity{
    name: :field,
    args: [:name, :label],
    schema: Teak.Document.View.Field.field_schema(),
    target: Teak.Document.View.Field
  }

  @list %Spark.Dsl.Entity{
    name: :list,
    args: [:resource, :label],
    schema: Teak.Document.View.List.list_schema(),
    target: Teak.Document.View.List
  }

  @field_entities [@field, @list]

  @section %Spark.Dsl.Entity{
    name: :section,
    schema: Teak.Document.View.Section.section_schema(),
    target: Teak.Document.View.Section,
    args: [:title],
    entities: [contents: @field_entities]
  }

  @grid %Spark.Dsl.Entity{
    name: :grid,
    schema: Teak.Document.View.Grid.grid_schema(),
    target: Teak.Document.View.Grid,
    args: [:size, :orientation],
    recursive_as: :contents,
    entities: [contents: [@section] ++ @field_entities]
  }

  @form %Spark.Dsl.Entity{
    name: :form,
    describe: "A form view for a specific resource's `create` or `update` action",
    schema: Teak.Document.View.Form.form_schema(),
    target: Teak.Document.View.Form,
    args: [:title, :action_type, :action],
    entities: [contents: [@grid, @section] ++ @field_entities]
  }

  @forms %Spark.Dsl.Section {
    name: :forms,
    describe: "Configure custom form views by resource's `create` and `update` action",
    entities: [@form]
  }


  @moduledoc """
  An API extension to display as a module UI

  Table of Contents:
  #{Spark.Dsl.Extension.doc_index([@forms])}

  DSL Docs:

  #{Spark.Dsl.Extension.doc([@forms])}
  """

  use Spark.Dsl.Extension, sections: [@forms]

  def form_views(resource) do
    Spark.Dsl.Extension.get_entities(resource, [:forms])
  end

  def form_view(resource, action) do
    form_views(resource) |> Enum.find(& &1.action == action)
  end
end
