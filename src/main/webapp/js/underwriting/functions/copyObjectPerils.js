/*	Created by	: mark jm 10.21.201
 * 	Description	: insert the objects copied from existing listing in deductibles based on their item no
 * 				: creates hidden row for display
 * 	Parameter	: objArray - array of objects that holds all the records of a certain table
 * 				: itemNo - primary key for comparison
 * 				: nextItemNo - the next primary key
 * 				: tableListing - name/id of the table where the new row will be added
 * 				: rowName - name of the div/row that will be added
 * 				: idList - space-separated string containing the columns that will compose the row'id
 * 				: subpageName - name of the subpage used for creating row details
 * 				: labelName - name of the label used in row details
 */
function copyObjectPerils(objArray, itemNo, nextItemNo, tableListing, rowName, idList, subpageName, labelName){
	try{
		var objFilteredArr = objArray.filter(function(obj){	return obj.itemNo == itemNo && nvl(obj.recordStatus, 0) != -1;	});
		
		if(objFilteredArr.length > 0){
			var copyObj = new Object();
			var length 	= objFilteredArr.length;
			
			for(var i=0; i < length; i++){			
				//if(objArray[i].itemNo == itemNo && objArray[i].recordStatus != -1){
					copyObj = cloneObject(objFilteredArr[i]);				
					copyObj.itemNo = nextItemNo;
					copyObj.recordStatus = 2;				
					objArray.push(copyObj);
					
					var content = getSubpageContent(subpageName, copyObj);
					var table = $(tableListing);
					var newDiv = new Element("div");
					var idCombination = "" + nextItemNo;
					var idListing = $w(idList);
					
					//marco - 04.14.2014 - create hidden fields to hold values
					content = '<input type="hidden" name="hidItemNo" 			 value="'+copyObj.itemNo+'"/>' +
								'<input type="hidden" name="hidPerilCd" 		 value="'+copyObj.perilCd+'"/>'+
								'<input type="hidden" name="hidPerilName" 		 value="'+copyObj.perilName+'"/>'+
								'<input type="hidden" name="hidPremiumRate" 	 value="'+copyObj.premRt+'"/>'+
						   		'<input type="hidden" name="hidTsiAmount" 		 value="'+copyObj.tsiAmt+'"/>'+
						   		'<input type="hidden" name="hidAnnTsiAmount" 	 value="'+copyObj.annTsiAmt+'"/>'+ 
								'<input type="hidden" name="hidPremiumAmount" 	 value="'+copyObj.premAmt+'"/>'+
								'<input type="hidden" name="hidAnnPremiumAmount" value="'+copyObj.annPremAmt+'"/>'+
								'<input type="hidden" name="hidRemarks" 		 value="'+copyObj.compRem+'"/>'+
								'<input type="hidden" name="hidDiscSum" 		 value=""/>'+
								'<input type="hidden" name="hidRecFlag" 		 value="'+copyObj.recFlag+'"/>'+
								'<input type="hidden" name="hidBasicPerilCd" 	 value="'+copyObj.bascPerlCd+'"/>'+
								'<input type="hidden" name="hidRiCommRate"	 	 value="'+copyObj.riCommRate+'" />'+
								'<input type="hidden" name="hidRiCommAmount" 	 value="'+copyObj.riCommAmt+'" />'+
								'<input type="hidden" name="hidTarfCd" 	 		 value="'+copyObj.tarfCd+'" />'+
								'<input type="hidden" name="hidPerilType" 	     value="'+copyObj.perilType+'" />'+
								'<input type="hidden" name="hidNoOfDays" 	     value="'+copyObj.noOfDays+'" />'+
								'<input type="hidden" name="hidBaseAmt"			 value="'+copyObj.baseAmt+'">' +
								content;
					
					for(var x=0, idLength=idListing.length; x < idLength; x++){
						idCombination += objFilteredArr[i][idListing[x]];
					}
					
					addEndtItemPeril(newDiv, rowName+idCombination, rowName, copyObj, content, tableListing);
				//}
			}
			
			delete copyObj;
		}
	}catch(e){
		showErrorMessage("copyObjectPerils", e);
	}	
}