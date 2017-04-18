<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;" class="perilInformation">
	<div id="innerDiv" name="innerDiv" >
   		<label>Peril Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="perilInfoLbl" name="gro">Hide</label>
   		</span>
   	</div>
</div>
<div id="perilInformationDiv" class="sectionDiv">
	<div id="perilInformation" style="margin: 10px;">
		<div id="itemPerilTable" name="itemPerilTable">
			<div class="tableHeader">
				<label style="width: 25%; text-align: left; padding-left: 40px;">Peril Name</label>
		   		<label style="width: 9%; text-align: right;">Rate</label>
				<label style="width: 13%; text-align: right;">TSI Amount</label>
				<label style="width: 15%; text-align: right;">Premium Amount</label>
				<label style="width: 30%; text-align: left; padding-left: 10px;">Remarks</label>
			</div>
			<div id="quoteItemPerilTableContainer" name="quoteItemPerilTableContainer" class="tableContainer" style="">
			</div>
		</div>
	</div>
	
	<div style="margin: 10px; margin-top: 1px;" id="quoteItemPerilForm" class="quoteChildRecord">
		<table cellspacing="1" border="0" style="margin: 10px auto;">
			<tr style="display: none;" id="messagePeril" name="messagePeril">
				<td colspan="4" style="padding: 0; padding-right: 29px;"><label style="margin: 0; float: right; text-align: left; font-size: 9px; padding: 2px; background-color: #98D0FF; width: 233px;">Peril already exists.</label></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">Total Premium Amount</td>
				<td class="leftAligned"  style="width: 210px;">
					<input id="txtTotalPremiumAmount" disabled="disabled" name="txtTotalPremiumAmount" class="money" type="text" readonly="readonly" style="width: 210px;" value="0"/>
				</td>
				<td class="rightAligned" style="width: 100px;">Total TSI Amount</td>
				<td class="leftAligned"  style="width: 210px;">
					<input id="txtTotalTsiAmount" disabled="disabled" name="txtTotalTsiAmount" type="text" class="money" readonly="readonly" style="width: 210px;" value="0"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">Peril Name </td>
				<td class="leftAligned" style="width: 210px;">
					<div class="required" style="float: left; border: solid 1px gray; width: 216px; height: 20px; margin-right: 3px;">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 185px; border: none; background-color: transparent;" name="txtPerilName" id="txtPerilName" readonly="readonly"/>
						<img id="hrefPeril" alt="goPeril" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					
				</td>
				<td class="rightAligned" style="width: 100px;" name="itemTitleTd">Peril Rate</td>
				<td class="leftAligned">
					<input id="txtPerilRate" name="txtPerilRate" type="text" class="nineDecimalPercentage required" style="width: 210px; text-align: right;" value="0" maxlength="13"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">TSI Amt </td>
				<td class="leftAligned">
					<input id="txtTsiAmount" name="txtTsiAmount" type="text" class="money required" value="0.00" style="width: 210px;" maxlength="17" />
				</td>
				<td class="rightAligned">Prem. Amt </td>
				<td class="leftAligned">
					<input id="txtPremiumAmount" name="txtPremiumAmount" type="text" class="money required" value="0.00" style="width: 210px;" maxlength="17" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Remarks </td>
				<td class="leftAligned" colspan="3">
					<div style="border: 1px solid gray; height: 20px; width: 550px;">
						<textarea id="txtRemarks" name="txtRemarks" onKeyDown="limitText(this,50);" onKeyUp="limitText(this,50);" style="width: 510px; border: none; height: 13px;" ></textarea>
						<img id="editRemarks" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit"  />
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div style="margin-bottom: 10px;" changeTagAttr="true">
		<input type="button" id="btnAddPeril"    name="btnAddPeril"    style="width: 90px;" class="button hover"   value="Add Peril" />
		<input type="button" id="btnDeletePeril" name="btnDeletePeril" style="width: 95px;" class="disabledButton" value="Delete Peril" disabled="disabled" />
	</div>
</div>

<script type="text/javascript">
	objPackQuoteItemPerilList = JSON.parse('${objPackQuoteItemPerilList}'.replace(/\\/g, '\\\\'));
	showQuoteItemPerilList(objPackQuoteItemPerilList);
	
	$("hrefPeril").observe("click", function(){
		var selectedQuote = getSelectedRow("quoteRow");
		var selectedItem = getSelectedRow("row");

		if(selectedQuote == null){
			showMessageBox("There is no quotation selected.");
			return false;
		}else if(selectedItem == null){
			showMessageBox("Please select an item first.");
		}else{
			var lineCd = selectedQuote.getAttribute("lineCd");
			var sublineCd = selectedQuote.getAttribute("sublineCd");
			var perilType = "";
			var notIn = "";
			var withPrevious = false;

			$$("div#itemPerilTable div[name='perilRow']").each(function(row){
				if(row.getAttribute("quoteId")== objCurrPackQuote.quoteId && 
				   row.getAttribute("itemNo") == selectedItem.getAttribute("itemNo")){
					if(withPrevious) notIn += ",";
					notIn += row.getAttribute("perilCd");
					withPrevious = true;
				}			
			});
			notIn = (notIn != "" ? "("+notIn+")" : null);
			if(notIn == null){
				perilType = "B";
			}
			showQuotePerilLOV(lineCd, sublineCd, perilType, notIn);
		}
		
	});

	$("editRemarks").observe("click", function(){
		showEditor($("txtRemarks"), 50);
	});

	$("txtPerilRate").observe("change", function(){ //replaced blur with change - christian 03/05/2013
		if($F("txtPerilRate") == "" || $F("txtPerilRate") == "NaN" || $F("txtPerilRate") == "Infinity"){
			$F("txtPerilRate") == 0;
		} else if (parseInt($F("txtPerilRate")) > 100 || parseInt($F("txtPerilRate")) < 0){
			showMessageBox("Peril rate must be in range 0 to 100.");
			$("txtPerilRate").value = "0";
		} else if($F("txtTsiAmount") != "" && objCurrPackQuote != null) {
			$("txtPremiumAmount").value = computePremiumAmountForPackQuote();
		}
		$("txtPerilRate").value = formatToNineDecimal($F("txtPerilRate"));
	});

	$("txtTsiAmount").observe("change", function(){ //replaced blur with change - christian 03/05/2013
		try {
			var tsiAmt = parseFloat($F("txtTsiAmount").replace(/,/g, ""));
			
			if(isNaN(tsiAmt)){
				showMessageBox("Invalid TSI Amt. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
				$("txtTsiAmount").value = "0";
				$("txtTsiAmount").focus();
			}else if(tsiAmt > parseFloat(99999999999999.99) || tsiAmt < parseFloat(0.01)){
				showMessageBox("Invalid TSI Amt. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
				$("txtTsiAmount").value = "0";
				$("txtTsiAmount").focus();
			}else{
				if($F("txtPerilRate") != "" && objCurrPackQuote != null) {
					$("txtPremiumAmount").value = computePremiumAmountForPackQuote();
				}
				if($F("btnAddPeril") == "Update Peril") confirmDeleteDeductibles();
			}
			$("txtTsiAmount").value = formatCurrency($F("txtTsiAmount"));
			
		} catch(e){
			showErrorMessage("txtTsiAmount", e);
		}
	});

	var origPremiumAmount = "0";
	$("txtPremiumAmount").observe("focus", function(){
		origPremiumAmount = $F("txtPremiumAmount");
	});

	$("txtPremiumAmount").observe("change", function(){ //replaced blur with change - christian 03/05/2013
		var premAmt = parseFloat($F("txtPremiumAmount").replace(/,/g, ""));

		if(isNaN(premAmt)){
			showMessageBox("Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
			$("txtPremiumAmount").value = origPremiumAmount;
			$("txtPremiumAmount").focus();
		}else if(premAmt != parseFloat(origPremiumAmount.replace(/,/g, ""))){
			var perilRate = recomputePerilRateForPackQuote();

			if(perilRate > 100){
				showMessageBox("Premium Rate exceeds 100%. Premium Amount should not be greater than TSI Amount");
				$("txtPremiumAmount").value = origPremiumAmount;
			}else{
				$("txtPerilRate").value = perilRate;
			}
		}
		$("txtPremiumAmount").value = formatCurrency($F("txtPremiumAmount"));
	});

	//created by christian 03/05/2013
	function confirmDeleteDeductibles(){
		try{
			var selectedPerilRow = getSelectedRow("perilRow");
			var exist = false;
			
			for(var i=0; i<objPackQuoteDeductiblesList.length; i++){
				if (objPackQuoteDeductiblesList[i].quoteId == selectedPerilRow.getAttribute("quoteId") &&
						objPackQuoteDeductiblesList[i].itemNo == selectedPerilRow.getAttribute("itemNo") &&
						objPackQuoteDeductiblesList[i].perilCd == selectedPerilRow.getAttribute("perilCd") &&
						objPackQuoteDeductiblesList[i].recordStatus != -1 &&
						objPackQuoteDeductiblesList[i].deductibleType == "T"){
						exist = true;
					}
			}	
			
			if(exist){
				showConfirmBox("Delete Deductibles", "The item has an existing deductible based on % of TSI. Changing TSI Amt will delete the existing deductible. Continue?", "Ok", "Cancel", 
					function(){
						deleteAllQuoteItemDeductibles(selectedPerilRow.getAttribute("quoteId"), selectedPerilRow.getAttribute("itemNo"));
						setQuoteDeductibleInfoForm(null);
					}, 
					function(){
						setQuoteItemPerilInfoForm(null);
					});
			}
		}catch(e){
			showErrorMessage("confirmDeleteDeductibles", e);			
		}
	}
	
	$("btnAddPeril").observe("click", function(){
		var itemRow = getSelectedRow("row");
		var currInv = getCurrPackQuoteInvoice(itemRow);
		
		if(validateBeforeAddOrUpdatePeril()){
			if($F("btnAddPeril") == "Add Peril"){
				var newPeril = setQuoteItemPerilObject();
				addQuoteItemPeril(newPeril);

			}else if($F("btnAddPeril")=="Update Peril"){
				var updatedPeril = setQuoteItemPerilObject();
				var selectedPerilRow = getSelectedRow("perilRow");
				addModedObjByAttr(objPackQuoteItemPerilList, updatedPeril,"quoteId perilCd"); //Rey for the peril computation error during t
				var updatedRow = prepareQuoteItemPerilTable(updatedPeril);					  //11-03-2011
				selectedPerilRow.update(updatedRow);
				selectedPerilRow.removeClassName("selectedRow");
				resizeTableBasedOnVisibleRows("itemPerilTable", "quoteItemPerilTableContainer");
				computeTotalItemTsiandPremAmount("txtTotalTsiAmount", "txtTotalPremiumAmount");
				setQuoteItemPerilInfoForm(null);
				setPackQuoteDeductiblePerilLov();
			}

			if(currInv == null){
				generatePackQuoteInvoice();
			}else{
				currInv.recordStatus = 1;
				quotePerilChangeTag = 1;
			}
			hidePackQuoteInvoiceSubPage();
		}
		
		
	});

	$("btnDeletePeril").observe("click", function(){
		var selectedPerilRow = getSelectedRow("perilRow");
		var alliedPeril = checkAlliedPerilsIfExisting(selectedPerilRow.getAttribute("perilCd")); 

		if(alliedPeril != ""){
			showMessageBox("The peril '" + alliedPeril + "' must be deleted first.", imgMessage.ERROR);
		}else{
			for (var i = 0; i < objPackQuoteItemPerilList.length; i++){
				if (objPackQuoteItemPerilList[i].quoteId == selectedPerilRow.getAttribute("quoteId") &&
					objPackQuoteItemPerilList[i].itemNo == selectedPerilRow.getAttribute("itemNo") &&
					objPackQuoteItemPerilList[i].perilCd == selectedPerilRow.getAttribute("perilCd")){
					objPackQuoteItemPerilList[i].recordStatus = -1;
					deleteAllQuoteItemDeductibles(objPackQuoteItemPerilList[i].quoteId, objPackQuoteItemPerilList[i].itemNo);
				}
			}
			selectedPerilRow.remove();
			resizeTableBasedOnVisibleRows("itemPerilTable", "quoteItemPerilTableContainer");
			computeTotalItemTsiandPremAmount("txtTotalTsiAmount", "txtTotalPremiumAmount");
			setQuoteItemPerilInfoForm(null);
			setPackQuoteDeductiblePerilLov();

			var itemRow = getSelectedRow("row");
			var currInv = getCurrPackQuoteInvoice(itemRow);
			if(currInv == null){
				generatePackQuoteInvoice();
			}else{
				currInv.recordStatus = 1;
				quotePerilChangeTag = 1;
			}
			hidePackQuoteInvoiceSubPage();
		}
	});

	function validateBeforeAddOrUpdatePeril(){
		try{
			var perilCd = $("txtPerilName").getAttribute("perilCd");
			var perilName = $("txtPerilName").value;
			var perilType = $("txtPerilName").getAttribute("perilType");
			var basicPerilCd = $("txtPerilName").getAttribute("basicPerilCd");
			var basicPerilName = $("txtPerilName").getAttribute("basicPerilName");
			var perilRate = parseFloat(nvl($F("txtPerilRate").replace(/\$|\,/g,''), 0));
			var tsiAmount =   parseFloat(nvl($F("txtTsiAmount").replace(/\$|\,/g,''), 0));
			var premiumAmount = parseFloat(nvl($F("txtPremiumAmount").replace(/\$|\,/g,''), 0));
			var itemNo = parseInt(getSelectedRowId("row"));
			
			if(perilName == null || perilName.blank()){
				showMessageBox("Peril name is required.", imgMessage.ERROR);
				return false;
			}else if(checkIfPerilIsExisting(perilCd) && $F("btnAddPeril") == "Add Peril"){
				showMessageBox("Peril must be unique.", imgMessage.ERROR);
				return false;
			}else if($F("txtPerilRate").empty()){
				showMessageBox("Peril Rate is required.", imgMessage.ERROR);
				return false;
			}else if(tsiAmount==0){
				showMessageBox("TSI Amount is required.", imgMessage.ERROR);
				return false;
			}else if((premiumAmount < tsiAmount) && (premiumAmount > 9999999999.99) && (perilType!="A")){
				showMessageBox("Invalid Prem Amt. Value should be from <br />0.01 to 9,999,999,999.99 <br />and must not be less than TSI Amt.", imgMessage.ERROR);
				return false;
			}else if(tsiAmount > 99999999999999.99){
				showMessageBox("Invalid TSI Amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
				return false;
			}else if(perilType == "A" && nvl(basicPerilCd, "") != "" && !checkIfPerilIsExisting(basicPerilCd)){
				showWaitingMessageBox( basicPerilName + " should exists before this peril can be added.", imgMessage.INFO, function(){fireEvent($("hrefPeril"), "click");});
				return false;
			}else if(perilType == "A" && nvl(basicPerilCd, "") != "" && checkIfPerilIsExisting(basicPerilCd) && (tsiAmount > getPerilTsiAmount(basicPerilCd))){
				showMessageBox("TSI Amount must be less than " + formatCurrency(getPerilTsiAmount(basicPerilCd)));
				return false;
			}else{
				return true;
			}
		}catch(e){
			showErrorMessage("validateBeforeAddOrUpdatePeril", e);
			return false;
		}
	}

	function addQuoteItemPeril(newPeril){
		var isDefaultWCExist = "";

		try{
			new Ajax.Request(contextPath+"/GIPIQuotationWarrantyAndClauseController",{
				parameters:{
					action: "checkQuotePerilDefaultWarranty",
					quoteId: newPeril.quoteId,
					lineCd: newPeril.lineCd,
					perilCd: newPeril.perilCd
				},
				onComplete: function(response){
					if((response.responseText == "Y" || response.responseText == "N")){
						isDefaultWCExist = response.responseText;
						
						function addPeril(){
							addNewItemObject(objPackQuoteItemPerilList, newPeril);
							var newPerilRow = createQuoteItemPerilRow(newPeril);
							$("quoteItemPerilTableContainer").insert({bottom : newPerilRow});
							setQuoteItemPerilRowObserver(newPerilRow);
							resizeTableBasedOnVisibleRows("itemPerilTable", "quoteItemPerilTableContainer");
							computeTotalItemTsiandPremAmount("txtTotalTsiAmount", "txtTotalPremiumAmount");
							setPackQuoteDeductiblePerilLov();
							setQuoteItemPerilInfoForm(null);
						};
						
						if(isDefaultWCExist == "Y"){
							showConfirmBox("Confirmation", "Do you want to attach default warranty?", "Yes", "No", 
									function(){
										newPeril.wcSw = "Y";
										addPeril();
									}, addPeril);
						}else if(isDefaultWCExist == "N"){
							newPeril.wcSw = "N";
							addPeril();
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("addQuoteItemPeril", e);
		}
	}
</script>
