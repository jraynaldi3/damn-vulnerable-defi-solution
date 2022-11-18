## The contract can be freeze permanently by outsider
**Severity**: High
Context: [UnstoppableLender.sol#L40](https://github.com/jraynaldi3/damn-vulnerable-defi-solution/blob/a217de5d255b1b754ab1a59044e010e77b5c19f6/contracts/unstoppable/UnstoppableLender.sol#L40)
The `UnstoppableLender` contract want to make sure the contract only receive ERC20 from `depositTokens` function with this code below:
```js
        // Ensured by the protocol via the `depositTokens` function
        assert(poolBalance == balanceBefore);
```
in contrast with ETH (Native token) which is trigger the `receive` function while contract receive ETH, ERC20 normally don't trigger any function while transfered. Any account that have DVT token can freeze the contract by making that check above always return false by simply transfer DVT token without using `depositTokens` function from the contract.

**Recommendation**: there's 3 kind of recommendation that i can give for this contract, you can choose one of them, that is:
1. remove the assertion to check `poolBalance == balanceBefore` and use only poolBalance that updated every `depositTokens` called. 
2. Instead of compare `poolBalance` with `balanceBefore` we can make `poolBalance = balanceBefore`
3. make a function to take the leftover ERC20 to make `poolBalance == balanceBefore` can return true again. 