USING Siemens.Simatic.S71500.Tasks;
USING tipi;
USING Libreria;
USING tempo;
USING System.Timer;

CONFIGURATION MyConfig

    
    TASK Load(PRIORITY:=1);
    TASK Main(PRIORITY:=0);
    TASK PackagesIn(PRIORITY:=0);
    
    PROGRAM P0 WITH Load: LoadConfiguration; 
    PROGRAM P1 WITH Main: MainProgram;
    PROGRAM P2 WITH PackagesIn: RandPack;

    // Configuring IO tags    
    VAR_GLOBAL
        
        //input output feed
        Qnf AT %Q0.0 : BOOL;
        Qdf AT %Q0.1 : BOOL;
        Qts AT %Q0.2 : BOOL;
        
        Idf AT %IB6 : USINT;
        Iff AT %I0.0 : BOOL;
        Isf AT %I0.1 : BOOL;
        Imf AT %I0.2 : BOOL;

        //input output coda
        Qnc AT %Q0.3 : BOOL;
        Qdc AT %Q0.4 : BOOL;
        Qtr AT %Q0.5 : BOOL; 
                
        Idc AT %IB4 : USINT;
        Ifc AT %I0.3 : BOOL;
        Isc AT %I0.4 : BOOL;
        Ifr AT %I0.5 : BOOL;

        //input output secondo magazzino
        Qn2 AT %Q0.6 : BOOL;
        Qd2 AT %Q0.7 : BOOL;
        Qt2 AT %Q1.0 : BOOL;

        Id2 AT %IB7 : USINT;
        If2 AT %I0.6 : BOOL;
        Is2 AT %I0.7 : BOOL;
        Im2 AT %I1.0 : BOOL;

        //input output terzo magazzino
        Qn3 AT %Q1.1 : BOOL;
        Qd3 AT %Q1.2 : BOOL;
        Qt3 AT %Q1.3 : BOOL;

        Id3 AT %IB8 : USINT;
        If3 AT %I1.1 : BOOL;
        Is3 AT %I1.2 : BOOL;
        Im3 AT %I1.3 : BOOL;

        //input output quarto magazzino
        Qn4 AT %Q1.4 : BOOL;
        Qd4 AT %Q1.5 : BOOL;
        Qt4 AT %Q1.6 : BOOL;

        Id4 AT %IB9 : USINT;
        If4 AT %I1.4 : BOOL;
        Is4 AT %I1.5 : BOOL;
        Im4 AT %I1.6 : BOOL;
 
    END_VAR

    VAR_GLOBAL
        nastri : ARRAY[1..n_mag] OF nastro;
        deviatori : ARRAY[1..n_mag] OF deviatore;
        magazzini : ARRAY[1..n_mag+1] OF inventory;
        n_pacchi : INT := 10; 
        elapsedtimer : tempo.Timer;
        coloreSim: USINT;
    END_VAR

    VAR_GLOBAL CONSTANT
        n_mag : INT := 5; // numero magazzini considerando uno feed e uno scarto e il penultimo ricetta o semplice
        capacity : INT := 10;
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
        nastri : ARRAY [1..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [1..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [1..n_mag+1] OF Libreria.inventory;
    END_VAR

    VAR_EXTERNAL CONSTANT
        n_mag : INT;
        capacity : INT;
    END_VAR

        //feed
        nastri[1].ID := 1;
        nastri[1].colore := USINT#0;
        nastri[1].actualState := stato#stop;
        nastri[1].CntrlForward := FALSE;
        nastri[1].CntrlBackward := FALSE;
        nastri[1].isForward := FALSE;
        nastri[1].isBackward := FALSE;

        deviatori[1].ID:=nastri[1].ID;
        deviatori[1].sensore := FALSE; 
        deviatori[1].chiuso := FALSE; 
        deviatori[1].cntrlApri := FALSE; 
        deviatori[1].cntrlChiudi := FALSE; 

        magazzini[1].ID:=nastri[1].ID;
        magazzini[1].acceptedColor := USINT#0; // impostare colore
        magazzini[1].actualState := stato#stop;
        magazzini[1].CntrlForward := FALSE;
        magazzini[1].CntrlBackward := FALSE;
        magazzini[1].isForward := FALSE;
        magazzini[1].isBackward := FALSE;

        magazzini[1].maxCapacity := Capacity; // impostare capacità desiderata
        magazzini[1].currentStockLevel:=0;
        magazzini[1].StockisFull := FALSE;
        magazzini[1].currentMode := Tipi.InventoryMode#Fill; // di default vogliamo riempire i magazzini

        //coda
        nastri[n_mag].ID := n_mag;
        nastri[n_mag].colore := USINT#0;
        nastri[n_mag].actualState := stato#stop;
        nastri[n_mag].CntrlForward := FALSE;
        nastri[n_mag].CntrlBackward := FALSE;
        nastri[n_mag].isForward := FALSE;
        nastri[n_mag].isBackward := FALSE;

        deviatori[n_mag].ID:=nastri[n_mag].ID;
        deviatori[n_mag].sensore := FALSE; 
        deviatori[n_mag].chiuso := FALSE; 
        deviatori[n_mag].cntrlApri := FALSE; 
        deviatori[n_mag].cntrlChiudi := FALSE; 

        magazzini[n_mag].ID:=nastri[n_mag].ID;
        magazzini[n_mag].acceptedColor := USINT#0; // impostare colore
        magazzini[n_mag].actualState := stato#stop;
        magazzini[n_mag].CntrlForward := FALSE;
        magazzini[n_mag].CntrlBackward := FALSE;
        magazzini[n_mag].isForward := FALSE;
        magazzini[n_mag].isBackward := FALSE;

        magazzini[n_mag].maxCapacity := Capacity; // impostare capacità desiderata
        magazzini[n_mag].currentStockLevel:=0;
        magazzini[n_mag].StockisFull := FALSE;
        magazzini[n_mag].currentMode := Tipi.InventoryMode#Fill; // di default vogliamo riempire i magazzini

        //secondo
        nastri[2].ID := 2;
        nastri[2].colore := USINT#0;
        nastri[2].actualState := stato#stop;
        nastri[2].CntrlForward := FALSE;
        nastri[2].CntrlBackward := FALSE;
        nastri[2].isForward := FALSE;
        nastri[2].isBackward := FALSE;

        deviatori[2].ID:=nastri[2].ID;
        deviatori[2].sensore := FALSE; 
        deviatori[2].chiuso := FALSE; 
        deviatori[2].cntrlApri := FALSE; 
        deviatori[2].cntrlChiudi := FALSE; 

        magazzini[2].ID:=nastri[2].ID;
        magazzini[2].acceptedColor := USINT#0; // impostare colore
        magazzini[2].actualState := stato#stop;
        magazzini[2].CntrlForward := FALSE;
        magazzini[2].CntrlBackward := FALSE;
        magazzini[2].isForward := FALSE;
        magazzini[2].isBackward := FALSE;

        magazzini[2].maxCapacity := Capacity; // impostare capacità desiderata
        magazzini[2].currentStockLevel:=0;
        magazzini[2].StockisFull := FALSE;
        magazzini[2].currentMode := Tipi.InventoryMode#Fill; // di default vogliamo riempire i magazzini

        //terzo
        nastri[3].ID := 3;
        nastri[3].colore := USINT#0;
        nastri[3].actualState := stato#stop;
        nastri[3].CntrlForward := FALSE;
        nastri[3].CntrlBackward := FALSE;
        nastri[3].isForward := FALSE;
        nastri[3].isBackward := FALSE;

        deviatori[3].ID:=nastri[3].ID;
        deviatori[3].sensore := FALSE; 
        deviatori[3].chiuso := FALSE; 
        deviatori[3].cntrlApri := FALSE; 
        deviatori[3].cntrlChiudi := FALSE; 

        magazzini[3].ID:=nastri[3].ID;
        magazzini[3].acceptedColor := USINT#0; // impostare colore
        magazzini[3].actualState := stato#stop;
        magazzini[3].CntrlForward := FALSE;
        magazzini[3].CntrlBackward := FALSE;
        magazzini[3].isForward := FALSE;
        magazzini[3].isBackward := FALSE;

        magazzini[3].maxCapacity := Capacity; // impostare capacità desiderata
        magazzini[3].currentStockLevel:=0;
        magazzini[3].StockisFull := FALSE;
        magazzini[3].currentMode := Tipi.InventoryMode#Fill; // di default vogliamo riempire i magazzini

        //quarto o ricetta
        nastri[4].ID := 4;
        nastri[4].colore := USINT#0;
        nastri[4].actualState := stato#stop;
        nastri[4].CntrlForward := FALSE;
        nastri[4].CntrlBackward := FALSE;
        nastri[4].isForward := FALSE;
        nastri[4].isBackward := FALSE;

        deviatori[4].ID:=nastri[4].ID;
        deviatori[4].sensore := FALSE; 
        deviatori[4].chiuso := FALSE; 
        deviatori[4].cntrlApri := FALSE; 
        deviatori[4].cntrlChiudi := FALSE; 

        magazzini[4].ID:=nastri[4].ID;
        magazzini[4].acceptedColor := USINT#0; // impostare colore
        magazzini[4].actualState := stato#stop;
        magazzini[4].CntrlForward := FALSE;
        magazzini[4].CntrlBackward := FALSE;
        magazzini[4].isForward := FALSE;
        magazzini[4].isBackward := FALSE;

        magazzini[4].maxCapacity := Capacity; // impostare capacità desiderata
        magazzini[4].currentStockLevel:=0;
        magazzini[4].StockisFull := FALSE;
        magazzini[4].currentMode := Tipi.InventoryMode#Fill; // di default vogliamo riempire i magazzini

END_PROGRAM


PROGRAM RandPack
    VAR
        PackOnDelay : OnDelay;
        deltaT: LTIME;
        triggerSuccess : BOOL;
        RandomSeed : INT := 12;
        coloreIngresso: colore;
        //enable : BOOL := TRUE;
    END_VAR

    VAR_EXTERNAL
        coloreSim : USINT;
    END_VAR

    PackOnDelay(signal := TRUE, duration := LTIME#5S); // Timer ogni 5 secondi per simulare l’arrivo di un pacco
    deltaT := PackOnDelay.elapsedTime;
    triggerSuccess := PackOnDelay.output;

    //timeAccumulator(enable := enable, previous := deltaT);
    
    IF triggerSuccess THEN //output diventa automaticamente TRUE se sono passati 5s
        deltaT := LTIME#0MS; //reset   
        // Simula colore random tra 0 e 7
        RandomSeed := (RandomSeed * 37 + 91) MOD 1000;
        coloreIngresso := TO_USINT(RandomSeed MOD 8); //MOD 8 limita il numero tra 0 e 7

        coloreSim:= coloreIngresso; //aggiorno una variabile globale che posso usare nel MainProgram o altrove
    END_IF; 

END_PROGRAM