{*******************************************************************************
    Name:
        defines.inc
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        Global macro file, to be included by means of ($I defines.inc)

    $Id: defines.inc,v 1.5 2004-12-19 12:34:56 elmuerte Exp $
*******************************************************************************}

{$IFDEF VER140} // delphi 6
  {$DEFINE IS_DELPHI}
{$ENDIF}

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

{$IFDEF IS_DELPHI}
  {$IFDEF DEBUG_BUILD}
    {$DESCRIPTION 'UnCodeX Debug build'}

    {$DEFINE DETECT_MEM_LEAK}

    {$O-} // no optimization
    {$W+} // build with stack frames
    {$R-} // range checking
    {$I+} // I/O checking
    {$Q-} // overflow checking
    {$D+} // debug
    {$L+} // local symbols
    {$Y+} // reference info
    {$C+} // assertions
  {$ELSE}
    {$O+} // no optimization
    {$W-} // build with stack frames
    {$R-} // range checking
    {$I+} // I/O checking
    {$Q-} // overflow checking
    {$D-} // debug
    {$L-} // local symbols
    {$Y-} // reference info
    {$C-} // assertions
  {$ENDIF}
{$ENDIF}