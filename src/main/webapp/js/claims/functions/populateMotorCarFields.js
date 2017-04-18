function populateMotorCarFields(obj){
	try{
		objCLMItem.selected 		= obj == null ? {} :obj;
		objCLMItem.selItemIndex	= obj == null ? null :objCLMItem.selItemIndex;
		$("txtItemNo").value  		= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('itemNo')]));
		$("txtItemTitle").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemTitle')]);
		$("txtItemDesc").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc')]);
		$("txtItemDesc2").value  	= obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('itemDesc2')]);
		$("txtCurrencyCd").value 	= obj == null ? null :unescapeHTML2(String(obj[itemGrid.getColumnIndex('currencyCd')])); 
		$("txtDspCurrencyDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCurrencyDesc')]);
		$("txtCurrencyRate").value  = obj == null ? null :unescapeHTML2(formatToNthDecimal(obj[itemGrid.getColumnIndex('currencyRate')],9));
		$("txtDspCurrencyDesc").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('dspCurrencyDesc')]);
		$("txtPlateNo").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('plateNo')]);
		$("txtModelYear").value = obj == null ? null :unescapeHTML2(obj[itemGrid.getColumnIndex('modelYear')]);
		$("txtMotcarCompCd").value = obj == null ? null : obj[itemGrid.getColumnIndex('motcarCompCd')];
		$("txtMotcarCompDesc").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('motcarCompDesc')]);
		$("txtSublineTypeCd").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('sublineTypeCd')]);
		$("txtSublineTypeDesc").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('sublineTypeDesc')]);
		$("txtMakeCd").value = obj == null ? null : obj[itemGrid.getColumnIndex('makeCd')];
		$("txtMakeCdDesc").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('makeDesc')]);
		$("txtMotorNo").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('motorNo')]);
		$("txtSerialNo").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('serialNo')]);
		$("txtMotType").value = obj == null ? null : obj[itemGrid.getColumnIndex('motType')];
		$("txtMotTypeDesc").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('motTypeDesc')]);
		$("txtBasicColorCd").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('basicColorCd')]);
		$("txtBasicColorDesc").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('basicColor')]);
		$("txtColor").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('color')]);
		$("txtColorCd").value = obj == null ? null : obj[itemGrid.getColumnIndex('colorCd')];
		$("txtSeriesCd").value = obj == null ? null : obj[itemGrid.getColumnIndex('seriesCd')];
		$("txtEngineSeries").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('engineSeries')]); // added unescape by j.diago 04.15.2014
		$("txtTowing").value = obj == null ? null : formatCurrency(obj[itemGrid.getColumnIndex('towing')]);
		$("txtAssignee").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('assignee')]); // added unescape by j.diago 04.15.2014
		$("txtMvFileNo").value = obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('mvFileNo')]); // added unescape by j.diago 04.15.2014
		$("txtNoOfPass").value = obj == null ? null : obj[itemGrid.getColumnIndex('noOfPass')];
		
		// driver details
		// Added condtion for populate switch of MC driver details. J. Diago 10.11.2013
		if(objCLMGlobal.driverInfoPopulateSw == "Y"){
			$("txtDrvrName").value  		= obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('drvrName')]);
			$("txtDrvngExp").value  		= obj == null ? null : obj[itemGrid.getColumnIndex('drvngExp')];
			$("txtDrvrAge").value  		= obj == null ? null : obj[itemGrid.getColumnIndex('drvrAge')];
			$("txtDrvrOccCd").value  		= obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('drvrOccCd')]);
			$("txtDrvrOccDesc").value  		= obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('drvrOccDesc')]);
			$("txtDrvrSex").value  		= obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('drvrSex')]);
			$("txtDrvrAdd").value  		= obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('drvrAdd')]);
			$("txtNationalityCd").value  		= obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('nationalityCd')]);
			$("txtNationalityDesc").value  		= obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('nationalityDesc')]);
			$("txtRelation").value  		= obj == null ? null : unescapeHTML2(obj[itemGrid.getColumnIndex('relation')]);
		}
		
		getAddtlInfos(obj);
	}catch(e){
		showErrorMessage("populateMotorCarFields",e);
	}
}