{*******************************************************************************
    Name:
        defines.inc
    Author(s):
        Michiel 'El Muerte' Hendriks
    Purpose:
        Global macro file, to be included by means of ($I defines.inc)

    $Id: defines.inc,v 1.11 2005-04-12 08:31:48 elmuerte Exp $
*******************************************************************************}

{$IFDEF VER140} // delphi 6
    {$DEFINE IS_DELPHI}
{$ENDIF}

{$IFDEF LINUX}
    {$DEFINE UNIX}
{$ENDIF}

{$IFDEF FPC}
    {$DEFINE CONSOLE}
	{$IFDEF LINUX}
    {$THREADING ON}
	{$ENDIF}
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

// add pascalscript support for HTML Output
//{ $DEFINE HTMLOUT_PASCALSCRIPT} //not yet

// enables compression for HTML output
{$DEFINE WITH_ZLIB}


{$IFDEF FPC}
  {$IFDEF DEBUG_BUILD}
    {$DEFINE FPC_HEAPTRC}
  {$ENDIF}
  // Defined(FPC) is required because Delphi 6 still tries to evaluate the if statement. 
  {$IF Defined(FPC) and (FPC_VERSION <= 1.0) and (FPC_RELEASE <= 9.0) and (FPC_PATCH < 8.0) }
    // BinToHex() functions have been added in 1.9.8
    {$DEFINE FPC_NO_BINHEXCONV}
  {$IFEND}
{$ENDIF}