defmodule Practice2.GameCards do

    def start_game() do
        data = %{nickname: "", score: 0, lives: 4}

        nickname = IO.gets("Ingrese nickname: ") |> String.trim()
        data = update_data(data, :nickname, nickname)
        print_status(data)

        {c_down, c_upper} = get_chunk_letters("bcdfghjklmnpqrstvwxyz", 3)
        {v_down, v_upper} = get_chunk_letters("aeiou", 3)
        l_join = c_down ++ c_upper ++ v_down ++ v_upper
                 |> Enum.map(&String.to_atom/1)
                 |> Enum.shuffle

        cards = Enum.with_index(l_join, fn (e, i) -> {e, i+1} end) |> Enum.into(%{})
        IO.inspect(cards) #Linea temporal para saber que parejas elegir
        start_process(data, cards, 4, init_board())
    end

    def start_process(data, cards, lives, board) do
        if lives == 0 do
            IO.puts(":: Fin de la partida")
            IO.puts(board)
            IO.puts(":: Resultado final")
            print_status(data)
        else
            {data, cards, board} = process(data, cards, board)
            print_status(data)
            IO.puts(board)
            start_process(data, cards, data[:lives], board)
        end
    end

    def process(data, cards, board) do
        {one, two} = IO.gets("Seleccione par (x,y): ")
                     |> String.trim()
                     |> String.split(",")
                     |> Enum.map(&String.to_integer/1)
                     |> List.to_tuple()

        one_card_show = show_card(cards, one)
        two_card_show = show_card(cards, two)

        one_card_down = String.downcase(one_card_show)
        if one_card_down == String.downcase(two_card_show) do
            cards = change_cards(cards, one) |> change_cards(two)
            #Se puede poner primer sum_score con one_card_show o two_card_show ya que son iguales
            update_score = sum_score(one_card_down)
            new_data = update_data(data, :score, data[:score]+update_score)

            new_board = change_board(board, one, one_card_show)
                        |> change_board(two, two_card_show)

            IO.puts(new_board)
            if update_score == 15, do: IO.puts("Has encontrado un par de vocales."),
                                   else: IO.puts("Has encontrado un par de consonantes")

            {new_data, cards, new_board}
        else
            new_lives = data[:lives] - 1
            new_data = update_data(data, :lives, new_lives)

            new_board = change_board(board, one, one_card_show)
                        |> change_board(two, two_card_show)

            IO.puts(new_board)
            IO.puts("Sigue intentando.")
            {new_data, cards, board}
        end
    end

    def get_chunk_letters(letters, chunk) when chunk >= 1 and chunk <= 21 do
        chunk_letters = String.graphemes(letters) |> Enum.take_random(chunk) |> Enum.to_list |> List.to_string
        letters_down = String.graphemes(chunk_letters)
        letters_up = String.upcase(chunk_letters) |> String.graphemes
        {letters_down, letters_up}
    end

    def change_cards(cards, in_card) do
        replace_card = get_key_card(cards, in_card)
        %{cards | replace_card => replace_card}
    end

    def get_key_card(cards, in_card) do
        cards
        |> Enum.find(fn {_, val} -> val == in_card end)
        |> elem(0)
    end

    def print_status(data) do
        IO.puts("Jugador: #{data[:nickname]}")
        IO.puts("Puntaje: #{data[:score]}")
        IO.puts("Vidas: #{data[:lives]}")
    end

    def update_data(data, key, value) do
        %{data | key => value}
    end

    def show_card(cards, number) when number >=1 and number <=12 do
        get_key_card(cards, number) |> to_string()
    end

    def sum_score(letter) do
        if Enum.member?(["a","e","i","o","u"], letter), do: 15, else: 10
    end

    def init_board() do
        b = """
            [ 1 ]  [ 2 ]  [ 3 ]  [ 4 ]
            [ 5 ]  [ 6 ]  [ 7 ]  [ 8 ]
            [ 9 ] [ 10 ] [ 11 ] [ 12 ]
            """
        IO.puts(b)
        b
    end

    def change_board(actual_board, field, replacement) do
        field = "[ #{to_string(field)} ]"
        replacement = "[ #{replacement} ]"
        String.replace(actual_board,field,replacement)
    end
end


Practice2.GameCards.start_game()
