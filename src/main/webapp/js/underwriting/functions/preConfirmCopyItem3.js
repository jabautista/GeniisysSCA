/*	Created by	: mark jm
 * 	Description : update varDiscExist
 */
function preConfirmCopyItem3(){
	try{
		//objFormVariables[0].varDiscExist = "N";
		objFormVariables.varDiscExist = "N";
		confirmCopyItem3();
	}catch(e){
		showErrorMessage("preConfirmCopyItem3", e);
	}
}