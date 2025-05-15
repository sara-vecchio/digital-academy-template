USING tipi;
USING Libreria;


PROGRAM MainProgram


    VAR_external
        nastri : ARRAY [1..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [1..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [1..n_mag] OF Libreria.inventory;
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

    END_VAR


    VAR_external CONSTANT 

        n_mag: int;

    END_VAR

    

 
    //BLOCCO FEED
    IF NOT(nastri[1].isEmpty(Iff,Isf)) THEN //se pacco presente sul nastro principale
        nastri[1].RunForward(); 
        Qnf := nastri[1].bMove; //accendo il nastro principale
    ELSE
        nastri[1].Stop(); 
        Qnf := nastri[1].bMove; //spengo il nastro principale
    END_IF;
    

    IF Isf THEN //se il sensore prima del deviatore vede un pacco
        IF deviatori[1].IsMyColor(Idf) THEN // controllo se il pacco è da smistare
            IF magazzini[1].isFull() THEN //se il magazzino è pieno
                deviatori[1].Discard();
                Qdf := deviatori[1].bCmd; //disattivo il deviatore
            ELSE
                deviatori[1].Accept();
                Qdf := deviatori[1].bCmd; //attivo il deviatore
                magazzini[1].Counter(); //dico che nel magazzino c'è un pacco in più
            END_IF;
        ELSE
            deviatori[1].Discard();
            Qdf := deviatori[1].bCmd; //disattivo il deviatore
        END_IF;
    END_IF;


    IF NOT(magazzini[1].nastroMagazzino.isEmpty(Imf,Imf)) THEN //se il pacco è sul nastro del magazzino (NB: per come l'ho scritta la funzione isEmpty ha bisogno di 2 sensori)
        magazzini[1].nastroMagazzino.RunForward();
        Qtf := magazzini[1].nastroMagazzino.bMove; //accendo il nastro del magazzino
    ELSE
        magazzini[1].nastroMagazzino.Stop(); 
        Qtf := magazzini[1].nastroMagazzino.bMove; //spengo il nastro del magazzino
    END_IF; 





    //BLOCCO 2
    IF NOT(nastri[2].isEmpty(If2,Is2)) THEN //se pacco presente sul nastro principale
        nastri[2].RunForward(); 
        Qn2 := nastri[2].bMove; //accendo il nastro principale
    ELSE
        nastri[2].Stop(); 
        Qn2 := nastri[2].bMove; //spengo il nastro principale
    END_IF;
    

    IF Is2 THEN //se il sensore prima del deviatore vede un pacco
        IF deviatori[2].IsMyColor(Id2) THEN // controllo se il pacco è da smistare
            IF magazzini[2].isFull() THEN //se il magazzino è pieno
                deviatori[2].Discard();
                Qd2 := deviatori[2].bCmd; //disattivo il deviatore
            ELSE
                deviatori[2].Accept();
                Qd2 := deviatori[2].bCmd; //attivo il deviatore
                magazzini[2].Counter(); //dico che nel magazzino c'è un pacco in più
            END_IF;
        ELSE
            deviatori[2].Discard();
            Qd2 := deviatori[2].bCmd; //disattivo il deviatore
        END_IF;
    END_IF;


    IF NOT(magazzini[2].nastroMagazzino.isEmpty(Im2,Im2)) THEN //se il pacco è sul nastro del magazzino (NB: per come l'ho scritta la funzione isEmpty ha bisogno di 2 sensori)
        magazzini[2].nastroMagazzino.RunForward();
        Qt2 := magazzini[2].nastroMagazzino.bMove; //accendo il nastro del magazzino
    ELSE
        magazzini[2].nastroMagazzino.Stop(); 
        Qt2 := magazzini[2].nastroMagazzino.bMove; //spengo il nastro del magazzino
    END_IF; 





    //BLOCCO 3
    IF NOT(nastri[3].isEmpty(If3,Is3)) THEN //se pacco presente sul nastro principale
        nastri[3].RunForward(); 
        Qn3 := nastri[3].bMove; //accendo il nastro principale
    ELSE
        nastri[3].Stop(); 
        Qn3 := nastri[3].bMove; //spengo il nastro principale
    END_IF;
    

    IF Is3 THEN //se il sensore prima del deviatore vede un pacco
        IF deviatori[3].IsMyColor(Id3) THEN // controllo se il pacco è da smistare
            IF magazzini[3].isFull() THEN //se il magazzino è pieno
                deviatori[3].Discard();
                Qd3 := deviatori[3].bCmd; //disattivo il deviatore
            ELSE
                deviatori[3].Accept();
                Qd3 := deviatori[3].bCmd; //attivo il deviatore
                magazzini[3].Counter(); //dico che nel magazzino c'è un pacco in più
            END_IF;
        ELSE
            deviatori[3].Discard();
            Qd3 := deviatori[3].bCmd; //disattivo il deviatore
        END_IF;
    END_IF;


    IF NOT(magazzini[3].nastroMagazzino.isEmpty(Im3,Im3)) THEN //se il pacco è sul nastro del magazzino (NB: per come l'ho scritta la funzione isEmpty ha bisogno di 2 sensori)
        magazzini[3].nastroMagazzino.RunForward();
        Qt3 := magazzini[3].nastroMagazzino.bMove; //accendo il nastro del magazzino
    ELSE
        magazzini[3].nastroMagazzino.Stop(); 
        Qt3 := magazzini[3].nastroMagazzino.bMove; //spengo il nastro del magazzino
    END_IF; 




    //BLOCCO 4
    IF NOT(nastri[4].isEmpty(If4,Is4)) THEN //se pacco presente sul nastro principale
        nastri[4].RunForward(); 
        Qn4 := nastri[4].bMove; //accendo il nastro principale
    ELSE
        nastri[4].Stop(); 
        Qn4 := nastri[4].bMove; //spengo il nastro principale
    END_IF;
    

    IF Is4 THEN //se il sensore prima del deviatore vede un pacco
        IF deviatori[4].IsMyColor(Id4) THEN // controllo se il pacco è da smistare
            IF magazzini[4].isFull() THEN //se il magazzino è pieno
                deviatori[4].Discard();
                Qd4 := deviatori[4].bCmd; //disattivo il deviatore
            ELSE
                deviatori[4].Accept();
                Qd4 := deviatori[4].bCmd; //attivo il deviatore
                magazzini[4].Counter(); //dico che nel magazzino c'è un pacco in più
            END_IF;
        ELSE
            deviatori[4].Discard();
            Qd4 := deviatori[4].bCmd; //disattivo il deviatore
        END_IF;
    END_IF;


    IF NOT(magazzini[4].nastroMagazzino.isEmpty(Im4,Im4)) THEN //se il pacco è sul nastro del magazzino (NB: per come l'ho scritta la funzione isEmpty ha bisogno di 2 sensori)
        magazzini[4].nastroMagazzino.RunForward();
        Qt4 := magazzini[4].nastroMagazzino.bMove; //accendo il nastro del magazzino
    ELSE
        magazzini[4].nastroMagazzino.Stop(); 
        Qt4 := magazzini[4].nastroMagazzino.bMove; //spengo il nastro del magazzino
    END_IF; 




    //BLOCCO CODA
    IF NOT(nastri[5].isEmpty(Ifc,Isc)) THEN //se pacco presente sul nastro principale
        nastri[5].RunForward(); 
        Qnc := nastri[5].bMove; //accendo il nastro principale
    ELSE
        nastri[5].Stop(); 
        Qnc := nastri[5].bMove; //spengo il nastro principale
    END_IF;
    

    IF Isc THEN //se il sensore prima del deviatore vede un pacco
        IF deviatori[5].IsMyColor_coda(Idc) THEN // controllo se il pacco è da smistare
            IF magazzini[5].isFull() THEN //se il magazzino è pieno
                deviatori[5].Discard();
                Qdc := deviatori[5].bCmd; //disattivo il deviatore
            ELSE
                deviatori[5].Accept();
                Qdc := deviatori[5].bCmd; //attivo il deviatore
                magazzini[5].Counter(); //dico che nel magazzino c'è un pacco in più
            END_IF;
        ELSE
            deviatori[5].Discard();
            Qdc := deviatori[5].bCmd; //disattivo il deviatore
        END_IF;
    END_IF;


    IF NOT(magazzini[5].nastroMagazzino.isEmpty(Imc,Imc)) THEN //se il pacco è sul nastro del magazzino (NB: per come l'ho scritta la funzione isEmpty ha bisogno di 2 sensori)
        magazzini[5].nastroMagazzino.RunForward();
        Qtc := magazzini[5].nastroMagazzino.bMove; //accendo il nastro del magazzino
    ELSE
        magazzini[5].nastroMagazzino.Stop(); 
        Qtc := magazzini[5].nastroMagazzino.bMove; //spengo il nastro del magazzino
    END_IF;


END_PROGRAM
