defmodule PerformanceForecast do
  def init(enterpriseyness) when is_list(enterpriseyness) do
    Agent.start_link(fn -> enterpriseyness end)
  end

  def pop(agent) do
    Agent.get_and_update(agent, fn([next | tail]) ->
      {next, Enum.concat(tail, [next])}
    end)
  end
end
