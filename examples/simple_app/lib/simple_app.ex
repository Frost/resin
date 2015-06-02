defmodule SimpleApp do
  use Plug.Router

  use Resin, enterpriseyness: 1_000

  plug :match
  plug :dispatch

  get "/hello" do
    conn
    |> send_resp(200,  "That sure was slo^H^H^Henterprisey, right?\n")
  end

  match _ do
    conn
    |> send_resp(404, "nope")
  end

  def start do
    Plug.Adapters.Cowboy.http SimpleApp, [], port: 4000
  end

  def stop do
    Plug.Adapters.Cowboy.shutdown SimpleApp.HTTP
  end
end
