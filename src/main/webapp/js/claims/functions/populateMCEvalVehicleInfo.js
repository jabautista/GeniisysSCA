function populateMCEvalVehicleInfo(obj){
	try{
		$("vehPlateNo").value = obj == null ? "" : unescapeHTML2(obj.plateNo) ;
		$("vehBasicColor").value = obj == null ? "" : unescapeHTML2(obj.basicColorDesc) ;
		$("vehModelYear").value = obj == null ? "" : obj.modelYear ;
		$("vehColor").value = obj == null ? "" : unescapeHTML2(obj.colorDesc) ;
		$("vehMotorNo").value = obj == null ? "" : unescapeHTML2(obj.motorNo) ;
		$("vehCarCompany").value = obj == null ? "" : unescapeHTML2(obj.carComDesc) ;
		$("vehSerialNo").value = obj == null ? "" : unescapeHTML2(obj.serialNo) ;
		$("vehMake").value = obj == null ? "" : unescapeHTML2(obj.makeDesc) ;
		$("vehMotorType").value = obj == null ? "" : unescapeHTML2(obj.motorTypeDesc) ;
		$("vehEngineSeries").value = obj == null ? "" : unescapeHTML2(obj.engineSeries) ;
		$("vehOtherInfoSpan").value = obj == null ? "" : unescapeHTML2(obj.otherInfo) ;
		$("vehDriverName").value = obj == null ? "" : unescapeHTML2(obj.drvrName) ;
		$("vehAge").value = obj == null ? "" : obj.drvrAge ;
		$("vehOccupation").value = obj == null ? "" : unescapeHTML2(obj.drvrOccDesc) ;
		$("vehSex").value = obj == null ? "" : obj.drvrSex ;
		$("vehAddress").value = obj == null ? "" : unescapeHTML2(obj.drvrAdd) ;

	}catch(e){
		showErrorMessage("populateMCEvalVehicleInfo",e);
	}
}