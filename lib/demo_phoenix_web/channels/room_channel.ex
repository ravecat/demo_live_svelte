defmodule DemoPhoenixWeb.RoomChannel do
  use Phoenix.Channel

  @impl true
  def join("room:lobby", _message, socket) do
    if authorize?(socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  @impl true
  def handle_in("new_msg", %{"body" => body}, socket) do
    user = socket.assigns.current_user
    broadcast!(socket, "new_msg", %{
      body: body,
      user_email: user.email,
      user_id: user.id
    })
    {:noreply, socket}
  end

  # Проверяет наличие текущего пользователя в сокете
  defp authorize?(socket) do
    case socket.assigns do
      %{current_user: user} when not is_nil(user) -> true
      _ -> false
    end
  end
end
