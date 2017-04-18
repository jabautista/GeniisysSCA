/**
 * Add new recovery - Recovery Information
 * Module: GICLS025
 * @author Niknok Orio
 * @date 03.20.2012
 */
function addClmNewRecoveryInfo(){
	try{
		var obj = new Object();
		obj.lineCd				= $("txtLineCd").value; 			
		obj.issCd				= $("txtIssCd").value; 			
		obj.recYear				= $("txtRecYear").value; 			
		obj.recSeqNo			= $("txtRecSeqNo").value; 			
		obj.dspRecStatDesc		= escapeHTML2($("lblClmRecStatus").innerHTML);
		obj.recTypeCd			= escapeHTML2($("txtRecTypeCd").value); 		
		obj.dspRecTypeDesc		= escapeHTML2($("txtDspRecTypeDesc").value); 	
		obj.currencyCd			= $("txtCurrencyCd").value; 		
		obj.dspCurrencyDesc		= escapeHTML2($("txtDspCurrencyDesc").value); 	
		obj.convertRate			= $("txtConvertRate").value; 		
		obj.plateNo				= escapeHTML2($("txtPlateNo").value); 			
		obj.lawyerCd			= $("txtLawyerCd").value; 			
		obj.lawyerClassCd		= $("hidLawyerClassCd").value; 	
		obj.dspLawyerName		= escapeHTML2($("txtDspLawyerName").value); 	
		obj.caseNo				= escapeHTML2($("txtCaseNo").value); 			
		obj.court				= escapeHTML2($("txtCourt").value); 			
		obj.tpItemDesc 			= escapeHTML2($("txtTpItemDesc").value); 		
		obj.recoverableAmt 		= unformatCurrencyValue($("txtRecoverableAmt").value); 	
		obj.recoverableAmt		= unformatCurrencyValue($("txtRecoverableAmt2").value); 	
		obj.recoveredAmt		= unformatCurrencyValue($("txtRecoveredAmt").value); 		
		obj.tpPlateNo			= escapeHTML2($("txtTpPlateNo").value); 		
		obj.tpDriverName		= escapeHTML2($("txtTpDriverName").value); 		
		obj.tpDrvrAdd			= escapeHTML2($("txtTpDrvrAdd").value); 		
		
		if (nvl(objCLM.recoveryDetailsTG,null) instanceof MyTableGrid) {
			objCLM.recoveryDetailsTG.createNewRow(obj);
			if (nvl(objCLM.recoveryDetailsLOV,null) != null){
				objCLM.recoveryDetailsTG.saveGrid(true);
			}
		}	
		return obj;
	}catch(e){
		showErrorMessage("addClmNewRecoveryInfo", e);
	}	
}