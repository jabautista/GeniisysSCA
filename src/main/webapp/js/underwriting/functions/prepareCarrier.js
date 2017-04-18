/*
 * Created By	: andrew robes
 * Date			: November 18, 2010
 * Description	: Prepares the row content in carrier listing
 * Parameter	: obj - object containing the carrier details 
 */
function prepareCarrier(obj) {
	try {
		/*
		var carrierInfo = '<label name="textCarrier" style="width: 240px; margin-left:5px;" for="carrier'+obj.vesselName+'">'+obj.vesselName.truncate(30, "...")+'</label>'+
		  '<label name="textCarrier" style="width: 140px; margin-left:5px;" for="carrier'+obj.plateNo+'">'+(obj.plateNo == "" ? "---" : obj.plateNo.truncate(20, "..."))+'</label>'+
		  '<label name="textCarrier" style="width: 140px; margin-left:5px;" for="carrier'+obj.motorNo+'">'+(obj.motorNo == "" ? "---" : obj.motorNo.truncate(20, "..."))+'</label>'+
		  '<label name="textCarrier" style="width: 140px; margin-left:5px;" for="carrier'+obj.serialNo+'">'+(obj.serialNo == "" ? "---" : obj.serialNo.truncate(20, "..."))+'</label>'+
		  '<label name="textCarrier" style="width: 180px; text-align: right; margin-left: 5px;" class="money" for="carrier'+obj.vesselLimitOfLiab+'">'+(obj.vesselLimitOfLiab == "" || obj.vesselLimitOfLiab == null ? "---" :obj.vesselLimitOfLiab.truncate(20, "..."))+'</label>';
		*/
		var vesselCd 	= obj == null ? "---" : obj.vesselCd;
		var vesselName 	= obj == null ? "---" : nvl(obj.vesselName, "---");
		var plateNo 	= obj == null ? "---" : nvl(obj.plateNo, "---");
		var motorNo 	= obj == null ? "---" : nvl(obj.motorNo, "---");
		var serialNo 	= obj == null ? "---" : nvl(obj.serialNo, "---");
		var limitOfLiab = obj == null ? "---" : formatCurrency(nvl(obj.vesselLimitOfLiab, ""));
		
		var carrierInfo = 
			'<label name="textCarrier" title="' + vesselCd + '" style="text-align: left; width: 100px; margin-left: 5px; margin-right: 5px;">' + vesselCd + '</label>' +
			'<label name="textCarrier" title="' + vesselName + '" style="text-align: left; width: 270px; margin-right: 5px;">' + vesselName.truncate(35, "...") + '</label>' +
			'<label name="textCarrier" title="' + plateNo + '" style="text-align: left; width: 100px; margin-right: 5px;">' + plateNo.truncate(13, "...") + '</label>' +
			'<label name="textCarrier" title="' + motorNo + '" style="text-align: left; width: 100px; margin-right: 5px;">' + motorNo.truncate(13, "...") + '</label>' +
			'<label name="textCarrier" title="' + serialNo + '" style="text-align: left; width: 100px; margin-right: 5px;">' + serialNo.truncate(13, "...") + '</label>' +
			'<label name="textCarrier" title="' + limitOfLiab + '" style="text-align: right; width: 150px;">' + limitOfLiab + '</label>';
		return carrierInfo;
	} catch (e) {
		showErrorMessage("prepareCarrier", e);
		//showMessageBox("prepareCarriers : " + e.message);
	}	  	
}