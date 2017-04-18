/*	Created by	: mark jm 01.21.2011
 * 	Description	: another version of filtering lov used in item info
 * 	Parameters	: tableId - id of the subpage table listing
 * 				: rowPkAttr - row primary key attribute name
 * 				: rowPkValue - current itemNo selected
 * 				: selectId - id od the lov
 * 				: attr - attribute to get data
 */
function filterItemLOV(tableId, rowPkAttr, rowPkValue, selectId, attr){
	var arrElem;
	var arrCd = [];
	var op;
	
	arrElem = $$("div#" + tableId + " div[" + rowPkAttr+ "='" + rowPkValue + "']");
	
	for(var i=0, length=arrElem.length; i < length; i++){		
		arrCd[i] = arrElem[i].getAttribute(attr);
	}
	
	(($(selectId).childElements()).invoke("show")).invoke("removeAttribute", "disabled");
	
	for(var i=0, length=$(selectId).options.length; i < length; i++){
		op = $(selectId).options[i];		
		if(arrCd.indexOf(op.value) > -1){			
			$(selectId).options[i].hide();
			$(selectId).options[i].disabled = true;
		}
	}	
}