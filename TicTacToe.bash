
#!/bin/bash


# inicjalizacja planszy
board=("1" "2" "3" "4" "5" "6" "7" "8" "9")
is_another_round_true="T"
score_X=0
score_O=0
current_player="X"
NC='\033[0m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'

# funkcja: drukowanie planszy
print_board() {
    echo ""
    echo -e "${CYAN} ${board[0]} | ${board[1]} | ${board[2]}"
    echo "---+---+---"
    echo -e "${CYAN} ${board[3]} | ${board[4]} | ${board[5]}"
    echo "---+---+---"
    echo -e "${CYAN} ${board[6]} | ${board[7]} | ${board[8]}"
    echo -e "${NC}" 
}


# funckja: sprawdzamy zwycięzcę 
check_winner() {
    # sprawdzamy czy nie ma 3 znaków pod rząd w wierszach
    for i in 0 3 6; do
        if [[ ${board[$i]} == "$current_player" && ${board[$((i+1))]} == "$current_player" && ${board[$((i+2))]} == "$current_player" ]]; then
            return 0
        fi
    done
    
    #sprawdzamy czy nie ma 3 znaków pod rząd w kolumnach
    for i in 0 1 2; do
        if [[ ${board[$i]} == "$current_player" && ${board[$((i+3))]} == "$current_player" && ${board[$((i+6))]} == "$current_player" ]]; then
            return 0
        fi
    done

    #sprawdzamy czy nie ma 3 znaków na ukos
    if [[ ${board[0]} == "$current_player" && ${board[4]} == "$current_player" && ${board[8]} == "$current_player" ]]; then
        return 0
    fi

    if [[ ${board[2]} == "$current_player" && ${board[4]} == "$current_player" && ${board[6]} == "$current_player" ]]; then
        return 0
    fi

    return 1
}

# funkcja: sprawdzamy remis 
check_draw() {
    # iterujemy przez wszystkie komórki na planszy i sprawdzamy czy jakaś jest pusta (jest dalej liczbą 1-9)
    # jeśli tak kontynuujemy grę ; jeśli nie ogłaszamy remis
    for cell in "${board[@]}"; do
        if [[ "$cell" =~ ^[1-9]$ ]]; then
            return 1
        fi
    done
    return 0
}

# Główny game loop

while true; do
    if [[ "$is_another_round_true" == "T" ]]; then 
        print_board # drukujemy planszę 
        echo "Ruch gracza $current_player (1-9):"
        read -r move # odczytujemy ruch gracza 
    
        # sprawdzamy czy ruch jest możliwy 
        if ! [[ "$move" =~ ^[1-9]$ ]]; then
            echo "Nieprawidłowy wybór. Wybierz numer od 1 do 9."
            continue
        fi

        index=$((move - 1)) # interpretujemy ruch gracza w pozycje na planszy (1-9 do 0-8)
    
        #sprawdzamy czy pole jest zajęte 
        if [[ "${board[$index]}" == "X" || "${board[$index]}" == "O" ]]; then
            echo "To pole jest już zajęte."
            continue
        
        fi
    
    
        # aktualizujemy planszę
        board[$index]=$current_player
    
        # sprawdzamy czy ktoś wygrał lub czy jest remis 
        if check_winner; then
            print_board
            echo -e "${GREEN} Gracz $current_player zwycięża ${NC}"
            echo "Czy chcesz zagrać jeszcze raz? (T/N)"
            read -r round_check 
            is_another_round_true="$round_check"
            board=("1" "2" "3" "4" "5" "6" "7" "8" "9")
            
            if [[ $current_player == "X" ]]; then 
                score_X+=1
            else
                score_Y+=1
            fi 
            echo "Obecny Wynik:"
            echo "X: $score_X"
            echo "O: $score_O"
            echo "Dowolny klawisz by kontynuować"
            read -r proceed
        
            
            if [[ "$is_another_round_true" == "N" ]]; then
                echo "Koniec Gry!"
                break
            fi
        elif check_draw; then
            print_board
            echo "Remis!"
            read -r round_check 
            is_another_round_true = round_check
            board=("1" "2" "3" "4" "5" "6" "7" "8" "9")
            echo "Obecny Wynik:"
            echo "X: $score_X"
            echo "O: $score_O"
            echo "Dowolny klawisz by kontynuować"
            read -r proceed
            
            
            if [[ "$is_another_round_true" == "N" ]]; then
                echo "Koniec Gry!"
                break
            fi
        fi
    
        # zmieniamy gracza 
        if [[ "$current_player" == "X" ]]; then
        current_player="O"
        else
            current_player="X"
        fi
        tput reset # czyścimy konsolę 
    fi 
done

