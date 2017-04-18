function getDistributionDetails(){
	var targetDiv = "distributionDetailsSectionDiv";
	new Ajax.Updater(targetDiv,
			contextPath+"/GICLClaimReserveController",{
		parameters:{
			action: "getDistributionDetails"
		},
		method: 'POST',
		evalScripts: true,
		asynchronous: false,
		onCreate : function(){
			$(targetDiv).hide();
		},
		onComplete : function(){
			$(targetDiv).show();
		}
	});
}