// hide an element thru fading effect
//parmaters: 
// id: id of the element to be hidden
// duration: how long the effect would be
// callback: name of the function to be called after fading
function fadeElement(id, duration, callback) {
	Effect.Fade(id, {
		duration: duration,
		afterFinish: function () {
			if (null != callback) {
				callback();
			}
		}
	});
}