USING Siemens.Simatic.S71500.Tasks;
USING tipi;
USING Libreria;


CONFIGURATION MyConfig

    TASK Load: Startup;
    TASK Main(Interval := T#100ms,PRIORITY:=1); //di default è 50ms (minimo)
    
    PROGRAM P0 WITH Load: LoadConfiguration; 
    PROGRAM P1 WITH Main: MainProgram;




    // Configuring IO tags    
    VAR_GLOBAL 
        
        //input output feed
        Qnf AT %Q0.0 : BOOL; //output nastro feed 
        Qnc AT %Q0.1 : BOOL;
        Qn2 AT %Q0.2 : BOOL;
        Qn3 AT %Q0.3 : BOOL;
        Qn4 AT %Q0.4 : BOOL;

        Qdf AT %Q1.0 : BOOL; //output deviatore feed 
        Qdc AT %Q1.1 : BOOL; 
        Qd2 AT %Q1.2 : BOOL;
        Qd3 AT %Q1.3 : BOOL;
        Qd4 AT %Q1.4 : BOOL;
        
        Qtf AT %Q2.0 : BOOL; //output tank feed 
        Qtc AT %Q2.1 : BOOL;   
        Qt2 AT %Q2.2 : BOOL;   
        Qt3 AT %Q2.3 : BOOL; 
        Qt4 AT %Q2.4 : BOOL; 

        Idf AT %IB6 : USINT; //input deviatore feed (colore)
        Idc AT %IB7 : USINT;
        Id2 AT %IB8 : USINT;
        Id3 AT %IB9 : USINT;
        Id4 AT %IB10 : USINT;

        Iff AT %I0.0 : BOOL; //input fotocellula feed (presenza pacco su nastro principale)
        Ifc AT %I0.1 : BOOL;
        If2 AT %I0.2 : BOOL; 
        If3 AT %I0.3 : BOOL;
        If4 AT %I0.4 : BOOL;
        
        Isf AT %I1.0 : BOOL; //input sensore feed (presenza pacco su nastro principale prima del deviatore)
        Isc AT %I1.1 : BOOL; 
        Is2 AT %I1.2 : BOOL; 
        Is3 AT %I1.3 : BOOL;
        Is4 AT %I1.4 : BOOL;

        Imf AT %I2.0 : BOOL; //input magazzino feed (presenza pacco su nastro principale)
        Imc AT %I2.1 : BOOL;                                                
        Im2 AT %I2.2 : BOOL;
        Im3 AT %I2.3 : BOOL;
        Im4 AT %I2.4 : BOOL;
 
    END_VAR

    VAR_GLOBAL

        nastri : ARRAY[1..n_mag] OF nastro;        
        deviatori : ARRAY[1..n_mag] OF deviatore;
        magazzini : ARRAY[1..n_mag] OF inventory;
        
    END_VAR

    VAR_GLOBAL CONSTANT

        n_mag : INT := 5; // numero magazzini considerando uno feed e uno scarto e il penultimo ricetta o semplice
        capacity : INT := 20; //numero pacchi che ogni magazzino può contenere
         
    END_VAR
    

END_CONFIGURATION


PROGRAM LoadConfiguration

    VAR_EXTERNAL

        nastri : ARRAY [1..n_mag] OF Libreria.nastro;
        deviatori : ARRAY [1..n_mag] OF Libreria.deviatore;
        magazzini : ARRAY [1..n_mag] OF Libreria.inventory;

        Qnf : BOOL;
        Qdf : BOOL;
        Qtf : BOOL;
        Idf : USINT;
        Iff : BOOL;
        Isf : BOOL;
        Imf : BOOL;
        Qnc : BOOL;
        Qdc : BOOL;
        Qtc : BOOL;
        Idc : USINT;
        Ifc : BOOL;
        Isc : BOOL;
        Imc : BOOL;
        Qn2 : BOOL;
        Qd2 : BOOL;
        Qt2 : BOOL;
        Id2 : USINT;
        If2 : BOOL;
        Is2 : BOOL;
        Im2 : BOOL;
        Qn3 : BOOL;
        Qd3 : BOOL;
        Qt3 : BOOL;
        Id3 : USINT;
        If3 : BOOL;
        Is3 : BOOL;
        Im3 : BOOL;
        Qn4 : BOOL;
        Qd4 : BOOL;
        Qt4 : BOOL;
        Id4 : USINT;
        If4 : BOOL;
        Is4 : BOOL;
        Im4 : BOOL;
    
        
    END_VAR

    VAR_EXTERNAL CONSTANT
        n_mag : INT;
        capacity : INT;
    END_VAR


    //inizializzo il blocco feed
    nastri[1].Init(1);
    deviatori[1].Init(1, colore#Undefined); //qua dico anche che colore il deviatore deve accettare
    magazzini[1].Init_magazzino(1, capacity);


    //inizializzo il blocco 2
    nastri[2].Init(2);
    deviatori[2].Init(2, colore#Red); //qua dico anche che colore il deviatore deve accettare
    magazzini[2].Init_magazzino(2, capacity);


    //inizializzo il blocco 3
    nastri[3].Init(3);
    deviatori[3].Init(3, colore#White); //qua dico anche che colore il deviatore deve accettare
    magazzini[3].Init_magazzino(3, capacity);


    //inizializzo il blocco 4
    nastri[4].Init(4);
    deviatori[4].Init(4, colore#Yellow); //qua dico anche che colore il deviatore deve accettare
    magazzini[4].Init_magazzino(4, capacity);


    //inizializzo il blocco coda
    nastri[n_mag].Init(n_mag);
    deviatori[n_mag].Init(n_mag, colore#Undefined); //qua dico un colore a caso ma in realtà accetta tutto (vedi method deviatore.IsMyColor_coda)
    magazzini[n_mag].Init_magazzino(n_mag, capacity);


END_PROGRAM
