# Copyright (c) 2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'glimmer/jfx/packages'
require 'glimmer/jfx/control_proxy'

module Glimmer
  module JFX
    # WindowProxy is a Proxy for JavaFX Stage/Scene objects, abstracing their details away.
    #
    # Follows the Proxy Design Pattern
    class WindowProxy < ControlProxy
      include Packages
      
      DEFAULT_WIDTH = 190
      DEFAULT_HEIGHT = 150
      
      attr_accessor :jfx, :scene
      attr_reader :parent_proxy, :application, :args, :keyword, :block
      alias stage jfx
      alias stage= jfx=
      
      def post_add_content
        super
        stage.width = DEFAULT_WIDTH if stage.width == 0 || stage.width.nan?
        stage.height = DEFAULT_HEIGHT if stage.height == 0 || stage.height.nan?
        stage.show
      end
      
      # Subclasses may override to perform post initialization work on an added child (normally must also call super)
      def post_initialize_child(child)
        self.scene = Scene.new(child.jfx)
        stage.set_scene(scene)
      end
      
      def respond_to?(method_name, *args, &block)
        respond_to_scene?(method_name, *args, &block) ||
          super(method_name, true)
      end
      
      def respond_to_scene?(method_name, *args, &block)
        @scene.respond_to?(method_name, true) || @scene.respond_to?("set_#{method_name}", true)
      end
      
      def send_to_scene(method_name, *args, &block)
        @scene.send(method_name, *normalize_args(args), &block)
      end
      
      def method_missing(method_name, *args, &block)
        if respond_to?("#{method_name}=", true) && !args.empty?
          send("#{method_name}=", *args)
        elsif @scene.respond_to?("set_#{method_name}", true) && !args.empty?
          send_to_scene("set_#{method_name}", *args, &block)
        elsif @scene.respond_to?(method_name, true)
          send_to_scene(method_name, *args, &block)
        else
          super
        end
      end
      
      def content(&block)
        Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::JFX::WindowExpression.new, @keyword, &block)
      end
      
      private
      
      def build
        self.stage = javafx.stage.Stage.new
      end
      
      def normalize_args(args)
        args.map do |arg|
          arg.is_a?(ControlProxy) ? arg.jfx : arg
        end
      end
    end
  end
end
