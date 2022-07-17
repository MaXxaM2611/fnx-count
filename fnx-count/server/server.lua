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
            if JobsCount[lastJob.name] then
                for a, b in pairs(JobsCount[lastJob.name]) do
                    if b == src then
                        table.remove(JobsCount[lastJob.name],tonumber(a))
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


local JobOnline = exports["fnx-count"]:getCountJob("job")  -- numero player con un determinato lavoro online

local TableJobOnline = exports["fnx-count"]:getTablePlayersJob("job")  -- tabella dei player con un determinato lavoro online

]]

