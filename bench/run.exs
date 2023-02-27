# iodata = ["abcd", ["defg", "i", "j"], "lmnopqrstuvwxyz"]
iodata = ["a", [:binary.copy("abcd", 256)], "b"]
iovec = :erlang.iolist_to_iovec(iodata)
binary = IO.iodata_to_binary(iodata)

Benchee.run(
  %{
    "inspect_binary" => fn input -> IODataNIF.inspect_binary(input) end,
    "inspect_iolist_as_binary" => fn input -> IODataNIF.inspect_iolist_as_binary(input) end,
    "inspect_iovec" => fn input -> IODataNIF.inspect_iovec(input) end
  },
  inputs: %{
    "iodata" => iodata,
    "iovec" => iovec,
    "binary" => binary
  },
  time: 1,
  warmup: 1
  # memory_time: 1
  # formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
