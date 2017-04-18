/*
 * Created by	: Andrew
 * Date			: September 28, 2010
 * Description	: Removes the gray background-color of subpage and shows the link
 * Parameters	: linkId - Id of the subpage link element
 */
function enableSubpage(linkId) {
	$(linkId).show();
	$(linkId).up("span", 0).up("div", 0).setStyle({backgroundColor: "", color: ""});
}