defmodule Resin do
  @moduledoc """
  Introduce a configurable delay to all requests in a plug pipeline.

  Usage

      use Resin

  This will introduce a delay to all incoming requests. This delay defaults to
  3000 ms, but can be configured by the `enterpriseyness` option, like so:

      use Resin, enterpriseyness: 4711

  It can also be configured with a range of integers, to allow some
  variation in how long the delay will be:

      use Resin, enterpriseyness: 1_000 .. 3_000

  Another option is to configure it with a pattern of delays. This is
  done by configuring the `enterpriseyness` option with an array.

      use Resin, enterpriseyness: [ 0, 0, 0, 1_000 ]

  Resin will cycle through this array as it processes requests, so the
  result of the above example is that every 4th request will have an
  added delay of 1000 ms.

  This can also be done with an array of ranges, or an array that
  combines integers and ranges, like so:

      use Resin, enterpriseyness: [ 0, 100 .. 200, 1_000, 300 .. 400 ]

  When running with `MIX_ENV=prod`, Resin will do nothing, but instead just edit
  itself out of your AST. See docs on `Resin.__using__/1` for more info on that.
  """
  @behaviour Plug
  @default_options [enterpriseyness: 3_000]

  def init(options \\ []) do
    forecast_level =
      @default_options
      |> Keyword.merge(options)
      |> Keyword.get(:enterpriseyness)
      |> List.wrap

    {:ok, agent} = PerformanceForecast.init(forecast_level)
    [forecast: agent]
  end

  def call(conn, options) do
    agent = Keyword.get(options, :forecast)
    PerformanceForecast.pop(agent)
    |> enterpriseyness()
    |> :timer.sleep()
    conn
  end

  defp enterpriseyness(min .. max) when max < min,
    do: enterpriseyness(max .. min)
  defp enterpriseyness(min .. max),
    do: min + :random.uniform(max - min)
  defp enterpriseyness(level),
    do: level

  @doc """
  Pour some resin in your plug pipeline, by `use`ing this module.

      use Resin

  Resin will insert itself into your pipeline, unless you compiled your project
  with `MIX_ENV=prod`, and add a configurable delay to every request.

  The default delay is set to 3000 ms.

  If you want a shorter (or longer (really?)) delay, you can use the
  `enterpriseyness` option to set the configured delay in milliseconds, like so:

      use Resin, enterpriseyness: 4711

  When compiling with `MIX_ENV=prod`, this macro will do nothing. You only want
  to display the enterpriseyness during your demo, right?
  """
  defmacro __using__(opts \\ []) do
    unless Mix.env == :prod do
      quote bind_quoted: [opts: opts] do
        plug Resin, opts
      end
    end
  end
end
