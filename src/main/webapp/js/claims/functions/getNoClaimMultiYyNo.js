/**
 * @author rey
 * @date 22-12-2011
 */
function getNoClaimMultiYyNo(){
	try{
		new Ajax.Request(contextPath + "/GICLNoClaimMultiYyController?action=getNoClaimMultiYyNo",{
			method: "GET",
			asynchronous: true,
			evalScripts: true,
			parameters:{
				
			},
			onCreate: function(){
			
			},
			onComplete: function(response){
				var noClaimNumber = response.responseText;
				$("hidNoClaimNo").value = noClaimNumber;
			}			
		});
	}catch(e){
		showErrorMessage("getNoClaimMultiYyNo",e);
	}
}