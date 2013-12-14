// Generated by CoffeeScript 1.6.3
var Frontend, JsCodeViewer, getCurrentProgram,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

getCurrentProgram = function() {
  return Game.instance.octagram.getCurrentInstance();
};

JsCodeViewer = (function() {
  function JsCodeViewer() {
    this.editor = null;
    this.preCursor = null;
  }

  JsCodeViewer.prototype.show = function(lines) {
    this.editor = ace.edit('js-viewer');
    this.editor.setTheme('ace/theme/monokai');
    this.editor.getSession().setMode("ace/mode/javascript");
    this.update(lines);
    return this.editor.setReadOnly(true);
  };

  JsCodeViewer.prototype.update = function(lines) {
    var code, line, selection, text,
      _this = this;
    this.unHighlite(lines);
    selection = this.editor.getSelection();
    selection.removeAllListeners('changeCursor');
    text = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = lines.length; _i < _len; _i++) {
        line = lines[_i];
        _results.push(line.text);
      }
      return _results;
    })();
    code = text.join('\n');
    this.editor.getSession().setValue(code);
    return selection.on('changeCursor', function() {
      return _this.changeHighlite(_this.editor.getCursorPosition(), lines);
    });
  };

  JsCodeViewer.prototype.hide = function(lines) {
    this.unHighlite(lines);
    return this.editor.destroy();
  };

  JsCodeViewer.prototype.changeHighlite = function(pos, lines) {
    if (this.preCursor != null) {
      this.unHighliteLine(lines[this.preCursor.row]);
    }
    this.highliteLine(lines[pos.row]);
    return this.preCursor = pos;
  };

  JsCodeViewer.prototype.unHighlite = function(lines) {
    var line, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = lines.length; _i < _len; _i++) {
      line = lines[_i];
      _results.push(this.unHighliteLine(line));
    }
    return _results;
  };

  JsCodeViewer.prototype.highliteLine = function(line) {
    var n, _i, _len, _ref, _results;
    if ((line != null) && (line.node != null)) {
      _ref = line.node;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        n = _ref[_i];
        if (n != null) {
          _results.push(n.showExecutionEffect());
        }
      }
      return _results;
    }
  };

  JsCodeViewer.prototype.unHighliteLine = function(line) {
    var n, _i, _len, _ref, _results;
    if ((line != null) && (line.node != null)) {
      _ref = line.node;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        n = _ref[_i];
        if (n != null) {
          _results.push(n.hideExecutionEffect());
        }
      }
      return _results;
    }
  };

  return JsCodeViewer;

})();

Frontend = (function() {
  function Frontend(options) {
    this.options = options;
    this.updateJs = __bind(this.updateJs, this);
    this.programStorage = new ProgramStorage();
    this.playerRunning = false;
    this.enemyRunning = false;
    this.currentProgramName = "";
    this.viewer = null;
  }

  Frontend.prototype.getPlayerProgram = function() {
    return Game.instance.octagram.getInstance(Game.instance.currentScene.world.playerProgramId);
  };

  Frontend.prototype.getEnemyProgram = function() {
    return Game.instance.octagram.getInstance(Game.instance.currentScene.world.enemyProgramId);
  };

  Frontend.prototype.showPlayerProgram = function() {
    Game.instance.octagram.showProgram(Game.instance.currentScene.world.playerProgramId);
    return this.updateJs();
  };

  Frontend.prototype.showEnemyProgram = function() {
    Game.instance.octagram.showProgram(Game.instance.currentScene.world.enemyProgramId);
    return this.updateJs();
  };

  Frontend.prototype.resetProgram = function(onReset) {
    var restart;
    this.stopProgram();
    restart = function() {
      if (!this.playerRunning && !this.enemyRunning) {
        Game.instance.currentScene.restart();
        if (onReset) {
          return onReset();
        }
      } else {
        return setTimeout(restart, 100);
      }
    };
    return setTimeout(restart, 100);
  };

  Frontend.prototype.restartProgram = function() {
    var _this = this;
    return this.resetProgram(function() {
      return _this.executeProgram();
    });
  };

  Frontend.prototype.editPlayerProgram = function() {
    $('#edit-player-program').hide();
    $('#edit-enemy-program').show();
    $('#program-container').css('border-color', '#5cb85c');
    return this.showPlayerProgram();
  };

  Frontend.prototype.editEnemyProgram = function() {
    $('#edit-player-program').show();
    $('#edit-enemy-program').hide();
    $('#program-container').css('border-color', '#d9534f');
    return this.showEnemyProgram();
  };

  Frontend.prototype.saveProgram = function(override) {
    var _this = this;
    if (override == null) {
      override = false;
    }
    return this.programStorage.saveProgram(override, this.currentProgramName, function(data) {
      return _this.currentProgramName = data.name;
    });
  };

  Frontend.prototype.deleteProgram = function() {
    return this.programStorage.deleteProgram();
  };

  Frontend.prototype.loadProgram = function() {
    var _this = this;
    this.stopJsAutoUpdate();
    return this.programStorage.loadProgram(function(data) {
      _this.currentProgramName = data.name;
      if (data.status === 'complete') {
        _this.startJsAutoUpdate();
        return _this.updateJs();
      }
    });
  };

  Frontend.prototype.loadProgramById = function(id, callback) {
    return this.programStorage.loadProgramById(id, callback);
  };

  Frontend.prototype.getContentWindow = function() {
    return $('iframe')[0].contentWindow;
  };

  Frontend.prototype.executeProgram = function() {
    var onStop,
      _this = this;
    this.playerRunning = true;
    this.enemyRunning = true;
    onStop = function() {
      if (!_this.playerRunning && !_this.enemyRunning && (_this.options != null) && (_this.options.onStop != null)) {
        return _this.options.onStop();
      }
    };
    this.getPlayerProgram().execute({
      onStop: function() {
        _this.playerRunning = false;
        return onStop();
      }
    });
    return this.getEnemyProgram().execute({
      onStop: function() {
        _this.enemyRunning = false;
        return onStop();
      }
    });
  };

  Frontend.prototype.stopProgram = function() {
    this.getPlayerProgram().stop();
    return this.getEnemyProgram().stop();
  };

  Frontend.prototype.getCurrentCode = function() {
    var generator, instance;
    instance = getCurrentProgram();
    generator = new JsGenerator();
    return generator.generate(instance.cpu);
  };

  Frontend.prototype.showJsWithDialog = function() {
    var lines, template, viewer;
    lines = this.getCurrentCode();
    template = '<html>' + '<head>' + '</head>' + '<body>' + '<div id="editor-div" style="height: 500px; width: 500px"></div>' + '</body>' + '</html>';
    viewer = new JsCodeViewer();
    bootbox.alert(template, function() {
      return viewer.hide(lines);
    });
    return viewer.show(lines);
  };

  Frontend.prototype.updateJs = function() {
    if (this.viewer != null) {
      return this.viewer.update(this.getCurrentCode());
    }
  };

  Frontend.prototype.stopJsAutoUpdate = function() {
    return getCurrentProgram().removeEventListener('changeOctagram', this.updateJs);
  };

  Frontend.prototype.startJsAutoUpdate = function() {
    return getCurrentProgram().addEventListener('changeOctagram', this.updateJs);
  };

  Frontend.prototype.showJs = function() {
    $('#enchant-stage').hide();
    $('#js-viewer').show();
    this.viewer = new JsCodeViewer();
    this.viewer.show(this.getCurrentCode());
    this.stopJsAutoUpdate();
    return this.startJsAutoUpdate();
  };

  Frontend.prototype.hideJs = function() {
    var lines;
    lines = this.getCurrentCode();
    this.viewer.hide(lines);
    $('#enchant-stage').show();
    $('#js-viewer').remove();
    $('#program-container').append($('<div id="js-viewer"></div>'));
    this.stopJsAutoUpdate();
    return this.viewer = null;
  };

  return Frontend;

})();

$(function() {
  var frontend,
    _this = this;
  frontend = new Frontend({
    onStop: function() {}
  });
  $('#edit-player-program').click(function() {
    $('#target-label-enemy').hide();
    $('#target-label-player').show();
    $('#save').removeAttr('disabled');
    return frontend.editPlayerProgram();
  });
  $('#edit-enemy-program').click(function() {
    $('#target-label-enemy').show();
    $('#target-label-player').hide();
    $('#save').attr('disabled', 'disabled');
    return frontend.editEnemyProgram();
  });
  $('#save').click(function() {
    return frontend.saveProgram();
  });
  $('#load').click(function() {
    return frontend.loadProgram();
  });
  $('#delete').click(function() {
    return frontend.deleteProgram();
  });
  $('#run').click(function() {
    frontend.executeProgram();
    $('#run').attr('disabled', 'disabled');
    $('#show-js').attr('disabled', 'disabled');
    $('#stop').removeAttr('disabled');
    return $('#restart').removeAttr('disabled');
  });
  $('#stop').click(function() {
    frontend.resetProgram();
    $('#run').removeAttr('disabled');
    $('#show-js').removeAttr('disabled');
    $('#stop').attr('disabled', 'disabled');
    return $('#restart').attr('disabled', 'disabled');
  });
  $('#restart').click(function() {
    return frontend.restartProgram();
  });
  $('#show-js').click(function() {
    $('#show-js').attr('disabled', 'disabled');
    $('#hide-js').removeAttr('disabled');
    $('#run').attr('disabled', 'disabled');
    return frontend.showJs();
  });
  return $('#hide-js').click(function() {
    $('#hide-js').attr('disabled', 'disabled');
    $('#show-js').removeAttr('disabled');
    $('#run').removeAttr('disabled');
    return frontend.hideJs();
  });
});
