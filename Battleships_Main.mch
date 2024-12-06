MACHINE Battleships_Main
SEES
    Battleships_Base

VARIABLES
    player1Ships, player2Ships, currentTurn, gameStatus, player1Hits, player2Hits

INVARIANT
    player1Ships <: GRID_POSITION &
    player2Ships <: GRID_POSITION &
    card(player1Ships) <= MAX_SHIPS &
    card(player2Ships) <= MAX_SHIPS &
    player1Ships /\ player2Ships = {} &
    currentTurn : PLAYER &
    gameStatus : STATUS &
    player1Hits : NAT &
    player2Hits : NAT 

INITIALISATION
    player1Ships := {} ||
    player2Ships := {} ||
    currentTurn := Player1 ||
    gameStatus := ongoing ||
    player1Hits := 0 ||
    player2Hits := 0 

OPERATIONS
    // Deploy the fleet for a player
    report <-- deployFleet(player, positions) =
    PRE
        gameStatus = ongoing &
        player : PLAYER &
        positions <: GRID_POSITION &
        card(positions) = MAX_SHIPS &
        ((player = Player1 => player1Ships = {}) &
         (player = Player2 => player2Ships = {}))
    THEN
        IF player = Player1 THEN
            player1Ships := positions
        ELSE
            player2Ships := positions
        END ||
        report := FleetDeployed
    END;

    // Player shoots at a target
    report <-- playerShoots(target) =
    PRE
        target : GRID_POSITION &
        gameStatus = ongoing &
        player1Ships /= {} &
        player2Ships /= {}
    THEN
        IF currentTurn = Player1 THEN
            IF target : player2Ships THEN
                player2Ships := player2Ships - {target} ||
                player1Hits := player1Hits + 1 ||
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
                player2Hits := player2Hits + 1 ||
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
            hitCount := player1Hits
        ELSE
            hitCount := player2Hits
        END
    END;

    // Return the current game status
    statusReport <-- gameStatusReport =
    BEGIN
        statusReport := gameStatus
    END
END
