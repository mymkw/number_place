@board = Array.new(9).map do |i|
  i = Array.new(9)
end
@opt = Array.new(9).map do |i|
  i = Array.new(9).map do |j|
    j = Array.new([1,2,3,4,5,6,7,8,9])
  end
end
9.times do |i|
  9.times do |j|
    @board[i][j] = 0
  end
end

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

def outputomit(x,y,num)
  x += 9 if x < 0
  y += 9 if y < 0
  puts("delete #{num} at x= #{x} y= #{y}")
  # 9.times do |i|
  #   p @opt[i]
  # end
  # print("\n")
end

def answer(x,y,num)
  puts("answer #{num} at x= #{x} y= #{y}")
  @board[y][x] = num
  omitopt(x,y,num)
  return if @jug
end

def omitopt(x,y,num)
  x += 9 if x < 0
  y += 9 if y < 0
  @opt[y][x] = []
  outputomit(x,y,num)
  1.upto(9) do |i|
    outputomit(x,y-i,num) if @opt[y-i][x].delete(num)
      
    #   if @cont && @opt[y-i][x].length == 0
    #     @jug = true
    #     return
    #   end
    # end

    answer(x,y-i,@opt[y-i][x][0]) if @opt[y-i][x].length == 1
  end
  1.upto(9) do |i|
    outputomit(x,y-i,num) if @opt[y][x-i].delete(num)
      
    #   if @cont && @opt[y][x-i].length == 0
    #     @jug = true
    #     return
    #   end
    # end
    answer(x-i,y,@opt[y][x-i][0]) if @opt[y][x-i].length == 1
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
      outputomit(j,i,num) if @opt[i][j].delete(num)
      answer(j,i,@opt[i][j][0]) if @opt[i][j].length == 1
    end
  end
  
end

# def contradiction
  
#   dataSave
#   9.times do |i|
#     9.times do |j|
#       if @board[i][j].length > 0
#         if @jug
          
#         end
#         answer(j,i,@board[i][j].first)
#       end
#     end
#   end
# end

# def dataSave #背理法
#   ary = [
#     Marshal.load(Marshal.dump(@board)),
#     Marshal.load(Marshal.dump(@opt))
#   ]
#   @data.push(ary)
# end
# def detaDelete
#   @data.pop
#   @board = @data.last[0]
#   @opt = @data.last[1]
# end

#main
# @cont = false
output
loop do
  print("\n")
  l = gets.split(" ")
  print("\n")
  break if l[0] == "exit"
  if l[1] == "nil"
      num = nil
  else
      num = l[1].to_i
  end
  x = /#{l[0][0]}/ =~ "abcdefghi"
  y = l[0][1].to_i - 1
  answer(x,y,num)
  print("\n")
  output
end
# @cont = true
# @data = Array.new
# contradiction #背理法