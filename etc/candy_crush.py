a = [
  ['R', 'R', '-', 'R', 'R'],
  ['-', '-', 'R', '-', '-'],
  ['R', 'R', '-', 'R', 'R']
]

#a = [
#  ['-', 'R', '-', '-', 'R', '-'],
#  ['-', 'R', '-', '-', 'R', '-'],
#  ['R', '-', 'R', 'R', '-', 'R'],
#  ['-', 'R', '-', '-', 'R', '-']
#]

#a = [
#  ['-', 'R', '-', 'R', '-', '-'],
#  ['R', '-', 'R', '-', 'R', 'R'],
#  ['-', 'R', '-', 'R', '-', '-'],
#  ['-', 'R', '-', 'R', '-', '-']
#]

#L
#a = [
#  ['-', '-', 'R', '-'],
#  ['R', 'R', '-', 'R'],
#  ['-', '-', 'R', '-'],
#  ['-', '-', 'R', '-']
#]

# Horizontal T
#a = [
#  ['-', '-', 'R', '-'],
#  ['R', 'R', '-', 'R'],
#  ['-', 'R', 'R-', '-'],
#  ['R', '-', 'R', 'R'],
#  ['-', 'R', '-', '-']
#]

def mark(arr, candy=[]): #mark candies for score
  return [arr, candy]


def matches():
  rows = len(a)
  for i in range(len(a)): #row
    for j in range(len(a[i])): #column
      cols = len(a[i])
      c = a[i][j]
      #--------------------------------------------------------------------------------------------
      # -x-
      # X-X
      if j + 2 < cols and i - 1 >= 0 and c == a[i - 1][j + 1] and c == a[i][j + 2] and c in ['R']:
        print "3 horizontal in a row on middle above: {0}".format(
          mark([[i, j], [i, j + 1], [i, j + 2]], [i - 1, j + 1]))

      # X-X
      # -x-
      if j + 2 < cols and i + 1 < rows and c == a[i + 1][j + 1] and c == a[i][j + 2] and c in ['R']:
        print "3 horizontal in a row on middle below: {0}".format(
          mark([[i, j], [i, j + 1], [i, j + 2]], [i + 1, j + 1]))

      #X
      #-x
      #X
      if i + 2 < rows and j + 1 < cols and c == a[i + 2][j] and c == a[i + 1][j + 1]:
        print "3 vertical in a row on middle right: {0}".format(mark([[i, j], [i + 1, j], [i + 2, j]], [i + 1, j + 1]))

      #-X
      #x-
      #-X
      if i + 2 < rows and j - 1 >= 0 and c == a[i + 2][j] and c == a[i + 1][j - 1]:
        print "3 vertical in a row on middle left: {0}".format(mark([[i, j], [i + 1, j], [i + 2, j]], [i + 1, j - 1]))

      #---------------------------------------------------------------------------------------------
      #2 consecutive vertical candies found
      if i + 1 < rows and c == a[i + 1][j] and c in ['R']:
        #3 vertical in a row ------------------------------------------------------------------------------------------
        #X
        #X
        #-
        #x
        if i + 3 < rows and c == a[i + 3][j]:
          print "3 vertical in a row on below: {0}".format(mark([[i, j], [i + 1, j], [i + 2, j]], [i + 3, j]))

        #X
        #X
        #-x
        if i + 2 < rows and j + 1 < cols and c == a[i + 2][j + 1]:
          print "3 vertical in a row on right below: {0}".format(mark([[i, j], [i + 1, j], [i + 2, j]], [i + 2, j + 1]))


        # X
        # X
        #x-
        if i + 2 < rows and j - 1 >= 0 and c == a[i + 2][j - 1]:
          print "3 vertical in a row on left below: {0}".format(mark([[i, j], [i + 1, j], [i + 2, j]], [i + 2][j - 1]))

        #x
        #-
        #X
        #X
        if i - 2 >= 0 and c == a[i - 2][j]:
          print "3 vertical in a row on above: {0}".format(mark([[i - 1, j], [i, j], [i + 1, j], ], [i - 2, j]))

        #x-
        #-X
        #-X
        if i - 1 >= 0 and j - 1 >= 0 and c == a[i - 1][j - 1]:
          print "3 vertical in a row on above left: {0}".format(mark([[i - 1, j], [i, j], [i + 1, j]], [i - 1, j - 1]))

        #-x
        #X
        #X
        if i - 1 >= 0 and j + 1 < cols and c == a[i - 1][j + 1]:
          print "3 vertical in a row on above right: {0}".format(mark([[i - 1, j], [i, j], [i + 1, j]], [i - 1, j + 1]))

        # 4 vertical in a row ----------------------------------------------------------------------------------------
        #X
        #X
        #-x
        #X
        if i + 3 < rows and j + 1 < cols and c == a[i + 3][j] and c == a[i + 2][j + 1]:
          print "4 vertical in a row on below right: {0}".format(
            mark([[i, j], [i + 1, j], [i + 2, j], [i + 3, j]], [i + 2, j + 1]))

        #-X
        #-X
        #x-
        # X
        if i + 2 < rows and j - 1 >= 0 and c == a[i + 3][j] and c == a[i + 2][j - 1]:
          print "4 vertical in a row on below left: {0}".format(
            mark([[i, j], [i + 1, j], [i + 2, j], [i + 3, j]], [i + 2, j - 1]))

        #X
        #-x
        #X
        #X
        if i - 2 >= 0 and j + 1 < cols and c == a[i - 2][j] and c == a[i - 1][j + 1]:
          print "4 vertical in a row on above right: {0}".format(
            mark([[i - 2, j], [i - 1, j], [i, j], [i + 1, j]], [i - 1, j + 1]))

        #-X
        #x-
        #-X
        # X
        if i - 2 >= 0 and j - 1 >= 0 and c == a[i - 2][j] and c == a[i - 1][j - 1]:
          print "4 vertical in a row on above left: {0}".format(
            mark([[i - 2, j], [i - 1, j], [i, j], [i + 1, j]], [i - 1, j - 1]))

        # 5 in a row ----------------------------------------------------------------------------------------
        #-X
        #-X
        #x-
        #-X
        # X
        if j - 1 >= 0 and i + 4 < rows and c == a[i + 3][j]\
           and c == a[i + 4][j] and c == a[i + 2][j - 1]:
          print "5 vertical in a row a middle candy left: {0}".format(
            mark([[i, j], [i + 1, j], [i + 2, j], [i + 3, j], [i + 4, j]], [i + 2, j - 1]))

        #X
        #X
        #-x
        #X
        #X
        if i + 4 < rows and j + 1 < cols and c == a[i + 3][j]\
           and c == a[i + 4][j] and c == a[i + 2][j + 1]:
          print "5 vertical in a row a middle candy right: {0}".format(
            mark([[i, j], [i + 1, j], [i + 2, j], [i + 3, j], [i + 4, j]], [i + 2, j + 1]))

        # T shaped  with 2 consecutive vertical candies ---------------------------------------------------------
        #-x
        #X-X
        #-X
        #-X
        if j - 1 >= 0 and j + 1 < cols and i - 2 >= 0 and  c == a[i - 1][j - 1] and c == a[i + 1][j - 1] and\
           c == a[i][j - 2]:
          print "T: {0}".format(
            mark([[i - 1, j - 1], [i - 1, j], [i - 1, j + 1], [i, j], [i + 1, j]], [i + 3, j]))

        #-X
        #-X
        #X-X
        #-x
        if j - 1 >= 0 and j + 1 < cols and i + 3 < rows and c == a[i + 2][j - 1] and c == a[i + 2][j + 1] and\
           c == a[i + 3][j]:
          print "Upsidedown T: {0}".format(
            mark([[i, j], [i + 1, j], [i + 2, j - 1], [i + 2, j], [i + 2, j + 1]], [i + 3, j]))

      #---------------------------------------------------------------------------------------------
      #2 consecutive horizontal candies found
      if j + 1 < cols and c == a[i][j + 1] and c in ['R']:
        #3 in a row ------------------------------------------------------------------------------------------
        # XX-x
        if j + 3 < cols and c == a[i][j + 3]:
          print "3 horizontal in a row on right: {0}".format(mark([[i, j], [i, j + 1], [i, j + 2]], [i, j + 3]))

        # XX-
        # --x
        if i + 1 < rows and j + 2 < cols and c == a[i + 1][j + 2]:
          print "3 horizontal in a row on right below: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2]], [i + 1, j + 2]))

        # --x
        # XX-
        if i - 1 >= 0 and j + 2 < cols and c == a[i - 1][j + 2]:
          print "3 horizontal in a row on right above: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i + 1, j + 2]], [i - 1, j + 2]))

        # x-XX
        if j - 2 >= 0 and c == a[i][j - 2]:
          print "3 horizontal in a row on left: {0}".format(mark([[i, j - 1], [i, j], [i, j + 1], ], [i, j - 2]))

        # -XX
        # x--
        if i + 1 < rows and j - 2 >= 0 and c == a[i][j - 2]:
          print "3 horizontal in a row on left below: {0}".format(
            mark([[i, j - 1], [i, j], [i, j + 1]], [i + 1, j - 1]))

        # x--
        # -XX
        if i - 1 >= 0 and j - 2 >= 0 and c == a[i][j - 2]:
          print "3 horizontal in a row on left above: {0}".format(
            mark([[i, j - 1], [i, j], [i, j + 1]], [i - 1, j - 1]))

        # 4 in a row ----------------------------------------------------------------------------------------
        # --x-
        # XX-X
        if i - 1 >= 0 and j + 3 < cols and c == a[i][j + 3] and c == a[i - 1][j + 2]:
          print "4 horizontal in a row on right above: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i, j + 3]], [i - 1, j + 2]))

        # XX-X
        # --x-
        if i + 1 < rows and j + 3 < cols and c == a[i][j + 3] and c == a[i + 1][j + 2]:
          print "4 horizontal in a row on right below: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i, j + 3]], [i + 1, j + 2]))

        # X-XX
        # -x--
        if i + 1 < rows and j - 2 >= 0 and c == a[i][j - 2] and c == a[i + 1][j - 1]:
          print "4 horizontal in a row on left below: {0}".format(
            mark([[i, j - 2], [i, j - 1], [i, j], [i, j + 1]], [i + 1, j - 1]))

        # -x--
        # X-XX
        if i - 1 >= 0 and j - 2 >= 0 and c == a[i][j - 2] and c == a[i - 1][j - 1]:
          print "4 horizontal in a row on left above: {0}".format(
            mark([[i, j - 2], [i, j - 1], [i, j], [i, j + 1]], [i - 1, j - 1]))

        # 5 in a row ----------------------------------------------------------------------------------------
        # XX-XX
        # --x--
        if i + 1 < rows and j + 4 < cols and c == a[i][j + 3]\
           and c == a[i][j + 4] and c == a[i + 1][j + 2]:
          print "5 horizontal in a row a middle candy below: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i, j + 3], [i, j + 4]], [i + 1, j + 2]))

        # --x--
        # XX-XX
        if i - 1 >= 0 and j + 4 < cols and c == a[i][j + 3]\
           and c == a[i][j + 4] and c == a[i - 1][j + 2]:
          print "5 horizontal in a row a middle candy above: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i, j + 3], [i, j + 4]], [i - 1, j + 2]))

        # L shaped, all combinations --------------------------------------------------------------------------
        # X
        # X
        # -XX
        # x
        if i - 2 >= 0  and j - 1 >= 0 and i + 1 < rows and c == a[i - 2][j - 1] and c == a[i - 1][j - 1]\
        and c == a[i + 1][j - 1]:
          print "L in a row below: {0}".format(
            mark([[i - 2, j - 1], [i - 1, j - 1], [i, j - 1], [i, j], [i, j + 1]], [i + 1, j - 1]))

        #  X
        #  X
        # x-XX
        if i - 2 >= 0 and j - 2 >= 0 and c == a[i - 2][j - 1] and c == a[i - 1][j - 1] and c == a[i][j - 2]:
          print "L in a same row left: {0}".format(
            mark([[i - 2, j - 1], [i - 1, j - 1], [i, j - 1], [i, j], [i, j + 1]], [i, j - 2]))

        #   X
        #   X
        # XX-x
        if i - 2 >= 0 and j + 2 < cols and c == a[i - 1][j + 2] and c == a[i - 2][j + 2] and c == a[i][j + 3]:
          print "Reversed L in a same row right: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i - 1, j + 2], [i - 2, j + 2]], [i, j + 3]))

        #   X
        #   X
        # XX-
        #   x
        if i - 2 >= 0 and j + 2 < cols and c == a[i - 1][j + 2] and c == a[i - 2][j + 2] and c == a[i + 1][j + 2]:
          print "Reversed L in a row below: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i - 1, j + 2], [i - 2, j + 2]], [i + 1, j + 2]))

        # x
        # -XX
        # X
        # X
        if i + 2 < rows and j - 1 >= 0 and c == a[i + 1][j - 1] and c == a[i + 2][j - 1] and c == a[i - 1][j - 1]:
          print "Upside-down L in a row below: {0}".format(
            mark([[i + 2, j - 1], [i + 1, j - 1], [i, j - 1], [i, j], [i, j + 1]], [i - 1, j - 1]))

        # x-XX
        # -X
        # -X
        if i + 2 < rows and j - 2 >= 0 and c == a[i + 1][j - 1] and c == a[i + 2][j - 1] and c == a[i][j - 2]:
          print "Upside-down L in a same row left: {0}".format(
            mark([[i + 2, j - 1], [i + 1, j - 1], [i, j - 1], [i, j], [i, j + 1]], [i, j - 2]))

        #   x
        # XX-
        #   X
        #   X
        if i - 1 >= 0 and i + 2 < rows and j + 2 < cols and c == a[i + 1][j + 2] and c == a[i + 2][j + 2] and\
           c == a[i - 1][j + 2]:
          print "Upside-down reversed L in a row above: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i + 1, j + 2], [i + 2, j + 2]], [i - 1, j + 2]))

        # XX-x
        #   X
        #   X
        if i + 2 < rows and j + 2 < cols and c == a[i + 1][j + 2] and c == a[i + 2][j + 2] and\
           c == a[i][j + 3]:
          print "Upside-down reversed L in a same row right: {0}".format(
            mark([[i, j], [i, j + 1], [i, j + 2], [i + 1, j + 2], [i + 2, j + 2]], [i, j + 3]))

        #T with two consecutive horizontal candies  ---------------------------------------------------------
        #--X
        #XX-x
        #--X
        if i - 1 >= 0 and i + 1 < rows and j + 3 < cols and c == a[i - 1][j + 2] and c == a[i + 1][j + 2] and\
           c == a[i][j + 3]:
          print "Right T: {0}".format(
            mark([[i, j], [i, j + 1], [i - 1, j + 2], [i, j + 2], [i + 1, j + 2]], [i, j + 3]))

        #-X
        #x-XX
        #-X
        if i - 1 >= 0 and i + 1 < rows and j - 2 >= 0 and  c == a[i - 1][j - 1] and c == a[i + 1][j - 1] and\
           c == a[i][j - 2]:
          print "Left T: {0}".format(
            mark([[i - 1, j - 1], [i, j - 1], [i + 1, j - 1], [i, j], [i, j + 1]], [i, j + 3]))


matches()

