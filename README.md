このプロジェクトでは、[こちらのコード](https://github.com/vplasencia/zkSudoku/tree/main)を参考にして作成された`.sh`ファイルを使用しています。

## Circomやsnarkjsのダウンロード

必要なツールであるCircomやsnarkjsのダウンロード方法については、[こちらのドキュメント](https://docs.circom.io/getting-started/installation/)を参照してください。

## 使い方

以下の手順に従って、プロジェクトをセットアップし、実行します。

### 1. 必要なパッケージのインストール

まず、プロジェクトの依存関係をnpmでインストールします。プロジェクトのルートディレクトリで以下のコマンドを実行してください。

```bash
npm install
```
### 2. 入力値の生成

次に、eddsa_poseidon_generate.jsを使用して入力値を生成します。

```bash
node eddsa_poseidon_generate.js
```
### 3. セットアップスクリプトの実行

`setup.sh`スクリプトを実行してセットアップを行います。このスクリプトは回路に依存しない値を生成するため、回路を書き換えた場合でも再実行する必要はありません。

```bash
bash setup.sh
```
### 4. 証明の生成

`generate_proof.sh`スクリプトを実行してセットアップの続きを行った後、証明を生成します。

```bash
bash generate_proof.sh
```
### 5. 証明の検証

最後に、`verify.sh`スクリプトを実行して証明を検証します。

```bash
bash verify.sh
```
以上の手順で、trusted set up、証明の生成、照明の検証までの一連の流れを実行することができます。
circuitフォルダ内にあるpublic.jsonに出力シグナルの値も記載されているので、1のときには20歳以上、0のときには20歳未満であることが分かります。