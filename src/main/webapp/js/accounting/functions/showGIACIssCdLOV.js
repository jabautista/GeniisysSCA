/**
Shows Iss Cd LOV for GIAC Premium Deposit
* @author emsy bolaños
* @date 06.11.2012
* @module GIACS026
*/
function showGIACIssCdLOV(){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action   : "getGiacIssCdLOV",
				issCd	 : $F("txtB140IssCd"),
				filterText : nvl(($F("txtB140PremSeqNo")), "%"),
				moduleId : "GIACS026",
				tranType: $F("txtTransactionType"),
					page : 1
			},
			title: "Giac Aging Soa Details",
			width: 800,
			height: 380,
			columnModel: [
	 			{
					id : 'b140IssCd',
					title: 'Iss Code',
					width : '70px',
					align: 'left',
					titleAlign : 'left'
				},
				{
					id : 'b140PremSeqNo',
					title: 'Inv No',
				    width: '50px',
				    align: 'right',
				    titleAlign: 'right'
				},
				{
					id : 'instNo',
					title: 'Inst No',
				    width: '60px',
				    align: 'right',
				    titleAlign: 'right'
				},
				{
					id : 'dspA150LineCd',
					title: 'A150 Line Cd',
				    width: '90px',
				    align: 'left'
				},
				{
					id : 'dspTotalAmountDue',
					title: 'Total Amount Due',
				    width: '120px',
				    align: 'right',
				    titleAlign: 'right',
				    geniisysClass: 'money',
					geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
					maxlength: 30
				},
				{
					id : 'dspTotalPayments',
					title: 'Total Payments',
				    width: '110px',
				    align: 'right',
				    titleAlign: 'right',
				    geniisysClass: 'money',
					geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
					maxlength: 30
				},
				{
					id : 'dspTempPayments',
					title: 'Temp Payments',
				    width: '110px',
				    align: 'right',
				    titleAlign: 'right',
				    geniisysClass: 'money',
					geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
					maxlength: 30
				    	
				},	
				{
					id : 'dspBalanceAmtDue',
					title: 'Balance Amt Due',
				    width: '120px',
				    align: 'right',
				    titleAlign: 'right',
				    geniisysClass: 'money',
					geniisysErrorMsg: 'Field must be of form 99,999,999,999,990.00.',
					maxlength: 30
				},
				{
					id : 'dspA020AssdNo',
					title: 'A020 Assd No',
				    width: '100px',
				    align: 'right',
				    titleAlign: 'right'
				},
				{
					id : 'assuredName',
					width : '0px',
					visible: false
				}
			],
			autoSelectOneRecord : true,
			filterText: nvl(($F("txtB140PremSeqNo")), "%"),
			draggable: true,
			onSelect: function(row) {
				if(row != undefined){
				$("txtB140IssCd").value = unescapeHTML2(row.b140IssCd);
				premDepIssCdTrigger();
				$("txtB140PremSeqNo").value = row.b140PremSeqNo;
				$("txtInstNo").value = row.instNo;
				$("txtDspA150LineCd").value = unescapeHTML2(row.dspA150LineCd);
				$("txtDspTotalAmountDue").value = row.dspTotalAmountDue;
				$("txtDspTotalPayments").value = row.dspTotalPayments;
				$("txtDspTempPayments").value = row.dspTempPayments;
				$("txtDspBalanceAmtDue").value = row.dspBalanceAmtDue;
				$("txtAssdNo").value = row.dspA020AssdNo;
				$("txtAssuredName").value = row.assuredName;
				$("txtDrvAssuredName").value = row.dspA020AssdNo + " - " + unescapeHTML2(row.assuredName);	//added unescapeHTML2 : shan 11.04.2013
				validateTranType1();
				getParSeqNo2();
				}
			}
		});
	}catch(e){
		showErrorMessage("showGIACIssCdLOV",e);
	}
	
}