defmodule JT do
  @multiplier 100_000_000
  @dir_with_json "test_files"
  @exclude_files []

  def run() do
    run_all([
      {
        "Poison",
         &Poison.decode!/1,
         &Poison.encode!/1
      },
      {
        ":jiffy",
        &(:jiffy.decode(&1, [:return_maps, :use_nil])),
        &(:jiffy.encode(&1, [:use_nil]))
      },
      {
        "JSON",
        &JSON.decode!/1,
        &JSON.encode!/1,
      }
    ])
  end

  def run_all([{label, func_dec, func_enc} | other_tests]) do
    files = File.ls!(@dir_with_json) |> Enum.filter(&(not &1 in @exclude_files))
    data = for f <- files, do: {f, nil, nil}
    timings = run_bunch(label, data, func_dec, func_enc)
    data = Enum.zip(files, timings) |> Enum.map(fn ({a, {b, c}}) -> {a, b, c} end)
    run_all(other_tests, data)
  end

  def run_all([{label, func_dec, func_enc} | other_tests], data) do
    run_bunch(label, data, func_dec, func_enc)
    run_all(other_tests, data)
  end

  def run_all([], _) do
    IO.puts "All tests are complete"
  end

  def run_bunch(label, data, fun_dec, fun_enc) do
    IO.puts "Test #{label}"
    times = Enum.map(data, fn ({file, d, e}) -> run_test(file, fun_dec, fun_enc, d, e) end)
    IO.puts ""
    times
  end

  def run_test(f_name, fun_dec, fun_enc, nom_dec \\ nil, nom_enc \\ nil) do
    t = times(f_name)
    :io.format("# ~-28s ~10.1fKb ~10B times ", ["'#{f_name}'", size(f_name)/1000, t])
    time_dec = json(f_name) |> test(fun_dec, t)
    time_enc = struc(f_name) |> test(fun_enc, t)
    {pd, pe} = f_time(time_dec, time_enc, nom_dec, nom_enc)
    :io.format(
      "~10.3f/~-10.3f ~8.1f% ~8.1f%  (decode/encode seconds and %)~n",
      [time_dec/1000_000, time_enc/1000_000, pd, pe]
    )
    {time_dec, time_enc}
  end

  def f_time(_, _, :nil, :nil), do: {100.0, 100.0}
  def f_time(dec, enc, t_dec, t_enc), do: {100*dec/t_dec, 100*enc/t_enc}

  def test(data, fun, times \\ 100) do
    start = current_time()
    for _ <- 1..times, do: fun.(data)
    stop = current_time()
    time_diff(start, stop)
  end

  defp json(name), do: File.read! "#{@dir_with_json}/#{name}"
  defp struc(name), do: json(name) |> Poison.decode!
  defp size(name), do: File.stat!("#{@dir_with_json}/#{name}").size
  defp times(name), do: Math.pow(10, round(Math.log10(@multiplier/size(name))))

  defp current_time, do: :erlang.monotonic_time
  defp time_diff(start, stop), do: :erlang.convert_time_unit(stop - start, :native, :micro_seconds)
end
