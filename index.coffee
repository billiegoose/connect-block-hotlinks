# Author: William Hilton
# License: https://opensource.org/licenses/MIT
url = require 'url'

stripSubdomains = (host) ->
  host = host.split('.')
  if host.length > 2
    host = host[-2..-1]
  host = host.join('.')

# Mitigate hotlinking and cross-site request forgery
module.exports = (req, res, next) ->
  # Who are we? (Strip subdomains)
  host = req.hostname
  return res.status(403).send("Missing 'Host' HTTP Header") if not host?
  host = stripSubdomains host
  # Check Referer
  referer = req.get 'Referer'
  return res.status(403).send("Missing 'Referer' HTTP Header") if not referer?
  # Compare referer to host
  try
    referer = url.parse referer
  catch
    return next Error "url.parse(#{referer}) throws error"
  referer = stripSubdomains referer.hostname
  # If they don't match, serve up a 'hotlinking-disallowed' image.
  if referer isnt host
    return res.status(200).sendFile __dirname + '/hotlinking-disallowed.png'
  return next()
