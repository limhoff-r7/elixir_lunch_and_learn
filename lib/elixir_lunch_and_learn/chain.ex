defmodule ElixirLunchAndLearn.Chain do
  def counter(next_pid) do
    receive do
      n ->
        send next_pid, n + 1
    end
  end

  def create_processes(n) do
    last = Enum.reduce 1..n,
                       self,
                       fn(_, send_to) ->
                         spawn(__MODULE__, :counter, [send_to])
                       end

    # start the count by sending
    send last, 0

    # and wait for the result to come back to us
    receive do
      final_answer when is_integer(final_answer) ->
        "Result is #{inspect final_answer}"
    end
  end

  def run(n) do
    {microseconds, result} = :timer.tc(__MODULE__, :create_processes, [n])
    IO.puts "#{result} (Calculated in #{microseconds} microseconds)"
  end
end