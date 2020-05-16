defmodule Cal do
  @moduledoc """
  Documentation for `Cal`, an Elixir mimic of the terminal `cal` command
  """
  @header_days ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

  @month_names %{
    1 => "January",
    2 => "February",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "August",
    9 => "September",
    10 => "October",
    11 => "November",
    12 => "December"
  }

  @doc """
  Generate a list of lists, each list containing 7 elements (one for each day)

  0 1 2 3 4 5 6

  [
    [nil, nil, nil, 1, 2, 3, 4],
    [5, 6, 7, 8, 9, 10, 11],
    # ...
  ]
  """
  def generate(year, month) when is_integer(year) and is_integer(month) do
    case Date.new(year, month, 1) do
      {:ok, _date} ->
        day_of_week = Calendar.ISO.day_of_week(year, month, 1)
        days_in_month = Calendar.ISO.days_in_month(year, month)
        all_days = Enum.to_list(1..days_in_month)
        pre_padding = List.duplicate(nil, day_of_week)
        calendar_slots = @header_days ++ pre_padding ++ all_days

        {:ok,
         %{
           weeks: Enum.chunk_every(calendar_slots, 7),
           year: year,
           month_name: @month_names[month]
         }}

      {:error, error} ->
        {:error, error}
    end
  end
end
