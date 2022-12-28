defmodule Teak.Test.Document.ResourceExtensionTest do
  @moduledoc false
  use ExUnit.Case, async: true

  defmodule TestRepo do
    use AshPostgres.Repo, otp_app: :teak
  end

  defmodule DocumentResource do
    use Teak.Document

    postgres do
      repo TestRepo
      table "document_resource"
    end

    document do
      name "Doc Resource"
      description "Test Document Resource"

      audit_updated_by? false

      field_names %{created_at: "Created On", updated_at: "Modified On"}
      action_names %{list: "List by page"}
    end
  end

  defmodule OwnedDocument do
    use Teak.Document
    
    postgres do
      repo TestRepo
      table "owned_document"
    end

    document do
      has_owner? true
    end
  end

  defmodule Registry do
    use Ash.Registry

    entries do
      entry DocumentResource
    end
  end

  defmodule Api do
    use Ash.Api

    resources do
      registry Registry
    end
  end

  describe "document DSL tests" do
    test "document display properties" do
      assert "Doc Resource" == Teak.Document.ResourceExtension.name(DocumentResource)
      assert "Test Document Resource" == Teak.Document.ResourceExtension.description(DocumentResource)

      assert "Modified On" == Teak.Document.ResourceExtension.field_names(DocumentResource).updated_at
      assert "Created On" == Teak.Document.ResourceExtension.field_names(DocumentResource).created_at

      assert "List by page" == Teak.Document.ResourceExtension.action_names(DocumentResource).list
    end

    test "audit fields" do
      assert nil != Ash.Resource.Info.attribute(DocumentResource, :created_at)
      assert nil != Ash.Resource.Info.attribute(DocumentResource, :updated_at)

      assert nil == Ash.Resource.Info.attribute(DocumentResource, :updated_by)
      assert nil != Ash.Resource.Info.attribute(DocumentResource, :created_by)

      assert nil != Ash.Resource.Info.attribute(OwnedDocument, :owner)
    end

  end

end
