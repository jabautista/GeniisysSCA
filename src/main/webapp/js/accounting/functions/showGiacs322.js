/**
 * @Created By : John Dolon
 * @Date Created : 11.13.2013
 * @Description showGiacs335
 */
function showGiacs322(){
	new Ajax.Request(contextPath + "/GIACDocSequenceController", {
		method : "POST",
		parameters : {action 	: "showGiacs322"},
        onCreate   : showNotice("Retrieving Sequence per Branch Maintenance, please wait..."),
        onComplete : function(response){
        	hideNotice();
        	if (checkErrorOnResponse(response)) {
        		$("dynamicDiv").update(response.responseText);
        	}
        }
	});

}