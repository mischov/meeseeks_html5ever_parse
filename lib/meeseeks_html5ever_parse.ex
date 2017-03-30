defmodule MeeseeksHtml5everParse do
  @html File.read! "data/github.html"
  @tuples (case Html5ever.parse(@html) do
            {:ok, result} ->  result
            {:error, err} -> {:error, err}
          end)

  def run do
    IO.puts "Running tests..."

    html5ever_async = time(&html5ever_parse_async/0)
    html5ever_sync = time(&html5ever_parse_sync/0)
    meeseeks_document = time(&meeseeks_document/0)
    meeseeks_async = time(&meeseeks_parse_async/0)
    meeseeks_sync = time(&meeseeks_parse_sync/0)

    IO.puts "Parsed with Html5ever async in #{html5ever_async} us"
    IO.puts "Parsed with Html5ever sync in #{html5ever_sync} us"
    IO.puts ""
    IO.puts "Created Meeseeks Document from tuples in #{meeseeks_document} us"
    IO.puts ""
    IO.puts "Parsed with Meeseeks async in #{meeseeks_async} us"
    IO.puts "Parsed with Meeseeks sync in #{meeseeks_sync} us"
  end

  def meeseeks_parse_async do
    case html5ever_parse_async() do
      {:ok, result} -> Meeseeks.Document.new(result)
      {:error, err} -> {:error, err}
    end
  end

  def meeseeks_parse_sync do
    case html5ever_parse_sync() do
      {:ok, result} -> Meeseeks.Document.new(result)
      {:error, err} -> {:error, err}
    end
  end

  def meeseeks_document do
    Meeseeks.Document.new(@tuples)
  end

  def html5ever_parse_async do
    Html5ever.Native.parse_async(@html)
    receive do
      {:html5ever_nif_result, :ok, result} -> {:ok, result}
      {:html5ever_nif_result, :error, err} -> {:error, err}
    end
  end

  def html5ever_parse_sync do
    case Html5ever.Native.parse_sync(@html) do
      {:html5ever_nif_result, :ok, result} -> {:ok, result}
      {:html5ever_nif_result, :error, err} -> {:error, err}
    end
  end

  def time(f) do
    runs = 10
    # Warmup
    for _ <- 1..5, do: f.()

    # Run
    times = for _ <- 1..runs do
      {time, _} = :timer.tc(f)
      time
    end

    # Average
    total_time = Enum.reduce(times, 0, &(&2 + &1))
    total_time / runs
  end
end
