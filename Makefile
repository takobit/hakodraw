.PHONY: help web-install web-dev web-build web-start web-lint web-audit web-audit-fix web-audit-fix-force

WEB_DIR := apps/web
NPM := npm --prefix $(WEB_DIR)

help: ## 利用できるコマンドを表示する
	@awk 'BEGIN {FS = ":.*##"; printf "利用できるコマンド:\n"} /^[a-zA-Z0-9_-]+:.*##/ {printf "  make %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

web-install: ## フロントエンドの依存関係をインストールする
	$(NPM) install

web-dev: ## Next.jsの開発サーバーを起動する
	$(NPM) run dev

web-build: ## Next.jsアプリケーションをビルドする
	$(NPM) run build

web-start: ## ビルド済みのNext.jsアプリケーションを起動する
	$(NPM) run start

web-lint: ## フロントエンドのlintを実行する
	$(NPM) run lint

web-audit: ## フロントエンド依存関係の脆弱性を確認する
	$(NPM) audit

web-audit-fix: ## フロントエンド依存関係の脆弱性を安全な範囲で修正する
	$(NPM) audit fix

web-audit-fix-force: ## フロントエンド依存関係の脆弱性を破壊的変更を含めて修正する
	$(NPM) audit fix --force
