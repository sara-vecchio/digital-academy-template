USING Siemens.Simatic.S71500.Tasks;
USING tipi;
USING Libreria;
USING tempo;
USING System.Timer;

CONFIGURATION MyConfig

    TASK Load: Startup;
    TASK Main(Interval := T#1000ms,PRIORITY:=1); //di default è 50ms (minimo)
    //TASK PackagesIn(Interval:= T#1s, PRIORITY:=1);//ogni 1s genera un pacco
    
    PROGRAM P0 WITH Load: LoadConfiguration; 
    PROGRAM P1 WITH Main: MainProgram;
    //PROGRAM P2 WITH PackagesIn: RandPack;

    // Configuring IO tags    
    VAR_GLOBAL 
        
        //input output feed
        Qnf AT %Q0.0 : BOOL; //output nastro feed 
        Qnc AT %Q0.1 : BOOL;
        Qn2 AT %Q0.2 : BOOL;
        Qn3 AT %Q0.3 : BOOL;
        Qn4 AT %Q0.4 : BOOL;

        Qdf AT %Q1.0 : BOOL; //output deviatore feed 
        Qdc AT %Q1.1 : BOOL; 
        Qd2 AT %Q1.2 : BOOL;
        Qd3 AT %Q1.3 : BOOL;
        Qd4 AT %Q1.4 : BOOL;
        
        Qtf AT %Q2.0 : BOOL; //output tank feed 
        Qtc AT %Q2.1 : BOOL;   
        Qt2 AT %Q2.2 : BOOL;   
        Qt3 AT %Q2.3 : BOOL; 
        Qt4 AT %Q2.4 : BOOL; 

        Idf AT %IB6 : USINT; //input deviatore feed (colore)
        Idc AT %IB7 : USINT;
        Id2 AT %IB8 : USINT;
        Id3 AT %IB9 : USINT;
        Id4 AT %IB10 : USINT;

        Iff AT %I0.0 : BOOL; //input fotocellula feed (presenza pacco su nastro principale)
        Ifc AT %I0.1 : BOOL;
        If2 AT %I0.2 : BOOL; 
        If3 AT %I0.3 : BOOL;
        If4 AT %I0.4 : BOOL;
        
        Isf AT %I1.0 : BOOL; //input sensore feed (presenza pacco su nastro principale prima del deviatore)
        Isc AT %I1.1 : BOOL; 
        Is2 AT %I1.2 : BOOL; 
        Is3 AT %I1.3 : BOOL;
        Is4 AT %I1.4 : BOOL;

        Imf AT %I2.0 : BOOL; //input magazzino feed (presenza pacco su nastro principale)
        Imc AT %I2.1 : BOOL;                                                
        Im2 AT %I2.2 : BOOL;
        Im3 AT %I2.3 : BOOL;
        Im4 AT %I2.4 : BOOL;
 
    END_VAR

    VAR_GLOBAL

        nastri : ARRAY[1..n_mag] OF nastro;        
        Id : ARRAY[1..n_mag] of USINT ;
        deviatori : ARRAY[1..n_mag] OF deviatore;
        magazzini : ARRAY[1..n_mag] OF inventory;
        n_pacchi : INT:=20; 
        elapsedtimer : tempo.Timer;
        flag : BOOL := FALSE;
        fineProcesso: BOOL := FALSE;
        
    END_VAR

    VAR_GLOBAL CONSTANT

        n_mag : INT := 5; // numero magazzini considerando uno feed e uno scarto e il penultimo ricetta o semplice
        capacity : INT := 5;
        tStopMotor : Time := T#5s;//tempo movimento motori
         
    END_VAR
    

END_CONFIGURATION


PROGRAM LoadConfiguration
    
    VAR_TEMP
        i:INT :=0;
    END_VAR

    VAR_EXTERNAL

        nastri : ARRAY [1..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [1..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [1..n_mag] OF Libreria.inventory;

        Qnf : BOOL;
        Qdf : BOOL;
        Qtf : BOOL;
        Idf : USINT;
        Iff : BOOL;
        Isf : BOOL;
        Imf : BOOL;
        Qnc : BOOL;
        Qdc : BOOL;
        Qtc : BOOL;
        Idc : USINT;
        Ifc : BOOL;
        Isc : BOOL;
        Imc : BOOL;
        Qn2 : BOOL;
        Qd2 : BOOL;
        Qt2 : BOOL;
        Id2 : USINT;
        If2 : BOOL;
        Is2 : BOOL;
        Im2 : BOOL;
        Qn3 : BOOL;
        Qd3 : BOOL;
        Qt3 : BOOL;
        Id3 : USINT;
        If3 : BOOL;
        Is3 : BOOL;
        Im3 : BOOL;
        Qn4 : BOOL;
        Qd4 : BOOL;
        Qt4 : BOOL;
        Id4 : USINT;
        If4 : BOOL;
        Is4 : BOOL;
        Im4 : BOOL;
        //elapsedtimer : tempo.Timer;
        
    END_VAR

    VAR_EXTERNAL CONSTANT
        n_mag : INT;
        capacity : INT;
        n_pacchi : INT;
    END_VAR

    //inizializzo il blocco feed
    nastri[1].Init(1);
    deviatori[1].Init(1, USINT#0); //qua dico anche che colore il deviatore deve accettare
    magazzini[1].Init_magazzino(1, capacity);


    //inizializzo il blocco 2
    nastri[2].Init(2);
    deviatori[2].Init(2, USINT#1); //qua dico anche che colore il deviatore deve accettare
    magazzini[2].Init_magazzino(2, capacity);


    //inizializzo il blocco 3
    nastri[3].Init(3);
    deviatori[3].Init(3, USINT#2); //qua dico anche che colore il deviatore deve accettare
    magazzini[3].Init_magazzino(3, capacity);


    //inizializzo il blocco 4
    nastri[4].Init(4);
    deviatori[4].Init(4, USINT#3); //qua dico anche che colore il deviatore deve accettare
    magazzini[4].Init_magazzino(4, capacity);


    //inizializzo il blocco coda
    nastri[n_mag].Init(n_mag);
    deviatori[n_mag].Init(n_mag, USINT#0); //qua dico anche che colore il deviatore deve accettare
    magazzini[n_mag].Init_magazzino(n_mag, capacity);


END_PROGRAM


/*PROGRAM RandPack
    VAR
        PackOnDelay : OnDelay;
        triggerSuccess : BOOL;
        RandomSeed : INT:=1;
        coloreIngresso: USINT;
        pacchi_creati: INT:=0;
    END_VAR
    
    VAR_EXTERNAL CONSTANT
        n_pacchi_max : INT;
        ListaPacchi: ARRAY [1..n_pacchi_max] OF USINT; 
    END_VAR

WHILE  pacchi_creati<n_pacchi_max DO //serve effettivamente questo while?
    PackOnDelay(signal := pacchi_creati<n_pacchi_max, duration := T#50ms); // se dopo 50ms signal è ancora TRUE, l'output diventa TRUE
    triggerSuccess := PackOnDelay.output;
    
    IF triggerSuccess AND pacchi_creati<n_pacchi_max THEN
        // Simula colore random tra 0 e 7
        RandomSeed := (RandomSeed * 37 + 91) MOD 1000;
        coloreIngresso := TO_USINT(RandomSeed MOD 8); //MOD 8 limita il numero tra 0 e 7

        IF coloreIngresso>USINT#7 THEN
            coloreIngresso:=USINT#0;
        END_IF;

        ListaPacchi[pacchi_creati + 1] := coloreIngresso;
        pacchi_creati := pacchi_creati + 1;
    END_IF; 
END_WHILE;

END_PROGRAM*/
