FUNCTION Timer: BOOL
    VAR_INPUT
        tStopMotor: INT;   // Tempo massimo che la funzione aspetta
    END_VAR
    
    VAR
        tTemp: INT := 0;   // Variabile temporanea per il conteggio
    END_VAR
    
    Timer:=FALSE;
    // Ciclo WHILE per incrementare il valore di t fino a tStopMotor
    WHILE tTemp < tStopMotor DO
        tTemp := tTemp + 1;
    END_WHILE;
    
    // Dopo aver completato il ciclo, ritorna TRUE (indica che è finito)
    Timer := TRUE; 
    
END_FUNCTION
    