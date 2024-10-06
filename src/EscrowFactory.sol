// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
import {Escrow} from "./Escrow.sol";
contract EscrowFactory
{
    Escrow[] escrows;
    event EscrowCreated(address escrowAddress);
    error InvalidEscrowIndex();
    function createEscrow(address payer, address payee, address escrowAgent) public
    {
        Escrow newEscrowContract = new Escrow(payer, payee, escrowAgent);
        escrows.push(newEscrowContract);
        emit EscrowCreated(address(newEscrowContract));
    }
    function getEscrowsCount() public view returns (uint256)
    {
        return escrows.length;
    }
    function getEscrow(uint256 index) external view returns (address)
    {
        require(escrows.length > index, InvalidEscrowIndex());
        return address(escrows[index]);
    }
}
