/**
Shows list of Old Item No. for GIAC Premium Deposit
* @author emsy bola�os
* @date 06.14.2012
* @module GIACS026
*/
function showGIACOldItemNoLOV(){
	try{
		var action = "";	//added by shan 11.04.2013 (change_lov_property program unit)	
		if ($F("txtTransactionType") == 2){
			action = "getGiacOldItemNoLOV";
		}else if($F("txtTransactionType") == 4){
			action = "getGiacOldItemNoFor4LOV";
		}
		
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action   : action,
				moduleId : "GIACS026",
					page : 1,
		 transactionType : $("txtTransactionType").value,
		   controlModule :  "GIACS026",
			},
			title: "Old Item No.",
			width: 800,
			height: 400,
			columnModel: [
	 			{
					id : 'oldItemNo',
					title: 'Old Item No',
					width : '90px',
					align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'oldTranType',
					title: 'Old Tran Type',
				    width: '100px',
				    align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'dspCollectionAmt',
					title: 'Amount',
				    width: '100px',
				    align: 'right',
				    titleAlign: 'right',
				    geniisysClass: 'money',
					geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
					maxlength: 30
				},
				{
					id : 'dspOldTranNo',
					title: 'Old Tran No.',
				    width: '90px',
				    align: 'left',
					titleAlign : 'left'
				},
				{
					id : 'dspParticulars',
					title: 'Particulars',
				    width: '120px',
				    align: 'left',
					titleAlign : 'left'
				},
				{
					id : 'dspTranClass',
					title: 'Tran Class',
				    width: '100px',
				    align: 'left',
					titleAlign : 'left'
				},
				{
					id : 'dspTranClassNo',
					title: 'Tran Class No',
				    width: '100px',
				    align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'branchCd',
					title: 'Branch Cd',
				    width: '80px',
				    align: 'left',
					titleAlign : 'left'
				},
				{
					id : 'intmNo',
					title: 'Intm No',
				    width: '80px',
				    align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'dspPolicyNo',
					title: 'Policy No',
				    width: '120px',
				    align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'b140IssCd',
					title: 'Iss Cd',
				    width: '80px',
				    align: 'left',
					titleAlign : 'left'
				},
				{
					id : 'b140PremSeqNo',
					title: 'Prem Seq No',
				    width: '100px',
				    align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'commRecNo',
					title: 'Comm Rec No',
				    width: '100px',
				    align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'lineCd',
				    width: '0px',
				    visible: false
				},
				{
					id : 'sublineCd',
				    width: '0px',
				    visible: false
				},
				{
					id : 'issCd',
				    width: '0px',
				    visible: false
				},
				{
					id : 'issueYy',
				    width: '0px',
				    visible: false
				},
				{
					id : 'polSeqNo',
				    width: '0px',
				    visible: false
				},
				{
					id : 'renewNo',
				    width: '0px',
				    visible: false
				},
				{
					id : 'riCd',
				    width: '0px',
				    visible: false
				},
				{
					id : 'b140PremSeqNo',
				    width: '0px',
				    visible: false
				},
				{
					id : 'b140IssCd',
				    width: '0px',
				    visible: false
				},
				{
					id : 'oldTranId',
				    width: '0px',
				    visible: false
				}
			],
			draggable: true,
			onSelect: function(row) {
				if(row != undefined){
					$("txtOldTranId").value = row.oldTranId;
					$("txtOldItemNo").value = row.oldItemNo;
					$("txtOldTranType").value = row.oldTranType;
					$("txtCollectionAmt").value = formatCurrency(nvl(row.dspCollectionAmt, "0"));
					$("txtTranYear").value = row.dspTranYear;
					$("txtTranMonth").value = row.dspTranMonth;
					$("txtTranSeqNo2").value = row.dspTranSeqNo;
					$("txtRemarks").value = row.dspParticulars;
					$("txtDspTranClassNo").value = row.dspTranClassNo;
					$("txtAssdNo").value = row.assdNo;
					$("txtDepFlag").value = row.depFlag;
					$("txtRiCd").value = row.riCd;
					$("txtIntmNo").value = row.intmNo;
					$("txtLineCd").value = row.lineCd;
					$("txtSublineCd").value = row.sublineCd;
					$("txtIssCd").value = row.issCd;
					$("txtIssueYy").value = row.issueYy;
					$("txtPolSeqNo").value = row.polSeqNo;
					$("txtRenewNo").value = row.renewNo;
					$("txtB140IssCd").value = row.b140IssCd;
					$("txtB140PremSeqNo").value = row.b140PremSeqNo;
					$("txtCommRecNo").value = row.commRecNo;
					$("oldTranTypeOkForValidation").value = "Y";
					$("txtInstNo").value = row.instNo;
					
					$("txtParLineCd").value	= row.parLineCd;
					$("txtParIssCd").value = row.parIssCd;
					$("txtParYy").value = row.parYy;	
					$("txtParSeqNo").value = row.parSeqNo;	
					$("txtQuoteSeqNo").value = row.quoteSeqNo;
					
					$("txtDrvAssuredName").value = nvl(row.assdNo,"") != ""  || nvl(unescapeHTML2(row.dspAssdName),"") != "" ? unescapeHTML2(row.assdNo + " - " + unescapeHTML2(row.dspAssdName)) : "";
					$("txtDrvIntmName").value = nvl(row.intmNo,"") != ""  || nvl(unescapeHTML2(row.dspIntmName),"") != ""  ? unescapeHTML2(row.intmNo + " - "  + unescapeHTML2(row.dspIntmName)) : "";
					$("txtDrvRiName").value = nvl(row.riCd,"") != ""  || nvl(unescapeHTML2(row.dspReinsurerName),"") != ""  ? unescapeHTML2(row.riCd + " - "  + unescapeHTML2(row.dspReinsurerName)) : "";
					$("txtParNo").value = unescapeHTML2(row.dspParNo);
					$("txtAssuredName").value = nvl(unescapeHTML2(row.dspAssdName),"");
					$("txtIntmName").value = nvl(unescapeHTML2(row.dspIntmName),"");
					$("txtRiName").value = nvl(unescapeHTML2(row.dspReinsurerName),"");
					
					$("txtCurrencyCd").value = row.currencyCd;
					$("txtDspCurrencyDesc").value = unescapeHTML2(row.currencyDesc);
					$("txtConvertRate").value = formatToNthDecimal(row.convertRate,9);
					$("txtForeignCurrAmt").value = formatCurrency(row.foreignCurrAmt);
					
					validateOldTranType();	//added to fetch Amount default value : shan 11.04.2013
					
					if (validateTranType1()) {
						getParSeqNo2();
					}
				}
			},
			onCancel: function(){
	  			$("oscmOldTransactionNo").focus();
	  		}
		});
	}catch(e){
		showErrorMessage("showGIACOldItemNoLOV",e);
	}
}