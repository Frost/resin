defmodule ResinTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defp clock_resin(options) do
    Resin
    |> :timer.tc(:call, [conn(:get, "/"), options])
    |> elem(0)
  end

  test "it is enterprisey" do
    assert clock_resin(Resin.init()) > 3_000_000
  end

  test "it has configurable enterpriseyness" do
    options = Resin.init(enterpriseyness: 1_000)
    assert clock_resin(options) in 1_000_000..1_100_000
  end

  test "accepts a range for enterpriseyness" do
    results =
      for _ <- 1..10 do
        clock_resin(Resin.init(enterpriseyness: 100..200))
      end

    {faster, slower} = Enum.split_with(results, fn x -> x < 150_000 end)

    assert Enum.count(faster) >= 1
    assert Enum.count(slower) >= 1
  end

  test "accepts a reverse range for enterpriseyness" do
    results =
      for _ <- 1..10 do
        clock_resin(Resin.init(enterpriseyness: 200..100))
      end

    {faster, slower} = Enum.split_with(results, fn x -> x < 150_000 end)

    assert Enum.count(faster) >= 1
    assert Enum.count(slower) >= 1
  end

  test "it accepts an enterpriseyness pattern array" do
    options = Resin.init(enterpriseyness: [1_000, 0])

    results =
      for _ <- 1..4 do
        clock_resin(options)
      end

    assert Enum.at(results, 0) > 1_000_000
    assert Enum.at(results, 1) < 1_000_000
    assert Enum.at(results, 2) > 1_000_000
    assert Enum.at(results, 3) < 1_000_000
  end

  test "it accepts an enterpriseyness pattern array of ranges" do
    options = Resin.init(enterpriseyness: [100..200, 300..400])

    results =
      for _ <- 1..4 do
        clock_resin(options)
      end

    assert Enum.at(results, 0) in 100_000..200_000
    assert Enum.at(results, 1) in 300_000..400_000
    assert Enum.at(results, 2) in 100_000..200_000
    assert Enum.at(results, 3) in 300_000..400_000
  end

  test "it accepts combined enterpriseyness pattern array" do
    options = Resin.init(enterpriseyness: [0, 100..200, 1_000, 300..400])

    results =
      for _ <- 1..4 do
        clock_resin(options)
      end

    assert Enum.at(results, 0) < 100_000
    assert Enum.at(results, 1) in 100_000..200_000
    assert Enum.at(results, 2) > 1_000_000
    assert Enum.at(results, 3) in 300_000..400_000
  end

  test "it can handle multple instances" do
    [
      {Resin.init(enterpriseyness: 100), 100_000..200_000},
      {Resin.init(enterpriseyness: 200), 200_000..300_000}
    ]
    |> Stream.cycle()
    |> Enum.take(6)
    |> Enum.map(fn {options, range} -> {clock_resin(options), range} end)
    |> Enum.map(fn {result, expected_range} ->
      assert result in expected_range
    end)
  end
end
