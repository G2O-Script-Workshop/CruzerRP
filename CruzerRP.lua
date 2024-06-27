--Napisane przez V0ID'a na licencji CC-BY-SA (u¿ycie zezwolone tylko poprzez uwzglêdnienie autora w tekœcie w "OnPlayerConnect")
local Player = {}
local Draws = {} -- Draws'y wstawimy do jednej tablicy
local Cmds = {}
local Classes = {}

--Klasy liderów
local Leaders = {11, 12, 7, 4, 13, 22, 31, 32, 36}

--Timer
SetTimer("Timer_All", 3 * 60000, 1)

-- Szity od drawow
function GetDraw(drawname)
	for i, v in ipairs(Draws) do
		if v.name == drawname then
			return v.id
		end
	end
end

function AddDraw(drawid, drawname)
	table.insert(Draws, { id = drawid, name = drawname})
end

function RemDraw(drawname)
	for i, v in ipairs(Draws) do
		if v.name == drawname then
			DestroyDraw(v.drawid)
			table.remove(Draws, i)
		end
	end
end

--ID po nicku
function GetPlayerIdByName(name)
	for i = 0, GetMaxPlayers() -1 do
		if GetPlayerName(i) == name then
			return i
		end
	end
	
	return -1
end


-- Struktury graczy
for i = 0, GetMaxPlayers() - 1 do
	Player[i] = {}
	Player[i].logged = false
	Player[i].password = nil
	Player[i].class = 0
	Player[i].moderator = 0 --Jest moderatora³kê?
	Player[i].guild = -1 --Brak przyzn
	Player[i].Overlay = nil
	Player[i].seepm = false
		
end
	
AddPlayerClass("PC_HERO",5401.4033203125,285.74258422852,-3149.1264648438,0,5401.4033203125,285.74258422852,-3149.1264648438,0)

function OnGamemodeInit()
	
	EnableChat(0)
	OpenLocks(1)
	SetGamemodeName("http://cruzer-rp.y0.pl/")
	SetServerDescription("******************************\n*Administracja: V0ID, DragonBess *\n            * Quarchodron *\n******************************")
	print "MyrtanaRP Gamemode v2, Re-loaded"
end

function OnPlayerConnect(playerid)
	SendPlayerMessage(playerid, 0, 255,0, "Gamemode stworzony przez V0ID'a.")
	SendPlayerMessage(playerid, 255, 145, 0, "Witaj na serwerze Cruzer RolePlay!")
	SendPlayerMessage(playerid, 255, 145, 0, "Wpisz /pomoc aby dowiedzieæ siê jak graæ na serwerze, powodzenia!")
	
	if IsNPC(playerid) == 0 then
		local fRead = io.open(GetPlayerName(playerid)..".acnt", "r+")
		if fRead then
			SendPlayerMessage(playerid, 111, 255, 0, "Masz ju¿ konto na serwerze: wpisz /zaloguj has³o")
			fRead:close()
		else
			SendPlayerMessage(playerid, 239, 255, 0, "Nie masz konta na serwerze: wpisz /zarejestruj has³o")
		end
		SetPlayerAdditionalVisual(playerid, "HUM_BODY_NAKED0", 2, "HUM_HEAD_BALD", 17)
	end
	
	--Kolor nicku (w sensie ze nie zalogowany)
	SetPlayerColor(playerid, 0, 255, 0)
	--Drawy
	ShowDraw(playerid, GetDraw("server_name"))
	ShowDraw(playerid, GetDraw("website"))
	
end

function OnPlayerText(playerid, text)
	if Player[playerid].logged == true then
	local msgType = GetChatMessageType(text)
		if msgType == "RP" then
			for i = 0, GetMaxPlayers() -1 do
				if GetDistancePlayers(playerid, i) < 1000 then
					SendPlayerMessage(i, 253, 255, 176, string.format("%s %s %s", GetPlayerName(playerid), "mówi", text)) 
				end
			end
		elseif msgType == "SCREAM" then
			text = text:gsub("^.", " ")
			for i = 0, GetMaxPlayers() - 1 do
				if GetDistancePlayers(playerid, i) < 3000 then
					SendPlayerMessage(i, 242, 8, 8, string.format("%s %s%s", GetPlayerName(playerid), "krzyczy:", text))
				end
			end
		elseif msgType == "TO" then
			text = text:gsub("^.", " ")
				for i = 0, GetMaxPlayers() -1 do
					if GetDistancePlayers(playerid, i) < 1000 then
						SendPlayerMessage(i, 47, 242, 8, string.format("%s (%s) ", text, GetPlayerName(playerid)))
					end
				end
		elseif msgType == "OOC" then
			text = text:gsub("^.", " ")
			for i = 0, GetMaxPlayers() -1 do
				if GetDistancePlayers(playerid, i) < 1000 then
					SendPlayerMessage(i, 255, 255, 0, string.format("%s  ((%s:%s)) ", "(OOC)", GetPlayerName(playerid), text))
				end
			end
		elseif msgType == "ME" then
			text = text:gsub("^.", " ")
			for i = 0, GetMaxPlayers() -1 do
				if GetDistancePlayers(playerid, i) < 1000 then
					SendPlayerMessage(i, 242, 86, 8, string.format("# %s%s # ", GetPlayerName(playerid), text))
				end
			end
		end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "Zaloguj siê aby móc pisaæ")
	end
end

function OnPlayerDisconnect(playerid, reason)

	if Player[playerid].logged == true then
		SaveAccount(playerid)
		Player[playerid].logged = false
		Player[playerid].class = 0
		Player[playerid].password = nil
		Player[playerid].moderator = 0
		Player[playerid].guild = -1
		Player[playerid].seepm = false
		SendMessageToAll(255, 0, 0, string.format("%s %s", GetPlayerName(playerid), "od³¹czy³(a) siê od gry"))
	end
	
	--Drawy
	HideDraw(playerid, GetDraw("server_name"))
	HideDraw(playerid, GetDraw("website"))
end

function OnPlayerSpawn(playerid, classid)
	if Player[playerid].logged == false then
		for i = 0, GetMaxPlayers() -1 do
			if IsPlayerConnected(i) == 1 then
				if i ~= playerid then
					SendPlayerMessage(i, 0, 255, 0, string.format("%s %s", GetPlayerName(playerid), "do³¹czy³(a) do gry!"))
				end
			end	
		end
		SetPlayerPos(playerid, 5401.4033203125,285.74258422852,-3149.1264648438)
	else
		SetPlayerPos(playerid, 38601.9140625, 3911.5217285156, -1280.5793457031)
		for i, v in ipairs(Classes) do
			if v.classid == Player[playerid].class then
				ClearInventory(playerid)
				v.func(playerid)
			end
		end
	end
end

function OnPlayerChangeClass(playerid, classid)
	SpawnPlayer(playerid)
	if Player[playerid].logged == false and IsNPC(playerid) == 0 then
		FreezePlayer(playerid, 1)
	end
end

function OnPlayerEnterWorld(playerid, world)
	if world ~= "NEWWORLD\\NEWWORLD.ZEN" then
		SetPlayerWorld(playerid, "NEWWORLD\\NEWWORLD.ZEN", "START")
		SetPlayerPos(playerid, 38601.9140625, 3911.5217285156, -1280.5793457031)	
	end
end

function OnPlayerChangeInstance(playerid, currInstance, oldInstance)
	if IsNPC(playerid) == 0 then
		if currInstance ~= "PC_HERO" then
			ExitGame(playerid)
			Kick(playerid)
		end
	end
end

function OnPlayerHit(playerid, killerid)
	if Player[killerid].class == 0 then
		ExitGame(killerid)
		Kick(killerid)
	end
end

function OnPlayerWeaponMode(playerid, weaponmode)
	if IsNPC(playerid) == 0 then
		if Player[playerid].class == 0 then
			if weaponmode ~= WEAPON_NONE then
				SendPlayerMessage(playerid, 255, 0, 0, "Jesteœ zbyt s³aby ¿eby walczyæ")
				SetPlayerWeaponMode(playerid, WEAPON_NONE)
			end
		else
			local h1, h2, bow, cbow = GetPlayerSkillWeapon(playerid, 0), GetPlayerSkillWeapon(playerid, 1), GetPlayerSkillWeapon(playerid, 2), GetPlayerSkillWeapon(playerid, 3);
		if weaponmode == WEAPON_NONE then
				SetPlayerWalk(playerid, Player[playerid].Overlay); -- or "NULL" for default
		elseif weaponmode == WEAPON_1H then
		Player[playerid].Overlay = GetPlayerWalk(playerid)
		if h1 >= 30 and h1 < 60 then -- 30 = amateur // 60 = master
			SetPlayerWalk(playerid, "Humans_1hST1.mds");
		elseif h1 >= 60 then
			SetPlayerWalk(playerid, "Humans_1hST2.mds");
		end
	elseif weaponmode == WEAPON_2H then
	Player[playerid].Overlay = GetPlayerWalk(playerid)
		if h2 >= 30 and h2 < 60 then 
			SetPlayerWalk(playerid, "Humans_2hST1.mds");
		elseif h2 >= 60 then
			SetPlayerWalk(playerid, "Humans_2hST2.mds");
		end
	elseif weaponmode == WEAPON_BOW then
	Player[playerid].Overlay = GetPlayerWalk(playerid)
		if bow >= 30 and bow < 60 then 
			SetPlayerWalk(playerid, "Humans_BowT1.mds");
		elseif bow >= 60 then
			SetPlayerWalk(playerid, "Humans_BowT2.mds");
		end
	elseif weaponmode == WEAPON_CBOW then
	Player[playerid].Overlay = GetPlayerWalk(playerid)
		if bow >= 30 and bow < 60 then 
			SetPlayerWalk(playerid, "Humans_CBowT1.mds");
		elseif bow >= 60 then
			SetPlayerWalk(playerid, "Humans_CBowT2.mds");
		end
	end
		end
	end
end

function OnPlayerCommandText(playerid, cmdtext)
	local cmd, params = GetCommand(cmdtext)
	
	for i, v in ipairs(Cmds) do
		if cmd == v.cmd then
			v.func(playerid, cmd, params)
		end
	end
	
end

--Rejestracja
function CMD_Register(playerid, cmd, params)
	local result, pass = sscanf(params, "s")
	if result == 1 then
		if Player[playerid].logged == false then
			local fRead = io.open(GetPlayerName(playerid)..".acnt", "r+")
			if fRead then
				SendPlayerMessage(playerid, 255, 0, 0, "Posiadasz ju¿ konto na serwerze. Wpisz /zaloguj has³o aby siê zalogowaæ")
				fRead:close()
			else
				Player[playerid].logged = true
				Player[playerid].password = pass
				FreezePlayer(playerid, 0)
				SetPlayerPos(playerid, 38601.9140625, 3911.5217285156, -1280.5793457031)
				SendPlayerMessage(playerid, 179, 0, 255, "Zarejestrowano pomyœlnie, ¿yczymy dobrej zabawy")
				GameTextForPlayer(playerid, 1500, 7000, "Zapraszamy na nasz¹ stronê http://cruzer-rp.y0.pl/", "Font_Old_10_White_Hi.TGA", 0, 255, 255, 1000 * 10)
				SetPlayerColor(playerid, 255, 255, 255)
				Class_NewPlayer(playerid)
				SaveAccount(playerid)
			end
		else
			SendPlayerMessage(playerid, 255, 0, 0, "Jesteœ ju¿ zalogowany!")
		end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "B³êdna sk³adnia komendy wpisz /zarejestruj has³o");
	end
end
--Logowanie
function CMD_LogIn(playerid, cmd, params)
	local result, pass = sscanf(params, "s")
	if result == 1 then
		if Player[playerid].logged == false then
			local fRead = io.open(GetPlayerName(playerid)..".acnt", "r+")
			if fRead then
				tmp = fRead:read("*l")
				if string.len(tmp) < 0 then SendPlayerMessage(playerid, 255, 0, 0, "Twoje konto jest uszkodzone, powiadom administratora.") return end
				local result, passwd = sscanf(tmp, "s")
					if pass == passwd then
						Player[playerid].logged = true
						Player[playerid].password = pass
						FreezePlayer(playerid, 0)
						SetPlayerPos(playerid, 38601.9140625, 3911.5217285156, -1280.5793457031)
						LoadAccount(playerid)
						SendPlayerMessage(playerid, 0, 255, 154, "Zosta³eœ zalogowany")
						GameTextForPlayer(playerid, 1500, 7000, "Zapraszamy na nasz¹ stronê http://cruzer-rp.y0.pl/", "Font_Old_10_White_Hi.TGA", 0, 255, 255, 1000 * 10)
						SetPlayerColor(playerid, 255, 255, 255)
					else
						SendPlayerMessage(playerid, 255, 0, 0, "B³êdne has³o! Podaj te, podane podczas rejestracji.")
						SendPlayerMessage(playerid, 255, 0, 0, "Je¿eli nie pamiêtasz has³a, powiadom administratora serwera.")
					end
			else
				SendPlayerMessage(playerid, 255, 0, 0, "Nie masz konta na serwerze wpisz /zarejestruj has³o")
			end
		else
			SendPlayerMessage(playerid, 255, 0, 0, "Jesteœ ju¿ zalogowany!")
		end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "B³êdna sk³adnia komendy wpisz /zaloguj has³o");
	end
end

function CMD_GMSG(playerid, cmd, params) --Wiadomoœæ do gildii
	local result, message = sscanf(params, "s")
	if result == 1 then --205, 133, 63
		if Player[playerid].guild == -1 then
			SendPlayerMessage(playerid, 255, 0, 0, "Nie nale¿ysz do ¿adnej oficjalnej gildii.")
		else
			for i = 0, GetMaxPlayers()-1 do
				if IsPlayerConnected(i) == 1 then
					if Player[playerid].guild == Player[i].guild then
						SendPlayerMessage(i, 205, 133, 63, string.format(">%s %d|%s: %s", "|GILDIA|", playerid, GetPlayerName(playerid), message))
					end
				end
			end
		end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "U¿yj /gmsg wiadomoœæ")
	end
end

function CMD_PM(playerid, cmd, params)
	local result, id, msg = sscanf(params, "ds")
		if result == 1 then
			if type(id) == "string" then
				id = GetPlayerIdByName(id)
			end
				if IsPlayerConnected(id) == 1 and playerid ~= id then

						SendPlayerMessage(id, 255, 154, 0, "(PM) "..GetPlayerName(playerid).."|"..playerid.." >> "..msg)
						SendPlayerMessage(playerid, 255, 68, 0, "(PM) "..GetPlayerName(id).."|"..id.." << "..msg)
						
							for i = 0, GetMaxPlayers() - 1 do -- Info do adma
								if IsPlayerAdmin(i) == 1 and i ~= playerid and i ~= id and Player[i].seepm == true then
									SendPlayerMessage(i, 0, 255, 94, "Podgl¹d (PM)| od "..GetPlayerName(playerid).."|"..playerid.." do "..GetPlayerName(id).."|"..id..": "..msg)
								end
							end
				else
					SendPlayerMessage(playerid, 255, 0, 0, "Ten gracz nie jest po³¹czony, lub piszesz do siebie.")
				end
		else
			SendPlayerMessage(playerid, 255, 0, 0, "U¿yj: /pm id wiadomosc")
		end
end

function CMD_VIS(playerid, cmd, params)
	local bodyModel = { "Hum_Body_Naked0", "Hum_Body_Babe0"}
	local headModel = { "Hum_Head_FatBald", "Hum_Head_Fighter", "Hum_Head_Pony", "Hum_Head_Bald", "Hum_Head_Thief", "Hum_Head_Psionic", "Hum_Head_Babe" }
		local result, body, bodytex, head, headtex = sscanf(params, "dddd")
			if result == 1 then
				SetPlayerAdditionalVisual(playerid, bodyModel[body], bodytex, headModel[head], headtex)
				SendPlayerMessage(playerid, 0, 255, 0, "Wygl¹d zmieniony!")
			else
				SendPlayerMessage(playerid, 255, 0, 0, "U¿yj /wyglad modelCia³a(1-2), teksturaCia³a(0-12), modelG³owy(1-7), teksturaG³owy(0-162)")
			end
end

function CMD_Help(playerid, cmd, params)
	local result, page = sscanf(params, "d")
	
	if page == 1 then
		SendPlayerMessage(playerid, 255, 255, 0, "Komendy serwera CruzerRP")
		SendPlayerMessage(playerid, 255, 255, 0, "Zapoznaj siê z nowym czatem rp opartym na prefix'ach:")
		SendPlayerMessage(playerid, 255, 255, 0, "@ - Wiadomoœæ zostanie wyœwietlona jako ooc ")
		SendPlayerMessage(playerid, 255, 255, 0, ". - Wiadomoœæ zostanie wyœwietlona jako do ")
		SendPlayerMessage(playerid, 255, 255, 0, "! - Wiadomoœæ zostanie wyœwietlona jako krzyk ")
		SendPlayerMessage(playerid, 255, 255, 0, "# - Wiadomoœæ zostanie wyœwietlona jako me(ja) ")
		SendPlayerMessage(playerid, 255, 255, 0, "Dalsza pomoc: /pomoc 2 ")
	elseif page == 2 then
		SendPlayerMessage(playerid, 255, 255, 0, "Komendy serwera CruzerRP")
		SendPlayerMessage(playerid, 255, 255, 0, "/pm id/nick_gracza - Prywatna wiadomoœæ")
		SendPlayerMessage(playerid, 255, 255, 0, "/adm wiadomoœæ - Wiadomoœæ do administratora (ujrz¹ j¹ wszyscy administratorzy online)")
		SendPlayerMessage(playerid, 255, 255, 0, "/wyglad modelCia³a(1-2) teksturaCia³a(0-12) modelG³owy(1-7) teksturaG³owy(0-162) - Zmiana wygl¹du")
		SendPlayerMessage(playerid, 255, 255, 0, "/gmsg wiadomoœæ - Wiadomoœæ do gildii")
		SendPlayerMessage(playerid, 255, 255, 0, "/zmienhaslo stareHas³o noweHas³o - zmiana has³a")
		SendPlayerMessage(playerid, 255, 255, 0, "/m.pomoc - Komendy moderatora")
		SendPlayerMessage(playerid, 255, 255, 0, "/anihelp - Lista animacji")
	else
		SendPlayerMessage(playerid, 255, 255, 0, "Komendy serwera CruzerRP")
		SendPlayerMessage(playerid, 255, 255, 0, "Zapoznaj siê z nowym czatem rp opartym na prefix'ach:")
		SendPlayerMessage(playerid, 255, 255, 0, "@ - Wiadomoœæ zostanie wyœwietlona jako ooc ")
		SendPlayerMessage(playerid, 255, 255, 0, ". - Wiadomoœæ zostanie wyœwietlona jako do ")
		SendPlayerMessage(playerid, 255, 255, 0, "! - Wiadomoœæ zostanie wyœwietlona jako krzyk ")
		SendPlayerMessage(playerid, 255, 255, 0, "# - Wiadomoœæ zostanie wyœwietlona jako me(ja) ")
		SendPlayerMessage(playerid, 255, 255, 0, "Dalsza pomoc: /pomoc 2 ")
	end
end

function CMD_MHelp(playerid, cmd, params)
	local result, page = sscanf(params, "d")
	
	if IsPlayerAdmin(playerid) == 1 or Player[playerid].moderator == 1 then
		if page == 1 then
			SendPlayerMessage(playerid, 255, 255, 0, "Komendy moderatora na serwerzer CruzerRP")
			SendPlayerMessage(playerid, 255, 255, 0, "/awans idgracza idklasy - Zmiana klasy")
			SendPlayerMessage(playerid, 255, 255, 0, "/post wiadomoœæ - Wiadomoœæ globalna")
			SendPlayerMessage(playerid, 255, 255, 0, "/m.kick idgracza powód - Wyrzucenie danego gracza z serwera")
			SendPlayerMessage(playerid, 255, 255, 0, "/m.all - Wyœwietla moderatorów oraz administratorów online")
		else
			SendPlayerMessage(playerid, 255, 255, 0, "Komendy moderatora na serwerzer CruzerRP")
			SendPlayerMessage(playerid, 255, 255, 0, "/awans idgracza idklasy - Zmiana klasy")
			SendPlayerMessage(playerid, 255, 255, 0, "/post wiadomoœæ - Wiadomoœæ globalna")
			SendPlayerMessage(playerid, 255, 255, 0, "/m.kick idgracza powód - Wyrzucenie danego gracza z serwera")
			SendPlayerMessage(playerid, 255, 255, 0, "/m.all - Wyœwietla moderatorów oraz administratorów online")
		end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "Nie masz uprawnieñ do u¿ycia tej komendy")
	end
end

function CMD_MKick(playerid, cmd, params)
	if IsPlayerAdmin(playerid) == 1 or Player[playerid].moderator == 1 then
		local result, id, reason = sscanf(params, "ds")
			if result == 1 then
				SendMessageToAll(255, 0, 0, "Gracz "..GetPlayerName(id).." zosta³ wyrzucony z serwera przez moderatora "..GetPlayerName(playerid).." powód: "..reason)
				Kick(id)
			else
				SendPlayerMessage(playerid, 255, 0, 0, "U¿yj /m.kick idgracza powód")
			end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "Nie masz uprawnieñ do u¿ycia tej komendy")
	end
end

function IsPlayerLeader(playerid)
	for k, v in pairs(Leaders) do
		if v == Player[playerid].class then
			return 1
		end
	end
	return 0
end

function CMD_MAll(playerid, cmd, params)
	if IsPlayerAdmin(playerid) == 1 or IsPlayerLeader(playerid) == 1 or Player[playerid].moderator == 1 then
		SendPlayerMessage(playerid, 255, 255, 0, "Osoby z uprawnienami przebywaj¹ce obecnie na serwerze:")
		for i = 0, GetMaxPlayers() -1 do
			if IsPlayerConnected(i) == 1 then
				if IsPlayerAdmin(i) == 1 then
					SendPlayerMessage(playerid, 255, 0, 0, string.format("%d|%s %s", i, GetPlayerName(i), "(Administrator)"))
				elseif Player[i].moderator == 1 then
					SendPlayerMessage(playerid, 0, 0, 255, string.format("%d|%s %s", i, GetPlayerName(i), "(Moderator)"))
				elseif IsPlayerLeader(i) == 1 then
					SendPlayerMessage(playerid, 0, 255, 0, string.format("%d|%s %s", i, GetPlayerName(i), "(Lider)"))
				end
			end
		end
	end
end

function CMD_Post(playerid, cmd, params) --Global
	if IsPlayerAdmin(playerid) == 1 or Player[playerid].moderator == 1 or IsPlayerLeader(playerid) == 1 then
		local result, message = sscanf(params, "s")
		if result == 1 then
			SendMessageToAll(0, 200, 225, string.format("%s %d|%s: %s", "(GLOBAL)", playerid, GetPlayerName(playerid), message))
		else
			SendPlayerMessage(playerid, 255, 0, 0, "U¿yj /post wiadomoœæ")
		end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "Nie masz uprawnieñ do tej komendy");
	end
end

function CMD_ChangeClass(playerid, cmd, params) --Awans
	local result, id, class = sscanf(params, "dd")
	if result == 1 then
		if IsPlayerAdmin(playerid) == 1 then
			for i, v in ipairs(Classes) do
				if v.classid == class then
					SendPlayerMessage(id, 0, 255, 0, "Twoja klasa zosta³a zamieniona na: "..v.name)
					SendPlayerMessage(playerid, 0, 255, 0, "Klasa gracza "..GetPlayerName(id).." zosta³a zamieniona na:"..v.name)
					ClearInventory(id)
					v.func(id)
				end
			end
		else
			if Player[playerid].moderator == 1 or IsPlayerLeader(playerid) == 1 then
				for i, v in ipairs(Classes) do
					if v.classid == class then
						SendPlayerMessage(id, 0, 255, 0, "Twoja klasa zosta³a zamieniona na: "..v.name)
						SendPlayerMessage(playerid, 0, 255, 0, "Klasa gracza "..GetPlayerName(id).." zosta³a zamieniona na:"..v.name)
						ClearInventory(id)
						v.func(id)
					end
				end
			else
				SendPlayerMessage(playerid, 255, 0, 0, "Nie jesteœ administratorem, ani dowódc¹!")
			end
		end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "U¿yj /awans idgracza idklasy")
	end
end

function CMD_Adm(playerid, cmd, params)
	local result, msg = sscanf(params, "s")
	if result == 1 then
		for i = 0, GetMaxPlayers() -1 do
			if playerid ~= i then
				if IsPlayerAdmin(i) == 1 or Player[i].moderator == 1 then
					SendPlayerMessage(i, 0, 255, 255, "Wiadomoœæ dla administratora:");
					SendPlayerMessage(i, 0, 255, 255, "(Adm)"..playerid.."|"..GetPlayerName(playerid)..":"..msg);
				end
			end
		end
		SendPlayerMessage(playerid, 0, 255, 0, "Wiadomoœæ zosta³a wys³ana.");
	end
end

function CMD_NPASS(playerid, cmd, params)
	local result, oldPass, newPass = sscanf(params, "ss")
	if result == 1 then
		if Player[playerid].logged == true then
			if oldPass == Player[playerid].password then
				Player[playerid].password = newPass
				SendPlayerMessage(playerid, 0, 255, 0, "Has³o zosta³o zmienione")
				SaveAccount(playerid)
			else
				SendPlayerMessage(playerid, 255, 0, 0, "Stare has³o nie pasuje do u¿ywanego obecnie")
			end
		else
			SendPlayerMessage(playerid, 255, 0, 0, "Musisz byæ zalogowany ¿eby zmieniæ has³o")
		end
	else
		SendPlayerMessage(playerid, 255, 0, 0, "U¿yj /zmienhaslo stareHas³o noweHas³o")
	end
end

function CMD_GIBMOD(playerid, cmd, params)
	if IsPlayerAdmin(playerid) == 1 then
		local result, id = sscanf(params, "d")
		if result == 1 then
			if Player[id].moderator == 0 then
				SendPlayerMessage(playerid, 0, 255, 0, "Nada³eœ uprawnienia moderatora graczowi "..GetPlayerName(id).."|"..id)
				SendPlayerMessage(id, 0, 255, 0, "Administrator "..GetPlayerName(playerid).."|"..playerid.." nada³ Ci uprawnienia moderatora")
				Player[id].moderator = 1
			else
				SendPlayerMessage(playerid, 255, 0, 0, "Zabra³eœ uprawnienia moderatora graczowi "..GetPlayerName(id).."|"..id)
				SendPlayerMessage(id, 0, 255, 0, "Administrator "..GetPlayerName(playerid).."|"..playerid.." odebra³ Ci uprawnienia moderatora")
				Player[id].moderator = 0
			end
		end
		else 
			SendPlayerMEssage(playerid, 255, 0, 0, "U¿yj /mod idgracza")
	end
end

function CMD_KALL(playerid, cmd, params) --Kick All
	local result, message = sscanf(params, "s")
	if IsPlayerAdmin(playerid) == 1 then
		SendMessageToAll(255, 0, 0, message)
		for i = 0, GetMaxPlayers() -1 do
			if IsPlayerConnected(i) == 1 then
				Kick(i)
			end
		end
	end
end

function CMD_SEEPM(playerid, cmd, params) --Podgl¹d pm
	if IsPlayerAdmin(playerid) == 1 then
		if Player[playerid].seepm == true then
			Player[playerid].seepm = false
			SendPlayerMessage(playerid, 255, 0, 0, "Podgl¹d prywatnych wiadomoœci wy³¹czony")
		else
			Player[playerid].seepm = true
			SendPlayerMessage(playerid, 0, 255, 0, "Podgl¹d prywatnych wiadomoœci w³¹czony")
		end
	end
end

function CMD_GETPOS(playerid, cmd, params)
	local x, y, z = GetPlayerPos(playerid)
	
	SendPlayerMessage(playerid, 255,255,0, "X:"..x.." Y:"..y.." Z:"..z)
end

local color_id = 0
function Timer_All() --Zapis, zmiana koloru drejwu itp
	for i = 0, GetMaxPlayers() -1 do
		if IsPlayerConnected(i) == 1 then
			if Player[i].logged == true then
				SaveAccount(i)
			end
		end
	end
	
	local colors = {{name = "green", r = 0, g = 255, b = 0}, {name = "default", r = 255, g = 143, b = 0}, {name = "DodgerBlue1", r = 30, g = 144, b = 255}, {name = "MediumSlateBlue", r = 123, g = 104, b = 238}, {name = "brown1", r = 255, g = 64, b = 64}, {name = "chocolate1", r = 255, g = 127, b = 36} }
	if color_id == #colors then
		color_id = 1
	else
		color_id = color_id + 1
	end
	
	UpdateDraw(GetDraw("server_name"), 5200, 7500, "Cruzer RolePlay", "Font_Old_20_White_Hi.TGA", colors[color_id].r, colors[color_id].g, colors[color_id].b)
end

function RegisterCommand(cmdname, funct)
	table.insert(Cmds, {cmd = cmdname, func = funct})
end

function RegisterClass(id, funct, cname)
	table.insert(Classes, {classid = id, func = funct, name = cname})
end

function GetChatMessageType(message)
	if message then
		local firstChar = message:sub(1, 1)
			if firstChar == "!" then
				return "SCREAM"
			elseif firstChar == "." then
				return "TO"
			elseif firstChar == "@" then	-- OOC
				return "OOC"
			elseif firstChar == "#" then
				return "ME"
			else return "RP"
			end
	end
end

--Rejestracja komend
RegisterCommand("/zarejestruj", CMD_Register)
RegisterCommand("/zaloguj", CMD_LogIn)
RegisterCommand("/pm", CMD_PM)
RegisterCommand("/pw", CMD_PM)
RegisterCommand("/adm", CMD_Adm)
RegisterCommand("/pomoc", CMD_Help)
RegisterCommand("/awans", CMD_ChangeClass)
RegisterCommand("/wyglad", CMD_VIS)
RegisterCommand("/post", CMD_Post)
RegisterCommand("/gmsg", CMD_GMSG)
RegisterCommand("/kall", CMD_KALL)
RegisterCommand("/zmienhaslo", CMD_NPASS)
RegisterCommand("/podgladpm", CMD_SEEPM)
RegisterCommand("/m.pomoc", CMD_MHelp)
RegisterCommand("/m.kick", CMD_MKick)
RegisterCommand("/m.all", CMD_MAll)
RegisterCommand("/mod", CMD_GIBMOD)
--Tworzenienie drawów
AddDraw(CreateDraw(5200, 7500, "Cruzer RolePlay", "Font_Old_20_White_Hi.TGA", 255, 143, 0), "server_name")
AddDraw(CreateDraw(6000, 0, "http://cruzer-rp.y0.pl", "Font_Old_10_White_Hi.TGA", 142, 35, 35), "website")

function SaveAccount(playerid)
		local x, y, z = GetPlayerPos(playerid)
        local angle = GetPlayerAngle(playerid)
        local HP = GetPlayerHealth(playerid)
        local MaxHP = GetPlayerMaxHealth(playerid)
        local Mana = GetPlayerMana(playerid)
        local MaxMana = GetPlayerMaxMana(playerid)
        local MagLvl = GetPlayerMagicLevel(playerid)
        local Str = GetPlayerStrength(playerid)
        local Dex = GetPlayerDexterity(playerid);
        local OneH = GetPlayerSkillWeapon(playerid, SKILL_1H)
        local TwoH = GetPlayerSkillWeapon(playerid, SKILL_2H)
        local Bow = GetPlayerSkillWeapon(playerid, SKILL_BOW)
        local CBow = GetPlayerSkillWeapon(playerid, SKILL_CBOW)
		local bodyModel, bodyTexture, headModel, headTexture = GetPlayerAdditionalVisual(playerid)
		
		local fWrite = io.open(GetPlayerName(playerid)..".acnt", "w+")
		
		fWrite:write(string.format("%s\n", Player[playerid].password))
		fWrite:write(string.format("%d\n", Player[playerid].class))
		fWrite:write(string.format("%d\n", Player[playerid].moderator))
		fWrite:write(string.format("%d\n", Player[playerid].guild))
		fWrite:write(x, " ", y, " ", z, " ", " ", angle, "\n")
		fWrite:write(HP, " ", MaxHP, " ", Mana, " ", MaxMana, "\n")
		fWrite:write(MagLvl, " ", Str, " ", Dex, "\n")
		fWrite:write(OneH, " ", TwoH, " ", Bow, " ", CBow, "\n")
		fWrite:write(bodyModel," ", bodyTexture, " ", headModel, " ", headTexture, "\n")
		
		fWrite:close()
		
end

function LoadAccount(playerid)
	local fRead = io.open(GetPlayerName(playerid)..".acnt", "r+")
	if fRead then
		tmp = fRead:read("*l") --passy
		tmp = fRead:read("*l")
		local result, class = sscanf(tmp, "d")
		if result == 1 then
			Player[playerid].class = class 
			ClearInventory(playerid)
			for i, v in ipairs(Classes) do
				if v.classid == class then
					ClearInventory(playerid)
					v.func(playerid)
				end
			end
		end
		tmp = fRead:read("*l")
		local result, moderator = sscanf(tmp, "d")
		if result == 1 then
			Player[playerid].moderator = moderator --Ustawienie moderatora
		end
		tmp = fRead:read("*l")
		local result, guild = sscanf(tmp, "d")
		if result == 1 then
			Player[playerid].guild = guild --Ustawienie gildii
		end
		tmp = fRead:read("*l")
		local result, x, y, z, angle = sscanf(tmp, "dddd")
		if result == 1 then
			SetPlayerPos(playerid, x, y, z)
			SetPlayerAngle(playerid, angle)
		end
		tmp = fRead:read("*l")
		local result, HP, MaxHP, Mana, MaxMana = sscanf(tmp, "dddd")
		if result == 1 then
			SetPlayerMaxHealth(playerid, MaxHP)
			SetPlayerHealth(playerid, HP)
			SetPlayerMaxMana(playerid, MaxMana)
			SetPlayerMana(playerid, Mana)
		end
		tmp = fRead:read("*l")
		local result, MagLvl, Str, Dex = sscanf(tmp, "ddd")
		if result == 1 then
			SetPlayerMagicLevel(playerid, MagLvl)
			SetPlayerStrength(playerid, Str)
			SetPlayerDexterity(playerid, Dex)
		end
		tmp = fRead:read("*l")
		local result, OneH, TwoH, Bow, CBow = sscanf(tmp, "dddd")
		if result == 1 then
			SetPlayerSkillWeapon(playerid, SKILL_1H, OneH)
			SetPlayerSkillWeapon(playerid, SKILL_2H, TwoH)
			SetPlayerSkillWeapon(playerid, SKILL_BOW, Bow)
			SetPlayerSkillWeapon(playerid, SKILL_CBOW, CBow)
		end
		tmp = fRead:read("*l")
		local result, bodyModel, bodyTexture, headModel, headTexture = sscanf(tmp, "sdsd")
		if result == 1 then
			SetPlayerAdditionalVisual(playerid, bodyModel, bodyTexture, headModel, headTexture)
		end
		fRead:close()
	end
end

function Class_NewPlayer(playerid) --Przybysz?
	Player[playerid].class = 0
	Player[playerid].guild = -1
	SetPlayerMaxHealth(playerid, 100)
	SetPlayerHealth(playerid, 100)
	SetPlayerStrength(playerid, 0)
	SetPlayerDexterity(playerid, 0)
	EquipArmor(playerid, "ITAR_Leather_L")
	GiveItem(playerid, "ItFo_Meat", 10)
	GiveItem(playerid, "ItFo_Water", 20)
	GiveItem(playerid, "ItMi_Joint", 3)
end

function Class_CityGuard(playerid) --Stra¿nik miejski (podstawowy)
	Player[playerid].class = 1
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 300)
	SetPlayerHealth(playerid, 300)
	SetPlayerStrength(playerid, 60)
	SetPlayerDexterity(playerid, 60)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 30)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 30)
	EquipMeleeWeapon(playerid, "ItMw_1h_Mil_Sword")
	EquipArmor(playerid, "ITAR_MIL_L")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItKe_Key_01", 1)
	GiveItem(playerid, "ItKe_Key_02", 1)
	GiveItem(playerid, "ItKe_Key_03", 1)
	GiveItem(playerid, "ItLsTorch", 3)
	GiveItem(playerid, "ItFo_Wine", 10)
	SetPlayerWalk(playerid, "HumanS_Militia.mds")
end

function Class_CityGuard2(playerid) --Stra¿nik miejski (zaawansowany)
	Player[playerid].class = 2
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 500)
	SetPlayerHealth(playerid, 500)
	SetPlayerStrength(playerid, 120)
	SetPlayerDexterity(playerid, 120)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 60)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 60)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 60)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 60)
	EquipMeleeWeapon(playerid, "ItMw_1h_Mil_Sword")
	EquipRangedWeapon(playerid, "ItRw_Crossbow_L_01")
	EquipArmor(playerid, "ITAR_MIL_M")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItKe_Key_01", 1)
	GiveItem(playerid, "ItKe_Key_02", 1)
	GiveItem(playerid, "ItKe_Key_03", 1)
	GiveItem(playerid, "ItLsTorch", 3)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Bolt", 25)
	SetPlayerWalk(playerid, "HumanS_Militia.mds")
end

function Class_Ritter(playerid) --Rycerz
	Player[playerid].class = 3
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 1000)
	SetPlayerHealth(playerid, 1000)
	SetPlayerMaxMana(playerid, 250)
	SetPlayerMana(playerid, 250)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 150)
	SetPlayerDexterity(playerid, 150)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 80)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 80)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 75)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 75)
	EquipMeleeWeapon(playerid, "ItMw_1h_Pal_Sword")
	EquipArmor(playerid, "ITAR_PAL_M")
	GiveItem(playerid, "ITAR_MIL_M", 1)
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItKe_Key_01", 1)
	GiveItem(playerid, "ItKe_Key_02", 1)
	GiveItem(playerid, "ItKe_Key_03", 1)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Bolt", 25)
	GiveItem(playerid, "ItSc_PalLight", 3)
	GiveItem(playerid, "ItSc_FullHeal", 3)
	SetPlayerWalk(playerid, "HumanS_Militia.mds")
end

function Class_Pal(playerid) --Paladyn
	Player[playerid].class = 4
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 1200)
	SetPlayerHealth(playerid, 1200)
	SetPlayerMaxMana(playerid, 500)
	SetPlayerMana(playerid, 500)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 200)
	SetPlayerDexterity(playerid, 200)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
	EquipMeleeWeapon(playerid, "ItMw_1h_Pal_Sword")
	EquipArmor(playerid, "ITAR_PAL_H")
	GiveItem(playerid, "ITAR_MIL_L", 1)
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItKe_Key_01", 1)
	GiveItem(playerid, "ItKe_Key_02", 1)
	GiveItem(playerid, "ItKe_Key_03", 1)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Bolt", 25)
	GiveItem(playerid, "ItSc_PalLight", 3)
	GiveItem(playerid, "ItSc_PalLightHeal", 3)
	GiveItem(playerid, "ItSc_PalHolyBolt", 3)
	GiveItem(playerid, "ItRu_PalFullHeal", 1)
	GiveItem(playerid, "ItSc_Firebolt", 30)
	SetPlayerWalk(playerid, "HumanS_Militia.mds")
end

function Class_Novice(playerid) --Nowicjusz
	Player[playerid].class = 5
	Player[playerid].guild = 1
	SetPlayerMaxHealth(playerid, 300)
	SetPlayerHealth(playerid, 300)
	SetPlayerStrength(playerid, 50)
	SetPlayerDexterity(playerid, 50)
	SetPlayerMaxMana(playerid, 100)
	SetPlayerMana(playerid, 100)
	SetPlayerMagicLevel(playerid, 6)
	EquipArmor(playerid, "ITAR_NOV_L")
	EquipMeleeWeapon(playerid, "ItMw_1h_Nov_Mace")
	GiveItem(playerid, "ItRu_Light", 1)
	GiveItem(playerid, "ItSc_Firebolt", 30)
	GiveItem(playerid, "ItSc_FullHeal", 3)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_FireMage(playerid) --Mag Ognia (podstawowy)
	Player[playerid].class = 6
	Player[playerid].guild = 1
	SetPlayerMaxHealth(playerid, 1000)
	SetPlayerHealth(playerid, 1000)
	SetPlayerMaxMana(playerid, 600)
	SetPlayerMana(playerid, 600)
	SetPlayerMagicLevel(playerid, 6)
	EquipArmor(playerid, "ITAR_KDF_L")
	GiveItem(playerid, "ItRu_Light", 1)
	GiveItem(playerid, "ItRu_Firebolt", 1)
	GiveItem(playerid, "ItRu_Icebolt", 1)
	GiveItem(playerid, "ItRu_Windfist", 1)
	GiveItem(playerid, "ItRu_Sleep", 1)
	GiveItem(playerid, "ItAr_Dementor", 1)
	GiveItem(playerid, "ItPo_Mana_03", 20)
	GiveItem(playerid, "ItPo_Speed", 3)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_FireMage2(playerid) --Mag Ognia (zaawansowany)
	Player[playerid].class = 7
	Player[playerid].guild = 1
	SetPlayerMaxHealth(playerid, 1300)
	SetPlayerHealth(playerid, 1300)
	SetPlayerMaxMana(playerid, 1000)
	SetPlayerMana(playerid, 1000)
	SetPlayerMagicLevel(playerid, 6)
	EquipArmor(playerid, "ITAR_KDF_H")
	GiveItem(playerid, "ItRu_Light", 1)
	GiveItem(playerid, "ItRu_Firebolt", 1)
	GiveItem(playerid, "ItRu_Icebolt", 1)
	GiveItem(playerid, "ItRu_Windfist", 1)
	GiveItem(playerid, "ItRu_Sleep", 1)
	GiveItem(playerid, "ItRu_Firerain", 1)
	GiveItem(playerid, "ItAr_Dementor", 1)
	GiveItem(playerid, "ItPo_Mana_03", 20)
	GiveItem(playerid, "ItRu_InstantFireball", 1)
	GiveItem(playerid, "ItPo_Speed", 3)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_NewSLD(playerid) -- Nowy najemnik?
	Player[playerid].class = 8
	Player[playerid].guild = 2
	SetPlayerMaxHealth(playerid, 300)
	SetPlayerHealth(playerid, 300)
	SetPlayerStrength(playerid, 60)
	SetPlayerDexterity(playerid, 60)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 30)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 30)
	EquipMeleeWeapon(playerid, "ItMw_1H_Sword_L_03")
	EquipArmor(playerid, "ITAR_SLD_L")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Cheese", 2)
	GiveItem(playerid, "ItLsTorch", 5)
	GiveItem(playerid, "ItFo_Wine", 10)
	SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_MedSLD(playerid) --Œrodkowy najemnik xD
	Player[playerid].class = 9
	Player[playerid].guild = 2
	SetPlayerMaxHealth(playerid, 500)
	SetPlayerHealth(playerid, 500)
	SetPlayerStrength(playerid, 120)
	SetPlayerDexterity(playerid, 120)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 60)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 60)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 60)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 60)
	EquipMeleeWeapon(playerid, "ItMw_1h_Sld_Sword")
	EquipRangedWeapon(playerid, "ItRw_Crossbow_L_01")
	EquipArmor(playerid, "ITAR_SLD_M")
	GiveItem(playerid, "ItMi_Joint", 12)
	GiveItem(playerid, "ItFo_Apple", 4)
	GiveItem(playerid, "ItLsTorch", 3)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Bolt", 25)
	SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_SLD(playerid) --Doœwiadczony najemnik (taki koks i wgle)
	Player[playerid].class = 10
	Player[playerid].guild = 2
	SetPlayerMaxHealth(playerid, 1200)
	SetPlayerHealth(playerid, 1200)
	SetPlayerMaxMana(playerid, 500)
	SetPlayerMana(playerid, 500)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
	SetPlayerStrength(playerid, 200)
	SetPlayerDexterity(playerid, 200)
	EquipMeleeWeapon(playerid, "ItMw_ShortSword4")
	EquipArmor(playerid, "ITAR_SLD_H")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Lute", 1)
	GiveItem(playerid, "ItMi_Sextant", 1)
	GiveItem(playerid, "ItRu_PalLight", 1)
	SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_Lord(playerid) --Lord khorinis
	Player[playerid].class = 11
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 1600)
	SetPlayerHealth(playerid, 1600)
	SetPlayerMaxMana(playerid, 500)
	SetPlayerMana(playerid, 500)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 200)
	SetPlayerDexterity(playerid, 200)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
	EquipMeleeWeapon(playerid, "ItMw_Schwert5")
	EquipArmor(playerid, "ITAR_Governor")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Lute", 1)
	GiveItem(playerid, "ItMi_Sextant", 1)
	GiveItem(playerid, "ItRu_PalLight", 1)
	GiveItem(playerid, "ItRu_InstantFireBall", 1)
	SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_Farm(playerid) --Wieœniak
	Player[playerid].class = 12
	Player[playerid].guild = 2
	SetPlayerMaxHealth(playerid, 1600)
	SetPlayerHealth(playerid, 1600)
	SetPlayerMaxMana(playerid, 500)
	SetPlayerMana(playerid, 500)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
	SetPlayerStrength(playerid, 200)
	SetPlayerDexterity(playerid, 200)
	EquipMeleeWeapon(playerid, "ItMw_Schwert5")
	EquipArmor(playerid, "ITAR_DJG_L")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Lute", 1)
	GiveItem(playerid, "ItMi_Sextant", 1)
	GiveItem(playerid, "ItRu_PalLight", 1)
	GiveItem(playerid, "ItRu_InstantFireBall", 1)
	SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_Gov(playerid) --Urzêdnik
	Player[playerid].class = 13
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 1600)
	SetPlayerHealth(playerid, 1600)
	SetPlayerMaxMana(playerid, 0)
	SetPlayerMana(playerid, 0)
	SetPlayerMagicLevel(playerid, 0)
	SetPlayerStrength(playerid, 100)
	SetPlayerDexterity(playerid, 100)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 25)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 25)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ItMw_1h_Vlk_Dagger")
	EquipArmor(playerid, "ITAR_Governor")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ITAR_VLK_L", 1)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Lute", 1)
	GiveItem(playerid, "ItMi_Sextant", 1)
	SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_Vlk(playerid) --Obywatel
	Player[playerid].class = 14
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 200)
	SetPlayerHealth(playerid, 200)
	SetPlayerMaxMana(playerid, 0)
	SetPlayerMana(playerid, 0)
	SetPlayerMagicLevel(playerid, 0)
	SetPlayerStrength(playerid, 10)
	SetPlayerDexterity(playerid, 10)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 20)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 20)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ItMw_1h_Vlk_Dagger")
	EquipArmor(playerid, "ITAR_VLK_L")
	GiveItem(playerid, "ITAR_VLKBABE_H", 1)
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Lute", 1)
	GiveItem(playerid, "ItLsTorch", 1)
	GiveItem(playerid, "ItFo_Bacon", 12)
end

function Class_Smith(playerid) --Kowal
	Player[playerid].class = 15
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 500)
	SetPlayerHealth(playerid, 500)
	SetPlayerMaxMana(playerid, 0)
	SetPlayerMana(playerid, 0)
	SetPlayerMagicLevel(playerid, 0)
	SetPlayerStrength(playerid, 40)
	SetPlayerDexterity(playerid, 40)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ItMw_1h_Mace_L_04")
	EquipArmor(playerid, "ITAR_SMITH")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Lute", 1)
	GiveItem(playerid, "ItLsTorch", 1)
	GiveItem(playerid, "ItFo_Bacon", 12)
	GiveItem(playerid, "ItMiSwordraw", 100)
end

function Class_Chemistry(playerid) --Alchemik
	Player[playerid].class = 16
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 400)
	SetPlayerHealth(playerid, 400)
	SetPlayerMaxMana(playerid, 0)
	SetPlayerMana(playerid, 0)
	SetPlayerMagicLevel(playerid, 0)
	SetPlayerStrength(playerid, 40)
	SetPlayerDexterity(playerid, 40)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ItMw_1h_Bau_Axe")
	EquipArmor(playerid, "ITAR_SMITH")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Lute", 1)
	GiveItem(playerid, "ItLsTorch", 1)
	GiveItem(playerid, "ItFo_Bacon", 12)
	GiveItem(playerid, "ItPo_Speed", 5)
	GiveItem(playerid, "ItPl_SwampHerb", 3)
	GiveItem(playerid, "ItPl_Mana_Herb_02", 3)
	GiveItem(playerid, "ItPl_Health_Herb_03", 3)
	GiveItem(playerid, "ItPl_Dex_Herb_01", 3)
	GiveItem(playerid, "ItPl_Strength_Herb_01", 3)
	GiveItem(playerid, "ItPl_Speed_Herb_01", 3)
	GiveItem(playerid, "ItPl_Blueplant", 3)
	GiveItem(playerid, "ItMi_Flask", 5)
end

function Class_FarmWorker(playerid) --Farmer (przed najemnikami)
	Player[playerid].class = 17
	Player[playerid].guild = 2
	SetPlayerMaxHealth(playerid, 300)
	SetPlayerHealth(playerid, 300)
	SetPlayerMaxMana(playerid, 0)
	SetPlayerMana(playerid, 0)
	SetPlayerMagicLevel(playerid, 0)
	SetPlayerStrength(playerid, 20)
	SetPlayerDexterity(playerid, 20)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ItMw_1h_Mace_L_04")
	EquipArmor(playerid, "ITAR_BAU_M")
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Rake", 1)
	GiveItem(playerid, "ItMi_Scoop", 1)
	GiveItem(playerid, "ItMi_Broom", 1)
	GiveItem(playerid, "ItMi_Brush", 1)
	GiveItem(playerid, "ItFo_Bacon", 2)
end

function Class_Judge(playerid) --Sêdzia
	Player[playerid].class = 18
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 1600)
	SetPlayerHealth(playerid, 1600)
	SetPlayerMaxMana(playerid, 0)
	SetPlayerMana(playerid, 0)
	SetPlayerMagicLevel(playerid, 0)
	SetPlayerStrength(playerid, 100)
	SetPlayerDexterity(playerid, 100)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 25)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 25)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ItMw_1h_Vlk_Dagger")
	EquipArmor(playerid, "ITAR_Judge")
	GiveItem(playerid, "ITAR_Governor", 1)
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ITAR_VLK_L", 1)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItMi_Lute", 1)
	GiveItem(playerid, "ItMi_Sextant", 1)
	SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_BDTL(playerid) --S³aby bandyta
	Player[playerid].class = 19
	Player[playerid].guild = 3
	SetPlayerMaxHealth(playerid, 300)
	SetPlayerHealth(playerid, 300)
	SetPlayerStrength(playerid, 60)
	SetPlayerDexterity(playerid, 60)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 30)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 30)
	EquipMeleeWeapon(playerid, "ItMw_1h_Mil_Sword")
	EquipRangedWeapon(playerid, "ItRw_Bow_L_01")
	EquipArmor(playerid, "ITAR_BDT_M")
	GiveItem(playerid, "ItMi_Joint", 16)
	GiveItem(playerid, "ITAR_Leather_L", 1)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItLsTorch", 3)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Arrow", 100)
	SetPlayerWalk(playerid, "HumanS_Militia.mds")
end

function Class_BDTM(playerid) --Bandyta
	Player[playerid].class = 20
	Player[playerid].guild = 3
	SetPlayerMaxHealth(playerid, 500)
	SetPlayerHealth(playerid, 500)
	SetPlayerStrength(playerid, 120)
	SetPlayerDexterity(playerid, 120)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 60)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 60)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 60)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 60)
	EquipMeleeWeapon(playerid, "ItMw_1h_Mil_Sword")
	EquipRangedWeapon(playerid, "ItRw_Crossbow_L_01")
	EquipArmor(playerid, "ItAr_BDT_H")
	GiveItem(playerid, "ITAR_Leather_L", 1)
	GiveItem(playerid, "ItMi_Joint", 26)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItLsTorch", 3)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Bolt", 25)
	SetPlayerWalk(playerid, "HumanS_Militia.mds")
end

function Class_BDTH(playerid) --Bandyta (stra¿nik)
	Player[playerid].class = 21
	Player[playerid].guild = 3
	SetPlayerMaxHealth(playerid, 1000)
	SetPlayerHealth(playerid, 1000)
	SetPlayerMaxMana(playerid, 250)
	SetPlayerMana(playerid, 250)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 150)
	SetPlayerDexterity(playerid, 150)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 80)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 80)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 75)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 75)
	EquipMeleeWeapon(playerid, "ItMw_1h_Pal_Sword")
	EquipArmor(playerid, "ITAR_THORUS_ADDON")
	GiveItem(playerid, "ITAR_Leather_L", 1)
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Bolt", 25)
	SetPlayerWalk(playerid, "HumanS_Militia.mds")
end

function Class_MASTERBDT(playerid) --Herszt bandytów
	Player[playerid].class = 22
	Player[playerid].guild = 3
	SetPlayerMaxHealth(playerid, 1200)
	SetPlayerHealth(playerid, 1200)
	SetPlayerMaxMana(playerid, 500)
	SetPlayerMana(playerid, 500)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 200)
	SetPlayerDexterity(playerid, 200)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
	EquipMeleeWeapon(playerid, "ItMw_1h_Pal_Sword")
	EquipArmor(playerid, "ITAR_Raven_Addon")
	EquipRangedWeapon(playerid, "ITRW_CROSSBOW_H_02")
	GiveItem(playerid, "ITAR_VLK_L", 1)
	GiveItem(playerid, "ITAR_MIL_L", 1)
	GiveItem(playerid, "ItMi_Joint", 6)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Bolt", 25)
	GiveItem(playerid, "ItSc_PalLight", 3)
	GiveItem(playerid, "ItSc_PalLightHeal", 3)
	GiveItem(playerid, "ItSc_PalHolyBolt", 3)
	GiveItem(playerid, "ItRu_PalFullHeal", 1)
	GiveItem(playerid, "ItSc_Firebolt", 30)
	SetPlayerWalk(playerid, "HumanS_Militia.mds")
end

function Class_V0ID(playerid)
	Player[playerid].class = 23
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 1600)
	SetPlayerHealth(playerid, 1600)
	SetPlayerMaxMana(playerid, 1000)
	SetPlayerMana(playerid, 1000)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 400)
	SetPlayerDexterity(playerid, 400)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
	EquipMeleeWeapon(playerid, "ItMw_ElBastardo")
	EquipArmor(playerid, "ITAR_Governor")
	GiveItem(playerid, "ITAR_Bloodwyn_Addon", 1)
	GiveItem(playerid, "ITAR_Barkeeper", 1)
	GiveItem(playerid, "ITAR_KDF_H", 1)
	GiveItem(playerid, "ITMI_INNOSEYE_MIS", 1)
	GiveItem(playerid, "ITAR_RANGER_Addon", 1)
	GiveItem(playerid, "ItRu_Light", 1)
	GiveItem(playerid, "ItRu_Firebolt", 1)
	GiveItem(playerid, "ItRu_Icebolt", 1)
	GiveItem(playerid, "ItRu_Windfist", 1)
	GiveItem(playerid, "ItRu_Sleep", 1)
	GiveItem(playerid, "ItRu_Firerain", 1)
	GiveItem(playerid, "ItAr_Dementor", 1)
	GiveItem(playerid, "ItPo_Mana_03", 20)
	GiveItem(playerid, "ItRu_InstantFireball", 1)
	GiveItem(playerid, "ItPo_Speed", 3)
	SetPlayerWalk(playerid, "Humans_Relaxed.mds")
	SetPlayerColor(playerid, 255, 0, 0)
end

function Class_BOWM(playerid) --£uczarz
	Player[playerid].class = 24
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 300)
	SetPlayerHealth(playerid, 300)
	SetPlayerStrength(playerid, 60)
	SetPlayerDexterity(playerid, 60)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 30)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 30)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 30)
	EquipMeleeWeapon(playerid, "ItMw_1h_Mil_Sword")
	EquipRangedWeapon(playerid, "ItRw_Bow_L_01")
	EquipArmor(playerid, "ITAR_Leather_L")
	GiveItem(playerid, "ItMi_Joint", 16)
	GiveItem(playerid, "ITAR_Leather_L", 1)
	GiveItem(playerid, "ItFo_Apple", 2)
	GiveItem(playerid, "ItLsTorch", 3)
	GiveItem(playerid, "ItFo_Wine", 10)
	GiveItem(playerid, "ItRw_Arrow", 1000)
	GiveItem(playerid, "ITRW_BOLT", 1000)
	GiveItem(playerid, "ITRW_BOW_H_01", 1)
	GiveItem(playerid, "ITRW_BOW_H_02", 1)
	GiveItem(playerid, "ITRW_BOW_H_03", 1)
	GiveItem(playerid, "ITRW_BOW_L_01", 1)
	GiveItem(playerid, "ITRW_BOW_L_02", 1)
	GiveItem(playerid, "ITRW_BOW_L_03", 1)
	GiveItem(playerid, "ITRW_SLD_BOW", 1)
	GiveItem(playerid, "ITRW_CROSSBOW_H_01", 1)
	GiveItem(playerid, "ITRW_CROSSBOW_H_02", 1)
	GiveItem(playerid, "ITRW_MIL_CROSSBOW", 1)
	GiveItem(playerid, "ITRW_CROSSBOW_M_02", 1)
	SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_General(playerid)
	Player[playerid].class = 25
	Player[playerid].guild = 0
	SetPlayerMaxHealth(playerid, 1300)
	SetPlayerHealth(playerid, 1300)
	SetPlayerMaxMana(playerid, 1000)
	SetPlayerMana(playerid, 1000)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 200)
	SetPlayerDexterity(playerid, 200)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
	EquipMeleeWeapon(playerid, "ItMw_1H_Blessed_02")
	EquipArmor(playerid, "itar_orebaron_addon")
	GiveItem(playerid, "itar_pal_h", 1)
	GiveItem(playerid, "ITAR_Barkeeper", 1)
	GiveItem(playerid, "ItRu_Light", 1)
	GiveItem(playerid, "ItRu_Icebolt", 1)
	GiveItem(playerid, "ItRu_Windfist", 1)
	GiveItem(playerid, "ItAr_Dementor", 1)
	GiveItem(playerid, "ItPo_Mana_03", 20)
	GiveItem(playerid, "ItRu_InstantFireball", 1)
	GiveItem(playerid, "ItPo_Speed", 3)
	SetPlayerWalk(playerid, "Humans_Relaxed.mds")
end

function Class_BlackNewb(playerid) --Pacho³ek cienia
	Player[playerid].class = 26
	Player[playerid].guild = 4
	SetPlayerMaxHealth(playerid, 300)
	SetPlayerHealth(playerid, 300)
	SetPlayerMaxMana(playerid, 200)
	SetPlayerMana(playerid, 200)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 35)
	SetPlayerDexterity(playerid, 35)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 20)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 20)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ITMW_1H_SWORD_L_03")
	EquipArmor(playerid, "ITAR_LESTER")
	GiveItem(playerid, "itpo_perm_mana", 20)
	GiveItem(playerid, "ITRU_FIREBOLT", 1)
	GiveItem(playerid, "ITRU_ZAP", 1)
	GiveItem(playerid, "ITFO_FISH", 1)
	GiveItem(playerid, "ITFO_APPLE", 1)
	GiveItem(playerid, "ITFO_WATER", 1)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_BlackMemb(playerid) --Cz³onek bractwa
	Player[playerid].class = 27
	Player[playerid].guild = 4
	SetPlayerMaxHealth(playerid, 400)
	SetPlayerHealth(playerid, 400)
	SetPlayerMaxMana(playerid, 200)
	SetPlayerMana(playerid, 200)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 60)
	SetPlayerDexterity(playerid, 70)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 40)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 40)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ITMW_HELLEBARDE")
	EquipArmor(playerid, "itar_mayazombie_addon")
	GiveItem(playerid, "itpo_perm_mana", 20)
	GiveItem(playerid, "itpo_perm_health", 20)
	GiveItem(playerid, "ITRU_FIREBOLT", 1)
	GiveItem(playerid, "ITRU_ZAP", 1)
	GiveItem(playerid, "ITFO_FISH", 1)
	GiveItem(playerid, "ITFO_APPLE", 1)
	GiveItem(playerid, "ITFO_WATER", 1)
	GiveItem(playerid, "ITRU_WINDFIST", 1)
	GiveItem(playerid, "ITFO_SAUSAGE", 1)
	GiveItem(playerid, "ITFO_CHEESE", 1)
	GiveItem(playerid, "ITMI_JOINT", 3)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_BlackWarrior(playerid) --Wojownik mroku
	Player[playerid].class = 28
	Player[playerid].guild = 4
	SetPlayerMaxHealth(playerid, 700)
	SetPlayerHealth(playerid, 700)
	SetPlayerMaxMana(playerid, 800)
	SetPlayerMana(playerid, 800)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 100)
	SetPlayerDexterity(playerid, 80)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 60)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 60)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "ITMW_2H_ORCAXE_03")
	EquipArmor(playerid, "ITAR_CORANGAR")
	GiveItem(playerid, "itpo_perm_mana", 20)
	GiveItem(playerid, "itpo_perm_health", 20)
	GiveItem(playerid, "ITRU_FIREBOLT", 1)
	GiveItem(playerid, "ITRU_ZAP", 1)
	GiveItem(playerid, "ITFO_FISH", 1)
	GiveItem(playerid, "ITFO_APPLE", 1)
	GiveItem(playerid, "ITFO_WATER", 1)
	GiveItem(playerid, "ITRU_WINDFIST", 1)
	GiveItem(playerid, "ITFO_SAUSAGE", 1)
	GiveItem(playerid, "ITFO_CHEESE", 1)
	GiveItem(playerid, "ITMI_JOINT", 3)
	GiveItem(playerid, "ITRU_LIGHTHEAL", 1)
	GiveItem(playerid, "ITRU_FIRESTORM", 1)
	GiveItem(playerid, "ITRU_ICECUBE", 1)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_Nekrofil(playerid) --Nekromanta
	Player[playerid].class = 29
	Player[playerid].guild = 4
	SetPlayerMaxHealth(playerid, 1000)
	SetPlayerHealth(playerid, 1000)
	SetPlayerMaxMana(playerid, 1200)
	SetPlayerMana(playerid, 1200)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 80)
	SetPlayerDexterity(playerid, 80)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 0)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 0)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipArmor(playerid, "ITAR_XARDAS")
	GiveItem(playerid, "ITRU_TELEPORTXARDAS", 1)
	GiveItem(playerid, "itpo_perm_mana", 20)
	GiveItem(playerid, "itpo_perm_health", 20)
	GiveItem(playerid, "ITRU_PYROKINESIS", 1)
	GiveItem(playerid, "ITSC_PALHOLYBOLT", 1)
	GiveItem(playerid, "ITSC_PALREPELEVIL", 1)
	GiveItem(playerid, "ITFO_FISH", 1)
	GiveItem(playerid, "ITFO_APPLE", 1)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_Nigger(playerid) --Cieñ
	Player[playerid].class = 30
	Player[playerid].guild = 4
	SetPlayerMaxHealth(playerid, 1100)
	SetPlayerHealth(playerid, 1100)
	SetPlayerMaxMana(playerid, 1200)
	SetPlayerMana(playerid, 1200)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 120)
	SetPlayerDexterity(playerid, 80)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 80)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 80)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 0)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 0)
	EquipMeleeWeapon(playerid, "itmw_2h_blessed_03")
	EquipArmor(playerid, "ITAR_DEMENTOR")
	GiveItem(playerid, "ITRU_TELEPORTXARDAS", 1)
	GiveItem(playerid, "itpo_perm_mana", 20)
	GiveItem(playerid, "itpo_perm_health", 20)
	GiveItem(playerid, "ITRU_PYROKINESIS", 1)
	GiveItem(playerid, "ITSC_PALHOLYBOLT", 1)
	GiveItem(playerid, "ITSC_PALREPELEVIL", 1)
	GiveItem(playerid, "ITFO_FISH", 1)
	GiveItem(playerid, "ITFO_APPLE", 1)
	GiveItem(playerid, "ITRU_ICEWAVE", 1)
	GiveItem(playerid, "ITRU_SLEEP", 1)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_Pedofil(playerid) --Kap³an (dowódca)
	Player[playerid].class = 31
	Player[playerid].guild = 4
	SetPlayerMaxHealth(playerid, 1300)
	SetPlayerHealth(playerid, 1300)
	SetPlayerMaxMana(playerid, 2000)
	SetPlayerMana(playerid, 2000)
	SetPlayerMagicLevel(playerid, 6)
	SetPlayerStrength(playerid, 160)
	SetPlayerDexterity(playerid, 160)
	SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
	SetPlayerSkillWeapon(playerid, SKILL_BOW, 100)
	SetPlayerSkillWeapon(playerid, SKILL_CBOW, 100)
	EquipMeleeWeapon(playerid, "ITMW_2H_SPECIAL_02")
	EquipArmor(playerid, "ITAR_DJG_H")
	GiveItem(playerid, "ITRU_TELEPORTXARDAS", 1)
	GiveItem(playerid, "itpo_perm_mana", 20)
	GiveItem(playerid, "itpo_perm_health", 20)
	GiveItem(playerid, "ITRU_PYROKINESIS", 1)
	GiveItem(playerid, "ITSC_PALHOLYBOLT", 1)
	GiveItem(playerid, "ITSC_PALREPELEVIL", 1)
	GiveItem(playerid, "ITFO_FISH", 1)
	GiveItem(playerid, "ITFO_APPLE", 1)
	GiveItem(playerid, "ITRU_ICEWAVE", 1)
	GiveItem(playerid, "ITRU_FULLHEAL", 1)
	GiveItem(playerid, "ITRU_HARMUNDEAD", 1)
	GiveItem(playerid, "ITRU_FIRERAIN", 1)
	GiveItem(playerid, "ITFOMUTTONRAW", 1)
	GiveItem(playerid, "itpo_speed", 10)
	GiveItem(playerid, "ITAT_DRAGONBLOOD", 1)
	GiveItem(playerid, "ITAR_VLKBABE_M", 1)
	GiveItem(playerid, "ITAR_VLK_M", 1)
	GiveItem(playerid, "ITFO_BREAD", 1)
	GiveItem(playerid, "ITFO_MILK", 1)
	GiveItem(playerid, "ITMI_RUNEBLANK", 1)
	GiveItem(playerid, "ITMI_JOINT", 20)
	GiveItem(playerid, "ITFO_WINE", 1)
	GiveItem(playerid, "ITAT_DEMONHEART", 1)
	GiveItem(playerid, "ITAT_GOBLINBONE", 1)
	GiveItem(playerid, "ITRW_BOW_H_01", 1)
	GiveItem(playerid, "ITRW_ARROW", 100)
	SetPlayerWalk(playerid, "Humans_Mage.mds")
end

function Class_LordKossak(playerid) --Lord Kossak
Player[playerid].class = 32
Player[playerid].guild = 5
SetPlayerMaxHealth(playerid, 1500)
SetPlayerHealth(playerid, 1500)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 200)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
EquipMeleeWeapon(playerid, "ItMW_meisterdegen")
EquipArmor(playerid, "ITAR_pal_skel")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITAT_DRGSNAPPERHORN", 1)
GiveItem(playerid, "ITAR_Governor", 1)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end 

function Class_RekaKossak(playerid) --Prawa Reka Kossaka
Player[playerid].class = 33
Player[playerid].guild = 5
SetPlayerMaxHealth(playerid, 1000)
SetPlayerHealth(playerid, 1000)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 150)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 60)
SetPlayerSkillWeapon(playerid, SKILL_2H, 60)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 60)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 60)
EquipMeleeWeapon(playerid, "ITMW_2H_ORCAXE_04")
EquipArmor(playerid, "ITAR_djg_crawler")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITRW_CROSSBOW_H_01", 1)
GiveItem(playerid, "ITAT_WOLFFUR", 10)
GiveItem(playerid, "ITAT_SHADOWHORN", 1)
GiveItem(playerid, "ITRW_BOLT", 25)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_ZolnierzKossak(playerid) --Zolnierz Kossakow
Player[playerid].class = 34
Player[playerid].guild = 5
SetPlayerMaxHealth(playerid, 750)
SetPlayerHealth(playerid, 750)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 75)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 35)
SetPlayerSkillWeapon(playerid, SKILL_2H, 35)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 35)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 35)
EquipMeleeWeapon(playerid, "ITMW_2H_ORCAXE_02")
EquipArmor(playerid, "ITAR_bloodwyn_addon")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITRW_CROSSBOW_M_01", 1)
GiveItem(playerid, "ITAT_WOLFFUR", 10)
GiveItem(playerid, "ITAT_TEETH", 10)
GiveItem(playerid, "ITRW_BOLT", 25)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_PracownikKossak(playerid) --Pracownik Farmer
Player[playerid].class = 35
Player[playerid].guild = 5
SetPlayerMaxHealth(playerid, 500)
SetPlayerHealth(playerid, 500)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 75)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 35)
SetPlayerSkillWeapon(playerid, SKILL_2H, 35)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 35)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 35)
EquipMeleeWeapon(playerid, "Itmw_1h_misc_axe")
EquipArmor(playerid, "ITAR_PRISONER")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITMI_BROOM", 1)
GiveItem(playerid, "ITRW_BOW_L_01", 10)
GiveItem(playerid, "ITAT_TEETH", 10)
GiveItem(playerid, "ITRW_ARROW", 25)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end 

function Class_LordRandall(playerid) --Lord Randall
Player[playerid].class = 36
Player[playerid].guild = 6
SetPlayerMaxHealth(playerid, 1600)
SetPlayerHealth(playerid, 1600)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 200)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 100)
SetPlayerSkillWeapon(playerid, SKILL_2H, 100)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 80)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 80)
EquipMeleeWeapon(playerid, "Itmw_kriegshammer2")
EquipArmor(playerid, "itar_raven_addon")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ItRu_PalLight", 1)
GiveItem(playerid, "ITAR_Governor", 1)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_RekaRandall(playerid) --Prawa Reka Randalla
Player[playerid].class = 37
Player[playerid].guild = 6
SetPlayerMaxHealth(playerid, 1000)
SetPlayerHealth(playerid, 1000)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 150)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 60)
SetPlayerSkillWeapon(playerid, SKILL_2H, 60)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 60)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 60)
EquipMeleeWeapon(playerid, "ITMW_FOLTERAXT")
EquipArmor(playerid, "ITAR_CORANGAR")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITRW_BOW_H_03", 1)
GiveItem(playerid, "ITAT_WOLFFUR", 10)
GiveItem(playerid, "ITMI_GOLDCUP", 1)
GiveItem(playerid, "ITRW_ARROW", 25)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_ZolnierzRandall(playerid) --Zolnierz Randalla
Player[playerid].class = 38
Player[playerid].guild = 6
SetPlayerMaxHealth(playerid, 750)
SetPlayerHealth(playerid, 750)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 75)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 35)
SetPlayerSkillWeapon(playerid, SKILL_2H, 35)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 35)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 35)
EquipMeleeWeapon(playerid, "ITMW_KRUMMSCHWERT")
EquipArmor(playerid, "ITAR_RANGER_Addon")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITRW_BOW_H_02", 1)
GiveItem(playerid, "ITAT_WOLFFUR", 10)
GiveItem(playerid, "ITMI_SILVERCUP", 1)
GiveItem(playerid, "ITRW_ARROW", 25)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_PracownikRandall(playerid) --Pracownik Farmer1
Player[playerid].class = 39
Player[playerid].guild = 6
SetPlayerMaxHealth(playerid, 500)
SetPlayerHealth(playerid, 500)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 75)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 35)
SetPlayerSkillWeapon(playerid, SKILL_2H, 35)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 35)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 35)
EquipMeleeWeapon(playerid, "ITMW_1H_SWORD_L_03")
EquipArmor(playerid, "ITAR_BARKEEPER")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITMI_BROOM", 1)
GiveItem(playerid, "ITRW_BOW_L_01", 10)
GiveItem(playerid, "ITAT_TEETH", 10)
GiveItem(playerid, "ITRW_ARROW", 25)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end 

function Class_UczonyKossak(playerid) --Uczony Kossak
Player[playerid].class = 40
Player[playerid].guild = 5
SetPlayerMaxHealth(playerid, 500)
SetPlayerHealth(playerid, 500)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 75)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 35)
SetPlayerSkillWeapon(playerid, SKILL_2H, 35)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 35)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 35)
EquipMeleeWeapon(playerid, "ITMW_KRIEGSKEULE")
EquipArmor(playerid, "ITAR_vlk_h")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITMI_BROOM", 1)
GiveItem(playerid, "ITRW_BOW_L_01", 10)
GiveItem(playerid, "ITAT_TEETH", 10)
GiveItem(playerid, "ITMI_GOLDNECKLACE",1)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds")
end

function Class_UczonyRandall(playerid) --Uczony Randall
Player[playerid].class = 41
Player[playerid].guild = 6
SetPlayerMaxHealth(playerid, 500)
SetPlayerHealth(playerid, 500)
SetPlayerMaxMana(playerid, 500)
SetPlayerMana(playerid, 500)
SetPlayerMagicLevel(playerid, 6)
SetPlayerStrength(playerid, 75)
SetPlayerDexterity(playerid, 200)
SetPlayerSkillWeapon(playerid, SKILL_1H, 35)
SetPlayerSkillWeapon(playerid, SKILL_2H, 35)
SetPlayerSkillWeapon(playerid, SKILL_BOW, 35)
SetPlayerSkillWeapon(playerid, SKILL_CBOW, 35)
EquipMeleeWeapon(playerid, "itmw_1h_vlk_sword")
EquipArmor(playerid, "ITAR_judge")
GiveItem(playerid, "ItMi_Joint", 6)
GiveItem(playerid, "ItFo_Apple", 2)
GiveItem(playerid, "ItFo_Wine", 10)
GiveItem(playerid, "ItMi_Lute", 1)
GiveItem(playerid, "ItMi_Sextant", 1)
GiveItem(playerid, "ITMI_BROOM", 1)
GiveItem(playerid, "ITRW_BOW_L_01", 10)
GiveItem(playerid, "ITAT_TEETH", 10)
GiveItem(playerid, "ITMI_GOLDNECKLACE",1)
SetPlayerWalk(playerid, "HumanS_Relaxed.mds") 
end

--Rejestracja klas
RegisterClass(0, Class_NewPlayer, "Nowy gracz")
RegisterClass(1, Class_CityGuard, "Stra¿nik miejski")
RegisterClass(2, Class_CityGuard2, "Doœwiadczony stra¿nik miejski")
RegisterClass(3, Class_Ritter, "Rycerz")
RegisterClass(4, Class_Pal, "Paladyn")
RegisterClass(5, Class_Novice, "Nowicjusz")
RegisterClass(6, Class_FireMage, "Mag ognia")
RegisterClass(7, Class_FireMage2, "Cz³onek krêgu ognia")
RegisterClass(8, Class_NewSLD, "Najemnik")
RegisterClass(9, Class_MedSLD, "Uzbrojony najemnik")
RegisterClass(10, Class_SLD, "Doœwiadczony najemnik")
RegisterClass(11, Class_Lord, "Lord miasta Khorinis")
RegisterClass(12, Class_Farm, "£owca smoków")
RegisterClass(13, Class_Gov, "Urzêdnik")
RegisterClass(14, Class_Vlk, "Obywatel")
RegisterClass(15, Class_Smith, "Kowal")
RegisterClass(16, Class_Chemistry, "Chemik")
RegisterClass(17, Class_FarmWorker, "Farmer")
RegisterClass(18, Class_Judge, "Sêdzia")
RegisterClass(19, Class_BDTL, "Cienias")
RegisterClass(20, Class_BDTM, "Bandyta")
RegisterClass(21, Class_BDTH, "Bandyta (stra¿nik)")
RegisterClass(22, Class_MASTERBDT, "Herszt bandytów")
RegisterClass(23, Class_V0ID, "Król (V0ID)")
RegisterClass(24, Class_BOWM, "£uczarz")
RegisterClass(25, Class_General, "Genera³")
RegisterClass(26, Class_BlackNewb, "Pacho³ek cienia")
RegisterClass(27, Class_BlackMemb, "Cz³onek bractwa")
RegisterClass(28, Class_BlackWarrior, "Wojownik mroku")
RegisterClass(29, Class_Nekrofil, "Nekromanta")
RegisterClass(30, Class_Nigger, "Cieñ")
RegisterClass(31, Class_Pedofil, "Kap³an")
RegisterClass(32, Class_LordKossak, "Lord Kossak")
RegisterClass(33, Class_RekaKossak, "Prawa rêka (Kossak)")
RegisterClass(34, Class_ZolnierzKossak, "¯o³nierz (Kossak)")
RegisterClass(35, Class_PracownikKossak, "Farmer (Kossak)")
RegisterClass(36, Class_LordRandall, "Lord Randall")
RegisterClass(37, Class_RekaRandall, "Prawa rêka (Randall)")
RegisterClass(38, Class_ZolnierzRandall, "¯o³nierz (Randall)")
RegisterClass(39, Class_PracownikRandall, "Farmer (Randall)")
RegisterClass(40, Class_UczonyKossak, "Uczony (Kossak)")
RegisterClass(41, Class_UczonyRandall, "Uczony (Randall)")