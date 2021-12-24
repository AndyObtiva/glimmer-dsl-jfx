require 'glimmer-dsl-jfx'

class Counter
  attr_accessor :count

  def initialize
    self.count = 0
  end
end

class HelloButton
  include Glimmer
  
  def initialize
    @counter = Counter.new
  end
  
  def launch
    window {
      title 'Hello, Button!'
      
      @button = button('Click To Increment: 0') {
        on_action do
          @counter.count += 1
          @button.text = "Click To Increment: #{new_count}"
        end
      }
    }
  end
end

HelloButton.new.launch
