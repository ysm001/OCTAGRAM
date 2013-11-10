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
	    <a href="#tutorial"><i class="icon-chevron-right"></i> チュートリアル</a>
	    <ul class="nav">
	      <li>
		<a href="#howto-set-tip"><i class="icon-chevron-right"></i> 命令チップを置いてみよう</a>
	      </li>
	      <li>
		<a href="#howto-run-program"><i class="icon-chevron-right"></i> プログラムを実行してみよう</a>
	      </li>
	      <li>
		<a href="#howto-connect-tip"><i class="icon-chevron-right"></i> 命令を繋げてみよう</a>
	      </li>
	      <li>
		<a href="#howto-loop"><i class="icon-chevron-right"></i> ループを使ってみよう</a>
	      </li>
	      <li>
		<a href="#howto-branch"><i class="icon-chevron-right"></i> 条件分岐を使ってみよう</a>
	      </li>
	      <li>
		<a href="#howto-jump"><i class="icon-chevron-right"></i> ジャンプを使ってみよう</a>
	      </li>
	      <li>
		<a href="#howto-preset"><i class="icon-chevron-right"></i> 組み込み命令を使ってみよう</a>
	      </li>
	      <li>
		<a href="#howto-var"><i class="icon-chevron-right"></i> 変数を使ってみよう</a>
	      </li>
	      <li>
		<a href="#howto-var-ope"><i class="icon-chevron-right"></i> 変数を扱う命令を使ってみよう</a>
	      </li>
	      <li>
		<a href="#howto-subroutine"><i class="icon-chevron-right"></i> サブルーチンを使ってみよう</a>
	      </li>
	    </ul>
	  </li>
	</ul>
	</div>
      </div><!-- /span3 bs-docs-sidebar -->

      <div class="col-sm-9">
	<section id="tutorial">
	  <div class="page-header">
	    <h2>チュートリアル</h2>
	    <p>本章では、<?php echo $serviceName ?>を実際に使いながら、プログラムの組み方を学んで行きます。</p>
	    <p><b class="text-danger">このチュートリアルに使われている画像は、開発中のものです。リリース時には変更される可能性があります。</b></p>
	  </div>
	  <section id="howto-set-tip">
	    <h2>命令チップを置いてみよう</h2>
	    <blockquote>
	      <p>OCTAGRAMプログラミングの基本となる命令チップについて学びます。</p>
	    </blockquote>
	    <h3 class="text-primary">命令を選択する</h3>
	    <?php echo $this->Html->image('document/tutorial/howto-set-tip_drag.png', array('class' => 'document-image'));?>
	    <p>プログラムの命令は、図のように、選択領域からプログラム編集領域へドラッグ&ドロップすることによって配置します。</p>

	    <h3 class="text-primary">命令を削除する</h3>
	    <?php echo $this->Html->image('document/tutorial/howto_remove_tip.png', array('class' => 'document-image'));?>
	    <p>配置した命令は、何も置かれていないマスをドラッグして上に乗せることで削除できます。</p>

	    <h3 class="text-primary">命令の進行方向を選択する</h3>
	    <?php echo $this->Html->image('document/tutorial/howto-rotate_arrow.png', array('class' => 'document-image'));?>
	    <p>プログラムは、チップから出ている矢印の方向へ進み、順番にプログラムを実行します。</p>
	    <p>チップを選択すると、図のように矢印の方向選択が可能になるので、矢印をドラッグしてプログラムの進行方向を調整して下さい。</p>

	    <h3 class="text-primary">命令のパラメータを設定する</h3>
	    <?php echo $this->Html->image('document/tutorial/howto_set_param.png', array('class' => 'document-image'));?>
	    <p>命令の中には、パラメータを設定できるものがあります。</p>
	    <p>パラメータを設定できる命令は、チップをクリックすることによりパラメータ編集画面を出すことができます。</p>
	    <p>例えば、進行命令のチップは、プレイヤーの進行方向を設定することができます。</p>

	    <br><br><br>
	  </section>

	  <section id="howto-run-program">
	    <h2>プログラムを実行してみよう</h2>
	    <blockquote>
	      <p>OCTAGRAMプログラムの実行の仕方と、実行の流れを学びます。</p>
	    </blockquote>
	   <h3 class="text-primary">プログラムを実行する</h3>
	    <?php echo $this->Html->image('document/tutorial/random_move.png', array('class' => 'document-image'));?>
	    <p>プログラムを実行するには、画面下部にある「<b class="text-primary">実行</b>」ボタンをクリックします。</p>
	    <p>プログラムは、画面上部にある「<b class="text-danger">Start</b>」と書かれた赤いチップから実行が始まります。</p>
	    <p>実行されたプログラムが矢印に沿って実行されて行く様子が分かります。</p>
	    <p>今回は、ランダムな方向へ移動する命令を1つ実行したので、ゲーム画面ではプレイヤーの機体がランダムな方向へ1マス移動します。</p>
	    <p>プログラムは、<b class="text-danger">何もチップが配置されていないマスへ進むと停止します。</b></p>
	    <br><br><br>
	  </section>

	  <section id="howto-connect-tip">
	    <h2>命令を繋げてみよう</h2>
	    <blockquote>
	      <p>複数の命令を組み合わせる方法を学びます。</p>
	    </blockquote>
	    <h3 class="text-primary">命令を繋ぎ合わせる</h3>
	    <p>ここまでで、命令の配置の仕方とプログラムの実行の仕方を学ぶことができました。</p>
	    <p>さらに複雑なプログラムを作るために、複数の命令を配置してみましょう。</p>
	    <?php echo $this->Html->image('document/tutorial/multi_tip.png', array('class' => 'document-image'));?>
	    <p>命令を複数繋げるには、命令の進行方向に別の命令を配置するだけです。</p>
	    <p>図のように、ランダムな方向へ移動する命令を2つ繋げて実行してみましょう。</p>
	    <p>ゲーム画面では、ランダムな方向へプレイヤーが2マス移動します。</p>
	    <p>同様に、ランダム移動命令を3つ繋げれば3マス、4つ繋げれば4マス移動します。</p>
	    <p>これが出来たら、もっと色々な命令を組み合わせて遊んでみましょう。</p>
	    <br><br><br>
	  </section>

	 <section id="howto-loop">
	   <h2>ループを使ってみよう</h2>
	   <blockquote>
	     <p>プログラミングの基本的な制御構造であるループについて学びます。</p>
	   </blockquote>
	   <h3 class="text-primary">ループとは</h3>
	   <p>プログラミングにおけるループとは、特定の処理を繰り返す制御構造のことです。</p>
	   <h3 class="text-primary">ループを作ってみよう</h3>
	    <?php echo $this->Html->image('document/tutorial/howto_loop1.png', array('class' => 'document-image'));?>
	   <p>OCTAGRAMにおけるループは、命令をループ状に繋げることによって表現できます。</p>
	   <p>例えば、ランダム移動命令を図のように繋げることで、ランダム移動命令を無限に繰り返すことが可能になります。</p>
	   <p>また、上記のループは次のように簡潔に書く事が可能です。</p>
	    <?php echo $this->Html->image('document/tutorial/howto_loop2.png', array('class' => 'document-image'));?>
	   <br><br><br>
	 </section>
	 <br><br><br>
	</section>

	  <section id="howto-branch">
	    <h2>条件分岐を使ってみよう</h2>
	    <blockquote>
	      <p>プログラミングの基本的な制御構造である条件分岐について学びます。</p>
	    </blockquote>
	    <h3 class="text-primary">条件分岐とは</h3>
	    <p>プログラミングにおける条件分岐とは、ある条件によってプログラムの動作内容を変える事です。</p>
	    <p>現実世界の例で例えるなら、「今日の天気が晴れなら、買い物に行こう。そうでなければ、家に居よう。」といった動作が条件分岐です。</p>
	    <p>「今日の天気が晴れ」という条件が満たされたとき、「買い物に行く」という動作をし、条件が満たされなかったとき、「家にいる」というように、条件によって動作を分岐させます。</p>
	    <?php echo $this->Html->image('document/tutorial/howto_branch.png', array('class' => 'document-image'));?>
	    <p>OCTAGRAMでは、条件分岐を条件分岐チップで表現します。</p>
	    <p>条件分岐チップは、通常の命令チップとは異なり青と赤の矢印を持っています。</p>
	    <p><b class="text-primary">条件が満たされた場合青矢印</b>、<b class="text-danger">条件が満たされなかった場合赤矢印</b>へ進みます。</p>
	    <br><br><br>
	  </section>
	  <br><br><br>
	</section>

	 <section id="howto-jump">
	   <h2>ジャンプを使ってみよう</h2>
	   <blockquote>
	     <p>プログラミングの基本的な命令であるジャンプについて学びます。</p>
	   </blockquote>
	   <h3 class="text-primary">ジャンプとは</h3>
	   <p>プログラミングにおけるジャンプ命令とは、ある命令から他のある命令へ飛ぶことのできる命令です。</p>
	   <h3 class="text-primary">ジャンプを使ってみよう</h3>
	   <p>OCTAGRAMにおけるジャンプ命令は一種類(リターン命令)だけです。</p>
	   <p>リターン命令が実行されると、プログラムの開始地点までジャンプします。</p>
	    <?php echo $this->Html->image('document/tutorial/howto_return.png', array('class' => 'document-image'));?>
	   <p>試しに、ランダム移動命令の次にリターン命令を置いてみましょう。</p>
	   <p>実行すると、ランダム移動命令で移動したあと、リターン命令によってプログラムの開始地点まで戻っていること分かります。</p>
	    <?php echo $this->Html->image('document/tutorial/howto_return2.png', array('class' => 'document-image'));?>
	   <p>また、プログラム領域の外枠部にはリターン命令が埋め込まれており、プログラム領域から外へ進もうとすると、プログラムの開始地点にジャンプします。</p>
	   <p>よって、上記のプログラムもランダム移動したあと、リターン命令によってプログラムの開始地点まで戻ります。</p>
	   <br><br><br>
	 </section>
	</section>

	<section id="howto-preset">
	   <h2>組み込み命令を使ってみよう</h2>
	   <blockquote>
	     <p>特殊な命令の扱いについて学びます。</p>
	   </blockquote>
	   <h3 class="text-primary">ノップチップ</h3>
	    <?php echo $this->Html->image('document/tutorial/howto_nop.png', array('class' => 'document-image'));?>
	   <p>何もせずに次へ進む命令です。</p>
	   <p>遠距離の命令を繋ぎたい場合などに使います。</p>
	   <br><br><br>
	 </section>
	 <br><br><br>
	</section>

	<section id="howto-var">
	   <h2>変数を使ってみよう</h2>
	   <blockquote>
	     <p>プログラミングの重要な要素である変数の扱い方について学びます。</p>
	   </blockquote>
	   <h3 class="text-danger">準備中</h3>
	   <br><br><br>
	 </section>
	 <br><br><br>
	</section>

	<section id="howto-var-ope">
	   <h2>変数を扱う命令を使ってみよう</h2>
	   <blockquote>
	     <p>プログラミングの重要な要素である引数の扱い方について学びます。</p>
	   </blockquote>
	   <h3 class="text-danger">準備中</h3>
	   <br><br><br>
	 </section>
	 <br><br><br>
	</section>

	<section id="howto-subroutine">
	   <h2>サブルーチンを使ってみよう</h2>
	   <blockquote>
	     <p>プログラミングの重要な要素であるサブルーチン(関数)について学びます。</p>
	   </blockquote>
	   <h3 class="text-danger">準備中</h3>
	   <br><br><br>
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
