# Backtracking sudoku solver, to be compared against algorithm x

problem1 = [[0, 6, 0, 3, 0, 0, 8, 0, 4], 
            [5, 3, 7, 0, 9, 0, 0, 0, 0], 
            [0, 4, 0, 0, 0, 6, 3, 0, 7], 
            [0, 9, 0, 0, 5, 1, 2, 3, 8], 
            [0, 0, 0, 0, 0, 0, 0, 0, 0], 
            [7, 1, 3, 6, 2, 0, 0, 4, 0], 
            [3, 0, 6, 4, 0, 0, 0, 1, 0], 
            [0, 0, 0, 0, 6, 0, 5, 2, 3], 
            [1, 0, 2, 0, 0, 9, 0, 8, 0]]

problem2 = [[0, 0, 0, 0, 0, 0, 0, 1, 2], 
            [0, 0, 0, 0, 0, 0, 0, 0, 3], 
            [0, 0, 2, 3, 0, 0, 4, 0, 0], 
            [0, 0, 1, 8, 0, 0, 0, 0, 5], 
            [0, 6, 0, 0, 7, 0, 8, 0, 0], 
            [0, 0, 0, 0, 0, 9, 0, 0, 0], 
            [0, 0, 8, 5, 0, 0, 0, 0, 0], 
            [9, 0, 0, 0, 4, 0, 5, 0, 0], 
            [4, 7, 0, 0, 0, 6, 0, 0, 0]]

def solve(grid):
  if not is_empty(grid):
    return True
  (row, col) = get_pos(grid)
  for n in range(10):
    if is_valid(grid, row, col, n):
      grid[row][col] = n

      if solve(grid[:]) == True:
        return True

      grid[row][col] = 0
  return False

def is_empty(grid):
  for rows in grid:
    if 0 in rows:
      return True
  return False

def get_pos(grid):
  for i, rows in enumerate(grid):
    for j, column in enumerate(rows):
      if column == 0:
        return (i, j)
  return (-1, -1)

def is_row_valid(grid, row, num):
  return num not in grid[row]

def is_column_valid(grid, col, num):
  for rows in grid:
    if rows[col] == num:
      return False
  return True

def is_grid_valid(grid, row, col, num):
  r = row - row % 3
  c = col - col % 3
  for rows in grid[r:r+3]:
    if num in rows[c:c+3]:
      return False 
  return True

def is_valid(grid, row, col, num):
  return is_row_valid(grid, row, num) and is_column_valid(grid, col, num) and is_grid_valid(grid, row, col, num)

def print_grid(grid):
  for rows in grid:
    for column in rows:
      print(column if column > 0 else ".", "", end="", flush=True)
    print()

print('preparing solution 1')
if solve(problem1) == True:
  print_grid(problem1)
else:
  print('no solution')

print('preparing solution 2')
if solve(problem2) == True:
  print_grid(problem2)
else:
  print('no solution')

