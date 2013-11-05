   <?php echo $this->Html->css(array('docs'), false, array('inline'=>false)); ?>
    
  <!-- Scrollspyの設定をbodyタグに記入 -->
  <body data-spy="scroll" data-target=".bs-docs-sidebar">
  
    <div class="container">

      <div class="row">
  
        <!-- 左部固定のサイドバー -->
        <div class="col-sm-3 bs-docs-sidebar">
          <div class="bs-sidebar hidden-print affix" role="complementary">
            <ul class="nav nav-list bs-sidenav bs-docs-sidenav">
              <li>
                <a href="#game-description"><i class="icon-chevron-right"></i>ゲーム概要</a>
                <ul class="nav">
                  <li><a href="#game-description-introduction"><i class="icon-chevron-right"></i>イントロダクション</a></li>
                  <li><a href="#game-description-explain"><i class="icon-chevron-right"></i>ゲーム説明</a></li>
                </ul>
              </li>
              <li>
                <a href="#game-rule"><i class="icon-chevron-right"></i>ゲームルール & 詳細</a>
                <ul class="nav">
                  <li><a href="#game-rule-overview"><i class="icon-chevron-right"></i>全体図</a></li>
                  <li><a href="#game-rule-hp-energy"><i class="icon-chevron-right"></i>HPとエネルギー</a></li>
                  <li><a href="#game-rule-stage"><i class="icon-chevron-right"></i>ステージ</a></li>
                  <li><a href="#game-rule-fighter"><i class="icon-chevron-right"></i>戦闘機</a></li>
                  <li><a href="#game-rule-msg"><i class="icon-chevron-right"></i>メッセージボックス</a></li>
                  <li><a href="#game-rule-flow"><i class="icon-chevron-right"></i>ゲームの流れ</a></li>
                </ul>
              </li>
              <!--<li>
                <a href="#game-instruction"><i class="icon-chevron-right"></i>命令詳細</a>
                <ul class="nav">
                  <li><a href="#game-instruction-move"><i class="icon-chevron-right"></i>移動</a></li>
                  <li><a href="#game-instruction-random-move"><i class="icon-chevron-right"></i>ランダム移動</a></li>
                  <li><a href="#game-instruction-approach"><i class="icon-chevron-right"></i>接近</a></li>
                  <li><a href="#game-instruction-leave"><i class="icon-chevron-right"></i>逃避</a></li>
                  <li><a href="#game-instruction-shot"><i class="icon-chevron-right"></i>ショット</a></li>
                </ul>
                </li>-->
            </ul>
          </div>
        </div><!-- /span3 bs-docs-sidebar -->
  
        <div class="col-sm-9">
          <section id="game-description">
            <div class="page-header">
              <h2>ゲーム概要</h2>
            </div>
    
            <section id="game-description-introduction">
              <h3>イントロダクション</h3>
              <p>このゲームはプログラミング言語 OCTAGRAM を使ったゲーム AI 対戦ゲームになります。</p>
              <p>ユーザーは OCTAGRAM で AI を組み、他のユーザーが作った AI と対戦することができます。</p>
              <p>対戦成績はユーザーが作成したプログラムごとに記録され、ランキングに反映されます。</p>
              <p>1 位を目指して最強の AI を組みましよう！！</p>
              <p>OCTAGRAM を通じてプログラミングの楽しさを少しでも理解していただけると幸いです。</p>
              </br>
            </section>

            <section id="game-description-explain">
                <h3>ゲーム説明</h3>
                <p>このゲームを簡単に説明すると、</p>
                <blockquote>
                    <p>限られたエネルギーの中、戦闘機を動かし、弾丸を相手に当てて倒すゲーム</p>
                </blockquote>
                <p>である。</p>
                <p>自分の戦闘機をプログラムを組んで動かす。</p>
                <p>戦闘機の行動にはエネルギーが必要（一部例外）で、エネルギーを消費しながら移動し敵を探し出して相手にダメージを与える。</p>
                <p>エネルギーをいかに保持しながら行動するかがポイントになる。</p>
                <p>エネルギーが枯渇した場合には行動不能になるので、補給地点からエネルギーを補給する必要がある。</p>
                <p>エネルギーの補給にはスキがあるため、敵に悟られないように行動しよう。</p>
            </section>
          </section>
  
          <section id="game-rule">
            <div class="page-header">
              <h3>ゲームルール & 詳細</h3>
            </div>
            <section id="game-rule-overview">
            <dl>
                <dt>全体図</dt>
                <?php echo $this->Html->image("document/game/game-screen.png"); ?>
            </dl>
            </section>

            <section id="game-rule-hp-energy">
            <dl>
                <dt>自機のHPとエネルギー①</dt>
                <dd>HP は最大値6、エネルギーは最大値 240</dd>
                <ul class="list-unstyled">HP
                    <ul>
                        <li>敵のショットでダメージを受けると HP が減る</li>
                        <li>HP が 0 になった場合は負けになる</li>
                    </ul>
                </ul>
                <ul class="list-unstyled">エネルギー
                    <ul>
                        <li>移動やショットなどの動作に必要な値</li>
                        <li>移動に必要なエネルギーが 8 だった場合は現在のエネルギーから 8 消費して移動することができる</li>
                        <li>エネルギーが足りない場合には行動できず、次の行動に移る</li>
                        <li>エネルギーを回復する方法は主に２つある
                        <ul>
                            <li>一定時間ごとに回復する</li>
                            <li>ステージの盤面からエネルギーを補給する</li>
                        </ul>
                        </li>
                        <li>2つ目については後述詳細を述べる</li>
                    </ul>
                </ul>

                <dt>敵機のHPとエネルギー②</dt>
                <dd>「自機のHPとエネルギー①」と同じなので説明を省略する。</dd>
            </dl>
            </section>

            <section id="game-rule-stage">
            <dl>
                <dt>ステージ③</dt>
                <dd>7 X 9の盤面でステージは構成されている。盤面は正方形ではなく、正六角形のタイルで構成されている。</dd>
                <dd>そのため移動が上下左右ではなく、6 方向に移動できる。</dd>
                <dd>
                盤面が正六角形なため盤面の端は行数によって移動できる範囲が異なる。
                <ul class="list-unstyled">
                    <li>奇数行目
                    <ul>
                        <li>右端 : 右上か右下に移動することができる</li>
                        <li>左端 : 左上か左下に移動することができない</li>
                    </ul>
                    </li>
                    <li>偶数行目
                    <ul>
                        <li>右端 : 右上か右下に移動することができない</li>
                        <li>左端 : 左上か左下に移動することができる</li>
                    </ul>
                    </li>
                </ul>
                </dd>
                <dd>例えば、左端の場合は以下の図のようになる</dd>
                </br>
                <?php echo $this->Html->image("document/game/map-end-explain.png"); ?>
                </br>
                </br>
                <dd>また各マスにはエネルギーが存在しており、戦闘機はエネルギーが枯渇した場合、各マスからエネルギーを補給する。</dd>
                <dd>マスからエネルギーを補給した場合、その分貯蔵しているエネルギーは減る。</dd>
                <dd>しかし、一定時間ごとに減った分のエネルギーが回復する。</dd>
                <dd>エネルギーが補給されたマスは色で判断することができ、枯渇している分だけ色は濃くなる。</dd>
                </br>
                <?php echo $this->Html->image("document/game/map-energy.png"); ?>
            </dl>
            </section>

            <section id="game-rule-fighter">
            <dl>
                <dt>自機④</dt>
                <dd>プレイヤー。プログラムで動かす、戦闘機</dd>
                <dd>主に以下の行動ができる</dd>
                <ul class="list-unstyled">行動
                    <li>
                    <ul>
                        <li>移動 : 隣接したマスに移動する</li>
                        <li>ショット : 自機から弾丸を発射する 敵機に弾丸を当てた場合ダメージを与え HP が減らすことができる</li>
                        <li>敵の探索 : 敵がショットの射程圏内にいるか探索する</li>
                        <li>エネルギーの補給 : 現在いるマスからエネルギーを補給する</li>
                        <li>バリアー : バリアーをはる バリアーをはっているときに相手の弾丸が当たった場合、吸収して HP と エネルギーを回復する</li>
                        <li>etc</li>
                    </ul>
                    </li>
                </ul>

                <dt>敵機⑤</dt>
                <dd>自機と同じなので、説明を省略する。</dd>
            </dl>
            </section>

            <section id="game-rule-msg">
            <dl>
                <dt>メッセージボックス⑥</dt>
                <dd>自機の行動のログを出力する。</dd>
                <dd>ログは最大 4 件まで表示される。</dd>
                <dd>行動のログの後には自機の HP とエネルギーを表示する。</dd>
                </br>
                <?php echo $this->Html->image("document/game/msgbox.png"); ?>
            </dl>
            <br>
            </section>

            <section id="game-rule-flow">
              <h4>ゲームの流れ</h4>
              <hr>
              <ol>
                  <li>対戦（ゲーム）を行う相手のプログラムを選択する</li>
                  <li>ゲームに使用するプログラムを自分で作成した中から選択する</li>
                  <li>ゲーム開始前は自機は (1,1) 敵機は (8, 6)に配置される</li>
                  <li>ゲーム開始ボタンを押すとゲームは進行する</li>
                  <li>ゲームはリアルタイムに進行し、戦闘機は指定されたフレームとエネルギー消費して行動（移動、ショット等）する</li>
                  <li>ゲームはどちらかの HP が 0 になる、もしくは 120 秒（2分）経過するまで行われる</li>
                  <li>その時に HP が多い方は勝者となる</li>
                  <li>HP が同じ場合は引き分けとし、決着がつくまで再度対戦させる</li>
              </ol>
              <p>なおゲームの結果は勝者、敗者が決定した時点で保存される。</p>
              <p>ゲーム途中でリロードや別ページに移動等を行い、ゲームを放棄した場合そのゲームの結果は負けとなる。</p>
              <p>また、高速対戦を行うことができ最大 4倍速 でゲームを進行させることができる</p>
              <h4>レート</h4>
              <p>ゲームの結果に応じて、使用したプログラムにはレートが付けられる。</p>
              <p>レートは勝率、その対戦の HP 残量、消費エネルギー量から計算される。</p>
              <p>なお、レートはランキングで使用され、そのプログラムの順位を確認することができる。</p>
            </section>
          </section>

          <!--<section id="game-instruction">
            <div class="page-header">
              <h3>命令詳細</h3>
            </div>
            <section id="game-instruction-move">
              <h4>移動</h4>
              <blockquote>
                  <p>隣接している指定したマスに移動する</p>
              </blockquote>
            </section>

            <section id="game-instruction-random-move">
              <h4>ランダム移動</h4>
              <blockquote>
                  <p>隣接しているマスにランダムに移動する</p>
              </blockquote>
            </section>

            <section id="game-instruction-approach">
              <h4>接近</h4>
              <blockquote>
                  <p>敵機に近づくように移動します</p>
              </blockquote>
            </section>

            <section id="game-instruction-leave">
              <h4>逃避</h4>
              <blockquote>
                  <p>敵機から離れるように移動します</p>
              </blockquote>
            </section>

            <section id="game-instruction-shot">
              <h4>ショット</h4>
              <blockquote>
                  <p>前方 5 マスに弾丸を発射する 敵に当たった場合には相手にダメージを与える</p>
              </blockquote>
            </section>
            </section>-->
        </div><!-- /span9 -->

        </div><!-- /row -->
        <hr>
        <br>
        <br>
    </div><!-- /container -->

    <!-- Affixに必要なコード -->
    <script>
      !function ($) {
        $(function(){
          var $window = $(window)
          $('.bs-docs-sidenav').affix({
            offset: {
              top: 0 , 
              bottom: 270
            }
          })
        })
      }(window.jQuery)
    </script>
