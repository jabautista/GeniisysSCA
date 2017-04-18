/* Created by: Andrew
** Date Created: 09.14.2010
** Description: Truncates long texts according to the specified length
** Parameters:  elementType - type of element
** 				elementName - name of element
**				length		- desired length
*/
function truncateLongDisplayTexts2(elementType, elementName, length) {
	$$(elementType+"[name='"+elementName+"']").each(function (a) {
		if (a.innerHTML.length >= length) {
			a.update(a.innerHTML.truncate(length, "..."));
		}
	});
}