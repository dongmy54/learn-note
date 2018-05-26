def event(desc,&block)
  puts "----------#{desc}" if block.call
end

load 'events.rb'
# => ----------Orders are too small
#    ----------Too many refunds