pragma solidity >= 0.8.0 <0.9.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 * @author OpenZeppelin, rewite by @maxflowo2 for events/gas optimization
 * Original source:
 * https://github.com/hiddentao/openzeppelin-solidity/blob/master/contracts/access/Roles.sol
 */

event RoleGranted(bytes4 _type, address _user); // 0x0baaa7ab
event RoleRevoked(bytes4 _type, address _user); // 0x6107a4a5
error Unauthorized(); // 0x82b42900
error Error(string _error); // 0x08c379a0

library Roles {
  struct Role {
    mapping(address => mapping(bytes4 => bool)) bearer;
  }

  /**
   * @dev give an account access to this role
   */
  function add(Role storage role, bytes4 type, address account) internal {
    if (account == address(0)) {
      revert Unauthorized();
    } else if (has(role, type, account)) {
      revert Error({
        _error: "User already has this role"
      });
    }
    role.bearer[account][type] = true;
    emit RoleGranted(type, account);
  }

  /**
   * @dev remove an account's access to this role
   */
  function remove(Role storage role, bytes4 type, address account) internal {
    if (account == address(0)) {
      revert Unauthorized();
    } else if (!has(role, type, account)) {
      revert Error({
        _error: "User does not have this role"
      });
    }
    role.bearer[account][type] = false;
    emit RoleRevoked(type, account);
  }

  /**
   * @dev check if an account has this role
   * @return bool
   */
  function has(Role storage role, bytes4 type, address account)
    internal
    view
    returns (bool)
  {
    if (account == address(0)) {
      revert Unauthorized();
    }
    return role.bearer[account][type];
  }
}
