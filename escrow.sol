// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Escrow {

    mapping (address => uint) user_balances;
    address admin;
    uint commission_percent = 1;
    // uint total_comission = 0;
    //public içerden-dışardan
    //external dışardan
    //internal içerden

    constructor(uint _commission_percent) {
        admin = msg.sender;
        commission_percent = _commission_percent;
    }

    function DepositEther() external payable {
        require(msg.value >= 1 ether);
        user_balances[msg.sender] += msg.value;
    }

    function TransferEtherWithCommission(address receiver, uint amount) external payable {
        require(msg.sender == admin);
        require(address(this).balance >= amount);
        user_balances[admin] += amount/100 * commission_percent;

        //total_comission += amount/100 * commission_percent;
        //payable(receiver).transfer(amount - amount/100 * commission_percent);
        test_transfer_internal(receiver, amount - amount/100 * commission_percent);
    }

    function test_transfer_internal(address _receiver, uint _amount) internal {
        payable(_receiver).transfer(_amount);
    }

    function TransferEtherWithoutCommission(address receiver, uint amount) external payable {
        require(msg.sender == admin);
        require(address(this).balance >= amount);
        payable(receiver).transfer(amount);
    }

    function CollectCommission() external payable {
        require(msg.sender == admin);
        payable(admin).transfer(user_balances[admin]);
        user_balances[admin] = 0;
    }

    function setAdmin(address newAdmin) external {
        require(msg.sender == admin);
        require(newAdmin != address(0));
        admin = newAdmin;
        user_balances[newAdmin] = user_balances[admin];
        user_balances[admin] = 0;
    } 

    function getCollectedCommission() external view returns(uint) {
        return user_balances[admin];
    }

    function getUserDeposit(address _user) external view returns(uint) {
        return user_balances[_user];
    }
}
