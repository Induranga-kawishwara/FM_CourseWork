/* Battleships_Base
 * Author: induranga kawishwara 
 * ID : 20200688 / w1913278
 */
 
// Machine that defines the base structure and constants for the Battleships game.
MACHINE Battleships_Base
    
// Define the sets that represent the possible players, game statuses, and results.
SETS
    // PLAYER set includes the two players in the game, Player1 and Player2.
    PLAYER = {Player1, Player2};
    // STATUS set defines the possible states of the game:
    STATUS = {deployPending,ongoing, player1Win, player2Win};
    // RESULT set defines the possible outcomes of a shot:
    RESULT = {hit, miss, FleetDeployed}

CONSTANTS
        // MAX_SHIPS defines the number of ships a player can have.
    MAX_SHIPS, 
    
        // GRID_POSITION defines the grid siz.
    GRID_POSITION

PROPERTIES
     // Define the maximum number of ships each player can have
    MAX_SHIPS = 3 &
    
    // Define the grid size as a 10x10 grid with positions represented as pairs (x, y),    
    GRID_POSITION = (1..10) * (1..10) 

END
