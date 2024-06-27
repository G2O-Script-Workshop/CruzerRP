local Player = {};

local bodyModel = ["HUM_BODY_NAKED0", "HUM_BODY_BABE0"];
local headModel = ["HUM_HEAD_FATBALD", "HUM_HEAD_FIGHTER", "HUM_HEAD_PONY", "HUM_HEAD_BALD", "HUM_HEAD_THIEF", "HUM_HEAD_PSIONIC", "HUM_HEAD_BABE"];

for(local i = 0, end = getMaxSlots(); i < end; ++i){
	Player[i] <- {};

	Player[i].logged <- false;

	Player[i].password <- "";
	Player[i].color <- [0, 0, 0];
	Player[i].clss <- 0;
	Player[i].rank <- 0;
	Player[i].vis <- ["HUM_BODY_NAKED0", 9, "HUM_HEAD_PONY", 18];

	Player[i].walk <- "";

	Player[i].seepm <- false;
}

function clearPlayer(pid){
	Player[pid].logged <- false;

	Player[pid].password <- "";
	Player[pid].color <- [0, 0, 0];
	Player[pid].clss <- 0;
	Player[pid].rank <- 0;
	Player[pid].vis <- ["HUM_BODY_NAKED0", 9, "HUM_HEAD_PONY", 18];

	Player[pid].walk <- "";

	Player[pid].seepm <- false;
}

addEventHandler("onInit", function(){
	print("-===========================-");
	print("[CruzerRP: Squirrel Re-Write]");
	print("-===========================-");

	setTimer(function(){
		local packet = Packet();
		packet.writeUInt8(1);
		for(local i = 0, end = getMaxSlots(); i < end; ++i){			
			packet.send(i, RELIABLE);

			if(Player[i].logged == true) saveAccount(i);
		}
	}, 180000, 0);
});

addEventHandler("onPacket", function(pid, packet){
	local packetId = packet.readUInt8();
	if(packetId == 3){
		Classes[Player[pid].clss].func(pid);
	}
});

addEventHandler("onPlayerJoin", function(pid){
	if(getPlayerName(pid) == "Nickname"){
		kick(pid, "Zmieñ nick w launcherze Gothic 2 Online!")
	}
	sendMessageToPlayer(pid, 0, 255, 0, "Gamemode stworzony przez V0ID'a. Przepisany przez DamianQ.");
	sendMessageToPlayer(pid, 255, 145, 0, "Witaj na serwerze Cruzer RolePlay!");
	sendMessageToPlayer(pid, 255, 145, 0, "Wpisz /pomoc aby dowiedzieæ siê jak graæ na serwerze, powodzenia!");

	local myfile = io.file("database/" + getPlayerName(pid) + ".acnt", "r+");
	if(myfile.isOpen){
		sendMessageToPlayer(pid, 111, 255, 0, "Masz ju¿ konto na serwerze: wpisz /zaloguj haslo");
	myfile.close();
	} else
		sendMessageToPlayer(pid, 239, 255, 0, "Nie masz konta na serwerze: wpisz /zarejestruj haslo");

	setPlayerColor(pid, 0, 255, 0);
});

addEventHandler("onPlayerDisconnect", function(pid, reason){
	if(Player[pid].logged == true){
		saveAccount(pid);
		sendMessageToAll(255, 0, 0, format("%s %s", getPlayerName(pid), "od³¹czy³(a) siê od gry"));
	}
	clearPlayer(pid);
});

addEventHandler("onPlayerRespawn", function(pid){
	spawnPlayer(pid);

	if(Player[pid].logged == true){
		setPlayerPosition(pid, 38601.9140625, 3911.5217285156, -1280.5793457031);
		setPlayerVisual(pid, Player[pid].vis[0], Player[pid].vis[1], Player[pid].vis[2], Player[pid].vis[3]);
		Classes[Player[pid].clss].func(pid);
	} else {
		sendMessageToAll(253, 255, 176, format("%s %s", getPlayerName(pid), "do³¹czy³(a) do gry!"));

		Classes[0].func(pid);
		setPlayerPosition(pid, 5401.4033203125, 285.74258422852, -3149.1264648438);
	}
});

addEventHandler("onPlayerChangeWorld", function(pid, world){
	if(world != "NEWWORLD\\NEWWORLD.ZEN"){
		setPlayerWorld(pid, "NEWWORLD\\NEWWORLD.ZEN");
		setPlayerPosition(pid, 38601.9140625, 3911.5217285156, -1280.5793457031);
	}
});

addEventHandler("onPlayerChangeWeaponMode", function(pid, oldwm, newwm){
	if(Player[pid].clss != 0){
		if(newwm != WEAPONMODE_NONE){
			if(newwm == WEAPONMODE_1HS){
				if(getPlayerSkillWeapon(pid, WEAPON_1H) >= 30 && getPlayerSkillWeapon(pid, WEAPON_1H) < 60){
					applyPlayerOverlay(pid, Mds.id("HUMANS_1HST1.MDS"));
				}
				else if(getPlayerSkillWeapon(pid, WEAPON_1H) >= 60){
					applyPlayerOverlay(pid, Mds.id("HUMANS_1HST2.MDS"));
				}
			}
			if(newwm == WEAPONMODE_2HS){
				if(getPlayerSkillWeapon(pid, WEAPON_2H) >= 30 && getPlayerSkillWeapon(pid, WEAPON_2H) < 60){
					applyPlayerOverlay(pid, Mds.id("HUMANS_2HST1.MDS"));
				}
				else if(getPlayerSkillWeapon(pid, WEAPON_2H) >= 60){
					applyPlayerOverlay(pid, Mds.id("HUMANS_2HST2.MDS"));
				}
			}
			if(newwm == WEAPONMODE_BOW){
				if(getPlayerSkillWeapon(pid, WEAPON_BOW) >= 30 && getPlayerSkillWeapon(pid, WEAPON_BOW) < 60){
					applyPlayerOverlay(pid, Mds.id("HUMANS_BOWT1.MDS"));
				}
				else if(getPlayerSkillWeapon(pid, WEAPON_BOW) >= 60){
					applyPlayerOverlay(pid, Mds.id("HUMANS_BOWT2.MDS"));
				}
			}
			if(newwm == WEAPONMODE_CBOW){
				if(getPlayerSkillWeapon(pid, WEAPON_CBOW) >= 30 && getPlayerSkillWeapon(pid, WEAPON_CBOW) < 60){
					applyPlayerOverlay(pid, Mds.id("HUMANS_CBOWT1.MDS"));
				}
				else if(getPlayerSkillWeapon(pid, WEAPON_BOW) >= 60){
					applyPlayerOverlay(pid, Mds.id("HUMANS_CBOWT2.MDS"));
				}
			}
		} else applyPlayerOverlay(pid, Player[pid].walk);
	} else {
		if(newwm != WEAPONMODE_NONE){
			sendMessageToPlayer(pid, 255, 0, 0, "Jesteœ zbyt s³aby ¿eby walczyæ");
			setPlayerWeaponMode(pid, WEAPONMODE_NONE);
		}
	}
});

addEventHandler("onPlayerMessage", function(pid, params){
	if(Player[pid].logged == true){
		strip(params);
		local msgType = params.slice(0, 1);
		local text = params.slice(1);
		local send = getPlayerPosition(pid);

		local sendPlayerMessage = function(dist, r, g, b, message){
			for(local i = 0, end = getMaxSlots(); i < end; ++i){
				if(isPlayerConnected(i)){
					local pos = getPlayerPosition(i);
					if(getDistance3d(send.x, send.y, send.z, pos.x, pos.y, pos.z) <= dist){
						sendMessageToPlayer(i, r, g, b, message);
					}
				}
			}
		}

		if(msgType == "@"){
			sendPlayerMessage(1000, 255, 255, 0, format("%s ((%s:%s))", "(OOC)", getPlayerName(pid), text));
		}
		else if(msgType == "#"){
			sendPlayerMessage(1000, 242, 86, 8, format("# %s %s #", getPlayerName(pid), text));
		}
		else if(msgType == "."){
			sendPlayerMessage(1000, 47, 242, 8, format("%s (%s)", text, getPlayerName(pid)));
		}
		else if(msgType == ","){
			sendPlayerMessage(500, 253, 255, 176, format("%s %s %s", getPlayerName(pid), "szepcze", text));
		}
		else if(msgType == "!"){
			sendPlayerMessage(3000, 242, 8, 8, format("%s %s %s", getPlayerName(pid), "krzyczy", text));
		}
		else {
			sendPlayerMessage(1000, 253, 255, 176, format("%s %s %s", getPlayerName(pid), "mówi", params));
		}
	} else
		sendMessageToPlayer(pid, 255, 0, 0, "Zaloguj siê aby móc pisaæ½");
});

function saveAccount(pid){
	local passwd = Player[pid].password;
	local color = getPlayerColor(pid);
	local clss = Player[pid].clss;
	local rank = Player[pid].rank;
	local vis = Player[pid].vis;
	local pos = getPlayerPosition(pid);
	local angle = getPlayerAngle(pid);

	local myfile = io.file("database/" + getPlayerName(pid) + ".acnt", "w+");
	if(myfile.isOpen){
		myfile.write(passwd + "\n");
		myfile.write(color.r + " " + color.g + " " + color.b + "\n");
		myfile.write(clss + "\n");
		myfile.write(rank + "\n");
		myfile.write(vis[0] + " " + vis[1] + " " + vis[2] + " " + vis[3] + "\n");
		myfile.write(pos.x + " " + pos.y + " " + pos.z + " " + angle);
	myfile.close();
	}
}

function loadAccount(pid){
	local myfile = io.file("database/" + getPlayerName(pid) + ".acnt", "r");
	if(myfile.isOpen){
		local passwd = myfile.read(io_type.LINE);
			Player[pid].password = passwd;

		local color = sscanf("ddd", myfile.read(io_type.LINE));
			if(color != null){
				setPlayerColor(pid, color[0], color[1], color[2]);
				Player[pid].color = [color[0], color[1], color[2]];
			}

		local clss = myfile.read(io_type.LINE).tointeger();
			Classes[clss].func(pid);
			Player[pid].clss = clss;

		local rank = myfile.read(io_type.LINE).tointeger();
			Player[pid].rank = rank;

		local vis = sscanf("sdsd", myfile.read(io_type.LINE));
			if(vis != null){
				setPlayerVisual(pid, vis[0], vis[1], vis[2], vis[3]);
				Player[pid].vis = [vis[0], vis[1], vis[2], vis[3]];
			}

		local pos = sscanf("ffff", myfile.read(io_type.LINE));
			if(pos != null){
				setPlayerPosition(pid, pos[0], pos[1], pos[2]);
				setPlayerAngle(pid, pos[3]);
			}

	myfile.close();
	}
}

addEventHandler("onPlayerCommand", function(pid, cmd, params){
	cmd = cmd.tolower();

	if(cmd == "zarejestruj"){
		local password = params;
		if(!password || password == ""){
			sendMessageToPlayer(pid, 255, 0, 0, "B³êdna sk³adnia komendy wpisz /zarejestruj has³o");
			return;
		}

		if(Player[pid].logged == false){
			local myfile = io.file("database/" + getPlayerName(pid) + ".acnt", "r+");
			if(myfile.isOpen){
				sendMessageToPlayer(pid, 255, 0, 0, "Posiadasz ju¿ konto na serwerze. Wpisz /zaloguj has³o aby siê zalogowaæ½");
			myfile.close();
			} else {
				Player[pid].logged = true;
				Player[pid].password = md5(params);
				sendMessageToPlayer(pid, 179, 0, 255, "Zarejestrowano pomyœlnie, ¿yczymy dobrej zabawy");
				setPlayerPosition(pid, 38601.9140625, 3911.5217285156, -1280.5793457031);
				setPlayerColor(pid, 255, 255, 255);
				Classes[0].func(pid);
				spawnPlayer(pid);
				saveAccount(pid);
						local packet = Packet();
						packet.writeUInt8(4);		
						packet.send(pid, RELIABLE);
			}
		} else
			sendMessageToPlayer(pid, 255, 0, 0, "Jesteœ ju¿ zalogowany!");
	}
	else if(cmd == "zaloguj"){
		local password = params;
		if(!password || password == ""){
			sendMessageToPlayer(pid, 255, 0, 0, "B³êdna sk³adnia komendy wpisz /zaloguj has³o");
			return;
		}

		if(Player[pid].logged == false){
			local myfile = io.file("database/" + getPlayerName(pid) + ".acnt", "r+");
			if(myfile.isOpen){
				local passwd = myfile.read(io_type.LINE);
				if(passwd == md5(password)){
					Player[pid].logged = true;
					Player[pid].password = passwd;
					sendMessageToPlayer(pid, 0, 255, 154, "Zosta³eœ zalogowany");
					spawnPlayer(pid);
					loadAccount(pid);
						local packet = Packet();
						packet.writeUInt8(4);		
						packet.send(pid, RELIABLE);
				} else {
					sendMessageToPlayer(pid, 255, 0, 0, "Z³e has³o! Jeœli uwa¿asz, ¿e to b³¹d, skontaktuj siê z administratorem.");
				}
			myfile.close();
			} else
				sendMessageToPlayer(pid, 255, 0, 0, "Nie masz konta na serwerze wpisz /zarejestruj has³o");
		} else
			sendMessageToPlayer(pid, 255, 0, 0, "Jesteœ ju¿ zalogowany!");
	}
	else if(cmd == "gmsg"){
		local msg = sscanf("s", params);

		if(!msg){
			sendMessageToPlayer(pid, 255, 0, 0, "U¿yj /gmsg wiadomoœæ");
			return;
		}

		if(Classes[Player[pid].clss].guild != 0){
			for(local i = 0, end = getMaxSlots(); i < end; ++i){
				if(isPlayerConnected(i)){
					if(Classes[Player[i].clss].guild == Classes[Player[pid].clss].guild){
						sendMessageToPlayer(i, 253, 255, 176, format("%s %d|%s: %s", "|GILDIA|", pid, getPlayerName(pid), msg));
					}
				}
			}
		} else
			sendMessageToPlayer(pid, 255, 0, 0, "Nie nale¿ysz do ¿adnej oficjalnej gildii.");
	}
	else if(cmd == "pm"){
		local par = sscanf("ds", params);

		if(!par){
			sendMessageToPlayer(pid, 255, 0, 0, "U¿yj: /pm id wiadomosc");
			return;
		}

		local id = par[0];
		local msg = par[1];

		if(isPlayerConnected(id)){
			sendMessageToPlayer(id, 255, 154, 0, "(PM) " + getPlayerName(pid) + "|" + pid + " >> " + msg);
			sendMessageToPlayer(pid, 255, 68, 0, "(PM) " + getPlayerName(id) + "|" + id + " << " + msg);
		} else
			sendMesageToPlayer(pid, 255, 0, 0, "Ten gracz nie jest po³¹czony.");

		for(local i = 0, end = getMaxSlots(); i < end; ++i){
			if(Player[i].seepm == true){
				sendMessageToPlayer(i, 0, 255, 94, "Podgl¹d (PM) | od " + getPlayerName(pid) + "|" + pid + " do " + getPlayerName(id) + "|" + id + ": " + msg);
			}
		}
	}
	else if(cmd == "wyglad"){
		local par = sscanf("dddd", params);

		if(!par){
			sendMessageToPlayer(pid, 255, 0, 0, "U¿yj /wyglad modelCia³a(0-1), teksturaCia³a(0-12), modelG³owy(0-6), teksturaG³owy(0-162)");
			return;
		}

		local bodym = par[0];
		local bodytex = par[1];
		local headm = par[2];
		local headtex = par[3];

		if(bodym > 1 || bodytex > 12 || headm > 6 || headtex > 162){
			sendMessageToPlayer(pid, 255, 0, 0, "U¿yj /wyglad modelCia³a(0-1), teksturaCia³a(0-12), modelG³owy(0-6), teksturaG³owy(0-162)");
		}

			setPlayerVisual(pid, bodyModel[bodym], bodytex, headModel[headm], headtex);
			Player[pid].vis = [bodyModel[bodym], bodytex, headModel[headm], headtex];

			sendMessageToPlayer(pid, 0, 255, 0, "Wygl¹d zmieniony!");
	}
	else if(cmd == "pomoc"){
		sendMessageToPlayer(pid, 255, 255, 0, "Komendy serwera CruzerRP");
		sendMessageToPlayer(pid, 255, 255, 0, "Zapoznaj siê z nowym czatem rp opartym na prefix'ach:");
		sendMessageToPlayer(pid, 255, 255, 0, "@ - Wiadomoœæ zostanie wyœwietlona jako ooc ");
		sendMessageToPlayer(pid, 255, 255, 0, ". - Wiadomoœæ zostanie wyœwietlona jako do ");
		sendMessageToPlayer(pid, 255, 255, 0, ", - Wiadomoœæ zostanie wyœwietlona jako szept ");
		sendMessageToPlayer(pid, 255, 255, 0, "! - Wiadomoœæ zostanie wyœwietlona jako krzyk ");
		sendMessageToPlayer(pid, 255, 255, 0, "# - Wiadomoœæ zostanie wyœwietlona jako me(ja) ");
		sendMessageToPlayer(pid, 255, 255, 0, "/pm id/nick_gracza - Prywatna wiadomoœæ");
		sendMessageToPlayer(pid, 255, 255, 0, "/adm wiadomoœæ - Wiadomoœæ do administratora (ujrz¹ j¹ wszyscy administratorzy online)");
		sendMessageToPlayer(pid, 255, 255, 0, "/wyglad modelCia³a(1-2) teksturaCia³a(0-12) modelG³owy(1-7) teksturaG³owy(0-162) - Zmiana wygl¹du");
		sendMessageToPlayer(pid, 255, 255, 0, "/gmsg wiadomoœæ - Wiadomoœæ do gildii");
		sendMessageToPlayer(pid, 255, 255, 0, "/zmienhaslo stareHas³o noweHas³o - zmiana has³a");
		sendMessageToPlayer(pid, 255, 255, 0, "/m.all - Wyœwietla moderatorów oraz administratorów online");
	}
	else if(cmd == "m.help"){
		if(Player[pid].rank >= 1){
			sendMessageToPlayer(pid, 255, 255, 0, "Komendy moderatora na serwerzer CruzerRP");
			sendMessageToPlayer(pid, 255, 255, 0, "/pos - Wyœwietlenie danej pozycji");
			sendMessageToPlayer(pid, 255, 255, 0, "/awans idgracza idklasy - Zmiana klasy");
			sendMessageToPlayer(pid, 255, 255, 0, "/post wiadomoœæ - Wiadomoœæ globalna");
			if(Player[pid].rank >= 2){
				sendMessageToPlayer(pid, 255, 255, 0, "/m.kick idgracza powód - Wyrzucenie danego gracza z serwera");
				sendMessageToPlayer(pid, 255, 255, 0, "/seepm - Widocznoœæ wiadomoœci prywatnych");
			}
			if(Player[pid].rank == 3){
				sendMessageToPlayer(pid, 255, 255, 0, "/kall - Wyrzucenie wszystkich graczy z serwera");
				sendMessageToPlayer(pid, 255, 255, 0, "/mod id rank - Zmiana poziomu uprawnieñ gracza");
			}
			sendMessageToPlayer(pid, 255, 255, 0, "/m.pomoc - Komendy moderatora");
		} else
			sendMessageToPlayer(pid, 255, 0, 0, "Nie masz uprawnieñ do u¿ycia tej komendy");
	}
	else if(cmd == "m.kick"){
		if(Player[pid].rank >= 2){
			local par = sscanf("ds", params);

			if(!par){
				sendMessageToPlayer(pid, 255, 0, 0, "U¿yj /m.kick idgracza powód");
				return;
			}

			local id = par[0];
			local reason = par[1];

			sendMessageToAll(255, 0, 0, "Gracz " + getPlayerName(id) + " zosta³ wyrzucony z serwera przez moderatora " + getPlayerName(pid) + " za " + reason);
			kick(id, reason);

		} else
			sendMessageToPlayer(pid, 255, 0, 0, "Nie masz uprawnieñ do u¿ycia tej komendy");
	}
	else if(cmd == "m.all"){
		sendMessageToPlayer(pid, 255, 255, 255, "Osoby z uprawnieniami przebywaj¹ce obecnie na serwerze:");
		for(local i = 0, end = getMaxSlots(); i < end; ++i){
			if(isPlayerConnected(i)){
				if(Player[i].rank == 1){
					sendMessageToPlayer(pid, 0, 255, 0, format("%d|%s %s", i, getPlayerName(i), "(Lider)"));
				}
				if(Player[i].rank == 2){
					sendMessageToPlayer(pid, 0, 0, 255, format("%d|%s %s", i, getPlayerName(i), "(Moderator)"));
				}
				if(Player[i].rank == 3){
					sendMessageToPlayer(pid, 255, 0, 0, format("%d|%s %s", i, getPlayerName(i), "(Administrator)"));
				}
			}
		}
	}
	else if(cmd == "post"){
		if(Player[pid].rank >= 1){
			local msg = sscanf("s", params);

			if(!msg){
				sendMessageToPlayer(pid, 255, 0, 0, "U¿yj /post wiadomoœæ");
				return;
			}

			sendMessageToAll(0, 200, 225, format("%s %d|%s: %s", "(GLOBAL)", pid, getPlayerName(pid), msg));

		} else
			sendMessageToPlayer(pid, 255, 0, 0, "Nie masz uprawnieñ do u¿ycia tej komendy");
	}
	else if(cmd == "awans"){
		if(Player[pid].rank >= 1){
			local par = sscanf("dd", params);

			if(!par){
				sendMessageToPlayer(pid, 255, 0, 0, "U¿yj /awans idgracza idklasy");
				return;
			}

			local id = par[0];
			local clss = par[1];

				if(clss <= Classes.len() && clss >= 0){
					sendMessageToPlayer(id, 0, 255, 0, "Twoja klasa zosta³a zamieniona na: " + Classes[clss].name);
					sendMessageToPlayer(pid, 0, 255, 0, "Klasa gracza " + getPlayerName(id) + " zosta³a zamieniona na " + Classes[clss].name);

					local packet = Packet();
					packet.writeUInt8(2);
					packet.send(pid, RELIABLE);
					Player[pid].clss = clss;
				} else
					sendMessageToPlayer(pid, 255, 0, 0, "Klasa o ID " + clss + " nie istnieje");

		} else
			sendMessageToPlayer(pid, 255, 0, 0, "Nie jesteœ administratorem, ani dowódc¹!");
	}
	else if(cmd == "adm"){
		for(local i = 0, end = getMaxSlots(); i < end; ++i){
			if(isPlayerConnected(i))
				if(Player[i].rank >= 2){{
					sendMessageToPlayer(i, 0, 255, 255, "Wiadomoœæ dla administratora:");
					sendMessageToPlayer(i, 0, 255, 255, "(Adm) " + pid + "|" + getPlayerName(pid) + ":" + msg);
				}
			}
		}
		sendMessageToPlayer(pid, 0, 255, 0, "Wiadomoœæ zosta³a wys³ana.");
	}
	else if(cmd == "zmienhaslo"){
		if(Player[pid].logged == true){
			local par = sscanf("ss", params);

			if(!par){
				sendMessageToPlayer(pid, 255, 0, 0, "U¿yj /zmienhaslo stareHas³o noweHas³o");
				return;
			}

			local oldpass = par[0];
			local newpass = par[1];

			if(md5(oldpass) == Player[pid].password){
				Player[pid].password = md5(newpass);
				sendMessageToPlayer(pid, 0, 255, 0, "Has³o zosta³o zmienione");
				saveAccount(pid);
			}
			else
				sendMessageToPlayer(pid, 255, 0, 0, "Stare has³o nie pasuje do u¿ywanego obecnie");
		}
	}
	else if(cmd == "mod"){
		if(Player[pid].rank == 3){
			local par = sscanf("dd", params);

			if(!par){
				sendMessageToPlayer(pid, 255, 0, 0, "U¿yj /mod idgracza rank");
				return;
			}

			local id = par[0];
			local rank = par[1];

			if(rank == 1){
				sendMessageToPlayer(pid, 0, 255, 0, "Nada³eœ uprawnienia dowódcy graczowi " + getPlayerName(id) + "|" + id);
				sendMessageToPlayer(id, 0, 255, 0, "Administrator " + getPlayerName(pid) + "|" + pid + " nada³ Ci uprawnienia dowódcy");
			}
			else if(rank == 2){
				sendMessageToPlayer(pid, 0, 255, 0, "Nada³eœ uprawnienia moderatora graczowi " + getPlayerName(id) + "|" + id);
				sendMessageToPlayer(id, 0, 255, 0, "Administrator " + getPlayerName(pid) + "|" + pid + " nada³ Ci uprawnienia moderatora");
			}
			else if(rank == 3){
				sendMessageToPlayer(pid, 0, 255, 0, "Nada³eœ uprawnienia administratora graczowi " + getPlayerName(id) + "|" + id);
				sendMessageToPlayer(id, 0, 255, 0, "Administrator " + getPlayerName(pid) + "|" + pid + " nada³ Ci uprawnienia administratora");
			}
			else{
				sendMessageToPlayer(pid, 0, 255, 0, "Zabra³eœ uprawnienia graczowi " + getPlayerName(id) + "|" + id);
				sendMessageToPlayer(id, 0, 255, 0, "Administrator " + getPlayerName(pid) + "|" + pid + " odebra³ Ci uprawnienia");
			}

			Player[id].rank = rank;

		} else
			sendMessageToPlayer(pid, 255, 0, 0, "Nie masz uprawnieñ do u¿ycia tej komendy");
	}
	else if(cmd == "kall"){
		if(Player[pid].rank == 3){
			for(local i = 0, end = getMaxSlots(); i < end; ++i){
				if(isPlayerConnected(i)) kick(i);
			}
		}
	}
	else if(cmd == "seepm"){
		if(Player[pid].rank >= 2){
			Player[pid].seepm = !Player[pid].seepm;
			sendMessageToPlayer(pid, 255, 0, 0, "Podgl¹d prywatnych wiadomoœci zmieniony");
		}
	}
	else if(cmd == "pos"){
		if(Player[pid].rank >= 1){
			local pos = getPlayerPosition(pid);
			local a = getPlayerAngle(pid);

			sendMessageToPlayer(pid, 255, 255, 0, "X:" + pos.x + " Y:" + pos.y + " Z:" + pos.z + " A:" + a);
			print("X:" + pos.x + " Y:" + pos.y + " Z:" + pos.z + " A:" + a);
		}
	}
});

io <- {}

enum io_type
{
	LINE,
	ALL
};

class io.file extends file
{
	constructor(fileName, mode)
	{
		errorMsg = null;
	
		try
		{
			base.constructor(fileName, mode);
			isOpen = true;
		}
		catch (msg)
		{
			errorMsg = msg;
			isOpen = false;
		}
	}
	
	function write(text)
	{
		foreach (char in text)
		{
			writen(char, 'b');
		}
	}
	
	function read(type = io_type.ALL)
	{
		if (type == io_type.LINE)
		{
			local line = "";
			local char;
			
			while (!eos() && (char = readn('b')))
			{
				if (char != '\n')
					line += char.tochar();
				else
					return line;
			}
			
			return line.len() == 0 ? null : line;
		}
		else if (type == io_type.ALL)
		{
			local content = "";
			local char;
			
			while (!eos() && (char = readn('b')))
			{
				content += char.tochar();
			}
			
			return content.len() == 0 ? null : content;
		}
		
		return null;
	}
	
	function close()
	{
		base.close();
		isOpen = false;
	}
	
	errorMsg = null;
	isOpen = false;
}

Classes <- [
	{
		name = "Przybysz",
		guild = 0,
		func = function(id){
			setPlayerMaxHealth(id, 100);
			setPlayerHealth(id, 100);
			setPlayerStrength(id, 0);
			setPlayerDexterity(id, 0);

			giveItem(id, Items.id("ITAR_LEATHER_L"), 1);

			giveItem(id, Items.id("ITFO_MEAT"), 10);
			giveItem(id, Items.id("ITFO_WATER"), 20);
			giveItem(id, Items.id("ITMI_JOINT"), 3);

			applyPlayerOverlay(id, Mds.id("HUMANS_TIRED.MDS"));
		}
	},
	{
		name = "Stra¿nik miejski",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 300);
			setPlayerHealth(id, 300);
			setPlayerStrength(id, 60);
			setPlayerDexterity(id, 60);
			setPlayerSkillWeapon(id, WEAPON_1H, 30);
			setPlayerSkillWeapon(id, WEAPON_2H, 30);
			setPlayerSkillWeapon(id, WEAPON_BOW, 30);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 30);

			giveItem(id, Items.id("ITAR_MIL_L"), 1);
			giveItem(id, Items.id("ITMW_1H_MIL_SWORD"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITLSTORCH"), 3);
			giveItem(id, Items.id("ITFO_WINE"), 10);

			applyPlayerOverlay(id, Mds.id("HUMANS_MILITIA.MDS"));
		}
	},
	{
		name = "Doœwiadczony stra¿nik miejski",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 500);
			setPlayerHealth(id, 500);
			setPlayerStrength(id, 120);
			setPlayerDexterity(id, 120);
			setPlayerSkillWeapon(id, WEAPON_1H, 60);
			setPlayerSkillWeapon(id, WEAPON_2H, 60);
			setPlayerSkillWeapon(id, WEAPON_BOW, 60);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 60);

			giveItem(id, Items.id("ITAR_MIL_M"), 1);
			giveItem(id, Items.id("ITMW_1H_MIL_SWORD"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITLSTORCH"), 3);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITRW_BOLT"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_MILITIA.MDS"));
		}
	},
	{
		name = "Rycerz",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 1000);
			setPlayerHealth(id, 1000);
			setPlayerMaxMana(id, 250);
			setPlayerMana(id, 250);
			setPlayerMagicLevel(id, 6);
			setPlayerStrength(id, 150);
			setPlayerDexterity(id, 150);
			setPlayerSkillWeapon(id, WEAPON_1H, 80);
			setPlayerSkillWeapon(id, WEAPON_2H, 80);
			setPlayerSkillWeapon(id, WEAPON_BOW, 75);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 75);

			giveItem(id, Items.id("ITAR_PAL_M"), 1);
			giveItem(id, Items.id("ITMW_1H_PAL_SWORD"), 1);

			giveItem(id, Items.id("ITAR_MIL_M"), 1);
			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITRW_BOLT"), 25);

			giveItem(id, Items.id("ITSC_PALLIGHT"), 3);
			giveItem(id, Items.id("ITSC_FULLHEAL"), 3);

			applyPlayerOverlay(id, Mds.id("HUMANS_MILITIA.MDS"));
		}
	},
	{
		name = "Paladyn",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 1200);
			setPlayerHealth(id, 1200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerStrength(id, 200);
			setPlayerDexterity(id, 200);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_PAL_H"), 1);
			giveItem(id, Items.id("ITMW_1H_PAL_SWORD"), 1);

			giveItem(id, Items.id("ITAR_MIL_L"), 1);
			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITRW_BOLT"), 25);

			giveItem(id, Items.id("ITSC_PALLIGHT"), 3);
			giveItem(id, Items.id("ITSC_FULLHEAL"), 3);

			applyPlayerOverlay(id, Mds.id("HUMANS_MILITIA.MDS"));
		}
	},
	{
		name = "Nowicjusz",
		guild = 2,
		func = function(id){
			setPlayerMaxHealth(id, 300);
			setPlayerHealth(id, 300);
			setPlayerMaxMana(id, 100);
			setPlayerMana(id, 100);
			setPlayerMagicLevel(id, 6);
			setPlayerStrength(id, 50);
			setPlayerDexterity(id, 50);

			giveItem(id, Items.id("ITAR_NOV_L"), 1);
			giveItem(id, Items.id("ITMW_1H_NOV_MACE"), 1);

			giveItem(id, Items.id("ITRU_LIGHT"), 1);
			giveItem(id, Items.id("ITSC_FIREBOLT"), 30);
			giveItem(id, Items.id("ITSC_FULLHEAL"), 3);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Mag ognia",
		guild = 2,
		func = function(id){
			setPlayerMaxHealth(id, 1000);
			setPlayerHealth(id, 1000);
			setPlayerMaxMana(id, 600);
			setPlayerMana(id, 600);
			setPlayerMagicLevel(id, 6);

			giveItem(id, Items.id("ITAR_KDF_L"), 1);

			giveItem(id, Items.id("ITRU_LIGHT"), 1);
			giveItem(id, Items.id("ITRU_FIREBOLT"), 1);
			giveItem(id, Items.id("ITRU_ICEBOLT"), 1);
			giveItem(id, Items.id("ITRU_WINDFIST"), 1);
			giveItem(id, Items.id("ITRU_SLEEP"), 1);
			giveItem(id, Items.id("ITAR_DEMENTOR"), 1);
			giveItem(id, Items.id("ITPO_MANA_03"), 20);
			giveItem(id, Items.id("ITPO_SPEED"), 3);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Cz³onek krêgu ognia",
		guild = 2,
		func = function(id){
			setPlayerMaxHealth(id, 1300);
			setPlayerHealth(id, 1300);
			setPlayerMaxMana(id, 1000);
			setPlayerMana(id, 1000);
			setPlayerMagicLevel(id, 6);

			giveItem(id, Items.id("ITAR_KDF_H"), 1);
			giveItem(id, Items.id("ITMW_1H_NOV_MACE"), 1);

			giveItem(id, Items.id("ITRU_LIGHT"), 1);
			giveItem(id, Items.id("ITRU_FIREBOLT"), 1);
			giveItem(id, Items.id("ITRU_ICEBOLT"), 1);
			giveItem(id, Items.id("ITRU_WINDFIST"), 1);
			giveItem(id, Items.id("ITRU_SLEEP"), 1);
			giveItem(id, Items.id("ITRU_FIRERAIN"), 1);
			giveItem(id, Items.id("ITAR_DEMENTOR"), 1);
			giveItem(id, Items.id("ITPO_MANA_03"), 20);
			giveItem(id, Items.id("ITRU_INSTANTFIREBALL"), 1);
			giveItem(id, Items.id("ITPO_SPEED"), 3);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Najemnik",
		guild = 3,
		func = function(id){
			setPlayerMaxHealth(id, 300);
			setPlayerHealth(id, 300);
			setPlayerStrength(id, 60);
			setPlayerDexterity(id, 60);
			setPlayerSkillWeapon(id, WEAPON_1H, 30);
			setPlayerSkillWeapon(id, WEAPON_2H, 30);
			setPlayerSkillWeapon(id, WEAPON_BOW, 30);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 30);

			giveItem(id, Items.id("ITAR_SLD_L"), 1);
			giveItem(id, Items.id("ITMW_1H_SWORD_L_03"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_CHEESE"), 2);
			giveItem(id, Items.id("ITLSTORCH"), 3);
			giveItem(id, Items.id("ITFO_WINE"), 10);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Uzbrojony najemnik",
		guild = 3,
		func = function(id){
			setPlayerMaxHealth(id, 500);
			setPlayerHealth(id, 500);
			setPlayerStrength(id, 120);
			setPlayerDexterity(id, 120);
			setPlayerSkillWeapon(id, WEAPON_1H, 60);
			setPlayerSkillWeapon(id, WEAPON_2H, 60);
			setPlayerSkillWeapon(id, WEAPON_BOW, 60);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 60);

			giveItem(id, Items.id("ITAR_SLD_M"), 1);
			giveItem(id, Items.id("ITMW_1H_SLD_SWORD"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 12);
			giveItem(id, Items.id("ITFO_CHEESE"), 4);
			giveItem(id, Items.id("ITLSTORCH"), 3);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITRW_BOLT"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Doœwiadczony najemnik",
		guild = 3,
		func = function(id){
			setPlayerMaxHealth(id, 1200);
			setPlayerHealth(id, 1200);
			setPlayerStrength(id, 200);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_SLD_H"), 1);
			giveItem(id, Items.id("ITMW_SHORTSWORD4"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_CHEESE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITRU_PALLIGHT"), 1);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Lord miasta Khorinis",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 1600);
			setPlayerHealth(id, 1600);
			setPlayerStrength(id, 200);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_GOVERNOR"), 1);
			giveItem(id, Items.id("ITMW_SCHWERT5"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITRU_PALLIGHT"), 1);
			giveItem(id, Items.id("ITRU_INSTANTFIREBALL"), 1);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "£owca smoków",
		guild = 3,
		func = function(id){
			setPlayerMaxHealth(id, 1600);
			setPlayerHealth(id, 1600);
			setPlayerStrength(id, 200);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_DJG_L"), 1);
			giveItem(id, Items.id("ITMW_SCHWERT5"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITRU_PALLIGHT"), 1);
			giveItem(id, Items.id("ITRU_INSTANTFIREBALL"), 1);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Urzêdnik",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 1600);
			setPlayerHealth(id, 1600);
			setPlayerStrength(id, 100);
			setPlayerDexterity(id, 100);
			setPlayerMaxMana(id, 0);
			setPlayerMana(id, 0);
			setPlayerMagicLevel(id, 0);
			setPlayerSkillWeapon(id, WEAPON_1H, 25);
			setPlayerSkillWeapon(id, WEAPON_2H, 25);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_GOVERNOR"), 1);
			giveItem(id, Items.id("ITMW_1H_VLK_DAGGER"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITAR_VLK_L"), 1);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Obywatel",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 200);
			setPlayerHealth(id, 200);
			setPlayerStrength(id, 10);
			setPlayerDexterity(id, 10);
			setPlayerMaxMana(id, 0);
			setPlayerMana(id, 0);
			setPlayerMagicLevel(id, 0);
			setPlayerSkillWeapon(id, WEAPON_1H, 20);
			setPlayerSkillWeapon(id, WEAPON_2H, 20);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_VLK_L"), 1);
			giveItem(id, Items.id("ITMW_1H_VLK_DAGGER"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITLSTORCH"), 1);
			giveItem(id, Items.id("ITAR_VLKBABE_H"), 1);
			giveItem(id, Items.id("ITFO_BACON"), 12);
		}
	},
	{
		name = "Kowal",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 500);
			setPlayerHealth(id, 500);
			setPlayerStrength(id, 40);
			setPlayerDexterity(id, 40);
			setPlayerMaxMana(id, 0);
			setPlayerMana(id, 0);
			setPlayerMagicLevel(id, 0);
			setPlayerSkillWeapon(id, WEAPON_1H, 30);
			setPlayerSkillWeapon(id, WEAPON_2H, 30);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_SMITH"), 1);
			giveItem(id, Items.id("ITMW_1H_MACE_L_04"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITLSTORCH"), 1);
			giveItem(id, Items.id("ITMISWORDRAW"), 100);
			giveItem(id, Items.id("ITFO_BACON"), 12);
		}
	},
	{
		name = "Alchemik",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 400);
			setPlayerHealth(id, 400);
			setPlayerStrength(id, 40);
			setPlayerDexterity(id, 40);
			setPlayerMaxMana(id, 0);
			setPlayerMana(id, 0);
			setPlayerMagicLevel(id, 0);
			setPlayerSkillWeapon(id, WEAPON_1H, 30);
			setPlayerSkillWeapon(id, WEAPON_2H, 30);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_SMITH"), 1);
			giveItem(id, Items.id("ITMW_1H_BAU_AXE"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITLSTORCH"), 1);
			giveItem(id, Items.id("ITFO_BACON"), 12);
			giveItem(id, Items.id("ITPO_SPEED"), 5);
			giveItem(id, Items.id("ITPL_SWAMPHERB"), 3);
			giveItem(id, Items.id("ITPL_MANA_HERB_02"), 3);
			giveItem(id, Items.id("ITPL_HEALTH_HERB_03"), 3);
			giveItem(id, Items.id("ITPL_DEX_HERB_01"), 3);
			giveItem(id, Items.id("ITPL_STRENGTH_HERB_01"), 3);
			giveItem(id, Items.id("ITPL_SPEED_HERB_01"), 3);
			giveItem(id, Items.id("ITPL_BLUEPLANT"), 3);
			giveItem(id, Items.id("ITMI_FLASK"), 5);
		}
	},
	{
		name = "Farmer",
		guild = 3,
		func = function(id){
			setPlayerMaxHealth(id, 300);
			setPlayerHealth(id, 300);
			setPlayerStrength(id, 20);
			setPlayerDexterity(id, 20);
			setPlayerMaxMana(id, 0);
			setPlayerMana(id, 0);
			setPlayerMagicLevel(id, 0);
			setPlayerSkillWeapon(id, WEAPON_1H, 30);
			setPlayerSkillWeapon(id, WEAPON_2H, 30);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_BAU_M"), 1);
			giveItem(id, Items.id("ITMW_1H_MACE_L_04"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_RAKE"), 1);
			giveItem(id, Items.id("ITMI_BROOM"), 1);
			giveItem(id, Items.id("ITMI_BRUSH"), 1);
			giveItem(id, Items.id("ITFO_BACON"), 2);
		}
	},
	{
		name = "Sêdzia",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 1600);
			setPlayerHealth(id, 1600);
			setPlayerStrength(id, 100);
			setPlayerDexterity(id, 100);
			setPlayerMaxMana(id, 0);
			setPlayerMana(id, 0);
			setPlayerMagicLevel(id, 0);
			setPlayerSkillWeapon(id, WEAPON_1H, 25);
			setPlayerSkillWeapon(id, WEAPON_2H, 25);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_JUDGE"), 1);
			giveItem(id, Items.id("ITMW_1H_VLK_DAGGER"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITAR_GOVERNOR"), 1);
			giveItem(id, Items.id("ITAR_VLK_L"), 1);
		}
	},
	{
		name = "Cienias",
		guild = 4,
		func = function(id){
			setPlayerMaxHealth(id, 300);
			setPlayerHealth(id, 300);
			setPlayerStrength(id, 60);
			setPlayerDexterity(id, 60);
			setPlayerSkillWeapon(id, WEAPON_1H, 30);
			setPlayerSkillWeapon(id, WEAPON_2H, 30);
			setPlayerSkillWeapon(id, WEAPON_BOW, 30);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 30);

			giveItem(id, Items.id("ITAR_BDT_M"), 1);
			giveItem(id, Items.id("ITMW_1H_MIL_SWORD"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 16);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITAR_LEATHER_L"), 1);
			giveItem(id, Items.id("ITLSTORCH"), 3);
			giveItem(id, Items.id("ITRW_ARROW"), 100);

			applyPlayerOverlay(id, Mds.id("HUMANS_MILITIA.MDS"));
		}
	},
	{
		name = "Bandyta",
		guild = 4,
		func = function(id){
			setPlayerMaxHealth(id, 500);
			setPlayerHealth(id, 500);
			setPlayerStrength(id, 120);
			setPlayerDexterity(id, 120);
			setPlayerSkillWeapon(id, WEAPON_1H, 60);
			setPlayerSkillWeapon(id, WEAPON_2H, 60);
			setPlayerSkillWeapon(id, WEAPON_BOW, 60);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 60);

			giveItem(id, Items.id("ITAR_BDT_H"), 1);
			giveItem(id, Items.id("ITMW_1H_MIL_SWORD"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 26);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITAR_LEATHER_L"), 1);
			giveItem(id, Items.id("ITLSTORCH"), 3);
			giveItem(id, Items.id("ITRW_BOLT"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_MILITIA.MDS"));
		}
	},
	{
		name = "Bandyta (stra¿nik)",
		guild = 4,
		func = function(id){
			setPlayerMaxHealth(id, 1000);
			setPlayerHealth(id, 1000);
			setPlayerStrength(id, 150);
			setPlayerDexterity(id, 150);
			setPlayerMaxMana(id, 250);
			setPlayerMana(id, 250);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 80);
			setPlayerSkillWeapon(id, WEAPON_2H, 80);
			setPlayerSkillWeapon(id, WEAPON_BOW, 75);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 75);

			giveItem(id, Items.id("ITAR_THORUS_ADDON"), 1);
			giveItem(id, Items.id("ITMW_1H_PAL_SWORD"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITAR_LEATHER_L"), 1);
			giveItem(id, Items.id("ITRW_BOLT"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_MILITIA.MDS"));
		}
	},
	{
		name = "Herszt bandytów",
		guild = 4,
		func = function(id){
			setPlayerMaxHealth(id, 1200);
			setPlayerHealth(id, 1200);
			setPlayerStrength(id, 200);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_RAVEN_ADDON"), 1);
			giveItem(id, Items.id("ITMW_1H_PAL_SWORD"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_H_02"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITAR_VLK_L"), 1);
			giveItem(id, Items.id("ITAR_MIL_L"), 1);
			giveItem(id, Items.id("ITRW_BOLT"), 25);
			giveItem(id, Items.id("ITSC_PALLIGHT"), 3);
			giveItem(id, Items.id("ITSC_PALLIGHTHEAL"), 3);
			giveItem(id, Items.id("ITSC_PALHOLYBOLT"), 3);
			giveItem(id, Items.id("ITRU_PALFULLHEAL"), 1);
			giveItem(id, Items.id("ITSC_FIREBOLT"), 30);

			applyPlayerOverlay(id, Mds.id("HUMANS_MILITIA.MDS"));
		}
	},
	{
		name = "Król (V0ID)",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 1600);
			setPlayerHealth(id, 1600);
			setPlayerStrength(id, 240);
			setPlayerDexterity(id, 400);
			setPlayerMaxMana(id, 1000);
			setPlayerMana(id, 1000);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_GOVERNOR"), 1);

			giveItem(id, Items.id("ITAR_BLOODWYN_ADDON"), 1);
			giveItem(id, Items.id("ITAR_BARKEEPER"), 1);
			giveItem(id, Items.id("ITAR_KDF_H"), 1);
			giveItem(id, Items.id("ITAR_RANGER_ADDON"), 1);
			giveItem(id, Items.id("ITAR_DEMENTOR"), 1);
			giveItem(id, Items.id("ITMI_INNOSEYE_MIS"), 1);
			giveItem(id, Items.id("ITRU_LIGHT"), 1);
			giveItem(id, Items.id("ITRU_FIREBOLT"), 1);
			giveItem(id, Items.id("ITRU_ICEBOLT"), 1);
			giveItem(id, Items.id("ITRU_WINDFIST"), 1);
			giveItem(id, Items.id("ITRU_SLEEP"), 1);
			giveItem(id, Items.id("ITRU_FIRERAIN"), 1);
			giveItem(id, Items.id("ITRU_INSTANTFIREBALL"), 1);
			giveItem(id, Items.id("ITPO_MANA_03"), 20);
			giveItem(id, Items.id("ITPO_SPEED"), 3);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "£uczarz",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 300);
			setPlayerHealth(id, 300);
			setPlayerStrength(id, 60);
			setPlayerDexterity(id, 60);
			setPlayerSkillWeapon(id, WEAPON_1H, 30);
			setPlayerSkillWeapon(id, WEAPON_2H, 30);
			setPlayerSkillWeapon(id, WEAPON_BOW, 30);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 30);

			giveItem(id, Items.id("ITAR_LEATHER_L"), 2);
			giveItem(id, Items.id("ITMW_1H_MIL_SWORD"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 16);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITLSTORCH"), 3);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITRW_ARROW"), 1000);
			giveItem(id, Items.id("ITRW_BOLT"), 1000);
			giveItem(id, Items.id("ITRW_BOW_H_01"), 1);
			giveItem(id, Items.id("ITRW_BOW_H_02"), 1);
			giveItem(id, Items.id("ITRW_BOW_H_03"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_01"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_02"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_03"), 1);
			giveItem(id, Items.id("ITRW_SLD_BOW"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_H_01"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_H_02"), 1);
			giveItem(id, Items.id("ITRW_MIL_CROSSBOW"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_M_02"), 1);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Genera³",
		guild = 1,
		func = function(id){
			setPlayerMaxHealth(id, 1300);
			setPlayerHealth(id, 1300);
			setPlayerStrength(id, 200);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 1000);
			setPlayerMana(id, 1000);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_OREBARON_ADDON"), 1);
			giveItem(id, Items.id("ITMW_1H_BLESSED_02"), 1);

			giveItem(id, Items.id("ITAR_PAL_H"), 1);
			giveItem(id, Items.id("ITAR_BARKEEPER"), 1);
			giveItem(id, Items.id("ITRU_LIGHT"), 1);
			giveItem(id, Items.id("ITRU_ICEBOLT"), 1);
			giveItem(id, Items.id("ITRU_WINDFIST"), 1);
			giveItem(id, Items.id("ITAR_DEMENTOR"), 1);
			giveItem(id, Items.id("ITPO_MANA_03"), 20);
			giveItem(id, Items.id("ITRU_INSTANTFIREBALL"), 1);
			giveItem(id, Items.id("ITPO_SPEED"), 3);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Pacho³ek cienia",
		guild = 5,
		func = function(id){
			setPlayerMaxHealth(id, 300);
			setPlayerHealth(id, 300);
			setPlayerStrength(id, 35);
			setPlayerDexterity(id, 35);
			setPlayerMaxMana(id, 200);
			setPlayerMana(id, 200);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 20);
			setPlayerSkillWeapon(id, WEAPON_2H, 20);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_LESTER"), 1);
			giveItem(id, Items.id("ITMW_1H_SWORD_L_03"), 1);

			giveItem(id, Items.id("ITRU_FIREBOLT"), 1);
			giveItem(id, Items.id("ITRU_ZAP"), 1);
			giveItem(id, Items.id("ITFO_FISH"), 1);
			giveItem(id, Items.id("ITFO_APPLE"), 1);
			giveItem(id, Items.id("ITFO_WATER"), 1);
			giveItem(id, Items.id("ITPO_PERM_MANA"), 20);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Cz³onek bractwa",
		guild = 5,
		func = function(id){
			setPlayerMaxHealth(id, 400);
			setPlayerHealth(id, 400);
			setPlayerStrength(id, 60);
			setPlayerDexterity(id, 70);
			setPlayerMaxMana(id, 200);
			setPlayerMana(id, 200);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 40);
			setPlayerSkillWeapon(id, WEAPON_2H, 40);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_MAYAZOMBIE_ADDON"), 1);
			giveItem(id, Items.id("ITMW_HELLEBARDE"), 1);

			giveItem(id, Items.id("ITRU_FIREBOLT"), 1);
			giveItem(id, Items.id("ITRU_ZAP"), 1);
			giveItem(id, Items.id("ITRU_WINDFIST"), 1);
			giveItem(id, Items.id("ITMI_JOINT"), 3);
			giveItem(id, Items.id("ITFO_SAUSAGE"), 1);
			giveItem(id, Items.id("ITFO_WATER"), 1);
			giveItem(id, Items.id("ITFO_FISH"), 1);
			giveItem(id, Items.id("ITFO_APPLE"), 1);
			giveItem(id, Items.id("ITFO_WATER"), 1);
			giveItem(id, Items.id("ITPO_PERM_MANA"), 20);
			giveItem(id, Items.id("ITPO_PERM_HEALTH"), 20);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Wojownik mroku",
		guild = 5,
		func = function(id){
			setPlayerMaxHealth(id, 700);
			setPlayerHealth(id, 700);
			setPlayerStrength(id, 100);
			setPlayerDexterity(id, 80);
			setPlayerMaxMana(id, 800);
			setPlayerMana(id, 800);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 60);
			setPlayerSkillWeapon(id, WEAPON_2H, 60);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_CORANGAR"), 1);
			giveItem(id, Items.id("ITMW_2H_ORCAXE_03"), 1);

			giveItem(id, Items.id("ITRU_FIREBOLT"), 1);
			giveItem(id, Items.id("ITRU_ZAP"), 1);
			giveItem(id, Items.id("ITRU_WINDFIST"), 1);
			giveItem(id, Items.id("ITRU_LIGHTHEAL"), 1);
			giveItem(id, Items.id("ITRU_FIRESTORM"), 1);
			giveItem(id, Items.id("ITRU_ICECUBE"), 1);
			giveItem(id, Items.id("ITMI_JOINT"), 3);
			giveItem(id, Items.id("ITFO_SAUSAGE"), 1);
			giveItem(id, Items.id("ITFO_WATER"), 1);
			giveItem(id, Items.id("ITFO_FISH"), 1);
			giveItem(id, Items.id("ITFO_APPLE"), 1);
			giveItem(id, Items.id("ITFO_WATER"), 1);
			giveItem(id, Items.id("ITPO_PERM_MANA"), 20);
			giveItem(id, Items.id("ITPO_PERM_HEALTH"), 20);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Nekromanta",
		guild = 5,
		func = function(id){
			setPlayerMaxHealth(id, 1000);
			setPlayerHealth(id, 1000);
			setPlayerStrength(id, 80);
			setPlayerDexterity(id, 80);
			setPlayerMaxMana(id, 1200);
			setPlayerMana(id, 1200);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 0);
			setPlayerSkillWeapon(id, WEAPON_2H, 0);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_XARDAS"), 1);

			giveItem(id, Items.id("ITRU_TELEPORTXARDAS"), 1);
			giveItem(id, Items.id("ITRU_PYROKINESIS"), 1);
			giveItem(id, Items.id("ITSC_PALHOLYBOLT"), 1);
			giveItem(id, Items.id("ITSC_PALREPELEVIL"), 1);
			giveItem(id, Items.id("ITFO_FISH"), 1);
			giveItem(id, Items.id("ITFO_APPLE"), 1);
			giveItem(id, Items.id("ITPO_PERM_MANA"), 20);
			giveItem(id, Items.id("ITPO_PERM_HEALTH"), 20);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Cieñ",
		guild = 5,
		func = function(id){
			setPlayerMaxHealth(id, 1100);
			setPlayerHealth(id, 1100);
			setPlayerStrength(id, 120);
			setPlayerDexterity(id, 80);
			setPlayerMaxMana(id, 1200);
			setPlayerMana(id, 1200);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 80);
			setPlayerSkillWeapon(id, WEAPON_2H, 80);
			setPlayerSkillWeapon(id, WEAPON_BOW, 0);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 0);

			giveItem(id, Items.id("ITAR_DEMENTOR"), 1);

			giveItem(id, Items.id("ITRU_TELEPORTXARDAS"), 1);
			giveItem(id, Items.id("ITRU_PYROKINESIS"), 1);
			giveItem(id, Items.id("ITSC_PALHOLYBOLT"), 1);
			giveItem(id, Items.id("ITSC_PALREPELEVIL"), 1);
			giveItem(id, Items.id("ITRU_ICEWAVE"), 1);
			giveItem(id, Items.id("ITRU_SLEEP"), 1);
			giveItem(id, Items.id("ITFO_FISH"), 1);
			giveItem(id, Items.id("ITFO_APPLE"), 1);
			giveItem(id, Items.id("ITPO_PERM_MANA"), 20);
			giveItem(id, Items.id("ITPO_PERM_HEALTH"), 20);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Kap³an",
		guild = 5,
		func = function(id){
			setPlayerMaxHealth(id, 1300);
			setPlayerHealth(id, 1300);
			setPlayerStrength(id, 160);
			setPlayerDexterity(id, 160);
			setPlayerMaxMana(id, 2000);
			setPlayerMana(id, 2000);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 100);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 100);

			giveItem(id, Items.id("ITAR_DJG_H"), 1);
			giveItem(id, Items.id("ITMW_2H_SPECIAL_02"), 1);
			giveItem(id, Items.id("ITRW_BOW_H_01"), 1);

			giveItem(id, Items.id("ITRU_TELEPORTXARDAS"), 1);
			giveItem(id, Items.id("ITRU_PYROKINESIS"), 1);
			giveItem(id, Items.id("ITSC_PALHOLYBOLT"), 1);
			giveItem(id, Items.id("ITSC_PALREPELEVIL"), 1);
			giveItem(id, Items.id("ITRU_ICEWAVE"), 1);
			giveItem(id, Items.id("ITRU_FULLHEAL"), 1);
			giveItem(id, Items.id("ITRU_HARMUNDEAD"), 1);
			giveItem(id, Items.id("ITRU_FIRERAIN"), 1);
			giveItem(id, Items.id("ITPO_SPEED"), 10);
			giveItem(id, Items.id("ITAT_DRAGONBLOOD"), 1);
			giveItem(id, Items.id("ITAR_VLKBABE_M"), 1);
			giveItem(id, Items.id("ITAR_VLK_M"), 1);
			giveItem(id, Items.id("ITMI_RUNEBLANK"), 1);
			giveItem(id, Items.id("ITMI_JOINT"), 20);
			giveItem(id, Items.id("ITAT_DEMONHEART"), 1);
			giveItem(id, Items.id("ITAT_GOBLINBONE"), 1);
			giveItem(id, Items.id("ITRW_ARROW"), 100);
			giveItem(id, Items.id("ITFO_BREAD"), 1);
			giveItem(id, Items.id("ITFO_MILK"), 1);
			giveItem(id, Items.id("ITFOMUTTONRAW"), 1);
			giveItem(id, Items.id("ITFO_FISH"), 1);
			giveItem(id, Items.id("ITFO_APPLE"), 1);
			giveItem(id, Items.id("ITPO_PERM_MANA"), 20);
			giveItem(id, Items.id("ITPO_PERM_HEALTH"), 20);

			applyPlayerOverlay(id, Mds.id("HUMANS_MAGE.MDS"));
		}
	},
	{
		name = "Lord Kossak",
		guild = 6,
		func = function(id){
			setPlayerMaxHealth(id, 1500);
			setPlayerHealth(id, 1500);
			setPlayerStrength(id, 200);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_PAL_SKEL"), 1);
			giveItem(id, Items.id("ITMW_MEISTERDEGEN"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITAT_DRGSNAPPERHORN"), 1);
			giveItem(id, Items.id("ITAR_GOVERNOR"), 1);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Prawa rêka (Kossak)",
		guild = 6,
		func = function(id){
			setPlayerMaxHealth(id, 1000);
			setPlayerHealth(id, 1000);
			setPlayerStrength(id, 150);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 60);
			setPlayerSkillWeapon(id, WEAPON_2H, 60);
			setPlayerSkillWeapon(id, WEAPON_BOW, 60);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 60);

			giveItem(id, Items.id("ITAR_DJG_CRAWLER"), 1);
			giveItem(id, Items.id("ITMW_2H_ORCAXE_04"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_H_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITAT_WOLFFUR"), 10);
			giveItem(id, Items.id("ITAT_SHADOWHORN"), 1);
			giveItem(id, Items.id("ITRW_BOLT"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "¯o³nierz (Kossak)",
		guild = 6,
		func = function(id){
			setPlayerMaxHealth(id, 750);
			setPlayerHealth(id, 750);
			setPlayerStrength(id, 75);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 35);
			setPlayerSkillWeapon(id, WEAPON_2H, 35);
			setPlayerSkillWeapon(id, WEAPON_BOW, 35);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 35);

			giveItem(id, Items.id("ITAR_BLOODWYN_ADDON"), 1);
			giveItem(id, Items.id("ITMW_2H_ORCAXE_02"), 1);
			giveItem(id, Items.id("ITRW_CROSSBOW_M_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITAT_WOLFFUR"), 10);
			giveItem(id, Items.id("ITAT_TEETH"), 10);
			giveItem(id, Items.id("ITRW_BOLT"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Farmer (Kossak)",
		guild = 6,
		func = function(id){
			setPlayerMaxHealth(id, 500);
			setPlayerHealth(id, 500);
			setPlayerStrength(id, 75);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 35);
			setPlayerSkillWeapon(id, WEAPON_2H, 35);
			setPlayerSkillWeapon(id, WEAPON_BOW, 35);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 35);

			giveItem(id, Items.id("ITAR_PRISONER"), 1);
			giveItem(id, Items.id("ITMW_1H_MISC_AXE"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITMI_BROOM"), 1);
			giveItem(id, Items.id("ITAT_TEETH"), 10);
			giveItem(id, Items.id("ITRW_ARROW"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Lord Randall",
		guild = 7,
		func = function(id){
			setPlayerMaxHealth(id, 1600);
			setPlayerHealth(id, 1600);
			setPlayerStrength(id, 200);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 100);
			setPlayerSkillWeapon(id, WEAPON_2H, 100);
			setPlayerSkillWeapon(id, WEAPON_BOW, 80);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 80);

			giveItem(id, Items.id("ITAR_RAVEN_ADDON"), 1);
			giveItem(id, Items.id("ITMW_KRIEGSHAMMER2"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITRU_PALLIGHT"), 1);
			giveItem(id, Items.id("ITAR_GOVERNOR"), 1);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Prawa rêka (Randall)",
		guild = 7,
		func = function(id){
			setPlayerMaxHealth(id, 1000);
			setPlayerHealth(id, 1000);
			setPlayerStrength(id, 150);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 60);
			setPlayerSkillWeapon(id, WEAPON_2H, 60);
			setPlayerSkillWeapon(id, WEAPON_BOW, 60);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 60);

			giveItem(id, Items.id("ITAR_CORANGAR"), 1);
			giveItem(id, Items.id("ITMW_FOLTERAXT"), 1);
			giveItem(id, Items.id("ITRW_BOW_H_03"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITAT_WOLFFUR"), 10);
			giveItem(id, Items.id("ITMI_GOLDCUP"), 1);
			giveItem(id, Items.id("ITRW_ARROW"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "¯o³nierz (Randall)",
		guild = 7,
		func = function(id){
			setPlayerMaxHealth(id, 750);
			setPlayerHealth(id, 750);
			setPlayerStrength(id, 75);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 35);
			setPlayerSkillWeapon(id, WEAPON_2H, 35);
			setPlayerSkillWeapon(id, WEAPON_BOW, 35);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 35);

			giveItem(id, Items.id("ITAR_RANGER_ADDON"), 1);
			giveItem(id, Items.id("ITMW_KRUMMSCHWERT"), 1);
			giveItem(id, Items.id("ITRW_BOW_H_02"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITAT_WOLFFUR"), 10);
			giveItem(id, Items.id("ITMI_SILVERCUP"), 1);
			giveItem(id, Items.id("ITRW_ARROW"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Farmer (Randall)",
		guild = 7,
		func = function(id){
			setPlayerMaxHealth(id, 500);
			setPlayerHealth(id, 500);
			setPlayerStrength(id, 75);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 35);
			setPlayerSkillWeapon(id, WEAPON_2H, 35);
			setPlayerSkillWeapon(id, WEAPON_BOW, 35);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 35);

			giveItem(id, Items.id("ITAR_BARKEEPER"), 1);
			giveItem(id, Items.id("ITMW_1H_SWORD_L_03"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITMI_BROOM"), 1);
			giveItem(id, Items.id("ITAT_TEETH"), 10);
			giveItem(id, Items.id("ITRW_ARROW"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Uczony (Kossak)",
		guild = 6,
		func = function(id){
			setPlayerMaxHealth(id, 500);
			setPlayerHealth(id, 500);
			setPlayerStrength(id, 75);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 35);
			setPlayerSkillWeapon(id, WEAPON_2H, 35);
			setPlayerSkillWeapon(id, WEAPON_BOW, 35);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 35);

			giveItem(id, Items.id("ITAR_VLK_H"), 1);
			giveItem(id, Items.id("ITMW_KRIEGSKEULE"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITMI_BROOM"), 1);
			giveItem(id, Items.id("ITAT_TEETH"), 10);
			giveItem(id, Items.id("ITMI_GOLDNECKLACE"), 1);
			giveItem(id, Items.id("ITRW_ARROW"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	},
	{
		name = "Uczony (Randall)",
		guild = 7,
		func = function(id){
			setPlayerMaxHealth(id, 500);
			setPlayerHealth(id, 500);
			setPlayerStrength(id, 75);
			setPlayerDexterity(id, 200);
			setPlayerMaxMana(id, 500);
			setPlayerMana(id, 500);
			setPlayerMagicLevel(id, 6);
			setPlayerSkillWeapon(id, WEAPON_1H, 35);
			setPlayerSkillWeapon(id, WEAPON_2H, 35);
			setPlayerSkillWeapon(id, WEAPON_BOW, 35);
			setPlayerSkillWeapon(id, WEAPON_CBOW, 35);

			giveItem(id, Items.id("ITAR_JUDGE"), 1);
			giveItem(id, Items.id("ITMW_1H_VLK_SWORD"), 1);
			giveItem(id, Items.id("ITRW_BOW_L_01"), 1);

			giveItem(id, Items.id("ITMI_JOINT"), 6);
			giveItem(id, Items.id("ITFO_APPLE"), 2);
			giveItem(id, Items.id("ITFO_WINE"), 10);
			giveItem(id, Items.id("ITMI_LUTE"), 1);
			giveItem(id, Items.id("ITMI_SEXTANT"), 1);
			giveItem(id, Items.id("ITMI_BROOM"), 1);
			giveItem(id, Items.id("ITAT_TEETH"), 10);
			giveItem(id, Items.id("ITMI_GOLDNECKLACE"), 1);
			giveItem(id, Items.id("ITRW_ARROW"), 25);

			applyPlayerOverlay(id, Mds.id("HUMANS_RELAXED.MDS"));
		}
	}
]