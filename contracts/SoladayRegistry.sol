// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <=0.8.11;

import "./SoladayContract.sol";
import "./SoladayToken.sol";

// @transmissions11 custom errors vs require() messages, save some gas
error noReentracy();
error invalidAddress();

/**
 * @title SoladayRegistry
 * @dev contract to track deployers and deployments
 * @author kethcode (https://github.com/kethcode)
 */
contract SoladayRegistry is SoladayContract {

    /*********
    * Events *
    **********/

    /**     * Announce Registry Deployment 
     * @param _contract Address of deployed Contract
     * @param _tokenContract Address of token contract used to issue rewards
     */
    event SoladayRegistryDeployed(
        address indexed _contract,
        address indexed _tokenContract
    );

    /**     * Announce a general Registration
     * @param _contract Address of deployed Contract
     * @param _deployer Address of account that deployed the Contract
     */
    event SoladayContractRegistered(
        address indexed _contract,
        address indexed _deployer
    );

    /************
    * Variables *
    *************/
    
    address[] deployers;
    mapping( address => address[] ) deployments;
    bool private locked;
    address private tokenContract;

    /*******************
    * Public Functions *
    ********************/

    modifier validAddress(address _addr) {
        if(_addr == address(0)) revert invalidAddress();
        _;
    }

    modifier noReentrancy() {
        if(locked) revert noReentracy();

        locked = true;
        _;
        locked = false;
    }

    constructor(address _tokenContract) validAddress(_tokenContract)
    {
        tokenContract =  _tokenContract;
        emit SoladayRegistryDeployed(address(this), tokenContract);
    }

    function getDeployers() public view returns (address[] memory) {
        return deployers;
    }

    function getDeployments(address _deployer) public view returns (address[] memory) {
        return deployments[_deployer];
    }

    function registerDeployment(address _contract, address _deployer) public noReentrancy validAddress(_contract) validAddress(_deployer)
    {
        // find deployer
        // TODO:    redundant and a waste of storage. extract this data from emitted events.
        //          being overly cautious, expect I'll need to migrate this data

        bool hasDeployed = false;
        for(uint256 i = 0; i < deployers.length; i++)
        {
            if(_deployer == deployers[i])
            {
                hasDeployed = true;
            }
        }

        if(!hasDeployed)
        {
            deployers.push(_deployer);
        }

        // check for dups
        bool duplicateFound = false;
        for(uint256 i = 0; i < deployments[_deployer].length; i++)
        {
            if(deployments[_deployer][i] == _contract)
            {
                duplicateFound = true;
            }
        }

        // no dup, log it
        if(!duplicateFound)
        {
            deployments[_deployer].push(_contract);
            
            SoladayToken token = SoladayToken(tokenContract);
            token.mint(_deployer, 1e18);

            emit SoladayContractRegistered(
                _contract,
                _deployer
            );
        }
    }

    // noticed both transmissions11 and m1guelpf use ERC165 interface declarations
    // seems like a good idea to follow suit
    // function supportsInterface(bytes4 interfaceId)
    //     public
    //     pure
    //     override(LilOwnable, ERC20)
    //     returns (bool)
    // {
    //     return
    //         interfaceId == 0x7f5828d0 || // ERC165 Interface ID for ERC173
    //         interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC20
    //         interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC165
    // }
}
