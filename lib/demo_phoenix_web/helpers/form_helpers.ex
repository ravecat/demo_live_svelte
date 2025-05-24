defmodule DemoPhoenixWeb.FormHelpers do
  import DemoPhoenixWeb.CoreComponents, only: [translate_error: 1]

  @moduledoc """
  Helper functions for working with Phoenix forms.

  Provides functions for serializing forms into data structures
  suitable for passing to JavaScript components.
  """

  @doc """
  Serializes a Phoenix.HTML.Form into a JavaScript-friendly data structure.

  Returns a map with all necessary form information:
  - id, name, data - basic form properties
  - values - field values from the form
  - errors - validation errors
  - posted, valid, touched - form state

  ## Examples

      iex> form = to_form(changeset)
      iex> DemoPhoenixWeb.FormHelpers.serialize_form(form)
      %{
        id: "user_form",
        name: "user",
        data: %{},
        values: %{email: "test@example.com"},
        errors: %{},
        posted: false,
        valid: true,
        touched: false
      }
  """
  def serialize_form(form) do
    %{
      id: form.id,
      name: form.name,
      data: form.data,
      values: extract_form_values(form),
      errors: extract_form_errors(form),
      posted: form.action != nil,
      valid: form.errors == [],
      touched: form.action == :validate
    }
  end

  @doc """
  Extracts field values from a form.

  For forms based on Ecto.Changeset, applies changes and converts
  to a map with field names as keys and their values.
  """
  defp extract_form_values(%Phoenix.HTML.Form{source: %Ecto.Changeset{} = changeset} = form) do
    changeset
    |> Ecto.Changeset.apply_changes()
    |> Map.from_struct()
    |> Map.drop([:__meta__])
    |> Enum.into(%{}, fn {field_name, _value} ->
      {field_name, Phoenix.HTML.Form.input_value(form, field_name)}
    end)
  end

  defp extract_form_values(_form), do: %{}

  @doc """
  Extracts errors from a form in map format.

  Converts form errors to {field => [error_message]} structure.
  """
  defp extract_form_errors(%Phoenix.HTML.Form{errors: errors}) do
    for {field, error} <- errors, into: %{} do
      {field, [translate_error(error)]}
    end
  end
end
