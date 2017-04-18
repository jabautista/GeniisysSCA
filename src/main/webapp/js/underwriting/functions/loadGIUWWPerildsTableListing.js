//belle 07.11.2011 loads the table grid listing for giuw_perilds (GIUWS018)
function loadGIUWWPerildsTableListing(){
	var url = contextPath+"/GIUWWPerildsController?action=showGIUWWPerildsTableListing";
	
	if(objGIPIPolbasicPolDistV1 != null){
		url = url+"&policyId="+objGIPIPolbasicPolDistV1.policyId+"&distNo="+objGIPIPolbasicPolDistV1.distNo;
	}	
	
	new Ajax.Updater("giuwwPerildsTableGridDiv", url, {
		method: "POST",
		evalScripts: true,
		asynchronous: false,
		onComplete: function(){
			hideNotice();
		}
	});

}