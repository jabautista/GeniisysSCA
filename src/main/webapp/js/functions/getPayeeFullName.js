/**
 * Retrieves the full name of the payee
 * @author irwin tabisora
 * @date 04.17.2012
 * @param payeeClassCd
 * @param payeeNo
 * @return payeeFullName
 */
function getPayeeFullName(payeeClassCd, payeeNo){
	var payeeFullName;
	new Ajax.Request(contextPath + "/GIISPayeesController", {
		parameters:{
			action: "getPayeeFullName",
			payeeClassCd: payeeClassCd,
			payeeNo: payeeNo
		},
		asynchronous: false,
		evalScripts: true,
		onComplete: function(response){
			hideNotice("");
			if(checkErrorOnResponse(response)) {
				payeeFullName = response.responseText;
			}else{
				showMessageBox(response.responseText, "E");
			}
		}		
	});		
	return payeeFullName;
}