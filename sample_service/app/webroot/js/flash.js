var Flash = (function() {
    "use strict";

    var elem,
    hideHandler,
    selector='.bb-alert',
    that = {};

    that.init = function() {
    };

    that.show = function(text, cls) {
	elem = $('<div></div>').attr('class', 'bb-alert alert ' + cls);
	elem.append('<span></span>');
	$('body').append(elem)

	clearTimeout(hideHandler);

	elem.find("span").html(text);
	elem.delay(200).fadeIn().delay(4000).fadeOut(function() {elem.remove();});
    };

    that.showSuccess = function(text) {
	that.show(text, 'alert-success');
    };

    that.showError = function(text) {
	that.show(text, 'alert-danger');
    };

    return that;
}());
