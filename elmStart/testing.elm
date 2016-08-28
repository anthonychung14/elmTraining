multiply num1 num2 =
  num1 * num2

add x y =
  x + y

result: Int -> String
result x =
  x  
    |> multiply 2
    |> add 3
    |> toString    