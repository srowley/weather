defmodule Weather.CLI do

  import SweetXml

  def run(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    [ head | tail ] = elem(OptionParser.parse(argv), 1)
    { head, Enum.map(tail, &(String.to_atom(&1))) }
      |> fetch
      |> present
  end

  def fetch({ station, measurements }) do
    url(station)
      |> get_xml
      |> parse_xml(measurements)
  end

  def url(station) do
    "https://w1.weather.gov/xml/current_obs/#{station}.xml"
  end

  def get_xml(url) do
    HTTPoison.get(url)
  end

  def parse_xml({ :ok, %{ body: body}}, measurements) do
    parsed = parse(body)
    Enum.map measurements,  &({ &1, xpath(parsed, ~x"//#{&1}/text()"s) })
  end

  def present(weather_data) do
    headers = Enum.map Keyword.keys(weather_data), &(Atom.to_string(&1))
    values = Keyword.values weather_data
    measurement_column_width = column_width headers
    value_column_width = column_width values
    measurement_pad = max(measurement_column_width, 11)
    value_pad = max(value_column_width, 5)
    IO.puts String.pad_trailing("Measurement", measurement_pad) <> " | " <> String.pad_trailing("Value", value_pad)
    IO.puts divider([measurement_pad, value_pad])
    Enum.each weather_data, &(IO.puts(data_line(transpose(&1), measurement_pad, value_pad)))
  end

  def column_width(list) do
    list 
      |> Enum.max_by(&(String.length(&1)))
      |> String.length
  end

  def divider(column_widths) do
    column_widths
    |> Enum.map(&(&1 + 1))
    |> Enum.map_join("+", &(String.duplicate("-", &1)))
  end

  def transpose(kw_pair) do
    [Atom.to_string(elem(kw_pair, 0)), elem(kw_pair, 1)]
  end

  def data_line([measurement, value], measurement_pad, value_pad) do
    String.pad_trailing(measurement, measurement_pad) <> " | " <> String.pad_trailing(value, value_pad)
  end
end
