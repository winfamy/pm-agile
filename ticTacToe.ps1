### --- Tic-Tac-Toe Game --- ###

<#
    1st Lt Banks, Tristan
    1st Lt Scheibner, Katie
    2d Lt Nicks, Nat
    2d Lt Van Dyke, Dan
#>



# --------------------- Script Variables ------------------------------- # 


<#  $gameBoard is an array (length=9) that represents the 
    tic-tac-toe board. Each index (0-8) represents a square
    on the board. Square number = array index + 1:

     1 | 2 | 3 
    -----------
     4 | 5 | 6 
    -----------
     7 | 8 | 9
    
#>

# initialize the gameBoard with numbers to help user ID spaces
$gameBoard = "1","2","3","4","5","6","7","8","9"

# 0 = Player X's turn ($markers[0])
# 1 = Player O's turn ($markers[1])
$currentUser = 0
$markers = "X" , "O"


# ------------------------- Functions ---------------------------------- # 

function gameOver {
    # Evaluates whether the game is over by checking if any 
    # rows, cols, or diagonals contain three matching squares
    
    switch ($over) {

        # checks top row and left col
        { ($gameBoard[0] -ne " " ) -and`    # This checks that the row/col is not blank (3 blanks would trigger false win)
         ((($gameBoard[0] -eq $gameBoard[1]) -and`
          ($gameBoard[1] -eq $gameBoard[2])) -or`
         (($gameBoard[0] -eq $gameBoard[3]) -and`
         ($gameBoard[3] -eq $gameBoard[6])))}{ $over = $true ; break}

        # checks middle col
        { ($gameBoard[1] -ne " " ) -and`
          ($gameBoard[1] -eq $gameBoard[4]) -and`
          ($gameBoard[4] -eq $gameBoard[7])} { $over = $true ; break}

        #checks right col
        { ($gameBoard[2] -ne " " ) -and`
          ($gameBoard[2] -eq $gameBoard[5]) -and`
          ($gameBoard[5] -eq $gameBoard[8])} { $over = $true ; break}

        # checks middle row
        { ($gameBoard[3] -ne " " ) -and`
          ($gameBoard[3] -eq $gameBoard[4]) -and`
          ($gameBoard[4] -eq $gameBoard[5])} { $over = $true ; break}
        
        # checks bottom row
        { ($gameBoard[6] -ne " " ) -and`
          ($gameBoard[6] -eq $gameBoard[7]) -and`
          ($gameBoard[7] -eq $gameBoard[8])} { $over = $true ; break}

        # checks left-right diagonal
        { ($gameBoard[0] -ne " " ) -and`
          ($gameBoard[0] -eq $gameBoard[4]) -and`
          ($gameBoard[4] -eq $gameBoard[8])} { $over = $true ; break}
        
        # checks right-left diagonal
        { ($gameBoard[2] -ne " " ) -and`
          ($gameBoard[2] -eq $gameBoard[4]) -and`
          ($gameBoard[4] -eq $gameBoard[6])} { $over = $true ; break}

        Default {$over = $false} # if no win conditions are met, game is not over
    }

    return $over # return the value of $over to the playGame function

}

function squareTaken ($square) {
    # Checks if a square is already taken when a player is making a move
    # parameter $square contains the index of the gameBoard square that
    # the current player has selected

    $taken = $false # start by assuming the square is not taken

    # if the the square isn't X or O, then it isn't taken yet
    if ($gameBoard[$square] -eq "X" -or $gameBoard[$square] -eq "O"){

        $taken = $true # toggle the value of $taken from false->true

    }

    return $taken # return the value of $taken to the playTurn function

}


function generateRow ($row) {
    # Produces a string representing the current ascii row being drawn via 
    # in the drawBoard function. The parameter $row is an integer (0-11) 
    # indicating the current ascii row. Note: every $gameBoard row consists of
    # three ascii rows ( star/space/marker combinations)

    $startIndex = 0 # refers to starting index of the $gameBoard array. Assume we
                    # are starting from index 0 of $gameBoard and therefore drawing
                    # ascii rows 0-2 

    # if we are drawing rows 9-11 of the ascii matrix, we need to know the
    # values of $gameBoard indices 6-8
    if ($row -gt 8){

        $startIndex = 6
    
      # otherwise, if drawing ascii rows 5-7,  need to know gameBoard indices 3-5
    } elseif ($row -gt 4) {

        $startIndex = 3

    }

    $rowString = ""  # create a blank string

    # build the row string  
    for ($i=0; $i -lt 3; $i++){

        # draw two spaces and append the appropriate space/marker stored in $gameBoard 
        if ($gameBoard[$startIndex+$i] -eq "X") {
            Write-host ("  " + $gameBoard[$startIndex+$i]) -ForegroundColor Green -NoNewLine  
        } elseif ($gameBoard[$startIndex+$i] -eq "O") {
            Write-host ("  " + $gameBoard[$startIndex+$i]) -ForegroundColor Red -NoNewLine  
        } else {
            Write-host ("  " + $gameBoard[$startIndex+$i]) -ForegroundColor White -NoNewLine  
        }

        # Draw vertical star dividers only after first two markers in row
        if ($i -ne 2){
            Write-host ("  *") -ForegroundColor Cyan -NoNewLine
        }

    }

    return $rowString # send the rowString to drawBoard to be printed to output

}

function playGame {

    # Controls the flow of the game  

    $gameOver = $false # start by assuming game is not over
    $numTurns = 0

    # Repeat this loop until the game ends
    while (!$gameOver){

        drawBoard # draw the game board

        playTurn # Player takes turn: get input & update board
        
        $numTurns += 1 # increment number of turns by 1

        drawBoard # redraw the board

        $gameOver = gameOver # check if a user has won

        # Print winning message if the current player has just won
        if ($gameOver) {
            
            Start-Job -ScriptBlock { bash -c "afplay ./win.wav" } | Out-Null
            Start-Job -ScriptBlock { bash -c "say 'Merry Christmas!'" } | Out-Null
            Write-HostCenter ("Congratulations! Player " + $markers[$currentUser] + " has won!") -ForegroundColor Green
            Write-HostCenter ("Merry Christmas!") -ForegroundColor Red
            Write-HostCenter "       /\       "
            Write-HostCenter "      /  \      "
            Write-HostCenter "     /    \     "
            Write-HostCenter "    /      \    "
            Write-HostCenter "   /        \   "
            Write-HostCenter "  /          \  "
            Write-HostCenter " /            \ "
            Write-HostCenter "/______________\"
            Write-HostCenter "       ||       "

            
            
        }elseif ($numTurns -ge 9){
            $gameOver = $true
            "The game has  ended in a tie!"
        }

        # Switch to the next player's turn
        if ($currentUser -eq 0){
            $currentUser = 1
        }else {
            $currentUser = 0
        }

    }
    
}


function playTurn {
    # this function walks through a player's turn

    $validInput = $false 

    # repeat this loop until the player makes a valid input
    while (!$validInput){

        # Get user input
        [int]$square = Read-Host "Where would you like to place your move?"

        # checks to make sure player entered an int 1-9
        if ( ($square -ge 1) -and ($square -le 9) ){

            $square -= 1 # adjust 1-9 board numbering to 0-8 $gameBoard array indices

            # checks whether the square the player just selected is already taken 
            if (! (squareTaken $square) ) {
                $validInput = $true
            }else{
                "That square is already taken"
            }
        
        # writes an error if the player entered an invalid square number
        }else{
            "Please enter a valid integer, 1-9"
        }

    }

    # once a valid selection has been made, update the corresponding index $gameBoard array
    $gameBoard[$square] = $markers[$currentUser]
    Start-Job -ScriptBlock { bash -c "afplay ./open.mp3" } | Out-Null
}

function drawBoard {
    # prints the gameBoard to the terminal for players to see

    cls # clear screen

    # Print game instructions above board
    "Note: Squares are numbered 1-9, left-to-right & top-to-bottom. Please"
    "      input the number of the square you would like to claim."
    Write-Host
    Write-Host
    "Current User: " + $markers[$currentUser] # show whose turn it is
    Write-Host
    Write-Host

    # draw space/stars/markers to create gameBoard 
    for ($i=1; $i -lt 12; $i += 1){
    
        # every fourth row is a horizontal divider row 
        if ($i % 4 -eq 0){
    
            Write-Host ("*" * 18)  -ForegroundColor Cyan
           
        # rows 2, 6, 10 contain X/O markers
        }elseif ($i%2 -eq 0){     
    
            generateRow $i
        
        # all other rows are the same space/star pattern
        }else { 
            Write-Host ("     *" * 2)  -ForegroundColor Cyan
        }
        
    }

}

function playSound ($wav) {
    Start-Job -ScriptBlock { bash -c "afplay $wav" } | Out-Null
}

function Write-HostCenter { param($Message) Write-Host ("{0}{1}" -f (' ' * (([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Floor($Message.Length / 2)))), $Message) }

# ------------------------- Start Game ---------------------------------- # 
clear
" _  _  _       _                                         _______ _       
(_)(_)(_)     | |                            _          (_______|_)      
 _  _  _ _____| | ____ ___  ____  _____    _| |_ ___        _    _  ____ 
| || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \      | |  | |/ ___)
| || || | ____| ( (__| |_| | | | | ____|    | || |_| |     | |  | ( (___ 
 \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/      |_|  |_|\____)
                                                                         
          _______                      _______          
         (_______)                    (_______)         
 _____       _ _____  ____    _____       _  ___  _____ 
(_____)     | (____ |/ ___)  (_____)     | |/ _ \| ___ |
            | / ___ ( (___               | | |_| | ____|
            |_\_____|\____)              |_|\___/|_____)"
"


"

#Wait until ready to begin

read-host “Press ENTER to continue...”

playGame # start the game by calling the playGame function

