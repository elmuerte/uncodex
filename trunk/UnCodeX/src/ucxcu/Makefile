DCUOUT=../../dcu/ucxcu/
BINOUT=../../bin/

ifeq ($(strip $(shell uname)),Linux)
	FPCPATH=-Fu../../../PascalScript-svn/Source -Fi../../../PascalScript-svn/Source
else
	FPCPATH=-Fu"C:\Program Files\RemObjects Software\Pascal Script for Delphi\Source" -Fi"C:\Program Files\RemObjects Software\Pascal Script for Delphi\Source"
endif

FPCOPT=-Mdelphi -Xs -XD -O3 -Op3

all:
	ppc386 $(FPCOPT) -Fu../ -Fu. $(FPCPATH) -FE$(BINOUT) -FU$(DCUOUT) ucxcu.dpr

debug:
	ppc386 $(FPCOPT) -Fu../ -Fu. $(FPCPATH) -FE$(BINOUT) -FU$(DCUOUT) -dDEBUG_BUILD ucxcu.dpr

clean:
	rm $(DCUOUT)*.o
	rm $(DCUOUT)*.ppu
