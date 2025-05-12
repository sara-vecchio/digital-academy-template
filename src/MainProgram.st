USING tipi;
USING Libreria;
USING System.Timer;

PROGRAM MainProgram

    VAR_external
        nastri : ARRAY [1..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [1..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [1..n_mag] OF Libreria.inventory;
        //Qn : ARRAY[1..n_mag] of BOOL ;
        //Qd : ARRAY[1..n_mag] of BOOL ;
        //Qt : ARRAY[1..n_mag] of BOOL ;
        //Id : ARRAY[1..n_mag] of USINT ;
        //If_ : ARRAY[1..n_mag] of BOOL ;
        //Is : ARRAY[1..n_mag] of BOOL ;
        //Im : ARRAY[1..n_mag] of BOOL ;
        //ListaPacchi2: ARRAY [1..n_pacchi_max] OF USINT;
        //ListaPacchi: ARRAY [1..n_pacchi_max] OF USINT;
    END_VAR

    VAR_external
        Qn: BYTE;
        Qd: BYTE;
        Qt: BYTE;
        //Id: BYTE;
        If_ :BYTE;
        Is:BYTE;
        Im:BYTE;
        Mask: ARRAY[1..n_mag] of BYTE;
        MaskOnes: BYTE;

        /*Qnf : BOOL;
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
        Im4 : BOOL;*/
        elapsedtimer : tempo.Timer;
        flag : BOOL;
        fineProcesso: BOOL;
        n_pacchi : INT;
    END_VAR

    VAR_external CONSTANT 
        n_mag: int;
        tStopMotor : Time;
        //n_pacchi_max : INT;
    END_VAR

    VAR_TEMP
        i:INT;
    END_VAR
    
    /*IF n_pacchi<0 THEN //se non ci sono pacchi fine smistamento
        fineProcesso := TRUE;
    END_IF;*/

    WHILE NOT(fineProcesso) DO //finche ci sono pacchi da smistare 
        i:=1;
        flag := FALSE;

        IF n_pacchi = 0 THEN
            fineProcesso := TRUE;
        END_IF;

        
        WHILE i<n_mag DO

            Qn := nastri[i].RunForward(MaskOnes); //i nastri sono sempre in moto (forward)
            nastri[i].isEmpty := nastri[i].CheckEmpty(If_ AND Mask[i]);// controlla se il nastro ha un pacco  
            nastri[i].actualState := nastri[i].Update();//aggiorna stato nastro
            
            WHILE NOT elapsedtimer.Check(Qn[i],tStopMotor) DO
                ;
            END_WHILE;
            If_[i] := FALSE;// spegni fotocellula del nastro
            Is[i] := TRUE;// accendi sensore (prima del deviatore)
            
            IF Is[i] THEN
            Qn[i] := nastri[i].Stop();
            nastri[i].isEmpty := nastri[i].CheckEmpty(Im[i]);// controlla se il nastro ha un pacco
            nastri[i].actualState := nastri[i].Update();//aggiorna stato nastro
            END_IF;
            
            //Id[1]:=ListaPacchi2[n_pacchi_max-n_pacchi+1];
            Id[1]:=ListaPacchi[n_pacchi_max-n_pacchi+1];
            IF deviatori[i].IsMycolor(Id[i]) = TRUE THEN // controllato se il pacco è da smistare
                //Id[i]
                IF magazzini[i].StockisFull THEN
                    deviatori[i].Discard();
                ELSE
                    deviatori[i].Accept();
                    Qt[i]:=(magazzini[i].RunForward()*Mask[i] OR Qtall);//attiva motore tank 
                    magazzini[i].update();//aggiorna lo stato del nastro magazzino
                    magazzini[i].isEmpty := magazzini[i].CheckEmpty(Im[i]);// controlla se il nastro ha un pacco
                    magazzini[i].actualState := magazzini[i].Update();//aggiorna stato nastro
                    Is[i] := FALSE;
                    Im[i] := TRUE; 
                    IF elapsedtimer.Check(Im[i],tStopMotor) THEN
                        Im[i] := FALSE;
                    END_IF;
                    Qt[i] := magazzini[i].Stop();
                    magazzini[i].update();//aggiorna lo stato del nastro magazzino
                    magazzini[i].isEmpty := magazzini[i].CheckEmpty(Im[i]);// controlla se il nastro ha un pacco
                    magazzini[i].actualState := magazzini[i].Update();//aggiorna stato nastro
                    n_pacchi := n_pacchi-1; //il numero di pacchi cala
                    Id[1]  := USINT#0;
                    Id[2]  := USINT#0;
                    Id[3]  := USINT#0;
                    Id[4]  := USINT#0;
                    Id[5]  := USINT#0;
                    magazzini[i].currentStockLevel := magazzini[i].GetCurrentStockLevel()+1; //lo spazio del magazzino cala
                    magazzini[i].isFull();
                    
                    flag:=TRUE;// flag per segnare che i pacchi sono già stati ridotti
                    i:=n_mag;

                END_IF;


            ELSE

            Id[i+1] := Id[i];

            END_IF;

            i:=i+1;

            IF n_pacchi = 0 THEN
                fineProcesso := TRUE;
            END_IF;

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