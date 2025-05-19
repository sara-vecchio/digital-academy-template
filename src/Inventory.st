USING Tipi;
USING Libreria;

NAMESPACE Libreria

    CLASS PUBLIC inventory 

        VAR PUBLIC

            ID_magazzino: INT;
            currentStockLevel: INT; //livello di stock attuale
            maxCapacity: INT; //capacità massima
            StockisFull: BOOL;
            nastroMagazzino : nastro; //NB: se usavo EXTENDS non riuscivo ad usare il metodo Init di nastro all'interno del metodo Init_magazzino

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
        ;  //  currentStockLevel := currentStockLevel + 1;
        END_METHOD

   
        
    END_CLASS

END_NAMESPACE
