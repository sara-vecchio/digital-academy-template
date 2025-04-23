USING tipi;
USING Libreria;
USING Siemens.Simatic.S71500;

PROGRAM MainProgram

    VAR
        n:INT;
        nastri : ARRAY[1..10] OF nastro;
        //deviatori[i] : ARRAY[1..10] OF deviatore;
        //magazzini[i] : ARRAY[1..10] OF magazzino;
        tStopMotor : INT;
        
    END_VAR

    VAR_TEMP

         i:INT;

    END_VAR

    n:=10;

    FOR i:=1 TO n DO //initialize components
            
        nastri[i].Init(i);   
        //deviatori[i].Init(i);
        //magazzini[i].Init(i); 

    END_FOR;

    i:=i+1;
    //magazzini[i].Init(i);

    i:=1; 

    
    WHILE nastri[i].isEmpty = TRUE DO

        nastri[i].CntrlForward := TRUE;
        nastri[i].Update();

        //implementare un timer che conta fino a 5s
        tStopMotor:=0;
        WHILE tStopMotor<5 DO
            tStopMotor := tStopMotor + 1;
        END_WHILE;

        IF tStopMotor = 5 THEN
            nastri[i].CntrlForward := FALSE;
            nastri[i].update();
        END_IF;
        
        
        i := i + 1;
    END_WHILE;







END_PROGRAM