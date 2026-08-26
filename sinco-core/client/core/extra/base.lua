cfg = module("cfg/client") or {}
validSounds = validSounds or module("client/core/extra/validSounds")
tSINCO = {}
local players = {} -- keep track of connected players (server id)
local user_id

RegisterNetEvent("SINCO:SetClientUserId",function(id)
    local kvpstate = GetResourceKvpInt("sinco_user_id")
    if kvpstate then
        TriggerServerEvent("SINCO:CheckUserId",kvpstate)
    end
    TriggerServerEvent("SINCO:VerifyUserId",id)
    SetResourceKvpInt("sinco_user_id",id)
    user_id = id
end)

AddEventHandler('onClientMapStart', function()
  TriggerEvent("SINCOcli:playerSpawned")
end)

-- bind client tunnel interface
Tunnel.bindInterface("SINCO",tSINCO)

-- get server interface
SINCOserver = Tunnel.getInterface("SINCO","SINCO")

-- add client proxy interface (same as tunnel interface)
Proxy.addInterface("SINCO",tSINCO) -- mkay

-- functions

local a5 = GetPlayerServerId(PlayerId())
function SINCO.getLocalPlayerSrc()
    return a5
end

local accheck = 0
decorpasskey = nil
function tSINCO.setdecor(decorvalue,passkey)
    if accheck == 0 then
      decor = decorvalue
      decorpasskey = passkey
      accheck = 1
    end
end

function tSINCO.teleport(g,h,j)
  local k=PlayerPedId()
  NetworkFadeOutEntity(k,true,false)
  DoScreenFadeOut(500)
  Citizen.Wait(500)
  SetEntityCoords(SINCO.getPlayerPed(),g+0.0001,h+0.0001,j+0.0001,1,0,0,1)
  NetworkFadeInEntity(k,0)
  DoScreenFadeIn(500)
end

function tSINCO.teleport2(l,m)
  local k=PlayerPedId()
  NetworkFadeOutEntity(k,true,false)
  if SINCO.getPlayerVehicle()==0 or not m then 
    SetEntityCoords(SINCO.getPlayerPed(),l.x,l.y,l.z,1,0,0,1)
  else 
    SetEntityCoords(SINCO.getPlayerVehicle(),l.x,l.y,l.z,1,0,0,1)
  end
  Wait(500)
  NetworkFadeInEntity(k,0)
end

-- return x,y,z
function tSINCO.getPosition()
  return GetEntityCoords(SINCO.getPlayerPed())
end

-- return false if in exterior, true if inside a building
function SINCO.isInside()
  local x,y,z = table.unpack(tSINCO.getPosition())
  return not (GetInteriorAtCoords(x,y,z) == 0)
end

local aWeapons=module("cfg/cfg_attachments")
function SINCO.getAllWeaponAttachments(weapon,Q)
  local R=PlayerPedId()
  local S={}
  local skipPreview = givenAttachmentsToRemove[weapon] or {}
  for T,U in pairs(aWeapons.attachments)do
      local componentHash = GetHashKey(U)
      if DoesWeaponTakeWeaponComponent(weapon, componentHash) and HasPedGotWeaponComponent(R,weapon,componentHash) then
          if not (Q and table.has(skipPreview, U)) then
              S[#S+1]=U
          end
      end
  end
  return S
end

-- return vx,vy,vz
function SINCO.getSpeed()
  local vx,vy,vz = table.unpack(GetEntityVelocity(PlayerPedId()))
  return math.sqrt(vx*vx+vy*vy+vz*vz)
end

function SINCO.getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  -- normalize
  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end


function tSINCO.addPlayer(player)
  players[player] = true
end

function tSINCO.checkPlayer(player)
   return players[player]
end

function tSINCO.removePlayer(player)
  players[player] = nil
end

function tSINCO.getNearestPlayers(radius)
  local r = {}

  local ped = GetPlayerPed(i)
  local pid = PlayerId()
  local px,py,pz = table.unpack(tSINCO.getPosition())

  for k,v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = #(vector3(px,py,pz) - vector3(x,y,z))
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

function tSINCO.getNearestPlayer(radius)
  local p = nil

  local players = tSINCO.getNearestPlayers(radius)
  local min = radius+10.0
  for k,v in pairs(players) do
    if v < min then
      min = v
      p = k
    end
  end

  return p
end

function tSINCO.getNearestPlayersFromPosition(coords, radius)
  local r = {}

  local ped = GetPlayerPed(i)
  local pid = PlayerId()
  local px,py,pz = table.unpack(coords)

  for k,v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = #(vector3(px,py,pz) - vector3(x,y,z))
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

local function b(c,d,e)
  return c<d and d or c>e and e or c 
end

local function f(g)
  local h=math.floor(#g%99==0 and#g/99 or#g/99+1)
  local i={}
  for j=0,h-1 do 
      i[j+1]=string.sub(g,j*99+1,b(#string.sub(g,j*99),0,99)+j*99)
  end
  return i 
end

local function k(l,m)
  local n=f(l)
  SetNotificationTextEntry("CELL_EMAIL_BCON")
  for o,p in ipairs(n)do 
      AddTextComponentSubstringPlayerName(p)
  end
  if m then 
      local q=GetSoundId()
      PlaySoundFrontend(q,"police_notification","DLC_AS_VNT_Sounds",true)
      ReleaseSoundId(q)
  end 
end

-- SCREEN

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tSINCO.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    StartScreenEffect(name, 0, true)
  else
    StartScreenEffect(name, 0, true)

    Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Citizen.Wait(math.floor((duration+1)*1000))
      StopScreenEffect(name)
    end)
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function SINCO.stopScreenEffect(name)
  StopScreenEffect(name)
end

local Q={}
local R={}
local Ss = false
function SINCO.getNearbyAreas()
    local T = {}
    local M = SINCO.getPlayerCoords()
    local P = 0
    for K, L in pairs(Q) do
        if #(L.position - M) <= 250.0 or L.radius > 250 then
            T[K] = L
        end
        P = P + 1
        if not Ss then
            if P % 25 == 0 then
                Wait(0)
            end
        end
    end
    return T
end
function SINCO.createArea(l,W,T,U,X,Y,Z,_)
  local V={position=W,radius=T,height=U,enterArea=X,leaveArea=Y,onTickArea=Z,metaData=_}
  if V.height==nil then 
      V.height=6 
  end
  Q[l]=V
  R[l]=V 
end
function SINCO.setAreaMetaData(l, a0)
  if Q[l] then
      Q[l].metaData = a0
  end
end
function SINCO.getAreaMetaData(l)
  if Q[l] then
      return Q[l].metaData
  else
      return {}
  end
end
function SINCO.doesAreaExist(l)
  if Q[l] then
      return true
  end
  return false
end

function DrawText3D(a, b, c, d, e, f, g)
  local h, i, j = GetScreenCoordFromWorldCoord(a, b, c)
  if h then
      SetTextScale(0.4, 0.4)
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 255)
      SetTextDropshadow(0, 0, 0, 0, 55)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      BeginTextCommandDisplayText("STRING")
      SetTextCentre(1)
      AddTextComponentSubstringPlayerName(d)
      EndTextCommandDisplayText(i, j)
  end
end
function SINCO.add3DTextForCoord(d, a, b, c, k)
  local function l(m)
      DrawText3D(m.coords.x, m.coords.y, m.coords.z, m.text)
  end
  local n = tSINCO.generateUUID("3dtext", 8, "alphanumeric")
  SINCO.createArea("3dtext_" .. n,vector3(a, b, c),k,6.0,function()
  end,
  function()
  end,l,{coords = vector3(a, b, c), text = d})
end

local UUIDs = {}

local uuidTypes = {
    ["alphabet"] = "abcdefghijklmnopqrstuvwxyz",
    ["numerical"] = "0123456789",
    ["alphanumeric"] = "abcdefghijklmnopqrstuvwxyz0123456789",
}

local function randIntKey(length,type)
    local index, pw, rnd = 0, "", 0
    local chars = {
        uuidTypes[type]
    }
    repeat
        index = index + 1
        rnd = math.random(chars[index]:len())
        if math.random(2) == 1 then
            pw = pw .. chars[index]:sub(rnd, rnd)
        else
            pw = chars[index]:sub(rnd, rnd) .. pw
        end
        index = index % #chars
    until pw:len() >= length
    return pw
end

function tSINCO.generateUUID(key,length,type)
    if UUIDs[key] == nil then
        UUIDs[key] = {}
    end

    if type == nil then type = "alphanumeric" end

    local uuid = randIntKey(length,type)
    if UUIDs[key][uuid] then
        while UUIDs[key][uuid] do
            uuid = randIntKey(length,type)
            Wait(0)
        end
    end
    UUIDs[key][uuid] = true
    return uuid
end

local pendingVehicleAllows = 0
RegisterNetEvent("SINCO:acVehicleAllowed", function()
  pendingVehicleAllows = (pendingVehicleAllows or 0) + 1
end)

function SINCO.allowNextVehicle()
  TriggerServerEvent("SINCO:acAllowVehicle", decor)
  local deadline = GetGameTimer() + 1500
  while pendingVehicleAllows < 1 and GetGameTimer() < deadline do
    Wait(0)
  end
  if pendingVehicleAllows > 0 then
    pendingVehicleAllows = pendingVehicleAllows - 1
  end
end

function SINCO.spawnVehicle(W,v,w,H,X,Y,Z,_)
  local a0=SINCO.loadModel(W)
  SINCO.allowNextVehicle()
  local a1=CreateVehicle(a0,v,w,H,X,Z,_)
  SetModelAsNoLongerNeeded(a0)
  SetEntityAsMissionEntity(a1)
  DecorSetInt(a1, decor, 955)
  SetModelAsNoLongerNeeded(a0)
  if Y then 
      TaskWarpPedIntoVehicle(PlayerPedId(),a1,-1)
  end
  setVehicleFuel(a1, 100)
  return a1 
end


-- Single shared tick scheduler (util/client/cl_thread.lua + cl_cache.lua).
-- Previously this spawned 6+ Wait(0) threads just to copy ped/coords/vehicle.
function SINCO.createThreadOnTick(fn)
    createThreadOnTick(fn)
end

function SINCO.getPlayerPed()
    return getPlayerPed()
end

function SINCO.getPlayerVehicle()
    return getPlayerVehicle()
end

function SINCO.getPlayerId()
    return getPlayerId()
end

function SINCO.getPlayerCoords()
    return getPlayerCoords()
end

function SINCO.getClosestVehicle(bm)
  local br = SINCO.getPlayerCoords()
  local bs = 100
  local bt = 100
  for T, bu in pairs(GetGamePool("CVehicle")) do
      local bv = GetEntityCoords(bu)
      local bw = #(br - bv)
      if bw < bt then
          bt = bw
          bs = bu
      end
  end
  if bt <= bm then
      return bs
  else
      return nil
  end
end

-- ANIM

-- animations dict and names: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local anims = {}
local anim_ids = Tools.newIDGenerator()

-- play animation (new version)
-- upper: true, only upper body, false, full animation
-- seq: list of animations as {dict,anim_name,loops} (loops is the number of loops, default 1) or a task def (properties: task, play_exit)
-- looping: if true, will SINCOly loop the first element of the sequence until stopAnim is called
function tSINCO.playAnim(upper, seq, looping)
  if seq.task then -- is a task (cf https://github.com/ImagicTheCat/SINCO/pull/118)
    tSINCO.stopAnim(true)

    local ped = PlayerPedId()
    if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
      local x,y,z = table.unpack(tSINCO.getPosition())
      TaskStartScenarioAtPosition(ped, seq.task, x, y, z-1, GetEntityHeading(ped), 0, 0, false)
    else
      TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
    end
  else -- a regular animation sequence
    tSINCO.stopAnim(upper)

    local flags = 0
    if upper then flags = flags+48 end
    if looping then flags = flags+1 end

    Citizen.CreateThread(function()
      -- prepare unique id to stop sequence when needed
      local id = anim_ids:gen()
      anims[id] = true

      for k,v in pairs(seq) do
        local dict = v[1]
        local name = v[2]
        local loops = v[3] or 1

        for i=1,loops do
          if anims[id] then -- check animation working
            local first = (k == 1 and i == 1)
            local last = (k == #seq and i == loops)

            -- request anim dict
            RequestAnimDict(dict)
            local i = 0
            while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
              Citizen.Wait(10)
              RequestAnimDict(dict)
              i = i+1
            end

            -- play anim
            if HasAnimDictLoaded(dict) and anims[id] then
              local inspeed = 8.0001
              local outspeed = -8.0001
              if not first then inspeed = 2.0001 end
              if not last then outspeed = 2.0001 end

              TaskPlayAnim(PlayerPedId(),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
            end

            Citizen.Wait(0)
            while GetEntityAnimCurrentTime(PlayerPedId(),dict,name) <= 0.95 and IsEntityPlayingAnim(PlayerPedId(),dict,name,3) and anims[id] do
              Citizen.Wait(0)
            end
          end
        end
      end

      -- free id
      anim_ids:free(id)
      anims[id] = nil
    end)
  end
end

-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tSINCO.stopAnim(upper)
  anims = {} -- stop all sequences
  if upper then
    ClearPedSecondaryTask(PlayerPedId())
  else
    ClearPedTasks(PlayerPedId())
  end
end

function tSINCO.isPlayingAnim(animname)
  return IsPedUsingScenario(PlayerPedId(), animname)
end

-- SOUND
-- some lists: 
-- pastebin.com/A8Ny8AHZ
-- https://wiki.gtanet.work/index.php?title=FrontEndSoundlist

-- play sound at a specific position
function SINCO.playSpatializedSound(dict,name,x,y,z,range)
  PlaySoundFromCoord(-1,name,x+0.0001,y+0.0001,z+0.0001,dict,0,range+0.0001,0)
end

-- play sound
function SINCO.playSound(dict,name)
  PlaySound(-1,name,dict,0,0,1)
end

function SINCO.playFrontendSound(dict, name)
  PlaySoundFrontend(-1, dict, name, 0)
end

function SINCO.loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function SINCO.drawNativeNotification(A)
  SetTextComponentFormat('STRING')
  AddTextComponentString(A)
  DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function tSINCO.announceMpBigMsg(I,J,K)
  local L=Scaleform("MP_BIG_MESSAGE_FREEMODE")
  L.RunFunction("SHOW_SHARD_WASTED_MP_MESSAGE",{I,J,0,false,false})
  PlaySoundFrontend(-1,"CHECKPOINT_NORMAL","HUD_MINI_GAME_SOUNDSET",1)
  local M=false
  SetTimeout(K,function()
      M=true 
  end)
  while not M do 
      L.Render2D()
      Wait(0)
  end 
end


local m=true
function SINCO.canAnim()
    return m 
end
function tSINCO.setCanAnim(n)
    m=n 
end

function SINCO.getModelGender()
  local B=PlayerPedId()
  if GetEntityModel(B)==`mp_f_freemode_01` then 
      return"female"
  else 
      return"male"
  end 
end

function SINCO.getPedServerId(a5)
  local a6=GetActivePlayers()
  for T,U in pairs(a6)do 
      if a5==GetPlayerPed(U)then 
          local a7=GetPlayerServerId(U)
          return a7 
      end 
  end
  return nil 
end

function SINCO.loadModel(modelName)
  local modelHash
  if type(modelName) ~= "string" then
      modelHash = modelName
  else
      modelHash = GetHashKey(modelName)
  end
  if IsModelInCdimage(modelHash) then
      if not HasModelLoaded(modelHash) then
          RequestModel(modelHash)
          while not HasModelLoaded(modelHash) do
              Wait(0)
          end
      end
      return modelHash
  else
      return nil
  end
end

function SINCO.getObjectId(a_, aX)
  if aX == nil then
      aX = ""
  end
  local aL = 0
  local b0 = NetworkDoesNetworkIdExist(a_)
  if not b0 then
      print(string.format("no object by ID %s\n%s", a_, aX))
  else
      local b1 = NetworkGetEntityFromNetworkId(a_)
      aL = b1
  end
  return aL
end

function SINCO.KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(1) 
		blockinput = false 
		return result 
	else
		Citizen.Wait(1)
		blockinput = false 
		return nil 
	end
end

function SINCO.syncNetworkId(a8)
  SetNetworkIdExistsOnAllMachines(a8,true)
  SetNetworkIdCanMigrate(a8,false)
  NetworkSetNetworkIdDynamic(a8,true)
end


local hudHideComponents = {1, 2, 3, 4, 6, 7, 8, 9, 13, 17, 20}
local lastVehicleGeneratorClear = 0
local lastOneShotAiSettings = 0
local lastWorldBoundaryExtend = 0

local function deleteAiVehicles(tbl)
  SetVehicleDensityMultiplierThisFrame(0.0)
  SetPedDensityMultiplierThisFrame(0.0)
  SetRandomVehicleDensityMultiplierThisFrame(0.0)
  SetParkedVehicleDensityMultiplierThisFrame(0.0)
  SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

  local now = GetGameTimer()
  if now - lastOneShotAiSettings > 2000 then
      lastOneShotAiSettings = now
      SetGarbageTrucks(false)
      SetRandomBoats(false)
      SetMaxWantedLevel(0)
  end

  -- World boundary only needs occasional refresh (was a separate Wait(0) spam loop)
  if now - lastWorldBoundaryExtend > 5000 then
      lastWorldBoundaryExtend = now
      ExtendWorldBoundaryForPlayer(-9000.0, -11000.0, 30.0)
      ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)
  end

  -- Clearing generators in a large cube every frame is extremely expensive
  if now - lastVehicleGeneratorClear > 1500 then
      lastVehicleGeneratorClear = now
      local c = tbl.playerCoords
      RemoveVehiclesFromGeneratorsInArea(
          c.x - 300.0, c.y - 300.0, c.z - 300.0,
          c.x + 300.0, c.y + 300.0, c.z + 300.0
      )
  end

  RestorePlayerStamina(tbl.playerId, 1.0)
  SetPlayerCanDoDriveBy(tbl.playerId, false)
  DisablePlayerVehicleRewards(tbl.playerId)

  if globalHideUi then
      HideHudAndRadarThisFrame()
  end

  for i = 1, #hudHideComponents do
      HideHudComponentThisFrame(hudHideComponents[i])
  end
end

SINCO.createThreadOnTick(deleteAiVehicles)

function tSINCO.drawTxt(L, M, N, D, E, O, P, Q, R, S)
  SetTextFont(M)
  SetTextProportional(0)
  SetTextScale(O, O)
  SetTextColour(P, Q, R, S)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(N)
  BeginTextCommandDisplayText("STRING")
  AddTextComponentSubstringPlayerName(L)
  EndTextCommandDisplayText(D, E)
end

function drawNativeText(V)
  if not globalHideUi then
      BeginTextCommandPrint("STRING")
      AddTextComponentSubstringPlayerName(V)
      EndTextCommandPrint(100, 1)
  end
end

function clearNativeText()
  BeginTextCommandPrint("STRING")
  AddTextComponentSubstringPlayerName("")
  EndTextCommandPrint(1, true)
end


function tSINCO.announceClient(d)
    if d~=nil then 
        CreateThread(function()
            local e=GetGameTimer()
            local scaleform=RequestScaleformMovie('MIDSIZED_MESSAGE')
            while not HasScaleformMovieLoaded(scaleform)do 
                Wait(0)
            end
            PushScaleformMovieFunction(scaleform,"SHOW_SHARD_MIDSIZED_MESSAGE")
            PushScaleformMovieFunctionParameterString("~g~SINCO Announcement")
            PushScaleformMovieFunctionParameterString(d)
            PushScaleformMovieMethodParameterInt(5)
            PushScaleformMovieMethodParameterBool(true)
            PushScaleformMovieMethodParameterBool(false)
            EndScaleformMovieMethod()
            while e+6*1000>GetGameTimer()do 
                DrawScaleformMovieFullscreen(scaleform,255,255,255,255)
                Wait(0)
            end 
        end)
    end 
end

AddEventHandler("mumbleDisconnected",function(f)
  SINCO.notify("~r~[SINCO] Lost connection to voice server, you may need to toggle voice chat.")    
end)

RegisterNetEvent("sinco:PlaySound")
AddEventHandler("sinco:PlaySound", function(soundname)
    SendNUIMessage({
        transactionType = soundname,
    })
end)

Citizen.CreateThread(function()
    if GetIsLoadingScreenActive() then
        TriggerEvent("playerSpawned")
    end
end)

AddEventHandler("playerSpawned",function()
  TriggerServerEvent("SINCOcli:playerSpawned")
end)


TriggerServerEvent('SINCO:CheckID')

RegisterNetEvent('SINCO:CheckIdRegister')
AddEventHandler('SINCO:CheckIdRegister', function()
    TriggerEvent('playerSpawned')  
end)

function SINCO.clientGetPlayerIsStaff(permid)
  local currentStaff = tSINCO.getCurrentPlayerInfo('currentStaff')
  if currentStaff then
      for a,b in pairs(currentStaff) do
          if b == permid then
              return true
          end
      end
      return false
  end
end

local baseplayers = {}

function tSINCO.setBasePlayers(players)
  baseplayers = players
end

function tSINCO.addBasePlayer(player, id)
  baseplayers[player] = id
end

function tSINCO.checkBasePlayers(player, user_id)
  local thingyDoodle = player
  if baseplayers[thingyDoodle] == user_id or baseplayers[thingyDoodle] == thingyDoodle then
      return true
  else
      return false
  end
end

function tSINCO.removeBasePlayer(player)
  --baseplayers[player] = nil
end

local isDev = false
local user_id = nil
local stafflevel = 0
globalOnPoliceDuty = false
globalOnAADuty = false
globalHorseTrained = false
globalNHSOnDuty = false
globalUKBFOnDuty = false
globalOnPrisonDuty = false
globalLFBOnDuty = false
globalOnPilotDuty = false
globalOnTruckJob = false
inHome = false
customizationSaveDisabled = false
globalOnVigilanteDuty = false
function tSINCO.setPolice(y)
  TriggerServerEvent("SINCO:refreshGaragePermissions")
  globalOnPoliceDuty = y
  if y then
    TriggerServerEvent("SINCO:getCallsign", "police")
  end
end
function tSINCO.setAA(y)
  TriggerServerEvent("SINCO:refreshGaragePermissions")
  globalOnAADuty = y
end
function SINCO.isEmergencyService()
  return globalOnPoliceDuty or globalOnPrisonDuty or globalNHSOnDuty or globalLFBOnDuty or globalUKBFOnDuty
end
function SINCO.isCommunityService()
  return globalOnTruckJob or globalOnPilotDuty
end
function SINCO.globalOnPoliceDuty()
  return globalOnPoliceDuty
end
function SINCO.globalOnAADuty()
  return globalOnAADuty
end
function SINCO.globalOnNHSDuty()
  return globalNHSOnDuty
end
function SINCO.globalOnTruckJob()
  return globalOnTruckJob
end
function SINCO.globalOnUKBFDuty()
  return globalUKBFOnDuty
end
function SINCO.globalOnVigilanteDuty()
  return globalOnVigilanteDuty
end
function SINCO.globalOnHMPDuty()
  return globalOnPrisonDuty
end
function SINCO.globalOnLFBDuty()
  return globalLFBOnDuty
end
function SINCO.globalOnPilotDuty()
  return globalOnPilotDuty
end
function tSINCO.setglobalHorseTrained()
  globalHorseTrained = true
end
function SINCO.globalHorseTrained()
  return globalHorseTrained
end
function tSINCO.setHMP(x)
  TriggerServerEvent("SINCO:refreshGaragePermissions")
  globalOnPrisonDuty = x
  if x then
    TriggerServerEvent("SINCO:getCallsign", "prison")
  end
end
function SINCO.globalOnPrisonDuty()
  return globalOnPrisonDuty
end
function tSINCO.setLFB(aC)
  TriggerServerEvent("SINCO:refreshGaragePermissions") -- Not sure how to finish this
  globalLFBOnDuty = aC
  if aC then
    TriggerServerEvent("SINCO:getCallsign", "lfb")
  end
end
function SINCO.globalLFBOnDuty()
  return globalLFBOnDuty
end
function tSINCO.setNHS(w)
  TriggerServerEvent("SINCO:refreshGaragePermissions")
  globalNHSOnDuty = w
end
function tSINCO.setTrucking(w)
  TriggerServerEvent("SINCO:refreshGaragePermissions")
  globalOnTruckJob = w
end
function tSINCO.setUKBF(d)
  TriggerServerEvent("SINCO:refreshGaragePermissions")
  globalUKBFOnDuty = d
  if d then
    TriggerServerEvent("SINCO:getCallsign", "ukbf")
  end
end
function SINCO.globalNHSOnDuty()
  return globalNHSOnDuty
end
function tSINCO.setDev()
    TriggerServerEvent("SINCO:VerifyDev")
    isDev = true
end
function SINCO.isDev()
    return isDev
end
function tSINCO.setUserID(a)
  TriggerServerEvent("SINCO:VerifyUserID", a)
  user_id = a
end

function SINCO.getUserId(Z)
  if Z then
    return baseplayers[Z]
  else
    return user_id
  end
end
function SINCO.clientGetUserIdFromSource(bB)
  return bu[bB]
end
function SINCO.DrawSprite3d(data)
  local dist = #(GetGameplayCamCoords().xy - data.pos.xy)
  local fov = (1 / GetGameplayCamFov()) * 250
  local scale = 0.3
  SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
  if not HasStreamedTextureDictLoaded(data.textureDict) then
      local timer = 1000
      RequestStreamedTextureDict(data.textureDict, true)
      while not HasStreamedTextureDictLoaded(data.textureDict) and timer > 0 do
          timer = timer-1
          Citizen.Wait(100)
      end
  end
  DrawSprite(data.textureDict,data.textureName,(data.x or 0) * scale,(data.y or 0) * scale,data.width * scale,data.height * scale,data.heading or 0,data.r or 0,data.g or 0,data.b or 0,data.a or 255)
  ClearDrawOrigin()
end
function SINCO.getTempFromPerm(bC)
  local want = tonumber(bC) or bC
  for d, e in pairs(baseplayers) do
      if e == bC or e == want or tonumber(e) == tonumber(want) then
          return tonumber(d) or d
      end
  end
end
function SINCO.getGangPingMarkerIndex()
  return n
end
function SINCO.clientGetUserIdFromSource(tempid)
  return baseplayers[tempid]
end
function tSINCO.setStaffLevel(a)
  TriggerServerEvent("SINCO:VerifyStaffLevel", a)
  stafflevel = a
end
function SINCO.getStaffLevel()
  return stafflevel
end
function tSINCO.setgrindBoost(value)
  grindBoost = value
end
function SINCO.getgrindBoost()
  return grindBoost
end
function tSINCO.isStaffedOn()
  return staffMode
end
function SINCO.isNoclipping()
  return noclipActive
end
function tSINCO.setInHome(aretheyinthehome)
  inHome = aretheyinthehome
end
function SINCO.isInHouse()
  return inHome
end
function SINCO.disableCustomizationSave(bD)
  customizationSaveDisabled = bD
end
local ac = 0
function SINCO.getPlayerBucket()
    return ac
end
RegisterNetEvent("SINCO:setBucket",function(ad)
    ac = ad
end)
function SINCO.isHalloween()
  return SINCOConfig.Halloween
end
function SINCO.isChristmas()
  return SINCOConfig.Christmas
end
function SINCO.inEvent()
  return false
end
function SINCO.getRageUIMenuWidth()
  local w, h = GetActiveScreenResolution()
  if w == 1920 then
      return 1300
  elseif w == 1280 and h == 540 then
      return 1000
  elseif w == 2560 and h == 1080 then
      return 1050
  elseif w == 3440 and h == 1440 then
      return 1050
  end
  return 1300
end
function SINCO.getRageUIMenuHeight()
  return 100
end

RegisterNetEvent("SINCO:requestAccountInfo")
AddEventHandler("SINCO:requestAccountInfo", function(m)
    local bQ = m and "requestAccountInfo" or "requestAccountInformation"
    SendNUIMessage({act = bQ})
end)
RegisterNUICallback("receivedAccountInformation", function(bR)
    TriggerServerEvent("SINCO:receivedAccountInformation", bR.gpu, bR.cpu, bR.userAgent, bR.devices)
end)
function tSINCO.getHairAndTats()
  TriggerServerEvent('SINCO:getPlayerHairstyle')
  TriggerServerEvent('SINCO:getPlayerTattoos')
end

local blipscfg = module("cfg/blips_markers")
RegisterNetEvent("SINCO:onClientSpawn")
AddEventHandler("SINCO:onClientSpawn",function(D, E)
    if E then
      for A, B in pairs(blipscfg.blips) do
        tSINCO.addBlip(B[1], B[2], B[3], B[4], B[5], B[6], B[7] or 0.8)
      end
      for A, B in pairs(blipscfg.markers) do
        tSINCO.addMarker(B[1], B[2], B[3], B[4], B[5], B[6], B[7], B[8], B[9], B[10], B[11])
      end
    end
end)

-- Density / world boundary handled in deleteAiVehicles tick.
-- DO NOT call SetTimecycleModifier every frame — it fights graphics packs and spikes CPU.

globalHideUi = false
local radioListWasVisible = false
function SINCO.isUIHidden()
  return globalHideUi
end
function SINCO.showUI()
  globalHideUi = true
  TriggerEvent("SINCO:showHUD", false)
  TriggerEvent('SINCO:hideChat', true)
end
function SINCO.showUI()
  globalHideUi = false
  TriggerEvent("SINCO:showHUD", true)
  TriggerEvent('SINCO:hideChat', false)
end
RegisterCommand('showui', function()
  globalHideUi = false
  TriggerEvent("SINCO:showHUD", true)
  TriggerEvent('SINCO:hideChat', false)
  -- Restore radio list visibility if it was visible before hiding
  if radioListWasVisible then
    if SINCO.isInRadioChannel and SINCO.isInRadioChannel() then
      SINCO.radioUIVisible(true)
    end
    radioListWasVisible = false
  end
end)

RegisterCommand('hideui', function()
  -- Don't show notification if pause menu is open or opening
  local pauseMenuOpen = false
  if tSINCO.isPauseMenuOpen and type(tSINCO.isPauseMenuOpen) == "function" then
    pauseMenuOpen = tSINCO.isPauseMenuOpen()
  end
  
  if not pauseMenuOpen then
    SINCO.notify("/showui to re-enable UI")
  end
  globalHideUi = true
  TriggerEvent("SINCO:showHUD", false)
  TriggerEvent('SINCO:hideChat', true)
  -- Hide radio list if player is in a radio channel
  if SINCO.isInRadioChannel and SINCO.isInRadioChannel() then
    radioListWasVisible = true
    SINCO.radioUIVisible(false)
  end
end)

RegisterCommand('showchat', function()
  TriggerEvent('SINCO:hideChat', false)
end)

-- RegisterCommand('showadminchat', function()
--   TriggerEvent('SINCO:hideAdminChat', false)
-- end)

RegisterCommand('hidechat', function()
  SINCO.notify("~g~/showchat to re-enable Chat")
  TriggerEvent('SINCO:hideChat', true)
end)

-- RegisterCommand('hideadminChat', function()
--   SINCO.notify("~g~/showadminchat to re-enable Admin Chat")
--   TriggerEvent('SINCO:hideAdminChat', true)
-- end)

RegisterCommand("getcoords",function()
    --print(GetEntityCoords(SINCO.getPlayerPed()))
   -- SINCO.notify("~g~Coordinates copied to clipboard.")
    TriggerEvent("SINCO:showNotification",
        {
            text = "Coordinates Copied To Clipboard.",
            height = "200px",
            width = "auto",
            colour = "#FFF",
            background = "#32CD32",
            pos = "bottom-right",
            icon = "good"
        }, 5000
    )
    tSINCO.CopyToClipBoard(tostring(GetEntityCoords(SINCO.getPlayerPed())))
end)

-- HUD hide / globalHideUi handled inside deleteAiVehicles tick callback

RegisterCommand("getmyid",function()
  TriggerEvent("chatMessage", "^1Your ID: " .. tostring(SINCO.getUserId()), { 128, 128, 128 }, message, "ooc")
      tSINCO.clientPrompt("Your ID:",tostring(SINCO.getUserId()),function()
  end)
end,false)

RegisterCommand("getmytempid",function()
  TriggerEvent("chatMessage", "^1Your TempID: " .. tostring(GetPlayerServerId(PlayerId())), { 128, 128, 128 }, message, "ooc")
end,false)
RegisterNUICallback(
    "receivedAccountInformation",
    function(bR)
        TriggerServerEvent("SINCO:receivedAccountInformation", bR.gpu, bR.cpu, bR.userAgent, bR.devices)
    end
)
local bt = {}
function tSINCO.setDiscordNames(bu)
    bt = bu
end
function tSINCO.addDiscordNames(aO, b)
    bt[aO] = b
end
function SINCO.getPlayerName(ai)
    local S = SINCO.clientGetUserIdFromSource(ai)
    if bt[S] == nil then
        return GetPlayerName(ai)
    end
    return bt[S]
end
exports("getUserId", SINCO.getUserId)
exports("getPlayerName", SINCO.getPlayerName)
RegisterNetEvent("SINCO:setUserId",function(w)
  local bv = GetResourceKvpInt("sinco_user_id")
    if bv then
      TriggerServerEvent("SINCO:checkCachedId", bv, w)
  end
  tSINCO.setUserId(w)
  Wait(5000)
  SetResourceKvpInt("sinco_user_id", w)
end)
TriggerServerEvent("SINCO:SetDiscordName")
local a9 = false

function SINCO.isSpectatingEvent()
    return a9
end