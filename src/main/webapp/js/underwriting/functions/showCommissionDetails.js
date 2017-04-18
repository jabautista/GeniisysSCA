/**
 * @author rey
 * @date 08.08.2011
 * commission details
 * @param object
 */
function showCommissionDetails(object,LineCd,IssCd){
	/*try{
		new Ajax.Updater("commissionDetail","GIPIPolbasicController?action=showCommissionDetails",{
			method: "get",
			evalScripts: true,
			asynchonous: false,
			parameters:{
				lineCd: LineCd,
				issCd : IssCd,
				premSeqNo : object.premSeqNo,
				intmNo : object.intmNo,
				perilCd : object.perilCd
			}
			
		});
	}
	catch(e){
		showErrorMessage("showCommissionDetails",e);
	}*/
	object = nvl(object, "");
	commissionTableGridListing.url = contextPath+"/GIPIPolbasicController?action=showCommissionDetails&refresh=1&lineCd="+LineCd+
									"&issCd="+IssCd+"&premSeqNo="+nvl(object.premSeqNo, 0)+"&intmNo="+nvl(object.intmNo, 0)+
									"&perilCd="+nvl(object.perilCd, 0);
	commissionTableGridListing._refreshList();
	
	getTotalDetails(); //Moved from commissionDetails.jsp - Jerome Bautista SR 21374 01.22.2016
	function getTotalDetails(){
		var totalPrntComm = 0;
		for(var i = 0; i<commissionTableGridListing.rows.length; i++){ //Modified by Jerome Bautista SR 2174 01.15.2016
			var val = commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailRt')] == null || commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailRt')] == "" ? 0 : commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailRt')];
			totalPrntComm = parseFloat(totalPrntComm) + parseFloat(val);
		}
		var frmTotalPrntComm = formatToNineDecimal(totalPrntComm);
		$("prntCommRtSum").value       = (nvl(frmTotalPrntComm, ""));
		
		var totalPrntCommAmt = 0;
		for(var i = 0; i<commissionTableGridListing.rows.length; i++){ //Modified by Jerome Bautista SR 2174 01.15.2016
			var val = commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailAmt')] == null || commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailAmt')] == "" ? 0 : commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('prntDetailAmt')];
			totalPrntCommAmt = parseFloat(totalPrntCommAmt) + parseFloat(val);
		}
		var frmTotalCommAmt = formatCurrency(totalPrntCommAmt);
		$("prntCommAmtSum").value       = (nvl(frmTotalCommAmt, ""));
		
		var totalAgentComm = 0;
		for(var i = 0; i<commissionTableGridListing.rows.length; i++){ //Modified by Jerome Bautista SR 2174 01.15.2016
			var val = commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommRt')] == null || commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommRt')] == "" ? 0 : commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommRt')];
			totalAgentComm = parseFloat(totalAgentComm) + parseFloat(val);
		}
		var frmTotalAgentComm = formatToNineDecimal(totalAgentComm);
		$("chldCommRtSum").value       = (nvl(frmTotalAgentComm, ""));
		
		var totalAgentCommAmt = 0;
		for(var i = 0; i<commissionTableGridListing.rows.length; i++){ //Modified by Jerome Bautista SR 2174 01.15.2016
			var val = commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommAmt')] == null || commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommAmt')] == "" ? 0 : commissionTableGridListing.rows[i][commissionTableGridListing.getColumnIndex('childCommAmt')];
			totalAgentCommAmt = parseFloat(totalAgentCommAmt) + parseFloat(val);
		}
		var frmTotalAgentCommAmt = formatCurrency(totalAgentCommAmt);
		$("chldCommAmtSum").value       = (nvl(frmTotalAgentCommAmt, ""));
		
		
	}
}