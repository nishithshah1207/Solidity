pragma solidity 0.8.27;
import {Test} from "forge-std/Test.sol";
import {BoxStorage} from "../src/BoxStorage.sol";
contract BoxStorageTest is Test
{
    BoxStorage public boxStorage;
    uint256 minimumSizeInCm = 10;
    function setUp() public
    {
        boxStorage = new BoxStorage(minimumSizeInCm);
    }
    function test_CreateBox() public
    {
        uint256 width = minimumSizeInCm;
        uint256 length = minimumSizeInCm;
        uint256 height = minimumSizeInCm;
        boxStorage.createBox(width, length, height);
        (uint256 storedWidth, uint256 storedLength, uint256 storedHeight) = boxStorage.boxes(0);
        assertEq(storedWidth, width);
        assertEq(storedLength, length);
        assertEq(storedHeight, height);
    }
    function test_RevertWhen_WidthLessThanMinimum() public
    {
        uint256 width = minimumSizeInCm - 1;
        uint256 length = minimumSizeInCm;
        uint256 height = minimumSizeInCm;
        vm.expectRevert(abi.encodeWithSelector(BoxStorage.WrongWidth.selector, width, minimumSizeInCm));
        boxStorage.createBox(width, length, height);
    }
    function test_RevertWhen_LengthLessThanMinimum() public
    {
        uint256 width = minimumSizeInCm;
        uint256 length = minimumSizeInCm - 1;
        uint256 height = minimumSizeInCm;
        vm.expectRevert(abi.encodeWithSelector(BoxStorage.WrongLength.selector, length, minimumSizeInCm));
        boxStorage.createBox(width, length, height);
    }
    function test_RevertWhen_HeightLessThanMinimum() public
    {
        uint256 width = minimumSizeInCm;
        uint256 length = minimumSizeInCm;
        uint256 height = minimumSizeInCm - 1;
        vm.expectRevert(abi.encodeWithSelector(BoxStorage.WrongHeight.selector, height, minimumSizeInCm));
        boxStorage.createBox(width, length, height);
    }
}