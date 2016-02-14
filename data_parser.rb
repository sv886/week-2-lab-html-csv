require "erb"
require "csv"

html = File.read("report.erb")

page_title = "Report"

bundles = []

CSV.foreach("planet_express_logs.csv", headers: true) do |row|
  bundles << row.to_hash
end

fry_data = []
amy_data = []
bender_data = []
leela_data = []

names = bundles.map do |data|
  if data["Destination"] == "Earth"
    fry_data << data
  elsif data["Destination"] == "Mars"
    amy_data << data
  elsif data["Destination"] == "Uranus"
    bender_data << data
  else
    leela_data << data
  end
end

moon = []
jupiter = []
pluto = []
saturn = []
mercury = []

leela_planets = leela_data.map do |data|
  if data["Destination"] == "Moon"
    moon << data
  elsif data["Destination"] == "Jupiter"
    jupiter << data
  elsif data["Destination"] == "Pluto"
    pluto << data
  elsif data["Destination"] == "Saturn"
    saturn << data
  else
    mercury << data
  end
end

def formatted_number(n)
  a,b = sprintf("%0.2f", n).split('.')
  a.gsub!(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
  "$#{a}.#{b}"
end

new_html = ERB.new(html).result(binding)

File.open("report.html", "wb") do |file|
  file.write(new_html)
  file.close
end
