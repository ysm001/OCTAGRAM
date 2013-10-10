var ErrorChecker, ErrorData,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

ErrorChecker = (function() {
  function ErrorChecker() {
    this.init();
  }

  ErrorChecker.prototype.init = function() {
    this.stack = [];
    this.visited = [];
    return this.error = new ErrorData();
  };

  ErrorChecker.prototype.detectError = function(cpu) {
    var start;
    start = cpu.getStartPosition();
    this.init();
    this._dfs(cpu, start);
    return this.error;
  };

  ErrorChecker.prototype._dfs = function(cpu, tipPos) {
    var tip;
    tip = cpu.getTip(tipPos.x, tipPos.y);
    if (tip != null) {
      if (__indexOf.call(this.stack, tip) >= 0) {
        return this._registerCycle(cpu, tip);
      } else {
        this.stack.push(tip);
        this.visited.push(tip);
        if (tip instanceof SingleTransitionCodeTip) {
          this._dfs(cpu.getTip());
        } else if (tip instanceof BranchTransitionCodeTip) {
          this._dfs(tip.getConseq());
          this._dfs(tip.getAlter());
        }
        return this.stack.pop();
      }
    }
  };

  ErrorChecker.prototype._registerCycle = function(cpu, cycleStartTip) {
    var cycle, start;
    start = this.stack.indexOf(cycleStartTip);
    cycle = this.stack.slice(start, this.stack.length - 1);
    return this.error.cycle.push(cycle);
  };

  ErrorChecker.prototype._registerUnreachable = function() {
    var i, j, _i, _ref, _results;
    _results = [];
    for (j = _i = 0, _ref = cpu.getYnum(); 0 <= _ref ? _i < _ref : _i > _ref; j = 0 <= _ref ? ++_i : --_i) {
      _results.push((function() {
        var _j, _ref1, _results1;
        _results1 = [];
        for (i = _j = 0, _ref1 = cpu.getXnum(); 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          _results1.push(console.log(""));
        }
        return _results1;
      })());
    }
    return _results;
  };

  return ErrorChecker;

})();

ErrorData = (function() {
  function ErrorData() {
    this.cycle = [];
    this.unreachable = [];
  }

  return ErrorData;

})();
