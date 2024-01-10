defmodule ParallelTask do

  @doc ~S"""
      iex> ParallelTask.execute([fn -> 1 end, fn -> 2 end])
      [1, 2]

      iex> ParallelTask.execute([fn -> 1 end, fn -> 2 end, fn -> throw(:failed) end])
      [1, 2, {:error, :failed}]
  """
  def execute(tasks, opts \\ []) do
    {:ok, supervisor} = Task.Supervisor.start_link()
    joins=
      if Keyword.has_key?(opts, :nocatch) do
        Enum.map(tasks, fn task -> Task.Supervisor.async(supervisor, fn -> task.() end) end)
      else
        Enum.map(tasks, fn task -> Task.Supervisor.async(supervisor, fn -> catching(task) end) end)
      end

    Enum.map(joins, fn join -> Task.await(join) end)
  end

  defp catching(task) do
    try do
      task.()
    catch
      log -> {:error, log}
    end
  end
end
