DCUOUT = ../../dcu/ucxcu/
BINOUT = ../../bin/

ifndef OS
FPCPATH = -Fu../../../PascalScript-svn/Source -Fi../../../PascalScript-svn/Source
else
FPCPATH = -Fu"C:\Program Files\RemObjects Software\Pascal Script for Delphi\Source" -Fi"C:\Program Files\RemObjects Software\Pascal Script for Delphi\Source"
endif

all:
	ppc386 -Mdelphi -Xs -XD -XX -O3 -Op3 -Fu../ -Fu. -Fu../paszlib $(FPCPATH) -FE$(BINOUT) -FU$(DCUOUT) ucxcu.dpr

debug:
	ppc386 -Mdelphi -Fu../ -Fu. -Fu../paszlib $(FPCPATH) -FE$(BINOUT) -FU$(DCUOUT) -dDEBUG_BUILD -gh -gl ucxcu.dpr

clean:
	rm $(DCUOUT)*.o
	rm $(DCUOUT)*.ppu
