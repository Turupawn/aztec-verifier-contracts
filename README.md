# Aztec Verifier Contract Test

This repository contains multiple verifier contracts and testing harnesses that are used by [Noir, our Zero-Knowledge Programming Language](https://github.com/noir-lang/noir).

The implementations maintain the same interface, regardless of the verifier flavour (Standard, Turbo, Ultra), this should enable upstream implementations to be "plug-and-play".

The verifier will follow an overall architecture below, consisting of 3 contracts/libraries. Namely, the verifier algorithm (stable across circuits), the verification key (circuit dependent) and then the "verifier instance", a base that reads from the verification key and uses the key's values in the verification algorithm. The main advantage of this design is that we can generate verification key's per circuit and plug them into a general verification algorithm.

![Verifier architecture](./figures/verifier.png)

The verification key is currently generated via [Barretenberg](https://github.com/AztecProtocol/barretenberg/blob/master/cpp/src/aztec/proof_system/verification_key/sol_gen.hpp), Aztec's backend for generating proofs.

## Current implementations

### Standard Plonk Verifier

A verifier for standard plonk, the version of plonk that is used to run the [Aztec Connect](https://aztec.network/connect/) rollup.

The contracts are in the `src/standard` directory.

### UltraPlonk Verifier

The UltraPlonk Verifier follows the same structure as the Standard Plonk verifier, under the `src/ultra` directory.

## Generating Verification Keys and Proofs

Run `bootstrap.sh` to clone git submodules, bootstrap barretenberg, download SRS and generate verification keys. The bootstrap will also install foundry to `./.foundry` so you can use `./.foundry/bin/forge` if you don't already have foundry installed.

# Tests

Test are performed with a `TestBase` harness, it provides helpers for reading files and printing proofs. The tests also require proofs and verification keys, those are build as part of the `bootstrap.sh`.

## How To Run the Tests?

To run all tests, run the following scripts at the root of the repo:

```bash
forge test --no-match-contract TestBase # add -(v, vv, vvv, vvvv) for verbosity of logs, no logs emitted as default
```

To run test for a specific Contract test,

```bash
forge test --match-contract <NAME_OF_CONTRACT> # e.g., StandardTest
```

To run a specific test

```bash
forge test --match-test <NAME_OF_TEST> # e.g., testValidProof
```

Example to run only `testValidProof` for the Standard verifier with logs:

```bash
forge test --match-contract StandardTest --match-test testValidProof -vvvv
```

## Debugging in all assembly

Debugging from inside the assembly can be pretty inconvenient. The quickest way to get going is to add a custom error:
```solidity
bytes4 internal constant ERR_S = 0xf7b44074;
error ERR(bytes32,bytes32,bytes32);
```
Where `ERR_S` is the selector (first 4 bytes of keccak256(function signature)).

To revert the contract, and print values, you can then do as
```solidity
mstore(0x00, ERR_S) // put the selector in memory
mstore(0x04, val_1) // add first value after selector
mstore(0x24, val_2) // add second value after first
mstore(0x44, val_3) // add third value after second
revert(0x00, 0x64)  // revert with a message containing 0x64 bytes defined above
```
When running a test, you will then see the three values `val_1, val_2, val_3` in the console.
