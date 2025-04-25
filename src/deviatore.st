USING Tipi;

NAMESPACE Libreria
    
    CLASS deviatore

        VAR PUBLIC
            ID:INT;
            isEmpty: BOOL;
            colore : colore;
            i:INT;
            sensore_presenza:BOOL;
            smista:BOOL;
        END_VAR
        
        METHOD PUBLIC Init  // Init motor
            VAR_INPUT
                IDinit : INT;
            END_VAR
            ID:=IDinit;
            sensore_presenza:=FALSE;
            colore := colore;

        END_METHOD

        METHOD PUBLIC devia // Init motor

            ID:=ID;

        END_METHOD 

        METHOD PUBLIC check // Init motor

            ID:=ID;

        END_METHOD
    

    END_CLASS

END_NAMESPACE