#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=cof
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/ex3.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/ex3.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1472/ex3.o ${OBJECTDIR}/_ext/1472/delay.o ${OBJECTDIR}/_ext/1472/funcoes.o ${OBJECTDIR}/_ext/1472/timer0.o ${OBJECTDIR}/_ext/1472/math.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1472/ex3.o.d ${OBJECTDIR}/_ext/1472/delay.o.d ${OBJECTDIR}/_ext/1472/funcoes.o.d ${OBJECTDIR}/_ext/1472/timer0.o.d ${OBJECTDIR}/_ext/1472/math.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1472/ex3.o ${OBJECTDIR}/_ext/1472/delay.o ${OBJECTDIR}/_ext/1472/funcoes.o ${OBJECTDIR}/_ext/1472/timer0.o ${OBJECTDIR}/_ext/1472/math.o


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
	${MAKE} ${MAKE_OPTIONS} -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/ex3.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=16f628a
MP_LINKER_DEBUG_OPTION=
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1472/ex3.o: ../ex3.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/ex3.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/ex3.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/ex3.lst\" -e\"${OBJECTDIR}/_ext/1472/ex3.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/ex3.o\" \"../ex3.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/ex3.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/ex3.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/_ext/1472/delay.o: ../delay.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/delay.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/delay.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/delay.lst\" -e\"${OBJECTDIR}/_ext/1472/delay.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/delay.o\" \"../delay.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/delay.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/delay.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/_ext/1472/funcoes.o: ../funcoes.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/funcoes.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/funcoes.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/funcoes.lst\" -e\"${OBJECTDIR}/_ext/1472/funcoes.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/funcoes.o\" \"../funcoes.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/funcoes.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/funcoes.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/_ext/1472/timer0.o: ../timer0.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/timer0.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/timer0.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/timer0.lst\" -e\"${OBJECTDIR}/_ext/1472/timer0.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/timer0.o\" \"../timer0.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/timer0.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/timer0.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/_ext/1472/math.o: ../math.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/math.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/math.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG  -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/math.lst\" -e\"${OBJECTDIR}/_ext/1472/math.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/math.o\" \"../math.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/math.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/math.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/_ext/1472/ex3.o: ../ex3.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/ex3.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/ex3.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/ex3.lst\" -e\"${OBJECTDIR}/_ext/1472/ex3.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/ex3.o\" \"../ex3.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/ex3.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/ex3.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/_ext/1472/delay.o: ../delay.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/delay.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/delay.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/delay.lst\" -e\"${OBJECTDIR}/_ext/1472/delay.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/delay.o\" \"../delay.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/delay.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/delay.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/_ext/1472/funcoes.o: ../funcoes.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/funcoes.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/funcoes.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/funcoes.lst\" -e\"${OBJECTDIR}/_ext/1472/funcoes.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/funcoes.o\" \"../funcoes.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/funcoes.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/funcoes.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/_ext/1472/timer0.o: ../timer0.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/timer0.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/timer0.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/timer0.lst\" -e\"${OBJECTDIR}/_ext/1472/timer0.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/timer0.o\" \"../timer0.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/timer0.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/timer0.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/_ext/1472/math.o: ../math.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} ${OBJECTDIR}/_ext/1472 
	@${RM} ${OBJECTDIR}/_ext/1472/math.o.d 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/_ext/1472/math.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l\"${OBJECTDIR}/_ext/1472/math.lst\" -e\"${OBJECTDIR}/_ext/1472/math.err\" $(ASM_OPTIONS)   -o\"${OBJECTDIR}/_ext/1472/math.o\" \"../math.asm\" 
	@${DEP_GEN} -d "${OBJECTDIR}/_ext/1472/math.o"
	@${FIXDEPS} "${OBJECTDIR}/_ext/1472/math.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/ex3.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w -x -u_DEBUG -z__ICD2RAM=1 -m"$(BINDIR_)$(TARGETBASE).map" -w -l".."   -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/ex3.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/ex3.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w  -m"$(BINDIR_)$(TARGETBASE).map" -w -l".."   -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/ex3.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
