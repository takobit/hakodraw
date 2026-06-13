# Git / GitHub 運用ルール

本リポジトリでは、GitHub Flow をベースとした Git / GitHub 運用を採用する。

## 目的

開発が進むにつれて、変更理由、作業内容、最終的な変更履歴が混ざると、後から判断の経緯を追いにくくなる。

そのため、Issue / Pull Request / Commit の役割を明確に分け、`main` ブランチに読みやすい履歴を残すための運用ルールを定める。

## 基本方針

Issue から作業ブランチ・PR を作成し、`Squash and Merge` で作業内容を一つのコミットにまとめて `main` ブランチにマージする。

| 場所                  | 役割                                                                                           |
| --------------------- | ---------------------------------------------------------------------------------------------- |
| Issue                 | 何をするか、なぜその作業するのかを残す                                                         |
| Pull Request          | どのように実装したのか（作業ブランチのコミット履歴）を残す（Issue 番号で紐づけ）               |
| `main` のコミット履歴 | 作業ブランチ・PRを `Squash` してマージし、プロダクトの変更履歴として扱う（Issue 番号で紐づけ） |

## 作業フロー

### 1. Issue を作成

作業を始める前に Issue を作成し、何をするか、なぜ必要か、タスク、完了条件は何かを整理する。

```md
## 概要

練習タイマー機能を追加する。

## 目的

練習中に経過時間を確認できるようにし、ユーザーが練習時間を把握しやすくする。

## タスク

- [ ] タイマー用hookを追加する
- [ ] タイマー表示UIを追加する
- [ ] 開始、停止、リセット操作を追加する
- [ ] ローカルで動作確認する

## 完了条件

- [ ] 練習画面で経過時間が表示される
- [ ] 開始、停止、リセットが正しく動作する
- [ ] `make test` が成功する
```

### 2. `main` ブランチから作業ブランチを作成

最新の `main` から作業ブランチを作成する。詳しくは[ブランチについて](#ブランチについて)を参照。

```sh
git checkout main
git pull
git checkout -b feature/12-add-practice-timer
```

### 3. 作業・コミット

作業ブランチ上で実装し、必要な単位でコミットする。
作業中のコミットは厳密でなくてもよいが、可能な範囲で Conventional Commits を利用する。詳しくは[コミットについて](#コミットについて)を参照。

```txt
wip: タイマーUIを仮実装
tmp: タイマーhookを検証
fix: タイマーのリセット不具合を修正
```

### 4. Pull Request を作成

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

### 5. CI・レビュー

CI導入前はローカルで静的解析・自動テストを実施して問題ないかを確認する。

レビューは機能追加や認証・認可、BDスキーマ・API使用の変更等、比較的重めの変更場合に Codex やその他 AI にレビューさせる。

### 6. `main` ブランチへの `Squash And Merge`

`main` へマージする前に、以下を確認する。

- 静的解析・自動テストが PASS しているか
- 不要な差分が含まれていないか
- Pull Request が大きすぎないか

問題なければ GitHub 上で `Squash and merge` を選択してクリックし、コミットメッセージ末尾に Issue 番号が含まれていることを確認してから `main` ブランチへマージする。

```txt
feat: 練習タイマーを追加 (#12)
```

### 7. 作業ブランチを削除

マージ後は PR 画面から作業ブランチを削除する。

```txt
Delete branch
```

必要であれば、ローカルブランチも削除する。

```sh
git branch -d feature/12-add-practice-timer
```

## Issue 番号の扱い

Issue番号は、Issue と作業ブランチ / Pull Request / `main` ブランチのコミットを関連付けるために利用する。

### Issue と作業ブランチの紐づけ

`main` から作成する作業ブランチには、Issue番号を付与する。

作業ブランチ名の Issue番号は、作業ブランチがどの Issue と関連するのか識別しやすくする目的で利用する。

```txt
feature/12-add-practice-timer
fix/18-canvas-resize
refactor/25-split-practice-service
```

### Issue と Pull Request の紐づけ

PR一覧で関連 Issue を識別しやすくするため、Pull Request のタイトル先頭には Issue 番号を付与する。

```txt
[#12] feat: 練習タイマーを追加
```

また Pull Request 本文には関連 Issue 番号を記載し、Pull Request と Issue を GitHub 上で紐づける。

これにより Pull Request の merge 時には Issue が自動で close される。

```md
## 関連Issue

Closes #12
```

### Issue と `main` ブランチの紐づけ

Pull Request を `Squash And Merge` して `main` ブランチにマージする際、コミットメッセージに Pull Request の作業内容を Conventional Commits の形式で記述し、末尾に PR 番号を含める。

```txt
feat: 練習タイマーを追加 (#13)
```

GitHub では `#13` のような Issue / PR 番号は自動でリンクされる。

`main` ブランチの squash merge commit に付与する PR 番号は、履歴から関連 PR を追跡しやすくするために利用する。

## ブランチについて

[GitHub Flow](https://docs.github.com/ja/get-started/using-github/github-flow) を基本とし、`main` ブランチと作業ブランチで作業を行う。

### `main` ブランチ

常に動作可能な状態を維持し、本番環境に deploy 可能なソースコードを保持する。

### 作業ブランチ

最新の `main` ブランチから Issue に対応する以下の作業ブランチを作成する。

| プレフィックス | 説明                                                            | 作業例                    | ブランチ例                         |
| -------------- | --------------------------------------------------------------- | ------------------------- | ---------------------------------- |
| feature/\*     | 新しい機能を追加し、セマンティックバージョンの `MINOR` を上げる | ユーザー認証追加          | feature/12-add-authentication      |
| fix/\*         | バグを修正し、セマンティックバージョンの `PATCH` を上げる       | Canvas リサイズ不具合修正 | fix/18-canvas-resize               |
| chore/\*       | 環境構築・設定変更・依存関係更新・不要ファイル削除を行う        | Next.js 初期化            | chore/1-init-nextjs                |
| docs/\*        | ドキュメント追加・修正を行う                                    | README 更新               | docs/5-update-readme               |
| test/\*        | テスト追加・修正を行う                                          | Go service test 追加      | test/20-add-practice-service-test  |
| refactor/\*    | 挙動を変えないコード整理・リファクタリングを行う                | service 分割              | refactor/25-split-practice-service |

## コミットについて

本リポジトリでは、[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) を基本とする。
コミットメッセージの件名と本文は日本語で記述する。

### 運用方針

作業ブランチ上では、必要に応じて `wip:` や `tmp:` のような一時的なコミットを行ってもよい。

ただし、Pull Request を `Squash and merge` する際は、整理された Conventional Commit 形式のメッセージを使用する。

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

| type     | 説明                                   | メッセージ例                             |
| -------- | -------------------------------------- | ---------------------------------------- |
| feat     | 機能追加                               | feat: 練習タイマーを追加                 |
| fix      | バグ修正                               | fix: Canvasのリサイズ不具合を修正        |
| docs     | ドキュメント変更                       | docs: リポジトリルールを追加             |
| style    | 挙動を変えない見た目・フォーマット修正 | style: ページコンポーネントを整形        |
| refactor | 挙動を変えないリファクタリング         | refactor: 練習セッション処理を分割       |
| test     | テスト追加・修正                       | test: タイマーのテストを追加             |
| ci       | CI/CD設定変更                          | ci: GitHub Actionsのbuild workflowを追加 |
| chore    | 設定変更・環境構築・依存関係更新       | chore: Next.jsアプリを初期化             |

### メッセージ本文

件名だけで意図が伝わる場合は、本文を書かなくてよい。
補足が必要な場合は、空行を挟んで変更理由や注意点を簡潔に書く。

```txt
feat: 練習タイマーを追加

練習画面で経過時間を確認できるようにするため、タイマー表示を追加した。
開始、停止、リセットの操作に対応する。
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

## バージョン方針

`main` ブランチに残る Squash Merge Commit は、将来的に `main` ブランチへバージョンタグを付与する際の判断材料として扱う。

バージョンタグは `v0.0.0` 形式を利用する。

```txt
v0.1.0
v0.2.0
v0.2.1
```

Squash Merge Commit の type をもとに、セマンティックバージョニングの考え方で次のバージョンを判断する。

| Squash Merge Commit | バージョン更新 | 例                     |
| ------------------- | -------------- | ---------------------- |
| feat                | MINOR          | `v0.1.0` から `v0.2.0` |
| fix                 | PATCH          | `v0.2.0` から `v0.2.1` |
| `!`付きのCommit     | MAJOR          | `v1.2.3` から `v2.0.0` |
| BREAKING CHANGE     | MAJOR          | `v1.2.3` から `v2.0.0` |

```txt
feat: 練習タイマーを追加 (#12)
fix: Canvasのリサイズ不具合を修正 (#18)
feat!: APIレスポンス形式を変更 (#30)
```

すべての `main` へのマージに対して、必ずバージョンタグを付与するわけではない。
原則として、ユーザー向けの動作や機能に影響する変更をリリース対象とする。

ドキュメント変更、テスト追加、CI設定変更、フォーマット修正など、ユーザー向けの動作に影響しない変更は、原則としてバージョンタグ付与の対象外とする。

ただし、`chore` や `refactor` であっても、実行環境、依存関係、API互換性、ユーザー向け挙動に影響する場合は、必要に応じてリリース対象とする。

## main ブランチ保護

将来的には GitHub Branch Protection Rule を利用し、以下を設定する。

- `main` への直接 push 禁止
- required status checks 必須化
- CI成功後のみ merge 許可
