/* Battleships_Base
 * Author: induranga kawishwara 
 * ID : 20200688 / w1913278
 */
  
MACHINE Battleships_Main
SEES
    Battleships_Base

VARIABLES
    player1Ships, player2Ships, currentTurn, gameStatus, player1shots, player2shots

INVARIANT
    player1Ships <: GRID_POSITION &
    player2Ships <: GRID_POSITION &
    card(player1Ships) <= MAX_SHIPS &
    card(player2Ships) <= MAX_SHIPS &
   // player1Ships /\ player2Ships = {} &
    currentTurn : PLAYER &
    gameStatus : STATUS &
    player1shots : NAT &
    player2shots : NAT 

INITIALISATION
    player1Ships := {} ||
    player2Ships := {} ||
    currentTurn := Player1 ||
    gameStatus := deployPending ||
    player1shots := 0 ||
    player2shots := 0 

OPERATIONS
    // Deploy the fleet for a player
    report <-- deployFleet(player, positions) =
    PRE
        gameStatus = deployPending &
        player : PLAYER &
        positions <: GRID_POSITION &
        card(positions) = MAX_SHIPS &
        ((player = Player1 => player1Ships = {}) &
         (player = Player2 => player2Ships = {}))
    THEN
        IF player = Player1 THEN
            player1Ships := positions
        ELSE
            player2Ships := positions ||
            gameStatus := ongoing
        END ||
        report := FleetDeployed
    END;

    // Player shoots at a target
    report <-- playerShoots(target) =
    PRE
        target : GRID_POSITION &
        gameStatus = ongoing 
        
    THEN
        IF currentTurn = Player1 THEN
            IF target : player2Ships THEN
                player2Ships := player2Ships - {target} ||
                player1shots := player1shots + 1 ||
                report := hit ||
                IF player2Ships - {target} = {} THEN
                    gameStatus := player1Win
                ELSE
                    currentTurn := Player2
                END
            ELSE
                report := miss ||
                currentTurn := Player2
            END
        ELSE  // Player2's turn
            IF target : player1Ships THEN
                player1Ships := player1Ships - {target} ||
                player2shots := player2shots + 1 ||
                report := hit ||
                IF  player1Ships - {target} = {} THEN
                    gameStatus := player2Win
                ELSE
                    currentTurn := Player1
                END
            ELSE
                report := miss ||
                currentTurn := Player1
            END
        END
    END;

    // Get the ship locations of a player
    shipsquares <-- shipLocations(player) =
    PRE
        player : PLAYER
    THEN
        IF player = Player1 THEN
            shipsquares := player1Ships
        ELSE
            shipsquares := player2Ships
        END
    END;

    // Return the number of ships left for each player
    shipCounts <-- shipsLeft =
    BEGIN
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
