require 'glimmer-dsl-libui'

include Glimmer
include Math

window('図形描画', 800, 600) {
  margined true
  
  vertical_box {
    area {
      path {
        arc(200, 300, 150, 90, 180, true)
        fill r: 200, g: 200, b: 255, a: 1.0
      }
      path {
        circle(200, 300, 150)
        rectangle(200,100,500,400)
        stroke r: 0, g: 0, b: 0
      }
      path {
        polygon(500,300-150, 500-150*cos(PI/6),300+150*sin(PI/6), 500+150*cos(PI/6), 300+150*sin(PI/6))
        fill r: 255, g: 200, b: 200, a: 1.0
      }
      path {
        polygon(500,300-150, 500-150*cos(PI/6),300+150*sin(PI/6), 500+150*cos(PI/6), 300+150*sin(PI/6))
        stroke r: 0, g: 0, b: 0
      }
    }
  }
}.show

