defmodule DemoPhoenixWeb.OnlineLive do
  use DemoPhoenixWeb, :live_view

  alias DemoPhoenixWeb.Presence

  def mount(params, _session, socket) do
    socket = stream(socket, :presences, [])

    socket =
      if connected?(socket) do
        user = socket.assigns.current_scope.user
        room_name = params["name"]

        meta = %{
          id: user.id,
          email: user.email,
          online_at: inspect(System.system_time(:second))
        }

        Presence.track_user(room_name, user.id, meta)
        Presence.subscribe(room_name)
        stream(socket, :presences, Presence.list_online_users(room_name))
      else
        socket
      end

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <ul id="online_users" phx-update="stream" class="space-y-2 mt-4">
      <li :for={{dom_id, %{metas: metas}} <- @streams.presences} id={dom_id} class="p-2 ">
        <%= if first_meta = List.first(metas) do %>
          <div class="font-bold">{first_meta.email} ({length(metas)})</div>
          <div class="text-sm text-gray-600">
            <div>Joined at: {first_meta.online_at}</div>
          </div>
        <% end %>
      </li>
    </ul>
    """
  end

  def handle_info({Presence, {:join, presence}}, socket) do
    {:noreply, stream_insert(socket, :presences, presence)}
  end

  def handle_info({Presence, {:leave, presence}}, socket) do
    if presence.metas == [] do
      {:noreply, stream_delete(socket, :presences, presence)}
    else
      {:noreply, stream_insert(socket, :presences, presence)}
    end
  end
end
