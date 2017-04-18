/**
 * @return
 */
function toggleSearchDiv() {
	Effect.toggle("searchDiv", "appear", {
		duration : .2,
		afterFinish : function() {
			$("sublineCd").focus();
		}
	});
}