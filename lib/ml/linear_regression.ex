defmodule ML.LinearRegression do
  @moduledoc false

  @spec predict(Decimal.t(), Decimal.t()) :: Decimal.t()
  def predict(x, w) do
    Decimal.mult(x, w)
  end

  @spec loss([Decimal.t()], [Decimal.t()], Decimal.t()) :: Decimal.t()
  def loss(x_values, y_values, w) do
    total_squared_error =
      x_values
      |> Enum.zip(y_values)
      |> Enum.reduce(0, fn {x, y}, total_squared_error ->
        error = Decimal.sub(predict(x, w), y)
        squared_error = Decimal.from_float(:math.pow(Decimal.to_float(error), 2))

        Decimal.add(total_squared_error, squared_error)
      end)

    Decimal.div(total_squared_error, length(x_values))
  end

  @spec train([Decimal.t()], [Decimal.t()], integer(), Decimal.t()) :: Decimal.t()
  def train(x_values, y_values, iterations, learning_rate) do
    Enum.reduce_while(1..iterations, Decimal.from_float(0.0), fn index, weight ->
      current_loss = loss(x_values, y_values, weight)
      IO.puts("Iteration #{index} => Loss: #{current_loss}")

      cond do
        Decimal.lt?(loss(x_values, y_values, Decimal.add(weight, learning_rate)), current_loss) ->
          {:cont, Decimal.add(weight, learning_rate)}

        Decimal.lt?(loss(x_values, y_values, Decimal.sub(weight, learning_rate)), current_loss) ->
          {:cont, Decimal.sub(weight, learning_rate)}

        true ->
          {:halt, weight}
      end
    end)
  end
end
