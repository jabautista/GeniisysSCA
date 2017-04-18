/**
* Shows checks paid per department
* @author Gzelle
* @date 09.19.2013
* 
*/
function showChecksPaidPerDepartment(){
	try{
		new Ajax.Request(contextPath+"/GIACInquiryController",{
			method: "POST",
			parameters : {action : "showChecksPaidPerDepartment"},
			asynchronous: false,
			evalScripts: true,
			onCreate: function (){
				showNotice("Loading Checks Paid per Department, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showChecksPaidPerDepartment", e);
	}
}