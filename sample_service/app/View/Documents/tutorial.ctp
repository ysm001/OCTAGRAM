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
                <a href="#howto-branch"><i class="icon-chevron-right"></i> 条件分岐を使ってみよう</a>
              </li>
              <li>
                <a href="#howto-loop"><i class="icon-chevron-right"></i> ループを使ってみよう</a>
              </li>
              <li>
                <a href="#howto-branch-loop"><i class="icon-chevron-right"></i> 条件付きループを使ってみよう</a>
              </li>
              <li>
                <a href="#howto-preset"><i class="icon-chevron-right"></i> 組み込み命令を使ってみよう</a>
              </li>
              <li>
                <a href="#howto-var"><i class="icon-chevron-right"></i> 変数を使ってみよう</a>
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
          </div>
          <section id="howto-set-tip">
	    <h2>命令チップを置いてみよう</h2>
            <blockquote>
              <p>OCTAGRAMプログラミングの基本となる命令チップについて学びます。</p>
            </blockquote>
            <h3 class="text-primary">命令を選択する</h3>
            <br><br><br>
          </section>

          <section id="howto-run-program">
	    <h2>プログラムを実行してみよう</h2>
            <blockquote>
              <p>OCTAGRAMプログラムの実行の仕方と、実行の流れを学びます。</p>
            </blockquote>
            <h3 class="text-primary">動作命令チップ</h3>
            <br><br><br>
          </section>

          <section id="howto-branch">
	    <h2>条件分岐を使ってみよう</h2>
            <blockquote>
              <p>プログラミングの基本的な制御構造である条件分岐について学びます。</p>
            </blockquote>
            <h3 class="text-primary">動作命令チップ</h3>
            <br><br><br>
          </section>
          <br><br><br>
        </section>

         <section id="howto-loop">
	   <h2>ループを使ってみよう</h2>
           <blockquote>
             <p>プログラミングの基本的な制御構造であるループについて学びます。</p>
           </blockquote>
           <h3 class="text-primary">動作命令チップ</h3>
           <br><br><br>
         </section>
         <br><br><br>
        </section>

        <section id="howto-branch-loop">
	   <h2>条件分岐付きループを使ってみよう</h2>
           <blockquote>
             <p>条件分岐とループの組み合わせについて学びます。</p>
           </blockquote>
           <h3 class="text-primary">動作命令チップ</h3>
           <br><br><br>
         </section>
         <br><br><br>
        </section>

        <section id="howto-preset">
	   <h2>組み込み命令を使ってみよう</h2>
           <blockquote>
             <p>特殊な命令チップの扱いについて学びます。。</p>
           </blockquote>
           <h3 class="text-primary">動作命令チップ</h3>
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

        <section id="howto-subroutine">
	   <h2>サブルーチンを使ってみよう</h2>
           <blockquote>
             <p>プログラミングの重要な要素であるサブルーチン(関数)について学びます。。</p>
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
