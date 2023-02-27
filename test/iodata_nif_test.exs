defmodule IODataNIFTest do
  use ExUnit.Case
  doctest IODataNIF

  @test_inputs ["abcd", ["abcd"], ["ab", "cd"], [?a, ["bcd"]], [], "", '', 'abc']

  test "inspect_iolist_as_binary" do
    Enum.each(@test_inputs, fn input ->
      assert IODataNIF.inspect_iolist_as_binary(input) == IO.iodata_length(input)
    end)
  end

  test "inspect_binary" do
    Enum.each(@test_inputs, fn input ->
      assert IODataNIF.inspect_binary(input) == IO.iodata_length(input)
    end)
  end

  test "enif_inspect_iovec" do
    Enum.each(@test_inputs, fn input ->
      assert IODataNIF.inspect_iovec(input) == IO.iodata_length(input)
    end)
  end
end
