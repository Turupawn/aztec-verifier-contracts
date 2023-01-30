// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import {UltraVerificationKey} from "../keys/UltraVerificationKey.sol";
import {BaseUltraVerifier} from "../BaseUltraVerifier.sol";

contract UltraVerifier is BaseUltraVerifier {
    function getVerificationKeyHash() public pure override(BaseUltraVerifier) returns (bytes32) {
        return UltraVerificationKey.verificationKeyHash();
    }

    function loadVerificationKey(uint256 vk, uint256 _omegaInverseLoc) internal pure virtual override {
        UltraVerificationKey.loadVerificationKey(vk, _omegaInverseLoc);
    }
}