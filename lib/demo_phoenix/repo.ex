defmodule DemoPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :demo_phoenix,
    adapter: Ecto.Adapters.Postgres
end
