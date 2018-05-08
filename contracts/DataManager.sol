    pragma solidity ^0.4.11;

    import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
    import "./DataCentre.sol";


contract DataManager is Pausable {

    // satelite contract addresses
    address public dataCentreAddr;

    function DataManager(address _dataCentreAddr) {
        dataCentreAddr = _dataCentreAddr;
    }

    // This handles the upgradeability part
    function kill(address _newTokenContract) public onlyOwner whenPaused {
        if (dataCentreAddr != address(0)) {
            Ownable(dataCentreAddr).transferOwnership(msg.sender);
        }
        selfdestruct(_newTokenContract);
    }

    // view Functions
    function balanceOf(address _owner) public view returns (uint256) {
        return DataCentre(dataCentreAddr).getBalanace("STK", _owner);
    }

    function totalSupply() public view returns (uint256) {
        return DataCentre(dataCentreAddr).getValue("STK", "totalSupply");
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return DataCentre(dataCentreAddr).getConstraint("STK", _owner, _spender);
    }

    // Internal Functions
    function createDataCentre() internal returns (DataCentre) {
        return new DataCentre();
    }

    function _setTotalSupply(uint256 _newTotalSupply) internal {
        DataCentre(dataCentreAddr).setValue("STK", "totalSupply", _newTotalSupply);
    }

    function _setBalanceOf(address _owner, uint256 _newValue) internal {
        DataCentre(dataCentreAddr).setBalanace("STK", _owner, _newValue);
    }

    function _setAllowance(address _owner, address _spender, uint256 _newValue) internal {
        require(balanceOf(_owner) >= _newValue);
        DataCentre(dataCentreAddr).setConstraint("STK", _owner, _spender, _newValue);
    }

}
