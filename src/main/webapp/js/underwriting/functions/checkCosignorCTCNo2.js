function checkCosignorCTCNo2(ctcNo,obj,id,fromCosignorTable){   //added by steven 4.24.2012
	var cosignorRows = obj;
	if (fromCosignorTable == 'Y') {
		for ( var w = 0; w < cosignorRows.length; w++) {
			if((cosignorRows[w].divCtrId != id) && (cosignorRows[w].cosignResNo == ctcNo)){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}
		}
	} else {
		for ( var w = 0; w < cosignorRows.length; w++) {
			if((cosignorRows[w].divCtrId != id) && (cosignorRows[w].cosignResNo == ctcNo)){
				showMessageBox("CTC No. already exist.", imgMessage.INFO);
				return true;
			}
		}
	}
}