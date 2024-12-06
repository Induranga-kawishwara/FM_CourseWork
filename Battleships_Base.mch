MACHINE Battleships_Base
SETS
    PLAYER = {Player1, Player2};
    STATUS = {ongoing, player1Win, player2Win};
    RESULT = {hit, miss, FleetDeployed}

CONSTANTS
    MAX_SHIPS, GRID_POSITION

PROPERTIES
    MAX_SHIPS = 3 &
    GRID_POSITION = (1..2) * (1..2)  // Adjust to 10x10 for coursework requirement

END
