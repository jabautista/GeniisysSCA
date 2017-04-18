<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="commVoucherDetailsMainDiv" class="sectionDiv" style="width: 920px; height: 505px;">
	<div id="cvDetailsDiv" class="sectionDiv" style="width: 750px; height: 450px; margin: 30px 0 0 100px;">
		<table style="width: 700px; margin: 20px 0 10px 25px;">
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Transaction Date</td>
				<td><input id="txtTranDate" type="text" readonly="readonly" style="width: 200px"> </td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Ref. No.</td>
				<td>
					<input id="txtRefNo" type="text" readonly="readonly" style="width: 145px"> 
					<input id="txtTranClass" type="text" readonly="readonly" style="width: 43px"> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Invoice No./Inst No</td>
				<td>
					<input id="txtIssCd" type="text" readonly="readonly" style="width: 40px"> 
					<input id="txtPremSeqNo" type="text" readonly="readonly" style="width: 95px"> 
					<input id="txtInstNo" type="text" readonly="readonly" style="width: 40px"> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Collection Amount</td>
				<td><input id="txtCollectionAmt" type="text" readonly="readonly" class="rightAligned" style="width: 200px"> </td>
				<td class="rightAligned" style="padding-right: 7px;">Commission Amount</td>
				<td><input id="txtCommissionAmt" type="text" readonly="readonly" class="rightAligned" style="width: 200px"> </td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Premium Amount</td>
				<td><input id="txtPremiumAmt" type="text" readonly="readonly" class="rightAligned" style="width: 200px"> </td>
				<td class="rightAligned" style="padding-right: 7px;"><label>&nbsp; + &nbsp;&nbsp;&nbsp;&nbsp; Input VAT</label></td>
				<td><input id="txtInputVat" type="text" readonly="readonly" class="rightAligned money" style="width: 200px"> </td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Tax Amount</td>
				<td><input id="txtTaxAmt" type="text" readonly="readonly" class="rightAligned" style="width: 200px"> </td>
				<td class="rightAligned" style="padding-right: 7px;"><label>&nbsp; - &nbsp;&nbsp;&nbsp;&nbsp; Withholding Tax</label></td>
				<td><input id="txtWholdingTax" type="text" readonly="readonly" class="rightAligned" style="width: 200px"> </td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Notarial Fee</td>
				<td><input id="txtNotarialFee" type="text" readonly="readonly" class="rightAligned" style="width: 200px"> </td>
				<td class="rightAligned" style="padding-right: 7px;"><label>&nbsp; - &nbsp;&nbsp;&nbsp;&nbsp; Advances</label></td>
				<td><input id="txtAdvances" type="text" class="rightAligned money" style="width: 200px"> </td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Other Charges</td>
				<td><input id="txtOtherCharges" type="text" readonly="readonly" class="rightAligned" style="width: 200px" > </td>
				<td class="rightAligned" style="padding-right: 7px;"> Net Commission Due</td>
				<td><input id="txtNetCommDue" type="text" readonly="readonly" class="rightAligned" style="width: 200px"> </td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding: 35px 7px 0 0;">Intermediary</td>
				<td colspan="3" style="padding-top: 35px;">
					<input id="txtIntmNo" type="text" readonly="readonly" class="rightAligned" style="width: 50px">
					<input id="txtIntmName" type="text" readonly="readonly" style="width: 500px"> 
			 	</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px">Assured</td>
				<td colspan="3">
					<input id="txtAssdName" type="text" readonly="readonly"style="width: 562px"> 
			 	</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Child Intm No</td>
				<td colspan="3">
					<input id="txtChldIntmNo" type="text" readonly="readonly" class="rightAligned" style="width: 50px">
					<input id="txtChldIntmName" type="text" readonly="readonly" style="width: 500px"> 
			 	</td>
			</tr>
		</table>
		
		<div class="buttonsDiv" style="width: 750px; height: 30px;">
			<input id="btnReturn" type="button" class="button" value="Return" style="width: 90px; margin-right: 20px;">
			<!-- <input id="btnSave" type="button" class="button" value="Save"> -->
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	initializeAllMoneyFields();
	//disableButton("btnSave");
	var hasChanged = false;
	var advances = objGIACS149.selectedRow.varAdvances;
	
	
	$("txtTranDate").value = dateFormat(objGIACS149.selectedRow.tranDate, 'mm-dd-yyyy');
	$("txtRefNo").value = objGIACS149.selectedRow.dspRefNo;
	$("txtTranClass").value = objGIACS149.selectedRow.tranClass;
	$("txtIssCd").value = objGIACS149.selectedRow.issCd;
	$("txtPremSeqNo").value = objGIACS149.selectedRow.premSeqNo;
	$("txtInstNo").value = objGIACS149.selectedRow.instNo;
	$("txtCollectionAmt").value = formatCurrency(objGIACS149.selectedRow.collectionAmt);
	$("txtCommissionAmt").value = formatCurrency(objGIACS149.selectedRow.commissionAmt);
	$("txtPremiumAmt").value = formatCurrency(objGIACS149.selectedRow.premMinusOthers);
	$("txtCollectionAmt").value = formatCurrency(objGIACS149.selectedRow.collectionAmt);
	$("txtInputVat").value = formatCurrency(objGIACS149.selectedRow.inputVat);
	$("txtTaxAmt").value = formatCurrency(objGIACS149.selectedRow.taxAmt);
	$("txtWholdingTax").value = formatCurrency(objGIACS149.selectedRow.withholdingTax);
	$("txtNotarialFee").value = formatCurrency(objGIACS149.selectedRow.notarialFee);
	$("txtAdvances").value = formatCurrency(objGIACS149.selectedRow.varAdvances);
	$("txtOtherCharges").value = formatCurrency(objGIACS149.selectedRow.otherCharge);
	$("txtNetCommDue").value = formatCurrency(objGIACS149.selectedRow.netCommDue);
	$("txtIntmNo").value = objGIACS149.selectedRow.intmNo;
	$("txtIntmName").value = objGIACS149.fieldValues[0].intmName;
	$("txtAssdName").value = objGIACS149.selectedRow.assdName;
	$("txtChldIntmNo").value = objGIACS149.selectedRow.chldIntmNo;
	$("txtChldIntmName").value = objGIACS149.selectedRow.chldIntmName;
	
	if(objGIACS149.selectedRow.cancelTag == "Y"){
		//$("txtInputVat").readOnly = true;
		$("txtAdvances").readOnly = true;
	}else{
		//$("txtInputVat").readOnly = false;
		$("txtAdvances").readOnly = false;
	}
		
	function saveAmtChanges(btn){
		try{
			new Ajax.Request(contextPath+"/GIACGenearalDisbReportController", {
				parameters: {
					action:			"updateGIACS149DtlAmount",
					gfunFundCd:		objGIACS149.selectedRow.gfunFundCd,
					gibrBranchCd:	objGIACS149.selectedRow.gibrBranchCd,
					gaccTranId:		objGIACS149.selectedRow.gaccTranId,
					tranType:		objGIACS149.selectedRow.transactionType,
					issCd:			objGIACS149.selectedRow.issCd,
					premSeqNo:		objGIACS149.selectedRow.premSeqNo,
					instNo:			objGIACS149.selectedRow.instNo,
					intmNo:			objGIACS149.selectedRow.intmNo,
					chldIntmNo:		objGIACS149.selectedRow.chldIntmNo,
					inputVat:		unformatCurrency("txtInputVat"),
					advances:		unformatCurrency("txtAdvances")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showMessageBox("Update successful.","S");
							disableButton("btnSave");
							hasChanged = false;
							
							if(btn == "R"){
								showGIACS149Page("N");
							}
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("saveAmtChanges", e);
		}
	}
	
	$("txtInputVat").observe("blur", function(){
		if ($F("txtInputVat") == ""){
			$("txtInputVat").value = formatCurrency(0);
		}
		/*if(objGIACS149.selectedRow.inputVat != unformatCurrency("txtInputVat")){
			hasChanged = true;
			enableButton("btnSave");
		}*/
	});
	
	
	$("txtAdvances").observe("select", function(){
		advances = $F("txtAdvances");
	});
	
	$("txtAdvances").observe("blur", function(){
		if ($F("txtAdvances") == ""){
			$("txtAdvances").value = formatCurrency(0);
		}else{
			if ($F("txtAdvances") == ""){
				$("txtAdvances").value = formatCurrency(0);
				advances = 0;
			}
			if(advances != unformatCurrency("txtAdvances")){
				var netCommDue = parseFloat(objGIACS149.selectedRow.netCommDue) + parseFloat(objGIACS149.selectedRow.varAdvances) 
								 - parseFloat($F("txtAdvances"));
				
				$("txtNetCommDue").value = formatCurrency(netCommDue);
			}
		}
		/*if(objGIACS149.selectedRow.varAdvances != unformatCurrency("txtAdvances")){
			hasChanged = true;
			enableButton("btnSave");
		}*/
	});
	
	/*$("btnSave").observe("click", function(){
		saveAmtChanges("S");
	});*/
	
	$("btnReturn").observe("click", function(){
		if (hasChanged){
			showConfirmBox4("Confirm", "Do you want to save the changes you have made?",
							"Yes", "No", "Cancel", 
							function() {
								saveAmtChanges("R");
							},
							function(){
								showGIACS149Page("N");
							},
							null, null
			);
		}else{
			showGIACS149Page("N");
		}
			
	});
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>