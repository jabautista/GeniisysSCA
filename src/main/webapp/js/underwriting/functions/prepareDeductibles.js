/*	Created by	: mark jm 10.21.2010
 * 	Description : returns a string containing the elements to display in table listing
 * 	Parameter	: obj - object to get data from
 */
function prepareDeductibles(obj){
	try{
		/*
		var deductibleInfo =			
			(1 < obj.dedLevel ? '<label name="txtDeductibles" style="width: 36px; text-align: right; margin-right: 10px;">'+obj.itemNo+'</label>' : "") +								  
			(3 == obj.dedLevel ? '<label name="txtDeductibles" style="width: 160px; text-align: left; " title="'+obj.perilName+'">'+obj.perilName.truncate(20, "...")+'</label>' : "") +	
			'<label name="txtDeductibles" style="width: 213px; text-align: left; margin-left: 6px;" title="'+obj.deductibleTitle+'">'+obj.deductibleTitle.truncate(25, "...")+'</label>'+		
			'<label name="txtDeductibles" style="width: 119px; text-align: right;">'+(obj.deductibleRate == null ? "-" : formatToNineDecimal(obj.deductibleRate))+'</label>'+
			'<label name="txtDeductibles" style="width: 119px; text-align: right;">'+(obj.deductibleAmount == null ? "-" : formatCurrency(obj.deductibleAmount))+'</label>'+							 
			'<label name="txtDeductibles" style="width: 155px; text-align: left;  margin-left: 20px;" title="'+obj.deductibleText+'">'+obj.deductibleText.truncate(20, "...")+'</label>'+
			'<label name="txtDeductibles" style="width: 33px; text-align: center;">';
		
		if (obj.aggregateSw == 'Y') {
			deductibleInfo += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 11px;  " />';
		} else {
			deductibleInfo += '<span style="width: 33px; height: 10px; text-align: left; display: block; margin-left: 3px;"></span>';
		}
		if(1 == obj.dedLevel){
			deductibleInfo += '</label><label style="width: 20px; text-align: center;">';
			if (obj.ceilingSw == 'Y') {
				deductibleInfo += '<img name="checkedImg" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 11px;" />';
			}
		}
		deductibleInfo += '</label>';
		*/
		
		var deductibleInfo = '<label name="txtDeductibles" style="width: 33px; text-align: center;">';
		var id = "";
				
		if (obj.aggregateSw == 'Y') {
			deductibleInfo += '<img name="checkedImg" class="printCheck" src="' + checkImgSrc + '"style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 11px;"></img>';
		} else {
			deductibleInfo += '<span style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;"></span>';
		}
		if(1 == obj.dedLevel){
			deductibleInfo += '</label><label style="width: 45px; text-align: center;">';
			if (obj.ceilingSw == 'Y') {
				deductibleInfo += '<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 16px;" />';
			}else{
				deductibleInfo += '<span style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;"></span>';
			}
		}
		deductibleInfo += '</label>';
		
		id = obj.dedLevel + obj.itemNo + (obj.perilCd + obj.dedDeductibleCd);
		
		deductibleInfo +=
			(1 < obj.dedLevel ? '<label name="txtDeductibles" style="width: 10px; text-align: right; margin-right: 10px;">' + obj.itemNo + '</label>' : "") +								  
			(3 == obj.dedLevel ? '<label name="peril" style="width: 160px; text-align: left;" id="peril' + id + '" title="' + obj.perilName+'">' + obj.perilName.truncate(20, "...")+'</label>' : "") +	
			'<label name="dedTitle' + obj.dedLevel+ '" style="width: 213px; text-align: left; margin-left: 5px;" id="dedTitle' + id + '" title="' + obj.deductibleTitle + '">'+obj.deductibleTitle.truncate(25, "...")+'</label>'+
			'<label name="dedText' + obj.dedLevel + '" style="width: 155px; text-align: left;  margin-left: 20px;" title="Click to view complete text.">' + obj.deductibleText.truncate(20, "...") + '</label>' +
			'<label name="txtDeductibles" style="width: 119px; text-align: right;">' + (obj.deductibleRate == null ? "-" : formatToNineDecimal(obj.deductibleRate)) + '</label>'+
			'<label name="txtDeductibles" style="width: 119px; text-align: right;">' + (obj.deductibleAmount == null ? "-" : formatCurrency(obj.deductibleAmount)) + '</label>';			
		
		return deductibleInfo;
	}catch(e){
		showErrorMessage("prepareDeductibles", e);
		//showMessageBox("prepareDeductibles : " + e.message);
	}
}