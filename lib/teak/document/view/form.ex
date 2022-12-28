defmodule Teak.Document.View.Form do
  @moduledoc "A view representing how a resource action should be displayed on a form"

  defstruct [
    :title,
    :action_type,
    :action,
    contents: []
  ]

  @schema [
    title: [
      type: :string,
      required: true,
      doc: "User friendly title of the form"
    ],
    action_type: [
      type: {:in, [:create, :update]},
      required: true,
      doc: "Action type is `:create` or `:update`"
    ],
    action: [
      type: :atom,
      required: true,
      doc: "`:create` or `:update` action name"
    ]
  ]

  def form_schema, do: @schema
end
