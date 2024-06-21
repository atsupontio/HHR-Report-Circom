#!/bin/sh

compile() {

  echo $(date +"%T") "coompile the circuit into r1cs, wasm and sym"
  itime="$(date -u +%s)"
  # circom circuit.circom --r1cs --wasm --sym -p bls12381
  circom circuit.circom --r1cs --wasm --sym
  ftime="$(date -u +%s)"
  echo "	($(($(date -u +%s)-$itime))s)"

  echo $(date +"%T") "snarkjs info -r circuit.r1cs"
  snarkjs info -r circuit.r1cs

  # print the contraint
  # snarkjs r1cs print circuit.r1cs circuit.sym

  #  export the r1cs to json
  snarkjs r1cs export json circuit.r1cs circuit.r1cs.json
  # cat circuit.r1cs.json

  echo "calculating witness"
  cd circuit_js
  node generate_witness.js circuit.wasm ../inputs.json ../witness.wtns

  cd ..
}

echo "compile circuit"
cd circuit
compile