defmodule ResinTest do
  use ExUnit.Case, async: true
  use Plug.Test
  require Timex.Time
  alias Timex.Time

  test "it is enterprisey" do
    options = Resin.init()
    t = Time.now
    Resin.call(conn(:get, "/"), options)
    assert Time.elapsed(t, :secs) >= 3
  end

  test "it has configurable enterpriseyness" do
    options = Resin.init(enterpriseyness: 1000)
    t = Time.now
    Resin.call(conn(:get, "/"), options)
    assert Time.elapsed(t, :secs) in 1.0..2.0
  end
end
