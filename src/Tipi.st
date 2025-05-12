NAMESPACE tipi

    TYPE  stato : (stop, forward, backward, unknown, error);
    END_TYPE

    TYPE
        colore : USINT (
            Undefined := USINT#0, // il pacco va nel magazzino "scarto feed"
            Red       := USINT#1, // il pacco va nel magazzino 2
            White     := USINT#2, // il pacco va nel magazzino 3
            Yellow    := USINT#3, // il pacco va nel magazzino 4
            Green     := USINT#4, // il pacco va nel magazzino "scarto coda"
            Blue      := USINT#5, // il pacco va nel magazzino "scarto coda"
            Cyan      := USINT#6, // il pacco va nel magazzino "scarto coda"
            Violet    := USINT#7  // il pacco va nel magazzino "scarto coda"
        );
    END_TYPE

    TYPE InventoryMode: 
        (Fill, Empty);
    END_TYPE

END_NAMESPACE
