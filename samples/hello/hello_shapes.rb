require 'glimmer-dsl-jfx'

include Glimmer

window {
  title 'Hello, Shapes!'
  width 400
  height 400
  
  pane {
    arc(85, 85, 45, 45, 30, 230) {
      type ArcType::OPEN
      fill Paint.value_of('#ff0000')
      stroke Paint.value_of('#0080ff')
      stroke_width 3
    }

    arc(85, 185, 45, 45, 30, 230) {
      type ArcType::CHORD
      fill Paint.value_of('#ff0000')
      stroke Paint.value_of('#0080ff')
      stroke_width 3
    }

    arc(85, 285, 45, 45, 30, 230) {
      type ArcType::ROUND
      fill Paint.value_of('#ff0000')
      stroke Paint.value_of('#0080ff')
      stroke_width 3
    }

    rectangle(140, 40, 180, 90) {
      fill Paint.value_of('#ffff00')
      stroke Paint.value_of('#ff0000')
      stroke_width 3
    }

    rectangle(140, 140, 180, 90) {
      arc_width 60
      arc_height 40
      fill Paint.value_of('#ffff00')
      stroke Paint.value_of('#ff0000')
      stroke_width 3
    }

    ellipse(230, 285, 90, 45) {
      fill Paint.value_of('#ffff00')
      stroke Paint.value_of('#ff0000')
      stroke_width 3
    }

    line(180, 60, 280, 110) {
      stroke Paint.value_of('#ff0000')
      stroke_width 3
    }

    quad_curve(170, 60, 180, 90, 220, 100) {
      fill Paint.value_of('#ffff00')
      stroke Paint.value_of('#00ff00')
      stroke_width 3
    }

    cubic_curve(190, 60, 240, 40, 220, 80, 260, 70) {
      fill Paint.value_of('#ffff00')
      stroke Paint.value_of('#0000ff')
      stroke_width 3
    }
  }
}
