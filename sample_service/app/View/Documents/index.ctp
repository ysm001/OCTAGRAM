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
	    <a href="#header1"><i class="icon-chevron-right"></i> Header1</a>
            <ul class="nav">
	      <li>
	        <a href="#sub-header1"><i class="icon-chevron-right"></i> Sub Header1</a>
              </li>
            </ul>
            <ul class="nav">
	      <li>
	        <a href="#sub-header2"><i class="icon-chevron-right"></i> Sub Header2</a>
              </li>
            </ul>

          </li>
          <li><a href="#header2"><i class="icon-chevron-right"></i> Header2</a></li>
          <li><a href="#header3"><i class="icon-chevron-right"></i> Header3</a></li>
          <li><a href="#header4"><i class="icon-chevron-right"></i> Header4</a></li>
          <li><a href="#header5"><i class="icon-chevron-right"></i> Header5</a></li>
        </ul>
        </div>
      </div><!-- /span3 bs-docs-sidebar -->
                
      <div class="col-sm-9">
        <section id="header1">
          <div class="page-header">
            <h2>Header1</h2>
          </div>
          <h3>Text1</h3>
          <h3>Text1</h3>
          <h3>Text1</h3>
          <h3>Text1</h3>
          <h3>Text1</h3>
          <h3>Text1</h3>
          <br>
          <br>
          <br>

          <section id="sub-header1">
            <h3>Sub Header1</h3>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <br>
            <br>
            <br>
          </section>

          <section id="sub-header2">
            <h3>Sub Header2</h3>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <h4>Text1</h4>
            <br>
            <br>
            <br>
          </section>


          <br>
          <br>
          <br>
        </section>
        <section id="header2">
          <div class="page-header">
            <h2>Header2</h2>
          </div>
          <h3>Text2</h3>
          <br>
          <br>
          <br>
        </section>
        <section id="header3">
          <div class="page-header">
            <h2>Header3</h2>
          </div>
          <h3>Text3</h3>
          <br>
          <br>
          <br>
        </section>
        <section id="header4">
          <div class="page-header">
            <h2>Header4</h2>
          </div>
          <h3>Text4</h3>
          <br>
          <br>
          <br>
        </section>
        <section id="header5">
          <div class="page-header">
            <h2>Header5</h2>
          </div>
          <h3>Text5</h3>
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
