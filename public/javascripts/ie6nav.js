/* IE <= 6.9 hover li fix */

var StepNavigation = document.getElementById('stepnavigation').firstChild;
if (StepNavigation) {
	for (var i = 0; i < StepNavigation.childNodes.length; i++) {
		var TabElement = StepNavigation.childNodes[i];
		if (TabElement.tagName == 'LI' && TabElement.id != 'leftspacer' ) {
			TabElement.onmouseover = function () { this.className += ' hover'; }
			TabElement.onmouseout = function () { this.className = this.className.replace(/hover/g,''); }
		}
	}
}