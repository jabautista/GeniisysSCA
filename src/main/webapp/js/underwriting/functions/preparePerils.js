/*	Created by	: mark jm 10.27.2010
 * 	Description	: returns a string containing the elements to display in table listing
 * 	Parameter	: obj - object to get data from
 */
function preparePerils(obj){
	try{
		var itemNo 		= (obj == null ? "---" : (obj.itemNo.toString()).truncate(5, "...")); 
		var perilName 	= (obj == null ? "---" : obj.perilName);
		var premRt 		= (obj == null ? "---" : (formatToNineDecimal(obj.premRt == null ? "0" : obj.premRt)));
		var tsiAmt 		= (obj == null ? "---" : (formatCurrency(obj.tsiAmt == null ? "0" : obj.tsiAmt)));
		var annTsiAmt 	= (obj == null ? "---" : (formatCurrency(obj.annTsiAmt == null ? "0" : obj.annTsiAmt)));
		var premAmt 	= (obj == null ? "---" : (formatCurrency(obj.premAmt == null ? "0" : obj.premAmt)));
		var annPremAmt 	= (obj == null ? "---" : (formatCurrency(obj.annPremAmt == null ? "0" : obj.annPremAmt)));
		var riCommRate	= (obj == null ? "---" : (formatToNineDecimal(obj.riCommRate == null ? "0" : obj.riCommRate)));
		var riCommAmt	= (obj == null ? "---" : (formatCurrency(obj.riCommAmt == null ? "0" : obj.riCommAmt)));		
			
		var perilInfo =
			'<div id="labelDiv1">' +
			'<label title="' + itemNo + '" name="lblItemNo" style="width: 36px; text-align: center; margin-left: 3px;">'+ itemNo +'</label>' +
			'<label title="' + perilName + '" name="lblPerilName" style="width: 135px; text-align: left; margin-left: 5px;">'+ perilName +'</label>' +
			'<label title="' + premRt + '" name="lblPremiumRate" style="width: 132px; text-align: right; margin-left: 3px;">'+ premRt +'</label>' +
	   		'<label title="' + tsiAmt + '" name="lblTsiAmount" style="width: 132px; text-align: right; margin-left: 3px;">' + tsiAmt +'</label>' +
	   		'<label title="' + annTsiAmt + '" name="lblAnnTsiAmount" style="width: 132px; text-align: right; margin-left: 3px;">' + annTsiAmt + '</label>' +
			'<label title="' + premAmt + '" name="lblPremiumAmount"	style="width: 132px; text-align: right; margin-left: 3px;">' + premAmt + '</label>' +
			'<label title="' + annPremAmt + '" name="lblAnnPremiumAmount" style="width: 145px; text-align: right; margin-left: 3px;">'+ annPremAmt +'</label>' +
			'</div>' + 
			'<div id="labelDiv2" style="display:none;">' +
			'<label title="'+ itemNo + '" name="lblItemNo" style="width: 36px; text-align: center; margin-left: 3px;">' + itemNo + '</label>' +
			'<label title="' + perilName + '" name="lblPerilName" style="width: 135px; text-align: center; margin-left: 5px">' + perilName + '</label>' +
			'<label title="' + riCommRate + '" name="lblRIRate" style="width: 135px; text-align: right; margin-left: 3px">' + riCommRate + '</label>' +
			'<label title="' + riCommAmt + '" name="lblCommissionAmount" style="width: 140px; text-align: right; margin-left: 3px;">' + riCommAmt + '</label>' +
			'<label title="' + premAmt + '" name="lblPremiumCeded" style="width: 140px; text-align: right; margin-left: 3px;">' + premAmt + '</label>' +
			'</div>';
		
		return perilInfo;
	}catch(e){
		showErrorMessage("preparePerils", e);
		//showMessageBox("preparePerils : " + e.message);
	}
}