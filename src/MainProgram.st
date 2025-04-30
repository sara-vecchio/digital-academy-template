USING tipi;
USING Libreria;
USING System.Timer;

PROGRAM MainProgram

    VAR_external
        nastri : ARRAY [1..3] OF Libreria.nastro;
        deviatori : ARRAY [1..3] OF Libreria.deviatore;
        magazzini : ARRAY [1..4] OF Libreria.inventory;

    END_VAR

    VAR_external
        Qnf : BOOL;
        Qdf : BOOL;
        Qts : BOOL;
        Iff : BOOL;
        Idf : USINT;
        Isf : BOOL;
        Imf : BOOL;
        Qnn : BOOL;
        Qdn : BOOL;
        Qtn : BOOL;
        Ifn : BOOL;
        Idn : USINT;
        Isn : BOOL;
        Imn : BOOL;
        Qnc : BOOL;
        Qdc : BOOL;
        Qtr : BOOL;
        Ifc : BOOL;
        Idc : USINT;
        Isc : BOOL;
        Ifr : BOOL;
    END_VAR
    
    VAR
        n_pacchi :INT:=10;
        fineProcesso: BOOL := FALSE;
        tempotrascorso: BOOL := FALSE;
        flag : BOOL := FALSE;
        run_time : TIME;
    END_VAR

    VAR CONSTANT
        n_mag: int :=3;
    END_VAR

    VAR_TEMP
        i:INT;
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

        WHILE i<n_mag+1 DO
            
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
            
            IF deviatori[i].IsMycolor(Idf) THEN // controllato se il pacco è da smistare
                
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
            n_pacchi:= n_pacchi-1; //il numero di pacchi cala
            magazzini[n_mag+1].currentStockLevel := magazzini[n_mag+1].GetCurrentStockLevel()+1;
            magazzini[n_mag+1].isFull();  //lo spazio del magazzino scarto finale cala
            IF magazzini[n_mag+1].StockisFull THEN // se lo spazio del magazzino finale da 0 passa a -1 significa che vogliamo forzare un pacco che non è stato smistato nel magazzino finale pieno 
                fineProcesso := TRUE; //esci dal ciclo perche non posso più carica
            END_IF;
        END_IF;

    END_WHILE;

    //smistamento completato 

END_PROGRAM