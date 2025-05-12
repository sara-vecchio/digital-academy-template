USING tipi;

PROGRAM LoadPlantConfiguration
    

    VAR_TEMP
        i:INT :=0;
    END_VAR

    VAR
    coloreq : USINT;
    END_VAR

    VAR_EXTERNAL
        nastri : ARRAY [1..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [1..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [1..n_mag] OF Libreria.inventory;
        //Qn : REF_TO ARRAY[1..n_mag] of BOOL ;
        //Qd : ARRAY[1..n_mag] of BOOL ;
        //Qt : ARRAY[1..n_mag] of BOOL ;
        Id : ARRAY[1..n_mag] of USINT ;
        //If_ : ARRAY[1..n_mag] of BOOL ;
        //Is : ARRAY[1..n_mag] of BOOL ;
        //Im : ARRAY[1..n_mag] of BOOL ;

        Qn: BYTE;
        Qd: BYTE;
        Qt: BYTE;
        //Id: BYTE;
        If_ :BYTE;
        Is:BYTE;
        Im:BYTE;

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
        //n_pacchi : INT;
        elapsedtimer : tempo.Timer;
        
    END_VAR

    VAR_EXTERNAL CONSTANT
        n_mag : INT;
        capacity : INT;
        n_pacchi : INT;
    END_VAR

        /*Qn[1]  := Qnf;
        Qn[2]  := Qn2;
        Qn[3]  := Qn3;
        Qn[4]  := Qn4;
        Qn[5]  := Qnc;

        Qd[1]  := Qdf;
        Qd[2]  := Qd2;
        Qd[3]  := Qd3;
        Qd[4]  := Qd4;
        Qd[5]  := Qdc;

        Qt[1]  := Qtf;
        Qt[2]  := Qt2;
        Qt[3]  := Qt3;
        Qt[4]  := Qt4;
        Qt[5]  := Qtc;*/

        Id[1]  := Idf;
        Id[2]  := Id2;
        Id[3]  := Id3;
        Id[4]  := Id4;
        Id[5]  := Idc;

        /*If_[1] := Iff;
        If_[2] := If2;
        If_[3] := If3;
        If_[4] := If4;
        If_[5] := Ifc;

        Is[1] := Isf;
        Is[2] := Is2;
        Is[3] := Is3;
        Is[4] := Is4;
        Is[5] := Isc;

        Im[1] := Imf;
        Im[2] := Im2;
        Im[3] := Im3;
        Im[4] := Im4;
        Im[5] := Imc;*/

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
        deviatori[1].color:=USINT#0; //colre magazzino feed (da aggiornare con TUTTI i colori che non sono appartenenti ad un magazzino colore)

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
        deviatori[n_mag].color:=USINT#0;


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
        nastri[2].colore := USINT#1;
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
        deviatori[2].color:=USINT#1;


        magazzini[2].ID:=nastri[2].ID;
        magazzini[2].acceptedColor := USINT#1; // impostare colore
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
        nastri[3].colore := USINT#2;
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
        deviatori[3].color:=USINT#2;


        magazzini[3].ID:=nastri[3].ID;
        magazzini[3].acceptedColor := USINT#2; // impostare colore
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
        nastri[4].colore := USINT#3;
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
        deviatori[4].color:=USINT#3;


        magazzini[4].ID:=nastri[4].ID;
        magazzini[4].acceptedColor := USINT#3; // impostare colore
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