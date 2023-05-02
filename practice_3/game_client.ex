defmodule Practice3.GameClient do

  def start_game() do
    IO.puts("Let's start - Two player memory game")
    p1 = IO.gets("Player 1: ") |> String.trim
    p2 = IO.gets("Player 2: ") |> String.trim

    GenServer.start_link(Practice3.GameServer, {p1, p2}, name: Serv)
  end

  def choose_cards(player, x, y) do
    GenServer.call(Serv, {:discover_cards, player, x, y})
  end

end

#iex
#r(Practice3.GameUtils)
#r(Practice3.GameServer)
#r(Practice3.GameClient)
#Practice3.GameClient.start_game()
#Practice3.GameClient.choose_cards("Jon", 1,2)
