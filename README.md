# README

現在はIIJmio会員の人が参照できる、データ使用量閲覧ツールを目指しています。
IIJmioの2016/06/06現在のサービスでは過去30日分のデータしか参照できない為、
それ以前のデータ量がどれくらいつかっていたかを把握できませんが、本ツールを
使用する事でデータを永続化していつでも参照できるようにします。

Herokuでの利用を前提としています。

ひとまずGoogleのOauth2でログインできるような内容にくらいはなっております。
アプリケーションの起動に必要なツール類を列挙します。

## Ruby version

2.6.3

## システム要件

Herokuで動かしてあげてください。
といっても他のVPSで動かない事もないので適宜修正していただければと思います。

## 設定の確認

```
heroku config
rake routes
```

## heroku cliのアップデート

"Warning: heroku update available from"
なメッセージが出てきたら更新してみてもいいかも。

```
heroku update
```

## Docker環境の構築

本アプリケーションではPostgreSQLを使用します。PostgreSQLはDockerから利用します。
HomebrewからPostgreSQLをインストールする、でも構いませんがDockerの方が楽だと思います。

```
docker-composer up -d
```

|key|value|
|----|----|
|port|15432|
|host|localhost|

で接続する。パスワードはdatabase.ymlに別途設定済み

### HomebrewからPostgreSQLをインストール(おまけ)

Mac上の環境設定については以下を参照してください
http://qiita.com/kakikubo/items/1eb72f3d815873542c00

## Database creation

```
bundle exec rails db:create
bundle exec rails db:migrate
```

## DBの初期化

```
heroku run rake db:migrate
```

## heroku上のPostgreSQLへ接続

```
heroku pg:psql
```

## heroku上でバックアップを取得する

```
heroku pg:backups capture --app miopon
```

## heroku上で取得されたバックアップ一覧を表示する

```
heroku pg:backups --app miopon
```

## heroku上のバックアップURLを得る

```
heroku pg:backups public-url -a miopon
```

## heroku上のバックアップURLからダンプデータを取得する

```
curl -o latest.dump `heroku pg:backups public-url -a miopon`
```


## heroku上で動作しているPostgreSQLのデータをlocalへリストア

```
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d miopon_development latest.dum
```

## dotenvの準備

プロジェクトルートに.envファイルを置き、次のような内容を記載してください
IIJmio会員サイトのアカウント(mailアドレス),パスワードをセットします

```
EMAIL="hogehoge@gmail.com"
PASSWORD="hogehoge"
```

本番サイト(heroku)上ではコマンドラインから次のようにセットしておいてください
```
% heroku config:add EMAIL=“hogehoge@gmail.com"
% heroku config:add PASSWORD=“hogehoge"
```

## heroku上の動作をブラウザで確認する

```
heroku open
```

## heroku上でのログをみる

```
heroku logs --tail
```


## herokuでの定期バックアップ

```
kakikubo@kair ~/Documents/miopon % heroku pg:backups:schedules -a miopon
```

## heroku での認証Token

```
kakikubo@kair ~/Documents/miopon % heroku authorizations:create -d "getting started token"
```

## 他

Google 側の設定は以下できちんと済ませましょう。
https://console.developers.google.com/?hl=JA

redirect_uriの設定などは「認証情報」からOAuthクライアントIDを作成、選択して設定が可能です。


## 参考にしたサイト

- http://www.ohmyenter.com/rails-4-1-devise-omniauth-google-oauth2-%E3%81%A7%E8%AA%8D%E8%A8%BC%E6%A9%9F%E8%83%BD%E3%82%92%E5%AE%9F%E8%A3%85%E3%81%99%E3%82%8B/
- http://d.hatena.ne.jp/komiyak/20141103/1415016929
- heroku config:set BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-multi.git
