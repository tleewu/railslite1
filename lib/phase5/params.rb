require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params
      parse_www_encoded_form(req.query_string)if req.query_string
      parse_www_encoded_form(req.body) if req.body

    end

    def [](key)
      JSON.parse(@params.to_json)[key.to_s]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      www_encoded_form = URI.decode_www_form(www_encoded_form)

      www_encoded_form.each do |hash_comb|

        if hash_comb.join("").split("").include?("[")
          hash_comb = parse_key(hash_comb.join(""))
        end

        current_params = @params
        hash_comb.each_with_index do |key,idx|
          if idx == hash_comb.length - 2
            current_params[key] = hash_comb[-1]
            break
          else
            if current_params[key]
              current_params = current_params[key]
            else
              current_params[key] = {}
              current_params = current_params[key]
            end
          end
        end
      end
    end

    def parse_key(key)
      key.to_s.split(/\]\[|\[|\]/)
    end
  end
end
