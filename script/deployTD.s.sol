// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {ERC20TD} from "src/ERC20TD.sol";
import {Evaluator} from "src/Evaluator.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        //vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        //vm.startBroadcast(vm.envUint("anvil"));
        ERC20TD erc20 = new ERC20TD("TD-ERC20-101", "9wjD2", 206631273000000000000000000);
        Evaluator evaluator = new Evaluator(erc20);
        erc20.setTeacher(address(evaluator), true);
        vm.stopBroadcast();
    }
}
