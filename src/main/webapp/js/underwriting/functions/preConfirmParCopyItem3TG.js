/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.11.2011	mark jm			pre-third validation in copying an item w/ or w/out perils
 */
function preConfirmParCopyItem3TG(){
	try{
		//objFormVariables.varDiscExist = "N";
		if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
			objFormMiscVariables.miscDeletePerilDiscById = "Y";
		}
		confirmParCopyItem3TG();
	}catch(e){
		showErrorMessage("preConfirmParCopyItem3TG", e);
	}
}