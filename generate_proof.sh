#!/bin/sh

compile_and_ts_and_witness() {

  echo $(date +"%T") "coompile the circuit into r1cs, wasm and sym"
  itime="$(date -u +%s)"
  # circom circuit.circom --r1cs --wasm --sym -p bls12381
  circom circuit.circom --r1cs --wasm --sym
  ftime="$(date -u +%s)"
  echo "	($(($(date -u +%s)-$itime))s)"

  echo $(date +"%T") "snarkjs info -r circuit.r1cs"
  snarkjs info -r circuit.r1cs

  # print the contraint
  snarkjs r1cs print circuit.r1cs circuit.sym

  #  export the r1cs to json
  snarkjs r1cs export json circuit.r1cs circuit.r1cs.json
  cat circuit.r1cs.json

  echo "calculating witness"
  cd circuit_js
  node generate_witness.js circuit.wasm ../inputs.json ../witness.wtns

  cd ..

  #setup the phase 2 circuit ceremony
  snarkjs groth16 setup circuit.r1cs pot14_final.ptau circuit_0000.zkey

  # first contribution
  snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v

  # second contribution
  snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
  # Third contribution
  snarkjs zkey export bellman circuit_0002.zkey  challenge_phase2_0003
  snarkjs zkey bellman contribute bn128 challenge_phase2_0003 response_phase2_0003 -e="some random text"
  snarkjs zkey import bellman circuit_0002.zkey response_phase2_0003 circuit_0003.zkey -n="Third contribution name"

  # verify the latest key
  snarkjs zkey verify circuit.r1cs pot14_final.ptau circuit_0003.zkey

  snarkjs zkey beacon circuit_0003.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 14 -n="Final Beacon phase2"

  # verify the final key
  snarkjs zkey verify circuit.r1cs pot14_final.ptau circuit_final.zkey

  # export the verification key
  snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

  # generate proof
  snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
}

echo "compile & trustesetup for circuit"
cd circuit
compile_and_ts_and_witness