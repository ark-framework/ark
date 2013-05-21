# RELEASE POLICY(KAYAC社内向け)

## OrePAN反映手順

ArkはまだCPANに上げてないので、以下の手順でtarballを作成して [社内orepan](https://github.com/kayac/orepan)に上げてください。orepanへの上げ方はリンク先を確認してください。

1. lib/Ark.pmのVERSIONを更新
2. Changesを書く
3. % make clean && rm MANIFEST # 念のため
4. % perl Makefile.PL
5. % make manifest
6. % make disttest
7. % make dist

orepanへのupも終わったら、リリースに使われたファイルを削除した後、差分をリポジトリに反映します。手順は以下のとおりです。

1. % git clean -df
2. % git checkout -- README.mkdn
3. % git commit -am "0.xx"
5. % git push
4. % git tag v0.xx
6. % git push --tags

git checkout -- README.mkdn しているのがバッドノウハウ感ありますが、travisやcoverallsのバッジを表示しているのに消えてしまって悲しいからです。その辺含めてイケてない感じはするので、上記を自動化してくれるのはnot ybskです。

## 旧バージョンのメンテナンスについて

以下のブランチで旧バージョンのメンテナンスを行なっています。

- 0.2x
- 0.1x

バグが発生した場合などは旧バージョンへのバックポートを行い必要に応じてバージョンを上げてtagを打ってください。旧バージョン系列のorepanへのuploadは不要です。(多分共存できないので)

0.1xに関してはメンテが止まっていて、コミットログを見てもメンテ継続が困難な状態です。もう使っている人もいないだろうので打ち切ってもいいんじゃないかと思っています。

ちなみに、各バージョンの大きな違いは以下のとおりです。

- 0.1x
 - HTTP::Engine
 - Mouse
 - ark.pl
- 0.2x
 - no HTTP::Engine; use Plack;
 - Any::Moose
 - split off Path::AttrRouter
- 0.3x
 - no Any::Moose; use Mouse;

0.3系は0.39の次に0.4に上げるか、その際メンテナンスを分離するかどうかなどはまだ決めていません。その頃にはCPANに上がっていて欲しいですね。
