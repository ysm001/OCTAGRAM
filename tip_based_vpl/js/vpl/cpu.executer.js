// Generated by CoffeeScript 1.6.3
var Executer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Executer = (function(_super) {
  __extends(Executer, _super);

  Executer.latency = 30;

  function Executer(cpu) {
    this.cpu = cpu;
    this.execNext = __bind(this.execNext, this);
    this.next = null;
    this.current = null;
  }

  Executer.prototype.getNext = function() {
    if (this.next != null) {
      return this.cpu.getTip(this.next.x, this.next.y);
    } else {
      return null;
    }
  };

  Executer.prototype._execute = function(tip) {
    if (this.current != null) {
      this.current.hideExecutionEffect();
    }
    this.current = tip;
    this.current.showExecutionEffect();
    if (this.current.isAsynchronous()) {
      this.current.code.instruction.removeEventListener('completeExecution', this.execNext);
      this.current.code.instruction.addEventListener('completeExecution', this.execNext);
    }
    if (!tip.isAsynchronous()) {
      return setTimeout(this.execNext, Executer.latency);
    }
  };

  Executer.prototype.execute = function() {
    var tip;
    tip = this.cpu.getStartTip();
    return this._execute(tip);
  };

  Executer.prototype.execNext = function(e) {
    var nextTip;
    nextTip = this.getNext();
    if ((this.current != null) && this.current.isAsynchronous() && e && (e.result != null)) {
      this.next = e.result ? this.current.code.getConseq() : this.current.code.getAlter();
      nextTip = this.getNext();
    }
    if (nextTip != null) {
      if (nextTip === this.current) {
        console.log("error : invalid execution timing.");
        this.next = this.current.code.getNext();
        nextTip = this.getNext();
      }
      return this._execute(nextTip);
    }
  };

  return Executer;

})(EventTarget);
