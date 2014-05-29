Chef-DK入門
====================
# 目的
[Chef開発キット](https://github.com/opscode/chef-dk)の解説

# 前提
| ソフトウェア   | バージョン   | 備考        |
|:---------------|:-------------|:------------|
| OS X           |10.9.2        |             |
| Chef Development Kit  |0.1.0  |             |
| vagrant        |1.6.0         |             |

[入門CHEF SOLO](https://github.com/k2works/chef_solo_introduction)のvagrant環境を設定して使う

# 構成
+ [Chef Development Kit](#1)
+ [Berkshelf](#2)
+ [Test Kitchen](#3)
+ [ChefSpec](#4)
+ [Foodcritic](#5)

# 詳細
## <a name="1">Chef Development Kit</a>
### インストール
[ここ](http://www.getchef.com/downloads/chef-dk/)からダウンロードする。  
パッケージのインストールができたならシェフクライアントスイートがシステムのbinディレクトリにシンボルリンクが貼られて使えるようになります。

### chefコマンド
我々のゴールはchefを素早いイテレーションとテストを可能にするBerkshelfの考えを組み込んだワークフローツールにする、そして簡単で信頼性が高く再利用可能なインフラ用自動化コードを生成する方法を提供することです。

#### ```chef generate```
ジェネレートサブコマンドはChefコードレイアウトのスケルトンを生成します。なのでテンプレートをコピーする退屈な作業をスキップしてインフラ自動化を迅速にやり遂げます。他のジェネレーターと違ってクックブックを作るときに最小限必要なファイルだけ生成します。なので不必要な過剰性を除いたタスクに集中できます。

以下のジェネレーターが組み込まれています。

+ ```chef generate app``` 複数のクックブックをサポートするアプリケーションレイアウトを生成する。これはひとつのレポジトリにひとつのクックブックと単一なシェフレポジトリのクックブック管理スタイルとの実験的折衷案です。
+ ```chef generate cookbook``` 単一のクックブックを作る。
+ ```chef generate recipe``` すでに存在するクックブックに新しいレシピファイルを作る。
+ ```chef generate attribute``` すでに存在するクックブックに新しいアトリビュートファイルを作る。
+ ```chef generate template``` すでに存在するクックブックに新しいテンプレートファイルを作る。-s SOURCEオプションを使うとソースファイルをコピーしてテンプレートを追加します。
+ ```chef generate file``` 既に存在するクックブックに新しいクックブックを作る。
+ ```chef generate lwrp``` 既に存在するクックブックに新しいLWRPリソースとプロバイダを作る。

#### ```chef gem```
chef gemはChefDKパッケージ用に組み込んだRubyのパッケージ管理のラッパーコマンドです。

Gemsはホームディレクトリの.chefdkディレクトリにインストールされます。

#### ```chef verify```
chef verifyは組み込まれたアプリケーションのテストを実行します。デフォルトでは組み込まれたアプリケーションが正しくインストールされてベーシックコマンドが動作するかを確かめるお手軽”スモークテスト”を実行します。

警告：受け入れテストは十分な権限でファイルシステムにアクセスしユーザー・グループを作成するHTTPサーバーを起動するような危険な行為です。テストはマシンの設定に敏感です。もしこれらを実行させるなら専用の隔離されてたホストで実行することを推奨します。

#### ```chef exec```

chef exec <command>は環境変数のPATHとruby環境変数(GEM_HOME,GEM_PATH,etc)で指定された任意のシェルコマンドを実行します。

#### ChefDKを主要な開発環境に使う

デフォルトではChefDKは既に存在する他のRuby開発環境から分離していくつかのアプリケーションをPATHに追加してパッケージングします。他のRuby環境を継続して使えます。ChefDKで提供するアプリケーションをPATHの最初に配置するだけです。

もしChefDKを主要なRuby/Chef開発環境にする場合はいくつかの変更が必要です。

_~/.chefdk/gem/ruby/2.1.0/bin_をPAHTに追加。これでchef gem経由でインストールしたコマンドラインアプリケーションを実行できるようになる。

### chefアプリケーション作成
```bash
$ chef generate app myapp
Compiling Cookbooks...
Recipe: code_generator::app
  * directory[/Users/k2works/projects/github/Chef-DK_introduction/myapp] action create
    - create new directory /Users/k2works/projects/github/Chef-DK_introduction/myapp

  * template[/Users/k2works/projects/github/Chef-DK_introduction/myapp/.kitchen.yml] action create
    - create new file /Users/k2works/projects/github/Chef-DK_introduction/myapp/.kitchen.yml
    - update content in file /Users/k2works/projects/github/Chef-DK_introduction/myapp/.kitchen.yml from none to 325674
        (diff output suppressed by config)

  * template[/Users/k2works/projects/github/Chef-DK_introduction/myapp/README.md] action create
    - create new file /Users/k2works/projects/github/Chef-DK_introduction/myapp/README.md
    - update content in file /Users/k2works/projects/github/Chef-DK_introduction/myapp/README.md from none to 6700ec
        (diff output suppressed by config)

  * directory[/Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks] action create
    - create new directory /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks

  * directory[/Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp] action create
    - create new directory /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp

  * template[/Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/metadata.rb] action create
    - create new file /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/metadata.rb
    - update content in file /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/metadata.rb from none to f054c6
        (diff output suppressed by config)

  * cookbook_file[/Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/chefignore] action create
    - create new file /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/chefignore
    - update content in file /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/chefignore from none to f2a74d
        (diff output suppressed by config)

  * cookbook_file[/Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/Berksfile] action create
    - create new file /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/Berksfile
    - update content in file /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/Berksfile from none to 303039
        (diff output suppressed by config)

  * directory[/Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/recipes] action create
    - create new directory /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/recipes

  * template[/Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/recipes/default.rb] action create
    - create new file /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/recipes/default.rb
    - update content in file /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/myapp/recipes/default.rb from none to d6c07b
        (diff output suppressed by config)

  * execute[initialize-git] action run
    - execute git init .

  * cookbook_file[/Users/k2works/projects/github/Chef-DK_introduction/myapp/.gitignore] action create
    - create new file /Users/k2works/projects/github/Chef-DK_introduction/myapp/.gitignore
    - update content in file /Users/k2works/projects/github/Chef-DK_introduction/myapp/.gitignore from none to 05eef0
        (diff output suppressed by config)
```
## <a name="2">Berkshelf</a>
### コマンド
+ berks init:既に存在するクックブックにBerksfileを生成する。
+ berks cookbook:新しいクックブックを生成する。
+ berks install:指定されたBerksfileと依存関係のクックブックをインストールする
+ berks help:ヘルプ
+ berks package:必要なクックブックを含んだ単一アーカイブを作成する。
+ berks vendor:クックブックをローカルにインストールする

### クックブック作成
```bash
$ cd myapp/cookbooks/
$ mv myapp mycookbook
$ cd mycookbook
$ berks init .
   identical  Berksfile
      create  Thorfile
    conflict  chefignore
Overwrite /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/chefignore? (enter "h" for help) [Ynaqdh] Y
       force  chefignore
      create  .gitignore
         run  git init from "."
      create  Gemfile
      create  .kitchen.yml
      append  Thorfile
      create  test/integration/default
      append  .gitignore
      append  .gitignore
      append  Gemfile
      append  Gemfile
You must run `bundle install' to fetch any new gems.
      create  Vagrantfile
Successfully initialized
```
依存関係はBerksfileを経由して管理されます。BerkfileはBundlerのGemfileのようなものです。  
_Berksfile_  
```ruby
source "https://api.berkshelf.com"

metadata

cookbook "mysql"
cookbook "nginx", "~> 2.6"
```
metadataキーワードはBundlerのGemfile内のgemspecのようなものです。  
_metadate.rb_  
```ruby
name             'mycookbook'
maintainer       ''
maintainer_email ''
license          ''
description      'Installs/Configures '
long_description 'Installs/Configures '
version          '0.1.0'
```
実行
```bash
$ berks vendor
Resolving cookbook dependencies...
Fetching 'mycookbook' from source at .
Fetching cookbook index from https://api.berkshelf.com...
Using apt (2.4.0)
Using bluepill (2.3.1)
Using build-essential (2.0.2)
Using mycookbook (0.1.0) from source at .
Using mysql (5.2.10)
Using nginx (2.7.0)
Using ohai (2.0.0)
Using rsyslog (1.12.2)
Using runit (1.5.10)
Using yum (3.2.0)
Using yum-epel (0.3.6)
Vendoring apt (2.4.0) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/apt
Vendoring bluepill (2.3.1) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/bluepill
Vendoring build-essential (2.0.2) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/build-essential
Vendoring mycookbook (0.1.0) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/mycookbook
Vendoring mysql (5.2.10) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/mysql
Vendoring nginx (2.7.0) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/nginx
Vendoring ohai (2.0.0) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/ohai
Vendoring rsyslog (1.12.2) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/rsyslog
Vendoring runit (1.5.10) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/runit
Vendoring yum (3.2.0) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/yum
Vendoring yum-epel (0.3.6) to /Users/k2works/projects/github/Chef-DK_introduction/myapp/cookbooks/mycookbook/berks-cookbooks/yum-epel
```
_Vagrantfile_編集
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.hostname = "mycookbook-berkshelf"
  config.omnibus.chef_version = :latest
  config.vm.box = "opscode_ubuntu-12.04_provisionerless"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
　config.vm.network "private_network", ip: "192.168.50.12"

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      mysql: {
        server_root_password: 'rootpass',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass'
      }
    }

    chef.run_list = [
        "recipe[mycookbook::default]",
        "nginx",
        "mysql::client",
        "mysql::server"
    ]
  end
end
```
_bootstrap.sh_追加
```bash
#!/usr/bin/env bash
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
apt-get update
```
vagrant実行
```bash
$ vagrant plugin install vagrant-berkshelf --plugin-version 2.0.1
$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'opscode_ubuntu-12.04_provisionerless'...
==> default: Matching MAC address for NAT networking...
・・・
==> default: [2014-05-16T10:01:53+00:00] INFO: Chef Run complete in 74.600774345 seconds
==> default: [2014-05-16T10:01:53+00:00] INFO: Running report handlers
==> default: [2014-05-16T10:01:53+00:00] INFO: Report handlers complete
```

## <a name="3">Test Kitchen</a>
### KitchenCI設定
デフォルトではバーチャルマシンの名前解決が上手くいかないので_default.rb_を編集して名前解決とapt-get updateを起動時に実行できるようにする。  
_myapp/cookbooks/mycookbook/recipes/default.rb_
```ruby
bash 'bootstrap' do
  code <<-EOC
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
  EOC
end

execute "update-pkg" do
  if node['platform'] == "ubuntu"
    command "apt-get update"
  else
    command "yum update -y"
  end
end
```
_.kitchen.yml_を編集する
_myapp/cookbooks/mycookbook/.kitchen.yml_
```yml
---
driver:
  name: vagrant
  customize:
    natdnshostresolver1: "on"

provisioner:
  name: chef_solo

platforms:
  - name: ubuntu-12.04
  - name: centos-6.4

suites:
  - name: default
    run_list:
      - recipe[mycookbook::default]
      - nginx
      - mysql::client
      - mysql::server
    attributes:
```
### テスト用バーチャルマシンを作る
```bash
$ kitchen list
Instance             Driver   Provisioner  Last Action
default-ubuntu-1204  Vagrant  ChefSolo     <Not Created>
default-centos-64    Vagrant  ChefSolo     <Not Created>
$ kitchen create default-ubuntu-1204
Instance             Driver   Provisioner  Last Action
default-ubuntu-1204  Vagrant  ChefSolo     Created
```
### テスト用レシピを書く
以下を追加  
_myapp/cookbooks/mycookbook/recipes/default.rb_
```ruby
package "git"

log "Well, that was too easy"
```
### Kitchen Convergeを実行する
```bash
$ kitchen converge default-ubuntu-1204
・・・
$ kitchen list
Instance             Driver   Provisioner  Last Action
default-ubuntu-1204  Vagrant  ChefSolo     Converged
```
convergeが失敗した場合は再実行してうまくいくまで繰り返す。

### 手動確認
```bash
$ kitchen login default-centos-64
Welcome to Ubuntu 12.04.4 LTS (GNU/Linux 3.11.0-15-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Last login: Thu May 29 02:29:24 2014 from 10.0.2.2
vagrant@default-ubuntu-1204:~$ exit
logout
Connection to 127.0.0.1 closed.
MacBook-Air@k2works:mycookbook (wip) $ kitchen login default-ubuntu-1204
Welcome to Ubuntu 12.04.4 LTS (GNU/Linux 3.11.0-15-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Last login: Thu May 29 02:48:30 2014 from 10.0.2.2
vagrant@default-ubuntu-1204:~$ which git
/usr/bin/git
vagrant@default-ubuntu-1204:~$ which mysql
/usr/bin/mysql
vagrant@default-ubuntu-1204:~$ which nginx
/usr/sbin/nginx
```
### テストを書く
_myapp/cookbooks/mycookbook/test/integration/default/bats/git_installed.bats_
```bash
#!/usr/bin/env bats

@test "git binary is found in PATH" {
  run which git
  [ "$status" -eq 0 ]
}
```
### Kitchen Verifyを実行する
```bash
$ kitchen verify default-ubuntu-1204
-----> Starting Kitchen (v1.2.2.dev)
-----> Setting up <default-ubuntu-1204>...
Fetching: thor-0.19.0.gem (100%)
Fetching: busser-0.6.2.gem (100%)
Successfully installed thor-0.19.0
Successfully installed busser-0.6.2
2 gems installed
-----> Setting up Busser
       Creating BUSSER_ROOT in /tmp/busser
       Creating busser binstub
       Plugin bats installed (version 0.2.0)
-----> Running postinstall for bats plugin
Installed Bats to /tmp/busser/vendor/bats/bin/bats
       Finished setting up <default-ubuntu-1204> (0m58.64s).
-----> Verifying <default-ubuntu-1204>...
       Suite path directory /tmp/busser/suites does not exist, skipping.
Uploading /tmp/busser/suites/bats/git_installed.bats (mode=0644)
-----> Running bats test suite
 ✓ git binary is found in PATH

1 test, 0 failures
       Finished verifying <default-ubuntu-1204> (0m1.08s).
-----> Kitchen is finished. (1m0.44s)
```
テストを失敗させる
_myapp/cookbooks/mycookbook/test/integration/default/bats/git_installed.bats_
```bash
#!/usr/bin/env bats

@test "git binary is found in PATH" {
  run which gitt
  [ "$status" -eq 0 ]
}
```
```bash
$ kitchen verify default-ubuntu-1204
-----> Starting Kitchen (v1.2.2.dev)
-----> Verifying <default-ubuntu-1204>...
       Removing /tmp/busser/suites/bats
Uploading /tmp/busser/suites/bats/git_installed.bats (mode=0644)
-----> Running bats test suite
 ✗ git binary is found in PATH
   (in test file /tmp/busser/suites/bats/git_installed.bats, line 5)

1 test, 1 failure
Command [/tmp/busser/vendor/bats/bin/bats /tmp/busser/suites/bats] exit code was 1
>>>>>> Verify failed on instance <default-ubuntu-1204>.
>>>>>> Please see .kitchen/logs/default-ubuntu-1204.log for more details
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::ActionFailed
>>>>>> Message: SSH exited (1) for command: [sh -c 'BUSSER_ROOT="/tmp/busser" GEM_HOME="/tmp/busser/gems" GEM_PATH="/tmp/busser/gems" GEM_CACHE="/tmp/busser/gems/cache" ; export BUSSER_ROOT GEM_HOME GEM_PATH GEM_CACHE; sudo -E /tmp/busser/bin/busser test']
>>>>>> ----------------------
```
テストを追加
```bash
#!/usr/bin/env bats

@test "git binary is found in PATH" {
  run which git
  [ "$status" -eq 0 ]
}

@test "mysql binary is found in PATH" {
  run which mysql
  [ "$status" -eq 0 ]
}

@test "nginx binary is found in PATH" {
  run which nginx
  [ "$status" -eq 0 ]
}

```
実行
```bash
$ kitchen verify default-ubuntu-1204
-----> Starting Kitchen (v1.2.2.dev)
-----> Verifying <default-ubuntu-1204>...
       Removing /tmp/busser/suites/bats
Uploading /tmp/busser/suites/bats/git_installed.bats (mode=0644)
-----> Running bats test suite
 ✓ git binary is found in PATH
 ✓ mysql binary is found in PATH
 ✓ nginx binary is found in PATH

3 tests, 0 failures
       Finished verifying <default-ubuntu-1204> (0m1.13s).
-----> Kitchen is finished. (0m1.86s)
```
### Kitchen Testを実行する
[うまくいかない](https://github.com/k2works/Chef-DK_introduction/issues/1)

### プラットフォーム追加
_.kitchen.yml_
```yml
・・・
platforms:
  - name: ubuntu-12.04
  - name: ubuntu-10.04
  - name: centos-6.4
・・・  
```
### Convergeを直す
_.kitchen.yml_
```yml
・・・
platforms:
  - name: ubuntu-12.04
  - name: ubuntu-10.04
  - name: centos-6.4
・・・  
```

```bash
$ kitchen converge 10
-----> Starting Kitchen (v1.2.2.dev)
-----> Converging <default-ubuntu-1004>...
...

       ================================================================================
       Error executing action `install` on resource 'package[git]'
       ================================================================================


       Chef::Exceptions::Package
       -------------------------
       git has no candidate in the apt-cache
...
```
_myapp/cookbooks/mycookbook/recipes/default.rb_
```bash
if node['platform'] == "ubuntu" && node['platform_version'].to_f <= 10.04
  package "git-core"
else
  package "git"
end

log "Well, that was too easy"
```
```bash
$ kitchen verify 10
$ kitchen verify ('12|64')
$ kitchen destroy
```
### 新機能を追加する
_.kitchen.yml_
```yml
・・・
- name: server
  run_list:
    - recipe[mycookbook::server]
  attributes:  
```
### サーバーテストを追加する
_myapp/cookbooks/mycookbook/test/integration/server/serverspec/git_daemon_spec.rb_
```ruby
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Git Daemon" do

  it "is listening on port 9418" do
    expect(port(9418)).to be_listening
  end

  it "has a running service of git-daemon" do
    expect(service("git-daemon")).to be_running
  end

end
```
テスト実行
```bash
$ kitchen verify server-ubuntu-1204
```
レシピが無くて失敗するのでレシピ追加
_myapp/cookbooks/mycookbook/recipes/server.rb_
```ruby
include_recipe "mycookbook"

package "git-daemon-run"

runit_service "git-daemon" do
  sv_templates false
end
```
### 依存関係追加
_Berksfile_
```ruby
cookbook "runit"
```
実行
```bash
$ kitchen verify server-ubuntu-1204
-----> Starting Kitchen (v1.2.2.dev)
-----> Verifying <server-ubuntu-1204>...
       Removing /tmp/busser/suites/serverspec
Uploading /tmp/busser/suites/serverspec/git_daemon_spec.rb (mode=0644)
-----> Running serverspec test suite
/opt/chef/embedded/bin/ruby -I/tmp/busser/suites/serverspec -S /opt/chef/embedded/bin/rspec /tmp/busser/suites/serverspec/git_daemon_spec.rb --color --format documentation

Git Daemon
  is listening on port 9418
  has a running service of git-daemon

Finished in 0.08699 seconds
2 examples, 0 failures
       Finished verifying <server-ubuntu-1204> (0m1.47s).
-----> Kitchen is finished. (0m2.47s)
```
CentOSでも実行できるようにする
```ruby
include_recipe "mycookbook"


if node['platform'] == "ubuntu"
  package "git-daemon-run"
else
  package "git-daemon"
end

runit_service "git-daemon" do
  sv_templates false
end
```
CentOSはサーバーグループから除外する場合
```yml
・・・
excludes:
  - centos-6.4
```
後かたづけ
```bash
$ kitchen destroy
```

## <a name="4">ChefSpec</a>
## <a name="5">Foodcritic</a>

# 参照
+ [Chef](http://www.getchef.com)
+ [Berkshelf](http://berkshelf.com)
+ [Test Kitchen](http://kitchen.ci)
+ [ChefSpec](http://code.sethvargo.com/chefspec/)
+ [Foodcritic](http://acrmp.github.io/foodcritic/)
