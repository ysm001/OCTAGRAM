   <?php echo $this->Html->css(array('docs'), false, array('inline'=>false)); ?>
   <?php $serviceName = "Fight OCTAGRAM"  ?>
    
  <!-- Scrollspyの設定をbodyタグに記入 -->
  <body data-spy="scroll" data-target=".bs-docs-sidebar">

  <div class="container">
            
    <div class="row">
                
      <!-- 左部固定のサイドバー -->
      <div class="col-sm-3 bs-docs-sidebar">
        <div class="bs-sidebar hidden-print affix" role="complementary">
        <ul class="nav nav-list bs-sidenav bs-docs-sidenav">
	  <li>
	    <a href="#octagram-overview"><i class="icon-chevron-right"></i> OCTAGRAMの概要</a>
            <ul class="nav">
	      <li><a href="#what-is-fight-octagram"><i class="icon-chevron-right"></i> <?php echo $serviceName ?>とは </a></li>
	      <li><a href="#what-is-octagram"><i class="icon-chevron-right"></i> OCTAGRAMとは </a></li>
            </ul>
	    <li><a href="#how-to-octagram"><i class="icon-chevron-right"></i> OCTAGRAMの使い方 </a></li>
          </li>

	  <li>
	    <a href="#header1"><i class="icon-chevron-right"></i> OCTAGRAMの命令</a>
            <ul class="nav">
	      <li><a href="#sub-header1-1"><i class="icon-chevron-right"></i> 動作命令</a></li>
	      <li><a href="#sub-header1-2"><i class="icon-chevron-right"></i> 分岐命令</a></li>
	      <li><a href="#sub-header1-3"><i class="icon-chevron-right"></i> 組み込み命令</a></li>
	      <li><a href="#sub-header1-4"><i class="icon-chevron-right"></i> 変数操作命令</a>
                <ul class="nav">
	          <li><a href="#sub-header1-4-1"><i class="icon-chevron-right"></i> 変数への代入</a></li>
	          <li><a href="#sub-header1-4-2"><i class="icon-chevron-right"></i> 変数の四則演算</a></li>
                </ul>
              </li>
	      <li><a href="#sub-header1-5"><i class="icon-chevron-right"></i> 変数を扱う命令</a>
                <ul class="nav">
	          <li><a href="#sub-header1-5-1"><i class="icon-chevron-right"></i> 引数を持つ動作命令</a></li>
	          <li><a href="#sub-header1-5-2"><i class="icon-chevron-right"></i> 引数を持つ分岐命令</a></li>
                </ul>
              </li>
              <li><a href="#sub-header1-6"><i class="icon-chevron-right"></i> サブルーチン</a></li>
            </ul>
          </li>

	  <li>
	    <a href="#octagram-framework"><i class="icon-chevron-right"></i> OCTAGRAM Framework</a>
            <ul class="nav">
              <li>
	        <a href="#octagram-api"><i class="icon-chevron-right"></i> OCTAGRAM API</a>
              </li>
            </ul>
          </li>
        </ul>
        </div>
      </div><!-- /span3 bs-docs-sidebar -->
                
      <div class="col-sm-9">
        <section id="octagram-overview">
          <div class="page-header">
            <h1>概要</h1>
	    <p>本章では、本サービス(<?php echo $serviceName ?>)の概要と、プログラミング言語OCTAGRAMに関して説明します。</p>
          </div>

          <section id="what-is-octagram">
	  <h2><?php echo $serviceName ?>とは</h2>
            <blockquote>
              <p>プログラミング言語OCTAGRAMを使ったゲームAIプログラミングを通して、ゲーム感覚でプログラミングの考え方を学ぶwebサービス</p>
            </blockquote>
            <br><br><br>
          </section>

          <section id="what-is-octagram">
            <h2>OCTAGRAMとは</h2>
            <blockquote>
            <p>プログラミング教育を目的とした直感的なビジュアルプログラミング言語</p>
            </blockquote>
            <p>命令をパズルのように組み合わせることにより、直感的にプログラムを組む事が可能な言語です。</p>
            <br><br><br>
          </section>
        </section>

        <section id="how-to-octagram">
	  <div class="page-header">
            <h1>OCTAGRAMの使い方</h1>
            <p>本章では、OCTAGRAMの使い方について説明します。</p>
          </div>
          <h3 class="text-primary">全体図</h3>
	  <?php echo $this->Html->image('document/octagram/octagram_screen.png');?>
          <h3 class="text-primary">① プログラム編集領域</h3>
          <p>プログラムを編集する領域です。</p><br>
          <h3 class="text-primary">② 命令チップ</h3>
	   <?php echo $this->Html->image('document/octagram/octagram_tip.png');?>
          <p>プログラムを組むための命令チップです。</p>
          <p>プログラム開始地点から実行が始まり、矢印に沿って順番に命令が実行されていきます。</p>
          <p>チップが置かれていない方向へ進んだり、停止チップを実行することによってプログラムが停止します。</p>
          <p>また、プログラム編集領域の外へ進むと、プログラムの開始地点へ戻ります。</p>
          <p>命令チップの詳細な説明は「<a class="href" href="#header1">OCTAGRAMの命令</a>」を参照して下さい。</a></p>
          <br>
          <br>
	  <h3 class="text-primary">③ 命令チップ選択領域</h3>
          <p>命令チップを選択する領域です。</p>
          <p>ここから、プログラム編集領域にチップをドラッグすることによってチップを配置します。</p>
          <br>
	  <h3 class="text-primary">④ メッセージ表示領域</h3>
          <p>各種メッセージが表示される領域です。</p>
          <br><br><br>

        </section>


        <section id="header1">
          <div class="page-header">
            <h1>OCTAGRAMの命令</h1>
	    <p>本章では、<?php echo $serviceName ?>内で利用する各命令の一部について説明します。</p>
          </div>

          <section id="sub-header1-1">
            <h2>動作命令</h2>
	    <?php echo $this->Html->image('document/octagram/action_tip.png');?>
            <p>キャラクターなどを動作させる命令です。</p>
            <br>
            <h3 class="text-primary">移動命令</h3>
            <p>プレイヤーを、指定した進行方向へ移動させます。</p>
            <br>
            <h3 class="text-primary">ランダム移動命令</h3>
            <p>プレイヤーを、ランダムな進行方向へ移動させます。</p>
            <br>
            <h3 class="text-primary">接近命令</h3>
            <p>プレイヤーを、敵に近づくように移動させます。</p>
            <br>
            <h3 class="text-primary">離脱命令</h3>
            <p>プレイヤーを、敵からは慣れるように移動させます。</p>
            <br>

            <br><br><br>
          </section>

          <section id="sub-header1-2">
            <h2>分岐命令</h2>
	    <?php echo $this->Html->image('document/octagram/branch_tip.png');?>
            <p>条件によって進行方向を変化させる命令です。</p>
            <p>チップから2本の矢印が伸びており、条件によって進行方向が変わります。</p>
            <br>

            <h3 class="text-primary">ランダム分岐命令</h3>
            <p>ランダムにプログラムの進行方向を分岐させます。</p>
            <br>

            <h3 class="text-primary">残りHP分岐命令</h3>
            <p>プレイヤーの残りHPによって進行方向を分岐させます。</p>
            <br>

            <br><br><br>
          </section>

          <section id="sub-header1-3">
            <h2>組み込み命令</h2>
            <p>あらかじめシステムに用意されている命令です。</p>
            <section id="sub-header1-3-1">
              <h3 class="text-primary">停止</h3>
	       <?php echo $this->Html->image('document/octagram/stop_tip.png');?>
               <p>プログラムを停止させます。</p>
               <br><br><br>
            </section>
            <section id="sub-header1-3-2">
              <h3 class="text-primary">ノップ</h3>
	       <?php echo $this->Html->image('document/octagram/nop_tip.png');?>
              <p>何もしないで次へ進みます。</p>
              <p>遠距離のチップ同士を接続する時などに利用します。</p>
              <br><br><br>
            </section>
            <section id="sub-header1-3-2">
              <h3 class="text-primary">リターン</h3>
	       <?php echo $this->Html->image('document/octagram/return_tip.png');?>
              <p>プログラムの開始地点へ戻ります。</p>
              <br><br><br>
            </section>


            <br><br><br>
          </section>

          <section id="sub-header1-4">
            <h2>変数操作命令</h2>
            <p>変数を操作することのできる命令です。</o>
            <section id="sub-header1-4-1">
              <h3>変数への代入</h3>
              <p class="text-danger">未実装</o>
              <br><br><br>
            </section>

            <section id="sub-header1-4-2">
              <h3>変数の四則演算</h3>
              <p class="text-danger">未実装</o>
              <br><br><br>
            </section>
          </section>

          <section id="sub-header1-5">
            <h2>変数を扱う命令</h2>
            <p>変数を使った命令です。</o>
            <section id="sub-header1-5-1">
              <h3>変数を扱う動作命令</h3>
              <p class="text-danger">未実装</o>
               <br><br><br>
            </section>

            <section id="sub-header1-5-2">
              <h3>変数を扱う分岐命令</h3>
              <p class="text-danger">未実装</o>
              <br><br><br>
            </section>
          </section>

          <section id="sub-header1-6">
            <h2>サブルーチン</h2>
            <p>自分で作成したサブルーチンを呼び出す命令です。</o>
            <p class="text-danger">未実装</o>
            <br><br><br>
          </section>

          <br>
          <br>
          <br>
        </section>
        <section id="octagram-framework">
          <div class="page-header">
            <h2>OCTAGRAM Framework</h2>
            <p>本章では、フレームワークとしてのOCTAGRAMの利用法について説明します。<b class="text-danger">(開発者向け)</b></p>
          </div>
          <p>OCTAGRAMはライブラリとして利用することができ、ゲームに限らずJavaScriptで記述された任意のアプリケーションに利用することができます。</p>
          <section id="octagram-api">
            <h3>OCTAGRAM API</h3>
            <p class="text-danger">準備中</p>
          </section>
          <br><br><br>
        </section>



      </div><!-- /span9 -->
                    
      </div><!-- /row -->
          <br>
      
      <hr>
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
