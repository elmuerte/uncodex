DCUOUT="../../dcu/ucxcu/"
BINOUT="../../bin/"

.PHONY : all
all:
	ppc386 -S2dg -O2p3 -Xs -XD -vewi -l -Fu../ -Fu. -FE${DCUOUT} ucxcu.dpr
	mv ${DCUOUT}ucxcu ${BINOUT}

.PHONY : debug
debug:
	ppc386 -S2dg -O2p3 -Xs -XD -vewi -l -Fu../ -Fu. -FE${DCUOUT} -dDEBUG_BUILD ucxcu.dpr
	mv ${DCUOUT}ucxcu ${BINOUT}

.PHONY : clean
clean:
	rm ${DCUOUT}*.o
	rm ${DCUOUT}*.ppu
