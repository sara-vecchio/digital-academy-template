USING tipi;
USING System.Timer;
USING tempo;

NAMESPACE Libreria
    
    FUNCTION Simulazione
           
        VAR_INPUT 
            Qnf : BOOL;
            Qdf : BOOL;
            Qtf : BOOL;
            Qn2 : BOOL;
            Qd2 : BOOL;
            Qt2 : BOOL;
            Qn3 : BOOL;
            Qd3 : BOOL;
            Qt3 : BOOL;
            Qn4 : BOOL;
            Qd4 : BOOL;
            Qt4 : BOOL;
            Qnc : BOOL;
            Qdc : BOOL;
            Qtc : BOOL;
        END_VAR

        VAR_OUTPUT
            Idf : USINT;
            Iff : BOOL := TRUE;
            Isf : BOOL;
            Imf : BOOL;
            Id2 : USINT;
            If2 : BOOL;
            Is2 : BOOL;
            Im2 : BOOL;
            Id3 : USINT;
            If3 : BOOL;
            Is3 : BOOL;
            Im3 : BOOL;
            Id4 : USINT;
            If4 : BOOL;
            Is4 : BOOL;
            Im4 : BOOL;
            Idc : USINT;
            Ifc : BOOL;
            Isc : BOOL;
            Imc : BOOL;
        END_VAR

        VAR_IN_OUT//_EXTERNAL
            elapsedtimer : tempo.Timer;
        END_VAR

        VAR 
            tStopMotor : Time;//tempo movimento motori
        END_VAR

        //BLOCCO FEED
        IF Qnf AND Iff THEN //IF nastro principale feed va avanti AND pacco presente su nastro principale feed       
            IF elapsedtimer.Check(Qnf,tStopMotor) THEN //TIMER DA SISTEMARE
                Iff := FALSE; //spegni fotocellula nastro principare feed
                Isf := TRUE; //accendi sensore pacco prima del deviatore feed
                //Idf := ... ; //il sensore riceve il colore del pacco
            END_IF;
        END_IF;

        IF Qdf AND Isf THEN //IF deviatore feed chiuso (sta deviando) AND pacco presente prima del deviatore feed
            //NB: il main attualmente non cambia i valori nel vettore Qd
            Isf := FALSE; //spegni sensore pacco prima del deviatore feed
            Imf := TRUE; //accendi fotocellula nastromagazzino feed
            IF Qtf AND elapsedtimer.Check(Imf,tStopMotor) THEN //IF nastro magazzino feed va avanti AND tempo passato
                Imf := FALSE; 
            END_IF; //il pacco è arrivato al magazzino feed
        END_IF;


        //BLOCCO 2
        IF Qn2 AND If2 THEN //IF nastro principale va avanti AND pacco presente su nastro principale    
            IF elapsedtimer.Check(Qnf,tStopMotor) THEN //TIMER DA SISTEMARE
                If2 := FALSE; //spegni fotocellula nastro principale
                Is2 := TRUE; //accendi sensore pacco prima del deviatore
                //Id2 := ... ; //il sensore riceve il colore del pacco
            END_IF;
        END_IF;

        IF Qd2 AND Is2 THEN //IF deviatore chiuso (sta deviando) AND pacco presente prima del deviatore
            //NB: il main attualmente non cambia i valori nel vettore Qd
            Is2 := FALSE; //spegni sensore pacco prima del deviatore 
            Im2 := TRUE; //accendi fotocellula nastro magazzino
            IF Qt2 AND elapsedtimer.Check(Imf,tStopMotor) THEN //IF nastro magazzino va avanti AND tempo passato
                Im2 := FALSE; 
            END_IF; //il pacco è arrivato al magazzino
        END_IF;


        //BLOCCO 3
        IF Qn3 AND If3 THEN //IF nastro principale va avanti AND pacco presente su nastro principale     
            IF elapsedtimer.Check(Qnf,tStopMotor) THEN //TIMER DA SISTEMARE
                If3 := FALSE; //spegni fotocellula nastro principale
                Is3 := TRUE; //accendi sensore pacco prima del deviatore
                //Id3 := ... ; //il sensore riceve il colore del pacco
            END_IF;
        END_IF;

        IF Qd3 AND Is3 THEN //IF deviatore chiuso (sta deviando) AND pacco presente prima del deviatore
            //NB: il main attualmente non cambia i valori nel vettore Qd
            Is3 := FALSE; //spegni sensore pacco prima del deviatore
            Im3 := TRUE; //accendi fotocellula nastro magazzino feed
            IF Qt3 AND elapsedtimer.Check(Imf,tStopMotor) THEN //IF nastro magazzino va avanti AND tempo passato
                Im3 := FALSE; 
            END_IF; //il pacco è arrivato al magazzino 
        END_IF;


        //BLOCCO 4
        IF Qn4 AND If4 THEN //IF nastro principale va avanti AND pacco presente su nastro principale      
            IF elapsedtimer.Check(Qnf,tStopMotor) THEN //TIMER DA SISTEMARE
                If4 := FALSE; //spegni fotocellula nastro principale
                Is4 := TRUE; //accendi sensore pacco prima del deviatore 
                //Id4 := ... ; //il sensore riceve il colore del pacco
            END_IF;
        END_IF;

        IF Qd4 AND Is4 THEN //IF deviatore chiuso (sta deviando) AND pacco presente prima del deviatore
            //NB: il main attualmente non cambia i valori nel vettore Qd
            Is4 := FALSE; //spegni sensore pacco prima del deviatore
            Im4 := TRUE; //accendi fotocellula nastromagazzino
            IF Qt4 AND elapsedtimer.Check(Imf,tStopMotor) THEN //IF nastro magazzino va avanti AND tempo passato
                Im4 := FALSE; 
            END_IF; //il pacco è arrivato al magazzino 
        END_IF;


        //BLOCCO CODA
        IF Qnc AND Ifc THEN //IF nastro principale va avanti AND pacco presente su nastro principale      
            IF elapsedtimer.Check(Qnf,tStopMotor) THEN //TIMER DA SISTEMARE
                Ifc := FALSE; //spegni fotocellula nastro principale
                Isc := TRUE; //accendi sensore pacco prima del deviatore
                //Idc := ... ; //il sensore riceve il colore del pacco
            END_IF;
        END_IF;

        IF Qdc AND Isc THEN //IF deviatore chiuso (sta deviando) AND pacco presente prima del deviatore
            //NB: il main attualmente non cambia i valori nel vettore Qd
            Isc := FALSE; //spegni sensore pacco prima del deviatore
            Imc := TRUE; //accendi fotocellula nastromagazzino 
            IF Qtc AND elapsedtimer.Check(Imf,tStopMotor) THEN //IF nastro magazzino va avanti AND tempo passato
                Imc := FALSE; 
            END_IF; //il pacco è arrivato al magazzino 
        END_IF;


        
    END_FUNCTION 

       
END_NAMESPACE
