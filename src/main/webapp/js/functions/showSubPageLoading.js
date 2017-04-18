// andrew 06.25.10
// Shows 'Loading...' label replacing the 'Show/Hide' link of subpage.
// Parameters: linkId - id of the subpage 'Show/Hide' link.
//			   bool - true if you want to show 'Loading...' and false to remove loading and show the link again. 
function showSubPageLoading(linkId, bool){
	try {
		if (bool) {
			setCursor("wait");
			$(linkId).up("span").insert({after:	'<label id="loading" style="cursor: wait; float: right; margin-left: 5px;">Loading...</label>'});
			$(linkId).up("span").hide();		
		} else {
			setCursor("default");
			$(linkId).up("span").next("label", 0).remove();
			$(linkId).up("span").show();
		}
	} catch (e) {
		showErrorMessage("showSubPageLoading", e);
		//showMessageBox("showSubPageLoading : " + e.message);
	}
}