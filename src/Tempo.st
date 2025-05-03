USING System.Timer;

NAMESPACE tempo
    
    Class Timer

    VAR
        ton : OnDelay;
    END_VAR

    METHOD PUBLIC Check : BOOL 
        VAR_INPUT
            signal: BOOL;
            duration : time;
            timeout : time;
        END_VAR
        ton(signal := TRUE, duration := Timeout);
        IF (ton.output) THEN
            Check := TRUE;
        ELSE
           Check := FALSE;
        END_IF;
    END_METHOD

    METHOD PUBLIC Reset
        ton(signal:= FALSE);
    END_METHOD

    END_class 

END_NAMESPACE
    