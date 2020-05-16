defmodule Mix.Tasks.Cal do
  use Mix.Task

  @help """
  NAME
     cal -- displays a simple calendar emulating the *unix utility of the same name.

  SYNOPSIS
     cal [[month] year]

  DESCRIPTION
     The cal utility displays a simple calendar in traditional format.
     If arguments are not specified, the current month is displayed.
  """
  def run([month, year]) do
    year = String.to_integer(year)
    month = String.to_integer(month)
    do_calendar(month, year)
  end

  def run(["--help"]) do
    # This is the quickie solution. For a more robust solution
    # see https://hexdocs.pm/elixir/OptionParser.html
    IO.puts(@help)
  end

  def run([month]) do
    month = String.to_integer(month)
    %{month: _, year: year} = Date.utc_today()
    do_calendar(month, year)
  end

  def run(_) do
    %{month: month, year: year} = Date.utc_today()
    do_calendar(month, year)
  end

  defp do_calendar(month, year) do
    case Cal.generate(year, month) do
      {:ok, %{weeks: weeks,
        month_name: month_name,
        year: year}} -> print_heading(month_name, year)
                        Enum.each(weeks, fn w ->
                          row = Enum.reduce(w, "", fn d, acc->
                            acc <> String.pad_leading("#{d}", 3)
                          end)
                          IO.puts(row)
                        end)
      {:error, error} -> Mix.shell().error(inspect(error))
    end
  end

  defp print_heading(month_name, year) do
    IO.puts(
      IO.ANSI.blue_background() <>
      IO.ANSI.bright() <>
      "    #{month_name} #{year}   " <>
      IO.ANSI.default_background() <> IO.ANSI.normal() <> IO.ANSI.reset()
    )
  end
end
