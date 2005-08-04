               ____ ___ _________  __________ __________
              |    |   \\_   ___ \ \______   \\______   \
              |    |   //    \  \/  |     ___/ |     ___/
              |    |  / \     \____ |    |     |    |
              |______/   \______  / |____|     |____| UCPP
                                \/                    v1.3

                       Thursday, August 04, 2005
                      Michiel "El Muerte" Hendriks
                      <elmuerte@drunksnipers.com>
------------------------------------------------------------------------

UnrealScript Class PreProcessor (UCPP) is a commandline utility intended 
to be executed before ucc make. It adds some preprocessor features that 
are not available in the standard UnrealScript compiler in UnrealEngine1 
and UnrealEngine2.

Features include conditional compiling directives but also definition 
replacements and function definitions. Most of the preprocessor 
directives found in most C\C++ compilers are supported.

More information and documentation about this tool can be found on the
UnrealWiki:
	http://wiki.beyondunreal.com/wiki/UCPP

------------------------------------------------------------------------

Changes since version 1.2

Changed:
- You can now use relative paths in SYSTEM or BASE, for example SYSTEM=. 
  will assume that the current directory is the system directory (in 
  case you didn't know "." is the current directory and ".." is the 
  parent directory).

Added:
- the notice messages inserted by '#ucpp notice' can now be configured
  in the ini file: "noticeMessage" in the section [Options]
- new directive "#ucpp rename filename" this will rename the resulting 
  file to "filename". Note: filename is relative to the input filename.
  This way to can also generate include files through UCPP to be used by
  the UnrealEngine's #include directive.
- you can now import environment variables by adding the commandline
  argument "-env", all environment variables will be important and can
  be used as normal defines. All environment variables are defined as a
  string.
- added 2 new builtin functions to be used in an #if expression:
  strcmp/2 and stricmp/2
  strcmp returns 0 if the strings are equal, stricmp is case 
  insensitive. For example:
	#define TEST1 "Hello World"
	#if strcmp(TEST1, "Hello World") == 0
		this is true
	#endif
	#define TEST2 "Hello World"
	#if strcmp(TEST2, "hello world") == 0
		this is false, use stricmp/2 for this
	#endif
	#define TEST3 Hello World
	#if strcmp(TEST3, "Hello World") == 0
		this is false
	#endif
	#define TEST4 1234
	#if strcmp(TEST4, 1234) == 0
		this is true, it's a side effect
	#endif

Changes since version 1.1

Bug fixes:
- conditionals with defines are sometimes not parsed correctly. The 
  following example whould not compile correctly when DEBUG wasn't 
  true.
	#if DEBUG
		#define TEST(a) LOG(a)
	#else
		#define TEST(a)
	#endif
- fixed a cosmetic bug where too many comment marks where added before 
  a line after a conditional directive

Changes since version 1.0

Bug fixes:
- the line after a single line comment wasn't commented out when needed
- #ucpp directives where always processed, even when they shouldn't
- incorrect string formatting caused wrong error messages
- UCPP_VERSION is now a proper integer again (like: v1.1 -> 101; 
  v1.12 -> 112; etc.)

Added:
- commandline argument '-q' to only show errors and warnings

------------------------------------------------------------------------