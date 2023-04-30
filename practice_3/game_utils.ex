defmodule Practice3.GameUtils do

  def init_board() do
    b = """
        [ 1 ]  [ 2 ]  [ 3 ]  [ 4 ]
        [ 5 ]  [ 6 ]  [ 7 ]  [ 8 ]
        [ 9 ] [ 10 ] [ 11 ] [ 12 ]
        """
    IO.puts(b)
    b
  end

  def print_status(data) do
    IO.puts("Jugador: #{data[:nickname]}")
    IO.puts("Puntaje: #{data[:score]}")
    IO.puts("Vidas: #{data[:lives]}")
  end

  def get_chunk_letters(letters, chunk) when chunk >= 1 and chunk <= 21 do
    chunk_letters = String.graphemes(letters) |> Enum.take_random(chunk)
                    |> Enum.to_list |> List.to_string
    letters_down = String.graphemes(chunk_letters)
    letters_up = String.upcase(chunk_letters) |> String.graphemes
    {letters_down, letters_up}
  end

  def change_board(actual_board, field, replacement) do
    field = "[ #{to_string(field)} ]"
    replacement = "[ #{replacement} ]"
    String.replace(actual_board,field,replacement)
  end

  def get_card(cards, number) do
    t_card = Enum.find(cards, fn {_, v} -> v == number end)
    if t_card == :nil, do: {t_card, :nil},
                       else: {t_card, elem(t_card, 0) |> to_string() |> String.downcase }
  end
end
