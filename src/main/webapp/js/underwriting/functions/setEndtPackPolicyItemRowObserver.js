function setEndtPackPolicyItemRowObserver(row){
	try{
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			var itemArr = [];				
			row.toggleClassName("selectedRow");
			
			if(row.hasClassName("selectedRow")){			
				($$("div#itemTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				
				itemArr = objGIPIWItem.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1;	});
				for(var i=0, length=itemArr.length; i < length; i++){				
					if(itemArr[i].itemNo == row.getAttribute("item")){					
						objCurrItem = itemArr[i];
						break;
					}
				}

				setMainItemForm(objCurrItem);
				if(nvl(row.getAttribute("updateable"), "Y") == "N"){
					enableEndtPackPolicyItemForm(false);
				}else{
					enableEndtPackPolicyItemForm(true);
					objCurrItem.gipiWItemPeril != null ? $("currency").disable() : $("currency").enable();
				}
			}else{
				setMainItemForm(null);
				enableEndtPackPolicyItemForm(true);
				$("currency").enable();
			}	
			checkIfCancelledEndorsement();
		});
	}catch(e){
		showErrorMessage("setEndtPackPolicyItemRowObserver", e);
	}
}