/*	Created by	: mark jm 12.14.2010
 * 	Description	: another version of isItemInfoValid (for par use)
 */
function isParItemInfoValid(){
	try{
		var emptyElem = false;
		var elemId = "";
		var arrRequiredElem = [];
		var filledRequiredFields = true;
		
		if($F("itemNo").blank()){
			//customShowMessageBox("Item Number is required.", imgMessage.ERROR, "itemNo");
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "itemNo");
			return false;
		} else if($F("btnAddItem") == "Add" && $("row" + $F("itemNo")) != undefined){
			//customShowMessageBox("Item Number already exists.", imgMessage.ERROR, "itemNo");
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "itemNo");
			return false;		
		} else if($F("currency").blank() || "0.000000000" == $F("rate")){
			//customShowMessageBox("Currency rate is required.", imgMessage.ERROR, "currency");
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "currency");
			return false;
		} else if($F("rate").match("-") || $F("rate").blank()) {
			//customShowMessageBox("Invalid currency rate.", imgMessage.ERROR, "rate");
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "rate");
			return false;
		} else if($F("itemTitle").blank() || $F("itemTitle") == "") {
			//customShowMessageBox("Please enter the item title first.", imgMessage.ERROR, "itemTitle");
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "itemTitle");
			return false;
		} else if ($F("region").blank()) {
			//customShowMessageBox("Region is required.", imgMessage.ERROR, "region");
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "region");
			return false;			
		}		
		/*
		$$("div#additionalItemInformation select[class='required']").each(function(elem){			
			if (elem.value == "") {
				emptyElem = true;
				elemId = elem.id;				
			}
		});
		
		$$("div#additionalItemInformation input[class='required']").each(function(elem){
			if(elem.value == ""){
				emptyElem = true;
				elemId = elem.Id;				
			}
		});
		
		$$("div#additionalItemInformation textarea[class='required']").each(function(elem){ //nok
			if(elem.value == ""){
				emptyElem = true;
				elemId = elem.Id;
			}
		});
		
		if (emptyElem) {
			//showMessageBox("Please complete additional information for Item No. "+$F("itemNo")+" before saving.", imgMessage.INFO);
			customShowMessageBox(elemId + " is required.", imgMessage.ERROR, elemId);
			return false;
		}
		*/		
		
		$$("div#additionalItemInformation .required").each(function(elem){
			if(elem instanceof HTMLInputElement && elem.value.empty()){
				if(elem.up(0) != null && elem.up(0) instanceof HTMLDivElement){
					arrRequiredElem[arrRequiredElem.length] = {"id" : elem.id, "label" : (elem.up(0)).up(0).previousSiblings()[0].innerHTML};
				}else{
					arrRequiredElem[arrRequiredElem.length] = {"id" : elem.id, "label" : elem.up(0).previousSiblings()[0].innerHTML};
				}
			}else if(elem instanceof HTMLTextAreaElement && elem.value.empty()){
				if(elem.up(0) != null && elem.up(0) instanceof HTMLDivElement){
					arrRequiredElem[arrRequiredElem.length] = {"id" : elem.id, "label" : (elem.up(0)).up(0).previousSiblings()[0].innerHTML};
				}else{
					arrRequiredElem[arrRequiredElem.length] = {"id" : elem.id, "label" : elem.up(0).previousSiblings()[0].innerHTML};
				}	
			}else if(elem instanceof HTMLSelectElement && elem.value.empty()){
				arrRequiredElem[arrRequiredElem.length] = {"id" : elem.id, "label" : elem.up(0).previousSiblings()[0].innerHTML};		
			}
		});		
		
		for(var i=0, length=arrRequiredElem.length; i < length; i++){			
			if($F(arrRequiredElem[i].id).empty()){
				//customShowMessageBox(arrRequiredElem[i].label + " is required.", imgMessage.ERROR, arrRequiredElem[i].id);
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, arrRequiredElem[i].id);
				filledRequiredFields = false;
				break;
			}
		}
		
		if(filledRequiredFields){
			return true;
		}else{
			return false;
		}	
	}catch(e){
		showErrorMessage("isParItemInfoValid", e);
	}
}