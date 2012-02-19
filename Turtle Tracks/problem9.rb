# files
INPUT_FILE = 'complex.logo'
OUTPUT_FILE = 'output.txt'

# commands
FD = 'FD'
RT = 'RT'
LT = 'LT'
BK = 'BK'
REPEAT = 'REPEAT'

# rotation array
ROT = [[-1,-1],[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1]]

# rotates turtle
def rotate ori, angle
  rots = (angle / 45) * -1
  index = ROT.index([ori[:v], ori[:h]]) + rots
  index += ROT.length if ! ROT[index] and index < 0
  index -= ROT.length if ! ROT[index] and index > 0
  rot = ROT[index]
  ori[:v] = rot[0]
  ori[:h] = rot[1]
end

# moves turtle
def move board, ori, pos, dist
  dir = dist < 0 ? -1 : 1
  dist = dist.abs
  while dist > 0 do
    pos[:v] += (dir * ori[:v])
	pos[:h] += (dir * ori[:h])
	board[pos[:v]][pos[:h]] = 'X'
	dist -= 1
  end
end

# moves turtle according to the commands
def command op, val, board, ori, pos
  case op
  when FD
    move board, ori, pos, val.to_i
  when BK
    move board, ori, pos, val.to_i * -1
  when RT
    rotate ori, val.to_i * -1
  when LT
    rotate ori, val.to_i
  end
end 

# read input file
size = commands = nil
File.open INPUT_FILE, 'rb' do |file|
  size = file.readline.to_i
  file.readline
  commands = file.read
end

# build board
board = Array.new size
for i in 0...size do
  board[i] = Array.new(size, '.')
end
ori = { :v => -1, :h => 0 }
pos = { :v => size / 2, :h => size / 2 }
board[pos[:v]][pos[:h]] = 'X'

# parse commands
commands = commands.split "\n"
commands.each do |comm|
  comm = comm.split ' '
  if comm[0] == REPEAT
    repeats = comm[1].to_i
	comm.shift 3
	comm.pop
	while repeats > 0 do
	  i = 0
	  while i < comm.length do
	    command comm[i], comm[i+1], board, ori, pos
		i += 2
	  end
	  repeats -= 1
	end
  else
    command comm[0], comm[1], board, ori, pos
  end
end

# output answer
File.open OUTPUT_FILE, 'w' do |file|
  board.each do |line|
    i = 1
	file.print line[0]
	while i < line.length do
      file.print ' ', line[i]
	  i += 1
    end
	file.puts ''
  end
end
