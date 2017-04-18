/*	Created by	: mark jm 03.18.2011
 * 	Description	: set the observer for package par policy item rows
 * 	Parameters	: row - the target for observer
 */
function setPackParPolicyRowObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){
				($$("div#packageParPolicyTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				
				($$("div#itemTable div[name='row']")).invoke("removeClassName", "selectedRow");
				($$("div#itemTable div[name='row']")).invoke("show");				
				($$("div#parItemTableContainer div:not([parId='" + row.getAttribute("parId") + "'])")).invoke("hide");
				
				resizeTableBasedOnVisibleRows("itemTable", "parItemTableContainer");				
				setMainItemForm(null);
				if($F("pageName") == "packagePolicyItems"){
					var selectedPar = null;
					
					for(var i=0, length=objGIPIParList.length; i < length; i++){						
						if(objGIPIParList[i].parId == row.getAttribute("parId")){							
							selectedPar = objGIPIParList[i];							
							break;
						}
					}
					
					if(selectedPar != null){
						$("packLineCd").value = selectedPar.lineCd;
						$("packSublineCd").value = selectedPar.sublineCd;
						$("region").value = selectedPar.regionCd;
						checkRecords(selectedPar);
					}					
				}
				objUWGlobal.hidGIPIS095PerilExist = "0"; //added by steven 12.10.2013
			}else{
				objUWGlobal.hidGIPIS095PerilExist = "0"; //added by steven 12.10.2013
				$("itemTable").hide();
				setMainItemForm(null);
			}	
			if (objUWGlobal.hidGIPIS095DefualtCurrencyCd == $("currency").value) {
				$("rate").disabled = true;
			} else {
				$("rate").disabled = false;
			}
		});
	}catch(e){
		showErrorMessage("setPackParPolicyRowObserver", e);
	}
}