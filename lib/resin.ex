defmodule Resin do
  @moduledoc """
  Introduce a configurable delay to all requests in a plug pipeline.

  Usage

      use Resin

  This will introduce a delay to all incoming requests. This delay defaults to
  3000 ms, but can be configured by the `enterpriseyness` option, like so:

      use Resin, enterpriseyness: 4711

  When running with `MIX_ENV=prod`, Resin will do nothing, but instead just edit
  itself out of your AST. See docs on `Resin.__using__/1` for more info on that.
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
