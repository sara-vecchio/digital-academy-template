USING Tipi;

NAMESPACE Libreria
    
    CLASS nastro

        VAR 
            ID:INT;
            isEmpty: BOOL;
            actualState : stato;
            CntrlForward : BOOL;    // Comando avanti
            CntrlBackward : BOOL;   // Comando indietro
            isForward : BOOL;    // Uscita avanti
            isBackward : BOOL;   // Uscita indietro
        END_VAR
        
        METHOD Init  // Init motor
            actualState := stato#stop;
            CntrlForward := FALSE;
            CntrlBackward := FALSE;
            isForward := FALSE;
            isBackward := FALSE;
        END_METHOD
        
        METHOD Update
            
            IF CntrlForward AND NOT CntrlBackward THEN
                actualState := stato#forward;
            ELSIF CntrlBackward AND NOT CntrlForward THEN
                actualState := stato#backward;
            ELSE
                actualState := stato#stop;
            END_IF;
        
            CASE actualState OF
                stato#forward:
                    isForward := TRUE;
                    isBackward := FALSE;
                stato#backward:
                    isForward := FALSE;
                    isBackward := TRUE;
                stato#stop:
                    isForward := FALSE;
                    isBackward := FALSE;
            END_CASE;

        END_METHOD

        METHOD PUBLIC fotocellula  //check if is isEmpty from sensor
                isEmpty := TRUE;
        END_METHOD

        METHOD PUBLIC GetStatus // get state of the conveyor
            actualState:=actualState;
        END_METHOD
    END_CLASS

END_NAMESPACE