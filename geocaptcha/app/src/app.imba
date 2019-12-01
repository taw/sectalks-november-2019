let cities = require("./cities.json")

let def randint(min, max)
  min + Math.floor(Math.random() * (max - min + 1))

let def radians(degrees)
  degrees * Math:PI / 180

# https://www.movable-type.co.uk/scripts/latlong.html
let def distance(lat1, lat2, lon1, lon2)
  let r = 6371 # km
  let phi1 = radians(lat1)
  let phi2 = radians(lat2)
  let dphi = radians(lat2 - lat1)
  let dlambda = radians(lon2 - lon1)

  let a = Math.sin(dphi / 2) * Math.sin(dphi / 2) +
          Math.cos(phi1) * Math.cos(phi2) *
          Math.sin(dlambda / 2) * Math.sin(dlambda / 2)
  let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

  let d = r * c

tag Map < img
  def onclick(event)
    let native_event = event.event
    let el = native_event:target
    let rect = el.getBoundingClientRect()
    let offset_x = native_event:pageX - rect:left
    let offset_y = native_event:pageY - rect:top
    let perc_x = offset_x / rect:width
    let perc_y = offset_y / rect:height
    let lon = -180 + 360 * perc_x
    let lat = 90 - 180 * perc_y
    trigger("mapclick", [lat, lon])

  def render
    <self.map src="earth.jpg">

tag Markers < svg:svg
  prop city
  prop clicked

  def y(lat)
    "{ (- lat + 90) / 180 * 50 }vw"

  def x(lon)
    "{ (lon + 180) / 360 * 100 }vw"

  def render
    let y1 = y(city:lat)
    let x1 = x(city:lon)
    let y2 = y(clicked[0])
    let x2 = x(clicked[1])
    <self>
      <svg:line x1=x1 y1=y1 x2=x2 y2=y2>
      <svg:circle.actual cx=x1 cy=y1>
      <svg:circle.clicked cx=x2 cy=y2>

tag App
  def onmapclick(event, latlon)
    @guess_latlon = latlon
    @distance = Math.round(distance(
      @city:lat,
      @guess_latlon[0],
      @city:lon
      @guess_latlon[1]
    ))
    if @distance < 1000
      next-stage()
      @city = random_city
    else
      @flag = "This is {@distance} km off. You are either a robot or a bad human. Let me help you."
      @done = true
      let search = "Where is human city of {@city:name}"
      document:location = "https://lmgtfy.me/?q={search}"

  def next-stage()
    @counter += 1
    mix(@counter + Math.floor(@distance / 1000))
    if @counter == 20
      mix(cities:length)
      @done = true
      let chars = @data.map do |c|
        String.fromCharCode(c)
      @flag = chars.join("")

  def mix(key)
    let prime = 104729
    for i in [0...@len]
      @data[i] = (@data[i] * 2 + i * 3 + key * 5) % prime
    let chars = @data.map do |c|
      String.fromCharCode(c)

  def oncontextmenu(event)
    document:location = "https://twitter.com/Seathorne74/status/1115466512737943553"
    return false

  def random_city
    cities[randint(0, cities:length - 1)]

  def setup
    @state = "guess"
    @city = random_city
    @flag = "Flag is available to humans only."
    @data = [20640, 85604, 16216, 81180, 84292, 6068, 50245, 75447, 6059, 75441, 101946, 48927, 75432, 88683, 320, 35661, 60863, 26819, 69693, 56436, 74105, 65266, 74099, 16662, 68372, 7820, 59530, 68363, 81614, 93562, 10920, 31704]
    @len = @data:length
    @counter = 0
    mix(cities:length)

  def render
    <self>
      if @done
        "Flag is {@flag}"
      else
        <div.instructions>
          "To make sure you're not a robot, we'll ask you to click a few cities."
        <div.instructions>
          "These cities all contain a lot of humans, so a real human would have no trouble with this."
        <div.instructions>
          "Where is "
          <b>
            "{@city:name} (population {@city:pop})"
        <Map>

Imba.mount <App>
