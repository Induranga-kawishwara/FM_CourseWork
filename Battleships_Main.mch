
/* Battleships_Main
 * Author: Induranga Kawishwara 
 * ID : 20200688 / w1913278
 */

MACHINE Battleships_Main

// Include the Battleships_Base machine to access constants and sets
SEES
    Battleships_Base

// Declare the variables used in the game
VARIABLES
    player1Ships, player2Ships, currentTurn, gameStatus, player1shots, player2shots , hitCellsPlayer1 ,hitCellsPlayer2, missCellsPlayer1 , missCellsPlayer2

// Invariant ensures that the variables follow the rules of the game
INVARIANT
    player1Ships <: GRID_POSITION &
    player2Ships <: GRID_POSITION &
    card(player1Ships) <= MAX_SHIPS &
    card(player2Ships) <= MAX_SHIPS &
    currentTurn : PLAYER &
    gameStatus : STATUS &
    player1shots : NAT &
    player2shots : NAT &
    hitCellsPlayer1 <: GRID_POSITION &
    hitCellsPlayer2 <: GRID_POSITION &
    missCellsPlayer1 <: GRID_POSITION &
    missCellsPlayer2 <: GRID_POSITION 


// Initialisation defines the initial state of the game
INITIALISATION
    player1Ships := {} ||
    player2Ships := {} ||
    currentTurn := Player1 ||
    gameStatus := deployPending ||
    player1shots := 0 ||
    player2shots := 0 ||
    hitCellsPlayer1 := {}||
    hitCellsPlayer2 := {}||
    missCellsPlayer1 := {}||
    missCellsPlayer2 := {}

DEFINITIONS


    // Define animation functions for visualizing the grid, ships, hits, and misses

ANIMATION_FUNCTION ==
    ({ row, col, img | col : 1..10 & row : 1..10 & img = 0 & 
        (col, 11 - row) : GRID_POSITION }) // Base grid for Player 1
    \/   ({ row, col, img | col : 11..11 & row : 1..10 & img = 2 & 
        (col -10, 11 - row) : GRID_POSITION }) 
    \/
    ({ row, col, img | col : 12..21 & row : 1..10 & img = 1 & 
        (col - 11, 11 - row) : GRID_POSITION }) ;// Base grid for Player 2

    ANIMATION_FUNCTION1 ==
        ({ row, col, img | col : 1..10 & row : 1..10 & img = 3 & 
            (col, 11 - row) : player1Ships });

    ANIMATION_FUNCTION2 ==
        ({ row, col, img | col : 12..21 & row : 1..10 & img = 4 & 
            (col - 11, 11 - row)  : player2Ships });

    ANIMATION_FUNCTION4 ==
        ({ row, col, img | col : 1..10 & row : 1..10 & img = 6 & 
            (col, 11 - row) : hitCellsPlayer2 });

   ANIMATION_FUNCTION5 ==
        ({ row, col, img | col : 12..21 & row : 1..10 & img = 6 & 
            (col-11, 11 - row) : hitCellsPlayer1 });

    ANIMATION_FUNCTION6 ==
        ({ row, col, img | col : 1..10 & row : 1..10 & img = 5 & 
            (col , 11 - row) :  missCellsPlayer2 });

    ANIMATION_FUNCTION7 ==
        ({ row, col, img | col : 12..21 & row : 1..10 & img = 5 & 
            (col-11 , 11 - row) :  missCellsPlayer1 });


    // Images for the grid and elements
    ANIMATION_IMG0 == "Images/squarBlue.png";
    ANIMATION_IMG1 == "Images/squarOrange.png";
    ANIMATION_IMG2 == "Images/squarWhite.png";
    ANIMATION_IMG3 == "Images/player1Ship.png";
    ANIMATION_IMG4 == "Images/player2Ship.png";
    ANIMATION_IMG5 == "Images/lostTarget.png";
    ANIMATION_IMG6 == "Images/win.png";

OPERATIONS
     // Deploy the fleet for a player
    report <-- deployFleet(player, positions) =
    PRE
        // The game must be in the deployPending state
        gameStatus = deployPending &
         // Validate that the player is either Player1 or Player2
        player : PLAYER &
        // The positions must be valid grid positions
        positions <: GRID_POSITION &
        // Ensure the player is deploying exactly MAX_SHIPS ships
        card(positions) = MAX_SHIPS &
        // Ensure the player has not already deployed their fleet
        ((player = Player1 => player1Ships = {}) &
         (player = Player2 => player2Ships = {}))
    THEN
        // Deploy the fleet for the specified player
        IF player = Player1 THEN
            player1Ships := positions
        ELSE
            player2Ships := positions ||
             // Change game status to ongoing once both fleets are deployed
            gameStatus := ongoing
        END ||
        // Return the report that the fleet has been deployed
        report := FleetDeployed
    END;

    // Player shoots at a target
    report <-- playerShoots(target) =
    PRE
        // The target must be a valid grid position
        target : GRID_POSITION &
        // The game must be ongoing
        gameStatus = ongoing  
        
    THEN
        // If it is Player1's turn
        IF currentTurn = Player1 THEN
            // If the shot hits Player2's fleet
            IF target : player2Ships &  target  /:    hitCellsPlayer1 \/ missCellsPlayer1 THEN
                player2Ships := player2Ships - {target} ||// Remove the ship from Player2's fleet
                player1shots := player1shots + 1 || // Increment Player1's shot count
                report := hit ||// Report the hit
                hitCellsPlayer1 := hitCellsPlayer1 \/ {target} ||
                // If Player2 has no ships left, Player1 wins
                IF player2Ships - {target} = {} THEN
                    gameStatus := player1Win
                ELSE
                    // Switch the turn to Player2
                    currentTurn := Player2
                END
            ELSE
                // If the shot misses
                report := miss ||
                missCellsPlayer1  := missCellsPlayer1 \/ {target} ||
                currentTurn := Player2
            END
        ELSE  // Player2's turn
            // If the shot hits Player1's fleet
            IF target : player1Ships &  target  /: hitCellsPlayer2 \/ missCellsPlayer2 THEN
                player1Ships := player1Ships - {target} ||
                player2shots := player2shots + 1 ||
                report := hit ||
                hitCellsPlayer2 := hitCellsPlayer2 \/ {target} ||
                IF  player1Ships - {target} = {} THEN
                    gameStatus := player2Win
                ELSE
                    currentTurn := Player1
                END
            ELSE
                report := miss ||
                missCellsPlayer2  := missCellsPlayer2 \/ {target} ||
                currentTurn := Player1
            END
        END
    END;

    // Get the ship locations of a player
    shipsquares <-- shipLocations(player) =
    PRE
        player : PLAYER
    THEN
         // If the player is Player1, return their ship locations
        IF player = Player1 THEN
            shipsquares := player1Ships
        ELSE
            // If the player is Player2, return their ship locations
            shipsquares := player2Ships
        END
    END;

    // Return the number of ships left for each player
    shipCounts <-- shipsLeft =
    BEGIN
        // Return the number of ships left for each player.
        shipCounts := (card(player1Ships), card(player2Ships))
    END;

    // Return the number of hits taken by each player
    hitCount <-- shotsTaken(player) =
    PRE
        player : PLAYER
    THEN
        IF player = Player1 THEN
            hitCount := player1shots
        ELSE
            hitCount := player2shots
        END
    END;

    // Return the current game status
    statusReport <-- gameStatusReport =
    BEGIN
        statusReport := gameStatus
    END
END
