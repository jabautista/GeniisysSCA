/*	Created by	: mark jm 03.18.2011
 * 	Description	: set the observer for item rows
 * 	Parameters	: row - the target for observer
 */
function setItemRowObserver(row){
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

				setMainItemForm(objCurrItem);				
			}else{
				setMainItemForm(null);
				$("currency").enable();
			}				
		});
	}catch(e){
		showErrorMessage("setItemRowObserver", e);
	}
}