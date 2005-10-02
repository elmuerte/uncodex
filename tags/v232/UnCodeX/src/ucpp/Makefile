DCUOUT = ../../dcu/ucpp/
BINOUT = .

all:
	ppc386 -Mdelphi -Xs -XD -XX -O3 -Op3 -Fu../ -Fu. -FE$(BINOUT) -FU$(DCUOUT) ucpp.dpr

debug:
	ppc386 -Mdelphi -Fu../ -Fu. -FE$(BINOUT) -FU$(DCUOUT) -dDEBUG_BUILD -gh -gl ucpp.dpr

clean:
	rm $(DCUOUT)*.o
	rm $(DCUOUT)*.ppu
