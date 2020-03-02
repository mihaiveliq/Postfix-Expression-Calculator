# Postfix-Expression-Calculator

        Prezentarea implementarii:
    
        -Codul transforma sirul primit din input folosindu-se de codul ASCII
    pentru a converti caracterele in cifre, si de functia cmp pentru a determina
    tipul operatiilor, spatiile, terminatorul de sir sau semnul unui numar. 
    Fiecare caracter al sirului este stocat prin functia lodsb in reagistrul al,
    fiind gestionat in functie de ce reprezinta.
    
       -Daca reprezinta o cifra, acesta este convertit in cifra respectiva
    prin scaderea cu 48 si se salveaza in eax. De fiecare data cifra se inmulteste
    cu valoarea din ecx, care este fie 1, daca numarul din care cifra face parte
    este pozitiv, fie -1 daca este negativ. Registrul este setat la -1 cand se 
    intalneste caracterul minus iaintea primei cifre dintr-un numar, si se 
    reseteaza la 1 cand se intalneste un spatiu. Prima cifra care se intalneste
    dupa un spatiu sau dupa un minus este urcata pe stiva. Pana la intalnirea unui
    spatiu, pentru a completa numarul cu o noua cifra, se coboara de pe stiva 
    numarul urcat precedent, se inmulteste cu 10, i se adauga noua cifra si se
    urca la loc. O problema apare la verificarea primului caracter din sir, atunci
    cand nu este negativ si nu exista un minus sau un spatiu pe prima pozitie din
    sir, fata de care sa determinam inceputul numarului. De aceea la inceputul
    programului am urcat pe stiva un 0, pentru a prelucra prima cifra ca fiind a
    doua dintr-un numar care incepe cu 0. Cand primul numar este negativ nu avem
    aceasta problema datorita minusului, dar trebuie sa dam un pop suplimentar la
    final pentru a indeparta zeroul pe care nu il folosim.
    
        -La intalnirea operatiilor de adunare, scadere, inmultire si impartire,
    se scot de pe stiva ultimele 2 numere si se executa operatia. Rezultatul este
    urcat inapoi pe stiva. O problema apare atunci cand caracterul minus se afla
    la finalul sirului, atunci cand testam in functie de pozitionarea fata de 
    spatiu daca minusul determina o operatie sau semnul urmator, nefiind 
    succedat nici de un spatiu nici de un numar, programul percepand totusi ca
    determina semnul unui numar, cand de fapt determina o operatie. De aceea se 
    efectueaza o comparatie suplimentara pentru a determina daca se afla la
    sfarsitul sirului, in caz afirmativ conferindu-i intrebuintarea corecta.
    
        -La intalnirea spatiului, doar se reseteaza registrul ecx la 1.
    
        -La intalnirea terminatorului de sir, se sare la labelul final, unde se
    coboara de pe stiva rezultatul final si se afiseaza. Daca este cazul se
    coboara si zeroul urcat la inceput.
