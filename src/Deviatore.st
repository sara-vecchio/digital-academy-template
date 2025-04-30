USING Tipi;

NAMESPACE Libreria
    
    CLASS deviatore

        VAR PUBLIC
            ID :INT;
            sensore : BOOL; // il sensore del deviatore del magazzino rosso si attiva se vede un pacco rosso
            cntrlApri : BOOL; // segnale per aprire il deviatore (se è aperto lascia passare i pacchi)   
            cntrlChiudi : BOOL; // segnale per chiudere il deviatore (se è chiuso devia i pacchi)
            chiuso : BOOL; 
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
            cntrlApri := FALSE;
            chiuso:= TRUE;
        END_METHOD // NB ci pensa test.st a definire (chiuso := TRUE)

        METHOD PUBLIC ApriDeviatore : BOOL // una volta deviato il pacco nel mai (sensore = FALSE) vogliamo aprire il deviatore
            cntrlApri := TRUE;
            cntrlChiudi := FALSE;
            chiuso := FALSE;
        END_METHOD // NB ci pensa test.st a definire (chiuso := FALSE)
    

    END_CLASS

END_NAMESPACE