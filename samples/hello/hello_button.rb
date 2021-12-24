require 'glimmer-dsl-jfx'

include Glimmer

window {
  title 'Hello, Button!'
  
  @button = button('Click To Increment: 0') {
    on_action do
      button_text_match = @button.text.match(/([^0-9]+)(\d+)$/)
      count = button_text_match[2].to_i + 1
      @button.text = "#{button_text_match[1]}#{count}"
    end
  }
}
