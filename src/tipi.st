NAMESPACE tipi

    TYPE  stato : (stop, forward, backward, unknown, error);
    END_TYPE

    TYPE
        colore : USINT (
            Undefined := USINT#0,
            Red       := USINT#1,
            Orange    := USINT#2,
            Yellow    := USINT#3,
            Green     := USINT#4,
            Blue      := USINT#5,
            Indigo    := USINT#6,
            Violet    := USINT#7
        ) := Undefined;
    END_TYPE

END_NAMESPACE