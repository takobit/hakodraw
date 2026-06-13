# Git / GitHub 運用ルール

本リポジトリでは、GitHub Flow をベースとした Git / GitHub 運用を採用する。

## 目的

- `main` ブランチを常に動作する状態に保つ
- Issue / Pull Request / Commit の役割を分ける
- Pull Request 単位で変更内容を確認できるようにする
- 後から設計判断や変更理由を追跡できるようにする
- Semantic Versioning と整合性のある履歴を残す

## 基本方針

履歴は以下の役割で管理する。

| 場所                | 役割                             |
| ------------------- | -------------------------------- |
| Issue               | なぜ作業するのか                 |
| Pull Request        | どのように実装したのか           |
| main のコミット履歴 | 最終的に何が追加・変更されたのか |

`main` ブランチは、プロダクトの変更履歴として扱う。
作業は `main` から作業ブランチを作成し、Pull Request を通して `main` に反映する。

## ブランチ戦略

GitHub Flow を基本とし、`main` と作業ブランチを使う。

| ブランチ    | 説明                                               | 作業例                   | ブランチ例                         |
| ----------- | -------------------------------------------------- | ------------------------ | ---------------------------------- |
| main        | 本番相当。常に動作する状態                         | -                        | -                                  |
| feature/\*  | 機能追加（MINOR）                                  | ユーザー認証追加         | feature/12-add-authentication      |
| fix/\*      | バグ修正（PATCH）                                  | Canvasリサイズ不具合修正 | fix/18-canvas-resize               |
| chore/\*    | 環境構築・設定変更・依存関係更新・不要ファイル削除 | Next.js初期化            | chore/1-init-nextjs                |
| docs/\*     | ドキュメント追加・修正                             | README更新               | docs/5-update-readme               |
| test/\*     | テスト追加・修正                                   | Go service test追加      | test/20-add-practice-service-test  |
| refactor/\* | 挙動を変えないコード整理・リファクタリング         | service分割              | refactor/25-split-practice-service |

## Issue 運用

作業は可能な範囲で Issue を作成してから開始する。
Issue では、何を行うか、なぜ必要か、完了条件は何かを管理する。

### Issue テンプレート

```md
## 概要

何をするか

## 目的

なぜ必要か

## タスク

- [ ] 作業1
- [ ] 作業2

## 完了条件

何をもって完了とするか
```

## Issue 番号の扱い

Issue番号は、Issue / 作業ブランチ / Pull Request / `main` ブランチの履歴を関連付けるために利用する。

### 作業ブランチ

`main` から作成する作業ブランチには、Issue番号を含める。

```txt
feature/12-add-practice-timer
fix/18-canvas-resize
refactor/25-split-practice-service
```

作業ブランチ名の Issue番号は、作業内容を識別しやすくする目的で利用する。

### Pull Request title

PR一覧で関連Issueを識別しやすくするため、Pull Request title には Issue番号を含める。

```txt
[#12] feat: add practice timer
```

Pull Request title では視認性を優先し、Issue番号を先頭に置いてよい。

### Pull Request body

Pull Request body には関連 Issue を記載する。

```md
Closes #12
```

これにより、Pull Request と Issue を GitHub 上で正式に関連付けできる。
merge 時には、Issue が自動で close される。

### `main` ブランチへ残る squash merge commit

`main` ブランチへ merge する際は、`Squash and merge` を利用する。

`main` に残る squash merge commit は、Conventional Commits の形式を優先する。

```txt
feat: add practice timer (#12)
```

`main` の履歴では `type:` を先頭に置き、Issue番号は suffix として付与する。

### 方針

- 作業ブランチには Issue番号を含める
- Pull Request title では視認性のため Issue番号を先頭に置く
- Pull Request body では `Closes #<Issue番号>` を利用して GitHub 上で正式に関連付ける
- `main` の squash merge commit は Conventional Commits を優先し、Issue番号を末尾に付与する
- `main` ブランチは、整理されたプロダクト履歴として扱う

## 作業フロー

### 1. main から作業ブランチを作成

最新の `main` から作業ブランチを作成する。

```sh
git checkout main
git pull
git checkout -b feature/12-add-practice-timer
```

### 2. 作業・コミット

作業ブランチ上で実装し、必要な単位でコミットする。
作業中のコミットは厳密でなくてもよいが、可能な範囲で Conventional Commits を利用する。

```txt
wip: タイマーUIを仮実装
tmp: タイマーhookを検証
fix: タイマーのリセット不具合を修正
```

### 3. Pull Request を作成

作業ブランチを push し、Pull Request を作成する。
Pull Request には、目的、変更内容、確認方法、関連 Issue を記載する。

```md
## 概要

練習タイマー機能を追加する。

## 変更内容

- タイマー用hookを追加
- タイマー表示UIを追加
- 開始、停止、リセット操作を追加

## 確認方法

- [ ] ローカルでタイマーが動作することを確認
- [ ] `make test` を実行

## 関連Issue

Closes #12
```

### 4. CI・レビュー

CI導入前は、マージ前にローカルで確認する。
該当するコマンドが未整備の場合は、利用可能な範囲で確認する。

```sh
make lint
make test
make build
```

CI導入後は、Pull Request 上で以下が成功してから `main` にマージする。
初期段階では、存在するアプリケーションのチェックのみ必須とする。

- frontend lint
- frontend test
- frontend build
- backend test
- backend build

一人開発のため、人間のレビューは必須としない。
ただし、設計変更、認証・権限・セキュリティ、DBスキーマ変更、API仕様変更、大きめのリファクタリングを含む Pull Request は、Codex / AI にレビューさせる。

### 5. main へマージ

`main` へマージする前に、以下を確認する。

- CI またはローカル確認が成功している
- 不要な差分が含まれていない
- Pull Request の目的が明確である
- Pull Request が大きすぎない

原則として、GitHub 上で `Squash and merge` を使用する。
作業途中の細かいコミットは Pull Request に残し、`main` には Pull Request 単位の整理されたコミットを残す。
Squash merge commit には、関連 Issue 番号を suffix として付与する。

```txt
feat: 練習タイマーを追加 (#12)
```

### 6. 作業ブランチを削除

マージ後は、GitHub 上で作業ブランチを削除する。

```txt
Delete branch
```

必要であれば、ローカルブランチも削除する。

```sh
git branch -d <branch-name>
```

## コミットルール

本リポジトリでは、[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) を基本とする。
コミットメッセージの件名と本文は日本語で記述する。

### 運用方針

Conventional Commits は、主に `main` に残る履歴を整理する目的で利用する。
作業ブランチ上では、必要に応じて `wip:` や `tmp:` のような一時的なコミットを行ってもよい。

ただし、Pull Request を `Squash and merge` する際は、整理された Conventional Commit 形式のメッセージを使用する。

```txt
作業コミット:
  必要以上に厳密にしなくてよい

main の履歴:
  読みやすく整理する
```

### 基本形式

```txt
<type>: <summary>

<body>
```

本文が不要な場合は、`<body>` を省略する。

後方互換性を壊す変更は、type の後ろに `!` を付ける。

```txt
<type>!: <summary>

<body>
```

大規模な破壊的変更の場合は、本文の後に `BREAKING CHANGE` フッターを追記する。

```txt
<type>!: <summary>

<body>

BREAKING CHANGE: <破壊的変更の内容>
```

### type 一覧

| type     | 説明                                   | メッセージ例                       |
| -------- | -------------------------------------- | ---------------------------------- |
| feat     | 機能追加                               | feat: 練習タイマーを追加           |
| fix      | バグ修正                               | fix: Canvasのリサイズ不具合を修正  |
| docs     | ドキュメント変更                       | docs: リポジトリルールを追加       |
| style    | 挙動を変えない見た目・フォーマット修正 | style: ページコンポーネントを整形  |
| refactor | 挙動を変えないリファクタリング         | refactor: 練習セッション処理を分割 |
| test     | テスト追加・修正                       | test: タイマーのテストを追加       |
| chore    | 設定変更・環境構築・依存関係更新       | chore: Next.jsアプリを初期化       |

### メッセージ本文

件名だけで意図が伝わる場合は、本文を書かなくてよい。
補足が必要な場合は、空行を挟んで変更理由や注意点を簡潔に書く。

```txt
feat: 練習タイマーを追加

練習画面で経過時間を確認できるようにするため、タイマー表示を追加した。
開始、停止、リセットの操作に対応する。
```

```txt
fix: Canvasのリサイズ不具合を修正

ウィンドウ幅を変更したときに描画領域のサイズが更新されない問題を修正した。
既存の描画内容が消えないよう、リサイズ時の再描画処理も調整した。
```

### Breaking Change

後方互換性を壊す変更は、type の後ろに `!` を付ける。
通常は `!` 付きの件名で破壊的変更であることを示す。

```txt
feat!: 認証方式をセッション認証からJWT認証へ変更

既存のログインセッションは利用できなくなるため、再ログインが必要になる。
```

大規模な変更や、移行時の注意点を明確に残したい場合は、フッターに `BREAKING CHANGE` を追記する。

```txt
feat!: APIレスポンス形式を変更

フロントエンドで扱いやすいよう、練習セッションAPIのレスポンス構造を変更した。

BREAKING CHANGE: `sessions` のレスポンスを配列から `{ items, total }` 形式に変更した。
```

### コミット単位

1つのコミットには、できるだけ1つの目的だけを含める。
機能追加、バグ修正、フォーマット修正、ドキュメント更新は、可能な範囲で分けてコミットする。

不要な差分、デバッグ用コード、生成物の混入がないことを確認してからコミットする。

## Semantic Versioning

本リポジトリでは Semantic Versioning を基本とする。

```txt
MAJOR.MINOR.PATCH
```

| version | 説明                       |
| ------- | -------------------------- |
| MAJOR   | 後方互換性を壊す変更       |
| MINOR   | 後方互換性を保った機能追加 |
| PATCH   | 後方互換性を保ったバグ修正 |

Conventional Commits との対応は以下とする。

| Commit          | Version |
| --------------- | ------- |
| feat            | MINOR   |
| fix             | PATCH   |
| `!`付きのCommit | MAJOR   |
| BREAKING CHANGE | MAJOR   |

初期開発中は `0.x.x` を利用する。
`1.0.0` は、最初の安定版リリースとする。

```txt
0.1.0
0.2.0
0.3.0
```

すべての `main` へのマージに対して、必ずバージョン付与・デプロイを行うわけではない。
原則として、ユーザー向けの動作や機能に影響する変更のみリリース対象とする。

| type            | バージョン付与 | 備考                         |
| --------------- | -------------- | ---------------------------- |
| feat            | MINOR          | 機能追加                     |
| fix             | PATCH          | バグ修正                     |
| `!`付きのCommit | MAJOR          | 後方互換性を壊す変更         |
| BREAKING CHANGE | MAJOR          | 大規模な破壊的変更の補足     |
| docs            | 原則なし       | ドキュメントのみ             |
| chore           | 原則なし       | 設定・環境構築・依存関係更新 |
| style           | 原則なし       | フォーマットのみ             |
| test            | 原則なし       | テストのみ                   |
| refactor        | 原則なし       | 挙動が変わらない場合         |

ただし、`chore`、`refactor` であっても、実行環境・依存関係・API互換性・ユーザー向け挙動に影響する場合は、必要に応じてリリース対象とする。

## main ブランチ保護

将来的には GitHub Branch Protection Rule を利用し、以下を設定する。

- `main` への直接 push 禁止
- required status checks 必須化
- CI成功後のみ merge 許可
