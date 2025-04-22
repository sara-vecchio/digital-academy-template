CONFIGURATION MyConfiguration
    TASK Main(Priority := 1);
    
    PROGRAM P1 WITH Main: MainProgram;
        
    VAR_GLOBAL
        Tag1 : INT;
        Tag3 AT %IB4 : BYTE;
    END_VAR

    VAR_GLOBAL CONSTANT
        Tag2 : BOOL := TRUE ;
    END_VAR
     

END_CONFIGURATION