defmodule Teak.Document.Customizations.Dsl do
  @attribute %Spark.Dsl.Entity{
    name: :attribute,
    describe: """
    Add custom attribute on an existing resource.
    """,
    links: [],
    examples: [
      """
      attribute :name, :string do
        allow_nil? false
      end
      """
    ],
    transform: {Ash.Resource.Attribute, :transform, []},
    target: Ash.Resource.Attribute,
    args: [:name, :type],
    modules: [:type],
    schema: Ash.Resource.Attribute.attribute_schema()
  }

  @create %Spark.Dsl.Entity{
    name: :create,
    describe: """
    Declares a `create` action. For calling this action, see the `Ash.Api` documentation.
    """,
    examples: [
      """
      create :register do
        primary? true
      end
      """
    ],
    links: [
      guides: [
        "ash:guide:Actions"
      ]
    ],
    target: Ash.Resource.Actions.Create,
    schema: Ash.Resource.Actions.Create.opt_schema(),
    no_depend_modules: [:touches_resources],
    entities: [
      changes: [
        @action_change,
        @action_validate
      ],
      arguments: [
        @action_argument
      ],
      metadata: [
        @metadata
      ]
    ],
    args: [:name]
  }

  @read %Spark.Dsl.Entity{
    name: :read,
    describe: """
    Declares a `read` action. For calling this action, see the `Ash.Api` documentation.
    """,
    examples: [
      """
      read :read_all do
        primary? true
      end
      """
    ],
    target: Ash.Resource.Actions.Read,
    schema: Ash.Resource.Actions.Read.opt_schema(),
    transform: {Ash.Resource.Actions.Read, :transform, []},
    no_depend_modules: [:touches_resources],
    links: [
      guides: [
        "ash:guide:Actions"
      ]
    ],
    entities: [
      arguments: [
        @action_argument
      ],
      preparations: [
        @prepare
      ],
      pagination: [
        @pagination
      ]
    ],
    args: [:name]
  }

  @update %Spark.Dsl.Entity{
    name: :update,
    describe: """
    Declares a `update` action. For calling this action, see the `Ash.Api` documentation.
    """,
    examples: [
      "update :flag_for_review, primary?: true"
    ],
    links: [
      guides: [
        "ash:guide:Actions"
      ]
    ],
    entities: [
      changes: [
        @action_change,
        @action_validate
      ],
      metadata: [
        @metadata
      ],
      arguments: [
        @action_argument
      ]
    ],
    no_depend_modules: [:touches_resources],
    target: Ash.Resource.Actions.Update,
    schema: Ash.Resource.Actions.Update.opt_schema(),
    args: [:name]
  }

  @destroy %Spark.Dsl.Entity{
    name: :destroy,
    describe: """
    Declares a `destroy` action. For calling this action, see the `Ash.Api` documentation.
    """,
    examples: [
      """
      destroy :soft_delete do
        primary? true
      end
      """
    ],
    links: [
      guides: [
        "ash:guide:Actions"
      ]
    ],
    no_depend_modules: [:touches_resources],
    entities: [
      changes: [
        @action_change,
        @action_validate
      ],
      metadata: [
        @metadata
      ],
      arguments: [
        @action_argument
      ]
    ],
    target: Ash.Resource.Actions.Destroy,
    schema: Ash.Resource.Actions.Destroy.opt_schema(),
    args: [:name]
  }

  @customize %Spark.Dsl.Entity{
    name: :customize,
    describe: "Customize an existing resource",
    schema: Teak.Document.Customizations.Resource.schema(),
    target: Teak.Document.Customizations.Resource,
    args: [:resource],
    entities: [
      attributes: [@attribute],
      # actions: [@create, @read, @update, :destroy]
    ]
  }

  @customizations %Spark.Dsl.Section{
    name: :customizations,
    entities: [@customize]
  }

  @sections [@customizations]

  use Spark.Dsl.Extension,
    sections: @sections
end
