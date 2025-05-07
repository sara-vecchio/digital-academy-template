USING tipi;
//USING MotorClass; //preso da libreria di @sara_vecchio

NAMESPACE Libreria
    
    CLASS nastro


        VAR PUBLIC
            ID:INT;
            actualState : stato;    // Comando avanti
            CntrlBackward : BOOL;   // Comando indietro
            isForward : BOOL;    // Uscita avanti //necessario?
            isBackward : BOOL;   // Uscita indietro //necessario?
            isEmpty:BOOL;
            CntrlForward : BOOL;
            colore: colore;
        END_VAR
        
        
        
        METHOD PUBLIC Init  // Initialization motor
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
        
        
        
        METHOD PUBLIC Update : stato
            
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

        
        
        METHOD PUBLIC CheckEmpty : BOOL  //check if is isEmpty from sensor
           
            VAR_INPUT
                bLightSensor: BOOL;
            END_VAR

            IF bLightSensor THEN
                CheckEmpty := FALSE;
            ELSIF NOT bLightSensor THEN
                CheckEmpty := TRUE;
            ELSE
                actualState := stato#error;
            END_IF;

        END_METHOD

        
        
        METHOD PUBLIC GetStatus : tipi.stato // get state of the conveyor
            GetStatus := actualState;
        END_METHOD
    
        
        
        METHOD PUBLIC Stop : BOOL
            CntrlForward := FALSE;
            CntrlBackward := FALSE;
            actualState := stato#stop;
        END_METHOD

        
        
        METHOD PUBLIC RunForward : BOOL //serve chiamare anche i motori?
            IF actualState <> stato#error THEN
                //Motor.Start := TRUE;
                CntrlForward := TRUE; //aggiungi sicura per eviatre che avanti e indietro possano essere attivati contemporaneamente
                actualState := stato#forward;
            END_IF;
        END_METHOD



        METHOD PUBLIC RunBackward 
            IF actualState <> stato#error THEN
                //Motor.Start := TRUE;
                CntrlBackward := TRUE; //aggiungi stessa sicura di sopra
                actualState := stato#backward;
            END_IF;
        END_METHOD
    
    
    
    END_CLASS


END_NAMESPACE