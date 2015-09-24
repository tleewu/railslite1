require 'json'
require 'webrick'
require 'byebug'

module Phase9
  class Flash
    def initialize(req, persists = true)

      cookie = req.cookies.find {|cookie| cookie.name == '_flash_cookie'}
      if cookie
        @value = JSON.parse(cookie.value)
      else
        @value = {}
      end

      @now = {}
    end

    def [](key)
      # Just flash, NOT flash.now
      result = []
      result << @value[key] if @value[key]
      result << @now[key] if @now[key]
      result
    end

    def []=(key,value)
      # Just flash, NOT flash.now
      @value[key] = value
    end

    def now
      @now
    end

    # def now=(key,value)
    #   @now[key] = value
    # end

    def store_flash(res)
      new_cookie = WEBrick::Cookie.new('_flash_cookie', @value.to_json)
      new_cookie.path = "/"

      res.cookies << new_cookie
    end

  end
end
