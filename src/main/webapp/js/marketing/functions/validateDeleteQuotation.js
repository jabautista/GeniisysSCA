/** Validates if user is allowed to delete quotation
 *  Modules: GIIMM001 and GIIMM001A
 * @author Veronica V. Raymundo
 * @param objUser - user details in JSONObject 
 * 		  quoteUser - processor of the quotation
 * @return
 */

function validateDeleteQuotation(objUser, quoteUser){
	var isDeleteAllowed = false;
	// as per Maam Mylene and Maam Jhing only users with tagged MGR_SW are allowed to deny/delete quotation : shan 07.31.2014
	if(nvl(objUser.allUserSw,'N')== 'Y' && (/*nvl(objUser.misSw,'N')== 'Y' ||*/ nvl(objUser.mgrSw,'N')== 'Y')){
		isDeleteAllowed = true;
		return isDeleteAllowed;		// shan 07.15.2014
	} // this condition is not found in CS.  Modification is for SR: 388 :: bonok :: 09.27.2013
	if(objUser.userId != quoteUser){
		showMessageBox("Record created by another user cannot be deleted.", imgMessage.INFO);
		isDeleteAllowed = false;
		return false;
	}
	if(objUser.userId == quoteUser){
		isDeleteAllowed = true;
	}

	return isDeleteAllowed;
}