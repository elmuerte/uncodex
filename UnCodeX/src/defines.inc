{*******************************************************************************
	Name:
        defines.inc
	Author(s):
		Michiel 'El Muerte' Hendriks
	Purpose:
        Global macro file, to be included by means of ($I defines.inc)

    $Id: defines.inc,v 1.2 2004-10-18 15:36:06 elmuerte Exp $
*******************************************************************************}

{$IFDEF FPC}
	{$DEFINE CONSOLE}
{$ENDIF}


{$IFDEF CONSOLE}
	// Console Application
	{$DEFINE NO_EXPORT}
	{$DEFINE DONT_SAVE_KEYWORDS}
{$ELSE}
	// GUI application
	{$DEFINE USE_TREEVIEW}
{$ENDIF}