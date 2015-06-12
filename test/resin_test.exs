defmodule ResinTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defp clock_resin(options) do
    :timer.tc(Resin, :call, [conn(:get, "/"), options])
    |> (fn ({time, _value}) -> time / 1000 end).()
  end

  test "it is enterprisey" do
    assert clock_resin(Resin.init) > 3_000
  end

  test "it has configurable enterpriseyness" do
    options = Resin.init(enterpriseyness: 1_000)
    assert clock_resin(options) in 1_000 ..  1_100
  end

  test "accepts a range for enterpriseyness" do
    results = for _ <- 1..10 do
      clock_resin(Resin.init(enterpriseyness: 100 .. 200))
    end

    {faster, slower} = Enum.partition(results, fn (x) -> x < 150 end)
    
    assert Enum.count(faster) >= 1
    assert Enum.count(slower) >= 1
  end

  test "accepts a reverse range for enterpriseyness" do
    results = for _ <- 1..10 do
      clock_resin(Resin.init(enterpriseyness: 200 .. 100))
    end

    {faster, slower} = Enum.partition(results, fn (x) -> x < 150 end)
    
    assert Enum.count(faster) >= 1
    assert Enum.count(slower) >= 1
  end

  test "it accepts an enterpriseyness pattern array" do
    options = [enterpriseyness: [1_000, 0]]
    results = for _ <- 1..4 do
      clock_resin(Resin.init(options))
    end

    assert Enum.at(results, 0) > 1_000
    assert Enum.at(results, 1) < 1_000
    assert Enum.at(results, 2) > 1_000
    assert Enum.at(results, 3) < 1_000
  end

  test "it accepts an enterpriseyness pattern array of ranges" do
    options = [enterpriseyness: [100 .. 200, 300 .. 400]]
    results = for _ <- 1..4 do
      clock_resin(Resin.init(options))
    end

    assert Enum.at(results, 0) in 100 .. 200
    assert Enum.at(results, 1) in 300 .. 400
    assert Enum.at(results, 2) in 100 .. 200
    assert Enum.at(results, 3) in 300 .. 400
  end

  test "it accepts combined enterpriseyness pattern array" do
    options = [enterpriseyness: [0, 100 .. 200, 1_000, 300 .. 400]]
    results = for _ <- 1..4 do
      clock_resin(Resin.init(options))
    end

    assert Enum.at(results, 0) < 100
    assert Enum.at(results, 1) in 100 .. 200
    assert Enum.at(results, 2) > 1_000
    assert Enum.at(results, 3) in 300 .. 400
  end
end
