USING Tipi;

NAMESPACE Inventory_lib

    CLASS PUBLIC Inventory
        VAR PUBLIC
            IDpackage: INT;
            ListStoredPackages: ARRAY[1..100] OF USINT; //dato che un magazzino deve avere pacchi dello stesso colore, può servire per controllare che tutti i pacchi inseriti abbiano effettivamente lo stesso colore
            currentStockLevel: INT; //livello di stock attuale
            maxCapacity: INT; //capacità massima
            acceptedColor: USINT;
            StockisFull: BOOL;
            currentMode: Tipi.InventoryMode;
        END_VAR

        METHOD PUBLIC Init //initialization of the inventory
            VAR_INPUT
                Capacity : INT;
                Color : USINT; //oppure tipi.colore#... oppure semplicemente INT e lo legge da solo?
                ID: INT;
            END_VAR
            maxCapacity := Capacity;
            acceptedColor := Color;
            IDpackage:= ID; //anche qui sarebbe color... forse non ha senso avere sia color che ID
            currentStockLevel:=0; //ipotizzo che inizialmente i magazzini siano vuoti
            StockisFull:=FALSE;
            currentMode := Tipi.InventoryMode#Fill; // di default vogliamo riempire i magazzini
        END_METHOD

        METHOD PUBLIC isFull  //controlla se il magazzino è pieno
            VAR_OUTPUT
                StockisFull: BOOL;
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

        METHOD PUBLIC SetMode // MODALITà RIEMPIMENTO O SVUOTAMENTO, LOGICA:FIFO
            VAR_INPUT
                mode : Tipi.InventoryMode;
                //InventorySensor:BOOL;
                InventoryPhotocell: BOOL; //c'è un pacco sul nastro del magazzino?
                DiverterSensor: BOOL; //se TRUE il deviatore è chiuso e manda il pacco al magazzino
                ID: USINT;
            END_VAR
            currentMode := mode;
            IF currentMode= InventoryMode#Fill THEN
                IF StockisFull=FALSE AND DiverterSensor=TRUE AND Tipi.stato=Tipi.stato#forward AND InventoryPhotocell=TRUE THEN
                    currentStockLevel:=currentStockLevel+1;
                    ListStoredPackages[currentStockLevel]:= ID; //salvo l'ID del pacco n nell'n-esima posizione dell'array
                ELSIF StockisFull=TRUE THEN
                    RETURN; //magari inserire una variabile tipo warningCode/exitflag...
                END_IF;
            /*ELSE // the mode is set to "empty"
                IF RecipeSatisfiable=TRUE AND Tipi.stato=backward THEN
                    currentStockLevel:=currentStockLevel-;
                END_IF*///DA COMPLETARE
            END_IF;            
        END_METHOD 
        
    END_CLASS

END_NAMESPACE


/*{Test}
METHOD PUBLIC MyTestMethod
    ; // AxUnit.Assert.Equal(y, x)
END_METHOD*/