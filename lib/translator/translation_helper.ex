defmodule Translator.TranslationHelpers do
  @default_field :translation

  def translate(%Ecto.Changeset{} = changeset, field) when is_atom(field), do: translate(changeset, field, @default_field)
  def translate(model, field), do: translate(model, field, @default_field)

  def translate(%Ecto.Changeset{} = changeset, field, _assoc) when is_atom(field) do
    if Map.has_key?(changeset.changes, field) do
      Map.get(changeset.changes, field)
    else
      ""
    end
  end

  def translate(%Ecto.Changeset{} = changeset, model, field), do: translate(changeset, model, field, @default_field)
  def translate(nil, _field, _assoc), do: ""
  def translate(model, field, assoc) do
    translation = Map.get(model, assoc)
    if !is_nil(translation) && Ecto.assoc_loaded?(translation) && Map.has_key?(translation, field) do
      Map.get(translation, field) || ""
    else
      Map.get(model, field) || ""
    end
  end

  def translate(%Ecto.Changeset{} = changeset, model, field, assoc) do
    if Map.has_key?(changeset.changes, field) do
      Map.get(changeset.changes, field)
    else
      translate(model, field, assoc)
    end
  end

end
