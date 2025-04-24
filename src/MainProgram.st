USING tipi;
USING Libreria;
USING Siemens.Simatic.S71500;

PROGRAM MainProgram

    VAR
        n_mag:INT:=3;// numero magazzini colore
        nastri : ARRAY[1..3] OF nastro;
        deviatori : ARRAY[1..3] OF deviatore;
        magazzini : ARRAY[1..3+1] OF magazzino;
        tStopMotor : INT;//tempo movimento
        n_pacchi :INT;
    END_VAR

    VAR_TEMP
        i:INT;
    END_VAR

    FOR i:=1 TO n_mag DO //initialize components
        nastri[i].Init(i);   
        deviatori[i].Init(i);
        magazzini[i].Init(i); 
    END_FOR;

    i:=i+1;
    magazzini[i].Init(i);
    
    IF n_pacchi>0 THEN //se ci sono pacchi la fotocellula del primo nastro lo riconosce
        nastri[1].isEmpty:=FALSE;
    END_IF;

    WHILE nastri[1].isEmpty = FALSE AND n_pacchi>=0 DO //finche ci sono pacchi
        i:=1;
        WHILE i<n_mag+1 DO
            nastri[i].CntrlForward := TRUE;//movimento avanti
            nastri[i].Update();//aggiorna stato nastro
    
            //implementare un timer che conta fino a 5s
            tStopMotor:=0;
            WHILE tStopMotor<5 DO
                tStopMotor := tStopMotor + 1;
                deviatori[i].sensore := TRUE;
            END_WHILE;
    
            IF tStopMotor >= 5 AND deviatori[i].sensore = TRUE THEN // controlla se il sensore vede il pacco
                nastri[i].CntrlForward := FALSE;//spegni motore
                nastri[i].update();//aggiorna stato nastro

                IF magazzini[i].isFull = FALSE AND deviatori[i].colore = nastri[i].colore THEN //controlla che il magazzino sia libero, il colore del pacco corrisponde con il colore del magazzino
                    magazzini[i].CntrlForward :=TRUE;//attiva motore magazzino
                    magazzini[i].update();//aggiorna lo stato del nastro magazzino
                    
                    //implementare un timer che conta fino a 5s
                    tStopMotor:=0;
                    WHILE tStopMotor<5 DO
                        tStopMotor := tStopMotor + 1;
                    END_WHILE;

                    magazzini[i].spazio := magazzini[i].spazio - 1;

                    IF magazzini[i].spazio = 0 THEN

                        magazzini[i].isFull:=TRUE;

                    END_IF;
                    
                    i:=n_mag+1;

                END_IF;

            END_IF;

            i:=i+1;
        
        END_WHILE;

        n_pacchi:=n_pacchi-1;

        IF i=n_mag+1 THEN
        
            magazzini[i].spazio := magazzini[i].spazio - 1;
            
            IF magazzini[i].spazio = 0 THEN

            magazzini[i].isFull:=TRUE;

            n_pacchi := -1; //esci dal ciclo perche pieno

            END_IF;

        END_IF;
        

        IF n_pacchi = 0 THEN
            nastri[1].isEmpty:=TRUE;
        END_IF;

    END_WHILE;

    //smistamento completato o non possibile

END_PROGRAM