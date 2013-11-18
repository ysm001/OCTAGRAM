function gra_rgb(b,a){ return gra(b,a,parse_rgb,build_rgb) }
function gra_hexcolor(b,a){ return gra(b,a,parse_hexcolor,build_hexcolor) }

function gra(b,a,parser,builder){
  var d = mop.apply(this,[b,a].map(parser));
  return function(i){ return builder([d[0](i),d[1](i),d[2](i)]); }
}

function mop(b,a){ return b.map(function(x,v){ var s=a[v]-x; return function(i){return Math.ceil(x+s*i) }}) }
function parse_rgb(c){ var r=/rgb\(\s*([0-9]+)\s*,\s*([0-9]+)\s*,\s*([0-9]+)/(c); return r&&r.shift()&&r.map(function(i){return parseInt(i)}) }
function parse_hexcolor(c){ return [0,1,2].map(function(j){ return parseInt(c[j*2+1]+c[j*2+2],16) }) }
function build_rgb(c){ return "rgb("+c+")" }
function build_hexcolor(c){ return "#"+c.map(hex2).join("") }
function hex2(i){return ((i<16)?"0":"")+i.toString(16)}
Array.prototype.map=function(f){
  var ret=[];
  for(var i=0;i<this.length;i++) ret.push(f(this[i],i,this));
  return ret;
}

