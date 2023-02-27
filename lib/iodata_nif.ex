defmodule IODataNIF do
  @moduledoc """
  Documentation for `IodataNif`.
  """

  @on_load {:load_nif, 0}
  @compile {:autoload, false}

  def load_nif() do
    nif_binary = Application.app_dir(:iodata_nif, "priv/iodata_nif")
    :erlang.load_nif(to_charlist(nif_binary), 0)
  end

  def nif_inspect_binary(_data), do: :erlang.nif_error(:nif_not_loaded)
  def nif_inspect_iolist_as_binary(_data), do: :erlang.nif_error(:nif_not_loaded)
  def nif_inspect_iovec(_data), do: :erlang.nif_error(:nif_not_loaded)

  def inspect_binary(data), do: nif_inspect_binary(IO.iodata_to_binary(data))
  def inspect_iolist_as_binary(data), do: nif_inspect_iolist_as_binary(data)
  def inspect_iovec(data), do: nif_inspect_iovec(:erlang.iolist_to_iovec(data))

  def assume_binary(data), do: nif_inspect_binary(data)
end
