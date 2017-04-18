/*	Created by	: Irwin Tabisora 11.14.2011
 * 	Description	: set the observer for oackage policy item rows
 * 	Parameters	: row - the target for observer
 */
function setPackagePolicyItemRowObserver(row){
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
						objCurrItem.gipiWItemPeril != null ? $("currency").disable() : $("currency").enable();
						break;
					}
				}
				objUWGlobal.hidGIPIS095PerilExist = checkGipis095PackPeril(row.getAttribute("parid"), row.getAttribute("item")); //added by steven 10.18.2013
				objUWGlobal.hidGIPIS095PerilExist != "0" ? $("rate").readOnly = true : $("rate").readOnly = false;
				setMainPackagePolicyItemForm(objCurrItem);	
			}else{
				setMainPackagePolicyItemForm(null);
				objUWGlobal.hidGIPIS095PerilExist = "0";
				$("rate").readOnly = false;
				$("currency").enable();
			}	
			if (objUWGlobal.hidGIPIS095DefualtCurrencyCd == $("currency").value) {
				$("rate").disabled = true;
			} else {
				$("rate").disabled = false;
			}
		});
	}catch(e){
		showErrorMessage("setPackagePolicyItemRowObserver", e);
	}
}