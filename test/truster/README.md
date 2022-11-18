## `TrusterLenderPool` can call any function from any contract which is dangereous for ERC20 inside the contract. 

**Severity** : High

**Context** : [TrusterLenderPool.sol#L36](https://github.com/jraynaldi3/damn-vulnerable-defi-solution/blob/3f0888d3b14117f4c156820a3a5fda368defa20b/contracts/truster/TrusterLenderPool.sol#L36)

`TrusterLenderPool` can call any function from any contract, ERC20 contract have an function called `approve` which is allow `approved` address to transfer certain amount ERC20 token from the address that `approve`. In this case `TrusterLenderPool` can make anyone to call DVT token contract and approve it for theirself, so `TrusterLenderPool` will approve the attacker, then after that the attacker can transfer DVT from `TrusterLenderPool` to their wallet. 

**Recommendation**:
Flash loan contract should determine which function will be called inside the borrower contract instead of the borrower who set which function is called in which contract. 
example :
```js
    IReceiver(borrower).executeFlashLoan();
```
