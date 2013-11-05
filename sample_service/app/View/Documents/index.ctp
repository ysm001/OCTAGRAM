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
	      <li><a href="#sub-header1-45"><i class="icon-chevron-right"></i> 変数操作命令</a>
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
            <br><br><br>
          </section>

          <section id="sub-header1-2">
            <h2>分岐命令</h2>
            <br><br><br>
          </section>

          <section id="sub-header1-3">
            <h2>組み込み命令</h2>
            <br><br><br>
          </section>

          <section id="sub-header1-4">
            <h2>変数操作命令</h2>
            <section id="sub-header1-4-1">
              <h3>変数への代入</h3>
               <br><br><br>
            </section>

            <section id="sub-header1-4-2">
              <h3>変数の四則演算</h3>
               <br><br><br>
            </section>
          </section>

          <section id="sub-header1-5">
            <h2>変数を扱う命令</h2>
            <section id="sub-header1-5-1">
              <h3>変数を扱う動作命令</h3>
               <br><br><br>
            </section>

            <section id="sub-header1-5-2">
              <h3>変数を扱う分岐命令</h3>
               <br><br><br>
            </section>
          </section>

          <section id="sub-header1-6">
            <h2>サブルーチン</h2>
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
