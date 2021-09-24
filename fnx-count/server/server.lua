ESX = exports.es_extended:getSharedObject()

local JobsCount = {}
local PlayersCache = { count = 0 }


Citizen.CreateThread(function()
   for a, b in pairs(ESX.Jobs) do
      if JobsCount[a] == nil then
        JobsCount[a] = {}
      end
   end
end)


RegisterServerEvent("esx:setJob")
AddEventHandler("esx:setJob",function (src,newjob,lastJob)
    if source == "" then
        if PlayersCache[src] then
            if JobsCount[newjob.name] then
                table.insert(JobsCount[newjob.name],src)
            end
            if JobsCount[lastJob] then
                for a, b in pairs(JobsCount[lastJob]) do
                    if b == src then
                        table.remove(JobsCount[lastJob],tonumber(a))
                        break
                    end
                end
            end
        end
    end
end)


AddEventHandler("esx:playerLoaded",function (src,xplayer,isnew)
    if PlayersCache[src] == nil then
        PlayersCache[src] = xplayer
        PlayersCache.count = (PlayersCache.count + 1)
        if JobsCount[xplayer.job.name] then
            table.insert(JobsCount[xplayer.job.name],src)
        end
    end
end)


AddEventHandler("esx:playerDropped",function (src,reason)
    if PlayersCache[src] then
        if JobsCount[PlayersCache[src].job.name] then
            local job = PlayersCache[src].job.name
            for a, b in pairs(JobsCount[job]) do
                if b == src then
                    table.remove(JobsCount[PlayersCache[src].job.name],tonumber(a))
                    break
                end
            end
        end
        PlayersCache[src] = nil
        PlayersCache.count = ((PlayersCache.count - 1) or 0)
    end
end)



exports("getCountJob",function (job)
    return (#JobsCount[job] or 0)
end)

exports("getCountPlayers",function ()
    return PlayersCache.count
end)

--

exports("getTablePlayers",function ()
    return (PlayersCache or {})
end)

exports("getTablePlayersJob",function (job)
    return (JobsCount[job] or {})
end)



--[[


--ESEMPIO VECCHIO CONTROLLO JOB "LAGGOSO"

ExampleChekJobOnline = function (job)  
    local count = 0
    for index, player in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(tonumber(player))
        if xPlayer then
            if xPlayer.job.name == job then
                count = count + 1
            end
        end
     end
    return count
end


--ESEMPIO DI QUESTO SISTEMA 


local JobOnline = exports["fnx-count"]:getCountJob("job")


]]




--- Per Poter Usare questo sistema bisogna modificare il classico setjob aggiungendo un trigger
--[[


    self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = self.job.name                                                             --------> [EDIT]

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)                              --------> [EDIT]
			self.triggerEvent('esx:setJob', self.job)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end
]]

---Il trigger è stato gia protetto cosi che nessun client possa triggerarlo per falsare i valori




