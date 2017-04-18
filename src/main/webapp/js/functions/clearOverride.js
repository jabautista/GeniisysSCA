/* Clear Override form
 */
function clearOverride(){
	try{
		$("overideUserName").clear();
		$("overidePassWord").clear();
		$("overideUserName").focus();
	}catch(e){
		showErrorMessage("clearOverride", e);
	}
}