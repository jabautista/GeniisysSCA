function setEndtPackPolicyRowObserver(row){
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
				}					
			}else{
				$("itemTable").hide();
			}
			setMainItemForm(null);
			enableEndtPackPolicyItemForm(true);		
			checkIfCancelledEndorsement();
		});
	}catch(e){
		showErrorMessage("setEndtPackPolicyRowObserver", e);
	}
}