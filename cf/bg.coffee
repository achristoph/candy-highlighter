_gaq = _gaq || []
_gaq.push(['_setAccount', 'UA-41315960-1'])
_gaq.push(['_trackPageview'])

(() ->
  ga = document.createElement('script')
  ga.type = 'text/javascript'
  ga.async = true
  ga.src = 'https://stats.g.doubleclick.net/dc.js'
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore(ga, s)
)()

pxw = 72
pxh = 64
n_rows = 9
n_columns = 9
w = 756
h = 756
candies_in_grid = []

class Candy
  constructor: (@color, @row, @col, @rgb, @is_matched, @type, @candy_type) ->

best_color = (r, g, b, row, col) ->
  green = [50, 171, 1, 'G']
  blue = [42, 156, 255, 'B']
  purple = [199, 31, 255, 'P']

  yellow = [252, 200, 0, 'Y']
  orange = [255, 142, 11, 'O']
  red = [255, 1, 0, 'R']
  nut = [203, 67, 33, 'N']
  cherry = [119, 27, 30, 'c']
  gray = [217, 226, 224, 'g']
  bg = [92, 103, 125, 'bg']

  red_stripped = [246, 39, 39, 'RS']
  green_stripped = [115, 231, 84, 'GS']
  blue_stripped = [31, 148, 240, 'BS']
  purple_stripped = [218, 60, 250, 'PS']
  yellow_stripped = [252, 195, 27, 'YS']
  orange_stripped = [250, 191, 113, 'OS']

  red_caged = [155, 8, 10, 'RC']
  green_caged = [33, 97, 7, 'GC']
  blue_caged = []
  purple_caged = [163, 30, 221, 'PC']
  yellow_caged = [190, 125, 10, 'YC']
  orange_caged = []

  colors = [green , blue, purple, yellow, orange, red, nut, cherry, gray, red_stripped, blue_stripped, orange_stripped, purple_stripped, green_stripped, yellow_stripped]
  sim_scores = []
  for color in colors
    [r1, g1, b1] = [color[0], color[1], color[2]]
    sum_of_squares = Math.pow((r1 - r), 2) + Math.pow((g1 - g), 2) + Math.pow((b1 - b), 2)
    distance = 1 / (1 + Math.sqrt(sum_of_squares))
    sim_scores.push([distance * 100, color[3]])
  best_match = sim_scores.sort(compScore)[sim_scores.length - 1]
  if best_match[0] < 1.0
    return 'X' #other kinds
  else
    return best_match[1]

compScore = (a, b) ->
  return a[0] - b[0]

compNum = (a, b) ->
  return parseInt(a) - parseInt(b)

mark = (matched_candies, type, msg) ->
  for candy in matched_candies
    candy.is_matched = true
    if not candy.type
      candy.type = type
    else if type in ['L', 'T'] and candy.type in ['3', '4', '5']
      candy.type = type
    else if type in ['3', '4', '5'] and parseInt(type) > parseInt(candy.type)
      candy.type = type

median = (arr) ->
  l = arr.length
  return arr.sort(compNum)[Math.round(l / 2)]

avg = (arr) ->
  l = arr.length
  sum = 0
  for c in arr
    sum += c
  return sum / l

screen_init = () ->
  chrome.windows.getCurrent (w) ->
    if w.width > 1056 #or w.height < 888 #viewport: 1040 x 775
      chrome.windows.update w.id, {width: 1056}, () ->
        console.log "window resize"

  chrome.tabs.getSelected (tab) ->
    chrome.tabs.insertCSS tab.id, {file: 'page.css'}
    chrome.tabs.executeScript tab.id, {file: 'jquery-1.9.1.min.js'}, () ->
      chrome.tabs.executeScript tab.id, {file: 'page.js'}

capture = (scroll_pos, callback) ->
  view = chrome.extension.getBackgroundPage()
  canvas = view.document.getElementById('canvas')
  ctx = canvas.getContext('2d')
  canvas.width = w
  canvas.height = h
  sx = 108 - scroll_pos[0]
  sy = 180 - scroll_pos[1]

  chrome.tabs.captureVisibleTab (screenshot) ->
    img = new Image()
    img.src = screenshot
    #    img.src = "images/candy.png"
    img.onload = () ->
      ctx.drawImage(img, sx, sy, w - sx, h - sy, 0, 0, w - sx, h - sy)

      candies_in_grid = []
      candies_in_row = []

      for row in [0..n_rows - 1]
        for col in [0..n_columns - 1]
          x = (pxw / 2) + pxw * col
          y = (pxh / 2) + pxh * row

#          if row == 5 and col == 0
#            full_pixel = ctx.getImageData(x, y, pxw, pxh)
#            rgb = full_pixel.data
#            canvas.width = canvas.width
#            ar = (parseInt(rgb[i]) for i in [0..rgb.length - 1] by 4)
#            ag = (parseInt(rgb[i]) for i in [1..rgb.length - 1] by 4)
#            ab = (parseInt(rgb[i]) for i in [2..rgb.length - 1] by 4)
#            ctx.putImageData(full_pixel,0,0)
#            console.log row,col, ar, ab, ag

          pixel = ctx.getImageData(x, y, 15, 15)
          rgb = pixel.data
          ar = (parseInt(rgb[i]) for i in [0..rgb.length - 1] by 4)
          ag = (parseInt(rgb[i]) for i in [1..rgb.length - 1] by 4)
          ab = (parseInt(rgb[i]) for i in [2..rgb.length - 1] by 4)

          [r, g, b] = [median(ar), median(ag), median(ab)]

          bc = best_color(r, g, b, row, col)
          if bc == 'RS'
            e = new Candy 'R', row, col, [r, g, b]
            e.candy_type = 'S'
          else if bc == 'GS'
            e = new Candy 'G', row, col, [r, g, b]
            e.candy_type = 'S'
          else if bc == 'OS'
            e = new Candy 'O', row, col, [r, g, b]
            e.candy_type = 'S'
          else if bc == 'BS'
            e = new Candy 'B', row, col, [r, g, b]
            e.candy_type = 'S'
          else if bc == 'PS'
            e = new Candy 'P', row, col, [r, g, b]
            e.candy_type = 'S'
          else
            e = new Candy bc, row, col, [r, g, b]

          candies_in_row.push(e)

        candies_in_grid.push(candies_in_row)
        candies_in_row = []

      for row in candies_in_grid
        console.log(c.color for c in row)

      matches(candies_in_grid)
      if (callback)
        callback()

chrome.runtime.onMessage.addListener (request, sender, response) ->
  if request.msg == 'done'
    resp = () ->
      response(bg: candies_in_grid)
      console.log(candies_in_grid)
    capture(request.scroll_pos, resp)
  return true

chrome.browserAction.onClicked.addListener(screen_init)

matches = (a) ->
  rows = a.length

  for i in [0..rows - 1]
    for j in [0..a[i].length - 1]
      cols = a[i].length
      c = a[i][j]
      try
      # -x-
      # X-X
        if c.color in ['R', 'G', 'B', 'P', 'Y', 'O']
          if j + 2 < cols and i - 1 >= 0 and c.color == a[i - 1][j + 1].color and c.color == a[i][j + 2].color and a[i][j + 1].color != 'g'
            mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i - 1][j + 1]], '3', "3 horizontal in a row on middle above"
          # X-X
          # -x-
          if j + 2 < cols and i + 1 < rows and c.color == a[i + 1][j + 1].color and c.color == a[i][j + 2].color and a[i][j + 1].color != 'g'
            mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i + 1][j + 1]], '3', "3 horizontal in a row on middle below"
          #X
          #-x
          #X
          if i + 2 < rows and j + 1 < cols and c.color == a[i + 2][j].color and c.color == a[i + 1][j + 1].color and a[i + 1][j].color != 'g'
            mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 1][j + 1]], '3', "3 vertical in a row on middle right"

          #-X
          #x-
          #-X
          if i + 2 < rows and j - 1 >= 0 and c.color == a[i + 2][j].color and c.color == a[i + 1][j - 1].color and a[i + 1][j].color != 'g'
            mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 1][j - 1]], '3', "3 vertical in a row on middle left"

          #2 consecutive vertical candies found
          if i + 1 < rows and c.color == a[i + 1][j].color
            #3 vertical in a row ------------------------------------------------------------------------------------------
            #X
            #X
            #-
            #x
            if i + 3 < rows and c.color == a[i + 3][j].color and a[i + 2][j].color != 'g'
              mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 3][j]], '3', "3 vertical in a row on below"

            #X
            #X
            #-x
            if i + 2 < rows and j + 1 < cols and c.color == a[i + 2][j + 1].color and a[i + 2][j].color != 'g'
              mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 2][j + 1]], '3', "3 vertical in a row on right below"


            # X
            # X
            #x-
            if i + 2 < rows and j - 1 >= 0 and c.color == a[i + 2][j - 1].color and a[i + 2][j].color != 'g'
              mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 2][j - 1]], '3', "3 vertical in a row on left below"

            #x
            #-
            #X
            #X
            if i - 2 >= 0 and c.color == a[i - 2][j].color and a[i - 1][j].color != 'g'
              mark [a[i - 1][j], a[i][j], a[i + 1][j], a[i - 2][j]], '3', "3 vertical in a row on above"

            #x-
            #-X
            #-X
            if i - 1 >= 0 and j - 1 >= 0 and c.color == a[i - 1][j - 1].color and a[i - 1][j].color != 'g'
              mark [a[i - 1][j], a[i][j], a[i + 1][j], a[i - 1][j - 1]], '3', "3 vertical in a row on above left"

            #-x
            #X
            #X
            if i - 1 >= 0 and j + 1 < cols and c.color == a[i - 1][j + 1].color and a[i - 1][j].color != 'g'
              mark [a[i - 1][j], a[i][j], a[i + 1][j], a[i - 1][j + 1]], '3', "3 vertical in a row on above right"

            # 4 vertical in a row ----------------------------------------------------------------------------------------
            #X
            #X
            #-x
            #X
            if i + 3 < rows and j + 1 < cols and c.color == a[i + 3][j].color and c.color == a[i + 2][j + 1].color and a[i + 2][j].color != 'g'
              mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 3][j], a[i + 2][j + 1]], '4', "4 vertical in a row on below right"

            #-X
            #-X
            #x-
            # X
            if i + 3 < rows and j - 1 >= 0 and c.color == a[i + 3][j].color and c.color == a[i + 2][j - 1].color and a[i + 2][j].color != 'g'
              mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 3][j], a[i + 2][j - 1]], '4', "4 vertical in a row on below left"
            #X
            #-x
            #X
            #X
            if i - 2 >= 0 and j + 1 < cols and c.color == a[i - 2][j].color and c.color == a[i - 1][j + 1].color and a[i - 1][j].color != 'g'
              mark [a[i - 2][j], a[i - 1][j], a[i][j], a[i + 1][j], a[i - 1][j + 1]], '4', "4 vertical in a row on above right"

            #-X
            #x-
            #-X
            # X
            if i - 2 >= 0 and j - 1 >= 0 and c.color == a[i - 2][j].color and c.color == a[i - 1][j - 1].color and a[i - 1][j].color != 'g'
              mark [a[i - 2][j], a[i - 1][j], a[i][j], a[i + 1][j], a[i - 1][j - 1]], '4', "4 vertical in a row on above left"

            # 5 in a row ----------------------------------------------------------------------------------------
            #-X
            #-X
            #x-
            #-X
            # X
            if j - 1 >= 0 and i + 4 < rows and c.color == a[i + 3][j].color and c.color == a[i + 4][j].color and c.color == a[i + 2][j - 1].color and a[i + 2][j].color != 'g'
              mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 3][j], a[i + 4][j], a[i + 2][j - 1]], '5', "5 vertical in a row a middle candy left"

            #X
            #X
            #-x
            #X
            #X
            if i + 4 < rows and j + 1 < cols and c.color == a[i + 3][j].color and c.color == a[i + 4][j].color and c.color == a[i + 2][j + 1].color and a[i + 2][j].color != 'g'
              mark [a[i][j], a[i + 1][j], a[i + 2][j], a[i + 3][j], a[i + 4][j], a[i + 2][j + 1]], '5', "5 vertical in a row a middle candy right"

            # T shaped  with 2 consecutive vertical candies ---------------------------------------------------------
            #-x
            #X-X
            #-X
            #-X
            if j - 1 >= 0 and j + 1 < cols and i - 2 >= 0 and c.color == a[i - 1][j - 1].color and c.color == a[i - 1][j + 1].color and c.color == a[i - 2][j].color and a[i - 1][j].color != 'g'
              mark [a[i - 1][j - 1], a[i - 1][j], a[i - 1][j + 1], a[i][j], a[i + 1][j], a[i + 3][j]], 'T', "T"

            #-X
            #-X
            #X-X
            #-x
            if j - 1 >= 0 and j + 1 < cols and i + 3 < rows and c.color == a[i + 2][j - 1].color and c.color == a[i + 2][j + 1].color and c.color == a[i + 3][j].color and a[i + 2][j].color != 'g'
              mark [a[i][j], a[i + 1][j], a[i + 2][j - 1], a[i + 2][j], a[i + 2][j + 1], a[i + 3][j]], 'T', "Upsidedown T"

          #-------------------------------------------------------------------------------------------------------
          #2 consecutive horizontal candies found
          if j + 1 < cols and c.color == a[i][j + 1].color
            #3 in a row ------------------------------------------------------------------------------------------
            # XX-x
            if j + 3 < cols and c.color == a[i][j + 3].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i][j + 3]], '3', "3 horizontal in a row on right"

            # XX-
            # --x
            if i + 1 < rows and j + 2 < cols and c.color == a[i + 1][j + 2].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i + 1][j + 2]], '3', "3 horizontal in a row on right below"

            # --x
            # XX-
            if i - 1 >= 0 and j + 2 < cols and c.color == a[i - 1][j + 2].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i - 1][j + 2]], '3', "3 horizontal in a row on right above"

            # x-XX
            if j - 2 >= 0 and c.color == a[i][j - 2].color and a[i][j - 1].color != 'g'
              mark [a[i][j - 1], a[i][j], a[i][j + 1], a[i][j - 2]], '3', "3 horizontal in a row on left"

            # -XX
            # x--
            if i + 1 < rows and j - 2 >= 0 and c.color == a[i + 1][j - 1].color and a[i][j - 1].color != 'g'
              mark [a[i][j - 1], a[i][j], a[i][j + 1], a[i + 1][j - 1]], '3', "3 horizontal in a row on left below"

            # x--
            # -XX
            if i - 1 >= 0 and j - 1 >= 0 and c.color == a[i - 1][j - 1].color and a[i][j - 1].color != 'g'
              mark [a[i][j - 1], a[i][j], a[i][j + 1], a[i - 1][j - 1]], '3', "3 horizontal in a row on left above"

            # 4 in a row ----------------------------------------------------------------------------------------
            # --x-
            # XX-X
            if i - 1 >= 0 and j + 3 < cols and c.color == a[i][j + 3].color and c.color == a[i - 1][j + 2].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i][j + 3], a[i - 1][j + 2]], '4', "4 horizontal in a row on right above"

            # XX-X
            # --x-
            if i + 1 < rows and j + 3 < cols and c.color == a[i][j + 3].color and c.color == a[i + 1][j + 2].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i][j + 3], a[i + 1][j + 2]], '4', "4 horizontal in a row on right below"

            # X-XX
            # -x--
            if i + 1 < rows and j - 2 >= 0 and c.color == a[i][j - 2].color and c.color == a[i + 1][j - 1].color and a[i][j - 1].color != 'g'
              mark [a[i][j - 2], a[i][j - 1], a[i][j], a[i][j + 1], a[i + 1][j - 1]], '4', "4 horizontal in a row on left below"

            # -x--
            # X-XX
            if i - 1 >= 0 and j - 2 >= 0 and c.color == a[i][j - 2].color and c.color == a[i - 1][j - 1].color and a[i][j - 1].color != 'g'
              mark [a[i][j - 2], a[i][j - 1], a[i][j], a[i][j + 1], a[i - 1][j - 1]], '4', "4 horizontal in a row on left above"

            # 5 in a row ----------------------------------------------------------------------------------------
            # XX-XX
            # --x--
            if i + 1 < rows and j + 4 < cols and c.color == a[i][j + 3].color and c.color == a[i][j + 4].color and c.color == a[i + 1][j + 2].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i][j + 3], a[i][j + 4], a[i + 1][j + 2]], '5', "5 horizontal in a row a middle candy below"

            # --x--
            # XX-XX
            if i - 1 >= 0 and j + 4 < cols and c.color == a[i][j + 3].color and c.color == a[i][j + 4] and c == a[i - 1][j + 2] and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i][j + 3], a[i][j + 4], a[i - 1][j + 2]], '5', "5 horizontal in a row a middle candy above"

            # L shaped, all combinations --------------------------------------------------------------------------
            # X
            # X
            # -XX
            # x
            if i - 2 >= 0 and j - 1 >= 0 and i + 1 < rows and c.color == a[i - 2][j - 1].color and c.color == a[i - 1][j - 1].color and c.color == a[i + 1][j - 1].color and a[i][j - 1].color != 'g'
              mark [a[i - 2][j - 1], a[i - 1][j - 1], a[i][j - 1], a[i][j], a[i][j + 1], a[i + 1][j - 1]], 'L', "L in a row below"

            #  X
            #  X
            # x-XX
            if i - 2 >= 0 and j - 2 >= 0 and c.color == a[i - 2][j - 1].color and c.color == a[i - 1][j - 1].color and c.color == a[i][j - 2].color and a[i][j - 1].color != 'g'
              mark [a[i - 2][j - 1], a[i - 1][j - 1], a[i][j - 1], a[i][j], a[i][j + 1], a[i][j - 2]], 'L', "L in a same row left"

            #   X
            #   X
            # XX-x
            if i - 2 >= 0 and j + 2 < cols and c.color == a[i - 1][j + 2].color and c.color == a[i - 2][j + 2].color and c.color == a[i][j + 3].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i - 1][j + 2], a[i - 2][j + 2], a[i][j + 3]], 'L', "Reversed L in a same row right"

            #   X
            #   X
            # XX-
            #   x
            if i - 2 >= 0 and j + 2 < cols and c.color == a[i - 1][j + 2].color and c.color == a[i - 2][j + 2].color and c.color == a[i + 1][j + 2].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i - 1][j + 2], a[i - 2][j + 2], a[i + 1][j + 2]], 'L', "Reversed L in a row below"

            # x
            # -XX
            # X
            # X
            if i + 2 < rows and i - 1 >= 0 and j + 1 < cols and j - 1 >= 0 and c.color == a[i + 1][j - 1].color and c.color == a[i + 2][j - 1].color and c.color == a[i - 1][j - 1].color and a[i][j - 1].color != 'g'
              mark [a[i + 2][j - 1], a[i + 1][j - 1], a[i][j - 1], a[i][j], a[i][j + 1], a[i - 1][j - 1]], 'L', "Upside-down L in a row above"

            # x-XX
            # -X
            # -X
            if i + 2 < rows and j - 2 >= 0 and c.color == a[i + 1][j - 1].color and c.color == a[i + 2][j - 1].color and c.color == a[i][j - 2].color and a[i][j - 1].color != 'g'
              mark [a[i + 2][j - 1], a[i + 1][j - 1], a[i][j - 1], a[i][j], a[i][j + 1], a[i][j - 2]], 'L', "Upside-down L in a same row left"

            #   x
            # XX-
            #   X
            #   X
            if i - 1 >= 0 and i + 2 < rows and j + 2 < cols and c.color == a[i + 1][j + 2].color and c.color == a[i + 2][j + 2].color and c.color == a[i - 1][j + 2].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i + 1][j + 2], a[i + 2][j + 2], a[i - 1][j + 2]], 'L', "Upside-down reversed L in a row above"

            # XX-x
            #   X
            #   X
            if i + 2 < rows and j + 3 < cols and c.color == a[i + 1][j + 2].color and c.color == a[i + 2][j + 2].color and c == a[i][j + 3] and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i][j + 2], a[i + 1][j + 2], a[i + 2][j + 2], a[i][j + 3]], 'L', "Upside-down reversed L in a same row right"

            #T with two consecutive horizontal candies  ---------------------------------------------------------
            #--X
            #XX-x
            #--X
            if i - 1 >= 0 and i + 1 < rows and j + 3 < cols and c.color == a[i - 1][j + 2].color and c.color == a[i + 1][j + 2].color and c.color == a[i][j + 3].color and a[i][j + 2].color != 'g'
              mark [a[i][j], a[i][j + 1], a[i - 1][j + 2], a[i][j + 2], a[i + 1][j + 2], a[i][j + 3]], 'T', "Right T"

            #-X
            #x-XX
            #-X
            if i - 1 >= 0 and i + 1 < rows and j - 2 >= 0 and c.color == a[i - 1][j - 1].color and c.color == a[i + 1][j - 1].color and c.color == a[i][j - 2].color and a[i][j - 1].color != 'g'
              mark [a[i - 1][j - 1], a[i][j - 1], a[i + 1][j - 1], a[i][j], a[i][j + 1], a[i][j - 2]], 'T', "Left T"

      catch error
        console.log(error)
        console.log("#{i} #{j}")



