USING Tipi;
USING Libreria;

NAMESPACE Libreria

    CLASS PUBLIC Inventory EXTENDS nastro 
        VAR PUBLIC
            IDpackage: INT;
            ListStoredPackages: ARRAY[1..100] OF USINT; //dato che un magazzino deve avere pacchi dello stesso colore, può servire per controllare che tutti i pacchi inseriti abbiano effettivamente lo stesso colore
            currentStockLevel: INT; //livello di stock attuale
            maxCapacity: INT; //capacità massima
            acceptedColor: USINT;
            StockisFull: BOOL;
            currentMode: Tipi.InventoryMode;
            statomotore: stato;
            recipe: Ricetta;
        END_VAR
        

        METHOD PUBLIC Init //initialization of the inventory
            VAR_INPUT
                Capacity : INT;
                Color : USINT;
                ID_i: INT;
            END_VAR
            maxCapacity := Capacity;
            acceptedColor := Color;
            IDpackage:= ID_i;
            currentStockLevel:=0; //ipotizzo che inizialmente i magazzini siano vuoti
            StockisFull := FALSE;
            currentMode := Tipi.InventoryMode#Fill; // di default vogliamo riempire i magazzini
        END_METHOD


        METHOD PUBLIC isFull  //controlla se il magazzino è pieno
            VAR_OUTPUT
                Load: BOOL; //TRUE:"ok puoi ancora riempire", FALSE:non puoi riempire
            END_VAR
            
            IF currentStockLevel < maxCapacity THEN
                StockisFull:= FALSE;
                Load:=TRUE;
            ELSE
                StockisFull:=TRUE;
                Load:=FALSE;
            END_IF;
        END_METHOD


        METHOD PUBLIC GetCurrentStockLevel : INT  //se chiamato, mostra il livello di riempimento attuale
            GetCurrentStockLevel:= currentStockLevel;
        END_METHOD


        METHOD PUBLIC EmptyFIFO
            VAR
                i: INT;
            END_VAR
            
            FOR i := 1 TO currentStockLevel - 1 DO
                ListStoredPackages[i] := ListStoredPackages[i + 1]; // Shift dei pacchi a sinistra (FIFO)
            END_FOR;
            ListStoredPackages[currentStockLevel] := TO_USINT(0); //resetto l'ultima posizione
            currentStockLevel := currentStockLevel - 1;

            IF currentStockLevel = 0 THEN
                statomotore := Tipi.stato#stop;
                currentMode:=Tipi.InventoryMode#Fill;
            END_IF;
        END_METHOD


        METHOD PUBLIC SetMode // MODALITà RIEMPIMENTO O SVUOTAMENTO, LOGICA:FIFO
            VAR_INPUT
                mode : Tipi.InventoryMode;
                //InventorySensor:BOOL;
                InventoryPhotocell: BOOL; //c'è un pacco sul nastro del magazzino?
                DiverterSensor: BOOL; //se TRUE il deviatore è chiuso e manda il pacco al magazzino
                ID_i: USINT;
            END_VAR
            currentMode := mode;
            IF currentMode= InventoryMode#Fill THEN
                IF StockisFull=FALSE AND DiverterSensor=TRUE AND statomotore=Tipi.stato#forward AND InventoryPhotocell=TRUE THEN
                    currentStockLevel:=currentStockLevel+1;
                    ListStoredPackages[currentStockLevel]:= ID_i; //salvo l'ID_i del pacco n nell'n-esima posizione dell'array
                ELSIF StockisFull=TRUE THEN
                    RETURN; //magari inserire una variabile tipo warningCode/exitflag...
                END_IF;
            ELSE // the mode is set to "empty"
                IF recipe.RecipeSatisfiable()=TRUE THEN //AND currentStockLevel > 0 THEN
                    statomotore := Tipi.stato#backward;
                    //EmptyFIFO(); //potete commentare questa riga mentre trovo una soluzione all'errore
                END_IF;
            END_IF;            
        END_METHOD             
        
    END_CLASS

END_NAMESPACE