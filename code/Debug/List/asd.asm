
;CodeVisionAVR C Compiler V3.49a 
;(C) Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _hour=R4
	.DEF _hour_msb=R5
	.DEF _mintue=R6
	.DEF _mintue_msb=R7
	.DEF _second=R8
	.DEF _second_msb=R9
	.DEF _x=R11
	.DEF _y=R10
	.DEF _colloc=R13
	.DEF _rowloc=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x37,0x38,0x39,0x2F,0x34,0x35,0x36,0x2A
	.DB  0x31,0x32,0x33,0x2D,0x20,0x30,0x3D,0x2B
_0x0:
	.DB  0x31,0x3A,0x53,0x74,0x6F,0x70,0x77,0x61
	.DB  0x74,0x63,0x68,0x0,0x32,0x3A,0x54,0x69
	.DB  0x6D,0x65,0x72,0x0,0x33,0x3A,0x43,0x4C
	.DB  0x4F,0x43,0x4B,0x0,0x49,0x6E,0x76,0x61
	.DB  0x6C,0x69,0x64,0x20,0x69,0x6E,0x70,0x75
	.DB  0x74,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x68,0x6F,0x75,0x72,0x73,0x3A,0x20,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x6D,0x69
	.DB  0x6E,0x74,0x75,0x65,0x73,0x3A,0x20,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x73,0x65
	.DB  0x63,0x6F,0x6E,0x64,0x73,0x3A,0x20,0x0
	.DB  0x3A,0x0,0x54,0x69,0x6D,0x65,0x20,0x75
	.DB  0x70,0x21,0x21,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _keypad
	.DW  _0x3*2

	.DW  0x0C
	.DW  _0x13
	.DW  _0x0*2

	.DW  0x08
	.DW  _0x13+12
	.DW  _0x0*2+12

	.DW  0x08
	.DW  _0x13+20
	.DW  _0x0*2+20

	.DW  0x0E
	.DW  _0x13+28
	.DW  _0x0*2+28

	.DW  0x0E
	.DW  _0x13+42
	.DW  _0x0*2+28

	.DW  0x0E
	.DW  _0x2C
	.DW  _0x0*2+42

	.DW  0x10
	.DW  _0x2D
	.DW  _0x0*2+56

	.DW  0x10
	.DW  _0x2E
	.DW  _0x0*2+72

	.DW  0x02
	.DW  _0x2F
	.DW  _0x0*2+88

	.DW  0x02
	.DW  _0x2F+2
	.DW  _0x0*2+88

	.DW  0x0A
	.DW  _0x4D
	.DW  _0x0*2+90

	.DW  0x0E
	.DW  _0x65
	.DW  _0x0*2+28

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void clock();
;void setclock();
;void timer();
;char keyfind();
;void display(int h,int m,int s);
;int hours();
;int mintues();
;int seconds();

	.DSEG
;void main(void)
; 0000 0021 {

	.CSEG
_main:
; .FSTART _main
; 0000 0022 
; 0000 0023 DDRC.0 = 1;
	SBI  0x14,0
; 0000 0024 PORTC.0 = 0;
	CBI  0x15,0
; 0000 0025 DDRD.0 = 0;
	CBI  0x11,0
; 0000 0026 DDRD.3 = 0;
	CBI  0x11,3
; 0000 0027 PORTD.0 = 1;
	SBI  0x12,0
; 0000 0028 PORTD.3 = 1;
	SBI  0x12,3
; 0000 0029 
; 0000 002A lcd_init(20);
	LDI  R26,LOW(20)
	RCALL _lcd_init
; 0000 002B while (1)
_0x10:
; 0000 002C {
; 0000 002D 
; 0000 002E 
; 0000 002F lcd_clear();
	RCALL _lcd_clear
; 0000 0030 lcd_puts("1:Stopwatch");
	__POINTW2MN _0x13,0
	RCALL _lcd_puts
; 0000 0031 lcd_gotoxy(0,1);
	RCALL SUBOPT_0x0
; 0000 0032 lcd_puts("2:Timer");
	__POINTW2MN _0x13,12
	RCALL _lcd_puts
; 0000 0033 lcd_gotoxy(0,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _lcd_gotoxy
; 0000 0034 lcd_puts("3:CLOCK");
	__POINTW2MN _0x13,20
	RCALL _lcd_puts
; 0000 0035 input = keyfind();
	RCALL _keyfind
	STS  _input,R30
; 0000 0036 lcd_putchar(input);
	LDS  R26,_input
	RCALL _lcd_putchar
; 0000 0037 if(input == '1'){
	LDS  R26,_input
	CPI  R26,LOW(0x31)
	BRNE _0x14
; 0000 0038 lcd_clear();
	RCALL _lcd_clear
; 0000 0039 hour = hours();
	RCALL _hours
	MOVW R4,R30
; 0000 003A delay_ms(1000);
	RCALL SUBOPT_0x1
; 0000 003B lcd_clear();
; 0000 003C mintue = mintues();
	RCALL _mintues
	MOVW R6,R30
; 0000 003D if(mintue>59){
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x15
; 0000 003E delay_ms(1000);
	RCALL SUBOPT_0x1
; 0000 003F lcd_clear();
; 0000 0040 lcd_puts("Invalid input");
	__POINTW2MN _0x13,28
	RCALL _lcd_puts
; 0000 0041 delay_ms(1000);
	RCALL SUBOPT_0x1
; 0000 0042 lcd_clear();
; 0000 0043 }
; 0000 0044 else {
	RJMP _0x16
_0x15:
; 0000 0045 delay_ms(1000);
	RCALL SUBOPT_0x1
; 0000 0046 lcd_clear();
; 0000 0047 second = seconds();
	RCALL _seconds
	MOVW R8,R30
; 0000 0048 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0049 
; 0000 004A if (second < 60){
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x17
; 0000 004B lcd_clear();
	RCALL _lcd_clear
; 0000 004C 
; 0000 004D clock();
	RCALL _clock
; 0000 004E lcd_clear();
	RCALL _lcd_clear
; 0000 004F }
; 0000 0050 else {
	RJMP _0x18
_0x17:
; 0000 0051 lcd_clear();
	RCALL _lcd_clear
; 0000 0052 lcd_puts("Invalid input");
	__POINTW2MN _0x13,42
	RCALL _lcd_puts
; 0000 0053 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0054 }
_0x18:
; 0000 0055 }
_0x16:
; 0000 0056 }
; 0000 0057 
; 0000 0058 if (input == '2')
_0x14:
	LDS  R26,_input
	CPI  R26,LOW(0x32)
	BRNE _0x19
; 0000 0059 {   lcd_clear();
	RCALL _lcd_clear
; 0000 005A timer();
	RCALL _timer
; 0000 005B }
; 0000 005C 
; 0000 005D if (input == '3')
_0x19:
	LDS  R26,_input
	CPI  R26,LOW(0x33)
	BRNE _0x1A
; 0000 005E {   lcd_clear();
	RCALL _lcd_clear
; 0000 005F setclock();
	RCALL _setclock
; 0000 0060 }
; 0000 0061 
; 0000 0062 }
_0x1A:
	RJMP _0x10
; 0000 0063 
; 0000 0064 }
_0x1B:
	RJMP _0x1B
; .FEND

	.DSEG
_0x13:
	.BYTE 0x38
;char keyfind()
; 0000 0066 {

	.CSEG
_keyfind:
; .FSTART _keyfind
; 0000 0067 while(1)
_0x1C:
; 0000 0068 {
; 0000 0069 KEY_DDR = 0x0F; // set port direction as input-output
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 006A KEY_PRT = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 006B do
_0x20:
; 0000 006C {
; 0000 006D delay_ms(20); /* 20ms key debounce time */
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
; 0000 006E colloc = (KEY_PIN & 0xF0); /* read status of column */
	IN   R30,0x16
	ANDI R30,LOW(0xF0)
	MOV  R13,R30
; 0000 006F }while(colloc == 0xF0); /* check for any key press */
	LDI  R30,LOW(240)
	CP   R30,R13
	BREQ _0x20
; 0000 0070 delay_ms(100); /* 100ms key debounce time */
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0071 /* now check for rows */
; 0000 0072 KEY_PRT = 0xFE; // check for pressed key in 1st row
	LDI  R30,LOW(254)
	RCALL SUBOPT_0x2
; 0000 0073 colloc = (KEY_PIN & 0xF0);
; 0000 0074 if(colloc != 0xF0)
	BREQ _0x22
; 0000 0075 {
; 0000 0076 rowloc = 0;
	CLR  R12
; 0000 0077 break;
	RJMP _0x1E
; 0000 0078 }
; 0000 0079 KEY_PRT = 0xFD; // check for pressed key in 2nd row
_0x22:
	LDI  R30,LOW(253)
	RCALL SUBOPT_0x2
; 0000 007A colloc = (KEY_PIN & 0xF0);
; 0000 007B if(colloc != 0xF0)
	BREQ _0x23
; 0000 007C {
; 0000 007D rowloc = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 007E break;
	RJMP _0x1E
; 0000 007F }
; 0000 0080 KEY_PRT = 0xFB; // check for pressed key in 3rd row
_0x23:
	LDI  R30,LOW(251)
	RCALL SUBOPT_0x2
; 0000 0081 colloc = (KEY_PIN & 0xF0);
; 0000 0082 if(colloc != 0xF0)
	BREQ _0x24
; 0000 0083 {
; 0000 0084 rowloc = 2;
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 0085 break;
	RJMP _0x1E
; 0000 0086 }KEY_PRT = 0xF7; /* check for pressed key in 4th row */
_0x24:
	LDI  R30,LOW(247)
	RCALL SUBOPT_0x2
; 0000 0087 colloc = (KEY_PIN & 0xF0);
; 0000 0088 if(colloc != 0xF0)
	BREQ _0x25
; 0000 0089 {
; 0000 008A rowloc = 3;
	LDI  R30,LOW(3)
	MOV  R12,R30
; 0000 008B break;
	RJMP _0x1E
; 0000 008C }
; 0000 008D }
_0x25:
	RJMP _0x1C
_0x1E:
; 0000 008E if(colloc == 0xE0)
	LDI  R30,LOW(224)
	CP   R30,R13
	BRNE _0x26
; 0000 008F return(keypad[rowloc][0]);
	RCALL SUBOPT_0x3
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET
; 0000 0090 else if(colloc == 0xD0)
_0x26:
	LDI  R30,LOW(208)
	CP   R30,R13
	BRNE _0x28
; 0000 0091 return(keypad[rowloc][1]);
	RCALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	LDD  R30,Z+1
	RET
; 0000 0092 else if(colloc == 0xB0)
_0x28:
	LDI  R30,LOW(176)
	CP   R30,R13
	BRNE _0x2A
; 0000 0093 return(keypad[rowloc][2]);
	RCALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	LDD  R30,Z+2
	RET
; 0000 0094 else
_0x2A:
; 0000 0095 return(keypad[rowloc][3]);
	RCALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	LDD  R30,Z+3
	RET
; 0000 0096 }
	RET
; .FEND
;int hours(){
; 0000 0099 int hours(){
_hours:
; .FSTART _hours
; 0000 009A int hours;
; 0000 009B lcd_puts("Enter hours: ");
	ST   -Y,R17
	ST   -Y,R16
;	hours -> R16,R17
	__POINTW2MN _0x2C,0
	RJMP _0x20C0005
; 0000 009C x = keyfind()-48;
; 0000 009D itoa(x,time);
; 0000 009E lcd_puts(time);
; 0000 009F y = keyfind()-48;
; 0000 00A0 itoa(y,time);
; 0000 00A1 lcd_puts(time);
; 0000 00A2 hours = x*10+y;
; 0000 00A3 return hours;
; 0000 00A4 }
; .FEND

	.DSEG
_0x2C:
	.BYTE 0xE
;int mintues(){
; 0000 00A6 int mintues(){

	.CSEG
_mintues:
; .FSTART _mintues
; 0000 00A7 int mintues;
; 0000 00A8 lcd_puts("Enter mintues: ");
	ST   -Y,R17
	ST   -Y,R16
;	mintues -> R16,R17
	__POINTW2MN _0x2D,0
	RJMP _0x20C0005
; 0000 00A9 x = keyfind()-48;
; 0000 00AA itoa(x,time);
; 0000 00AB lcd_puts(time);
; 0000 00AC y = keyfind()-48;
; 0000 00AD itoa(y,time);
; 0000 00AE lcd_puts(time);
; 0000 00AF mintues = x*10+y;
; 0000 00B0 
; 0000 00B1 
; 0000 00B2 return mintues;
; 0000 00B3 
; 0000 00B4 }
; .FEND

	.DSEG
_0x2D:
	.BYTE 0x10
;int seconds(){
; 0000 00B6 int seconds(){

	.CSEG
_seconds:
; .FSTART _seconds
; 0000 00B7 int seconds;
; 0000 00B8 lcd_puts("Enter seconds: ");
	ST   -Y,R17
	ST   -Y,R16
;	seconds -> R16,R17
	__POINTW2MN _0x2E,0
_0x20C0005:
	RCALL _lcd_puts
; 0000 00B9 x = keyfind()-48;
	RCALL _keyfind
	SUBI R30,LOW(48)
	MOV  R11,R30
; 0000 00BA itoa(x,time);
	RCALL SUBOPT_0x4
; 0000 00BB lcd_puts(time);
; 0000 00BC y = keyfind()-48;
	RCALL _keyfind
	SUBI R30,LOW(48)
	MOV  R10,R30
; 0000 00BD itoa(y,time);
	RCALL SUBOPT_0x4
; 0000 00BE lcd_puts(time);
; 0000 00BF seconds = x*10+y;
	MOV  R26,R11
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	MOV  R30,R10
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
; 0000 00C0 
; 0000 00C1 
; 0000 00C2 
; 0000 00C3 return seconds;
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00C4 
; 0000 00C5 }
; .FEND

	.DSEG
_0x2E:
	.BYTE 0x10
;void display(int h, int m, int s){
; 0000 00C6 void display(int h, int m, int s){

	.CSEG
_display:
; .FSTART _display
; 0000 00C7 
; 0000 00C8 lcd_clear();
	RCALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	__GETWRS 20,21,8
;	h -> R20,R21
;	m -> R18,R19
;	s -> R16,R17
	RCALL _lcd_clear
; 0000 00C9 itoa(h,time);
	ST   -Y,R21
	ST   -Y,R20
	RCALL SUBOPT_0x5
; 0000 00CA lcd_puts(time);
; 0000 00CB lcd_puts(":");
	__POINTW2MN _0x2F,0
	RCALL _lcd_puts
; 0000 00CC 
; 0000 00CD itoa(m,time);
	ST   -Y,R19
	ST   -Y,R18
	RCALL SUBOPT_0x5
; 0000 00CE lcd_puts(time);
; 0000 00CF lcd_puts(":");
	__POINTW2MN _0x2F,2
	RCALL _lcd_puts
; 0000 00D0 
; 0000 00D1 itoa(s,time);
	ST   -Y,R17
	ST   -Y,R16
	RCALL SUBOPT_0x5
; 0000 00D2 lcd_puts(time);
; 0000 00D3 }
	RJMP _0x20C0004
; .FEND

	.DSEG
_0x2F:
	.BYTE 0x4
;void clock(){
; 0000 00D5 void clock(){

	.CSEG
_clock:
; .FSTART _clock
; 0000 00D6 int i,j,k;
; 0000 00D7 int check = 0;
; 0000 00D8 int checkk = 0;
; 0000 00D9 for (i = hour; i >= 0; i--){
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	check -> Y+8
;	checkk -> Y+6
	MOVW R16,R4
_0x31:
	TST  R17
	BRPL PC+2
	RJMP _0x32
; 0000 00DA if (checkk == 1){
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BRNE _0x33
; 0000 00DB for(j = 59; j >= 0; j--){
	__GETWRN 18,19,59
_0x35:
	TST  R19
	BRMI _0x36
; 0000 00DC if(check == 1){
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x37
; 0000 00DD 
; 0000 00DE 
; 0000 00DF for (k = 59; k >= 0; k--){
	__GETWRN 20,21,59
_0x39:
	TST  R21
	BRMI _0x3A
; 0000 00E0 
; 0000 00E1 display(i,j,k);
	RCALL SUBOPT_0x6
; 0000 00E2 delay_ms(1000);
; 0000 00E3 }
	__SUBWRN 20,21,1
	RJMP _0x39
_0x3A:
; 0000 00E4 }
; 0000 00E5 else{
	RJMP _0x3B
_0x37:
; 0000 00E6 check = 1;
	RCALL SUBOPT_0x7
; 0000 00E7 for (k = second; k >= 0; k--){
_0x3D:
	TST  R21
	BRMI _0x3E
; 0000 00E8 if (PIND.0 == 0){
	SBIS 0x10,0
; 0000 00E9 return;
	RJMP _0x20C0004
; 0000 00EA }
; 0000 00EB display(i,j,k);
	RCALL SUBOPT_0x6
; 0000 00EC delay_ms(1000);
; 0000 00ED }
	__SUBWRN 20,21,1
	RJMP _0x3D
_0x3E:
; 0000 00EE }
_0x3B:
; 0000 00EF }
	__SUBWRN 18,19,1
	RJMP _0x35
_0x36:
; 0000 00F0 }
; 0000 00F1 else {
	RJMP _0x40
_0x33:
; 0000 00F2 checkk = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00F3 for(j = mintue; j >= 0; j--){
	MOVW R18,R6
_0x42:
	TST  R19
	BRMI _0x43
; 0000 00F4 if(check == 1){
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x44
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 for (k = 59; k >= 0; k--){
	__GETWRN 20,21,59
_0x46:
	TST  R21
	BRMI _0x47
; 0000 00F8 display(i,j,k);
	RCALL SUBOPT_0x6
; 0000 00F9 delay_ms(1000);
; 0000 00FA }
	__SUBWRN 20,21,1
	RJMP _0x46
_0x47:
; 0000 00FB }
; 0000 00FC else{
	RJMP _0x48
_0x44:
; 0000 00FD check = 1;
	RCALL SUBOPT_0x7
; 0000 00FE for (k = second; k >= 0; k--){
_0x4A:
	TST  R21
	BRMI _0x4B
; 0000 00FF if (PIND.0 == 0){
	SBIS 0x10,0
; 0000 0100 return;
	RJMP _0x20C0004
; 0000 0101 }
; 0000 0102 display(i,j,k);
	RCALL SUBOPT_0x6
; 0000 0103 delay_ms(1000);
; 0000 0104 }
	__SUBWRN 20,21,1
	RJMP _0x4A
_0x4B:
; 0000 0105 }
_0x48:
; 0000 0106 
; 0000 0107 }
	__SUBWRN 18,19,1
	RJMP _0x42
_0x43:
; 0000 0108 }
_0x40:
; 0000 0109 
; 0000 010A 
; 0000 010B }
	__SUBWRN 16,17,1
	RJMP _0x31
_0x32:
; 0000 010C lcd_gotoxy(0,1);
	RCALL SUBOPT_0x0
; 0000 010D lcd_puts("Time up!!");
	__POINTW2MN _0x4D,0
	RCALL _lcd_puts
; 0000 010E PORTC.0 = 1;
	SBI  0x15,0
; 0000 010F delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 0110 PORTC.0 = 0;
	CBI  0x15,0
; 0000 0111 lcd_clear();
	RCALL _lcd_clear
; 0000 0112 
; 0000 0113 }
_0x20C0004:
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND

	.DSEG
_0x4D:
	.BYTE 0xA
;void timer(){
; 0000 0116 void timer(){

	.CSEG
_timer:
; .FSTART _timer
; 0000 0117 
; 0000 0118 int i,j,k;
; 0000 0119 
; 0000 011A for (i = 0; i <= 24; i++){
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
	__GETWRN 16,17,0
_0x53:
	__CPWRN 16,17,25
	BRGE _0x54
; 0000 011B 
; 0000 011C for(j = 0; j < 60 ; j++){
	__GETWRN 18,19,0
_0x56:
	__CPWRN 18,19,60
	BRGE _0x57
; 0000 011D 
; 0000 011E for (k = 0; k < 60; k++){
	__GETWRN 20,21,0
_0x59:
	__CPWRN 20,21,60
	BRGE _0x5A
; 0000 011F if (PIND.0 == 0){
	SBIC 0x10,0
	RJMP _0x5B
; 0000 0120 lcd_clear();
	RCALL _lcd_clear
; 0000 0121 return;
	RJMP _0x20C0003
; 0000 0122 }
; 0000 0123 if (PIND.3 == 0){
_0x5B:
	SBIC 0x10,3
	RJMP _0x5C
; 0000 0124 delay_ms(1300);
	LDI  R26,LOW(1300)
	LDI  R27,HIGH(1300)
	RCALL _delay_ms
; 0000 0125 
; 0000 0126 while(1){
_0x5D:
; 0000 0127 if(PIND.3==0){
	SBIC 0x10,3
	RJMP _0x60
; 0000 0128 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0129 break;  }
	RJMP _0x5F
; 0000 012A if (PIND.0 == 0){
_0x60:
	SBIC 0x10,0
	RJMP _0x61
; 0000 012B lcd_clear();
	RCALL _lcd_clear
; 0000 012C return;
	RJMP _0x20C0003
; 0000 012D }
; 0000 012E 
; 0000 012F }
_0x61:
	RJMP _0x5D
_0x5F:
; 0000 0130 
; 0000 0131 
; 0000 0132 
; 0000 0133 }
; 0000 0134 display(i,j,k);
_0x5C:
	RCALL SUBOPT_0x6
; 0000 0135 delay_ms(1000);
; 0000 0136 }
	__ADDWRN 20,21,1
	RJMP _0x59
_0x5A:
; 0000 0137 }
	__ADDWRN 18,19,1
	RJMP _0x56
_0x57:
; 0000 0138 }
	__ADDWRN 16,17,1
	RJMP _0x53
_0x54:
; 0000 0139 }
_0x20C0003:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;void setclock(){
; 0000 013B void setclock(){
_setclock:
; .FSTART _setclock
; 0000 013C int i,j,k,h,m,s;
; 0000 013D h=hours();
	SBIW R28,6
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	h -> Y+10
;	m -> Y+8
;	s -> Y+6
	RCALL _hours
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 013E delay_ms(1000);
	RCALL SUBOPT_0x1
; 0000 013F lcd_clear();
; 0000 0140 m=mintues();
	RCALL _mintues
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0141 delay_ms(1000);
	RCALL SUBOPT_0x1
; 0000 0142 lcd_clear();
; 0000 0143 s=seconds();
	RCALL _seconds
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0144 delay_ms(1000);
	RCALL SUBOPT_0x1
; 0000 0145 lcd_clear();
; 0000 0146 if(h>23||m>59||s>59){
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,24
	BRGE _0x63
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,60
	BRGE _0x63
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,60
	BRLT _0x62
_0x63:
; 0000 0147 lcd_puts("Invalid input");
	__POINTW2MN _0x65,0
	RCALL _lcd_puts
; 0000 0148 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 0149 }
; 0000 014A for (i = h; i < 24; i++){
_0x62:
	__GETWRS 16,17,10
_0x67:
	__CPWRN 16,17,24
	BRGE _0x68
; 0000 014B 
; 0000 014C for(j = m; j < 60 ; j++){
	__GETWRS 18,19,8
_0x6A:
	__CPWRN 18,19,60
	BRGE _0x6B
; 0000 014D 
; 0000 014E for (k = s; k < 60; k++){
	__GETWRS 20,21,6
_0x6D:
	__CPWRN 20,21,60
	BRGE _0x6E
; 0000 014F 
; 0000 0150 if (PIND.0 == 0){
	SBIC 0x10,0
	RJMP _0x6F
; 0000 0151 lcd_clear();
	RCALL _lcd_clear
; 0000 0152 return;
	RJMP _0x20C0002
; 0000 0153 }
; 0000 0154 display(i,j,k);
_0x6F:
	RCALL SUBOPT_0x6
; 0000 0155 delay_ms(1000);
; 0000 0156 
; 0000 0157 }
	__ADDWRN 20,21,1
	RJMP _0x6D
_0x6E:
; 0000 0158 
; 0000 0159 }
	__ADDWRN 18,19,1
	RJMP _0x6A
_0x6B:
; 0000 015A 
; 0000 015B if(i==23&&j==60&&k==60){
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x71
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x71
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x72
_0x71:
	RJMP _0x70
_0x72:
; 0000 015C i=-1;j=0;k=0;
	__GETWRN 16,17,-1
	__GETWRN 18,19,0
	__GETWRN 20,21,0
; 0000 015D h=-1;m=0;s=0;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 015E }
; 0000 015F 
; 0000 0160 }
_0x70:
	__ADDWRN 16,17,1
	RJMP _0x67
_0x68:
; 0000 0161 }
_0x20C0002:
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND

	.DSEG
_0x65:
	.BYTE 0xE
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	STS  __lcd_x,R16
	STS  __lcd_y,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x8
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x8
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	CPI  R17,10
	BRNE _0x2000007
	RJMP _0x20C0001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	LD   R17,Y+
	RET
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_keypad:
	.BYTE 0x10
_time:
	.BYTE 0x2
_input:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	OUT  0x18,R30
	IN   R30,0x16
	ANDI R30,LOW(0xF0)
	MOV  R13,R30
	LDI  R30,LOW(240)
	CP   R30,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	MOV  R30,R12
	LDI  R26,LOW(_keypad)
	LDI  R27,HIGH(_keypad)
	LDI  R31,0
	RCALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _itoa
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RCALL _itoa
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x6:
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R20
	RCALL _display
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOVW R20,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
