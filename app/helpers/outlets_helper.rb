require 'soap/wsdlDriver'
module OutletsHelper
  class WebService
    def initialize
      wsdl_url = "http://localhost:9999/ws/raspberry?wsdl"
      @publicWS = SOAP::WSDLDriverFactory.new(wsdl_url).create_rpc_driver
      wsdl_url_admin = "http://localhost:9991/ws/admin?wsdl"
      @adminWS = SOAP::WSDLDriverFactory.new(wsdl_url_admin).create_rpc_driver
    end

    @@instance = WebService.new

    def self.instance
      return @@instance
    end

    def getlistoutlets
      ret = @publicWS.getListOutlet[0];
      outlets = Array.new
      if(ret != "") then
        if ret.item.kind_of?(Array) then
          ret.item.each{|item|
            outlets.push(getOutlet(item))
          }
        else
          outlets.push(getOutlet(ret.item))
        end
      end
      return outlets
    end

    def getOutlet(item)
      return Outlet.new(uuid:item.id, room:item.room, state:item.state, name:item.name)
    end

    def switchonoff(uuid, state)
      if state then
        @publicWS.switch_on(uuid)
      else
        @publicWS.switch_off(uuid)
      end
    end

    def addoutlet(o)
      id = @adminWS.add_outlet(o.room, o.name)
      o.uuid = id
    end

    def removeoutlet(uuid)
      @adminWS.remove_outlet(uuid)
    end

    def getoutlet(id)
      ret = @adminWS.get_outlet(id)[0]
      if(ret != "")
        return getOutlet(ret)
      else
        return nil
      end
    end

    def updateoutlet(o)
      @adminWS.update_outlet(o.uuid, o.name, o.room, o.state)
    end

    private_class_method :new
  end
end
