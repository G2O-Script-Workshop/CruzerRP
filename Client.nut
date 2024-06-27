local server_name = Draw(5200, 7500, "Cruzer RolePlay");
local website = Draw(6000, 0, "http://cruzer-rp.y0.pl");

server_name.font = "FONT_OLD_20_WHITE_HI.TGA";
server_name.setColor(255, 143, 0);
website.font = "FONT_OLD_10_WHITE_HI.TGA";
website.setColor(142, 35, 35);

addEventHandler("onInit", function(){
	clearMultiplayerMessages();
	setKeyLayout(1);
	enable_NicknameId(true);

	server_name.visible = true;
	website.visible = true;

	setFreeze(true);
});

addEventHandler("onExit", function(){
	server_name.visible = false;
	website.visible = false;
});

addEventHandler("onPacket", function(packet){
	local packetId = packet.readUInt8();
	if(packetId == 1){
		local colors = [{r = 0, g = 255, b = 0}, {r = 255, g = 143, b = 0}, {r = 30, g = 144, b = 255}, {r = 123, g = 104, b = 238}, {r = 255, g = 64, b = 64}, {r = 255, g = 127, b = 36}];
		local color_rand = (rand() % colors.len());

		server_name.setColor(colors[color_rand].r, colors[color_rand].g, colors[color_rand].b);
	}
	else if(packetId == 2){
		clearInventory();
		local packet = Packet();
		packet.writeUInt8(3);
		packet.send(RELIABLE);
	}
	else if(packetId == 4){
		setFreeze(false);
	}
});