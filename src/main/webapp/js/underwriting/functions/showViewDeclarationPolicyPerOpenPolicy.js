/**
 * Shows
 * @author Kris Felipe
 * @date 10.29.2013
 */
function showViewDeclarationPolicyPerOpenPolicy(){
	try{
		new Ajax.Request(contextPath + "/GIPIOpenPolicyController", {
			parameters : { 
				action 		: "viewDeclarationPolicyPerOpenPolicy",
				callingForm	: objGIPIS100.callingForm,
				lineCd		: nvl(objGIPIS199.lineCd,""),
				opSublineCd	: nvl(objGIPIS199.opSublineCd,""),
				opIssCd		: nvl(objGIPIS199.opIssCd,""),
				opIssueYy	: nvl(objGIPIS199.opIssueYy,""),
				opPolSeqNo	: nvl(objGIPIS199.opPolSeqNo,""),
				opRenewNo	: nvl(objGIPIS199.opRenewNo,""),
			},
			onCreate : function(){showNotice("Retrieving Declaration Policy per Open Policy, please wait...");},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					//if(objGIPIS100.callingForm == "GIPIS199"){
						$("dynamicDiv").update(response.responseText);
					//} else {
						//$("mainContents").update(response.responseText);
					//}
				}
			}
		});
	}catch(e){
		showErrorMessage("viewDeclarationPolicyPerOpenPolicy",e);
	}
}