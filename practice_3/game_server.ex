defmodule Practice3.GameServer do

  use GenServer
  import Practice3.GameUtils

  def init(name) do
    data = %{nickname: name, score: 0, lives: 4}
    print_status(data)

    {c_down, c_upper} = get_chunk_letters("bcdfghjklmnpqrstvwxyz", 3)
    {v_down, v_upper} = get_chunk_letters("aeiou", 3)
    l_join = c_down ++ c_upper ++ v_down ++ v_upper
              |> Enum.map(&String.to_atom/1)
              |> Enum.shuffle

    cards = Enum.with_index(l_join, fn (e, i) -> {e, i+1} end) |> Enum.into(%{})
    IO.inspect(cards) #Linea temporal para saber que parejas elegir
    {:ok, {data, cards, init_board()}}
  end

  def handle_call({:show_cards, x, y}, _from, {data, cards, board}) do

    if data[:lives] == 0 || cards == %{} do
      {:stop, :shutdown, {data, cards, board}}
    else
      {t_one_card, k_one_str} = get_card(cards, x)
      {t_two_card, k_two_str} = get_card(cards, y)

      case {k_one_str, k_two_str} do
        {:nil,:nil} -> {:reply, "Ambas tarjetas no fueron encontradas.", {data, cards, board}, {:continue, :state}}
        {:nil,_} -> {:reply, "Una de las tarjetas no fue encontrada.", {data, cards, board}, {:continue, :state}}
        {_,:nil} -> {:reply, "Una de las tarjetas no fue encontrada.", {data, cards, board}, {:continue, :state}}
        {x,y} when x == y -> same_cards(data, cards, board, t_one_card, t_two_card)
        {x,y} when x != y -> different_cards(data, cards, board, t_one_card, t_two_card)
        _ -> {:stop, "Caso no encontrado...", {data, cards, board}}
      end
    end
  end

  def handle_continue(:state, {data, cards, board}) do
    Process.sleep(1000) # Sleep para mostrar data y board ordenado en iex
    print_status(data)
    IO.puts(board)
    {:noreply, {data, cards, board}}
  end

  def terminate(_reason, {data, _, board}) do
    IO.puts(":: Fin de la partida")
    IO.puts(board)
    IO.puts(":: Resultado final")
    print_status(data)
  end

  def same_cards(data, cards, board, one_card, two_card) do
    key_one = elem(one_card, 0)
    value_one = elem(one_card, 1)

    key_two = elem(two_card, 0)
    value_two = elem(two_card, 1)

    key_one_str = to_string(key_one)
    key_two_str = to_string(key_two)
    score = if Enum.member?(["a","e","i","o","u"], String.downcase(key_one_str)), do: 15, else: 10
    new_data = Map.put(data, :score, data[:score]+score)

    new_board = change_board(board, value_one, key_one_str)
                |> change_board(value_two, key_two_str)
    IO.puts(new_board)
    reply = if score == 15, do: "Has encontrado un par de vocales.",
                            else: "Has encontrado un par de consonantes"

    new_cards = Map.delete(cards, key_one) |> Map.delete(key_two)
    new_state = {new_data, new_cards, new_board}
    {:reply, reply, new_state, {:continue, :state}}
  end

  def different_cards(data, cards, board, one_card, two_card) do
    key_one_str = elem(one_card, 0) |> to_string()
    value_one = elem(one_card, 1)

    key_two_str = elem(two_card, 0) |> to_string()
    value_two = elem(two_card, 1)

    new_data = Map.put(data, :lives, data[:lives]-1)

    preview_board = change_board(board, value_one, key_one_str)
                |> change_board(value_two, key_two_str)
    IO.puts(preview_board)

    new_state = {new_data, cards, board}
    {:reply, "Sigue intentando.", new_state, {:continue, :state}}
  end

end
