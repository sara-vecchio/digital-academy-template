USING Tipi;

NAMESPACE Libreria
    
    CLASS deviatore

        VAR PUBLIC
            ID :INT;
            acceptedColor : tipi.colore; //il colore da deviare (definito nell'inizializzazione)
            bCmd : BOOL; //se vero il deviatore devia se falso il deviatore lascia passare
            nCountAccepted : INT; //numero di pacchi deviati
        END_VAR
        
        METHOD PUBLIC Init // inizializzazione del deviatore
            VAR_INPUT
                IDinit : INT;
                color : tipi.colore;
            END_VAR
            ID:=IDinit;
            acceptedColor := color;
            bCmd := FALSE; //il deviatore lascia passare
            nCountAccepted := 0;
        END_METHOD


        METHOD PUBLIC Accept 
            bCmd := TRUE;
            nCountAccepted := nCountAccepted + 1;
        END_METHOD


        METHOD PUBLIC Discard : BOOL 
            bCmd := FALSE;
        END_METHOD
        

        METHOD PUBLIC IsMyColor : BOOL  //controlla se accettare o meno il pacco
            VAR_INPUT
                uSensor : colore; //colore letto dal sensore
                bSensor : BOOl; //sensore prima del deviatore
            END_VAR
            
            IF uSensor = acceptedColor AND bSensor THEN //se è il colore giusto AND il pacco è visto dal sensore
                IsMyColor := TRUE;
            ELSE
                IsMyColor := FALSE;
            END_IF;
        END_METHOD


        METHOD PUBLIC IsMyColor_coda : BOOL  //controlla se accettare o meno il pacco il blocco coda
            VAR_INPUT
                uSensor : colore; //colore letto dal sensore
                bSensor : BOOl; //sensore prima del deviatore
            END_VAR
            
            IF bSensor THEN //se il pacco è visto dal sensore (non controllo il colore)
                IsMyColor_coda := TRUE;
            ELSE
                IsMyColor_coda := FALSE;
            END_IF;
        END_METHOD




    END_CLASS

END_NAMESPACE
