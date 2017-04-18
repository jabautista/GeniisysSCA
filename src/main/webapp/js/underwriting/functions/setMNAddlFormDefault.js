/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.21.2011	mark jm			set default value in marine cargo additional details 
 */
function setMNAddlFormDefault(){
	try{
		$("printTag").value = objFormParameters.paramDefaultPrintTag;
	}catch(e){
		showErrorMessage("setMNAddlFormDefault", e);
	}
}