function enableDisableBillForm(enableSw){
	$("hrefBillRemarks").stopObserving("click");
	if(enableSw == "enable"){
		//$("selDocType").enable(); -- commented lines is handled in populateLossExpBillForm
		//$("hrefBillPayeeClassCd").show();
		//$("hrefBillPayeeCd").show();
		$("hrefBillDate").show();
		//$("txtDocNumber").readOnly = false;
		$("txtBillAmt").readOnly = false;
		$("txtBillRemarks").readOnly = false;
		enableButton("btnAddLossExpBill");
		enableButton("btnDeleteLossExpBill");
		enableButton("btnSaveBill");
		$("hrefBillRemarks").observe("click", function(){
			showEditor("txtBillRemarks", 4000);
		});
	}else{
		$("selDocType").disable();
		$("hrefBillPayeeClassCd").hide();
		$("hrefBillPayeeCd").hide();
		$("hrefBillDate").hide();
		$("txtDocNumber").readOnly = true;
		$("txtBillAmt").readOnly = true;
		$("txtBillRemarks").readOnly = true;
		disableButton("btnAddLossExpBill");
		disableButton("btnDeleteLossExpBill");
		disableButton("btnSaveBill");
		$("hrefBillRemarks").observe("click", function(){
			showEditor("txtBillRemarks", 4000, "true");
		});
	}
}