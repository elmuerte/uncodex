{*******************************************************************************
    Name:
        defines.inc
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        Global macro file, to be included by means of ($I defines.inc)

    $Id: defines.inc,v 1.3 2004-10-20 14:19:27 elmuerte Exp $
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