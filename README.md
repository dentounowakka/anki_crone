# anki_crone

Anki の公式オープンソースリポジトリをローカルに取得し、改良作業を始めるためのワークスペースです。


## GitHub Pages で公開する

このリポジトリは GitHub Pages でそのまま表示できる `index.html` と `styles.css` を含んでいます。GitHub のリポジトリ設定で Pages の Source を `Deploy from a branch`、Branch を公開したいブランチの `/ (root)` に設定すると、セットアップ案内ページが公開されます。

ローカルで表示確認する場合は、以下を実行して `http://127.0.0.1:8000/` を開いてください。

```bash
python3 -m http.server 8000
```

## セットアップ

```bash
./scripts/setup_anki.sh
```

このスクリプトは次の処理を行います。

1. `anki/` が未作成の場合、公式リポジトリ `https://github.com/ankitects/anki.git` を clone します。
2. 公式 URL が使えない場合、`ANKI_REPO_URLS` で指定した代替 URL も順番に試します。
3. 既に `anki/.git` がある場合、現在のブランチと作業ツリー状態を表示します。
4. Anki 開発でよく使う `git`、`python3`、`node`、`yarn`、`bazel` の有無を確認します。
5. 次に実行する開発コマンドの案内を表示します。

## この環境で clone が失敗した理由

このコンテナでは `HTTPS_PROXY=http://proxy:8080` が設定されており、GitHub への HTTPS CONNECT がプロキシ側で `403 Forbidden` として拒否されました。プロキシを外すと `github.com` の名前解決自体ができないため、このコンテナからは Anki 本体の clone を完了できません。

GitHub に接続できる通常のネットワーク環境では、以下のコマンドまたはセットアップスクリプトで clone できます。

```bash
git clone https://github.com/ankitects/anki.git anki
```

## 代替 URL を指定して clone する

社内ミラーやフォークを使う場合は、空白区切りで URL を指定できます。

```bash
ANKI_REPO_URLS="https://github.com/ankitects/anki.git https://example.com/mirror/anki.git" ./scripts/setup_anki.sh
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
