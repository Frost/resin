defmodule PerformanceForecast do
  def init(enterpriseyness) when is_list(enterpriseyness) do
    Agent.start_link(fn -> enterpriseyness end, name: __MODULE__)
  end

  def pop do
    Agent.get_and_update(__MODULE__, fn([next | tail]) ->
      {next, Enum.concat(tail, [next])}
    end)
  end
end
