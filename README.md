# README

## Model

### User
- id
- name string
- created_at
- updated_at
- password_digest string
- remember_digest string

### Station
- id
- user_id   integer ログイン中のユーザーに紐付け
- name      string ユーザー入力 or 自動生成
- call_sign string ユーザー入力 or 自動生成
- mmsi      integer 自動生成
- lat       float 自動生成
- long      float E,Nが＋でS,Wが-
- region    string
- channel   integer
- created_at
- updated_at
- state     integer 0:OFF 1:定常 2:CH変更 3:補助画面 4:MENU 5:FUNC 6:DSC 7:DIST
- tmp_ch    integer
- power     integer 1 or 25

#### state
- 0 電源OFF　            全ての入力を受け付けない
- 1 定常画面 　          数字(0,1,2,6,7,8)→チャンネル変更モードへ FUNC→短縮キー MENU→メニュー画面へ
- 2 チャンネル変更モード   0~9でチャンネル確定 キャンセルで定常画面へ
- 3 補助画面
- 4 MENU 数字→階層選択
- 5 FUNC
- 6 DSC受信画面
- 7 遭難モード

### Dsc
- id
- from_id      integer
- to_id        integer
- category     string
- format       string
- message_type string
- work_ch      integer
- reason       string
- eos          string
- nature       string
- lat          float
- long         float
- utc          float
- created_at
- updated_at
- dist_id      integer
- original_id  integer


## Controller

### application
- set_current_user     @current_user定義
- authenticate_user    アクセス制限（未ログイン）
- forbid_login_user    アクセス制限（ログイン中）
- authenticate_station アクセス制限（局情報未登録）
- forbid_login_station アクセス制限（局情報登録済）


### dscs
- ship_station_call             DSC呼出ロジック
- safety_call_all_ships         〃
- safety_call_specific_station  〃
- urgency_call_all_ships        〃
- urgency_call_specific_station 〃
- distress_call                 〃
- proxy_distress_call_all_ships 〃
- show                          DSCメッセージ表示（MENU 4）
- received_call                 DSC受信画面
- accept                        MENU操作時、遭難モード時のDSC受入
- listen                        Work CHにチャンネル変更して聴取
- cancel                        聴取せずホーム画面に戻る
- new_call                      新規メッセージ確認ロジック
- ack                           受信証を返す
- relay                         Distressリレー
- new_ch                        別チャンネル提示
- nack                          受信不可
- set_dsc                       @dsc、@from、@to定義
- set_lat_long                  度、分換算


### home
- top
- about
- forbid_login_user_home アクセス制限（ログイン中）


### stations
- index                         *
- show                          定常画面
- new                           局情報登録画面
- pwr_cont                      電源ON（state0→1)
- pwr_off                       電源OFF
- change_power                  1W/25W
- back_16                       CH16
- menu                          MENUモード
- cancel                        定常状態へ戻る
- break                         遭難モード中断
- off_btn                       電源OFF確認
- func                          FUNCモード
- dsc_rtn                       DSC呼出画面
- safety_call_all_ships         〃
- safety_call_specific_station  〃
- urgency_call_all_ships        〃
- urgency_call_specific_station 〃
- distress_call                 〃
- proxy_distress_call_all_ships 〃
- dsc_test_call                 〃
- other_ships_list              MENU 5.1 Other ships list
- self_diagnosis                MENU 8.1 自己診断テスト
- ais_call                      AIS情報から呼出
- btns                          テンキー操作
- edit                          *
- create                        局情報登録
- update                        *
- destroy                       *
- set_station                   @station定義
- set_lat_long                  度、分換算
- ensure_correct_station        アクセス制限（他局）


### users
- index               *
- show                ホーム画面（ようこそ、○○さん）
- new                 新規登録画面
- edit                *
- create              新規登録
- update              *
- destroy             *
- login_form          ログイン画面
- login               ログイン
- logout              ログアウト
- ensure_correct_user アクセス制限（他ユーザ）
- set_user            @user定義
- user_params         *



This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
