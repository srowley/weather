defmodule WeatherTest do
  use ExUnit.Case
  doctest Weather

  import SweetXml
  import ExUnit.CaptureIO

  alias Weather.CLI, as: CLI

  test "url" do
    assert CLI.url("KXXX") == "https://w1.weather.gov/xml/current_obs/KXXX.xml"
  end

  test "parse_xml" do
    test_xml = "<foo>bar</foo>"
    assert CLI.parse_xml({ :ok, %{ body: test_xml }}, [:foo] ) ==  [foo: "bar"]
  end

  test "present" do
    result = capture_io fn -> CLI.present([foo: "bar"]) end
    assert result == """
    Measurement | Value
    ------------+------
    foo         | bar  
    """
  end

  test "column_width" do
    assert CLI.column_width(["five_", "six___", "seven__", "eight___"]) == 8
  end

  test "divider" do
    assert CLI.divider([8, 4]) == "---------+-----"
  end

  test "data_line" do 
    assert CLI.data_line(["temperature", "100.5"], 10, 5) == "temperature | 100.5"
  end

  test "transpose" do
    assert CLI.transpose({:key, "value"}) == ["key", "value"]
  end
end
