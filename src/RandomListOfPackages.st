//WORKING, BUT NOT USED

/*USING System.Timer;

PROGRAM RandPack
    VAR
        PackOnDelay : OnDelay;
        triggerSuccess : BOOL;
        RandomSeed : INT:=1;
        coloreIngresso: USINT;
        pacchi_creati: INT:=0;
    END_VAR
    
    VAR_EXTERNAL CONSTANT
        n_pacchi_max : INT;
        ListaPacchi: ARRAY [1..n_pacchi_max] OF USINT; 
    END_VAR

WHILE  pacchi_creati<n_pacchi_max DO //serve effettivamente questo while?
    PackOnDelay(signal := pacchi_creati<n_pacchi_max, duration := T#50ms); // se dopo 50ms signal è ancora TRUE, l'output diventa TRUE
    triggerSuccess := PackOnDelay.output;
    
    IF triggerSuccess AND pacchi_creati<n_pacchi_max THEN
        // Simula colore random tra 0 e 7
        RandomSeed := (RandomSeed * 37 + 91) MOD 1000;
        coloreIngresso := TO_USINT(RandomSeed MOD 8); //MOD 8 limita il numero tra 0 e 7

        IF coloreIngresso>USINT#7 THEN
            coloreIngresso:=USINT#0;
        END_IF;

        ListaPacchi[pacchi_creati + 1] := coloreIngresso;
        pacchi_creati := pacchi_creati + 1;
    END_IF; 
END_WHILE;

END_PROGRAM*/
