defmodule PasswordGeneratorTest do
  use ExUnit.Case

  setup do
    options = %{
      :length => 10,
      :numbers => false,
      :uppercase => false,
      :symbols => false
    }

    options_type = %{
      lowercase_letter: Enum.map(?a..?z, &<<&1>>),
      numbers: Enum.map(0..9, &to_string(&1)),
      uppercase: Enum.map(?A..?Z, &<<&1>>),
      symbols: String.split("!#$%&()*+,-./:;<=>?@[]^_{|}~^", "", trim: true)
    }
  end

  test "should return a string" do
    options = %{
      :length => 10,
      :numbers => false,
      :uppercase => false,
      :symbols => false
    }

    {:ok, result} = PasswordGenerator.generate(options)
    assert is_bitstring(result)
  end

  test "should throw a error when no length is given" do
    options = %{:invalid => false}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "should throw a error when length is not an integer" do
    options = %{:length => "ab"}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "should return a lowercase string just with the length", options_type do
    length_option = %{:length => 5}
    {:ok, result} = PasswordGenerator.generate(length_option)

    assert String.contains?(result, options_type.lowercase_letter)
    assert result |> to_charlist |> length() == length_option.length

    refute String.contains?(result, options_type.numbers)
    refute String.contains?(result, options_type.uppercase)
    refute String.contains?(result, options_type.symbols)
  end

  test "should throw a error when options values are not booleans" do
    options = %{
      :length => 10,
      :numbers => "invalid",
      :uppercase => 0,
      :symbols => false
    }

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "should throw error when options not allowed" do
    options = %{:length => 5, "invalid" => true}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "should throw error when 1 options not allowed" do
    options = %{:length => 5, :numbers => true, :invalid => true}

    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "should return a upper and lower case string", options_type do
    options = %{
      :length => 10,
      :numbers => false,
      :uppercase => true,
      :symbols => false
    }

    {:ok, result} = PasswordGenerator.generate(options)

    assert String.contains?(result, options_type[:lowercase_letter])
    assert result |> to_charlist |> length() == options.length

    refute String.contains?(result, options_type[:numbers])
    refute String.contains?(result, options_type[:symbols])
  end

  test "should return a lower case string with numbers", options_type do
    options = %{
      :length => 10,
      :numbers => true,
      :uppercase => false,
      :symbols => false
    }

    {:ok, result} = PasswordGenerator.generate(options)

    assert String.contains?(result, options_type[:lowercase_letter])
    assert String.contains?(result, options_type[:numbers])
    assert result |> to_charlist |> length() == options.length

    refute String.contains?(result, options_type[:uppercase])
    refute String.contains?(result, options_type[:symbols])
  end

  test "should return a lower case string with symbols", options_type do
    options = %{
      :length => 10,
      :numbers => false,
      :uppercase => false,
      :symbols => true
    }

    {:ok, result} = PasswordGenerator.generate(options)

    assert String.contains?(result, options_type[:lowercase_letter])
    assert String.contains?(result, options_type[:symbols])
    assert result |> to_charlist |> length() == options.length

    refute String.contains?(result, options_type[:uppercase])
    refute String.contains?(result, options_type[:numbers])
  end
end
