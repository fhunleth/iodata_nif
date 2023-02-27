iodata = ["abcd", ["defg", "i", "j"], "lmnopqrstuvwxyz"]
iovec = :erlang.iolist_to_iovec(iodata)
binary = IO.iodata_to_binary(iodata)

Benchee.run(
  %{
    "inspect_binary/iodata" => fn -> IODataNIF.inspect_binary(iodata) end,
    "inspect_iolist_as_binary/iodata" => fn -> IODataNIF.inspect_iolist_as_binary(iodata) end,
    "inspect_iovec/iodata" => fn -> IODataNIF.inspect_iovec(iodata) end,
    "inspect_binary/iovec" => fn -> IODataNIF.inspect_binary(iovec) end,
    "inspect_iolist_as_binary/iovec" => fn -> IODataNIF.inspect_iolist_as_binary(iovec) end,
    "inspect_iovec/iovec" => fn -> IODataNIF.inspect_iovec(iovec) end,
    "inspect_binary/binary" => fn -> IODataNIF.inspect_binary(binary) end,
    "inspect_iolist_as_binary/binary" => fn -> IODataNIF.inspect_iolist_as_binary(binary) end,
    "inspect_iovec/binary" => fn -> IODataNIF.inspect_iovec(binary) end,
    "assume_binary/binary" => fn -> IODataNIF.assume_binary(binary) end
  },
  time: 1,
  warmup: 1,
  memory_time: 1,
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
