USING Tipi;

NAMESPACE Libreria
    
    CLASS deviatore

        VAR PUBLIC
            ID:INT;
            isEmpty: BOOL;
            colore : colore;
            i:INT;
            sensore:BOOL;
        END_VAR
        
        METHOD PUBLIC Init  // Init motor
            VAR_INPUT
                IDinit : INT;
            END_VAR
            ID:=IDinit;
            sensore:=FALSE;
            colore := colore;

        END_METHOD
    

    END_CLASS

END_NAMESPACE