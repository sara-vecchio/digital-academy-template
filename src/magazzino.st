USING Tipi;

NAMESPACE Libreria
    
    CLASS magazzino

        VAR PUBLIC
            ID:INT;
            isFull: BOOL;
            colore : colore;
            i:INT;
            spazio:INT;
            fotocellula:BOOL;
            actualState : stato;
            CntrlForward : BOOL;    // Comando avanti
            CntrlBackward : BOOL;   // Comando indietro
            isForward : BOOL;    // Uscita avanti
            isBackward : BOOL;   // Uscita indietro
            
        END_VAR
        
        METHOD PUBLIC Init  // Init motor
            VAR_INPUT
                IDinit : INT;
                Color : colore;
            END_VAR
            ID:=IDinit;
            colore := color;
            actualState := stato#stop;
            CntrlForward := FALSE;
            CntrlBackward := FALSE;
            isForward := FALSE;
            isBackward := FALSE;

        END_METHOD
    
        METHOD PUBLIC Update
            
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

    END_CLASS

END_NAMESPACE