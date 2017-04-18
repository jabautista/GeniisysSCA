/** Validates if user is allowed to delete PAR
 *  Modules: GIPIS001, GIPIS001A, GIPIS058 and GIPIS058A
 * @author Veronica V. Raymundo
 * @param objUser - user details in JSONObject 
 * 		  underwriter - underwriter of the selected PAR
 * @return
 */
function validateDeletePAR(objUser, underwriter){
	var isDeleteAllowed = false;
	
	if(nvl(objUser.allUserSw,'N')== 'Y' && (nvl(objUser.misSw,'N')== 'Y' || nvl(objUser.mgrSw,'N')== 'Y')){
		isDeleteAllowed = true;
	}else if(objUser.userId != underwriter){
		showMessageBox("Record created by another user cannot be deleted.", imgMessage.INFO);
		isDeleteAllowed = false;
		return false;
	}else if(objUser.userId == underwriter){
		isDeleteAllowed = true;
	}

	return isDeleteAllowed;
}