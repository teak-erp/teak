defmodule Teak.Helpers do
  def underscore_to_display_name(name) when is_atom(name) do
    Atom.to_string(name) |> underscore_to_display_name
  end

  def underscore_to_display_name(name) when is_bitstring(name) do
    String.split(name, "_")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join(" ")
  end

  def camelcase_to_display_name(name) when is_atom(name) do
    Atom.to_string(name) |> camelcase_to_display_name
  end

  def camelcase_to_display_name(<<h, rest::binary>>) do
    <<h>> <> do_camelcase_to_display_name(rest, h)
  end

  defp do_camelcase_to_display_name(<<h, t, rest::binary>>, _)
    when h >= ?A and h <= ?Z and not (t >= ?A and t <= ?Z) and not (t >= ?0 and t <= ?9) and
                t != ?. and t != ?_ do
   <<?\s, h, t>> <> do_camelcase_to_display_name(rest, t)
  end

  defp do_camelcase_to_display_name(<<h, t::binary>>, prev)
   when h >= ?A and h <= ?Z and not (prev >= ?A and prev <= ?Z) and prev != ?\s do
      <<?\s, h>> <> do_camelcase_to_display_name(t, h)
  end

  defp do_camelcase_to_display_name(<<?., t::binary>>, _) do
    <<?\s>> <> camelcase_to_display_name(t)
  end

  defp do_camelcase_to_display_name(<<h, t::binary>>, _) do
    <<h>> <> do_camelcase_to_display_name(t, h)
  end

  defp do_camelcase_to_display_name(<<>>, _), do: <<>>
end
