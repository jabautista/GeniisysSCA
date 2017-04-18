function afterPrintingGiacs149(){
	restoreOCV = null;
	printCommDialog.close();
	if (objGIACS149.ocvNo == null && objGIACS149.ocvPrefSuf == null){
		showConfirmBox("Confirmation", "Was the printing successful?", "Yes", "No",
				function(){
					printOk = true;
					restoreOCV = false;
					delWorkflowRec();
					objGIACS149.ocvNo = objGIACS149.voucherNo;
					objGIACS149.ocvPrefSuf = objGIACS149.voucherPrefSuf;
					commVoucherTG._refreshList();
				},
				function(){
					printOk = false;
					showConfirmBox4("Confirmation", "Please pick a transaction.", "Restore OCV", "Spoil OCV", "Exit",
									function(){
										if(objGIACS149.reprint == "N"){
											restoreOCV = true;
											restoreGpcv(0);
										}else{
											restoreGpcv(0);
										}
									},
									function(){
										restoreGpcv(2);
									},
									function(){
										/*commVoucherTG.url = objGIACS149.url;
										commVoucherTG._refreshList();*/
									}
					);
				}
		);
	}else{
		commVoucherTG._refreshList();
	}	
}