defmodule PasswordGenerator do
  @moduledoc """
  Generates random password based on given parameters
  """

  @allowed_options [:length, :numbers, :uppercase, :symbols]

  @doc """
  `generate(options)`
  This functions receive a map of options
  ## Example:

    options = %{
      "length" => 5,
      "numbers" => false,
      "uppercase" => false,
      "symbols" => false,
    }

    iex> PasswordGenerator.generate(options)
    "abcdf"

    options = %{
      "length" => 5,
      "numbers" => true,
      "uppercase" => false,
      "symbols" => false,
    }

    iex> PasswordGenerator.generate(options)
    "abcdf3"


  """
  @spec generate(options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  def generate(options) do
    length = Map.has_key?(options, :length)
    validate_length(length, options)
  end

  defp validate_length(false, _options), do: {:error, "Please provide a length"}

  defp validate_length(true, options) do
    numbers = Enum.map(0..99, & &1)
    length = options[:length]
    is_length_integer = Enum.any?(numbers, &(&1 == length))

    validate_is_length_integer(is_length_integer, options)
  end

  defp validate_is_length_integer(false, _options) do
    {:error, "Only integers are allowd for length"}
  end

  defp validate_is_length_integer(true, options) do
    options_without_length = Map.delete(options, :length)
    options_values = Map.values(options_without_length)
    values_are_boolean = options_values |> Enum.all?(&IO.puts(is_boolean(&1)))

    validate_options_values_are_boolean(values_are_boolean, options)
  end

  defp validate_options_values_are_boolean(false, _options) do
    {:error, "Only booleans allowed for options values"}
  end

  defp validate_options_values_are_boolean(true, options) do
    # options_without_length = Map.delete(options, :length) |> included_options()
    # treated_options = %{options_without_length | :length => options[:length]}
    invalid_options? = Enum.any?(options, fn {key, _value} -> key not in @allowed_options end)
    validate_options(invalid_options?, options)
  end

  defp validate_options(true, _options) do
    {:error, "Only options allowed numbers, uppercase, symbols"}
  end

  defp validate_options(false, options) do
    generate_string(options)
  end

  defp generate_string(options) do
    options_keys = [:lowercase_letter | Map.keys(options)] |> List.delete(:length)
    included = options_keys |> include()
    length = options[:length] - length(included)
    random_strings = generate_random_strings(length, options_keys)
    strings = included ++ random_strings
    get_result(strings)
  end

  defp get_result(strings) do
    string =
      strings |> Enum.shuffle() |> to_string()

    {:ok, Enum.join(for <<c::utf8 <- string>>, do: <<c::utf8>>)}
  end

  defp include(options) do
    options |> Enum.map(&get(&1))
  end

  defp get(:lowercase_letter) do
    Enum.random(?a..?z)
  end

  defp get(:numbers) do
    Enum.random(0..9)
  end

  defp get(:uppercase) do
    Enum.random(?A..?Z)
  end

  defp get(:symbols) do
    symbols = "!#$%&()*+,-./:;<=>?@[]^_{|}~^" |> String.split("", trim: true)
    Enum.random(symbols)
  end

  defp generate_random_strings(length, options) do
    Enum.map(1..length, fn _ ->
      Enum.random(options) |> get()
    end)
  end
end
