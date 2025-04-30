USING Siemens.Simatic.S71500.Tasks;
USING tipi;
USING Libreria;

CONFIGURATION MyConfig

    TASK Main(PRIORITY:=0);
    TASK Load(PRIORITY:=1);
    
    PROGRAM P0 WITH Load: LoadConfiguration; 
    PROGRAM P1 WITH Main: MainProgram;

    // Configuring IO tags    
    VAR_GLOBAL

        Qnf AT %Q0.0 : BOOL;
        Qdf AT %Q0.1 : BOOL;
        Qts AT %Q0.2 : BOOL;
        Iff AT %I0.0 : BOOL;
        Idf AT %I0.1 : BOOL;
        Isf AT %I0.2 : BOOL;
        Imf AT %I0.3 : BOOL;

        Qnn AT %Q0.3 : BOOL;
        Qdn AT %Q0.4 : BOOL;
        Qtn AT %Q0.5 : BOOL;
        Ifn AT %I0.4 : BOOL;
        Idn AT %I0.5 : BOOL;
        Isn AT %I0.6 : BOOL;
        Imn AT %I0.7 : BOOL;

        Qnc AT %Q0.6 : BOOL;
        Qdc AT %Q0.7 : BOOL;
        Qtr AT %Q1.0 : BOOL; 
        Ifc AT %I1.0 : BOOL;
        Idc AT %I1.1 : BOOL;
        Isc AT %I1.2 : BOOL;
        Ifr AT %I1.3 : BOOL; 
    END_VAR

    VAR_GLOBAL
        nastri : ARRAY[1..n_mag] OF nastro;
        deviatori : ARRAY[1..n_mag] OF deviatore;
        magazzini : ARRAY[1..n_mag+1] OF magazzino;
        Tag1 : INT;
        Tag3 AT %IB4 : BYTE;
        n_pacchi : INT;
    END_VAR

    VAR_GLOBAL CONSTANT
        n_mag : INT := 3 ;
    END_VAR

END_CONFIGURATION

PROGRAM LoadConfiguration

    VAR_TEMP
        i:INT :=1;
    END_VAR


    VAR_EXTERNAL
        nastri : ARRAY [1..3] OF Libreria.nastro;
        deviatori : ARRAY [1..3] OF Libreria.deviatore;
        magazzini : ARRAY [1..4] OF Libreria.magazzino;
        Tag1 : INT;
        Tag3 : BYTE;
    END_VAR

    VAR_EXTERNAL CONSTANT
        n_mag : INT;
    END_VAR

    FOR i:=1 TO n_mag DO //inizializzare componenti
        nastri[i].Init(i);
        deviatori[i].Init(i);
        magazzini[i].Init(i); 
    END_FOR;

    magazzini[n_mag+1].Init(n_mag+1);

END_PROGRAM
