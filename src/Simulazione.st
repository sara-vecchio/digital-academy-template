USING tipi;

NAMESPACE Libreria
    
    FUNCTION Simulazione 
           
        VAR_INPUT 
            Qnf : BOOL;
            Qdf : BOOL;
            Qts : BOOL;
            Qnn : BOOL;
            Qdn : BOOL;
            Qtn : BOOL;
            Qnc : BOOL;
            Qdc : BOOL;
            Qtr : BOOL;
        END_VAR

        VAR_OUTPUT
            Idf : USINT;
            Iff : BOOL;
            Isf : BOOL;
            Imf : BOOL;
            Idn : USINT;
            Ifn : BOOL;
            Isn : BOOL;
            Imn : BOOL;
            Idc : USINT;
            Ifc : BOOL;
            Isc : BOOL;
            Ifr : BOOL;
        END_VAR

        VAR 
            tStopMotor : INT:=5;//tempo movimento motori
            tempo : BOOL;
        END_VAR

        IF Qnf AND Iff THEN
            tempo := FALSE;
            tempo := Timer(tStopMotor); // aspetta 5 secondi
            IF tempo THEN
                Iff := FALSE;// spegni fotocellula del nastro
                Isf := TRUE;
            END_IF;
        END_IF;

        IF Qts AND Isf THEN
            tempo := FALSE;
            Isf := FALSE;
            Imf := TRUE;
            tempo := Timer(tStopMotor); // aspetta 5 secondi
            IF tempo THEN
                Imf := FALSE;
            END_IF;
        END_IF;

        ;
    END_FUNCTION 

       
END_NAMESPACE