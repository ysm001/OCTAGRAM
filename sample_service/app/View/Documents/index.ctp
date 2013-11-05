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
        </ul>
        </div>
      </div><!-- /span3 bs-docs-sidebar -->
                
      <div class="col-sm-9">
        <section id="header1">
          <div class="page-header">
            <h1>OCTAGRAMの命令</h2>
          </div>

          <section id="sub-header1-1">
            <h2>動作命令</h2>
            <p>キャラクターなどを動作させる命令です。</p>
            <br><br><br>
          </section>

          <section id="sub-header1-2">
            <h2>分岐命令</h2>
            <p>条件によって進行方向を変化させる命令です。</p>
            <br><br><br>
          </section>

          <section id="sub-header1-3">
            <h2>組み込み命令</h2>
            <p>あらかじめシステムに用意されている命令です。</p>
            <section id="sub-header1-3-1">
              <h3 class="text-primary">停止</h3>
               <p>プログラムを停止させます。</p>
               <br><br><br>
            </section>
            <section id="sub-header1-3-2">
              <h3 class="text-primary">ノップ</h3>
              <p>何もしないで次へ進みます。</p>
              <p>遠距離のチップ同士を接続する時などに利用します。</p>
              <br><br><br>
            </section>
            <section id="sub-header1-3-2">
              <h3 class="text-primary">リターン</h3>
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


      </div><!-- /span9 -->
                    
      </div><!-- /row -->
             <br>
          <br>
          <br>     <br>
          <br>
          <br>     <br>
          <br>
          <br>     <br>
          <br>
          <br>     <br>
          <br>
          <br>     <br>
          <br>
          <br>     <br>
          <br>
          <br>     <br>
          <br>
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
