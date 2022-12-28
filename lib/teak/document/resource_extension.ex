defmodule Teak.Document.ResourceExtension do
  @document %Spark.Dsl.Section{
    name: :document,
    describe: "Configure the resource as a Teak document",
    schema: [
      name: [
        type: :string,
        doc: "Default user friendly name of the document"
      ],
      description: [
        type: :string,
        doc: "Default description of a document to be shown in frontend"
      ],
      create_timestamp?: [
        type: :boolean,
        doc: "Set false to skip adding create timestamp",
        default: true
      ],
      update_timestamp?: [
        type: :boolean,
        doc: "Set false to skip adding update timestamp",
        default: true
      ],
      field_names: [
        type: {:map, :atom, :string},
        doc: "Default user friendly label maps for attributes and arguments"
      ],
      action_names: [
        type: {:map, :atom, :string},
        doc: "Default user friendly names for actions"
      ],
      audit_created_by?: [
        type: :boolean,
        doc: "Set false to skip adding created_by field",
        default: true
      ],
      audit_updated_by?: [
        type: :boolean,
        doc: "Set false to skip adding updated_by field",
        default: true
      ],
      has_owner?: [
        type: :boolean,
        doc: "Set true to add 'owner' field to track record ownership",
        default: false
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@document],
    transformers: [
      Teak.Document.Transformers.Defaults,
      # Teak.Document.Transformers.Customizations
    ]

  @moduledoc """
  An API extension to make resource a Teak document
  
  Table of Contents:
  #{Spark.Dsl.Extension.doc_index([@document])}
  
  DSL Docs:
  
  #{Spark.Dsl.Extension.doc([@document])}
  """

  def name(resource) do
    Spark.Dsl.Extension.get_opt(resource, [:document], :name, nil, true) || default_name(resource)
  end

  defp default_name(resource) do
    resource
    |> Module.split()
    |> List.last()
    |> Teak.Helpers.camelcase_to_display_name()
  end

  def description(resource) do
    Spark.Dsl.Extension.get_opt(resource, [:document], :description, nil, true)
  end

  # def list_attributes(resource) do
  #   attributes = Ash.Resource.Info.attributes(resource)
  #   case Spark.Dsl.Extension.get_opt(resource, [:document], :list_attributes, nil, true) do
  #     nil ->
  #       attributes
  #     list_attrs ->
  #       Enum.filter(attributes, &(&1.name in list_attrs))
  #   end
  # end

  def create_timestamp?(resource) do
    Spark.Dsl.Extension.get_opt(resource, [:document], :create_timestamps?, true)
  end

  def update_timestamp?(resource) do
    Spark.Dsl.Extension.get_opt(resource, [:document], :update_timestamps?, true)
  end

  def audit_created_by?(resource) do
    Spark.Dsl.Extension.get_opt(resource, [:document], :audit_created_by?, true)
  end

  def audit_updated_by?(resource) do
    Spark.Dsl.Extension.get_opt(resource, [:document], :audit_updated_by?, true)
  end

  def has_owner?(resource) do
    Spark.Dsl.Extension.get_opt(resource, [:document], :has_owner?, false)
  end

  def field_names(resource) do
    attr_names = Spark.Dsl.Extension.get_opt(resource, [:document], :field_names, %{})

    Ash.Resource.Info.attributes(resource)
    |> Enum.reduce(attr_names, &user_friendly_name/2)
  end

  def action_names(resource) do
    names = Spark.Dsl.Extension.get_opt(resource, [:document], :action_names, %{})

    Ash.Resource.Info.actions(resource)
    |> Enum.reduce(names, &user_friendly_name/2)
  end

  defp user_friendly_name(arg, acc) do
    Map.put_new_lazy(acc, arg.name, fn -> Teak.Helpers.underscore_to_display_name(arg.name) end)
  end
end
