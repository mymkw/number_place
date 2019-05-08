@board = Array.new(9).map do |i|
  i = Array.new(9).map do |j|
    j = 0
  end
end
@opt = Array.new(9).map do |i|
  i = Array.new(9).map do |j|
    j = Array.new([1,2,3,4,5,6,7,8,9])
  end
end

# @board = [
#   [],
#   [],
#   [],
#   [],
#   [],
#   [],
#   [],
#   [],
#   []
# ]

# @board = [              #スパコンで作成された問題 少し時間がかかる
#   [0,6,1,0,0,7,0,0,3],
#   [0,9,2,0,0,3,0,0,0],
#   [0,0,0,0,0,0,0,0,0],
#   [0,0,8,5,3,0,0,0,0],
#   [0,0,0,0,0,0,5,0,4],
#   [5,0,0,0,0,8,0,0,0],
#   [0,4,0,0,0,0,0,0,1],
#   [0,0,0,1,6,0,8,0,0],
#   [6,0,0,0,0,0,0,0,0]
# ]

@test = [              #世界一難しい問題
  [8,0,0,0,0,0,0,0,0],
  [0,0,3,6,0,0,0,0,0],
  [0,7,0,0,9,0,2,0,0],
  [0,5,0,0,0,7,0,0,0],
  [0,0,0,0,4,5,7,0,0],
  [0,0,0,1,0,0,0,3,0],
  [0,0,1,0,0,0,0,6,8],
  [0,0,8,5,0,0,0,1,0],
  [0,9,0,0,0,0,4,0,0],
]

def output
  print("   a b c d e f g h i\n")
  print("   - - - - - - - - -\n")
  9.times do |i|
    print("#{i+1}|")
    9.times do |j|
      print(" ")
      if @board[i][j] == 0
        print(".")
      else
        print(@board[i][j])
      end
    end
    print("\n")
  end
end

def answer(x,y,num)
  x += 9 if x < 0
  chars = "abcdefghi"
  y += 9 if y < 0
  puts("FILL #{num} AT #{chars[x]}#{y+1}")
  @board[y][x] = num
  omitopt(x,y,num)
end

def omitopt(x,y,num)
  # x += 9 if x < 0
  # y += 9 if y < 0
  @opt[y][x] = []

  1.upto(9) do |i| #y軸に対しての操作
    @opt[y-i][x].delete(num)
  end

  1.upto(9) do |i| #x軸に対しての操作
    @opt[y][x-i].delete(num)
  end
  
  if x < 3
    sx = 0
  elsif x < 6
    sx = 3
  else
    sx = 6
  end
  if y < 3
    sy = 0
  elsif y < 6
    sy = 3
  else
    sy = 6
  end

  sy.upto(sy+2) do |i|
    sx.upto(sx+2) do |j|
      next if i == y && j == x
      @opt[i][j].delete(num)
    end
  end

  9.times do |i|
    9.times do |j|
      answer(j,i,@opt[i][j][0]) if @opt[i][j].length == 1
    end
  end
  
end

def deleteFirstSel #直近の候補一つを削除する
  dataLoad  #直近の状態(answerする前)に戻っている。
  dataDelete
  9.times do |i|
    9.times do |j|
      if @opt[i][j].length > 1
        @opt[i][j].delete(@opt[i][j][0])
        @break = true
        return
      
      elsif @opt[i][j].length == 1
        deleteFirstSel #直近の候補が1つの場合はもうひとつ前。
      end
      return if @break
    end
  end
end

def contradiction
  i = 0
  j = 0
  while i < 9 do
    while j < 9 do
      if @opt[i][j].length == 0 && @board[i][j] == 0
        @break = false
        deleteFirstSel
        i = 0
        j = 0
        redo
        
      elsif @opt[i][j].length >= 1
        dataSave
        answer(j,i,@opt[i][j][0])
      end
      j = j + 1
    end
    j = 0
    i = i + 1

  end #9.times

end #def

def dataSave
  ary = [
    Marshal.load(Marshal.dump(@board)),
    Marshal.load(Marshal.dump(@opt))
  ]
  @data.push(ary)
  puts("DATA SAVE")
end
def dataDelete
  @data.delete(@data.last) if @data.length > 0
  puts("DATA DELETE")
  return
end
def dataLoad
  @board = Marshal.load(Marshal.dump(@data.last[0]))
  @opt = Marshal.load(Marshal.dump(@data.last[1]))
  puts("DATA LOAD")
end

def quick
  9.times do |i|
    l = gets
    9.times do |j|
      @board[i][j] = l[j].to_i
    end
    output
  end
end

#main

@data = Array.new
dataSave
output
loop do
  print("\n")
  l =gets.split(" ")
  break if l[0] == "exit"
  if l[0] == "undo"
    dataDelete
    dataLoad
  elsif l[0] == "test"
    @board = Marshal.load(Marshal.dump(@test))
    dataSave
    output
  elsif l[0] == "quick"
    quick
  else
    num = l[1].to_i
    x = /#{l[0][0]}/ =~ "abcdefghi"
    y = l[0][1].to_i - 1
    @board[y][x] = num
    puts("FILL #{num} AT #{l[0]}")
    dataSave
  end
end

9.times do |i|
  9.times do |j|
    if @board[i][j] != 0
      answer(j,i,@board[i][j])
    end
  end
end
dataSave
contradiction #背理法
print "\n"
output
print "\n"