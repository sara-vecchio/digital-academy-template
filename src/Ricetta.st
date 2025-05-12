//TO BE COMPLETED; NOT USED YET

USING tipi;

NAMESPACE Libreria

    CLASS PUBLIC Ricetta

        /*STRUCT RicettaTipo
            Colore: USINT; // colore desiderato
            Quantità: INT; // numero pacchi necessari
        END_STRUCT

        VAR_GLOBAL
            Ricetta : ARRAY[1..5] OF RicettaTipo; // max 5 tipi di pacchi richiesti
        END_VAR*/

        METHOD PUBLIC RecipeSatisfiable : BOOL
            VAR
                i: INT;
                matchingColor: USINT;
                matchingQuantity: INT;
                foundCount: INT;
            END_VAR

            RecipeSatisfiable := TRUE; // assumi che sia soddisfatta, fino a prova contraria
        
            /*FOR i := 1 TO SIZEOF(Tipi.Ricetta) DO
                matchingColor := Tipi.Ricetta[i].Colore;
                matchingQuantity := Tipi.Ricetta[i].Quantità;
        
                // Verifica se il magazzino ha il colore richiesto
                IF acceptedColor = matchingColor THEN
                    IF currentStockLevel < matchingQuantity THEN
                        RecipeSatisfiable := FALSE;
                        RETURN;
                    END_IF;
                END_IF;
            END_FOR;*/
                
        END_METHOD

        /*METHOD PUBLIC RecipeSatisfiable:BOOL
            IF Ricetta.HowMany THEN
                RecipeSatisfiable:=TRUE;
            ELSE
                RecipeSatisfiable:=FALSE;
            END_IF;
        END_METHOD*/

    END_CLASS

END_NAMESPACE
