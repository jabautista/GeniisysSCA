function preConfirmParCopyItem3(){
	try{
		//objFormVariables.varDiscExist = "N";
		if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
			objFormMiscVariables.miscDeletePerilDiscById = "Y";
		}
		confirmParCopyItem3();
	}catch(e){
		showErrorMessage("preConfirmParCopyItem3", e);
		//showMessageBox("preConfirmParCopyItem3 : " + e.message);
	}
}