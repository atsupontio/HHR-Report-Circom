// pragma circom 2.0.0;
// include "../node_modules/circomlib/circuits/mimc.circom";

pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/eddsaposeidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";


template checkAge () {
    signal input age;
    signal output result;

    component greaterEq = GreaterEqThan(8);

    age ==> greaterEq.in[0];
    20 ==> greaterEq.in[1];
    greaterEq.out ==> result;
}

template Example () {
    signal input pubkey_0;
    signal input pubkey_1;
    signal input signature_0;
    signal input signature_1;
    signal input signature_s;
    signal input msg;
    signal output out;
    

    component eddsaverifier = EdDSAPoseidonVerifier();
    eddsaverifier.enabled <== 1;
    eddsaverifier.Ax <== pubkey_0;
    eddsaverifier.Ay <== pubkey_1;
    eddsaverifier.S <== signature_s;
    eddsaverifier.R8x <== signature_0;
    eddsaverifier.R8y <== signature_1;
    eddsaverifier.M <== msg;


    component checkage = checkAge();
    checkage.age <== msg;
    checkage.result ==> out;
    

}

component main { public [ pubkey_0, pubkey_1 ] } = Example();
