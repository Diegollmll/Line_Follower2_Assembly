PROCESSOR 16F877A
#include <xc.inc>
; CONFIGURATION WORD PG 144 datasheet
CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0
    
   
    
max:
DS 1 ;reserve 1 byte for max
tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2
resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS
    
#define	LED_ROJO PORTD,1
#define	LED_DER PORTD,2
#define	LED_IZQ PORTD,3
#define	MDA PORTD,4  
#define	MDB PORTD,5
#define	MIA PORTD,6
#define	MIB PORTD,7  
#define S_CEN PORTB,0  
#define S_DER PORTB,1  
#define S_IZQ PORTB,2  
 

PSECT code

AVANZAR:
 BSF MDA
 BSF MIA
 BCF MDB
 BCF MIB
 BCF LED_ROJO
 BCF LED_DER
 BCF LED_IZQ
 goto MAIN

 
STOP:
 BCF MDA
 BCF MIA
 BCF MDB
 BCF MIB
 BSF LED_ROJO
 BCF LED_DER
 BCF LED_IZQ
goto MAIN
 
DERECHA:
 BCF MDA
 BSF MIA
 BCF MDB
 BCF MIB
 BCF LED_ROJO
 BSF LED_DER
 BCF LED_IZQ
goto MAIN
 
IZQUIERDA:
 BSF MDA
 BCF MIA
 BCF MDB
 BCF MIB
 BCF LED_ROJO
 BCF LED_DER
 BSF LED_IZQ
goto MAIN
 
 

INISYS:
    bcf		STATUS,6	;BK1
    bsf		STATUS,5
    
    bsf		TRISB, 0	        ;PORT (C0) S1 ENTRADA
    bsf		TRISB, 1		;PORT (C1) S2 ENTRADA
    bsf		TRISB, 2		;PORT (C2) S3 ENTRADA
    bsf		TRISB, 3		;PORT (C3) S4 ENTRADA
    bsf		TRISB, 4		;PORT (C4) S5 ENTRADA
    
    bcf		TRISD, 0	        ;PORT (D0) MA1 SALIDA
    bcf		TRISD, 1		;PORT (D1) MA2 SALIDA
    bcf		TRISD, 2		;PORT (D2) MB1 SALIDA
    bcf		TRISD, 3		;PORT (D3) MB2 SALIDA
    bcf		TRISD, 4		;PORT (D4) LAI SALIDA
    bcf		TRISD, 5		;PORT (D5) LAD SALIDA
    bcf		TRISD, 6		;PORT (D6) LRSTP SALIDA	
    bcf		TRISD, 7		;PORT (D6) LRSTP SALIDA	
    ;*************************     
    BCF STATUS, 5 ; BK0 
    
   MAIN:
   
   ;Pregunta por sensor1 
   BTFSS PORTB, 2
   GOTO INSTRUCCION1 ;0
   GOTO INSTRUCCION2 ;1
    
   INSTRUCCION1:
    
   BTFSS PORTB, 1
   GOTO INSTRUCCION3 ;00
   GOTO INSTRUCCION4 ;01
   
   INSTRUCCION2:
    
    BTFSS PORTB, 1
    GOTO INSTRUCCION5 ;10
    GOTO INSTRUCCION6 ;11
    
   INSTRUCCION3: 
    
   BTFSS PORTB, 0
   CALL STOP
   CALL DERECHA
   
   INSTRUCCION4:
    
   BTFSS PORTB , 0
   CALL AVANZAR
   CALL DERECHA
   
   INSTRUCCION5:
    
    BTFSS PORTB , 0
    CALL IZQUIERDA
    GOTO MAIN
    
   INSTRUCCION6:
    
   BTFSS PORTB, 0
   CALL IZQUIERDA
   CALL STOP
   
   end resetVec