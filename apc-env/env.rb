require 'rubygems'
require 'sinatra'
require 'json/pure'

get '/' do
  res = "<html>"
  res << "<head><title>Apcera Platform Environment</title><meta name=\"viewport\" content=\"width=device-width\">
  <link rel=\"stylesheet\" href=\"//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css\">
  <style>
    table { table-layout: fixed; }
    table th, table td { overflow: hidden; }
  </style>
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  <script src=\"//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.js\" type=\"text/javascript\"></script>
  <script src=\"//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js\"></script></head>"
  res << "<body style=\"padding-top: 10px; padding-left: 20px; padding-right: 20px; padding-bottom: 10px; \">"
  res << "<p></p><img src=\"https://www.apcera.com/sites/default/files/apcera_logo_0.png\">"
  res << "<h3>Apcera Platform Environment Variables</h3>"
  res << "<div class=\"well well-sm\" style=\"width: 80%\"><table class=\"table table-striped\" style=\"width: 100%\">"
  ENV.keys.sort.each do |key|
    value = begin
                "<pre>" + JSON.pretty_generate(JSON.parse(ENV[key])) + "</pre>"
            rescue
                ENV[key]
            end
    res << "<tr><td style=\"width: 30%\"><strong>#{key}</strong></td><td>#{value}</td></tr>"
  end
  res << "</table></div>"
  res << "<h3>HTTP Request Headers</h3>"
  res << "<div class=\"well well-sm\" style=\"width: 80%\"><table class=\"table table-striped\" style=\"width: 100%\">"
  env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}.sort.each do |k,v|
    res << "<tr><td style=\"width: 30%\"><strong>#{k}</strong></td><td>#{v}</td></tr>"
  end
  res << "</table></div></body></html>"
end
