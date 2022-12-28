defmodule Teak.Document.Transformers.Defaults do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer
  alias Teak.Document.ResourceExtension

  def transform(dsl_state) do
    {:ok, id} =
      Transformer.build_entity(Ash.Resource.Dsl, [:attributes], :uuid_primary_key, name: :id)

    {:ok,
     dsl_state
     |> Transformer.add_entity([:attributes], id)
     |> add_timestamp_attributes
     |> add_audit_attributes
     |> add_owner_attribute
     |> add_default_list_action}
  end

  defp add_timestamp_attributes(dsl_state) do
    dsl_state =
      if ResourceExtension.create_timestamp?(dsl_state) do
        {:ok, created_at} =
          Transformer.build_entity(Ash.Resource.Dsl, [:attributes], :create_timestamp,
            name: :created_at
          )

        Transformer.add_entity(dsl_state, [:attributes], created_at)
      else
        dsl_state
      end

    if ResourceExtension.update_timestamp?(dsl_state) do
      {:ok, updated_at} =
        Transformer.build_entity(Ash.Resource.Dsl, [:attributes], :update_timestamp,
          name: :updated_at
        )

      Transformer.add_entity(dsl_state, [:attributes], updated_at)
    else
      dsl_state
    end
  end

  defp add_audit_attributes(dsl_state) do
    dsl_state =
      if ResourceExtension.audit_created_by?(dsl_state) do
        {:ok, created_by} =
          Transformer.build_entity(Ash.Resource.Dsl, [:attributes], :attribute,
            name: :created_by,
            type: :uuid,
            # destination: Teak.AccessControl.Authorization.User,
            allow_nil?: false
          )

        dsl_state = Transformer.add_entity(dsl_state, [:attributes], created_by)

        {:ok, set_created_by} =
          Transformer.build_entity(Ash.Resource.Dsl, [:changes], :change,
            on: [:create],
            only_when_valid?: true,
            change: Ash.Resource.Change.Builtins.set_attribute(:created_by, {:_actor, :id})
          )

        Transformer.add_entity(dsl_state, [:changes], set_created_by)
      else
        dsl_state
      end

    if ResourceExtension.audit_updated_by?(dsl_state) do
      {:ok, updated_by} =
        Transformer.build_entity(Ash.Resource.Dsl, [:attributes], :attribute,
          name: :updated_by,
          type: :uuid,
          # destination: Teak.AccessControl.Authorization.User,
          allow_nil?: true
        )

      dsl_state = Transformer.add_entity(dsl_state, [:attributes], updated_by)

      {:ok, change_updated_by} =
        Transformer.build_entity(Ash.Resource.Dsl, [:changes], :change,
          on: [:update],
          only_when_valid?: true,
          change: Ash.Resource.Change.Builtins.set_attribute(:updated_by, {:_actor, :id})
        )

      Transformer.add_entity(dsl_state, [:changes], change_updated_by)
    else
      dsl_state
    end
  end

  defp add_owner_attribute(dsl_state) do
    dsl_state =
      if ResourceExtension.has_owner?(dsl_state) do
        {:ok, owner} =
          Transformer.build_entity(Ash.Resource.Dsl, [:attributes], :attribute, name: :owner,
          type: :uuid,
          allow_nil?: false)

        dsl_state = Transformer.add_entity(dsl_state, [:attributes], owner)

        {:ok, set_owner} =
          Transformer.build_entity(Ash.Resource.Dsl, [:changes], :change,
            on: [:create],
            only_when_valid?: true,
            change: Ash.Resource.Change.Builtins.set_attribute(:owner, {:_actor, :id})
          )

        Transformer.add_entity(dsl_state, [:changes], set_owner)
      else
        dsl_state
      end
  end

  defp add_default_list_action(dsl_state) do
    case Transformer.get_entities(dsl_state, [:actions])
         |> Enum.find(fn action -> action.type == :read and action.name == :list end) do
      nil ->
        {:ok, pagination} =
          Transformer.build_entity(Ash.Resource.Dsl, [:actions, :read], :pagination,
            default_limit: 20,
            offset?: true,
            countable: true
          )

        {:ok, list_action} =
          Transformer.build_entity(Ash.Resource.Dsl, [:actions], :read,
            name: :list,
            pagination: [pagination]
          )

        Transformer.add_entity(dsl_state, [:actions], list_action)

      _ ->
        dsl_state
    end
  end
end
