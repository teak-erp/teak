defmodule Teak.Test.HelpersTest do
  @moduledoc false
  use ExUnit.Case, async: true

  describe "Underscore to display name" do
    test "From atom" do
      result = Teak.Helpers.underscore_to_display_name(:system_user)
      assert result == "System User"
    end

    test "From string" do
      result = Teak.Helpers.underscore_to_display_name("full_name")
      assert result == "Full Name"
    end
  end

  describe "Camelcase to display name" do
    test "From atom" do
      result = Teak.Helpers.camelcase_to_display_name(:"SystemUser")
      assert result == "System User"
    end

    test "From string" do
      result = Teak.Helpers.camelcase_to_display_name("SystemUser")
      assert result == "System User"
    end

    test "From dotted namespace" do
      result = Teak.Helpers.camelcase_to_display_name("Teak.Auth.SystemUser")
      assert result == "Teak Auth System User"
    end

    test "From acronym" do
      result = Teak.Helpers.camelcase_to_display_name("LDAPUser")
      assert result == "LDAP User"
    end
  end
end
