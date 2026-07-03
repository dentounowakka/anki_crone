# anki_crone

Anki の公式オープンソースリポジトリをローカルに取得し、改良作業を始めるためのワークスペースです。

## セットアップ

```bash
./scripts/setup_anki.sh
```

このスクリプトは次の処理を行います。

1. `anki/` が未作成の場合、公式リポジトリ `https://github.com/ankitects/anki.git` を clone します。
2. 既に `anki/.git` がある場合、現在のブランチと作業ツリー状態を表示します。
3. Anki 開発でよく使う `git`、`python3`、`node`、`yarn`、`bazel` の有無を確認します。
4. 次に実行する開発コマンドの案内を表示します。

> この実行環境では GitHub への CONNECT が `403 Forbidden` でブロックされたため、実リポジトリの clone はこのコミット時点では完了していません。ネットワークで GitHub へ接続できる環境で上記スクリプトを実行してください。

## 手動 clone

スクリプトを使わない場合は、以下を実行してください。

```bash
git clone https://github.com/ankitects/anki.git anki
cd anki
git status
```

## 改良作業の流れ

```bash
cd anki
git switch -c my-improvement
# 変更を加える
git status
git diff
```

Anki 本体のビルド・テスト手順は、clone 後に `anki/README.md` や公式ドキュメントを確認してください。
