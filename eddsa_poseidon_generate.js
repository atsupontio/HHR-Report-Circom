const circomlibjs = require("circomlibjs");
const fs = require("fs");

const buildEddsa = require("circomlibjs").buildEddsa;
const buildBabyjub = require("circomlibjs").buildBabyjub;

(async ()=>{

const eddsa =  await buildEddsa();

const babyJub = await buildBabyjub();
const F = babyJub.F;

// const F = eddsa.babyJub.F;
const msg = F.e(21);

const prvKey = Buffer.from("0001020304050607080900010203040506070809000102030405060708090001", "hex");

const pubKey = eddsa.prv2pub(prvKey);

const signature = eddsa.signPoseidon(prvKey, msg);


const inputs = {
    "pubkey_0": F.toString(pubKey[0]),
    "pubkey_1": F.toString(pubKey[1]),
    "signature_0": F.toString(signature.R8[0]),
    "signature_1": F.toString(signature.R8[1]),
    "signature_s": signature.S.toString(),
    "msg": F.toString(msg)
}

console.log(inputs);

fs.writeFileSync(
    "circuit/inputs.json",
    JSON.stringify(inputs),
    "utf-8"
);

})();
