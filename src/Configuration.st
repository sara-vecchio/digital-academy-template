USING Siemens.Simatic.S71500.Tasks;
USING tipi;
USING Libreria;
USING tempo;

CONFIGURATION MyConfig

    
    TASK Load(PRIORITY:=1);
    TASK Main(PRIORITY:=0);
    
    PROGRAM P0 WITH Load: LoadConfiguration; 
    PROGRAM P1 WITH Main: MainProgram;

    // Configuring IO tags    
    VAR_GLOBAL
        
        //input output feed
        Qnf AT %Q0.0 : BOOL;
        Qdf AT %Q0.1 : BOOL;
        Qts AT %Q0.2 : BOOL;
        
        Idf AT %IB0 : USINT;
        Iff AT %I1.0 : BOOL;
        Isf AT %I1.1 : BOOL;
        Imf AT %I1.2 : BOOL;

        //input output ennesimo magazzino
        Qnn AT %Q0.3 : BOOL;
        Qdn AT %Q0.4 : BOOL;
        Qtn AT %Q0.5 : BOOL;

        Idn AT %IB2 : USINT;
        Ifn AT %I3.0 : BOOL;
        Isn AT %I3.1 : BOOL;
        Imn AT %I3.2 : BOOL;

        //input output coda
        Qnc AT %Q0.6 : BOOL;
        Qdc AT %Q0.7 : BOOL;
        Qtr AT %Q1.0 : BOOL; 
        
        Idc AT %IB4 : USINT;
        Ifc AT %I5.0 : BOOL;
        Isc AT %I5.1 : BOOL;
        Ifr AT %I5.2 : BOOL; 
    END_VAR

    VAR_GLOBAL
        nastri : ARRAY[0..n_mag] OF nastro;
        deviatori : ARRAY[0..n_mag] OF deviatore;
        magazzini : ARRAY[0..n_mag+1] OF inventory;
        n_pacchi : INT := 10; 
        elapsedtimer : tempo.Timer;
    END_VAR

    VAR_GLOBAL CONSTANT
        n_mag : INT := 3; //7
        capacity : INT := 10;

        maxVal : INT := 7;
        minVal : INT :=1;
    END_VAR

END_CONFIGURATION

PROGRAM LoadConfiguration

    VAR_TEMP
        i:INT :=0;
    END_VAR

    VAR
    coloreq : USINT;
    END_VAR

    VAR_EXTERNAL
        nastri : ARRAY [0..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [0..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [0..n_mag+1] OF Libreria.inventory;
    END_VAR

    VAR_EXTERNAL CONSTANT
        n_mag : INT;
        capacity : INT;
        maxVal : INT ;
        minVal : INT ;
    END_VAR

        nastri[i].Init(i);
        deviatori[i].Init(i);
        coloreq := TO_USINT(i);
        magazzini[i].Init(capacity,coloreq,i);

    FOR i:=1 TO n_mag DO //inizializzare componenti
        nastri[i].Init(i);
        deviatori[i].Init(i);
        coloreq := TO_USINT(i);
        magazzini[i].Init(capacity,coloreq,i);
    END_FOR;

    magazzini[n_mag+1].Init(capacity,USINT#0,n_mag+1); //se questo è scarto coda non è USINT#0...

END_PROGRAM
