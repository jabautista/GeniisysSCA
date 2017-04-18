/**
 * Loads the tableGrid listing of GIUW_WITEMDS records
 * ModuleId: GIUWS010
 * 
 */
function loadGIUWWitemdsTableListing(){
	var url = contextPath+"/GIUWWitemdsController?action=showGIUWWitemdsTableListing";

	if(objGIPIPolbasicPolDistV1 != null){
		url = url+"&policyId="+objGIPIPolbasicPolDistV1.policyId+"&distNo="+objGIPIPolbasicPolDistV1.distNo;
	}
	
	new Ajax.Updater("giuwWItemdsTableGridDiv", url, {
		method: "POST",
		evalScripts: true,
		asynchronous: false,
		onComplete: function(){
			hideNotice();
		}
	});
}