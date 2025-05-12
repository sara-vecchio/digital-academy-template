NAMESPACE Libreria
    
    FUNCTION  SelectSensorInput : USINT
        VAR_INPUT
            uIndex : USINT;
            in1 : USINT;
            in2 : USINT;
            in3 : USINT;
            in4 : USINT;
            in5 : USINT;
        END_VAR
        CASE uIndex OF
            USINT#0 : SelectSensorInput:= in1;
            USINT#1 : SelectSensorInput:= in2;
            USINT#2 : SelectSensorInput:= in3;
            USINT#3 : SelectSensorInput:= in4;
            USINT#4 : SelectSensorInput:= in5;
        END_CASE;        
    END_FUNCTION
 END_NAMESPACE