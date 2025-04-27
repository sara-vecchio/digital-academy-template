USING tipi;
USING Libreria;

PROGRAM MainProgram

    VAR
        tStopMotor : INT:=5;//tempo movimento motori
        n_pacchi :INT:=10;
        n_mag : INT:=3;// numero magazzini

        nastri : ARRAY[1..3] OF nastro;
        deviatori : ARRAY[1..3] OF deviatore;
        magazzini : ARRAY[1..3+1] OF magazzino;

        fineProcesso: BOOL := FALSE;
        tempotrascorso: BOOL := FALSE;
        flag : BOOL := FALSE;

    END_VAR

    VAR_TEMP
        i:INT;
    END_VAR

    FOR i:=1 TO n_mag DO //inizializzare componenti
        nastri[i].Init(i);
        deviatori[i].Init(i);
        magazzini[i].Init(i); 
    END_FOR;

    magazzini[n_mag+1].Init(n_mag+1);
    
    IF not(n_pacchi>0) THEN //se non ci sono pacchi fine smistamento
        fineProcesso:= TRUE;
    END_IF;

    WHILE NOT(fineProcesso) DO //finche ci sono pacchi da smistare 
        i:=1;
        Flag := FALSE;

        IF n_pacchi = 0 THEN
            fineProcesso := TRUE;
        END_IF;

        WHILE i<n_mag+1 DO

            nastri[i].CntrlForward := TRUE;//movimento avanti motore nastro
            nastri[i].CheckEmpty();// fotocellula con pacchi
            nastri[i].Update();//aggiorna stato nastro
            
            if i>1 THEN
                deviatori[i-1].sensore := FALSE; //spegni il sensore del deviatore precendente
            END_IF;
            
            tempotrascorso := Timer(tStopMotor);
            deviatori[i].sensore := TRUE;//il deviatore vede un pacco
            //inserire check chiudi deviatore
            deviatori[i].ChiudiDeviatore();// controllato se il pacco è da smistare
    
            IF tempotrascorso AND deviatori[i].sensore THEN // controlla se il sensore vede il pacco dopo il movimento del motore
                nastri[i].CntrlForward := FALSE;//spegni motore
                nastri[i].update();//aggiorna stato nastro

                IF NOT(magazzini[i].isFull) AND deviatori[i].chiuso THEN //controlla che il magazzino sia libero, il colore del pacco corrisponde con il colore del magazzino
                    deviatori[i].ChiudiDeviatore();// devia il pacco
                    magazzini[i].CntrlForward := TRUE;//attiva motore magazzino
                    magazzini[i].update();//aggiorna lo stato del nastro magazzino
                    nastri[i].isEmpty := TRUE;//spegne la fotocellula nastro 
                    deviatori[i].sensore := FALSE;// spegne sensore presenza pacco
                    magazzini[i].fotocellula := TRUE;// la fotocellula del magazzino vede il pacco
                
                    tempotrascorso := Timer(tStopMotor);
                    magazzini[i].fotocellula := FALSE;// la fotocellula non vede più il pacco che è entrato a magazzino

                    n_pacchi := n_pacchi-1; //il numero di pacchi cala
                    magazzini[i].spazio := magazzini[i].spazio - 1; //lo spazio del magazzino cala

                    IF magazzini[i].spazio = 0 THEN//se non c'è più spazio il magazzino diventa pieno
                        magazzini[i].isFull:=TRUE;
                    END_IF;
                    
                    flag:=TRUE;// flag per segnare che i pacchi sono già stati ridotti
                    i:=n_mag;

                END_IF;

            END_IF;

            i:=i+1;
        
        END_WHILE;

        IF i=n_mag+1 AND NOT(Flag) THEN //se abbiamo passato tutti i magazzini e i pacchi non sono stati ridotti entra nel magazzino scarto finale
            n_pacchi:= n_pacchi-1; //il numero di pacchi cala
            magazzini[n_mag+1].spazio := magazzini[n_mag].spazio - 1;  //lo spazio del magazzino scarto finale cala
            IF magazzini[n_mag+1].spazio = -1 THEN // se lo spazio del magazzino finale da 0 passa a -1 significa che vogliamo forzare un pacco che non è stato smistato nel magazzino finale pieno 
                fineProcesso := TRUE; //esci dal ciclo perche non posso più carica
            END_IF;
        END_IF;

    END_WHILE;

    //smistamento completato 

END_PROGRAM