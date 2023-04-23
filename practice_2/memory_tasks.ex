defmodule Practice2.MemoryTasks do
    import Practice2.MemoryUtils

    def start_game() do
        data = %{nickname: "", score: 0, lives: 4}

        nickname = IO.gets("Ingrese nickname: ") |> String.trim()
        data = %{data | :nickname => nickname}
        print_status(data)

        {c_down, c_upper} = get_chunk_letters("bcdfghjklmnpqrstvwxyz", 3)
        {v_down, v_upper} = get_chunk_letters("aeiou", 3)
        l_join = c_down ++ c_upper ++ v_down ++ v_upper
                 |> Enum.map(&String.to_atom/1)
                 |> Enum.shuffle

        cards = Enum.with_index(l_join, fn (e, i) -> {e, i+1} end) |> Enum.into(%{})
        IO.inspect(cards) #Linea temporal para saber que parejas elegir
        start_process(data, cards, init_board())
    end

    def start_process(data, cards, board) do
        if data[:lives] == 0 || cards == %{} do
            IO.puts(":: Fin de la partida")
            IO.puts(board)
            IO.puts(":: Resultado final")
            print_status(data)
        else
            {data, cards, board} = process(data, cards, board)
            print_status(data)
            IO.puts(board)
            start_process(data, cards, board)
        end
    end

    def process(data, cards, board) do
        {one, two} = IO.gets("Seleccione par (x,y): ")
                     |> String.trim()
                     |> String.split(",")
                     |> Enum.map(&String.to_integer/1)
                     |> List.to_tuple()

        {t_one_card, k_one_str} = get_card(cards, one)
        {t_two_card, k_two_str} = get_card(cards, two)

        case {k_one_str, k_two_str} do
            {:nil,:nil} -> do_nothing("Ambas tarjetas ya fueron seleccionadas.", data, cards, board)
            {:nil,_} -> do_nothing("Una de las tarjetas ya fue seleccionada.", data, cards, board)
            {_,:nil} -> do_nothing("Una de las tarjetas ya fue seleccionada.", data, cards, board)
            {x,y} when x == y -> same_cards(cards, data, board, t_one_card, t_two_card)
            {x,y} when x != y -> different_cards(cards, data, board, t_one_card, t_two_card)
            _ -> IO.puts("ERROR !!!")
        end
    end

    def same_cards(cards, data, board, one_card, two_card) do
        key_one = elem(one_card, 0)
        value_one = elem(one_card, 1)

        key_two = elem(two_card, 0)
        value_two = elem(two_card, 1)

        key_one_str = to_string(key_one)
        key_two_str = to_string(key_two)
        score = if Enum.member?(["a","e","i","o","u"], String.downcase(key_one_str)), do: 15, else: 10
        new_data = %{data | :score => data[:score]+score}

        new_board = change_board(board, value_one, key_one_str)
                    |> change_board(value_two, key_two_str)
        IO.puts(new_board)
        if score == 15, do: IO.puts("Has encontrado un par de vocales."),
                        else: IO.puts("Has encontrado un par de consonantes")

        new_cards = Map.delete(cards, key_one) |> Map.delete(key_two)
        {new_data, new_cards, new_board}
    end

    def different_cards(cards, data, board, one_card, two_card) do
        key_one_str = elem(one_card, 0) |> to_string()
        value_one = elem(one_card, 1)

        key_two_str = elem(two_card, 0) |> to_string()
        value_two = elem(two_card, 1)

        new_data = %{data | :lives => data[:lives]-1}

        preview_board = change_board(board, value_one, key_one_str)
                    |> change_board(value_two, key_two_str)
        IO.puts(preview_board)
        IO.puts("Sigue intentando.")

        {new_data, cards, board}
    end

    def do_nothing(message, data, cards, board) do
        IO.puts(message)
        {data, cards, board}
    end
end
