defmodule DemoPhoenixWeb.PageController do
  use DemoPhoenixWeb, :controller

  def home(conn, _params) do
    dbg(conn.assigns)
    render(conn, :home)
  end
end
