# Demo Phoenix LiveView + Svelte

A demonstration application showcasing Phoenix LiveView integration with Svelte components through the live_svelte library.

## Technologies

- **Phoenix LiveView** - Server-side rendering with WebSocket connections
- **Svelte 5** - Reactive client-side components
- **live_svelte** - LiveView and Svelte integration
- **Phoenix Presence** - Online user tracking
- **Tailwind CSS + DaisyUI** - UI styling

## Architecture

The project demonstrates a hybrid approach:

- LiveView pages with server-side state
- Svelte components for interactive forms
- Bidirectional data synchronization between LiveView and Svelte
- Server-side and client-side rendering of Svelte components

## Getting Started

1. Install dependencies:

   ```bash
   mix setup
   ```

2. Start the server:

   ```bash
   mix phx.server
   ```

   or in interactive mode:

   ```bash
   iex -S mix phx.server
   ```

3. Open your browser: [localhost:4000](http://localhost:4000)

## Available Pages

- **[/users/register](http://localhost:4000/users/register)** - User Registration with Svelte

- **[/online/room](http://localhost:4000/online/room)** - Online Room (require authentication)

  - Phoenix Presence for user tracking
  - Real-time updates

## Production Deployment

For production deployment run:

```bash
mix assets.deploy
```

More details: [Phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html)

## Useful Links

### Phoenix

- [Phoenix Framework](https://www.phoenixframework.org/)
- [LiveView Documentation](https://hexdocs.pm/phoenix_live_view)
- [Phoenix Guides](https://hexdocs.pm/phoenix/overview.html)
- [Phoenix Docs](https://hexdocs.pm/phoenix)
- [Phoenix Forum](https://elixirforum.com/c/phoenix-forum)
- [Phoenix Source](https://github.com/phoenixframework/phoenix)

### Svelte

- [Svelte 5 Documentation](https://svelte.dev/docs/svelte/overview)
- [live_svelte GitHub](https://github.com/woutdp/live_svelte)

### Integration

- [live_svelte Examples](https://github.com/woutdp/live_svelte/tree/main/example_project)
