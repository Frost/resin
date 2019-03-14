defmodule PerformanceForecast do
  @moduledoc """
  An agent that keeps track of your enterpriseyness patterns.

  If you configure Resin to have a varying pattern of enterpriseyness,
  it will use this module to cycle through your pattern.
  """

  def init(enterpriseyness) when is_list(enterpriseyness) do
    Agent.start_link(fn -> enterpriseyness end)
  end

  def pop(agent) do
    Agent.get_and_update(agent, fn([next | tail]) ->
      {next, Enum.concat(tail, [next])}
    end)
  end
end
