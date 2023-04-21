#1
IO.puts("#1")
require Integer
num = IO.gets("Ingrese numero: ") |> String.trim() |> String.to_integer()
case num do
  x when Integer.is_even(x) -> IO.puts("Par")
  x when Integer.is_odd(x) -> IO.puts("Impar")
end

IO.puts("#2")
frase = IO.gets("Ingrese palabra: ") |> String.trim()
frase_rev = String.reverse(frase)
if frase == frase_rev do
  IO.puts("Si es palindromo")
else
  IO.puts("No es palindromo")
end


#3
IO.puts("#3")
nombre = "Juan"
edad = 26
ciudad = "Medellin"
case {nombre, edad, ciudad} do
  {"Juan", _, _} -> IO.puts("Hola Juan de #{ciudad}!")
  _ -> IO.puts("Encantado de conocerte!")
end

#4
IO.puts("#4")
numero = IO.gets("Ingrese numero: ") |> String.trim() |> String.to_integer()
if numero > 0 do
  IO.puts("Positivo")
else
  if numero < 0 do
    IO.puts("Negativo")
  else
    IO.puts("Cero")
  end
end

#5
IO.puts("#5")
x = IO.gets("Ingrese numero: ") |> String.trim() |> String.to_integer()
if x > 10 do
  IO.puts("x es mayor que 10")
else
  IO.puts("x es menor o igual que 10")
end

#6
IO.puts("#6")
x = IO.gets("Ingrese numero: ") |> String.trim() |> String.to_integer()
cond do
  x > 10 -> IO.puts("x es mayor que 10")
  x < 5 -> IO.puts("x es menor que 5")
  x > 5 && x < 10 -> IO.puts("x esta entre 5 y 10")
  true -> IO.puts("No coincide")
end

#7
IO.puts("#7")
mapa = %{nombre: "Jhon Doe", edad: 26, ciudad: "Medellin"}
nombre = Map.get(mapa, :nombre)
IO.puts("Hola #{nombre}!")

#8
IO.puts("#8")
frase = IO.gets("Ingrese palabra: ") |> String.trim()
frase_rev = String.reverse(frase)
case frase do
  x when x == frase_rev -> IO.puts("Si es palindromo")
  _ -> IO.puts("No es palindromo")
end

#9
IO.puts("#9")
lista = ["a", "z", "c"]
IO.puts(Enum.sort(lista, :asc))
IO.puts(Enum.sort(lista, :desc))
