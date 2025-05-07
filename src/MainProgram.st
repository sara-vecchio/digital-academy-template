USING tipi;
USING Libreria;
USING System.Timer;

PROGRAM MainProgram

    VAR_external
        nastri : ARRAY [1..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [1..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [1..n_mag] OF Libreria.inventory;
        coloreSim : USINT;
    END_VAR

    VAR_external
        Qnf : BOOL;
        Qdf : BOOL;
        Qts : BOOL;
        Idf : USINT;
        Iff : BOOL;
        Isf : BOOL;
        Imf : BOOL;
        Qnc : BOOL;
        Qdc : BOOL;
        Qtr : BOOL;
        Idc : USINT;
        Ifc : BOOL;
        Isc : BOOL;
        Ifr : BOOL;
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
        i:=0;
        Flag := FALSE;

        IF n_pacchi = 0 THEN
            fineProcesso := TRUE;
        END_IF;

        WHILE i<n_mag DO

            Simulazione();
            Qnf := nastri[i].RunForward();
            nastri[i].isEmpty := nastri[i].CheckEmpty(Iff);// controlla se il nastro ha un pacco
            nastri[i].actualState := nastri[i].Update();//aggiorna stato nastro
            Simulazione();
            
            IF Isf THEN
            Qnf := nastri[i].Stop();
            nastri[i].isEmpty := nastri[i].CheckEmpty(Imf);// controlla se il nastro ha un pacco
            nastri[i].actualState := nastri[i].Update();//aggiorna stato nastro
            END_IF;
            
            IF deviatori[i].IsMycolor(coloreSim) THEN // controllato se il pacco è da smistare
                
                IF magazzini[i].StockisFull THEN
                    deviatori[i].Discard();
                END_IF;
                
                IF NOT(magazzini[i].StockisFull) THEN
                    deviatori[i].Accept();
                    
                    Qts:=magazzini[i].RunForward();//attiva motore tank scarto 
                    magazzini[i].update();//aggiorna lo stato del nastro magazzino
                    magazzini[i].isEmpty := magazzini[i].CheckEmpty(Iff);// controlla se il nastro ha un pacco
                    magazzini[i].actualState := magazzini[i].Update();//aggiorna stato nastro
                    Simulazione();
                    Qts := magazzini[i].Stop();

                    n_pacchi := n_pacchi-1; //il numero di pacchi cala
                    magazzini[i].currentStockLevel := magazzini[i].GetCurrentStockLevel()+1; //lo spazio del magazzino cala
                    magazzini[i].isFull();
                    
                    flag:=TRUE;// flag per segnare che i pacchi sono già stati ridotti
                    
                    i:=n_mag;

                END_IF;

            END_IF;

            i:=i+1;
        
        END_WHILE;

        IF i=n_mag+1 AND NOT(Flag) THEN //se abbiamo passato tutti i magazzini e i pacchi non sono stati ridotti entra nel magazzino scarto finale
            n_pacchi := n_pacchi-1; //il numero di pacchi cala
            magazzini[n_mag+1].currentStockLevel := magazzini[n_mag+1].GetCurrentStockLevel()+1;
            magazzini[n_mag+1].isFull();  
            
            IF magazzini[n_mag+1].StockisFull THEN 
                fineProcesso := TRUE; //esci dal ciclo perche non posso più caricare
            END_IF;
        END_IF;

    END_WHILE;

END_PROGRAM