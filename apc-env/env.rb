require 'rubygems'
require 'sinatra'
require 'json/pure'

get '/' do
  res = "<html><body style=\"margin:0px auto; width:80%; font-family:monospace\">"
  res << "<head><title>Apcera HCOS Environment</title><meta name=\"viewport\" content=\"width=device-width\"></head>"
  res << "<img src=\"https://www.apcera.com/sites/default/files/apcera_logo_0.png\">"
  res << "<h2>Apcera Platform Environment</h2>"
  res << "<div><table>"
  ENV.keys.sort.each do |key|
    value = begin
                "<pre>" + JSON.pretty_generate(JSON.parse(ENV[key])) + "</pre>"
            rescue
                ENV[key]
            end
    res << "<tr><td><strong>#{key}</strong></td><td>#{value}</tr>"
  end
  res << "</table></div>"
  res << "<h2>HTTP Request Headers</h2>"
  res << "<div><table>"
  env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}.sort.each do |k,v|
    res << "<tr><td><strong>#{k}</strong></td><td>#{v}</tr>"
  end
  res << "</table></div></body></html>"
end
