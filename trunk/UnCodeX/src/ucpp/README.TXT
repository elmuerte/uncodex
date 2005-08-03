               ____ ___ _________  __________ __________
              |    |   \\_   ___ \ \______   \\______   \
              |    |   //    \  \/  |     ___/ |     ___/
              |    |  / \     \____ |    |     |    |
              |______/   \______  / |____|     |____| UCPP
                                \/                    v1.2

                       Wednesday, August 03, 2005
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