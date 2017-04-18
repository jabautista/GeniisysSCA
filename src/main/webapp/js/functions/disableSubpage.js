/*
 * Created by	: Andrew
 * Date			: September 27, 2010
 * Description	: Makes the subpage background color gray and hides the link
 * Parameters	: linkId - Id of the subpage link element
 */
function disableSubpage(linkId) {
	$(linkId).hide();
	$(linkId).up("span", 0).up("div", 0).setStyle("background-color: #C0C0C0; color: #fff;");
	if($(linkId).innerHTML == "Hide"){
		fireEvent($(linkId), "click");
	}
}