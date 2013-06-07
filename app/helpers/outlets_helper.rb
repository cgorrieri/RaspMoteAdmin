require 'soap/wsdlDriver'
module OutletsHelper
  class WebService
    def initialize
      wsdl_url = "http://localhost:9999/ws/raspberry?wsdl"
      @service = SOAP::WSDLDriverFactory.new(wsdl_url).create_rpc_driver
    end

    @@instance = WebService.new

    def self.instance
      return @@instance
    end

    def getlistoutlets
      items = @service.getListOutlet[0].item;
      outlets = Array.new
      items.each{|item|
        o = Outlet.where(uuid:item.id).first
        if o then
          o.update_attributes(room:item.room, state:item.state, name:item.name)
        else
          o = Outlet.new(uuid:item.id, room:item.room, state:item.state, name:item.name)
          o.save
        end
        Rails.logger.debug o
        outlets.push(o)
      }
      return outlets
    end

    def switchonoff(uuid, state)
      if state then
        @service.switch_on(uuid)
      else
        @service.switch_off(uuid)
      end
    end

    private_class_method :new
  end
end
