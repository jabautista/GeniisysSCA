//toggle the display of an element thru provided effect
//parmaters: 
//id: id of the element to be hidden
//duration: how long the effect would be
//effect: valid values are: appear, blind, slide
//callback: name of the function to be called after fading
function toggleDisplayElement(id, duration, effect, callback) {
	Effect.toggle(id, effect, {
		duration: duration,
		afterFinish: function () {
			if (null != callback) {
				callback();
			}
		}
	});
}