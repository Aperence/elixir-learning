defmodule KVServer do
  @moduledoc """
  Documentation for `KVServer`.
  """

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [reuseaddr: true, packet: :line, active: :false, mode: :binary])
    loop_accept(socket)
  end

  def loop_accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, fn () -> serve(client) end)
    :gen_tcp.controlling_process(client, pid)
    loop_accept(socket)
  end

  def serve(socket) do

    msg =
    with {:ok, line} <- read_line(socket),
         {:ok, command} <- KVServer.Command.parse(line)
    do
        KVServer.Command.run(command)
    end

    write_line(msg, socket)

    serve(socket)
  end

  def read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  def write_line({:ok, line}, socket) do
    :gen_tcp.send(socket, line)
  end

  def write_line({:error, :closed}, _socket) do
    exit(:shutdown)
  end

  def write_line({:error, :unknown}, socket) do
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  def write_line({:error, reason}, socket) do
    :gen_tcp.send(socket, reason)
  end
end
