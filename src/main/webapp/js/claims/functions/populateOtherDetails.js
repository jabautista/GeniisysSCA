/**
 * Motor car Item info functions
 * 
 * @author Irwin Tabisora, 9.13.11
 */
function populateOtherDetails(obj){
	// populate other details
	$("detClassName").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('classDesc')]);
	$("detPayee").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('payeeDesc')]);
	$("detPlateNo").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('plateNo')]);
	$("detMotorNo").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('motorNo')]);
	$("detColor").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('colorDesc')]);
	$("detColorCd").value =  obj == null ? null :obj[mcTpDtlGrid.getColumnIndex('colorCd')];
	$("detBasicColor").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('basicColorDesc')]);
	$("detBasicColorCd").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('basicColorCd')]);
	$("detModelYear").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('modelYear')]);
	$("detSerialNo").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('serialNo')]);
	$("detCarCompany").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('carComDesc')]);
	$("detCarCompanyCd").value =  obj == null ? null :obj[mcTpDtlGrid.getColumnIndex('motorcarCompCd')];
	$("detMake").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('makeDesc')]);
	$("detMakeCd").value =  obj == null ? null :obj[mcTpDtlGrid.getColumnIndex('makeCd')];
	$("detEngineSeries").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('engineSeries')]);
	$("detSeriesCd").value =  obj == null ? null :obj[mcTpDtlGrid.getColumnIndex('seriesCd')];
	$("detMotorTypeDesc").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('motorTypeDesc')]); 
	$("detTypeCd").value =  obj == null ? null :obj[mcTpDtlGrid.getColumnIndex('motType')];
	$("detOtherInfo").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('otherInfo')]);
	$("detRiCd").value =  obj == undefined ? null : nvl(obj[mcTpDtlGrid.getColumnIndex('riCd')],null);
	$("detRiName").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('riName')]);
	
	// drvr details
	$("detDriverName").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('drvrName')]);
	$("detDriverAge").value =  obj == null ? null : nvl(obj[mcTpDtlGrid.getColumnIndex('drvrAge')],null);
	if(obj != null){
		if(obj[mcTpDtlGrid.getColumnIndex('drvrSex')] == "M"){
			$("detDriverSex").options.selectedIndex = 1;
		}else if(obj[mcTpDtlGrid.getColumnIndex('drvrSex')] == "F"){
			$("detDriverSex").options.selectedIndex = 2;
		}	
	}else{
		$("detDriverSex").options.selectedIndex = 0;
	}
	// $("detDriverSex").value = obj == null ? null
	// :obj[mcTpDtlGrid.getColumnIndex('drvrSex')];
	$("detDrivingExperience").value =  obj == null ? null : nvl(obj[mcTpDtlGrid.getColumnIndex('drvngExp')],null);
	$("detDriverOccupation").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('drvrOccDesc')]); 
	$("detDriverOccupationCd").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('drvrOccCd')]);
	$("detNationalityDesc").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('nationalityDesc')]);
	$("detNationalityCd").value =  obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('nationalityCd')]);
	$("detDriverAddress").value = obj == null ? null
	:unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('drvrAdd')]);
}