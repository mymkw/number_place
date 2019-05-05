@board = Array.new(4).map do |i|
  i = Array.new(4)
end
@opt = Array.new(4).map do |i|
  i = Array.new(4).map do |j|
    j = Array.new([1,2,3,4])
  end
end
4.times do |i|
  4.times do |j|
    @board[i][j] = 0
  end
end

def output
  print("   a b c d\n")
  print("   - - - -\n")
  4.times do |i|
    print("#{i+1}|")
    4.times do |j|
      print(" ")
      print(@board[i][j])
    end
    print("\n")
  end
end

def outputomit(x,y,num)
  x += 4 if x < 0
  y += 4 if y < 0
  puts("delete #{num} at x= #{x} y= #{y}")
  4.times do |i|
    p @opt[i]
  end
  print("\n")
end

def answer(x,y,num)
  @board[y][x] = num
  omitopt(x,y,num)
end
def omitopt(x,y,num)
  x += 4 if x < 0
  y += 4 if y < 0
  @opt[y][x] = []
  outputomit(x,y,num)
  1.upto(3) do |i|
    outputomit(x,y-i,num) if @opt[y-i][x].delete(num)
    answer(x,y-i,@opt[y-i][x][0]) if @opt[y-i][x].length == 1
  end
  1.upto(3) do |i|
    outputomit(x-i,y,num) if @opt[y][x-i].delete(num)
    answer(x-i,y,@opt[y][x-i][0]) if @opt[y][x-i].length == 1
  end
  
  if x < 2
    sx = 0
  else
    sx = 2
  end
  if y < 2
    sy = 0
  else
    sy = 2
  end

  sy.upto(sy+1) do |i|
    sx.upto(sx+1) do |j|
      next if i == y && j == x
      outputomit(j,i,num) if @opt[i][j].delete(num)
      answer(j,i,@opt[i][j][0]) if @opt[i][j].length == 1
    end
  end
  
end



#main

output
loop do
  l = gets.split(" ")
  break if l[0] == "exit"
  if l[1] == "nil"
      num = nil
  else
      num = l[1].to_i
  end
  x = /#{l[0][0]}/ =~ "abcdefghi"
  y = l[0][1].to_i - 1
  answer(x,y,num)
  output
end