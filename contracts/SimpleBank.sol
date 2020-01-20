pragma solidity ^0.5.0;

contract SimpleBank {

    //
    // State variables
    //
    
    mapping (address => uint) private balances;
    
    mapping (address => bool) public enrolled;

    address payable public owner;
    
    //
    // Events - publicize actions to external listeners
    //
    
    event LogEnrolled(address payable accountAddress);

    event LogDepositMade(address payable accountAddress, uint amount);

   event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    //
    // Functions
    //

    constructor() public {
        owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    function() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool){
        if(enrolled[msg.sender] == false){
            enrolled[msg.sender] = true;
            emit LogEnrolled(owner);
            return true;
        } else {
            return false;
        }
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
          require(enrolled[msg.sender] == true);
          balances[msg.sender] = balances[msg.sender] + msg.value;
          emit LogDepositMade(msg.sender, balances[msg.sender]);
          return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user    
    function withdraw(uint withdrawAmount) public payable returns (uint) {
           require(balances[msg.sender] >= withdrawAmount, "does not have enough balance to complete transaction");
           uint newBalance;
           address accountAddress = msg.sender;
            newBalance = balances[accountAddress] - withdrawAmount;
            balances[accountAddress] = newBalance;
            msg.sender.transfer(withdrawAmount);
            emit LogWithdrawal(accountAddress, withdrawAmount, newBalance);
            return newBalance;
    }

}
