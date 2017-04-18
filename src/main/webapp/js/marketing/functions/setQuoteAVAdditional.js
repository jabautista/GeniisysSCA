//emman 04.27.2011 for aviation additional info
function setQuoteAVAdditional(itemObj) {
	try{
		var newObj = {};
		newObj.quoteId			= nvl(itemObj.quoteId,'');
		newObj.itemNo			= nvl($F("txtItemNo"),'');
		newObj.vesselCd			= ($("selVessel").value.blank()) ? null : escapeHTML2($("selVessel").value);
		newObj.purpose			= ($("txtPurpose").value.blank()) ? null : escapeHTML2($("txtPurpose").value);
		newObj.deductText		= ($("txtDeductText").value.blank()) ? null : escapeHTML2($("txtDeductText").value);
		newObj.prevUtilHrs		= ($("txtPrevUtilHrs").value.blank()) ? null : escapeHTML2($("txtPrevUtilHrs").value);
		newObj.estUtilHrs		= ($("txtEstUtilHrs").value.blank()) ? null : escapeHTML2($("txtEstUtilHrs").value);
		newObj.totalFlyTime		= ($("txtTotalFlyTime").value.blank()) ? null : escapeHTML2($("txtTotalFlyTime").value);
		newObj.qualification	= ($("txtQualification").value.blank()) ? null : escapeHTML2($("txtQualification").value);
		newObj.geogLimit		= ($("txtGeogLimit").value.blank()) ? null : escapeHTML2($("txtGeogLimit").value);		
		return newObj; 
	}catch (e) {
		showErrorMessage("setQuoteAVAdditional", e);
	}
}