## `FlashLoanReceiver.sol` fund can be drained to a flashloan by anyone. 

**Severity**: High 

**Context**: [FlashLoanReceiver::receiveEther](https://github.com/jraynaldi3/damn-vulnerable-defi-solution/blob/7682ec953218c857049a76c278508559b6afb94e/contracts/naive-receiver/FlashLoanReceiver.sol#L21-L32)

`FlashLoanReceiver` contract allow anybody to operate the flashloan from "NaiveReceiverLenderPool" contract which is charge for 1 ETH fee for everytime `flashloan` function in "NaiveReceiverLenderPool" contract called. Anyone can use `flashloan` function and pass the `FlashLoanReceiver` contract as `borrower`, everytime the `flashloan` called `FlashLoanReceiver` will pay 1 ETH to flash loan contract until the fund in `FlashLoanReceiver` drained compeletely.

**Recomendation**: 
1. `FlashLoanReceiver` can set some whitelisted address that can be the operator of flashloan and check it while `receiveEther` called, add this code to check the operator `require(tx.origin == operator)`.
2. we can make `FlashLoanReceiver` to transfer ETH inside it everytime `flashloan` called, so the contract will not have a leftover ETH, every profit that the contract make from flashloan can be transfered to treasury address instead.