require_relative '../phase6/controller_base'
require_relative './flash'

module Phase9
  class ControllerBase < Phase6::ControllerBase

    def flash
      @flash ||= Flash.new(@req)
    end

    def redirect_to(url)
      flash.store_flash(@res)
      super(url)
    end

    def render_content(content, content_type)
      flash.store_flash(@res)
      super(content, content_type)
    end

  end
end
