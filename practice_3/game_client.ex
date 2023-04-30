defmodule Practice3.GameClient do

  def start_game(nickname) do
    GenServer.start_link(Practice3.GameServer, nickname, name: Serv)
  end

  def choose_cards(x,y) do
    GenServer.call(Serv, {:show_cards, x, y})
  end

end

#iex
#r(Practice3.GameServer)
#r(Practice3.GameClient)
#r(Practice3.GameUtils)
#Practice3.GameClient.start_game("Brayan")
#Practice3.GameClient.choose_cards(1,2)
