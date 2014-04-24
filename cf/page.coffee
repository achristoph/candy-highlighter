_gaq = _gaq || []
_gaq.push(['_setAccount', 'UA-41315960-1'])
_gaq.push(['_trackPageview'])

(() ->
  ga = document.createElement('script')
  ga.type = 'text/javascript'
  ga.async = true
  ga.src = 'https://ssl.google-analytics.com/ga.js'
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore(ga, s)
)()

pxw = 72
pxh = 64

$ ->
  [canvas_width,canvas_height] = ["648","576"]
  clear_canvas = () ->
    canvas = document.getElementById("canvas")
    ctx = canvas.getContext('2d')
    ctx.clearRect(0, 0, canvas.width, canvas.height)

  send_msg = () ->
    chrome.runtime.sendMessage {msg: 'done', scroll_pos: [window.scrollX, window.scrollY]}, (response) ->
      candies_in_grid = response.bg
      ctx = document.getElementById("canvas").getContext('2d')
      for t in ['3', '4', '5', 'T', 'L']
        fillColor(ctx, candies_in_grid, t)

  if $("#canvas").length
    $("#canvas").show()
    clear_canvas()
    setTimeout(send_msg, 10)
  else
    canvas = document.createElement("canvas")
    canvas.setAttribute("id", "canvas")
    canvas.setAttribute("width",canvas_width)
    canvas.setAttribute("height",canvas_height)
    $("body").append(canvas)

  $("#canvas").mousedown (e) ->
    canvas = document.getElementById("canvas")
    ctx = canvas.getContext('2d')
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    $("#canvas").hide()

  fillColor = (ctx, candies_in_grid, type) ->
    fill_color =
      switch
        when type == '3' then "rgba(255, 255, 0, 0.3)"
        when type == '4' then "rgba(255, 0, 0, 0.3)"
        when type == '5' then "rgba(0, 255, 0, 0.3)"
        when type == 'T' then "rgba(0, 255, 255, 0.3)"
        when type == 'L' then "rgba(0, 255, 255, 0.3)"

    ctx.fillStyle = fill_color
    for row in candies_in_grid
      for candy in row
        if candy.is_matched and candy.type == type
          ctx.fillRect(pxw * candy.col, pxh * candy.row, pxw, pxh)

