USING Tipi;

NAMESPACE Libreria
    
    CLASS nastro

        VAR 
            ID:INT;
            isEmpty: BOOL;
            actualState : Tipi.stato;
            CntrlForward : BOOL;    // Comando per andare avanti
            CntrlBackward : BOOL;   // Comando per andare indietro
            isForward : BOOL;    // Uscita avanti
            isBackward : BOOL;   // Uscita indietro
        END_VAR
        
        METHOD Init
            // Inizializza il motore
            actualState := Tipi.stato#stop;
            CntrlForward := FALSE;
            CntrlBackward := FALSE;
            isForward := FALSE;
            isBackward := FALSE;
        END_METHOD
        
        METHOD Update
            
            IF CntrlForward AND NOT CntrlBackward THEN
                actualState := Tipi.stato#forward;
            ELSIF CntrlBackward AND NOT CntrlForward THEN
                actualState := Tipi.stato#backward;
            ELSE
                actualState := Tipi.stato#stop;
            END_IF;
        
            CASE actualState OF
                tipi.stato#forward:
                    isForward := TRUE;
                    isBackward := FALSE;
                tipi.stato#backward:
                    isForward := FALSE;
                    isBackward := TRUE;
                tipi.stato#stop:
                    isForward := FALSE;
                    isBackward := FALSE;
            END_CASE;
        END_METHOD

        METHOD PUBLIC fotocellula 
            //check if is isEmpty from sensor
                isEmpty := TRUE;
        END_METHOD

        METHOD PUBLIC GetStatus 
            // ottieni stato del nastro
            actualState:=actualState;
            END_METHOD
    END_CLASS

END_NAMESPACE