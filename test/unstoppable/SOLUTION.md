## Problem 
```flashLoan()``` on  ```UnstoppableLender.sol``` contain an assertion that require ```balanceBefore``` which is DVT token balance of the contract and ```poolBalance``` which is only updated when ```depositTokens()``` used to deposit DVT token to contract.
```sol
    // Ensured by the protocol via the `depositTokens` function
    assert(poolBalance == balanceBefore);
```
the problem is theres other way to transfer ERC20 token to the smartcontract that make the ```poolBalance``` doesn't increasing. that is ```transfer()``` or ```transferFrom``` from ERC20 standart.

## Solution 

simple transfer DVT token to smart contract without calling ```depositTokens()```. 