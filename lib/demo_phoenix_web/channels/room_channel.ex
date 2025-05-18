defmodule DemoPhoenixWeb.RoomChannel do
  use Phoenix.Channel
  alias DemoPhoenixWeb.Presence

  @impl true
  def join("room:lobby", _message, socket) do
    if authorize?(socket) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info(:after_join, socket) do
    user = socket.assigns.current_user

    {:ok, _} =
      Presence.track(socket, user.id, %{
        user_id: user.id,
        email: user.email,
        online_at: System.system_time(:second)
      })

    dbg(Presence.list(socket))


    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
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

  # Checks if current user exists in the socket
  defp authorize?(socket) do
    case socket.assigns do
      %{current_user: user} when not is_nil(user) -> true
      _ -> false
    end
  end
end
