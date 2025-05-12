USING Tipi;
USING Libreria;

NAMESPACE Libreria

    CLASS PUBLIC Inventory 
        VAR PUBLIC
            ID_magazzino: INT;
            currentStockLevel: INT; //livello di stock attuale
            maxCapacity: INT; //capacità massima
            StockisFull: BOOL;
            nastroMagazzino : nastro;

            /*ListStoredPackages: ARRAY[1..3] OF USINT; //dato che un magazzino deve avere pacchi dello stesso colore, può servire per controllare che tutti i pacchi inseriti abbiano effettivamente lo stesso colore
            currentMode: Tipi.InventoryMode;
            statomotore: stato;
            recipe: Ricetta;*/
        END_VAR
        

        METHOD PUBLIC Init_magazzino 
            VAR_INPUT
                IDinit: INT;
                Capacity : INT;
            END_VAR
            ID_magazzino:= IDinit;
            currentStockLevel:=0; //ipotizzo che inizialmente i magazzini siano vuoti
            maxCapacity := Capacity;
            StockisFull := FALSE;
            nastroMagazzino.Init(IDinit); //ho aggiunto l'inizializzazione del nastro del magazzino
        END_METHOD


        METHOD PUBLIC isFull : BOOL //controlla se il magazzino è pieno
            IF currentStockLevel < maxCapacity THEN
                isFull:= FALSE;
                StockisFull := FALSE;
            ELSE
                isFull:=TRUE;
                StockisFull := TRUE;
            END_IF;
        END_METHOD


        METHOD PUBLIC Counter //aumento il numero di pacchi contati nel magazzino
            currentStockLevel := currentStockLevel + 1;
        END_METHOD


        /*METHOD PUBLIC GetCurrentStockLevel : INT  //se chiamato, mostra il livello di riempimento attuale
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
                    THIS.EmptyFIFO();
                END_IF;
            END_IF;            
        END_METHOD*/             
        
    END_CLASS

END_NAMESPACE
