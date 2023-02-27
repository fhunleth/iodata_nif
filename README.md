# NIF IOData Experiments

This is a rough implementation of a NIF that takes IOData to see how the various
ways of passing IOData compare.

It tries out:

1. Passing IOData unchanged to the NIF and calling
   `enif_inspect_iolist_as_binary`
2. Converting the IOData to a binary and passing the the binary to the NIF
3. Converting the IOData to an iovec and using `enif_inspect_iovec` to get an
   iovec out

## Benchmark runs

TL;DR: For the small IOData buffers that I'm interested in at the moment,
`enif_inspect_iolist_as_binary` is faster than converting to a binary and using
that or converting to an iovec and using `enif_inspect_iovec`. Everything is so
fast that if you enable the `ERL_NIF_DIRTY_JOB_IO_BOUND` flag for the functional
call, like you were actually going to make a blocking call, the additional
processing adds too much variability to the test to get a good result.

### ~1K IOData

```text
Operating System: Linux
CPU Information: AMD Ryzen Threadripper 2950X 16-Core Processor
Number of Available Cores: 32
Available memory: 31.20 GB
Elixir 1.14.3
Erlang 25.2

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 1 s
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: binary, iodata, iovec
Estimated total run time: 18 s

Benchmarking inspect_binary with input binary ...
Benchmarking inspect_binary with input iodata ...
Benchmarking inspect_binary with input iovec ...
Benchmarking inspect_iolist_as_binary with input binary ...
Benchmarking inspect_iolist_as_binary with input iodata ...
Benchmarking inspect_iolist_as_binary with input iovec ...
Benchmarking inspect_iovec with input binary ...
Benchmarking inspect_iovec with input iodata ...
Benchmarking inspect_iovec with input iovec ...

##### With input binary #####
Name                               ips        average  deviation         median         99th %
inspect_binary                  8.00 M      124.98 ns   ±613.80%         120 ns         180 ns
inspect_iolist_as_binary        7.55 M      132.49 ns   ±791.81%         121 ns         241 ns
inspect_iovec                   6.92 M      144.52 ns   ±457.47%         131 ns         271 ns

Comparison:
inspect_binary                  8.00 M
inspect_iolist_as_binary        7.55 M - 1.06x slower +7.51 ns
inspect_iovec                   6.92 M - 1.16x slower +19.54 ns

##### With input iodata #####
Name                               ips        average  deviation         median         99th %
inspect_iolist_as_binary        4.10 M      244.02 ns   ±229.25%         240 ns         340 ns
inspect_binary                  2.17 M      459.90 ns  ±4822.11%         331 ns         632 ns
inspect_iovec                   1.37 M      729.11 ns  ±3557.07%         541 ns         812 ns

Comparison:
inspect_iolist_as_binary        4.10 M
inspect_binary                  2.17 M - 1.88x slower +215.88 ns
inspect_iovec                   1.37 M - 2.99x slower +485.09 ns

##### With input iovec #####
Name                               ips        average  deviation         median         99th %
inspect_iolist_as_binary        4.30 M      232.83 ns  ±3462.04%         221 ns         320 ns
inspect_binary                  1.92 M      521.62 ns  ±4369.51%         331 ns        1383 ns
inspect_iovec                   1.86 M      536.25 ns  ±2394.14%         471 ns        1072 ns

Comparison:
inspect_iolist_as_binary        4.30 M
inspect_binary                  1.92 M - 2.24x slower +288.79 ns
inspect_iovec                   1.86 M - 2.30x slower +303.43 ns
```

### ~26 byte IOData

```text
Operating System: Linux
CPU Information: AMD Ryzen Threadripper 2950X 16-Core Processor
Number of Available Cores: 32
Available memory: 31.20 GB
Elixir 1.14.3
Erlang 25.2

Benchmark suite executing with the following configuration:
warmup: 1 s
time: 1 s
memory time: 0 ns
reduction time: 0 ns
parallel: 1
inputs: binary, iodata, iovec
Estimated total run time: 18 s

Benchmarking inspect_binary with input binary ...
Benchmarking inspect_binary with input iodata ...
Benchmarking inspect_binary with input iovec ...
Benchmarking inspect_iolist_as_binary with input binary ...
Benchmarking inspect_iolist_as_binary with input iodata ...
Benchmarking inspect_iolist_as_binary with input iovec ...
Benchmarking inspect_iovec with input binary ...
Benchmarking inspect_iovec with input iodata ...
Benchmarking inspect_iovec with input iovec ...

##### With input binary #####
Name                               ips        average  deviation         median         99th %
inspect_iolist_as_binary        8.13 M      123.05 ns   ±110.02%         120 ns         171 ns
inspect_binary                  7.75 M      129.11 ns    ±27.01%         121 ns         220 ns
inspect_iovec                   3.59 M      278.29 ns  ±3474.84%         240 ns         671 ns

Comparison:
inspect_iolist_as_binary        8.13 M
inspect_binary                  7.75 M - 1.05x slower +6.05 ns
inspect_iovec                   3.59 M - 2.26x slower +155.23 ns

##### With input iodata #####
Name                               ips        average  deviation         median         99th %
inspect_iolist_as_binary        4.03 M      247.83 ns    ±20.42%         241 ns         341 ns
inspect_binary                  3.88 M      257.88 ns  ±2068.21%         201 ns         411 ns
inspect_iovec                   2.03 M      492.02 ns  ±1088.37%         441 ns        1152 ns

Comparison:
inspect_iolist_as_binary        4.03 M
inspect_binary                  3.88 M - 1.04x slower +10.05 ns
inspect_iovec                   2.03 M - 1.99x slower +244.19 ns

##### With input iovec #####
Name                               ips        average  deviation         median         99th %
inspect_binary                  6.19 M      161.49 ns  ±5718.69%         130 ns         321 ns
inspect_iolist_as_binary        4.70 M      212.98 ns  ±3767.72%         201 ns         271 ns
inspect_iovec                   2.10 M      476.91 ns  ±2636.68%         431 ns        1042 ns

Comparison:
inspect_binary                  6.19 M
inspect_iolist_as_binary        4.70 M - 1.32x slower +51.49 ns
inspect_iovec                   2.10 M - 2.95x slower +315.42 ns
```
