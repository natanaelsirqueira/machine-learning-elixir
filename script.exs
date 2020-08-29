{x_values, y_values} =
  "#{:code.priv_dir(:mlex)}/pizza.txt"
  |> File.stream!()
  |> Enum.drop(1)
  |> Enum.reduce({[], []}, fn line, {x_values, y_values} ->
    chars =
      line
      |> String.trim()
      |> String.split(" ")

    {x, _} = chars |> List.first() |> Float.parse()
    {y, _} = chars |> List.last() |> Float.parse()

    x = Decimal.from_float(x)
    y = Decimal.from_float(y)

    {[x | x_values], [y | y_values]}
  end)

x_values = Enum.reverse(x_values)
y_values = Enum.reverse(y_values)

w = ML.LinearRegression.train(x_values, y_values, 1000, Decimal.from_float(0.01))

IO.puts "Weight: #{inspect(w)}"
