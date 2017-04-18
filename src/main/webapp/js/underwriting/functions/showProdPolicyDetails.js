//Fons 10.09.2013	View Production Policy Details
function showProdPolicyDetails(lineCd1,sublineCd1,issCd1,issueYy1,polSeqNo1,renewNo1,policyId,paramDate,fromDate,toDate,month,year,distFlag){
	new Ajax.Request(contextPath + "/GIPIPolbasicController", {
	    parameters : {action : "getProdPolicyDetails",
	    				lineCd1 : lineCd1,
	    				sublineCd1 : sublineCd1,
	    				issCd1 : issCd1,
	    				issueYy1 : issueYy1,
	    				polSeqNo1 : polSeqNo1,
	    			    renewNo1 : renewNo1,
	    			    policyId : policyId,
	    			    paramDate : paramDate,
	    				fromDate : fromDate,
	    				toDate : toDate,
	    				month : month,
	    				year : year,
	    				distFlag : distFlag
	    },
	    onCreate: showNotice("Loading Policy Details,  Please wait..."),
		onComplete : function(response){
			try {
				hideNotice("");
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showProdPolicyDetails - onComplete : ", e);
			}								
		} 
	});
}