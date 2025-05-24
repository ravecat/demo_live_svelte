defmodule DemoPhoenixWeb.Helpers.Form do
  import DemoPhoenixWeb.CoreComponents, only: [translate_error: 1]

  @moduledoc """
  Helper functions for working with Phoenix forms.

  Provides functions for serializing forms into data structures
  suitable for passing to JavaScript components.

  ## Usage

  The primary function `serialize_form/1` converts a Phoenix.HTML.Form
  into a JavaScript-friendly map that can be easily passed to frontend
  components:

      # In your LiveView
      alias DemoPhoenixWeb.Helpers.Form

      def mount(_params, _session, socket) do
        changeset = User.changeset(%User{})
        form = to_form(changeset, as: :user)

        socket = assign(socket, form: Form.serialize_form(form))
        {:ok, socket}
      end

  The serialized form includes all necessary information for frontend
  validation and form handling, including field values, errors, and
  form state.

  ## Working with Changesets

  The module handles Ecto changesets automatically:

      # Creating a changeset with validation
      changeset = %User{}
                  |> User.changeset(%{email: "test@example.com"})
                  |> User.validate_required([:email, :password])

      # Converting to form and serializing
      form_data = changeset
                  |> to_form(as: :user)
                  |> Form.serialize_form()

  The serializer extracts field values using `Ecto.Changeset.apply_changes/1`
  and properly formats validation errors for client consumption.
  """

  @doc """
  Serializes a Phoenix.HTML.Form into a JavaScript-friendly data structure.

  Returns a map with all necessary form information:
  - id, name, data - basic form properties
  - values - field values from the form
  - errors - validation errors
  - posted, valid, touched - form state

  ## Examples

  Basic form serialization:

      iex> changeset = User.changeset(%User{}, %{email: "test@example.com"})
      iex> form = to_form(changeset, as: :user, id: "user_form")
      iex> DemoPhoenixWeb.Helpers.Form.serialize_form(form)
      %{
        id: "user_form",
        name: "user",
        data: %User{},
        values: %{email: "test@example.com"},
        errors: %{},
        posted: false,
        valid: true,
        touched: false
      }

  Serializing a form with validation errors:

      iex> changeset = User.changeset(%User{}, %{email: "invalid"})
      iex> form = to_form(changeset, as: :user, id: "user_form", action: :validate)
      iex> DemoPhoenixWeb.Helpers.Form.serialize_form(form)
      %{
        id: "user_form",
        name: "user",
        data: %User{},
        values: %{email: "invalid"},
        errors: %{email: ["Email is not a valid email"]},
        posted: false,
        valid: false,
        touched: true
      }

  Working with an Ecto changeset:

      iex> changeset = User.changeset(%User{}, %{email: "test@example.com", password: "password123"})
      iex> form = to_form(changeset, as: :user)
      iex> serialized = DemoPhoenixWeb.Helpers.Form.serialize_form(form)
      iex> serialized.values
      %{email: "test@example.com", password: "password123"}

  Handling form submission with errors:

      iex> attrs = %{email: "", password: "short"}
      iex> changeset = User.changeset(%User{}, attrs) |> Map.put(:action, :insert)
      iex> form = to_form(changeset, as: :user, action: :insert)
      iex> serialized = DemoPhoenixWeb.Helpers.Form.serialize_form(form)
      iex> serialized.posted
      true
      iex> serialized.valid
      false
      iex> serialized.errors
      %{email: ["can't be blank"], password: ["should be at least 8 character(s)"]}
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

  @doc false
  @spec extract_form_values(Phoenix.HTML.Form.t()) :: map()
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

  @doc false
  @spec extract_form_errors(Phoenix.HTML.Form.t()) :: map()
  defp extract_form_errors(%Phoenix.HTML.Form{errors: errors}) do
    for {field, error} <- errors, into: %{} do
      {field, [translate_error(error)]}
    end
  end
end
