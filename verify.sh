#!/bin/sh

compile_and_ts_and_witness() {

  snarkjs groth16 verify verification_key.json public.json proof.json
  
}

echo "compile & trustesetup for circuit"
cd circuit
compile_and_ts_and_witness