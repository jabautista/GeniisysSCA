/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	07.27.2011	mark jm			set the observer for item (common) buttons 
 */
function observeItemButtons(){
	try{
		var lineCd = getLineCd();
		
		if (objFormParameters.paramIsPack == "Y"){//edgar 02/06/2015
			disableButton("btnRenumber");
		}
		
		if(lineCd != "EN" && lineCd != "AV"){
			$("btnCopyItemInfo").observe("click", function(){
				if(hasPendingChildRecords()){
					showMessageBox("Please save changes first before adding/updating an item.", imgMessage.INFO);
					return false;
				}else{			
					confirmParCopyItemTG();
				}		
			});

			$("btnCopyItemPerilInfo").observe("click", function(){
				if(hasPendingChildRecords()){
					showMessageBox("Please save changes first before adding/updating an item.", imgMessage.INFO);
					return false;
				}else{
					confirmParCopyItemPerilTG();
				}		
			});
		}		
		
		$("btnRenumber").observe("click", function(){	
			if(hasPendingChildRecords()){
				showMessageBox("Please save changes first before adding/updating an item.", imgMessage.INFO);
				return false;
			}else{
				confirmParRenumberTG();
			}
		});
				
		$("btnAssignDeductibles").observe("click", function(){
			if(hasPendingChildRecords()){
				showMessageBox("Please save changes first before adding/updating an item.", imgMessage.INFO);
				return false;
			}else{
				assignDeductiblesTG();
			}
		});
		
		//$("btnAttachMedia").observe("click", function(){	openAttachMediaModal("par");	});
		$("btnAttachMedia").observe("click", function() {	openAttachMediaOverlay("par");	}); //SR-5494 JET SEPT-28-2016
		$("btnOtherDetails").observe("click", function(){	showOtherInfo("otherInfo", 2000);	});
	}catch(e){
		showErrorMessage("observeItemButtons", e);
	}
}