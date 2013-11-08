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
          <p>テキスト</p>
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
