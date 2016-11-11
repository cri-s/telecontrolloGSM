
'****************************************************************
'*  Name    : C622-R12 (PJ025 Progetto Completo)                *
'*            Telecontrollo GSM 2 OUT / 2 IN DIG / 2 IN ANAL    *
'*  Author  : Carlo Vignati                                     *
'*  Notice  : Copyright (c) 2010 EVR electronics                *
'*          : All Rights Reserved                               *
'*  Date    : 26/05/2010                                        *
'*  Notes   : PIC18F2620-I/SO                                   *
'*          :                                                   *
'****************************************************************
 
    include "MODEDEFS.BAS"
 
DEFINE OSC 20
 
TRISA=%00010011         'Port A tutte uscite tranne RA0 e RA1 e RA4
TRISB=%11111111         'Port B tutti ingressi
TRISC=%10001110         'Port C
 
ADCON1=%00001101        'Imposta RA0 e RA1 come analogici
CMCON=%00000111         'PortA in digitale
 
INTCON2.7=0             'Abilita pull-up sul port B
 
'Configurazione usart 
DEFINE HSER_RCSTA 90h 
DEFINE HSER_TXSTA 24h   
DEFINE HSER_SPBRG 64
DEFINE HSER_CLROERR 1 
 
'Definizione linee I/O
SYMBOL  USCITA1=PORTA.2            'Linea uscita 1
SYMBOL  USCITA2=PORTA.3            'Linea uscita 2
SYMBOL  USCITA3=PORTA.2            'Linea uscita 3
SYMBOL  USCITA4=PORTA.3            'Linea uscita 4
SYMBOL POWERGSM=PORTA.4    'POWER GSM
SYMBOL RESETGSM=PORTA.5    'RESET GSM
 
SYMBOL  USCITA5=PORTC.0            'Linea uscita 5
SYMBOL RINGGSM  =PORTC.1    'RING GSM
SYMBOL STATOGSM =PORTC.2    'STATO GSM
SYMBOL  RXGPS    =PORTC.3          
SYMBOL  LDGIALLO =PORTC.4          'LED GIALLO
SYMBOL  TXGPS    =PORTC.5          
SYMBOL  TXDGSM   =PORTC.6          'RXD GSM
SYMBOL  RXDGSM   =PORTC.7          'TXD GSM
 
SYMBOL  INGRESSO1=PORTB.0
SYMBOL  INGRESSO2=PORTB.1
SYMBOL  INGRESSO3=PORTB.2
SYMBOL  INGRESSO4=PORTB.3
SYMBOL  INGRESSO5=PORTB.4
 
 
'Inizializza linee di I/O
LOW     RESETGSM
 
LOW     USCITA1
LOW     USCITA2
LOW     USCITA3
LOW     USCITA4
LOW     USCITA5
 
'Definizione variabili
VAR1                VAR BYTE    
CHIAMATAESEGUITA    VAR BYTE    
TMP                 VAR BYTE
TMP1                VAR BYTE
TMP2                VAR WORD
TMP3                VAR BYTE[8]
 
MITTENTE            VAR BYTE[20]
LUNGMITT            VAR BYTE
BUFF                VAR BYTE[160]
BUFF1               VAR BYTE[160]
LUNGMESS            VAR BYTE
CONTAREG            VAR BYTE
CONTAREG1           VAR BYTE
TENTATIVI           VAR BYTE
 
IDDISP              VAR BYTE[4]     
PASSWORD            VAR BYTE[4]     
IDDISPL             VAR BYTE[4]     
IDDISPL1            VAR BYTE[4]
PASSWORDL           VAR BYTE[4]
PASSWORDL1          VAR BYTE[4]
 
TELEFONO1           VAR BYTE[16]
LUNGTEL1            VAR BYTE
TELEFONO2           VAR BYTE[16]
LUNGTEL2            VAR BYTE
TELEFONO3           VAR BYTE[16]
LUNGTEL3            VAR BYTE
TELEFONO4           VAR BYTE[16]
LUNGTEL4            VAR BYTE
TELEFONO5           VAR BYTE[16]
LUNGTEL5            VAR BYTE
 
SOUT1               VAR BYTE       
SOUT2               VAR BYTE
SOUT3               VAR BYTE
SOUT4               VAR BYTE
SOUT5               VAR BYTE
 
CAROUT1             VAR BYTE[3]     
CAROUT2             VAR BYTE[3]     
CAROUT3             VAR BYTE[3]     
CAROUT4             VAR BYTE[3]     
CAROUT5             VAR BYTE[3]    
 
CARIN1              VAR BYTE        
CARIN2              VAR BYTE        
CARIN3              VAR BYTE        
CARIN4              VAR BYTE       
CARIN5              VAR BYTE        
 
MODFUNZIN1          VAR BYTE
MODFUNZIN2          VAR BYTE
MODFUNZAN1          VAR BYTE
MODFUNZAN2          VAR BYTE
 
TPERMIN1            VAR BYTE
TPERMIN2            VAR BYTE
TPERMIN3            VAR BYTE
TPERMIN4            VAR BYTE
TPERMIN5            VAR BYTE
 
INIBIN1             VAR BYTE
INIBIN2             VAR BYTE
 
INIBAN1             VAR BYTE
INIBAN2             VAR BYTE
 
SMSPUP              VAR BYTE
FRASE               VAR BYTE
FLAGCALL            VAR BYTE
POWERUP             VAR BYTE
 
TESTOALLARME        VAR BYTE[80]
LUNGALLARME         VAR BYTE
 
CANCELLO            VAR BYTE
RSQUILLO            VAR BYTE
RIPRISTUSCITE       VAR BYTE
 
LUNGTEL             VAR BYTE
TELEFONO            VAR BYTE[16]
 
INANA1              VAR WORD    
INANA1V             VAR WORD    
INANA1S             VAR WORD    
INANA1SL            VAR BYTE
INANA1SH            VAR BYTE
 
INANA2              VAR WORD
INANA2V             VAR WORD
INANA2S             VAR WORD
INANA2SL            VAR BYTE
INANA2SH            VAR BYTE
 
RIATTIVAZIONE       VAR BYTE
 
DOORMODE            VAR BYTE    
 
TRESECONDI      VAR BYTE
MINUTI          VAR BYTE
ORE             VAR BYTE
 
ECHOSMS         VAR BYTE
 
'Inizializza EEPROM
EEPROM 1,[0]        'Flag di prima accensione
 
EEPROM 2,[67]       
EEPROM 3,[54]       
EEPROM 4,[53]       
EEPROM 5,[50]      
 
EEPROM 10,[48]     
EEPROM 11,[48]      
EEPROM 12,[48]     
EEPROM 13,[48]     
 
EEPROM 14,[67]       
EEPROM 15,[54]       
EEPROM 16,[53]       
EEPROM 17,[50]       
 
EEPROM 22,[48]      
EEPROM 23,[48]      
EEPROM 24,[48]      
EEPROM 25,[48]     
 
EEPROM 30,[45]      'Telefono 1 Cifra 1
EEPROM 31,[45]      'Telefono 1 Cifra 2
EEPROM 32,[45]      'Telefono 1 Cifra 3
EEPROM 33,[45]      'Telefono 1 Cifra 4
EEPROM 34,[45]      'Telefono 1 Cifra 5
EEPROM 35,[45]      'Telefono 1 Cifra 6
EEPROM 36,[45]      'Telefono 1 Cifra 7
EEPROM 37,[45]      'Telefono 1 Cifra 8
EEPROM 38,[45]      'Telefono 1 Cifra 9
EEPROM 39,[45]      'Telefono 1 Cifra 10
EEPROM 40,[45]      'Telefono 1 Cifra 11
EEPROM 41,[45]      'Telefono 1 Cifra 12
EEPROM 42,[45]      'Telefono 1 Cifra 13
EEPROM 43,[45]      'Telefono 1 Cifra 14
EEPROM 44,[45]      'Telefono 1 Cifra 15
EEPROM 45,[45]      'Telefono 1 Cifra 16
EEPROM 46,[0]       'Telefono 1 Lunghezza
 
EEPROM 50,[45]      'Telefono 2 Cifra 1
EEPROM 51,[45]      'Telefono 2 Cifra 2
EEPROM 52,[45]      'Telefono 2 Cifra 3
EEPROM 53,[45]      'Telefono 2 Cifra 4
EEPROM 54,[45]      'Telefono 2 Cifra 5
EEPROM 55,[45]      'Telefono 2 Cifra 6
EEPROM 56,[45]      'Telefono 2 Cifra 7
EEPROM 57,[45]      'Telefono 2 Cifra 8
EEPROM 58,[45]      'Telefono 2 Cifra 9
EEPROM 59,[45]      'Telefono 2 Cifra 10
EEPROM 60,[45]      'Telefono 2 Cifra 11
EEPROM 61,[45]      'Telefono 2 Cifra 12
EEPROM 62,[45]      'Telefono 2 Cifra 13
EEPROM 63,[45]      'Telefono 2 Cifra 14
EEPROM 64,[45]      'Telefono 2 Cifra 15
EEPROM 65,[45]      'Telefono 2 Cifra 16
EEPROM 66,[0]       'Telefono 2 Lunghezza
 
EEPROM 70,[45]      'Telefono 3 Cifra 1
EEPROM 71,[45]      'Telefono 3 Cifra 2
EEPROM 72,[45]      'Telefono 3 Cifra 3
EEPROM 73,[45]      'Telefono 3 Cifra 4
EEPROM 74,[45]      'Telefono 3 Cifra 5
EEPROM 75,[45]      'Telefono 3 Cifra 6
EEPROM 76,[45]      'Telefono 3 Cifra 7
EEPROM 77,[45]      'Telefono 3 Cifra 8
EEPROM 78,[45]      'Telefono 3 Cifra 9
EEPROM 79,[45]      'Telefono 3 Cifra 10
EEPROM 80,[45]      'Telefono 3 Cifra 11
EEPROM 81,[45]      'Telefono 3 Cifra 12
EEPROM 82,[45]      'Telefono 3 Cifra 13
EEPROM 83,[45]      'Telefono 3 Cifra 14
EEPROM 84,[45]      'Telefono 3 Cifra 15
EEPROM 85,[45]      'Telefono 3 Cifra 16
EEPROM 86,[0]       'Telefono 3 Lunghezza
 
EEPROM 90,[45]      'Telefono 4 Cifra 1
EEPROM 91,[45]      'Telefono 4 Cifra 2
EEPROM 92,[45]      'Telefono 4 Cifra 3
EEPROM 93,[45]      'Telefono 4 Cifra 4
EEPROM 94,[45]      'Telefono 4 Cifra 5
EEPROM 95,[45]      'Telefono 4 Cifra 6
EEPROM 96,[45]      'Telefono 4 Cifra 7
EEPROM 97,[45]      'Telefono 4 Cifra 8
EEPROM 98,[45]      'Telefono 4 Cifra 9
EEPROM 99,[45]      'Telefono 4 Cifra 10
EEPROM 100,[45]      'Telefono 4 Cifra 11
EEPROM 101,[45]      'Telefono 4 Cifra 12
EEPROM 102,[45]      'Telefono 4 Cifra 13
EEPROM 103,[45]      'Telefono 4 Cifra 14
EEPROM 104,[45]      'Telefono 4 Cifra 15
EEPROM 105,[45]      'Telefono 4 Cifra 16
EEPROM 106,[0]       'Telefono 4 Lunghezza
 
EEPROM 110,[45]      'Telefono 5 Cifra 1
EEPROM 111,[45]      'Telefono 5 Cifra 2
EEPROM 112,[45]      'Telefono 5 Cifra 3
EEPROM 113,[45]      'Telefono 5 Cifra 4
EEPROM 114,[45]      'Telefono 5 Cifra 5
EEPROM 115,[45]      'Telefono 5 Cifra 6
EEPROM 116,[45]      'Telefono 5 Cifra 7
EEPROM 117,[45]      'Telefono 5 Cifra 8
EEPROM 118,[45]      'Telefono 5 Cifra 9
EEPROM 119,[45]      'Telefono 5 Cifra 10
EEPROM 120,[45]      'Telefono 5 Cifra 11
EEPROM 121,[45]      'Telefono 5 Cifra 12
EEPROM 122,[45]      'Telefono 5 Cifra 13
EEPROM 123,[45]      'Telefono 5 Cifra 14
EEPROM 124,[45]      'Telefono 5 Cifra 15
EEPROM 125,[45]      'Telefono 5 Cifra 16
EEPROM 126,[0]       'Telefono 5 Lunghezza
 
EEPROM  130,[0]         
EEPROM  131,[0]         
EEPROM  132,[0]         
EEPROM  133,[0]         
EEPROM  134,[0]         
 
EEPROM  135,[0]        
EEPROM  136,[0]        
EEPROM  137,[1]          
EEPROM  138,[1]         
 
 
EEPROM  140,[1]        
 
EEPROM  141,[0]         
 
EEPROM  142,[0]         
EEPROM  143,[0]         
EEPROM  144,[0]         
EEPROM  145,[0]         
EEPROM  146,[0]         
 
EEPROM  147,[1]        
 
EEPROM  148,[0]        
 
EEPROM  149,[0]          
                       
 
EEPROM  150,[1]       
 
                       
EEPROM  151,[255]      
EEPROM  152,[3]        
EEPROM  153,[255]      
EEPROM  154,[3]       
 
EEPROM  155,[0]         
 
EEPROM  156,[77]     
 
EEPROM  157,[1]       
 
RIPARTI:
 
    READ 1,TMP      'Leggi se prima accensione
    IF TMP=0 THEN  
        
        'Se prima accensione prendi ID e passwrd di default
        write   1,1             'Segnala non più prima accensione
 
        IDDISP[0]=67        
        WRITE 14,IDDISP[0]
        IDDISP[1]=54        
        WRITE 15,IDDISP[1]
        IDDISP[2]=50       
        WRITE 16,IDDISP[2] 
        IDDISP[3]=50        
        WRITE 17,IDDISP[3]
 
        PASSWORD[0]=48     
        WRITE 22,PASSWORD[0]
        PASSWORD[1]=48      
        WRITE 23,PASSWORD[1]
        PASSWORD[2]=48      
        WRITE 24,PASSWORD[2]
        PASSWORD[3]=48      
        WRITE 25,PASSWORD[3]
 
        MODFUNZIN1=0    'Imposta in1 attivo basso
        WRITE 135,MODFUNZIN1
        
        MODFUNZIN2=0    'Imposta in2 attivo basso
        WRITE 136,MODFUNZIN2
        
        MODFUNZAN1=1    'Imposta AN1 per soglia over
        WRITE 137,MODFUNZAN1
        
        MODFUNZAN2=1    'Imposta AN2 per soglia over
        WRITE 138,MODFUNZAN2
 
        SMSPUP=1        'Abilita sms di power up
        write 140,SMSPUP
        FLAGCALL=0      'Disabilita squillo di avviso
        WRITE 141,FLAGCALL
 
        TPERMIN1=0      'Tempo permaneza in 1
        WRITE 142,TPERMIN1
        TPERMIN2=0      'Tempo permaneza in 2
        WRITE 143,TPERMIN2
 
        CANCELLO=0       'Disabilita funzione apricancello
        WRITE 148,CANCELLO
        
        RSQUILLO=0       'Disabilita squillo di risposta
        WRITE 149,RSQUILLO
 
        SOUT1=0             
        WRITE 130,SOUT1
        SOUT2=0            
        WRITE 131,SOUT1
        SOUT3=0             
        WRITE 132,SOUT1
        SOUT4=0             
        WRITE 133,SOUT1
        SOUT5=0             
        WRITE 134,SOUT1
 
        WRITE 46,0          'Azzera Telefono 1 Lunghezza
        WRITE 66,0          'Azzera Telefono 2 Lunghezza
        WRITE 86,0          'Azzera Telefono 3 Lunghezza
        WRITE 106,0         'Azzera Telefono 4 Lunghezza
        WRITE 126,0         'Azzera Telefono 5 Lunghezza
 
        RIPRISTUSCITE=1     'Abilita rispristino uscite
        WRITE 150,RIPRISTUSCITE
 
        INANA1SL=255        'Soglia AN1 bassa
        WRITE 151,INANA1SL
        INANA1SH=3          'Soglia AN1 alta
        WRITE 152,INANA1SH
        INANA2SL=255        'Soglia AN2 bassa
        WRITE 153,INANA2SL
        INANA2SH=3          'Soglia AN2 alta
        WRITE 154,INANA2SH
 
        RIATTIVAZIONE=0
        WRITE 155,RIATTIVAZIONE
 
        DOORMODE=77
        WRITE 156,DOORMODE
 
        ECHOSMS=1           'Abilita echosms
        WRITE 157,ECHOSMS
 
        WRITE 200,42    'Azzera testo allarme
        WRITE 300,42    'Azzera testo allarme
        WRITE 400,42    'Azzera testo allarme
        WRITE 500,42    'Azzera testo allarme
        WRITE 600,42    'Azzera testo allarme
        WRITE 700,42    'Azzera testo allarme
        WRITE 800,42    'Azzera testo allarme
        WRITE 900,42    'Azzera testo allarme                                                
 
    endif
 
        'Se non è prima accensione prendi parametri memorizzati
        READ    14,IDDISP[0]
        READ    15,IDDISP[1]
        READ    16,IDDISP[2]
        READ    17,IDDISP[3]
     
        READ    22,PASSWORD[0]
        READ    23,PASSWORD[1]
        READ    24,PASSWORD[2]
        READ    25,PASSWORD[3]      
        READ    30,TELEFONO1[0]      'Telefono 1 Cifra 1
        READ    31,TELEFONO1[1]      'Telefono 1 Cifra 2
        READ    32,TELEFONO1[2]      'Telefono 1 Cifra 3
        READ    33,TELEFONO1[3]      'Telefono 1 Cifra 4
        READ    34,TELEFONO1[4]      'Telefono 1 Cifra 5
        READ    35,TELEFONO1[5]      'Telefono 1 Cifra 6
        READ    36,TELEFONO1[6]      'Telefono 1 Cifra 7
        READ    37,TELEFONO1[7]      'Telefono 1 Cifra 8
        READ    38,TELEFONO1[8]      'Telefono 1 Cifra 9
        READ    39,TELEFONO1[9]      'Telefono 1 Cifra 10
        READ    40,TELEFONO1[10]      'Telefono 1 Cifra 11
        READ    41,TELEFONO1[11]      'Telefono 1 Cifra 12
        READ    42,TELEFONO1[12]      'Telefono 1 Cifra 13
        READ    43,TELEFONO1[13]      'Telefono 1 Cifra 14
        READ    44,TELEFONO1[14]      'Telefono 1 Cifra 15
        READ    45,TELEFONO1[15]      'Telefono 1 Cifra 16
        READ    46,LUNGTEL1             'Telefono 1 Lunghezza
        READ    50,TELEFONO2[0]      'Telefono 2 Cifra 1
        READ    51,TELEFONO2[1]      'Telefono 2 Cifra 2
        READ    52,TELEFONO2[2]      'Telefono 2 Cifra 3
        READ    53,TELEFONO2[3]      'Telefono 2 Cifra 4
        READ    54,TELEFONO2[4]      'Telefono 2 Cifra 5
        READ    55,TELEFONO2[5]      'Telefono 2 Cifra 6
        READ    56,TELEFONO2[6]      'Telefono 2 Cifra 7
        READ    57,TELEFONO2[7]      'Telefono 2 Cifra 8
        READ    58,TELEFONO2[8]      'Telefono 2 Cifra 9
        READ    59,TELEFONO2[9]      'Telefono 2 Cifra 10
        READ    60,TELEFONO2[10]      'Telefono 2 Cifra 11
        READ    61,TELEFONO2[11]      'Telefono 2 Cifra 12
        READ    62,TELEFONO2[12]      'Telefono 2 Cifra 13
        READ    63,TELEFONO2[13]      'Telefono 2 Cifra 14
        READ    64,TELEFONO2[14]      'Telefono 2 Cifra 15
        READ    65,TELEFONO2[15]      'Telefono 2 Cifra 16
        READ    66,LUNGTEL2       'Telefono 2 Lunghezza
        READ    70,TELEFONO3[0]      'Telefono 3 Cifra 1
        READ    71,TELEFONO3[1]      'Telefono 3 Cifra 2
        READ    72,TELEFONO3[2]      'Telefono 3 Cifra 3
        READ    73,TELEFONO3[3]      'Telefono 3 Cifra 4   
        READ    74,TELEFONO3[4]      'Telefono 3 Cifra 5
        READ    75,TELEFONO3[5]      'Telefono 3 Cifra 6
        READ    76,TELEFONO3[6]      'Telefono 3 Cifra 7
        READ    77,TELEFONO3[7]      'Telefono 3 Cifra 8
        READ    78,TELEFONO3[8]      'Telefono 3 Cifra 9
        READ    79,TELEFONO3[9]      'Telefono 3 Cifra 10
        READ    80,TELEFONO3[10]      'Telefono 3 Cifra 11
        READ    81,TELEFONO3[11]      'Telefono 3 Cifra 12
        READ    82,TELEFONO3[12]      'Telefono 3 Cifra 13
        READ    83,TELEFONO3[13]      'Telefono 3 Cifra 14
        READ    84,TELEFONO3[14]      'Telefono 3 Cifra 15
        READ    85,TELEFONO3[15]      'Telefono 3 Cifra 16
        READ    86,LUNGTEL3       'Telefono 3 Lunghezza
        READ    90,TELEFONO4[0]      'Telefono 4 Cifra 1
        READ    91,TELEFONO4[1]      'Telefono 4 Cifra 2
        READ    92,TELEFONO4[2]      'Telefono 4 Cifra 3
        READ    93,TELEFONO4[3]      'Telefono 4 Cifra 4
        READ    94,TELEFONO4[4]      'Telefono 4 Cifra 5
        READ    95,TELEFONO4[5]      'Telefono 4 Cifra 6
        READ    96,TELEFONO4[6]      'Telefono 4 Cifra 7
        READ    97,TELEFONO4[7]      'Telefono 4 Cifra 8
        READ    98,TELEFONO4[8]      'Telefono 4 Cifra 9
        READ    99,TELEFONO4[9]      'Telefono 4 Cifra 10
        READ    100,TELEFONO4[10]      'Telefono 4 Cifra 11
        READ    101,TELEFONO4[11]      'Telefono 4 Cifra 12
        READ    102,TELEFONO4[12]      'Telefono 4 Cifra 13
        READ    103,TELEFONO4[13]      'Telefono 4 Cifra 14
        READ    104,TELEFONO4[14]      'Telefono 4 Cifra 15
        READ    105,TELEFONO4[15]      'Telefono 4 Cifra 16
        READ    106,LUNGTEL4       'Telefono 4 Lunghezza
        READ    110,TELEFONO5[0]      'Telefono 5 Cifra 1
        READ    111,TELEFONO5[1]      'Telefono 5 Cifra 2
        READ    112,TELEFONO5[2]      'Telefono 5 Cifra 3
        READ    113,TELEFONO5[3]      'Telefono 5 Cifra 4
        READ    114,TELEFONO5[4]      'Telefono 5 Cifra 5
        READ    115,TELEFONO5[5]      'Telefono 5 Cifra 6
        READ    116,TELEFONO5[6]      'Telefono 5 Cifra 7
        READ    117,TELEFONO5[7]      'Telefono 5 Cifra 8
        READ    118,TELEFONO5[8]      'Telefono 5 Cifra 9
        READ    119,TELEFONO5[9]      'Telefono 5 Cifra 10
        READ    120,TELEFONO5[10]      'Telefono 5 Cifra 11
        READ    121,TELEFONO5[11]      'Telefono 5 Cifra 12
        READ    122,TELEFONO5[12]      'Telefono 5 Cifra 13
        READ    123,TELEFONO5[13]      'Telefono 5 Cifra 14
        READ    124,TELEFONO5[14]      'Telefono 5 Cifra 15
        READ    125,TELEFONO5[15]      'Telefono 5 Cifra 16
        READ    126,LUNGTEL5            'Telefono 5 Lunghezza
        READ    135,MODFUNZIN1          'Carica nelle variabili il modo 
        READ    136,MODFUNZIN2          'di funzionamento degli ingressi
        READ    137,MODFUNZAN1
        READ    138,MODFUNZAN2
 
        READ    140,SMSPUP
        READ    141,FLAGCALL
        READ    142,TPERMIN1
        READ    143,TPERMIN2
 
     
        READ    148,CANCELLO
        READ    149,RSQUILLO
        READ    150,RIPRISTUSCITE
        READ    151,INANA1SL
        READ    152,INANA1SH
        READ    153,INANA2SL
        READ    154,INANA2SH
        READ    155,RIATTIVAZIONE
        READ    156,DOORMODE
        READ    157,ECHOSMS
 
'Inizializza variabili
CONTAREG = 0
INIBIN1=0       'Non inibire in 1
INIBIN2=0       'Non inibire in 2
INIBAN1=0       'Non inibire in 3
INIBAN2=0       'Non inibire in 4
 
POWERUP=0       'Flag di puwer up inviato a 0
 
TRESECONDI=0
MINUTI=0
ORE=0
 
'Calcola valori di soglia per ad partendo dai byte letti da eeprom
'(byte alto x 256) + byte basso
    INANA1S = 0
    INANA1S = INANA1SH * 256
    INANA1S = INANA1S + INANA1SL
    INANA2S = 0
    INANA2S = INANA2SH * 256
    INANA2S = INANA2S + INANA2SL
 
START:
 
    LOW     LDGIALLO        'Spegni led giallo
    pause   3000            
 
    GOSUB   ON_OFF          'Accendi e configura il gsm
 
    gosub   RIPRISTINO      'Ripristina stato uscite
 
    pause   10000           
    GOSUB   INVIOPUP        'Invia messaggio di power up
 
MAIN:
    PAUSE   50
    HSEROUT ["AT",13] 
    HSERIN  2000,MAINERR,[WAIT ("OK")]     
 
    pause   50 
    HSEROUT ["AT+CMEE=0",13]                'Disabilira report errori
    HSERIN  2000,MAIN1,[WAIT ("OK")]   
 
MAIN1:
    PAUSE   50
    HSEROUT ["AT+CMGF=1",13]                'Configura sms in formato testo
    HSERIN  2000,MAIN2,[WAIT ("OK")]    
 
MAIN2:
    PAUSE   50
    HSEROUT ["AT#SMSMODE=0",13]  
    HSERIN  2000,MAIN3,[WAIT ("OK")]    
 
MAIN3:
    PAUSE   50
    HSEROUT ["AT+CPMS=",34,"ME",34,13]      'Imposta lettura SMS nella memoria SIM
    HSERIN  2000,MAIN4,[WAIT ("OK")]    
    GOSUB   LEGGISMS                        'Guarda se c'è un sms
 
MAIN4:
    PAUSE   50
    HSEROUT ["AT+CPMS=",34,"SM",34,13]      'Imposta lettura SMS nella memoria SIM
    HSERIN  2000,MAIN5,[WAIT ("OK")]    
    GOSUB   LEGGISMS                        'Guarda se c'è un sms
 
MAIN5:
    PAUSE   50
    HSEROUT ["AT+CLIP=1",13]                'Abilita CLI calling line identification
    HSERIN  2000,MAIN6,[WAIT ("OK")]    
 
MAIN6:
    IF RINGGSM=0 THEN               'Guarda se c'è una chiamata
        GOSUB CHIAMATAARRIVO
        pause   50                  
    ENDIF
 
    HIGH    LDGIALLO        'Lampeggio di run
    pause   100
    LOW     LDGIALLO   
    pause   100
 
    gosub   LEGGIIN         'Leggi ingressi digitali IN1 e IN2
 
    IF RIATTIVAZIONE=1 THEN     'Se impostata riattivazione automatica
        GOSUB RIATTIVAINGRESSI  'riattiva ingressi
    ENDIF        
 
    GOSUB   LEGGIINANA      'Leggi ingressi analogici AN1 e AN2
 
    PAUSE   50                              'Verifica presenza network gsm
    HSEROUT ["AT+CREG?",13]                 
                                            
                                           
    HSERIN 2000,NORISPOSTA,[WAIT ("+CREG: "),TMP,TMP1,TMP2]
    PAUSE 100    
    IF TMP2="1" OR TMP2="5" THEN            
        CONTAREG=0                          
    ELSE
        CONTAREG=CONTAREG+1                
        IF CONTAREG>100 THEN               
            CONTAREG=0
            GOSUB RSTGSM                    'Resetta e configura gsm
        ENDIF 
    ENDIF
 
    goto    MAIN
 
NORISPOSTA:
    CONTAREG=CONTAREG+1                 'No risposta da telit
    IF CONTAREG>100 THEN               
            CONTAREG=0
            GOSUB RSTGSM                'Resetta e configura il gsm
    ENDIF 
    GOTO    MAIN
 
MAINERR:
    GOSUB   RSTGSM
    GOTO    MAIN
    
'-----------------------------------------------------------------------------
'SUBROUTINE ON_OFF Accendi e configura il gsm
 
ON_OFF: 
    HIGH    LDGIALLO    'Accendi led gaillo inizio configurzione gsm
 
    TRISA.4=0           'Imposta RA4 POWERGSM come uscita
    PAUSE 10
    LOW POWERGSM        'Accendi o spegni il modulo
    PAUSE 2000
    PAUSE 10
    TRISA.4=1           'Imposta RA4 POWERGSM come ingresso alta impedenza
 
    PAUSE 60000          
 
    pause   1000
    HSEROUT ["AT",13]                       'Vedi se il gsm risponde
    HSERIN  2000,ERRORE,[WAIT ("OK")]       
 
    pause   1000        
    HSEROUT ["AT+IPR=19200",13]             'Imposta velocità a 19200
    HSERIN  2000,ERRORE,[WAIT ("OK")]
 
                                   
    PAUSE   1000
    HSEROUT ["AT#SELINT=2",13]      'Imposta modo Selint=2
    HSERIN  2000,ERRORE,[WAIT ("OK")]
 
    PAUSE   1000
    HSEROUT ["AT#BND=0",13]         'Imposta banda 900 - 1800
    pause   3000                   
    
    PAUSE   50
    HSEROUT ["AT+COPS=0",13]        'Imposta scelta automatica dell'operatore
    pause   30000                   
 
    pause   1000        
    HSEROUT ["AT#REGMODE=1",13]             'Richiesta registrazione formale
  
 
    CONTAREG=0
    CONTAREG1=0
ON_OFF1:
    PAUSE   1000                            'Verifica presenza network gsm
    HSEROUT ["AT+CREG?",13]                
    HSERIN  60000,ON_OFF2,[WAIT ("+CREG: "),TMP,TMP1,TMP2]
    PAUSE   100    
    IF TMP2="1" OR TMP2="5" THEN            'Se risponde +CREG: X,1 o +CREG: X,5
        GOTO ON_OFF3                        'Il network è presente continua
    ENDIF
                    
    PAUSE 10000             
    CONTAREG1=CONTAREG1+1
    IF CONTAREG1>30 THEN    
        GOTO ON_OFF         'resetta il modulo
    ENDIF            
    GOTO    ON_OFF1         
 
ON_OFF2:                    'Arriva qui se non risponde entro 60 secondi
    CONTAREG=CONTAREG+1
    IF CONTAREG>5 THEN     
        GOTO ON_OFF         'resetta il modulo
    ENDIF            
    GOTO    ON_OFF1        
 
ON_OFF3:                    'Network agganciato
    pause   1000 
    HSEROUT ["AT+CMEE=0",13]                'Disabilira report errori
    HSERIN  6000,ERRORE,[WAIT ("OK")]      
 
    pause   1000        
    HSEROUT ["AT+CMGF=1",13]                'Configura sms in formato testo
    HSERIN  6000,ERRORE,[WAIT ("OK")]       
 
    PAUSE   50
    hserout ["AT#MONI=0",13]                'Seleziona la cella di default
    HSERIN  2000,ERRORE,[WAIT ("OK")]       
 
    TMP=0
ON_OFF_CLIP:
    pause   1000        
    HSEROUT ["AT+CLIP=1",13]                'Abilita CLI calling line identification
    HSERIN  2000,ON_OFF_CLIP1,[WAIT ("OK")] 
    GOTO    ON_OFF_FINE                     
    
ON_OFF_CLIP1:
    TMP=TMP+1                       
    IF TMP=100 THEN                 
        GOTO ERRORE                
    ENDIF     
    GOTO    ON_OFF_CLIP
    
ON_OFF_FINE:
    LOW     LDGIALLO        'Spegni led giallo
    PAUSE   500             'E fai 4 lampeggi per segnalare configurazione
    HIGH    LDGIALLO        'gsm ultimata
    pause   400
    LOW     LDGIALLO   
    pause   400
    HIGH    LDGIALLO    
    pause   400
    LOW     LDGIALLO   
    pause   400
    HIGH    LDGIALLO    
    pause   400
    LOW     LDGIALLO 
    pause   400
    HIGH    LDGIALLO    
    pause   400
    LOW     LDGIALLO 
    
    return
   
'------------------------------------------------------------------------------
'SUBROUTINE ERRORE
 
ERRORE:
     pause  1000
     GOTO   START
     END
'------------------------------------------------------------------------------         
 
'-------------------------------------------------------------------------------
'SUBROUTINE RSTGSM      Resetta il gsm
 
RSTGSM:
    HIGH    LDGIALLO    'Accendi led gillo 
 
    HIGH RESETGSM       'Resetta il modulo
    PAUSE 1500
    LOW RESETGSM
    PAUSE 2000
    
    TRISA.4=0           'Imposta RA4 POWERGSM come uscita
    PAUSE 10
    LOW POWERGSM        'Accendi o spegni il modulo
    PAUSE 1500
    HIGH POWERGSM
    PAUSE 10
    TRISA.4=1           'Imposta RA4 POWERGSM come ingresso alta impedenza
 
    IF STATOGSM=0 THEN  
        PAUSE 2000
        GOTO  RSTGSM
    ENDIF        
 
    PAUSE 5000          'Pausa 5 sec
 
    pause   1000
    HSEROUT ["AT",13]                       'Vedi se il gsm è acceso
    HSERIN  2000,RSTGSM,[WAIT ("OK")]       
 
    pause   1000        
    HSEROUT ["AT+IPR=19200",13]             'Imposta velocità a 19200
    HSERIN  2000,RSTGSM,[WAIT ("OK")]      
 
    PAUSE   50
    HSEROUT ["AT#SELINT=2",13]              'Imposta modo Selint=2
    HSERIN  2000,RSTGSM1,[WAIT ("OK")]       
 
RSTGSM1:
    PAUSE   50
    hserout ["AT#MONI=0",13]                'Seleziona la cella di default
    HSERIN  2000,RSTGSM2,[WAIT ("OK")]       
 
RSTGSM2:
    PAUSE   50
    HSEROUT ["AT#REGMODE=1",13]             'Richiesta registrazione formale
    PAUSE   1000    
 
    LOW     LDGIALLO                        'Spegni led giallo
    RETURN
'-------------------------------------------------------------------------------    
 
 
 
'------------------------------------------------------------------------------
'ROUTINE LEGGINET           LEGGI DATI DEL NETWORK
 
LEGGINET:
 
    PAUSE   50
    hserout ["AT#MONI=0",13]            
    HSERIN  2000,ERRORE,[WAIT ("OK")]   
    PAUSE   50
    hserout ["AT#MONI",13]             
    HSERIN  2000,ESCILEGGINET,[WAIT ("#MONI:"),STR BUFF\160\10]
 
    PAUSE   100
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout [STR BUFF\160]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
 
ESCILEGGINET:
    RETURN
    
'------------------------------------------------------------------------------
'SUBROUTINE LEGGISMS
 
LEGGISMS:
            PAUSE   50
            HSEROUT ["AT+CMGL=",34,"ALL",34,13]     'Leggi messaggi SMS
            HSERIN 1000,EXITSMS,[SKIP 10,WAIT (34,",",34),STR MITTENTE\25\13]            
            HSERIN 1000,LEGGISMS,[WAIT (10),STR BUFF\160\10]
 
            HIGH    LDGIALLO
            PAUSE   3000
            LOW     LDGIALLO
 
            FOR TMP=0 TO 25             'Calcola lunghezza num mittente
                TMP1=MITTENTE[TMP]
                IF TMP1=34 THEN         
                    LUNGMITT=TMP
                    TMP=35
                ENDIF
            NEXT TMP            
 
            FOR TMP=0 TO 160            'Calcola lunghezza messaggio
                TMP1=BUFF[TMP]
                IF TMP1=13 THEN        
                    LUNGMESS=TMP
                    TMP=170
                ENDIF
            NEXT TMP
            
            PAUSE 2000
 
            PAUSE   50                 'Cancella tutti gli sms
            hserout ["AT+CMGD=1,4",13]
            GOSUB   ATTENDIOK
 
            PAUSE 1000
 
            'qui ho
            'in mittente il numero del mittente
            'in lungmitt lunghezza mittente
            'in buff il messaggio
            'in lungmess lunghezza messaggio
 
VERIF1:     IF BUFF[0]=82   then
                goto VERIF2
            ENDIF
            GOTO VERIFSMS9
VERIF2:     IF BUFF[1]=83   then
                goto VERIF3
            ENDIF
            GOTO VERIFSMS9
VERIF3:     IF BUFF[2]=84   then
                WRITE 1,0       'Segnala prima accensione
                goto RIPARTI    'riparti
            ENDIF
 
VERIFSMS9:
            IF  BUFF[0]=PASSWORD[0] THEN
                GOTO VERIFSMS10
            ENDIF
                GOTO EXITSMS1                
VERIFSMS10:
            IF  BUFF[1]=PASSWORD[1] THEN
                GOTO VERIFSMS11
            ENDIF
                GOTO EXITSMS1                
VERIFSMS11:
            IF  BUFF[2]=PASSWORD[2] THEN
                GOTO VERIFSMS12
            ENDIF
                GOTO EXITSMS1                
VERIFSMS12:
            IF  BUFF[3]=PASSWORD[3] THEN
                GOTO VERIFSMS13
            ENDIF
                GOTO EXITSMS1                
 
VERIFSMS13:
 
            PAUSE   10000   
 
            SELECT CASE BUFF[4]
 
                '--------------------------------------------------------------
                'Comando N 
                case 78,110             'N oppure n
                    GOSUB   LEGGINET    'Leggi dati network e invia al mittente
 
                '---------------------------------------------------------------               
                'Comando P (password) Programmazione nuova password
                case 80,112               'P oppure p
                    PASSWORDL[0]=BUFF[5]  
                    PASSWORDL[1]=BUFF[6]
                    PASSWORDL[2]=BUFF[7]
                    PASSWORDL[3]=BUFF[8]
 
                    PASSWORDL1[0]=BUFF[9]  
                    PASSWORDL1[1]=BUFF[10]
                    PASSWORDL1[2]=BUFF[11]
                    PASSWORDL1[3]=BUFF[12]
                
                    GOSUB   VERIFPAS        'Verifica se sono uguali
 
                    if tmp=1 then           'Se uguali carica in PASSWORD e EEPROM
                        PASSWORD[0]=PASSWORDL[0]
                        PASSWORD[1]=PASSWORDL[1]
                        PASSWORD[2]=PASSWORDL[2]
                        PASSWORD[3]=PASSWORDL[3]
                        WRITE 22,PASSWORD[0]       
                        WRITE 23,PASSWORD[1]       
                        WRITE 24,PASSWORD[2]       
                        WRITE 25,PASSWORD[3]       
 
                        PAUSE   100             'Invia sms di ok
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Command OK Password Updated"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       
                    
                    endif
 
                    PAUSE   100                 'Invia sms di errore
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    hserout ["Password Update Fail"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK       
                
                '---------------------------------------------------------------
                'Comando U (users) Programma numeri teleefono cellulare utenti
                case 85,117             'U oppure u
                    if  buff[5]=49 THEN
                        GOSUB   PRONUM1 'Programma numero 1
                    ENDIF
                    if  buff[5]=50 THEN
                        GOSUB   PRONUM2 'Programma numero 2
                    ENDIF
                    if  buff[5]=51 THEN
                        GOSUB   PRONUM3 'Programma numero 3
                    ENDIF
                    if  buff[5]=52 THEN
                        GOSUB   PRONUM4 'Programma numero 4
                    ENDIF
                    if  buff[5]=53 THEN
                        GOSUB   PRONUM5 'Programma numero 5
                    ENDIF
 
                    IF  BUFF[5]<>49 AND BUFF[5]<>50 AND BUFF[5]<>51 AND BUFF[5]<>52 AND BUFF[5]<>53 THEN
                        PAUSE   100                 
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Phone Update Fail"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       'Attendi ok in max 60 sec
                    ENDIF
 
                '---------------------------------------------------------------
                'Comando O Gestione uscite
                case 79,111              'O oppure o
                    IF BUFF[5]=82 OR BUFF[5]=114 THEN   'R oppure r gestione ripristino
                        if  buff[6]=49 THEN     'Se uguale a 1
                            RIPRISTUSCITE=1     'Abilita ripristino uscite
                            write   150,RIPRISTUSCITE
                            PAUSE   100         
                            hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                            PAUSE   2000
                            hserout ["Setup: Outputs Restore ON"]
                            PAUSE   100
                            hserout [26]
                            GOSUB   ATTENDIOK       'Attendi ok in max 60 sec
                        ELSE                    'Altrimenti
                            RIPRISTUSCITE=0     'Disabilita ripristino uscite
                            write   150,RIPRISTUSCITE
                            PAUSE   100         
                            hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                            PAUSE   2000
                            hserout ["Setup: Outputs Restore OFF"]
                            PAUSE   100
                            hserout [26]
                            GOSUB   ATTENDIOK     
                        endif
                    ENDIF
                    if  buff[5]=49 THEN
                        GOSUB   GESTOUT1 'Gestione uscita 1
                    ENDIF
                    if  buff[5]=50 THEN
                        GOSUB   GESTOUT2 'Gestione uscita 2
                    ENDIF
 
                    IF  BUFF[5]<>49 and BUFF[5]<>50 AND BUFF[5]<>51 AND BUFF[5]<>52 AND BUFF[5]<>53 THEN
                        PAUSE   100                 
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Output Fail"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    ENDIF
 
                '---------------------------------------------------------------
                'Comando I Programmazione modo di funzionamento ingressi
                case 73,105                 'I oppure i
                    IF  BUFF[5]=68 THEN     'Se è D allora setup ingr. digitali
                        if  buff[6]=49 THEN
                            GOSUB   SETIN1      'Setup ingresso digitale 1
                        ENDIF
                        if  buff[6]=50 THEN
                            GOSUB   SETIN2      'Setup ingresso digitale 2
                        ENDIF
                    ENDIF
                    
                    IF  BUFF[5]=65 THEN     'Se è A allora setup ingr. analogici
                        if  buff[6]=49 THEN
                            GOSUB   SETAN1      'Setup ingresso analogico 1
                        ENDIF
                        if  buff[6]=50 THEN
                            GOSUB   SETAN2      'Setup ingresso analogico 2
                        ENDIF
                    ENDIF                         
 
                '---------------------------------------------------------------
                'Comando A Riattiva ingresso disabilitato
                case 65,97              'A oppure a
                    if  buff[5]=49 THEN
                        INIBIN1=0       'Riabilita allarme ingresso digitale 1
                        PAUSE   100     
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: IN 1 Reactivated" ]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    ENDIF
                    if  buff[5]=50 THEN
                        INIBIN2=0       'Riabilita allarme ingresso digitale 2
                        PAUSE   100    
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: IN 2 Reactivated" ]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    ENDIF
                    if  buff[5]=51 THEN
                        INIBAN1=0       'Riabilita allarme ingresso analogico 1
                        PAUSE   100    
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: AN 1 Reactivated" ]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    ENDIF
                    if  buff[5]=52 THEN
                        INIBAN2=0       'Riabilita allarme ingresso analogico 2
                        PAUSE   100    
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: AN 2 Reactivated" ]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    ENDIF
                    if  buff[5]=48 THEN
                        INIBIN1=0       'Riabilita gestione di tutti 
                        INIBIN2=0       'gli ingressi
                        INIBAN1=0
                        INIBAN2=0
                        PAUSE   100     
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: All Inputs Reactivated" ]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       
                    ENDIF
                    if  buff[5]=54 THEN
                        RIATTIVAZIONE=1 'Seleziona riattivazione ingressi automatica
                        WRITE   155,RIATTIVAZIONE   
                        PAUSE   100    
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: Automatic Inputs Reactivation ON" ]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    ENDIF
                    if  buff[5]=55 THEN
                        RIATTIVAZIONE=0 'Seleziona riattivazione ingressi con sms
                        WRITE   155,RIATTIVAZIONE   'e salva in eeprom
                        PAUSE   100     
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: SMS Inputs Reactivation ON" ]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    ENDIF
 
                    IF  BUFF[5]<>54 AND BUFF[5]<>55 AND BUFF[5]<>48 and BUFF[5]<>49 and BUFF[5]<>50 AND BUFF[5]<>51 AND BUFF[5]<>52 AND BUFF[5]<>53 THEN
                        PAUSE   100                
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: Reactivated Fail" ]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       
                    ENDIF
 
                '---------------------------------------------------------------
                'Comando R Leggi I/O
                case 82,114                 'R oppure r
                    GOSUB INVIASTATO
 
                '---------------------------------------------------------------
                'Comando C Attiva squillo di alert
                case 67,99                  'C oppure c
                    if  buff[5]=49 THEN     'Se uguale a 1
                        FLAGCALL=1          'Abilita squillo di avviso
                        write   141,FLAGCALL
                        PAUSE   100         
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: Call After SMS Alert ON"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    ELSE                    'Altrimenti
                        FLAGCALL=0          'Disabilita squillo di avviso
                        write   141,FLAGCALL
                        PAUSE   100         
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: Call After SMS Alert OFF"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    endif
 
 
                '---------------------------------------------------------------
                'Comando E richiedi network                
                case 69,101             'E oppure e
                    IF BUFF[5]=67 OR BUFF[5]=99 THEN    'C oppure c
                        if  buff[6]=49 THEN     'Se uguale a 1
                            ECHOSMS=1           'Abilita echo sms
                            write   157,ECHOSMS
                            PAUSE   100        
                            hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                            PAUSE   2000
                            hserout ["Setup Echo SMS Abilitato" ]
                            PAUSE   100
                            hserout [26]
                            GOSUB   ATTENDIOK       
                        endif
 
                        if  buff[6]=48 THEN     'Se uguale a 0
                            ECHOSMS=0           'Disabilita echo sms
                            write   157,ECHOSMS
                            PAUSE   100        
                            hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                            PAUSE   2000
                            hserout ["Setup Echo SMS Disabilitato" ]
                            PAUSE   100
                            hserout [26]
                            GOSUB   ATTENDIOK     
                        endif
                    ENDIF
 
                '---------------------------------------------------------------
                'Comando F Leggi firmware e IMEI
                case 70,102              'F oppure f
                    GOSUB   LEGGIFIR
                
                '---------------------------------------------------------------
                'Comando S Attiva disattiva SMS di Start Up
                case 83,115                 'S oppure s 
                    if  buff[5]=49 THEN     'Se uguale a 1
                        SMSPUP=1            'Abilita sms di power up
                        write   140,SMSPUP
                        PAUSE   100         
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: SMS Power Up ON"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       
                    ENDIF
                    if  buff[5]=48 THEN     'Se uguale a 0
                        SMSPUP=0            'Disabilita sms di power up
                        write   140,SMSPUP
                        PAUSE   100         
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: SMS Power Up OFF"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       
                    endif
                    if  buff[5]=50 THEN     'Se uguale a 2
                        SMSPUP=2            'Abilita Call di power up
                        write   140,SMSPUP
                        PAUSE   100       
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: Call Power Up ON"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       
                    endif
               
               '---------------------------------------------------------------
                'Comando D Attiva / Disattiva funzione apricancello
                case 68,100                 'D oppure d   
                    if  buff[5]=49 THEN     'Se uguale a 1
                        CANCELLO=1          'Abilita funzione apricancello
                        write   148,CANCELLO
                        IF BUFF[6]=77 THEN      'Se uguale M
                            DOORMODE=77         'Imposta apricancello monostabile
                            WRITE   156,DOORMODE
                            PAUSE   100         
                            hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                            PAUSE   2000
                            hserout ["Setup: Out1 Gate Opener ON Monostable"]
                            PAUSE   100
                            hserout [26]
                            GOSUB   ATTENDIOK       'Attendi ok in max 60 sec
                        ENDIF
                        IF BUFF[6]=66 THEN      'Se uguale B
                            DOORMODE=66         'Imposta apricancello bistabile
                            WRITE   156,DOORMODE
                            PAUSE   100        
                            hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                            PAUSE   2000
                            hserout ["Setup: Out1 Gate Opener ON Bistable"]
                            PAUSE   100
                            hserout [26]
                            GOSUB   ATTENDIOK       
                        ENDIF
                        IF  BUFF[6]<>77 AND BUFF[6]<>66 THEN                                                
                            PAUSE   100
                            hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                            PAUSE   2000
                            hserout ["Command Not Recognized"]
                            PAUSE   100
                            hserout [26]
                            GOSUB   ATTENDIOK      
                        ENDIF                        
                    ELSE                    'Altrimenti
                        CANCELLO=0          'Disabilita funzione apricancello
                        write   148,CANCELLO
                        PAUSE   100        
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: Out1 Gate Opener OFF"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       
                    endif
 
               '---------------------------------------------------------------
                'Comando W Attiva / Disattiva squillo risposta al posto degli sms
                case 87,119                 'W oppure w    
                    if  buff[5]=49 THEN     'Se uguale a 1
                        RSQUILLO=1          'Abilita risposta con squillo
                        write   149,RSQUILLO
                        PAUSE   100         
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: Answer with Ring ON"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK       'Attendi ok in max 60 sec
                    ELSE                    'Altrimenti
                        RSQUILLO=0          'Disabilita risposta con squillo
                        write   149,RSQUILLO
                        PAUSE   100         
                        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                        PAUSE   2000
                        hserout ["Setup: Answer with Ring OFF"]
                        PAUSE   100
                        hserout [26]
                        GOSUB   ATTENDIOK      
                    endif
 
                '---------------------------------------------------------------
                'Comando M Aggiungi / Rimuovi numero per apricancello
                case 77,109                 'M oppure m   
                    if  buff[5]=65 THEN     'Se uguale a A 
                        GOSUB AGGIUNGISIM   'Aggiungi numero in memoria SIM
                    ENDIF
                    if  buff[5]=82 THEN     'Se uguale a R 
                        GOSUB RIMUOVISIM    'Rimuivi numero dalla memoria SIM
                    ENDIF
                    if  buff[5]=63 THEN     'Se uguale a ?
                        GOSUB STATOSIM      'Invia sms risposta con stato sim
                    ENDIF
 
                '---------------------------------------------------------------
                'Nessun comando riconosciuto
                case else
                    PAUSE   100
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    hserout ["Command Not Recognized"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK      
            
            end select    
 
            pause 200
            RETURN           'Ritorno
 
EXITSMS:
            PAUSE 200
            RETURN
 
EXITSMS1:
                                   
            IF ECHOSMS=1 THEN                   'Se echo sms abilitato
                IF LUNGTEL1>5 THEN             
                    PAUSE   100                
                    hserout ["AT+CMGS=",34,str TELEFONO1\LUNGTEL1,34,13]
                    PAUSE   2000
                    HSEROUT ["ECHO SMS : ",STR BUFF\LUNGMESS]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK       
 
                    PAUSE 10000     
                endif       
            ENDIF
            
            LOW     LDGIALLO        'Spegni led giallo
            PAUSE   500             'E fai 3 lampeggi per segnalare 
            HIGH    LDGIALLO        'password errata
            pause   400
            LOW     LDGIALLO   
            pause   400
            HIGH    LDGIALLO    
            pause   400
            LOW     LDGIALLO   
            pause   400
            HIGH    LDGIALLO    
            pause   400
            LOW     LDGIALLO 
            
            RETURN            
            
'------------------------------------------------------------------------------
 
'------------------------------------------------------------------------------
'SUBROUTINE VERIFID
'Verifica che il nuovo id inviato due volte coincida
 
VERIFID:
        TMP=0
        
        IF IDDISPL[0]<>IDDISPL1[0] THEN
            GOTO ESCIVERIFID
        ENDIF
        IF IDDISPL[1]<>IDDISPL1[1] THEN
            GOTO ESCIVERIFID
        ENDIF
        IF IDDISPL[2]<>IDDISPL1[2] THEN
            GOTO ESCIVERIFID
        ENDIF
        IF IDDISPL[3]<>IDDISPL1[3] THEN
            GOTO ESCIVERIFID
        ENDIF
 
        TMP=1   'Segnala che sono uguali
                
ESCIVERIFID:
        RETURN
        
 
'------------------------------------------------------------------------------
'SUBROUTINE VERIFPAS
'Verifica che la nuova password inviata due volte coincida
 
VERIFPAS:
        TMP=0
        
        IF PASSWORDL[0]<>PASSWORDL1[0] THEN
            GOTO ESCIVERIFPAS
        ENDIF
        IF PASSWORDL[1]<>PASSWORDL1[1] THEN
            GOTO ESCIVERIFPAS
        ENDIF
        IF PASSWORDL[2]<>PASSWORDL1[2] THEN
            GOTO ESCIVERIFPAS
        ENDIF
        IF PASSWORDL[3]<>PASSWORDL1[3] THEN
            GOTO ESCIVERIFPAS
        ENDIF
 
        TMP=1   'Segnala che sono uguali
                
ESCIVERIFPAS:
        RETURN
        
 
 
'------------------------------------------------------------------------------
'ROUTINE LEGGIFIR           LEGGI DATI FIRMWARE
 
LEGGIFIR:
    PAUSE   50
    hserout ["AT#CGMR",13]              
    HSERIN  2000,ESCILEGGINET,[WAIT ("#CGMR:"),STR BUFF\160\10]
 
    PAUSE   50
    hserout ["AT#CGSN",13]             
    HSERIN  2000,ESCILEGGINET,[WAIT ("#CGSN:"),STR BUFF1\160\10]
    
    PAUSE   100
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["GSM-C622 R12,",STR BUFF\160,",",STR BUFF1\160]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK      
 
ESCILEGGIFIR:
    RETURN                
 
'------------------------------------------------------------------------------
'ROUTINE PRONUM1                    Programma numero di telfono 1
 
PRONUM1:
 
    FOR TMP=6 TO 22             
    TMP1=BUFF[TMP]
        IF TMP1=42 THEN             
            LUNGTEL1=TMP            
            TMP=40                 
        ENDIF
    NEXT TMP               
    LUNGTEL1=LUNGTEL1-6            
 
    TMP1=0                         
    FOR TMP=6 TO 21                 
        TELEFONO1[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
 
    'Salva il numero e la lunghezza in EEPROM
    WRITE   30,TELEFONO1[0]         'Telefono 1 Cifra 1
    WRITE   31,TELEFONO1[1]         'Telefono 1 Cifra 2
    WRITE   32,TELEFONO1[2]         'Telefono 1 Cifra 3
    WRITE   33,TELEFONO1[3]         'Telefono 1 Cifra 4
    WRITE   34,TELEFONO1[4]         'Telefono 1 Cifra 5
    WRITE   35,TELEFONO1[5]         'Telefono 1 Cifra 6
    WRITE   36,TELEFONO1[6]         'Telefono 1 Cifra 7
    WRITE   37,TELEFONO1[7]         'Telefono 1 Cifra 8
    WRITE   38,TELEFONO1[8]         'Telefono 1 Cifra 9
    WRITE   39,TELEFONO1[9]         'Telefono 1 Cifra 10
    WRITE   40,TELEFONO1[10]        'Telefono 1 Cifra 11
    WRITE   41,TELEFONO1[11]        'Telefono 1 Cifra 12
    WRITE   42,TELEFONO1[12]        'Telefono 1 Cifra 13
    WRITE   43,TELEFONO1[13]        'Telefono 1 Cifra 14
    WRITE   44,TELEFONO1[14]        'Telefono 1 Cifra 15
    WRITE   45,TELEFONO1[15]        'Telefono 1 Cifra 16
    WRITE   46,LUNGTEL1             'Telefono 1 Lunghezza
 
    PAUSE   100                    
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Command OK Phone 1 Updated: ",STR TELEFONO1\LUNGTEL1]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
 
    RETURN
    
'------------------------------------------------------------------------------
'ROUTINE PRONUM2                    Programma numero di telfono 2
 
PRONUM2:
 
    FOR TMP=6 TO 22             
    TMP1=BUFF[TMP]
        IF TMP1=42 THEN             
            LUNGTEL2=TMP           
            TMP=40                 
        ENDIF
    NEXT TMP               
    LUNGTEL2=LUNGTEL2-6            
 
    TMP1=0                          
    FOR TMP=6 TO 21                
        TELEFONO2[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
 
    'Salva il numero e la lunghezza in EEPROM
    WRITE   50,TELEFONO2[0]         'Telefono 2 Cifra 1
    WRITE   51,TELEFONO2[1]         'Telefono 2 Cifra 2
    WRITE   52,TELEFONO2[2]         'Telefono 2 Cifra 3
    WRITE   53,TELEFONO2[3]         'Telefono 2 Cifra 4
    WRITE   54,TELEFONO2[4]         'Telefono 2 Cifra 5
    WRITE   55,TELEFONO2[5]         'Telefono 2 Cifra 6
    WRITE   56,TELEFONO2[6]         'Telefono 2 Cifra 7
    WRITE   57,TELEFONO2[7]         'Telefono 2 Cifra 8
    WRITE   58,TELEFONO2[8]         'Telefono 2 Cifra 9
    WRITE   59,TELEFONO2[9]         'Telefono 2 Cifra 10
    WRITE   60,TELEFONO2[10]        'Telefono 2 Cifra 11
    WRITE   61,TELEFONO2[11]        'Telefono 2 Cifra 12
    WRITE   62,TELEFONO2[12]        'Telefono 2 Cifra 13
    WRITE   63,TELEFONO2[13]        'Telefono 2 Cifra 14
    WRITE   64,TELEFONO2[14]        'Telefono 2 Cifra 15
    WRITE   65,TELEFONO2[15]        'Telefono 2 Cifra 16
    WRITE   66,LUNGTEL2             'Telefono 2 Lunghezza
 
    PAUSE   100                     
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Command OK Phone 2 Updated: ",STR TELEFONO2\LUNGTEL2]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK      
 
    RETURN
            
'------------------------------------------------------------------------------
'ROUTINE PRONUM3                    Programma numero di telfono 3
 
PRONUM3:
 
    FOR TMP=6 TO 22             
    TMP1=BUFF[TMP]
        IF TMP1=42 THEN            
            LUNGTEL3=TMP           
            TMP=40                  
        ENDIF
    NEXT TMP               
    LUNGTEL3=LUNGTEL3-6           
 
    TMP1=0                          
    FOR TMP=6 TO 21               
        TELEFONO3[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
 
    'Salva il numero e la lunghezza in EEPROM
    WRITE   70,TELEFONO3[0]         'Telefono 3 Cifra 1
    WRITE   71,TELEFONO3[1]         'Telefono 3 Cifra 2
    WRITE   72,TELEFONO3[2]         'Telefono 3 Cifra 3
    WRITE   73,TELEFONO3[3]         'Telefono 3 Cifra 4
    WRITE   74,TELEFONO3[4]         'Telefono 3 Cifra 5
    WRITE   75,TELEFONO3[5]         'Telefono 3 Cifra 6
    WRITE   76,TELEFONO3[6]         'Telefono 3 Cifra 7
    WRITE   77,TELEFONO3[7]         'Telefono 3 Cifra 8
    WRITE   78,TELEFONO3[8]         'Telefono 3 Cifra 9
    WRITE   79,TELEFONO3[9]         'Telefono 3 Cifra 10
    WRITE   80,TELEFONO3[10]        'Telefono 3 Cifra 11
    WRITE   81,TELEFONO3[11]        'Telefono 3 Cifra 12
    WRITE   82,TELEFONO3[12]        'Telefono 3 Cifra 13
    WRITE   83,TELEFONO3[13]        'Telefono 3 Cifra 14
    WRITE   84,TELEFONO3[14]        'Telefono 3 Cifra 15
    WRITE   85,TELEFONO3[15]        'Telefono 3 Cifra 16
    WRITE   86,LUNGTEL3             'Telefono 3 Lunghezza
 
    PAUSE   100                     
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Command OK Phone 3 Updated: ",STR TELEFONO3\LUNGTEL3]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK      
 
    RETURN
 
'------------------------------------------------------------------------------
'ROUTINE PRONUM4                    Programma numero di telfono 4
 
PRONUM4:
 
    FOR TMP=6 TO 22             
    TMP1=BUFF[TMP]
        IF TMP1=42 THEN             
            LUNGTEL4=TMP            
            TMP=40                 
        ENDIF
    NEXT TMP               
    LUNGTEL4=LUNGTEL4-6            
 
    TMP1=0                          
    FOR TMP=6 TO 21                
        TELEFONO4[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
 
    'Salva il numero e la lunghezza in EEPROM
    WRITE   90,TELEFONO4[0]         'Telefono 4 Cifra 1
    WRITE   91,TELEFONO4[1]         'Telefono 4 Cifra 2
    WRITE   92,TELEFONO4[2]         'Telefono 4 Cifra 3
    WRITE   93,TELEFONO4[3]         'Telefono 4 Cifra 4
    WRITE   94,TELEFONO4[4]         'Telefono 4 Cifra 5
    WRITE   95,TELEFONO4[5]         'Telefono 4 Cifra 6
    WRITE   96,TELEFONO4[6]         'Telefono 4 Cifra 7
    WRITE   97,TELEFONO4[7]         'Telefono 4 Cifra 8
    WRITE   98,TELEFONO4[8]         'Telefono 4 Cifra 9
    WRITE   99,TELEFONO4[9]         'Telefono 4 Cifra 10
    WRITE   100,TELEFONO4[10]        'Telefono 4 Cifra 11
    WRITE   101,TELEFONO4[11]        'Telefono 4 Cifra 12
    WRITE   102,TELEFONO4[12]        'Telefono 4 Cifra 13
    WRITE   103,TELEFONO4[13]        'Telefono 4 Cifra 14
    WRITE   104,TELEFONO4[14]        'Telefono 4 Cifra 15
    WRITE   105,TELEFONO4[15]        'Telefono 4 Cifra 16
    WRITE   106,LUNGTEL4             'Telefono 4 Lunghezza
 
    PAUSE   100                    
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Command OK Phone 4 Updated: ",STR TELEFONO4\LUNGTEL4]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
 
    RETURN
 
'------------------------------------------------------------------------------
'ROUTINE PRONUM5                    Programma numero di telefono 5
 
PRONUM5:
 
    FOR TMP=6 TO 22             
    TMP1=BUFF[TMP]
        IF TMP1=42 THEN             
            LUNGTEL5=TMP            
            TMP=40                  
        ENDIF
    NEXT TMP               
    LUNGTEL5=LUNGTEL5-6            
 
    TMP1=0                          
    FOR TMP=6 TO 21                
        TELEFONO5[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
 
    'Salva il numero e la lunghezza in EEPROM
    WRITE   110,TELEFONO5[0]         'Telefono 5 Cifra 1
    WRITE   111,TELEFONO5[1]         'Telefono 5 Cifra 2
    WRITE   112,TELEFONO5[2]         'Telefono 5 Cifra 3
    WRITE   113,TELEFONO5[3]         'Telefono 5 Cifra 4
    WRITE   114,TELEFONO5[4]         'Telefono 5 Cifra 5
    WRITE   115,TELEFONO5[5]         'Telefono 5 Cifra 6
    WRITE   116,TELEFONO5[6]         'Telefono 5 Cifra 7
    WRITE   117,TELEFONO5[7]         'Telefono 5 Cifra 8
    WRITE   118,TELEFONO5[8]         'Telefono 5 Cifra 9
    WRITE   119,TELEFONO5[9]         'Telefono 5 Cifra 10
    WRITE   120,TELEFONO5[10]        'Telefono 5 Cifra 11
    WRITE   121,TELEFONO5[11]        'Telefono 5 Cifra 12
    WRITE   122,TELEFONO5[12]        'Telefono 5 Cifra 13
    WRITE   123,TELEFONO5[13]        'Telefono 5 Cifra 14
    WRITE   124,TELEFONO5[14]        'Telefono 5 Cifra 15
    WRITE   125,TELEFONO5[15]        'Telefono 5 Cifra 16
    WRITE   126,LUNGTEL5             'Telefono 5 Lunghezza
 
    PAUSE   100                    
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Command OK Phone 5 Updated: ",STR TELEFONO5\LUNGTEL5]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK      
 
    RETURN
 
 
                
    
'------------------------------------------------------------------------------
'ROUTINE INVIASTATO           invia messaggio con stato I/O
 
INVIASTATO:
 
        IF SOUT1=1 THEN    
            CAROUT1[0]=79   
            CAROUT1[1]=78   
            CAROUT1[2]=0   
        ELSE
            CAROUT1[0]=79   
            CAROUT1[1]=70   
            CAROUT1[2]=70   
        ENDIF            
 
        IF SOUT2=1 THEN    
            CAROUT2[0]=79   
            CAROUT2[1]=78     
            CAROUT2[2]=0    
        ELSE
            CAROUT2[0]=79   
            CAROUT2[1]=70   
            CAROUT2[2]=70   
        ENDIF            
 
 
        IF INGRESSO1=0 THEN     
            CARIN1=72       
        ELSE
            CARIN1=76       
        ENDIF
        
        IF INGRESSO2=0 THEN     
            CARIN2=72       
        ELSE
            CARIN2=76       
        ENDIF
 
        TMP2 = INANA1       
        TMP2 = TMP2 * 49    
        TMP2 = TMP2 / 10
        INANA1V = TMP2      
        
        TMP2 = INANA2      
        TMP2 = TMP2 * 49    
        TMP2 = TMP2 / 10
        INANA2V = TMP2      
 
        PAUSE   100         'Invia al mittente stato I/O e AD
        hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
        PAUSE   2000
        HSEROUT ["OUT1=",str CAROUT1\3," OUT2=",str CAROUT2\3," IN1=",str CARIN1\1," IN2=",str CARIN2\1," AN1=",DEC INANA1,"(",DEC INANA1V,"mV)"," AN2=",DEC INANA2,"(",DEC INANA2V,"mV)"]
 
        PAUSE   100
        hserout [26]
        GOSUB   ATTENDIOK      
 
        RETURN
 
'------------------------------------------------------------------------------
'ROUTINE GESTOUT1           'Gestione uscita 1
 
GESTOUT1:
 
        if  buff[7]=78 OR buff[7]=110 THEN   'Se c'e' una N il comando è ON
 
            IF BUFF[8]=49 or BUFF[8]=50 or BUFF[8]=51 or BUFF[8]=52 or BUFF[8]=53 or BUFF[8]=54 or BUFF[8]=55 or BUFF[8]=56 or BUFF[8]=57 THEN
                                       
                                        'Chiudi per il tempo impostato
                TMP=BUFF[8]
                PAUSE   100             'Invia prima al mittente risposta
                if RSQUILLO=1 THEN      'Se rsquillo abilitato rispondi con squillo
                    PAUSE 1000          'Manda uno squillo di risposta
                    HSEROUT ["ATD ",str MITTENTE\LUNGMITT,";",13]
                    pause 15000
                    hserout["ATH",13] 
                    pause 1000
                ELSE                     'Altrimenti manda un sms di risposta
                    PAUSE   50
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    HSEROUT ["OUT 1 ON ",str TMP\1," sec"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK       
                ENDIF
                TMP=BUFF[8]-48         'Trasforma caratterere in numero e metti in tmp
                TMP2=TMP*1000
                HIGH USCITA1            
                PAUSE TMP2              
                LOW USCITA1             
                GOTO ENDGESTOUT1        
            ELSE                        'Altrimenti chiudi 
                                        'relè in modo permanente
                HIGH USCITA1            
                SOUT1=1                 
                WRITE 130,SOUT1                                     
                PAUSE   100             
                if RSQUILLO=1 THEN      
                    PAUSE 1000          
                    HSEROUT ["ATD ",str MITTENTE\LUNGMITT,";",13]
                    pause 15000
                    hserout["ATH",13] 
                    pause 1000
                ELSE                     
                    PAUSE   50
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    HSEROUT ["OUT 1 ON"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK       
                ENDIF
                goto    ENDGESTOUT1     
            endif
            GOTO    ENDGESTOUT1          
        ENDIF
 
        IF  BUFF[7]=70 OR BUFF[7]=102  THEN  'Se c'e' una F il comando è OFF
            IF BUFF[9]=49 or BUFF[9]=50 or BUFF[9]=51 or BUFF[9]=52 or BUFF[9]=53 or BUFF[9]=54 or BUFF[9]=55 or BUFF[9]=56 or BUFF[9]=57 THEN
                                        
                TMP=BUFF[9]             'Apri per tempo impostato
                PAUSE   100             
                if RSQUILLO=1 THEN      
                    PAUSE 1000          
                    HSEROUT ["ATD ",str MITTENTE\LUNGMITT,";",13]
                    pause 15000
                    hserout["ATH",13] 
                    pause 1000
                ELSE                     'Altrimenti manda un sms di risposta
                    PAUSE   50
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    HSEROUT ["OUT 1 OFF ",str TMP\1," sec"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK       
                ENDIF
                TMP=BUFF[9]-48         'Trasforma caratterere in numero e metti in tmp
                TMP2=TMP*1000
                LOW USCITA1             
                PAUSE TMP2             
                HIGH USCITA1            
                GOTO ENDGESTOUT1        
            ELSE                        
                                        'apri relè in modo permanente
                low USCITA1            
                SOUT1=0                 
                WRITE 130,SOUT1                                      
                PAUSE   100             
                if RSQUILLO=1 THEN      'Se rsquillo abilitato rispondi con squillo
                    PAUSE 1000          
                    HSEROUT ["ATD ",str MITTENTE\LUNGMITT,";",13]
                    pause 15000
                    hserout["ATH",13] 
                    pause 1000
                ELSE                     'Altrimenti manda un sms di risposta
                    PAUSE   50
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    HSEROUT ["OUT 1 OFF"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK      
                ENDIF
                goto    ENDGESTOUT1     
            endif            
            GOTO    ENDGESTOUT1
        ENDIF
 
ENDGESTOUT1:
        RETURN
 
 
'------------------------------------------------------------------------------
'ROUTINE GESTOUT2           'Gestione uscita 2
 
GESTOUT2:
 
        if  buff[7]=78 OR buff[7]=110 THEN     'Se c'e' una N il comando è ON
            IF BUFF[8]=49 or BUFF[8]=50 or BUFF[8]=51 or BUFF[8]=52 or BUFF[8]=53 or BUFF[8]=54 or BUFF[8]=55 or BUFF[8]=56 or BUFF[8]=57 THEN
                                        
                TMP=BUFF[8]             'Chiudi per tempo impostato
                PAUSE   100             
                if RSQUILLO=1 THEN      
                    PAUSE 1000          'Manda uno squillo di risposta
                    HSEROUT ["ATD ",str MITTENTE\LUNGMITT,";",13]
                    pause 15000
                    hserout["ATH",13] 
                    pause 1000
                ELSE                     'Altrimenti manda un sms di risposta
                    PAUSE   50
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    HSEROUT ["OUT 2 ON ",str TMP\1," sec"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK       
                ENDIF
                TMP=BUFF[8]-48         'Trasforma caratterere in numero e metti in tmp
                TMP2=TMP*1000
                HIGH USCITA2           
                PAUSE TMP2              
                LOW USCITA2            
                GOTO ENDGESTOUT2        
            ELSE                       
                                        'chiudi relè in modo permanente
                HIGH USCITA2           
                SOUT2=1                 
                WRITE 131,SOUT2                                    
                PAUSE   100             
                if RSQUILLO=1 THEN      'Se rsquillo abilitato rispondi con squillo
                    PAUSE 1000         
                    HSEROUT ["ATD ",str MITTENTE\LUNGMITT,";",13]
                    pause 15000
                    hserout["ATH",13] 
                    pause 1000
                ELSE                     'Altrimenti manda un sms di risposta
                    PAUSE   50
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    HSEROUT ["OUT 2 ON"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK       
                ENDIF
                goto    ENDGESTOUT2     
            endif
            GOTO    ENDGESTOUT2        
        ENDIF
 
        IF  BUFF[7]=70 OR BUFF[7]=102 THEN     'Se c'e' una F il comando è OFF
            IF BUFF[9]=49 or BUFF[9]=50 or BUFF[9]=51 or BUFF[9]=52 or BUFF[9]=53 or BUFF[9]=54 or BUFF[9]=55 or BUFF[9]=56 or BUFF[9]=57 THEN
                                       
                TMP=BUFF[9]             'Apri per tempo impostato
                PAUSE   100             
                if RSQUILLO=1 THEN      
                    PAUSE 1000          
                    HSEROUT ["ATD ",str MITTENTE\LUNGMITT,";",13]
                    pause 15000
                    hserout["ATH",13] 
                    pause 1000
                ELSE                     'Altrimenti manda un sms di risposta
                    PAUSE   50
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    HSEROUT ["OUT 2 OFF ",str TMP\1," sec"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK      
                ENDIF
                TMP=BUFF[9]-48         'Trasforma caratterere in numero e metti in tmp
                TMP2=TMP*1000
                LOW USCITA2             
                PAUSE TMP2             
                HIGH USCITA2           
                GOTO ENDGESTOUT2       
            ELSE                       
                                        'apri relè in modo permanente
                low USCITA2            
                SOUT2=0                
                WRITE 131,SOUT2                                         
                PAUSE   100             
                if RSQUILLO=1 THEN      'Se rsquillo abilitato rispondi con squillo
                    PAUSE 1000         
                    HSEROUT ["ATD ",str MITTENTE\LUNGMITT,";",13]
                    pause 15000
                    hserout["ATH",13] 
                    pause 1000
                ELSE                     'Altrimenti manda un sms di risposta
                    PAUSE   50
                    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
                    PAUSE   2000
                    HSEROUT ["OUT 2 OFF"]
                    PAUSE   100
                    hserout [26]
                    GOSUB   ATTENDIOK       
                ENDIF
                goto    ENDGESTOUT2     
            endif            
            GOTO    ENDGESTOUT2
        ENDIF
 
ENDGESTOUT2:
        RETURN
 
'------------------------------------------------------------------------------
'ROUTINE RIPRISTINO             Dopo l'accensione ripristina stato uscite
 
RIPRISTINO:
 
        IF  RIPRISTUSCITE=1 THEN    'Se ripristino uscite abilitato
            GOTO RIPRISTINO1        'vai a ripristinare
        ENDIF
        GOTO FINERIPRISTINO        
 
 
RIPRISTINO1:
        READ    130,SOUT1        'Carica nelle variabili lo stato delle uscite
        READ    131,SOUT2
        
        IF SOUT1=0 THEN         'Aggiorna uscita 1
            LOW USCITA1
        ELSE
            HIGH USCITA1
        ENDIF
        
        IF SOUT2=0 THEN         'Aggiorna uscita 2
            LOW USCITA2
        ELSE
            HIGH USCITA2
        ENDIF
 
FINERIPRISTINO:        
        RETURN
        
 
'------------------------------------------------------------------------------
'ROUTINE LEGGIIN             Leggi ingressi e vedi se devi denerare allarme
 
LEGGIIN:
    'Ingresso 1
    IF MODFUNZIN1=0 THEN            'Se in 1 impostato per lavorare attivo basso
        IF INIBIN1=0 THEN           'e inibizione non attiva
            IF INGRESSO1=0 THEN     'e ingresso 1 è basso
                pause TPERMIN1*1000     
              
                IF INGRESSO1=0 then    
                    FRASE=1
                    GOSUB ALARMIN       'allora allarme ingresso
                    INIBIN1=1          'Inibisci ingresso 1
                ENDIF
            ENDIF
        ENDIF
    ENDIF
    IF MODFUNZIN1=1 THEN            'Se in 1 impostato per lavorare attivo alto
        IF INIBIN1=0 THEN           'e inibizione non attiva
            IF INGRESSO1=1 THEN     'e ingresso 1 è alto
                pause TPERMIN1*1000    
               
                if INGRESSO1=1 THEN
                    FRASE=2
                    GOSUB ALARMIN       'allora allarme ingresso
                    INIBIN1=1          'Inibisci ingresso 1
                ENDIF
            ENDIF
        ENDIF
    ENDIF
    'Ingresso 2
    IF MODFUNZIN2=0 THEN            'Se in 2 impostato per lavorare attivo basso
        IF INIBIN2=0 THEN           'e inibizione non attiva
            IF INGRESSO2=0 THEN     'e ingresso 2 è basso
                pause TPERMIN2*1000      
               
                IF INGRESSO2=0 THEN 
                    FRASE=3
                    GOSUB ALARMIN       'allora allarme ingresso
                    INIBIN2=1          'Inibisci ingresso 2
                ENDIF
            ENDIF
        ENDIF
    ENDIF
    IF MODFUNZIN2=1 THEN            'Se in 2 impostato per lavorare attivo alto
        IF INIBIN2=0 THEN           'e inibizione non attiva
            IF INGRESSO2=1 THEN     'e ingresso 2 è alto
                pause TPERMIN2*1000     
               
                IF INGRESSO2=1 THEN
                    FRASE=4
                    GOSUB ALARMIN       'allora allarme ingresso
                    INIBIN2=1          'Inibisci ingresso 2
                ENDIF
            ENDIF
        ENDIF
    ENDIF
 
    RETURN
 
'------------------------------------------------------------------------------
'ROUTINE ALARMIN       'Invia sms causa allarme ingresso 
        
ALARMIN:
 
'Prendi da eeprom il testo da inviare
    SELECT CASE FRASE           'Vedi la locazione di partenza
    CASE 1
    TMP2=200                    'locazione 200
    CASE 2
    TMP2=200                    'locazione 200
    CASE 3
    TMP2=300                    'locazione 300
    CASE 4
    TMP2=300                    'locazione 300
    CASE 5
    TMP2=400                    'locazione 400
    CASE 6
    TMP2=400                    'locazione 400
    CASE 7
    TMP2=500                    'locazione 500
    CASE 8
    TMP2=500                    'locazione 500
    CASE 9
    TMP2=600                    'eeprom locazione 600
    CASE 10
    TMP2=600                    'eeprom locazione 600
    END SELECT
 
                                'Leggi testo allarme in eeprom 
    FOR TMP=0 TO 80             'partendo dalla locazione tmp2 calcolata
        READ TMP2,TESTOALLARME[TMP]  
        TMP2=TMP2+1
        PAUSE 10
    NEXT TMP
 
    FOR TMP=0 TO 80           'In TESTOALLARME da 0 a 80 ai sms di allarme evento  
    TMP1=TESTOALLARME[TMP]              
            IF TMP1=42 THEN     
            LUNGALLARME=TMP     
            TMP=90               
        ENDIF
    NEXT TMP               
 
    'Calcola valore letto ad in mV
    TMP2 = INANA1       'Trasferisci lettura in variabile word
    TMP2 = TMP2 * 49    'Calcola valore in mV
    TMP2 = TMP2 / 10
    INANA1V = TMP2      
    TMP2 = INANA2      
    TMP2 = TMP2 * 49    
    TMP2 = TMP2 / 10
    INANA2V = TMP2     
 
'Invia sms di allarme al telefono 1 
ALARMINT1:                              
        IF LUNGTEL1>5 THEN              'Se telefono 1 memorizzato
            PAUSE   100                 'Invia al telefono 1 
            hserout ["AT+CMGS=",34,str TELEFONO1\LUNGTEL1,34,13]
            PAUSE   2000
       
            SELECT CASE FRASE 
            CASE 1
            HSEROUT ["Alarm IN1 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 2
            HSEROUT ["Alarm IN1 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 3
            HSEROUT ["Alarm IN2 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 4
            HSEROUT ["Alarm IN2 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 5
            HSEROUT ["Alarm AN1 Less Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 6
            HSEROUT ["Alarm AN1 Over Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 7
            HSEROUT ["Alarm AN2 Less Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 8
            HSEROUT ["Alarm AN2 Over Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            END SELECT
        
            PAUSE   100
            hserout [26]
            GOSUB   ATTENDIOK       
 
            PAUSE 10000     
 
            if FLAGCALL=1 THEN
                PAUSE 1000          'Manda anche uno squillo per avvisare arrivo sms
                HSEROUT ["ATD ",str TELEFONO1\LUNGTEL1,";",13]
              
                pause 15000
                hserout["ATH",13] 
                pause 1000
            ENDIF
        endif       
 
'Invia sms di allarme al telefono 2 
ALARMINT2:                              
        IF LUNGTEL2>5 THEN              'Se telefono 2 memorizzato
            PAUSE   100                 'Invia al telefono 2 
            hserout ["AT+CMGS=",34,str TELEFONO2\LUNGTEL2,34,13]
            PAUSE   2000
       
            SELECT CASE FRASE 
            CASE 1
            HSEROUT ["Alarm IN 1 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 2
            HSEROUT ["Alarm IN 1 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 3
            HSEROUT ["Alarm IN 2 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 4
            HSEROUT ["Alarm IN 2 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 5
            HSEROUT ["Alarm AN1 Less Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 6
            HSEROUT ["Alarm AN1 Over Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 7
            HSEROUT ["Alarm AN2 Less Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 8
            HSEROUT ["Alarm AN2 Over Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            END SELECT
        
            PAUSE   100
            hserout [26]
            GOSUB   ATTENDIOK       
 
            PAUSE 10000     
 
            if FLAGCALL=1 THEN
                PAUSE 1000          'Manda anche uno squillo per avvisare arrivo sms
                HSEROUT ["ATD ",str TELEFONO2\LUNGTEL2,";",13]
          
                pause 15000
                hserout["ATH",13] 
                pause 1000
            ENDIF
 
        endif       
 
'Invia sms di allarme al telefono 3
ALARMINT3:                              
        IF LUNGTEL3>5 THEN              'Se telefono 3 memorizzato
            PAUSE   100                 'Invia al telefono 3 
            hserout ["AT+CMGS=",34,str TELEFONO3\LUNGTEL3,34,13]
            PAUSE   2000
       
            SELECT CASE FRASE 
            CASE 1
            HSEROUT ["Alarm IN 1 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 2
            HSEROUT ["Alarm IN 1 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 3
            HSEROUT ["Alarm IN 2 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 4
            HSEROUT ["Alarm IN 2 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 5
            HSEROUT ["Alarm AN1 Less Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 6
            HSEROUT ["Alarm AN1 Over Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 7
            HSEROUT ["Alarm AN2 Less Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 8
            HSEROUT ["Alarm AN2 Over Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            END SELECT
        
            PAUSE   100
            hserout [26]
            GOSUB   ATTENDIOK       
 
            PAUSE 10000     
 
            if FLAGCALL=1 THEN
                PAUSE 1000          'Manda anche uno squillo per avvisare arrivo sms
                HSEROUT ["ATD ",str TELEFONO3\LUNGTEL3,";",13]
             
                pause 15000
                hserout["ATH",13] 
                pause 1000
            ENDIF
 
        endif       
 
'Invia sms di allarme al telefono 4
ALARMINT4:                              
        IF LUNGTEL4>5 THEN              'Se telefono 4 memorizzato
            PAUSE   100                 'Invia al telefono 4
            hserout ["AT+CMGS=",34,str TELEFONO4\LUNGTEL4,34,13]
            PAUSE   2000
       
            SELECT CASE FRASE 
            CASE 1
            HSEROUT ["Alarm IN 1 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 2
            HSEROUT ["Alarm IN 1 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 3
            HSEROUT ["Alarm IN 2 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 4
            HSEROUT ["Alarm IN 2 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 5
            HSEROUT ["Alarm AN1 Less Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 6
            HSEROUT ["Alarm AN1 Over Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 7
            HSEROUT ["Alarm AN2 Less Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 8
            HSEROUT ["Alarm AN2 Over Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            END SELECT
        
            PAUSE   100
            hserout [26]
            GOSUB   ATTENDIOK       
 
            PAUSE 10000    
 
            if FLAGCALL=1 THEN
                PAUSE 1000          'Manda anche uno squillo per avvisare arrivo sms
                HSEROUT ["ATD ",str TELEFONO4\LUNGTEL4,";",13]
              
                pause 15000
                hserout["ATH",13] 
                pause 1000
            ENDIF
 
        endif       
 
'Invia sms di allarme al telefono 5
ALARMINT5:                              
        IF LUNGTEL5>5 THEN              'Se telefono 5 memorizzato
            PAUSE   100                 'Invia al telefono 5
            hserout ["AT+CMGS=",34,str TELEFONO5\LUNGTEL5,34,13]
            PAUSE   2000
       
            SELECT CASE FRASE 
            CASE 1
            HSEROUT ["Alarm IN 1 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 2
            HSEROUT ["Alarm IN 1 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 3
            HSEROUT ["Alarm IN 2 V Present : ",STR TESTOALLARME\LUNGALLARME]
            CASE 4
            HSEROUT ["Alarm IN 2 V Absent : ",STR TESTOALLARME\LUNGALLARME]
            CASE 5
            HSEROUT ["Alarm AN1 Less Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 6
            HSEROUT ["Alarm AN1 Over Threshold AN1=",DEC INANA1,"(",DEC INANA1V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 7
            HSEROUT ["Alarm AN2 Less Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            CASE 8
            HSEROUT ["Alarm AN2 Over Threshold AN2=",DEC INANA2,"(",DEC INANA2V,"mV) : ",STR TESTOALLARME\LUNGALLARME]
            END SELECT
        
            PAUSE   100
            hserout [26]
            GOSUB   ATTENDIOK      
 
            PAUSE 10000     
 
            if FLAGCALL=1 THEN
                PAUSE 1000          'Manda anche uno squillo per avvisare arrivo sms
                HSEROUT ["ATD ",str TELEFONO5\LUNGTEL5,";",13]
             
                pause 15000
                hserout["ATH",13] 
                pause 1000
            ENDIF
 
        endif       
       
       RETURN
 
'------------------------------------------------------------------------------
'ROUTINE SETIN1        'Setup ingresso digitale 1
        
SETIN1:
    
    IF BUFF[7]=80 OR BUFF[7]=112 THEN        'E' una P
        MODFUNZIN1=1            'Imposta in1 per funzionare attivo alto
        WRITE 135,MODFUNZIN1    
    ELSE 
        MODFUNZIN1=0            'Altimenti è una A Imposta in1 per funzionare 
        WRITE 135,MODFUNZIN1    'attivo basso e memorizza   
    ENDIF
 
    'Converti tempo di permanenza da caratteri ascii a numeri
    BUFF[8]=BUFF[8]-48
    BUFF[9]=BUFF[9]-48
 
    'Calcola il tempo di permanenza
    TPERMIN1 = 0
    TPERMIN1 = TPERMIN1 + BUFF[9]       
    TPERMIN1 = TPERMIN1 + (BUFF[8]*10)  
    WRITE 142,TPERMIN1                  
    
    FOR TMP=11 TO 91            'In BUFF da 11 a 91 ai sms di allarme evento  
    TMP1=BUFF[TMP]              
            IF TMP1=42 THEN     
            LUNGALLARME=TMP     
            TMP=105            
        ENDIF
    NEXT TMP               
    LUNGALLARME=LUNGALLARME-11  'Aggiusta lunghezza testo allarme
    
    TMP1=0                          
    FOR TMP=11 TO 91                
        TESTOALLARME[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
    
    TMP2=200                    'Salva il testo allarme in eeprom 
    FOR TMP=0 TO LUNGALLARME    'partendo dalla 200
        WRITE TMP2,TESTOALLARME[TMP]  
        TMP2=TMP2+1
        PAUSE 10
    NEXT TMP
 
    if  MODFUNZIN1=1 THEN
        TMP3[0]=80  'P
        TMP3[1]=114 'r
        TMP3[2]=101 'e
        TMP3[3]=115 's        
        TMP3[4]=101 'e
        TMP3[5]=110 'n
        TMP3[6]=116 't
    ELSE
        TMP3[0]=65  'A
        TMP3[1]=98  'b
        TMP3[2]=115 's
        TMP3[3]=101 'e        
        TMP3[4]=110 'n
        TMP3[5]=116 't
        TMP3[6]=45  '-
    ENDIF
    
    PAUSE   100             'Invia al mittente sms risposta
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    HSEROUT ["Setup IN 1 :"," Normal V ",STR TMP3\7," - Delay Time: ",DEC TPERMIN1," sec - Event Text IN1 : ",STR TESTOALLARME\LUNGALLARME]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK      
    
    INIBIN1=0                   
 
    RETURN
 
'------------------------------------------------------------------------------
'ROUTINE SETIN2        'Setup ingresso digitale 2
        
SETIN2:
    
    IF BUFF[7]=80 OR BUFF[7]=112 THEN        'E' una P
        MODFUNZIN2=1            'Imposta in2 per funzionare attivo alto
        WRITE 136,MODFUNZIN2    'e memorizza in eeprom    
    ELSE 
        MODFUNZIN2=0            'Altimenti è una A Imposta in1 per funzionare 
        WRITE 136,MODFUNZIN2    'attivo basso e memorizza   
    ENDIF
 
    'Converti tempo di permanenza da caratteri ascii a numeri
    BUFF[8]=BUFF[8]-48
    BUFF[9]=BUFF[9]-48
 
    'Calcola il tempo di permanenza
    TPERMIN2 = 0
    TPERMIN2 = TPERMIN2 + BUFF[9]       'Unita
    TPERMIN2 = TPERMIN2 + (BUFF[8]*10)  'Decine
    WRITE 143,TPERMIN2                  'Salva in eeprom
    
    FOR TMP=11 TO 91            'In BUFF da 11 a 91 ai sms di allarme evento  
    TMP1=BUFF[TMP]              
            IF TMP1=42 THEN     
            LUNGALLARME=TMP     
            TMP=105             
        ENDIF
    NEXT TMP               
    LUNGALLARME=LUNGALLARME-11  'Aggiusta lunghezza testo allarme
    
    TMP1=0                          'Trasferisci il testo allarme dal buffer
    FOR TMP=11 TO 91                'alla variabile testoallarme
        TESTOALLARME[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
    
    TMP2=300                     
    FOR TMP=0 TO LUNGALLARME   
        WRITE TMP2,TESTOALLARME[TMP]  
        TMP2=TMP2+1
        PAUSE 10
    NEXT TMP
 
    if  MODFUNZIN2=1 THEN
        TMP3[0]=80  'P
        TMP3[1]=114 'r
        TMP3[2]=101 'e
        TMP3[3]=115 's        
        TMP3[4]=101 'e
        TMP3[5]=110 'n
        TMP3[6]=116 't
    ELSE
        TMP3[0]=65  'A
        TMP3[1]=98  'b
        TMP3[2]=115 's
        TMP3[3]=101 'e        
        TMP3[4]=110 'n
        TMP3[5]=116 't
        TMP3[6]=45  '-
    ENDIF
    
    PAUSE   100             'Invia al mittente sms risposta
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    HSEROUT ["Setup IN 2 :"," Normal V ",STR TMP3\7," - Delay Time: ",DEC TPERMIN2," sec - Event Text IN2 : ",STR TESTOALLARME\LUNGALLARME]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
    
    INIBIN2=0                  
 
    RETURN
 
'------------------------------------------------------------------------------
'ROUTINE SETAN1        'Setup ingresso analogico 1
        
SETAN1:
    
    IF BUFF[7]=79 OR BUFF[7]=111 THEN        'E' una O
        MODFUNZAN1=1            'Imposta an1 per funzionare over
        WRITE 137,MODFUNZAN1    'e memorizza in eeprom    
    ELSE 
        MODFUNZAN1=0            'Altimenti è una L Imposta an1 per
        WRITE 137,MODFUNZAN1    'funzionare less e salva in eeprom
    ENDIF
 
    'Converti soglia da caratteri ascii a numeri
    BUFF[11]=BUFF[11]-48
    BUFF[10]=BUFF[10]-48
    BUFF[9]=BUFF[9]-48
    BUFF[8]=BUFF[8]-48
 
    'Calcola il valore di soglia
    INANA1S = 0
    INANA1S = INANA1S + BUFF[11]        
    INANA1S = INANA1S + (BUFF[10]*10)   
    INANA1S = INANA1S + (BUFF[9]*100)   
    INANA1S = INANA1S + (BUFF[8]*1000)  
 
    'Salva valore di soglia in eeprom scomponendolo in byte alto e basso
    INANA1SL = INANA1S.LOWBYTE
    INANA1SH = INANA1S.HIGHBYTE
    WRITE   151,INANA1SL
    WRITE   152,INANA1SH
    
    FOR TMP=13 TO 93            'In BUFF da 13 a 93 ai sms di allarme evento  
    TMP1=BUFF[TMP]              
            IF TMP1=42 THEN     
            LUNGALLARME=TMP     
            TMP=105            
        ENDIF
    NEXT TMP               
    LUNGALLARME=LUNGALLARME-13   'Aggiusta lunghezza testo allarme
 
    
    TMP1=0                          'Trasferisci il testo allarme dal buffer
    FOR TMP=13 TO 93                'alla variabile testoallarme
        TESTOALLARME[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
    
    TMP2=400                    'Salva il testo allarme in eeprom 
    FOR TMP=0 TO LUNGALLARME    'partendo dalla 400
        WRITE TMP2,TESTOALLARME[TMP]  
        TMP2=TMP2+1
        PAUSE 10
    NEXT TMP
 
    if  MODFUNZAN1=1 THEN
        TMP3[0]=79  'O
        TMP3[1]=118 'v
        TMP3[2]=101 'e
        TMP3[3]=114 'r        
    ELSE
        TMP3[0]=76  'L
        TMP3[1]=101 'e
        TMP3[2]=115 's
        TMP3[3]=115 's        
    ENDIF
    
    PAUSE   100             'Invia al mittente sms risposta
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    HSEROUT ["Setup AN1 : Alarm if AN1 ",STR TMP3\4," ",DEC INANA1S," - Event Text AN1 : ",STR TESTOALLARME\LUNGALLARME]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
    
    INIBAN1=0                  
 
    RETURN
 
 
'------------------------------------------------------------------------------
'ROUTINE SETAN2        'Setup ingresso analogico 2
        
SETAN2:
    
    IF BUFF[7]=79 OR BUFF[7]=111 THEN        'E' una O
        MODFUNZAN2=1            'Imposta an2 per funzionare over
        WRITE 138,MODFUNZAN2    'e memorizza in eeprom    
    ELSE 
        MODFUNZAN2=0            'Altimenti è una L Imposta an2 per
        WRITE 138,MODFUNZAN2    'funzionare less e salva in eeprom
    ENDIF
 
    'Converti soglia da caratteri ascii a numeri
    BUFF[11]=BUFF[11]-48
    BUFF[10]=BUFF[10]-48
    BUFF[9]=BUFF[9]-48
    BUFF[8]=BUFF[8]-48
 
    'Calcola il valore di soglia
    INANA2S = 0
    INANA2S = INANA2S + BUFF[11]        
    INANA2S = INANA2S + (BUFF[10]*10)   
    INANA2S = INANA2S + (BUFF[9]*100)  
    INANA2S = INANA2S + (BUFF[8]*1000)  
 
    'Salva valore di soglia in eeprom scomponendolo in byte alto e basso
    INANA2SL = INANA2S.LOWBYTE
    INANA2SH = INANA2S.HIGHBYTE
    WRITE   153,INANA2SL
    WRITE   154,INANA2SH
    
    FOR TMP=13 TO 93            'In BUFF da 13 a 93 ai sms di allarme evento  
    TMP1=BUFF[TMP]              
            IF TMP1=42 THEN     
            LUNGALLARME=TMP     
            TMP=105             
        ENDIF
    NEXT TMP               
    LUNGALLARME=LUNGALLARME-13   'Aggiusta lunghezza testo allarme
 
    
    TMP1=0                          'Trasferisci il testo allarme dal buffer
    FOR TMP=13 TO 93                'alla variabile testoallarme
        TESTOALLARME[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
    
    TMP2=500                    'Salva il testo allarme in eeprom 
    FOR TMP=0 TO LUNGALLARME    'partendo dalla 500
        WRITE TMP2,TESTOALLARME[TMP]  
        TMP2=TMP2+1
        PAUSE 10
    NEXT TMP
 
    if  MODFUNZAN2=1 THEN
        TMP3[0]=79  'O
        TMP3[1]=118 'v
        TMP3[2]=101 'e
        TMP3[3]=114 'r        
    ELSE
        TMP3[0]=76  'L
        TMP3[1]=101 'e
        TMP3[2]=115 's
        TMP3[3]=115 's        
    ENDIF
    
    PAUSE   100             
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    HSEROUT ["Setup AN2 : Alarm if AN2 ",STR TMP3\4," ",DEC INANA2S," - Event Text AN2 : ",STR TESTOALLARME\LUNGALLARME]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK      
    
    INIBAN2=0                  
 
    RETURN
 
 
'------------------------------------------------------------------------------         
'SUBROUTINE CHIAMATAARRIVO
CHIAMATAARRIVO:
    'Leggi numero del chiamante
    HSERIN 10000,EXITCHIAMATAARRIVO,[WAIT ("+CLIP: ",34),STR MITTENTE\20]   
        
        FOR TMP=0 TO 20             'Calcola lunghezza num mittente
            TMP1=MITTENTE[TMP]
            IF TMP1=34 THEN        
                LUNGMITT=TMP-1
                TMP=35
            ENDIF
        NEXT TMP
        LUNGMITT=LUNGMITT+1         
 
        IF CANCELLO=1 THEN          'Se funzione apricancello abilitata
            GOTO APRICANCELLO
        ELSE                        'Altrimenti verifica per ascolo ambientale
            GOTO VERIFTEL1
        ENDIF        
        goto    EXITCHIAMATAARRIVO  
 
VERIFTEL1:                          'Verifica se mittente uguale telefono 1
        TMP1=0
        for TMP=0 TO LUNGMITT-1
            IF TELEFONO1[TMP1]<>MITTENTE[TMP1] THEN
                GOTO VERIFTEL2
            ENDIF
        TMP1=TMP1+1
        NEXT TMP
        GOTO    VERIFICATO          'Numero in memoria
 
VERIFTEL2:                          'Verifica se mittente uguale telefono 2
        TMP1=0
        for TMP=0 TO LUNGMITT-1
            IF TELEFONO2[TMP1]<>MITTENTE[TMP1] THEN
                GOTO VERIFTEL3
            ENDIF
        TMP1=TMP1+1
        NEXT TMP
        GOTO    VERIFICATO          'Numero in memoria
 
VERIFTEL3:                          'Verifica se mittente uguale telefono 3
        TMP1=0
        for TMP=0 TO LUNGMITT-1
            IF TELEFONO3[TMP1]<>MITTENTE[TMP1] THEN
                GOTO VERIFTEL4
            ENDIF
        TMP1=TMP1+1
        NEXT TMP
        GOTO    VERIFICATO          'Numero in memoria
 
VERIFTEL4:                          'Verifica se mittente uguale telefono 4
        TMP1=0
        for TMP=0 TO LUNGMITT-1
            IF TELEFONO4[TMP1]<>MITTENTE[TMP1] THEN
                GOTO VERIFTEL5
            ENDIF
        TMP1=TMP1+1
        NEXT TMP
        GOTO    VERIFICATO          'Numero in memoria
 
VERIFTEL5:                          'Verifica se mittente uguale telefono 5
        TMP1=0
        for TMP=0 TO LUNGMITT-1
            IF TELEFONO5[TMP1]<>MITTENTE[TMP1] THEN
                GOTO VERIFTEL6
            ENDIF
        TMP1=TMP1+1
        NEXT TMP
        GOTO    VERIFICATO          'Numero in memoria
 
VERIFTEL6:                          'Se nessun numero in memoria  
        PAUSE   100                 'coincide con mittente
        goto    EXITCHIAMATAARRIVO  'esci
        
VERIFICATO:                         'Se arriva qui il numero è in memoria
        PAUSE   50
        HSEROUT ["AT#CAP=1",13]     'Settaggio audio su canale HF              
        pause 300
        hserout["ATA",13]           'Prendi la linee telefonica
        pause   10000               'Attendi 10 sec
        goto    EXITCHIAMATAARRIVO  'esci
        
EXITCHIAMATAARRIVO:             'Attendi il disimpegno della linea
                                'o termine ascolto ambientale
    pause   100
    HSEROUT ["AT+CPAS",13]                              'Verifico stato chiamata
    HSERIN  2000,EXITCHIAMATAARRIVO,[WAIT (": "),TMP]                  
    HSERIN  2000,EXITCHIAMATAARRIVO,[WAIT ("OK")]       
    IF TMP="3" THEN           'Se il ring è in corso ricicla
        PAUSE   1000
        GOTO    EXITCHIAMATAARRIVO
    endif
    IF TMP="4" THEN             'Se la chiamata è in corso ricicla
        PAUSE   1000
        GOTO    EXITCHIAMATAARRIVO
    endif
    pause   100
    hserout ["ATH",13]           'Lascia la linee telefonica
    pause   1000
    return
 
APRICANCELLO:
    FOR TMP=0 TO 15    
    pause   100
    hserout ["ATH",13]          'Lascia la linee telefonica    
    NEXT TMP
        
APRICANCELLO1:             'Attendi il disimpegno della linea
 
    pause   100
    HSEROUT ["AT+CPAS",13]                              'Verifico stato chiamata
    HSERIN  2000,APRICANCELLO1,[WAIT (": "),TMP]                  
    HSERIN  2000,APRICANCELLO1,[WAIT ("OK")]      
    IF TMP="3" THEN           'Se il ring è in corso ricicla
        PAUSE   1000
        GOTO    APRICANCELLO
    endif
    IF TMP="4" THEN             'Se la chiamata è in corso ricicla
        PAUSE   1000
        GOTO    APRICANCELLO
    endif
 
    TELEFONO=MITTENTE       'Copia numero chiamante
    LUNGTEL=LUNGMITT        'Copia lunghezza numero chiamante
 
    PAUSE   100
    HSEROUT ["AT+CPBS=SM",13]                   'Configura per lavorare con SIM
    HSERIN  2000,ESCICANCELLO,[WAIT ("OK")]     'Attendi OK
 
    BUFF = 0
    PAUSE   100     'Vedi se il numero del chiamante è nella sim 
                   
 
    HSEROUT ["AT+CPBF=",str MITTENTE\LUNGMITT,13]
    HSERIN  20000,ESCICANCELLO,[WAIT ("+CPBF: "),STR BUFF\3\44]  
 
    IF DOORMODE=77 THEN         'Se modalita monostabile
        HIGH    USCITA1         'Attiva uscita 1 per 2 secondi
        PAUSE   2000        
        LOW     USCITA1            
        PAUSE   2000
    ENDIF
    IF DOORMODE=66 THEN         'Se modalita bistabile
        TOGGLE  USCITA1         'Cambia stato all'uscita 1
        PAUSE   2000
    ENDIF
 
ESCICANCELLO:
    return
 
'------------------------------------------------------------------------------
 
 
'------------------------------------------------------------------------------         
'SUBROUTINE INVIOPUP    Invia SMS di power up
 
INVIOPUP:
 
        IF SMSPUP=0 THEN    'Se flag a 0 nessun alert richiesto al power up
            GOTO EXITINVIOPUP
        ENDIF            
 
        'Telefono 1
        IF LUNGTEL1>5 THEN              'Se telefono 1 memorizzato
            IF SMSPUP=1 THEN    'Se flag a 1 invia sms di power up 
                PAUSE   100                 'Invia al telefono 1 sms di power up
                hserout ["AT+CMGS=",34,str TELEFONO1\LUNGTEL1,34,13]
                PAUSE   2000
                HSEROUT ["System Power Up"]
                PAUSE   100
                hserout [26]         
                GOSUB   ATTENDIOK       
                pause   10000                
            ENDIF
            IF SMSPUP=2 THEN    'Se flag a 2 invia squillo di power up 
                PAUSE 1000         
                HSEROUT ["ATD ",str TELEFONO1\LUNGTEL1,";",13]
             
                pause 15000
                hserout["ATH",13] 
                pause 1000
             endif
        endif
                     
        'Telefono 2
        IF LUNGTEL2>5 THEN              'Se telefono 1 memorizzato
            IF SMSPUP=1 THEN    'Se flag a 1 invia sms di power up 
                PAUSE   100                 'Invia al telefono 1 sms di power up
                hserout ["AT+CMGS=",34,str TELEFONO2\LUNGTEL2,34,13]
                PAUSE   2000
                HSEROUT ["System Power Up"]
                PAUSE   100
                hserout [26]         
                GOSUB   ATTENDIOK      
                pause   10000               
            ENDIF
            IF SMSPUP=2 THEN    'Se flag a 2 invia squillo di power up 
                PAUSE 1000          'Manda uno squillo di power up
                HSEROUT ["ATD ",str TELEFONO2\LUNGTEL2,";",13]
              
                pause 15000
                hserout["ATH",13] 
                pause 1000
             endif
        endif
 
        'Telefono 3
        IF LUNGTEL3>5 THEN              'Se telefono 1 memorizzato
            IF SMSPUP=1 THEN    'Se flag a 1 invia sms di power up 
                PAUSE   100                 'Invia al telefono 1 sms di power up
                hserout ["AT+CMGS=",34,str TELEFONO3\LUNGTEL3,34,13]
                PAUSE   2000
                HSEROUT ["System Power Up"]
                PAUSE   100
                hserout [26]         
                GOSUB   ATTENDIOK      
                pause   10000               
            ENDIF
            IF SMSPUP=2 THEN    'Se flag a 2 invia squillo di power up 
                PAUSE 1000          'Manda uno squillo di power up
                HSEROUT ["ATD ",str TELEFONO3\LUNGTEL3,";",13]
              
                pause 15000
                hserout["ATH",13] 
                pause 1000
             endif
        endif
 
        'Telefono 4
        IF LUNGTEL4>5 THEN              'Se telefono 1 memorizzato
            IF SMSPUP=1 THEN    'Se flag a 1 invia sms di power up 
                PAUSE   100                 'Invia al telefono 1 sms di power up
                hserout ["AT+CMGS=",34,str TELEFONO4\LUNGTEL4,34,13]
                PAUSE   2000
                HSEROUT ["System Power Up"]
                PAUSE   100
                hserout [26]         
                GOSUB   ATTENDIOK      
                pause   10000                
            ENDIF
            IF SMSPUP=2 THEN    'Se flag a 2 invia squillo di power up 
                PAUSE 1000          'Manda uno squillo di power up
                HSEROUT ["ATD ",str TELEFONO4\LUNGTEL4,";",13]
              
                pause 15000
                hserout["ATH",13] 
                pause 1000
             endif
        endif
 
        'Telefono 5
        IF LUNGTEL5>5 THEN              'Se telefono 1 memorizzato
            IF SMSPUP=1 THEN    'Se flag a 1 invia sms di power up 
                PAUSE   100                 'Invia al telefono 1 sms di power up
                hserout ["AT+CMGS=",34,str TELEFONO5\LUNGTEL5,34,13]
                PAUSE   2000
                HSEROUT ["System Power Up"]
                PAUSE   100
                hserout [26]         
                GOSUB   ATTENDIOK      
                pause   10000              
            ENDIF
            IF SMSPUP=2 THEN    'Se flag a 2 invia squillo di power up 
                PAUSE 1000          'Manda uno squillo di power up
                HSEROUT ["ATD ",str TELEFONO5\LUNGTEL5,";",13]
             
                pause 15000
                hserout["ATH",13] 
                pause 1000
             endif
        endif
        
EXITINVIOPUP:        
        RETURN
        
'------------------------------------------------------------------------------         
'SUBROUTINE ATTIVAMIC   E' arrivata chiamata da telefono abilitato attiva 
'                       microfono ambientale 
 
ATTIVAMIC:
 
    'Settaggio audio su canale HF
    PAUSE   50
    HSEROUT ["AT#CAP=1",13]                
    pause 300
 
    hserout["ATA",13]           
 
    pause   10000               
 
ATTIVAMIC1:
 
    pause   100
    HSEROUT ["AT+CPAS",13]                          'Verifico stato chiamata
    HSERIN  2000,ATTIVAMIC1,[WAIT (": "),TMP]                    
    HSERIN  2000,ATTIVAMIC1,[WAIT ("OK")]           
 
  
    IF TMP="4" THEN           'Se la chiamata è in corso ricicla
        PAUSE   1000
        GOTO    ATTIVAMIC1
    endif
 
    hserout["ATH",13]           'Lascia la linee telefonica
    pause 1000
 
    return
 
 
'------------------------------------------------------------------------------
'ROUTINE AGGIUNGISIM     Aggiungi numero nella memoria SIM
 
AGGIUNGISIM:
 
    FOR TMP=6 TO 22             
    TMP1=BUFF[TMP]
        IF TMP1=42 THEN             
            LUNGTEL=TMP            
            TMP=40                 
        ENDIF
    NEXT TMP               
    LUNGTEL=LUNGTEL-6               
 
    TMP1=0                          'Trasferisci il numero telefono dal buffer
    FOR TMP=6 TO 21                 'alla variabile telefono
        TELEFONO[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
 
    BUFF = 0
    
    PAUSE   100
    HSEROUT ["AT+CPBS=SM",13]                   'Configura per lavorare con SIM
    HSERIN  2000,AGGIUNGISIMKO,[WAIT ("OK")]     
 
    PAUSE   100     'Memorizza numero nella prima locazione sim libera
                  
    HSEROUT ["AT+CPBW=",44,str TELEFONO\LUNGTEL,44,49,52,53,44,STR TELEFONO\LUNGTEL,13]                    
    HSERIN  2000,AGGIUNGISIMKO,[WAIT ("OK")]      
 
    PAUSE   100                     'Invia sms di ok
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Command OK ID Phone Add in Memory: ",STR TELEFONO\LUNGTEL]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
    GOTO    ESCIAGGIUNGISIM
 
AGGIUNGISIMKO:
    PAUSE   100                     'Invia sms di errore
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Memory Error: ",STR TELEFONO\LUNGTEL]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
 
ESCIAGGIUNGISIM:
    RETURN
 
'------------------------------------------------------------------------------
'ROUTINE RIMUOVISIM     Rimuovi numero nella memoria SIM
 
RIMUOVISIM:
 
    FOR TMP=6 TO 22             
    TMP1=BUFF[TMP]
        IF TMP1=42 THEN            
            LUNGTEL=TMP            
            TMP=40                  
        ENDIF
    NEXT TMP               
    LUNGTEL=LUNGTEL-6               
 
    TMP1=0                          'Trasferisci il numero telefono dal buffer
    FOR TMP=6 TO 21                 'alla variabile telefono
        TELEFONO[TMP1]=BUFF[TMP]
        TMP1=TMP1+1
    NEXT TMP
 
    BUFF = 0
 
    PAUSE   100
    HSEROUT ["AT+CPBS=SM",13]                   'Configura per lavorare con SIM
    HSERIN  2000,RIMUOVISIMKO,[WAIT ("OK")]       
 
    PAUSE   100     'Vedi se il numero da cancellare è nella sim
    HSEROUT ["AT+CPBF=",str TELEFONO\LUNGTEL,13]
    HSERIN  2000,RIMUOVISIMNO,[WAIT ("+CPBF: "),STR BUFF\3\44]  
 
    PAUSE   100     'Cancella la locazione indicata da BUFF 
    HSEROUT ["AT+CPBW=",STR BUFF,13]
    HSERIN  2000,RIMUOVISIMKO,[WAIT ("OK")]       
 
    PAUSE   100                    
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Command OK ID Phone Remove to Memory: ",STR TELEFONO\LUNGTEL]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
    GOTO    ESCIRIMUOVISIM
 
RIMUOVISIMNO:
    PAUSE   100                     'Invia sms di numero non trovato in memoria
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["ID Phone not present in memory: ",STR TELEFONO\LUNGTEL]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
    GOTO    ESCIRIMUOVISIM
 
RIMUOVISIMKO:
    PAUSE   100                     'Invia sms di errore
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Memory Error: ",STR TELEFONO\LUNGTEL]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
 
ESCIRIMUOVISIM:
    RETURN
 
'------------------------------------------------------------------------------
'ROUTINE STATOSIM     Invia SMS di risposta con stato SIM
 
STATOSIM:
 
    BUFF = 0
 
    PAUSE   100
    HSEROUT ["AT+CPBS=SM",13]                   'Configura per lavorare con SIM
    HSERIN  2000,STATOSIMKO,[WAIT ("OK")]       
 
    PAUSE   100
    HSEROUT ["AT+CPBS?",13]                     'Richiedi stato SIM
    HSERIN  2000,STATOSIMKO,[WAIT ("+CPBS: "),SKIP 5,str BUFF\20\13]  'Attendi stato
    HSERIN  2000,STATOSIMKO,[WAIT ("OK")]       
 
    PAUSE   100                                 'Invia sms con stato memoria
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Memory Status Used,Total: ",STR BUFF]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK       
    GOTO    ESCISTATOSIM
 
STATOSIMKO:
    PAUSE   100                     'Invia sms di errore
    hserout ["AT+CMGS=",34,str MITTENTE\LUNGMITT,34,13]
    PAUSE   2000
    hserout ["Memory Error: ",STR TELEFONO\LUNGTEL]
    PAUSE   100
    hserout [26]
    GOSUB   ATTENDIOK      
 
ESCISTATOSIM:
    RETURN
 
'------------------------------------------------------------------------------
'ROUTINE LEGGIINAA          Leggi ingressi analogici
 
LEGGIINANA:
 
    ADCON2=%10111110        'Imposta giustificato a destra
                            
    TMP1=0
    TMP2=0
    ADCON0=%00000001        'Collega convertitore a RA0 (IN1 analogico)
    pause   10              'Attendi 10 ms
    HIGH    ADCON0.1        'Fai partire la conversione
    PAUSE   10              'Attendi 10 ms
    TMP1=ADRESL             'Salva risultato basso in var byte
    TMP2=ADRESH             'Salva risultato alto in var word
    INANA1=(TMP2*256)+TMP1  'Moltiplica parte alta per 256 e somma alla bassa
 
    TMP1=0
    TMP2=0
    ADCON0=%00000101        'Collega convertitore a RA1 (IN2 analogico)
    pause   10              'Attendi 10 ms
    HIGH    ADCON0.1        'Fai partire la conversione
    PAUSE   10              'Attendi 10 ms
    TMP1=ADRESL             'Salva risultato basso in var byte
    TMP2=ADRESH             'Salva risultato alto in var word
    INANA2=(TMP2*256)+TMP1  'Moltiplica parte alta per 256 e somma alla bassa
 
    'Ingresso analogico 1
    IF MODFUNZAN1=0 THEN            'Se AN1 less 
        IF INIBAN1=0 THEN           
            IF INANA1<INANA1S THEN  
                pause 5
                FRASE=5
                GOSUB ALARMIN       'allora allarme ingresso
                INIBAN1=1           'Inibisci ingresso analogico 1
            ENDIF
        ENDIF
    ENDIF
    IF MODFUNZAN1=1 THEN            'Se AN1 over
        IF INIBAN1=0 THEN           
            IF INANA1>INANA1S THEN  
                pause 5
                FRASE=6
                GOSUB ALARMIN       'allora allarme ingresso
                INIBAN1=1           'Inibisci ingresso analogico 1
            ENDIF
        ENDIF
    ENDIF
 
    'Ingresso analogico 2
    IF MODFUNZAN2=0 THEN            'Se AN2 less 
        IF INIBAN2=0 THEN           'e inibizione non attiva
            IF INANA2<INANA2S THEN  'e il valore letto è minore della soglia
                pause 5
                FRASE=7
                GOSUB ALARMIN       'allora allarme ingresso
                INIBAN2=1           'Inibisci ingresso analogico 2
            ENDIF
        ENDIF
    ENDIF
    IF MODFUNZAN2=1 THEN            'Se AN2 over
        IF INIBAN2=0 THEN           'e inibizione non attiva
            IF INANA2>INANA2S THEN  'e il valore letto è maggiore della soglia
                pause 5
                FRASE=8
                GOSUB ALARMIN       'allora allarme ingresso
                INIBAN2=1           'Inibisci ingresso analogico 2
            ENDIF
        ENDIF
    ENDIF
 
    RETURN
 
'------------------------------------------------------------------------------         
'SUBROUTINE RIATTIVAINGRESSI    E' impostata la riattivazione automatica 
'                               sulla gestione ingressi, riattiva ingressi
 
RIATTIVAINGRESSI:
 
    'Ingresso 1
    IF MODFUNZIN1=0 THEN        'Se in 1 impostato per lavorare attivo basso
        IF INGRESSO1=1 THEN     'e ingresso 1 è alto
            pause 5
            IF INGRESSO1=1 then     'ancora alto
                INIBIN1=0           'Togli inibizione ingresso 1
            ENDIF
        ENDIF
    ENDIF
    IF MODFUNZIN1=1 THEN        'Se in 1 impostato per lavorare attivo alto
        IF INGRESSO1=0 THEN     'e ingresso 1 è basso
            pause 5
            if INGRESSO1=0 THEN     'ancora basso
                INIBIN1=0           'Togli inibizione ingresso 1
            ENDIF
        ENDIF
    ENDIF
 
    'Ingresso 2
    IF MODFUNZIN2=0 THEN        'Se in 2 impostato per lavorare attivo basso
        IF INGRESSO2=1 THEN     'e ingresso 2 è alto
            pause 5
            IF INGRESSO2=1 then     'ancora alto
                INIBIN2=0           'Togli inibizione ingresso 2
            ENDIF
        ENDIF
    ENDIF
    IF MODFUNZIN2=1 THEN        'Se in 2 impostato per lavorare attivo alto
        IF INGRESSO2=0 THEN     'e ingresso 2 è basso
            pause 5
            if INGRESSO2=0 THEN     'ancora basso
                INIBIN2=0           'Togli inibizione ingresso 2
            ENDIF
        ENDIF
    ENDIF
 
    RETURN
 
'------------------------------------------------------------------------------         
 
 
'-------------------------------------------------------------------------------
'SUBROUTINE ATTENDIOK       Attendi ok dal gsm per un massimo di 60 sec
 
ATTENDIOK:
 
    HSERIN  60000,ESCIATTENDIOK,[WAIT ("OK")]   
 
ESCIATTENDIOK:
    PAUSE   50
    RETURN
'-------------------------------------------------------------------------------    
       
 
