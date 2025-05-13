USING tipi;
//USING MotorClass; //preso da libreria di @sara_vecchio

NAMESPACE Libreria
    
    CLASS nastro


        VAR PUBLIC
            ID:INT;
            actualState : stato;
            bMove : BOOL; //acceso o spento
            bForward : BOOL; //avanti o indietro
        END_VAR
        
        
        
        METHOD PUBLIC Init  //Inizializzazione
            VAR_INPUT
                IDinit : INT;
            END_VAR
            ID:=IDinit;
            actualState := stato#stop;
            bMove := FALSE;
            bForward := FALSE;
        END_METHOD
        

        
        
        METHOD PUBLIC isEmpty : BOOL  //check if is isEmpty from sensor    
            VAR_INPUT
                bLightSensor: BOOL; //Iff, If2, If3, If4, Ifc
                bSensor2 : BOOL; //Isf, Is2...
            END_VAR

            IF bLightSensor OR bSensor2 THEN
                isEmpty := FALSE;
            ELSIF NOT (bLightSensor OR bSensor2) THEN
                isEmpty := TRUE;
            ELSE
                //actualState := stato#error;
            END_IF;
        END_METHOD

        
        
        METHOD PUBLIC GetStatus : tipi.stato // get state of the conveyor
            IF bMove AND bForward THEN
                actualState := stato#forward;
            ELSIF bMove AND NOT(bForward) THEN
                actualState := stato#backward;
            ELSIF NOT(bMove) THEN
                actualState := stato#stop;
            END_IF;
            GetStatus := actualState;
        END_METHOD
    

        
        METHOD PUBLIC RunForward
            IF actualState <> stato#error THEN
                bMove := TRUE;
                bForward := TRUE;
                actualState := stato#forward;
            END_IF;
        END_METHOD



        METHOD PUBLIC RunBackward 
            IF actualState <> stato#error THEN
                bMove := TRUE;
                bForward := FALSE;
                actualState := stato#backward;
            END_IF;
        END_METHOD


        METHOD PUBLIC Stop
            IF actualState <> stato#error THEN
                bMove := FALSE;
                actualState := stato#stop;
            END_IF;
        END_METHOD
    
    
    END_CLASS


END_NAMESPACE
