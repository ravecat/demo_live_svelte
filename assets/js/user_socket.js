// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket, Presence } from "phoenix";

// And connect to the path in "lib/demo_phoenix_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", { params: { token: window.userToken } });

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/demo_phoenix_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/demo_phoenix_web/components/layouts/root.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/demo_phoenix_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
// if (window.userToken) {
socket.connect();

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("room:lobby", {});
let chatInput = document.querySelector("#chat-input");
let messagesContainer = document.querySelector("#messages");
let onlineUsers = document.querySelector("#online-users");

let presence = new Presence(channel);

function renderOnlineUsers(presence) {
  if (!onlineUsers) return;

  let html = "";

  presence.list((id, { metas: [first, ...rest] }) => {
    console.log(rest);
    let count = rest.length + 1;
    const onlineTime = new Date(
      parseInt(first.online_at) * 1000
    ).toLocaleTimeString();

    html += `<li>
        <div><strong>ID пользователя:</strong> ${first.user_id}</div>
        <div><strong>Email:</strong> ${first.email}</div>
        <div><strong>Присоединился в:</strong> ${onlineTime}</div>
        <div><strong>Подключений:</strong> ${count}</div>
      </li>`;
  });

  onlineUsers.innerHTML = `<ul>${html}</ul>`;
}

presence.onSync(() => renderOnlineUsers(presence));

chatInput?.addEventListener("keypress", (event) => {
  if (event.key === "Enter") {
    channel.push("new_msg", { body: chatInput.value });
    chatInput.value = "";
  }
});

channel.on("new_msg", (payload) => {
  let messageItem = document.createElement("p");

  if (payload.user_email) {
    messageItem.innerHTML = `<strong>${payload.user_email}</strong>: ${payload.body}`;
  } else {
    messageItem.innerText = `${payload.body}`;
  }

  messagesContainer.appendChild(messageItem);
});

channel
  .join()
  .receive("ok", (resp) => {
    console.log("Joined successfully", resp);
  })
  .receive("error", (resp) => {
    console.log("Unable to join", resp);
  });
// }

export default socket;
