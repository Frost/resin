defmodule Resin do
  @moduledoc """
  Introduce a configurable delay to all requests in a plug pipeline.
  """
  @behaviour Plug
  @default_enterpriseyness 3_000

  def init(options \\ []) do
    Keyword.merge([enterpriseyness: @default_enterpriseyness], options)
  end

  def call(conn, options) do
    :timer.sleep(Keyword.get(options, :enterpriseyness))
    conn
  end

  @doc """
  Pour some resin in your plug pipeline.

  Resin.act_enterprisey will insert itself into your pipeline, unless you
  compiled your project with `MIX_ENV=prod`, and add a configurable delay to
  every request.

  The default delay is set to 3000 ms.

  If you want a shorter (or longer (really?)) delay, you can use the
  `enterpriseyness` option to set the configured delay in milliseconds, like so:

      Resin.act_enterprisey enterpriseyness: 4711

  When compiling with `MIX_ENV=prod`, this macro will do nothing. You only want
  to display the enterpriseyness during your demo, right?
  """
  defmacro act_enterprisey(opts \\ []) do
    unless Mix.env == :prod do
      quote bind_quoted: [opts: opts] do
        plug Resin, opts
      end
    end
  end
end
