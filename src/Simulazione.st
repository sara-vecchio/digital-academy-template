USING tipi;
USING System.Timer;
USING tempo;

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
            Iff : BOOL := TRUE;
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

        VAR_EXTERNAL
            elapsedtimer : tempo.Timer;
        END_VAR

        VAR 
            tStopMotor : Time;//tempo movimento motori
        END_VAR

        IF Qnf AND Iff THEN
            
            IF elapsedtimer.Check(Qnf,tStopMotor) THEN
                Iff := FALSE;// spegni fotocellula del nastro
                Isf := TRUE;// accendi sensore
            END_IF;

        END_IF;

        IF Qts AND Isf THEN
            Isf := FALSE;
            Imf := TRUE; 
            IF elapsedtimer.Check(Imf,tStopMotor) THEN
                Imf := FALSE;
            END_IF;
        END_IF;

        ;
    END_FUNCTION 

       
END_NAMESPACE