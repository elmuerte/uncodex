{*******************************************************************************
    Name:
        defines.inc
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        Global macro file, to be included by means of ($I defines.inc)

    $Id: defines.inc,v 1.4 2004-11-22 13:17:41 elmuerte Exp $
*******************************************************************************}

{$IFDEF LINUX}
    {$DEFINE UNIX}
{$ENDIF}

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