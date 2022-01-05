// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <=0.8.11;

import "@rari-capital/solmate/src/tokens/ERC20.sol";

/**
 * @title SoladayToken
 * @dev Contract for announcing deployments
 * @author kethcode (https://github.com/kethcode)
 */
contract SoladayToken is ERC20 {

    /*********
    * Events *
    **********/

    /**     * Announce Token Deployment 
     * @param _tokenContract Address of token contract
     */
    event SoladayTokenDeployed(
        address indexed _tokenContract
    );

    /************
    * Variables *
    *************/

    /*******************
    * Public Functions *
    ********************/
    constructor() ERC20 ("SoladayToken20220104", "SAD20220104", 18)
    {
        emit SoladayTokenDeployed(address(this));
    }

    function mint(address to, uint256 value) public virtual {
        _mint(to, value);
    }

    function burn(address from, uint256 value) public virtual {
        _burn(from, value);
    }
}