class Octagram
  constructor : (path) ->
    @core = null

    $octagramContent = $('<iframe seamless></iframe>').attr('id', 'octagram-content')
                                                      .attr('src', path + '/content.html')
                                                      .attr('width', '640')
                                                      .attr('height', '640')

    $('#octagram').append($octagramContent)
    contentWindow = $octagramContent[0].contentWindow
    contentWindow.octagram = @

  onload : () ->
