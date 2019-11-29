## 2.7 ActiveJob

### 2.7.1 ActiveJobについて

ある時間のかかる処理をWebシステムで実行すると、その処理が終わるまでブラウザの操作ができなくなります。
その間、利用者は何もできずただ待つだけになってしまいます。

これを解決する方法として、時間のかかる処理はバックグラウンドで行おうというものがあります。これを非同期処理と言います。

リンクやボタンがクリックされ、サーバにリクエストが送られるとサーバでは処理を開始します。
非同期処理では時間のかかる処理を即座に行わず、キューにためておき別のプロセスが順番に処理を行います。

そのリクエストでは時間のかかる処理は行わないため、すぐにレスポンスを返すことができ、ユーザは即座に別のページにアクセス出来るようになります。

この非同期処理の仕組みを自分で実装も出来ますが、これまでと同様にGemでさまざまなライブラリが提供されています。
Railsで非同期処理を実装する場合は、これらのGemを利用して実装することになります。

- sidekiq
- resque
- delayed job

それぞれ特徴はありますがここでは割愛します。
興味があれば調べてみて下さい。

この3つのGemの書き方を簡単に紹介します。

```
class SomeJob
  include Sidekiq::Worker
  
  def perform(*args)
    # ここに時間のかかる処理を書く
  end
end

SomeJob.perform_asyncd
```

```
class SomeJob
  @queue = :default
  
  def self.perform(*args)
    # ここに時間のかかる処理を書く
  end
end

Resque.enqueue(SomeJob, 'arg')
```

```
class SomeClass
  def some_method
    # ここに時間のかかる処理を書く
  end
end

SomeClass.new.delay.some_method
```

このようにそれぞれのGemで実装方法が異なっています。

非同期処理を抽象化し、これらの違いを吸収するアダプタを持つライブラリがActiveJobです。

それではActiveJobを使った場合の実装を見てみましょう。

```
class SomeJob
  def perform(*args)
    # ここに時間のかかる処理を書く
  end
end

SomeJob.perform_later(arg)
```

どのGemを使っていても、Jobのコードは同じです。

違いは設定ファイルにあります。

```
config.active_job.queue_adapter = :sidekiq
config.active_job.queue_adapter = :resque
config.active_job.queue_adapter = :delayed_job
```



### 2.7.2 非同期処理を使ったインポート処理

それでは実際にActiveJobを使ってある処理を非同期で動かしてみましょう。
今回はResqueを使って実装します。

この例題では下記の仕様を実装します。

- CSVファイルをアップロードする
- CSVファイルには名前とメールアドレスが記載されている
- アップロードしたファイルを読み込んでUserモデルに登録する
- usersテーブルはname, emailのカラムを持つ

まずは、非同期処理を使わずに実装してみましょう。

Userモデルを作成します。
画面で登録した内容が確認できるようにscaffoldで作成します。

```
rails g scaffold User name email
rails db:migrate
```

CSVファイルをアップロードする機能を作成します。

`app/forms/upload_form.rb`

```
require 'csv'
class UploadForm
  include ActiveModel::Model

  attr_accessor :file

  validates :file, presence: true

  FILE_DIR = "#{Rails.root}/tmp"


  def import
    return false unless save
    CSV.read(filename).each do |row|
      User.create(name: row[0], email: row[1])
    end
    true
  end

  private

  def filename
    "#{FILE_DIR}/#{file.original_filename}"
  end

  def save
    return false unless valid?
    open(filename, "w") do |f|
      f.write file.read
    end
    true
  end
end
```

`config/routes.rb`

```
get 'upload', to: 'csv#index'
post 'upload', to: 'csv#upload'
```

`app/controllers/csv_controller.rb`

```
class CsvController < ApplicationController
  def index
    @upload_form = UploadForm.new
  end

  def upload
    @upload_form = UploadForm.new(upload_form_params)

    if @upload_form.import
      redirect_to upload_path, notice: 'インポートしました。'
    else
      render :index
    end
  end

  def upload_form_params
    params.fetch(:upload_form, {}).permit(:file)
  end
end
```

`views/csv/index.html.erb`

```
<h1>upload csv</h1>
<p><%= notice %></p>
<% if @upload_form.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@upload_form.errors.count, "error") %> prohibited this upload from being saved:</h2>

      <ul>
        <% @upload_form.errors.full_messages.each do |message| %>
            <li><%= message %></li>
        <% end %>
      </ul>
    </div>
<% end %>
<%= form_with(model: @upload_form, url: upload_path, method: :post, local: true) do |f| %>
  <%= f.file_field :file %>
  <%= f.submit %>
<% end %>

```

実際にファイルをアップロードしましょう。

`https://hogehoge/upload`にアクセスしてファイルを選択してボタンをクリックしてみましょう。

数秒後にレスポンスが帰ってきたかと思います。

それでは実際にjobを作って、非同期で処理を行ってみましょう。

まず、Gemfileに 'resque' を追加しましょう。

'Gemfile'

```
gem 'resque'
```

Gemfileに追記したら 'bundle install'を行います。

```
bundle install
```

次に 'ActiveJob' で 'resque' を利用するための設定を行います。

`config/application.rb`

```
config.active_job.queue_adapter = :resque
```

`config/initializers/resque.rb`を新たに作成

```
Resque.redis = 'localhost:6379'
Resque.redis.namespace = "resque:app_name:#{Rails.env}" # アプリ毎に異なるnamespaceを定義しておく
```

`lib/tasks/resque.rake`を新たに作成

```
require 'resque/tasks'
task 'resque:setup' => :environment
```


ここまでできたらJobを作成して、非同期処理になるように変更しましょう。

```
rails g job csv_import
```

`app/jobs/csv_import_job.rb`

```
class CsvImportJob < ApplicationJob
  queue_as :default

  def perform(filename)
    CSV.read(filename).each do |row|
      User.create(name: row[0], email: row[1])
    end
  end
end
```

`app/forms/upload_form.rb`を以下のように修正します。

```
  def import
    return false unless save
    CsvImportJob.perform_later(filename)
    true
  end
```

`Resque` は `redis` を利用してキューを管理しています。
cloud9には `redis` はすでにインストールされているのでターミナルで起動します。

```
redis-serverß
```

最後に実際にキューを読んで処理を行うプロセスを起動しましょう。

```
QUEUE=default rails resque:work
```

ここまでできたら、もう一度ファイルをアップロードしてみましょう。

先ほどとは違い、すぐにレスポンスが返ってきました。




