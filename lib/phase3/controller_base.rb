require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      content = ERB.new(File.read("views/#{controller_name}/#{template_name}.html.erb")).result(binding)
      # This evaluates all of the controller's variables (within scope) and
      # substitutes them into the HTML.
      render_content(content, "text/html")
    end

    def controller_name
      self.class.to_s.underscore
    end
  end
end
