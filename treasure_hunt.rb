########### Angkan Baidya ###########
###########abaidya ###########
########### 112309655 ###########

class ValueError < RuntimeError
end

class Cave
  def initialize()
    @edges = [[1, 2], [2, 10], [10, 11], [11, 8], [8, 1], [1, 5], [2, 3], [9, 10], [20, 11], [7, 8], [5, 4],
                      [4, 3], [3, 12], [12, 9], [9, 19], [19, 20], [20, 17], [17, 7], [7, 6], [6, 5], [4, 14], [12, 13],
                      [18, 19], [16, 17], [15, 6], [14, 13], [13, 18], [18, 16], [16, 15], [15, 14]]
    @rooms = {}
    for i in 1..21
      @rooms[i] = Room.new(i)
    end
    @edges.each do |edge|
      @rooms[edge[0]].connect(@rooms[edge[1]])
    end
  end


  def add_hazard(thing, count)
    while count > 0
      randomroom = (rand(1..20))
      if @rooms[randomroom].has?(thing) == true
        redo
      end
      @rooms[randomroom].add(thing)
      count -= 1
    end
    end


  def random_room
    return @rooms[(rand(1..20))]
  end

  def move(thing, frm, to)
    if frm.has?(thing)
      to.add(thing)
      frm.remove(thing)
    else
      raise ValueError
  end
  end

  def room_with(thing)
    @rooms.each do |key,val|
      if val.has?(thing)
        return val
      end
    end
    return nil
  end

  def entrance
    @rooms.each do |key,val|
      if val.safe? == true
        return val
      end
      end
  end

  def room(number)
    if @rooms[number] == nil
      raise KeyError
    end
    return @rooms[number]
end
  end
class Player
  def initialize
    @senses = {}
    @encounters = {}
    @actions = {}
    @room = nil
  end

  def room
    return @room
  end
  def sense(thing, &callback)
    @senses[thing] = callback
  end

  def encounter(thing, &callback)
    @encounters[thing] = callback
  end



  def action(thing, &callback)
    @actions[thing] = callback
  end

  def enter(room)
    @room = room
    if @room.empty? == false
      if @room.hazards.size == 1
            return @encounters[@room.hazards[0]].call(self)
      end
      return @encounters.values[0].call(self)
    end

    end


  def explore_room
    @room.neighbors.each do |x|
      x.hazards.each do |y|
        @senses[y].call(self)
      end

    end
  end

  def act(action, destination)
    if @actions[action] == nil
      raise KeyError
    end
    @actions[action][destination]

  end
  end
class Room
  def initialize(number)
    @number = number
    @hazards = []
    @neighbors = []
  end

  def hazards
    return @hazards
  end

  def neighbors
    return @neighbors
  end

  def number
    return @number
  end



  def add(thing)
    @hazards.push(thing)
  end

  def remove(thing)
    boolean = false
    count = 0
    @hazards.each do  |x|
      count = count + 1
      if x == thing
        @hazards.delete_at(count-1)
        boolean = true
      end
      if boolean == false
        raise ValueError
      end


  end
  end

  def has?(thing)
    @hazards.each do |x|
      if x == thing
        return true
      end
  end
    return false
  end

  def empty?
    if @hazards.size == 0
      return true
    end
    return false
  end

  def safe?
    if @hazards.empty? == false
      return false
    end
    @neighbors.each do |x|
      if x.empty? == false
        return false
      end
    end
    return true
  end

  def connect(other_room)
    @neighbors.push(other_room)
    @neighbors[-1].neighbors.push(self)
  end

  def exits
    if @neighbors.size == 0
      return Array.new
    end
    @returnable = Array.new
    @neighbors.each do |x|
      @returnable.push(x.number)
    end
    return @returnable
  end

  def neighbor(number)
    if @neighbors.size == 0
      return nil
    end
    @neighbors.each do |x|
      if x.number == number
        return x
      end
    end
    return nil
  end

  def random_neighbor
    if @neighbors.size == 0
      raise IndexError
    end
    return @neighbors.sample
  end
end

class Console
  def initialize(player, narrator)
    @player   = player
    @narrator = narrator
  end

  def show_room_description
    @narrator.say "-----------------------------------------"
    @narrator.say "You are in room #{@player.room.number}."

    @player.explore_room

    @narrator.say "Exits go to: #{@player.room.exits.join(', ')}"
  end

  def ask_player_to_act
    actions = {"m" => :move, "s" => :shoot, "i" => :inspect }

    accepting_player_input do |command, room_number|
      @player.act(actions[command], @player.room.neighbor(room_number))
    end
  end

  private

  def accepting_player_input
    @narrator.say "-----------------------------------------"
    command = @narrator.ask("What do you want to do? (m)ove or (s)hoot?")

    unless ["m","s"].include?(command)
      @narrator.say "INVALID ACTION! TRY AGAIN!"
      return
    end

    dest = @narrator.ask("Where?").to_i

    unless @player.room.exits.include?(dest)
      @narrator.say "THERE IS NO PATH TO THAT ROOM! TRY AGAIN!"
      return
    end

    yield(command, dest)
  end
end

class Narrator
  def say(message)
    $stdout.puts message
  end

  def ask(question)
    print "#{question} "
    $stdin.gets.chomp
  end

  def tell_story
    yield until finished?

    say "-----------------------------------------"
    describe_ending
  end

  def finish_story(message)
    @ending_message = message
  end

  def finished?
    !!@ending_message
  end

  def describe_ending
    say @ending_message
  end
end


