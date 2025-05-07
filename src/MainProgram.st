USING tipi;
USING Libreria;
USING System.Timer;

PROGRAM MainProgram

    VAR_external
        nastri : ARRAY [1..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [1..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [1..n_mag] OF Libreria.inventory;
        Qn : ARRAY[1..n_mag] of BOOL ;
        Qd : ARRAY[1..n_mag] of BOOL ;
        Qt : ARRAY[1..n_mag] of BOOL ;
        Id : ARRAY[1..n_mag] of USINT ;
        If_ : ARRAY[1..n_mag] of BOOL ;
        Is : ARRAY[1..n_mag] of BOOL ;
        Im : ARRAY[1..n_mag] of BOOL ;
    END_VAR

    VAR_external
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
        elapsedtimer : tempo.Timer;
    END_VAR

   

    VAR 
        tStopMotor : Time;//tempo movimento motori
    END_VAR
    
    VAR
        fineProcesso: BOOL := FALSE;
        tempotrascorso: BOOL := FALSE;
        flag : BOOL := FALSE;
        run_time : TIME;
    END_VAR

    VAR_external CONSTANT 
        n_mag: int;
        capacity : INT;
    END_VAR

    VAR_TEMP
        i:INT;
        n_pacchi :INT;
    END_VAR
    
    IF n_pacchi<=0 THEN //se non ci sono pacchi fine smistamento
        fineProcesso:= TRUE;
    END_IF;

    WHILE NOT(fineProcesso) DO //finche ci sono pacchi da smistare 
        i:=1;
        Flag := FALSE;

        IF n_pacchi = 0 THEN
            fineProcesso := TRUE;
        END_IF;

        WHILE i<n_mag DO

            Simulazione();
            Qn[i] := nastri[i].RunForward();
            nastri[i].isEmpty := nastri[i].CheckEmpty(If_[i]);// controlla se il nastro ha un pacco
            nastri[i].actualState := nastri[i].Update();//aggiorna stato nastro
            IF elapsedtimer.Check(Qn[i],tStopMotor) THEN
                If_[i] := FALSE;// spegni fotocellula del nastro
                Is[i] := TRUE;// accendi sensore
            END_IF;
            
            IF Is[i] THEN
            Qn[i] := nastri[i].Stop();
            nastri[i].isEmpty := nastri[i].CheckEmpty(Im[i]);// controlla se il nastro ha un pacco
            nastri[i].actualState := nastri[i].Update();//aggiorna stato nastro
            END_IF;
            
            IF deviatori[i].IsMycolor(Id[i]) THEN // controllato se il pacco è da smistare
                
                IF magazzini[i].StockisFull THEN
                    deviatori[i].Discard();
                ELSE
                    deviatori[i].Accept();
                    Qt[i]:=magazzini[i].RunForward();//attiva motore tank 
                    magazzini[i].update();//aggiorna lo stato del nastro magazzino
                    magazzini[i].isEmpty := magazzini[i].CheckEmpty(Im[i]);// controlla se il nastro ha un pacco
                    magazzini[i].actualState := magazzini[i].Update();//aggiorna stato nastro
                    Is[i] := FALSE;
                    Im[i] := TRUE; 
                    IF elapsedtimer.Check(Im[i],tStopMotor) THEN
                        Im[i] := FALSE;
                    END_IF;
                    Qt[i] := magazzini[i].Stop();

                    n_pacchi := n_pacchi-1; //il numero di pacchi cala
                    magazzini[i].currentStockLevel := magazzini[i].GetCurrentStockLevel()+1; //lo spazio del magazzino cala
                    magazzini[i].isFull();
                    
                    flag:=TRUE;// flag per segnare che i pacchi sono già stati ridotti
                    
                    i:=n_mag;

                END_IF;

            END_IF;

            i:=i+1;
        
        END_WHILE;

        IF i=n_mag AND NOT(Flag) THEN //se abbiamo passato tutti i magazzini e i pacchi non sono stati ridotti entra nel magazzino scarto finale
            n_pacchi := n_pacchi-1; //il numero di pacchi cala
            magazzini[n_mag].currentStockLevel := magazzini[n_mag].GetCurrentStockLevel()+1;
            magazzini[n_mag].isFull();  
            
            IF magazzini[n_mag].StockisFull THEN 
                fineProcesso := TRUE; //esci dal ciclo perche non posso più caricare
            END_IF;
        END_IF;

    END_WHILE;

END_PROGRAM