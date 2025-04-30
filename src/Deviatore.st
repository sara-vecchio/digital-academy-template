USING Tipi;

NAMESPACE Libreria
    
    CLASS deviatore

        VAR PUBLIC
            ID :INT;
            color : colore;
            sensore : BOOL; // il sensore del deviatore del magazzino rosso si attiva se vede un pacco rosso
            cntrlApri : BOOL; // segnale per aprire il deviatore (se è aperto lascia passare i pacchi)   
            cntrlChiudi : BOOL; // segnale per chiudere il deviatore (se è chiuso devia i pacchi)
            chiuso : BOOL; 
            accetta : BOOL;
        END_VAR
        
        METHOD PUBLIC Init // inizializzazione del deviatore
            VAR_INPUT
                IDinit : INT;
            END_VAR
            ID:=IDinit;
            sensore := FALSE; // all'inizio non vede il pacco
            chiuso := FALSE; // all'inizio il deviatore è aperto
            cntrlApri := FALSE; 
            cntrlChiudi := FALSE; // all'inizio non ci sono comandi di apertura o chiusura
        END_METHOD

        METHOD PUBLIC ChiudiDeviatore : BOOL // nel main se (sensore = TRUE) vogliamo chiudere il deviatore

            cntrlChiudi := TRUE;

        END_METHOD 

        METHOD PUBLIC ApriDeviatore : BOOL // una volta deviato il pacco nel mai (sensore = FALSE) vogliamo aprire il deviatore
            cntrlApri := TRUE;
            cntrlChiudi := FALSE;
            chiuso := FALSE;
        END_METHOD // NB ci pensa test.st a definire (chiuso := FALSE)

        METHOD PUBLIC Accept 

            cntrlChiudi := TRUE;

        END_METHOD

        METHOD PUBLIC Discard 

            cntrlApri := TRUE;

        END_METHOD
        
        METHOD PUBLIC IsMyColor : BOOL  //controlla se accettare o meno il pacco
            VAR_INPUT
                uSensor:colore;
            END_VAR
            
            IF uSensor = color THEN
                accetta :=TRUE;
            ELSE
                accetta :=FALSE;
            END_IF;
            
        END_METHOD

    END_CLASS

END_NAMESPACE