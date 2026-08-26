-- [[ Notifys ]] -- 

function SINCO.notify(source,msg)
    if type(msg) == "table" then
        msg = table.unpack(msg)
    end
    if source == 0 then
        print(msg)
    else
        TriggerClientEvent("SINCO:Notify",source,msg)
    end
end

function SINCO.notifyPicture(ay,az,l,ac,aA,aB,aC)
    TriggerClientEvent("SINCO:notifyPicture",ay,az,l,ac,aA,aB,aC)
end

function SINCO.notifyPicture2(a8, type, a9, aa, ab)
    TriggerClientEvent("SINCO:notifyPicture2", a8, type, a9, aa, ab)
end

function SINCO.notifyPicture5(headshot, iconType, title, usePicture, message)
    TriggerClientEvent("SINCO:notifyPicture5", headshot, iconType, title, usePicture, message)
end

function SINCO.notifyPicture(ay,az,l,ac,aA,aB,aC)
    TriggerClientEvent("SINCO:notifyPicture",ay,az,l,ac,aA,aB,aC)
end

-- [[ Weapons ]] --

function SINCO.giveWeapons(h, i,passkey)
    TriggerClientEvent("SINCO:giveWeapons",h, i,passkey)
end

function SINCO.calculateTimeRemaining(expireTime)
    if tonumber(expireTime) then
        local datetime = ''
        local expiry = os.date("%d/%m/%Y at %H:%M", tonumber(expireTime))
        local hoursLeft = ((tonumber(expireTime)-os.time()))/3600
        local minutesLeft = nil
        if hoursLeft < 1 then
            minutesLeft = hoursLeft * 60
            minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
            datetime = minutesLeft .. " mins" 
            return datetime
        else
            hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
            datetime = hoursLeft .. " hours" 
            return datetime
        end
        return datetime
    else
        return "Permanent Ban"
    end
end

function SINCO.getGangName(user_id)
    return exports["sinco-core"]:scalarSync("SELECT gangname FROM sinco_user_gangs WHERE user_id = @user_id", {user_id = user_id}) or ""
end

function SINCO.calculateTimeAgo(creationTime)
    if tonumber(creationTime) then
        local datetime = ''
        local secondsAgo = os.time() - tonumber(creationTime)
        local minutesAgo = secondsAgo / 60
        local hoursAgo = minutesAgo / 60
        local daysAgo = hoursAgo / 24
        if daysAgo >= 1 then
            daysAgo = math.floor(daysAgo)
            datetime = daysAgo .. (daysAgo == 1 and " day" or " days") .. " ago"
        elseif hoursAgo >= 1 then
            hoursAgo = math.floor(hoursAgo)
            datetime = hoursAgo .. (hoursAgo == 1 and " hour" or " hours") .. " ago"
        elseif minutesAgo >= 1 then
            minutesAgo = math.floor(minutesAgo)
            datetime = minutesAgo .. (minutesAgo == 1 and " minute" or " minutes") .. " ago"
        else
            secondsAgo = math.floor(secondsAgo)
            datetime = secondsAgo .. (secondsAgo == 1 and " second" or " seconds") .. " ago"
        end
        return datetime
    else
        return "Invalid timestamp"
    end
end

function SINCO.GetPlayersInRoutingBucket(bucketid)
    local players = {}
    for k,v in pairs(GetPlayers()) do
        if GetPlayerRoutingBucket(v) == bucketid then
            table.insert(players,v)
        end
    end
    return players
end