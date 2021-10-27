pragma solidity >=0.8.0 <0.9.0;

import '@openzeppelin/contracts/interfaces/IERC20.sol';
import '@openzeppelin/contracts/interfaces/IERC721.sol';

library SplitWithdrawals {
    event SplitWithdrawal(address _tokenAddressOrNone, address recipient, uint256 _amount);

    struct Payout {
        address[] recipients;
        uint16[] splits;
        uint16 BASE;
        bool initialized;
    }

    modifier onlyWhenInitialized(bool initialized) {
        require(initialized, 'This withdrawal split must be initialized.');
        _;
    }

    event PayoutCreated(address indexed _sender, uint256 _amount, uint16 _split);

    function initialize(Payout storage _payout) external {
        // configure fee sharing
        require(_payout.recipients.length > 0, 'You must specify at least one recipient.');
        require(_payout.recipients.length == _payout.splits.length, 'Recipients and splits must be the same length.');

        uint16 _total = 0;
        for (uint8 i = 0; i < _payout.splits.length; i++) {
            _total += _payout.splits[i];
        }
        require(_total == _payout.BASE, 'Total must be equal to 100%.');

        // initialized flag
        _payout.initialized = true;
    }

    // WITHDRAWAL

    /// @dev withdraw native tokens divided by splits
    function withdraw(Payout storage _payout) external onlyWhenInitialized(_payout.initialized) {
        uint256 _amount = address(this).balance;
        if (_amount > 0) {
            for (uint256 i = 0; i < _payout.recipients.length; i++) {
                // we don't want to fail here or it can lock the contract withdrawals
                uint256 _share = i != _payout.recipients.length - 1
                    ? (_amount * _payout.splits[i]) / _payout.BASE
                    : address(this).balance;
                (bool _success, ) = payable(_payout.recipients[i]).call{value: _share}('');
                if (_success) {
                    emit SplitWithdrawal(address(0), _payout.recipients[i], _share);
                }
            }
        }
    }

    /// @dev withdraw ERC20 tokens divided by splits
    function withdrawTokens(Payout storage _payout, address _tokenContract)
        external
        onlyWhenInitialized(_payout.initialized)
    {
        IERC20 tokenContract = IERC20(_tokenContract);

        // transfer the token from address of this contract
        uint256 _amount = tokenContract.balanceOf(address(this));
        /* istanbul ignore else */
        if (_amount > 0) {
            for (uint256 i = 0; i < _payout.recipients.length; i++) {
                uint256 _share = i != _payout.recipients.length - 1
                    ? (_amount * _payout.splits[i]) / _payout.BASE
                    : tokenContract.balanceOf(address(this));
                tokenContract.transfer(_payout.recipients[i], _share);
                emit SplitWithdrawal(_tokenContract, _payout.recipients[i], _share);
            }
        }
    }

    /// @dev withdraw ERC721 tokens to the first recipient
    function withdrawNFT(
        Payout storage _payout,
        address _tokenContract,
        uint256[] memory _id
    ) external onlyWhenInitialized(_payout.initialized) {
        IERC721 tokenContract = IERC721(_tokenContract);
        for (uint256 i = 0; i < _id.length; i++) {
            address _recipient = getNftRecipient(_payout);
            tokenContract.safeTransferFrom(address(this), _recipient, _id[i]);
        }
    }

    /// @dev Allow a recipient to update to a new address
    function updateRecipient(Payout storage _payout, address _recipient)
        external
        onlyWhenInitialized(_payout.initialized)
    {
        require(_recipient != address(0), 'Cannot use the zero address.');
        require(_recipient != address(this), 'Cannot use the address of this contract.');

        // loop over all the recipients and update the address
        bool _found = false;
        for (uint256 i = 0; i < _payout.recipients.length; i++) {
            // if the sender matches one of the recipients, update the address
            if (_payout.recipients[i] == msg.sender) {
                _payout.recipients[i] = _recipient;
                _found = true;
                break;
            }
        }
        require(_found, 'The sender is not a recipient.');
    }

    function getNftRecipient(Payout storage _payout)
        internal
        view
        onlyWhenInitialized(_payout.initialized)
        returns (address)
    {
        return _payout.recipients[0];
    }
}
