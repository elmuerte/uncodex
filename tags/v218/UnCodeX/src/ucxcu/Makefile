DCUOUT="../../dcu/ucxcu/"

.PHONY : all
all:
	ppc386 -S2dg -O2p3 -Xs -XD -vewi -l -Fu../ -Fu. -FE${DCUOUT} -o../../bin/ucxcu ucxcu.dpr

.PHONY : debug
debug:
	ppc386 -S2dg -O2p3 -Xs -XD -vewi -l -Fu../ -Fu. -FE${DCUOUT} -o../../bin/ucxcu -dDEBUG_BUILD ucxcu.dpr

.PHONY : clean
clean:
	rm ${DCUOUT}*.o
	rm ${DCUOUT}*.ppu
