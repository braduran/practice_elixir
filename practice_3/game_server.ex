defmodule Practice3.GameServer do

  use GenServer
  import Practice3.GameUtils

  @impl true
  def init({p1, p2}) do
    data = [%{nickname: p1, score: 0, lives: 4}, %{nickname: p2, score: 0, lives: 4}]
    print_status(data)

    {c_down, c_upper} = get_chunk_letters("bcdfghjklmnpqrstvwxyz", 3)
    {v_down, v_upper} = get_chunk_letters("aeiou", 3)
    l_join = c_down ++ c_upper ++ v_down ++ v_upper
              |> Enum.map(&String.to_atom/1)
              |> Enum.shuffle

    cards = Enum.with_index(l_join, fn (e, i) -> {e, i+1} end) |> Enum.into(%{})
    IO.inspect(cards) #Linea temporal para saber que parejas elegir
    state_game = %{current_player: List.first(data), rounds: 0}
    {:ok, {data, cards, init_board(), state_game}}
  end

  @impl true
  def handle_call({:discover_cards, player, x, y}, _from, state) do
    cp = Map.get(elem(state, 3), :current_player) |> Map.get(:nickname)
    p1 = List.first(elem(state, 0))
    p2 = List.last(elem(state, 0))

    cards = elem(state, 1)
    cond do
      (cp != player) -> {:reply, "Es el turno de #{cp}", state}
      (cards == %{}) -> {:stop, :shutdown, state}
      (p1[:lives] == 0 || p2[:lives] == 0) -> {:stop, :shutdown, state}
      true -> show_cards(cards, x, y, state)
    end
  end

  @impl true
  def handle_continue(:print_state, state) do
    Process.sleep(1000) # Sleep para mostrar data y board ordenado en iex
    print_status(elem(state, 0))
    IO.puts(elem(state, 2))
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, {data, _, board, state_game}) do
    IO.puts(":: Fin de la partida")
    IO.puts(board)
    IO.puts("Rondas totales: #{round(state_game[:rounds])}")
    IO.puts(":: Resultado final")
    print_status(data)
    p1 = List.first(data)
    p2 = List.last(data)

    cond do
      (p1[:score] > p2[:score]) -> IO.puts("El ganador es #{p1[:nickname]}")
      (p1[:score] < p2[:score]) -> IO.puts("El ganador es #{p2[:nickname]}")
      (p1[:lives] > p2[:lives]) -> IO.puts("El ganador es #{p1[:nickname]}")
      (p1[:lives] < p2[:lives]) -> IO.puts("El ganador es #{p2[:nickname]}")
      true -> IO.puts("No se pudo determinar quien fue el ganador.")
    end
  end

  def show_cards(cards, x, y, state) do
    {t_one_card, k_one_str} = get_card(cards, x)
    {t_two_card, k_two_str} = get_card(cards, y)

    case {k_one_str, k_two_str} do
      {:nil,:nil} -> {:reply, "Ambas tarjetas no fueron encontradas.", state, {:continue, :print_state}}
      {:nil,_} -> {:reply, "Una de las tarjetas no fue encontrada.", state, {:continue, :print_state}}
      {_,:nil} -> {:reply, "Una de las tarjetas no fue encontrada.", state, {:continue, :print_state}}
      {x,y} when x == y -> same_cards(state, t_one_card, t_two_card)
      {x,y} when x != y -> different_cards(state, t_one_card, t_two_card)
      _ -> {:stop, "Caso no encontrado...", state}
    end
  end

  def same_cards(state, one_card, two_card) do
    {data, cards, board, state_game} =  state
    current_player = Map.get(state_game, :current_player)

    key_one = elem(one_card, 0)
    value_one = elem(one_card, 1)

    key_two = elem(two_card, 0)
    value_two = elem(two_card, 1)

    key_one_str = to_string(key_one)
    key_two_str = to_string(key_two)
    score = if Enum.member?(["a","e","i","o","u"], String.downcase(key_one_str)), do: 15, else: 10

    new_player = Map.put(current_player, :score, current_player[:score]+score)
    other_player = Enum.find(data, fn e -> e[:nickname] != new_player[:nickname] end)
    new_data = [new_player, other_player]

    new_board = change_board(board, value_one, key_one_str)
                |> change_board(value_two, key_two_str)
    IO.puts(new_board)
    reply = if score == 15, do: "Has encontrado un par de vocales.",
                            else: "Has encontrado un par de consonantes"

    new_cards = Map.delete(cards, key_one) |> Map.delete(key_two)
    new_state_game = Map.put(state_game, :rounds, state_game[:rounds]+0.5)
                     |> Map.put(:current_player, other_player)

    new_state = {new_data, new_cards, new_board, new_state_game}
    {:reply, reply, new_state, {:continue, :print_state}}
  end

  def different_cards(state, one_card, two_card) do
    {data, cards, board, state_game} =  state
    current_player = Map.get(state_game, :current_player)

    key_one_str = elem(one_card, 0) |> to_string()
    value_one = elem(one_card, 1)

    key_two_str = elem(two_card, 0) |> to_string()
    value_two = elem(two_card, 1)

    new_player = Map.put(current_player, :lives, current_player[:lives]-1)
    other_player = Enum.find(data, fn e -> e[:nickname] != new_player[:nickname] end)
    new_data = [new_player, other_player]

    preview_board = change_board(board, value_one, key_one_str)
                |> change_board(value_two, key_two_str)
    IO.puts(preview_board)

    new_state_game = Map.put(state_game, :rounds, state_game[:rounds]+0.5)
                     |> Map.put(:current_player, other_player)

    new_state = {new_data, cards, board, new_state_game}
    {:reply, "Sigue intentando.", new_state, {:continue, :print_state}}
  end

end
