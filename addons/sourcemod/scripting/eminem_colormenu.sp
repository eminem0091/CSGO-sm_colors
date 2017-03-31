// SourceMod 1.7+
#include <sourcemod>
#include <clientprefs>
#include <multicolors>

#pragma semicolon 1

#define PLUGIN_VERSION "1.1"

Handle gH_Cookie = INVALID_HANDLE;

public Plugin:myinfo = 
{
	name = "[CS:GO] Chat colors",
	author = "shavit, EMINEM",
	description = "Provides a menu with the option to change your chat color.",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net/member.php?u=163134"
}

public void OnPluginStart()
{
	gH_Cookie = RegClientCookie("sm_chatcolors_cookie", "Contains the used chat color", CookieAccess_Protected);

	CreateConVar("sm_csgochatcolors_version", PLUGIN_VERSION, "Plugin version", FCVAR_PLUGIN|FCVAR_DONTRECORD|FCVAR_NOTIFY);

	RegAdminCmd("sm_colors", Command_Colors, ADMFLAG_RESERVATION, "Pops up the colors menu");
}

public Action Command_Colors(int client, int args)
{
	Handle hMenu = CreateMenu(MenuHandler_Colors, MENU_ACTIONS_ALL);
	SetMenuTitle(hMenu, "Select a chat color:");

	AddMenuItem(hMenu, "none", "Default");
	AddMenuItem(hMenu, "\x03", "Týmová barva"); //Team color
	AddMenuItem(hMenu, "\x04", "Zelená"); //Green
	AddMenuItem(hMenu, "\x08", "Šedá"); //Grey
	AddMenuItem(hMenu, "\x0D", "Šedá2"); //Grey2
	AddMenuItem(hMenu, "\x0A", "Modro-šedá"); //Blue grey
	AddMenuItem(hMenu, "\x0B", "Světle modrá"); //Light blue
	AddMenuItem(hMenu, "\x0C", "Tmavě modrá"); //Dark blue
	AddMenuItem(hMenu, "\x07", "Světle červená"); //Light red
	AddMenuItem(hMenu, "\x0F", "Světle červená2"); //Light red2	
	AddMenuItem(hMenu, "\x02", "Tmavě červená"); //Dark red
	AddMenuItem(hMenu, "\x06", "Limetková"); //Lime
	AddMenuItem(hMenu, "\x05", "Olivová"); //Olive	
	AddMenuItem(hMenu, "\x09", "Oranžová"); //Orange
	AddMenuItem(hMenu, "\x0E", "Fialová"); //Orchid

	SetMenuExitButton(hMenu, true);

	DisplayMenu(hMenu, client, 20);

	return Plugin_Handled;
}

public int MenuHandler_Colors(Handle hMenu, MenuAction maAction, int client, int choice)
{
	if(maAction == MenuAction_Select)
	{
		char sChoice[8];
		GetMenuItem(hMenu, choice, sChoice, 8);

		SetClientCookie(client, gH_Cookie, sChoice);

		if(StrEqual(sChoice, "none"))
		{
			FormatEx(sChoice, 8, "\x01");
		}

		if(StrEqual(sChoice, "\x03"))
		{
			PrintToChat(client, "[\x0BTvůj portál ? Colors\x01] Barva tvého psaní bude stejná jako barva tvého týmu.");
		}

		else
		{
			PrintToChat(client, "[\x0BTvůj portál ? Colors\x01] Vybral sis %stuto barvu\x01.", sChoice);
		}
	}

	else if(maAction == MenuAction_End)
	{
		CloseHandle(hMenu);
	}
}

public Action OnChatMessage(int &client, Handle hRecipients, char[] sName, char[] sMessage)
{
	if(CheckCommandAccess(client, "sm_colors", ADMFLAG_RESERVATION))
	{
		char sCookie[8];
		GetClientCookie(client, gH_Cookie, sCookie, 8);

		if(StrEqual(sCookie, "") || StrEqual(sCookie, "none"))
		{
			return Plugin_Continue;
		}

		Format(sMessage, 256, "%s%s", sCookie, sMessage);

		return Plugin_Changed;
	}

	return Plugin_Continue;
}
