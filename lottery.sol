// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.7.0;

/**
 * @title Lottery
 * @dev Wager ether with 4 other participants
 * @author Michael Bentley (mlb222)
 * @author Evan Hruskar (ezh221)
 * @author Nicole ElChaar (nje222)
 * @author Dan Yu (ddy221)
 * 
 * The contract is deployed on the Kovan test network. 
 * A three player version is deployed at:
 * 0xcBF19E687241a96B70fd5E6Ca8a85C1399cC0A0b
 * A five player version is deployed at:
 * 0x276672ffDc991DcF62B15A181B75C7b23dB06a6a
 * 
 * We tested the three player version over the Kovan network.
 * 
 * ABI:
    [
        {
            "inputs": [],
            "name": "wager",
            "outputs": [],
            "stateMutability": "payable",
            "type": "function"
        }
    ]
 */
contract Lottery {

    uint players = 5; //TODO: Change to 5!

    // Need to make sure this is the same as players. 
    address payable[5] participants;

    uint total_amount = 0;

    uint current_participant_count = 0;

    function wager() payable public {
      uint wager_size = msg.value;
      require(wager_size >= 0.01 ether, "Wager amount must be at least 0.01 ether");
      total_amount += wager_size;
      participants[current_participant_count] = msg.sender;
      current_participant_count++;
      if (current_participant_count == players) {
        // Declare victor
        uint winner = random() % players;
        participants[winner].transfer(total_amount);
        current_participant_count = 0;
        total_amount = 0;
        // No need to zero out participants since those will be overwritten. 
      }
    }
    
    // Returns a random number. 
    function random () private view returns(uint) {
      return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
}