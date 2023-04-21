defmodule Practice2.GameCards do

    def start_game() do
        data = %{nickname: "", score: 0, lives: 4}

        nickname = IO.gets("Ingrese nickname: ") |> String.trim()
        data = update_data(data, :nickname, nickname)
        print_status(data)

        #alphabet_upper = alphabet_converter(?A..?Z)
        #alphabet_lower = Enum.map(alphabet_upper, fn x -> string_downcase(x) end)
        #IO.inspect(alphabet_upper)
        #IO.inspect(alphabet_lower)

        cards = %{a: 1, e: 2, o: 3, b: 4, c: 5, d: 6, A: 7, E: 8, O: 9, B: 10, C: 11, D: 12}
        print_cards(cards)
        start_process(data, cards, 4)
    end

    def alphabet_converter(range) do
        range |> Enum.take_random(6) |> Enum.to_list
    end

    def change_cards(cards, in_card) do
        replace_card = get_key_card(cards, in_card)
        %{cards | replace_card => replace_card}
    end

    def get_key_card(cards, in_card) do
        cards
        |> Enum.find(fn {key, val} -> val == in_card end)
        |> elem(0)
    end

    def print_cards(cards) do
        key_values = Map.values(cards)
        IO.inspect(key_values)
    end

    def print_status(data) do
        IO.puts("Jugador: #{data[:nickname]}")
        IO.puts("Puntaje: #{data[:score]}")
        IO.puts("Vidas: #{data[:lives]}")
    end

    def update_data(data, key, value) do
        %{data | key => value}
    end

    def start_process(data, cards, lives) do
        if lives == 0 do
            IO.puts(":: Fin de la partida")
            print_cards(cards)
            IO.puts(":: Resultado final")
            print_status(data)
        else
            {data, cards} = process(data, cards)
            print_status(data)
            print_cards(cards)
            start_process(data, cards, data[:lives])
        end
    end

    def process(data, cards) do
        {one, two} = IO.gets("Seleccione par: ")
                     |> String.trim()
                     |> String.split(",")
                     |> Enum.map(&String.to_integer/1)
                     |> List.to_tuple()

        one_card_show = show_card(cards, one)
        two_card_show = show_card(cards, two)

        if one_card_show == two_card_show do
            cards = change_cards(cards, one) |> change_cards(two)
            new_score = data[:score] + 10
            new_data = update_data(data, :score, new_score)
            {new_data, cards}
        else
            new_lives = data[:lives] - 1
            new_data = update_data(data, :lives, new_lives)
            {new_data, cards}
        end
    end

    def show_card(cards, number) when number >=1 and number <=12 do
        get_key_card(cards, number) |> to_string() |> String.downcase()
    end
end

#alias Practice2.GameCards, as: Game
#import Game
Practice2.GameCards.start_game()
