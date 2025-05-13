USING Siemens.Simatic.S71500.Tasks;
USING tipi;
USING Libreria;
USING tempo;
USING System.Timer;

CONFIGURATION MyConfig

    TASK Load: Startup;
    TASK Main(Interval := T#1000ms,PRIORITY:=1); //di default è 50ms (minimo)
    //TASK PackagesIn(Interval:= T#1s, PRIORITY:=1);//ogni 1s genera un pacco
    
    PROGRAM P0 WITH Load: LoadPlantConfiguration; 
    PROGRAM P1 WITH Main: MainProgram;
    //PROGRAM P2 WITH PackagesIn: RandPack;


    // Configuring IO tags    
    VAR_GLOBAL 
        
        //input output feed
        Qn AT %QB0 : BYTE; //per comodità con le operazioni di mask, pensare che il byte è riempito al contrario (aka primo bit a destra è il feed, primo bit significativo a sinistra è il coda)
        Qnf AT %Q0.0 : BOOL; //output nastro feed
        Qnc AT %Q0.1 : BOOL;
        Qn2 AT %Q0.2 : BOOL;
        Qn3 AT %Q0.3 : BOOL;
        Qn4 AT %Q0.4 : BOOL;

        Qd AT %QB1 : BYTE;
        Qdf AT %Q1.0 : BOOL; //output deviatore feed
        Qdc AT %Q1.1 : BOOL; 
        Qd2 AT %Q1.2 : BOOL;
        Qd3 AT %Q1.3 : BOOL;
        Qd4 AT %Q1.4 : BOOL;
        
        Qt AT %QB2 : BYTE;
        Qtf AT %Q2.0 : BOOL; //output tank feed
        Qtc AT %Q2.1 : BOOL;   
        Qt2 AT %Q2.2 : BOOL;   
        Qt3 AT %Q2.3 : BOOL; 
        Qt4 AT %Q2.4 : BOOL; 

        //Id AT %IB6 : BYTE;
        Idf AT %IB6 : USINT; //input deviatore feed (colore)
        Idc AT %IB7 : USINT;
        Id2 AT %IB8 : USINT;
        Id3 AT %IB9 : USINT;
        Id4 AT %IB10 : USINT;

    //    If_ AT %IB0 : BYTE;
        Iff AT %I0.0 : BOOL; //input fotocellula feed
        Ifc AT %I0.1 : BOOL;
        If2 AT %I0.2 : BOOL; 
        If3 AT %I0.3 : BOOL;
        If4 AT %I0.4 : BOOL;
        
    //    Is AT %IB1 : BYTE;
        Isf AT %I1.0 : BOOL; //input sensore feed (vedi slides - sensore di presenza)
        Isc AT %I1.1 : BOOL; 
        Is2 AT %I1.2 : BOOL; 
        Is3 AT %I1.3 : BOOL;
        Is4 AT %I1.4 : BOOL;

    //    Im AT %IB2 : BYTE;
        Imf AT %I2.0 : BOOL; //input magazzino feed
        Imc AT %I2.1 : BOOL;
        Im2 AT %I2.2 : BOOL;
        Im3 AT %I2.3 : BOOL;
        Im4 AT %I2.4 : BOOL;
 
    
        Mask : ARRAY[1..n_mag] of BYTE := [BYTE#1,BYTE#2,BYTE#4, BYTE#8, BYTE#16];
        nastri : ARRAY[1..n_mag] OF nastro;        
        //Qn : REF_TO ARRAY[1..n_mag] of BOOL ;
        //Qd : ARRAY[1..n_mag] of BOOL ;
        //Qt : ARRAY[1..n_mag] of BOOL ;

        Id : ARRAY[1..n_mag] of USINT ;
        If_ : ARRAY[1..n_mag] of BOOL ;
        Is : ARRAY[1..n_mag] of BOOL ;
        Im : ARRAY[1..n_mag] of BOOL ;

        deviatori : ARRAY[1..n_mag] OF deviatore;
        magazzini : ARRAY[1..n_mag] OF inventory;
        n_pacchi : INT:=20; 
        elapsedtimer : tempo.Timer;
        flag : BOOL := FALSE;
        fineProcesso: BOOL := FALSE;
        color:colore;
        //ListaPacchi: ARRAY [1..n_pacchi_max] OF USINT; 
        //ListaPacchi2: ARRAY [1..n_pacchi_max] OF USINT:=[USINT#1,USINT#1,USINT#1,USINT#1,USINT#1,USINT#2,USINT#2,USINT#2,USINT#2,USINT#2,USINT#3,USINT#3,USINT#3,USINT#3,USINT#3,USINT#0,USINT#0,USINT#0,USINT#0,USINT#0 ]; 
    END_VAR

    VAR_GLOBAL CONSTANT
        n_mag : INT := 5; // numero magazzini considerando uno feed e uno scarto e il penultimo ricetta o semplice
        capacity : INT := 5;
        tStopMotor : Time := T#5s;//tempo movimento motori
        //n_pacchi_max : INT:=20; 
    END_VAR

END_CONFIGURATION