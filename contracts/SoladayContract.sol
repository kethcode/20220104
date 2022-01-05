// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <=0.8.11;

/**
 * @title SoladayContract
 * @dev Contract for announcing deployments
 * @author kethcode (https://github.com/kethcode)
 */
contract SoladayContract {

    /*********
    * Events *
    **********/
    
    /**     * Announce a Deployment
     * @param _contract Address of deployed Contract
     * @param _deployer Address of account that deployed the Contract
     * @param _timestamp Timestamp of current block of deployment, 
     */
    event SoladayContractDeployed(
        address indexed _contract,
        address indexed _deployer, 
        uint256 _timestamp
    );

    /************
    * Variables *
    *************/

    /*******************
    * Public Functions *
    ********************/

    constructor() {
        emit SoladayContractDeployed ( 
            address(this),
            msg.sender,
            block.timestamp
        );
    }
}