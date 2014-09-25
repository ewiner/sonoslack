#!./node_modules/.bin/iced

sonos = require('sonos')
request = require("request")
randomColor = require("randomcolor")

config = require('./config.json')

lastArtist = null
lastTitle = null
isBroke = false

mySonos = null
if config.sonosIpAddress == "detect"
  await(sonos.search(defer(mySonos)))
else
  mySonos = new sonos.Sonos(config.sonosIpAddress)

postToChat = (message) ->
  await(request.post({
    uri: config.slackIncomingWebHookUrl
    body: JSON.stringify(message)
  }, defer(err)))
  if err?
    console.error("Error posting to chat: #{err}")


checkSong = ->
  await(mySonos.currentTrack(defer(err, track)))
  if err? or not track?
    if not isBroke
      isBroke = true
      console.error("Error connecting to Sonos: #{err}")
      postToChat(text: "Error: #{err}")
  else if track.artist != lastArtist or track.title != lastTitle
    isBroke = false
    lastArtist = track.artist
    lastTitle = track.title
    oneLiner = "#{track.artist} - #{track.title}"
    console.log(oneLiner)

    postToChat(
      attachments: [
        {
          fallback: oneLiner
          color: randomColor()
          fields: [
            {
              title: track.artist
              value: track.title
              short: true
            }
          ]
        }
      ]
    )

checkSong()
setInterval(checkSong, 5000)