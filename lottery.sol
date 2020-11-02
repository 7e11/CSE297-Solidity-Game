// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.7.0;

/**
 * @title Lottery
 * @dev Wager ether with 4 other participants
 */
contract Lottery {

    uint players = 3;

    // Need to make sure this is the same as players. 
    address payable[3] participants;

    uint total_amount = 0;

    uint current_participant_count = 0;

    // constructor(uint _players) public {
    //   players = _players;
    // }


    function wager() payable public {
      uint wager_size = msg.value;
      require(wager_size >= 0.01 ether, "Wager size must be >= to 0.01 ether");
      total_amount += wager_size;
      participants[current_participant_count] = msg.sender;
      current_participant_count++;
      if (current_participant_count == players) {
        // Declare victor
        uint winner = random();
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