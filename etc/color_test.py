#image size 72x64

#def distance([r,g,b]):
#  sum_of_squares=sum([pow(prefs[person1][item]-prefs[person2][item],2)
#                      for item in si])
#  return 1/(1+sqrt(sum_of_squares))

red = [255, 0, 0]
#green 0 255 0

#yellow 255 255 0
#orange 255 137 0

#purple 200 0 255
#blue 0 100 255

import Image
im = Image.open("images/orange.png")
print im.size

#mx = im.size[0]/2
#my = im.size[1]/2
##print mx,my
#
#max = 0
#min = 255
#i = 1
#arr = []
#x = []
#for x in range(15):
#  for y in range(15):
#    px = im.getpixel((mx+x,my+y))
#    arr.append(px[i])
#    if px[i] < min:
#      min = px[i]
#    if px[i] > max:
#      max = px[i]
##    print im.getpixel((mx+x,my+y))
##    print im.getpixel((mx-x,my-y))
#
#print min, max
#print sorted(arr)
