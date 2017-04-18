/** Validates if user is allowed to delete PAR
 *  Modules: GIPIS001 and GIPIS001A
 * @author Veronica V. Raymundo
 * @param objUser - user details in JSONObject 
 * 		  underwriter - underwriter of the selected PAR
 * @return
 */
function validateCancelPAR(objUser, underwriter){
	var isCancelAllowed = false;	
	if(nvl(objUser.allUserSw,'N')== 'Y' && (nvl(objUser.misSw,'N')== 'Y' || nvl(objUser.mgrSw,'N')== 'Y')){
		isCancelAllowed = true;
	}else if(objUser.userId != underwriter){
		showMessageBox("Record created by another user cannot be cancelled.", imgMessage.INFO);
		isCancelAllowed = false;
		return false;
	}else if(objUser.userId == underwriter){
		isCancelAllowed = true;
	}
	return isCancelAllowed;
}