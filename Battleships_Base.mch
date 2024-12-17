/* Battleships_Base
 * Author: Induranga Kawishwara
 * ID : 20200688 / w1913278
 */
 
MACHINE Battleships_Base
    
SETS
    PLAYER = {Player1, Player2};
    STATUS = {deployPending, ongoing, player1Win, player2Win,resetSuccess};
    RESULT = {hit, miss, FleetDeployed , AlreadyUsed}

CONSTANTS
    MAX_SHIPS, GRID_POSITION

PROPERTIES
    MAX_SHIPS = 3 &
    GRID_POSITION = (1..10) * (1..10) 

END