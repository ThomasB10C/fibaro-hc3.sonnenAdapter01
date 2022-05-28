-- sbAdpater1 V1.1
-- Adapter für die sonnenBatterie Eco8.0 und SB10
-- QuickApp für das System Fibaro HC3
-- Der Adapter fragt ausgewählte Daten der Batterie zyklisch ab und stellt diese in einer Anzeige, als lokale Variablen und als Globale Variablen zur Verfügung
-- Copyright (C) 2020  Thomas Burchert, 10Consult

-- GNU General Public License
--- Dieses Programm ist freie Software. Sie können es unter den Bedingungen der GNU General Public License, wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, entweder gemäß Version 3 der Lizenz oder (nach Ihrer Wahl) gemäß jeder späteren Version. Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK. Details finden Sie in der GNU General Public License. Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem Programm erhalten haben. Falls nicht, finden Sie ein Exemplar der GNU General Public License zu diesem Programm hier:  <https://www.gnu.org/licenses/>

--- This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program; if not, see <https://www.gnu.org/licenses/>.

-- Parameter, Settings
--- ip: IP-Adresse der Batterie
--- interval: Zeitintervall für die Abfrage der Livedaten
--- wait: yes/no, der Adapter geht bei "yes" in den Wartezustand (Leerlauf)
--- globaleValues: yes/no, der Adapter speichert die Livedaten zusätzlich im Bereich der globalen Variablen ab.

-- Hinweis: die sonnenBatterie und der Fibaro-HC3-Hub müssen im selben Netzwerk angemeldet sein!

-- API-Queries
--- http://<ip-sonnenBatterie>:8080/api/v1/status

-- Lokale Werte: werden in Variablenübersicht der QuickApp gespeichert
-- Globale Werte: werden in der zentralen Variablenübersicht von Fibaro gespeichert; dafür die Globalen Variablen dort manuell hinzufügen und die lokale Variable "globaleValue" auf "yes" stellen!

-- ==============LUA-SCRIPT-CODE=====================================

-- QuickApp: onInit()
-- bei Start der QuickApp, Initialiiserung
function QuickApp:onInit()
	self:debug("sbAdapter1 gestartet (init sbA1)")
    self:updateView("statemessage", "text", "Message: >>> sbAdapter1 gestartet (init sbA1)")	

   -- check values
    if (self:getVariable("ip")) then
    else self:setVariable('ip','change-ip')
    end
    if (self:getVariable("wait")) then
    else self:setVariable('wait','yes')
    end
    if (self:getVariable("interval")) then
    else self:setVariable('interval','60000')
    end
    if (self:getVariable("globalValues")) then
    else self:setVariable('globalValues','no')
    end
    self:readData("sbA1 - Start reading Livedata") -- start readDate()
end

-- QuickApp: readData()
-- Routine für Datenabfrage, Datenaufbereitung, Datenanzeige
-- local address = "http://<ip-adresse>:8080/api/v1/status"
function QuickApp:readData(message)
    self:debug(message)
    self.looptime = tonumber(self:getVariable("interval")) -- string value to number
    self.ip = self:getVariable("ip")
    self.wait = self:getVariable("wait")
    self.go = "yes" 
    self.setGlobalValues = self:getVariable("globalValues")
    
    -- Check the Start-Values "change-ip", "interval", "wait" 
    if  (self.ip == "change-ip") then
        self:trace("sbA1 - please change the ip-address!") -- Value "change-ip"= not correct IP-Address
        self:updateView("statemessage", "text", "Message: >>> sbA1 - please change the ip-address!")	
        self.go = "no"
    end
    if  (self.looptime < 60) then
    self:trace("sbA1, Error - interval to small! Value= ",self.looptime) -- value "interval" zu niedrig!
    self:updateView("statemessage", "text", "Message: >>> sbA1, Error - interval to small!")	
    self.looptime = 60
    self:setVariable("interval",'60') -- value correction
    self.go = "no"
    end
    if  (self.wait == "yes") then
        self:debug("sbA1 is waiting!") -- Value "wait"= yes
        self:updateView("statemessage", "text", "Message: >>> sbA1 is waiting!")
        self.go = "no"
    end
    -- Hauptroutine, main routine
    if (self.go == "yes") then
        self:debug("sbA1 - start data request")
        
        -- looptime berechnen
        self.looptime = self.looptime*1000 -- Zyklus für rd. 120 sec
        
        -- start data request sbAdapter
        self.http = net.HTTPClient({timeout=1000})
        local address = "http://"..self:getVariable("ip")..":8080/api/v1/status"
	    self.http:request(address, {
		    options={headers = {Accept = "application/json"}, method = 'GET'},
		        success = function(response)
                self:debug("sbA1 - data response was successful!")

			    local sbdata = json.decode(response.data)
		
                -- prepare live data for view			
                local strTimestamp = sbdata.Timestamp -- string value  
                self:setVariable("Timestamp",strTimestamp)  
            
                local strSystemStatus = sbdata.SystemStatus -- string value
                self:setVariable("OnlineState",strSystemStatus)
			
                local iProduction = sbdata.Production_W -- integer value
                iProduction = iProduction/1000
                self:setVariable("Production_kW",iProduction)
                strProduction = string.format("%.3f", iProduction) -- now string value

                local iConsumption = sbdata.Consumption_W
			    iConsumption = iConsumption/1000
                self:setVariable("Consumption_kW",iConsumption)	
			    strConsumption = string.format("%.3f", iConsumption)	

			    local str = sbdata.GridFeedIn_W
                str = str/1000
                self:setVariable("GridFeedIn_kW",str)
			    strGridFeedIn = string.format("%.3f", str)
                
	
			    local iPac_total = sbdata.Pac_total_W
			    iPac_total = iPac_total/1000
                self:setVariable("Pac_kW",iPac_total)
			    strPac_total = string.format("%.3f", iPac_total)
			
			    local iRSOC = sbdata.RSOC
			    iRSOC = string.format("%.0f", iRSOC)
                self:setVariable("SOC_%",iRSOC)
                strRSOC = string.format("%.0f", iRSOC)

                -- Write Global Values to Fibaro memory
                -- Schreiben Globaler Variablen in zentrale Variablenverwaltung
                -- leider kann Fibaro nur String-Werte gespeichern
                if  (self.setGlobalValues == "yes") then
                    fibaro.setGlobalVariable("sbTimestamp", strTimestamp)
                    fibaro.setGlobalVariable("sbSystemStatus", strSystemStatus)
                    fibaro.setGlobalVariable("sbProduction", strProduction)
                    fibaro.setGlobalVariable("sbConsumption", strConsumption)
                    fibaro.setGlobalVariable("sbGridFeedIn", strGridFeedIn)
                    fibaro.setGlobalVariable("sbPac_total", strPac_total)
                    fibaro.setGlobalVariable("sbRSOC", strRSOC)
                    self:debug("sbA1 - save Global Values to Fibaro! Ready")
                    self:updateView("statemessage", "text", "Message: >>> sbAdapter1 okay & ready")
                end

                -- Prepare data for inside QA-View
                -- Daten für interne QA-Anzeige speichern
  			    local vMessage = "------------- LIVEDATEN-ANZEIGE für Eco 8.0 / SB 10 -------------"
			    self:updateView("message", "text", vMessage)              

			    local vTimestamp = "Zeit: " ..strTimestamp.." - Status: "..strSystemStatus.."!"
			    self:updateView("time", "text", vTimestamp)
            
                local vConsumption = "Erzeugung: "..strProduction.." kW / Verbrauch: "..strConsumption.. " kW"
			    self:updateView("consum", "text", vConsumption)

			    local vGridFeedIn = "Einspeisung / Bezug(-): " ..strGridFeedIn.." kW"
			    self:updateView("gridfeed", "text", vGridFeedIn)

			    local vPac_total = "Entladung / Ladung(-): " ..strPac_total.." kW"
			    self:updateView("pac", "text", vPac_total)

			    local vRSOC = "SOC: " ..strRSOC.." %"
			    self:updateView("rsoc", "text", vRSOC)	
        end,
		error = function(error)
			self:error('error: ' .. json.encode(error))
		end
	    })
    end
    -- Pooling für zyklischen Abruf der Livedaten
    -- self:debug("Timeout sec: ",self.looptime)
    fibaro.setTimeout(self.looptime, function()
    self:readData("sbA1 - activate polling!")
    end)
end
