//Fons 10.11.2013	View Production Details
function showProductionDetails(lineCd,sublineCd,issCd,issueYy,intmNo,credIss,paramDate,fromDate,toDate,month,year,distFlag,regPolicySw){
	new Ajax.Request(contextPath + "/GIPIPolbasicController", {
	    parameters : {action : "getProductionDetails",
	    				lineCd : lineCd,
	    				sublineCd : sublineCd,
	    				issCd : issCd,
	    				issueYy : issueYy,
	    				intmNo : intmNo,
	    				credIss : credIss,
	    				paramDate : paramDate,
	    				fromDate : fromDate,
	    				toDate : toDate,
	    				month : month,
	    				year : year,
	    				distFlag : distFlag,
	    				regPolicySw : regPolicySw
	    },
	    onCreate: showNotice("Loading Production Details,  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showProductionDetails - onComplete : ", e);
			}								
		} 
	});
}