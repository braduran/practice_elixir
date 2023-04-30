defmodule Practice3.PrimerProceso do
  use GenServer

  #Se activa con GenServer.start_link(PrimerProceso, []) :: {:ok, pid}
  def init(param) do
    IO.puts "Inicio  GenServer PrimerProceso #{param}"
    IO.inspect param
    {:ok, %{conteo: 0}}
  end

  #Se activa con send(pid, {"My msg"})
  def handle_info(msg, %{count: c}) do
    IO.puts "Me mandan mensaje #{c}"
    {:noreply, state}
  end

  #Se activa con GenServer.call(pid, {:add, 4, 5})
  #Sincrono
  def handle_call({:add, x, y}, _from, %{conteo: c}) do
    IO.puts "handle_call(:add, #{x}, #{y})"
    result = x + y
    IO.puts "El acumulador va en #{c}"
    {:reply, result, %{conteo: c + result}}
  end

  #Se activa con GenServer.cast(pid, :reset)
  #Asincrono
  def handle_cast(:reset, _state) do
    IO.puts "handle_cast(:reset)"
    {:noreply, %{conteo: 0}}
  end

  #Se recomienda envolver los llamados a GenServer para que sea mas comodo
  #Asi llamaria desde iex PrimerProceso.add(pid, 1, 2)
  #Para el pid podria crear otra funcion que me lo devuelva
  def add(pid, x, y) do
    GenServer.call(pid, {:add, x, y})
  end
end
