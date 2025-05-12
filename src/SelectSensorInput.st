NAMESPACE Libreria
    
    FUNCTION  SelectSensorInput : USINT
        VAR_INPUT
            uIndex : INT;
            in1 : USINT; //sensore colore deviatore nastro feed
            in2 : USINT; //sensore colore deviatore magazzino 2
            in3 : USINT; //sensore colore deviatore magazzino 3
            in4 : USINT; //sensore colore deviatore magazzino 4
            in5 : USINT; //sensore colore deviatore magazzino coda
        END_VAR
        CASE uIndex OF
            INT#1 : SelectSensorInput:= in1;
            INT#2 : SelectSensorInput:= in2;
            INT#3 : SelectSensorInput:= in3;
            INT#4 : SelectSensorInput:= in4;
            INT#5 : SelectSensorInput:= in5;
        END_CASE;        
    END_FUNCTION
 END_NAMESPACE