//belle 12.01.2011 for PA item info
function populateAccidentFields(obj){
	try{
		objCLMItem.selected 			= obj == null ? {} :obj;
		objCLMItem.selItemIndex			= obj == null ? null :objCLMItem.selItemIndex;
		$("txtItemNo").value  			= obj == null ? null :String(obj[itemGrid.getColumnIndex('itemNo')]);
		$("txtItemTitle").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemTitle')]);
		$("txtGrpItemNo").value  		= obj == null ? null :String(obj[itemGrid.getColumnIndex('groupedItemNo')]);
		$("txtGrpItemTitle").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('groupedItemTitle')]);
		$("txtCurrencyCd").value 		= obj == null ? null :String(obj[itemGrid.getColumnIndex('currencyCd')]); 
		$("txtDspCurrencyDesc").value 	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCurrency')]);
		$("txtCurrencyRate").value  	= obj == null ? null :formatToNthDecimal(obj[itemGrid.getColumnIndex('currencyRate')],9);
		$("txtPositionCd").value	 	= obj == null ? null :nvl(String(obj[itemGrid.getColumnIndex('positionCd')]), "");
		$("txtDspPosition").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspPosition')]);
		$("txtMonthlySal").value  		= obj == null ? null :formatCurrency(obj[itemGrid.getColumnIndex('monthlySalary')]);
		$("txtDspControlType").value 	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspControlType')]);
		$("txtControlCd").value 		= obj == null ? null :obj[itemGrid.getColumnIndex('controlCd')];
		$("txtAmtCoverage").value 		= obj == null ? null :formatCurrency(obj[itemGrid.getColumnIndex('amountCoverage')]);
		$("txtItemDesc").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc')]);
		$("txtItemDesc2").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc2')]);
		$("txtLevel").value  			= obj == null ? null :obj[itemGrid.getColumnIndex('levelCd')];
		$("txtSalGrade").value  		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('salaryGrade')]);
		$("txtDateOfBirth").value  		= obj == null ? null :obj[itemGrid.getColumnIndex('dateOfBirth')] == null ? "" : dateFormat(obj[itemGrid.getColumnIndex('dateOfBirth')], "mm-dd-yyyy");
		$("txtDspCivilStat").value 		= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCivilStat')]);
		$("txtDspSex").value  			= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspSex')]);
		$("txtAge").value  				= obj == null ? null :obj[itemGrid.getColumnIndex('age')];
		getAddtlInfos(obj);
	}catch(e){
		showErrorMessage("populateAccidentFields",e);
	}	
}