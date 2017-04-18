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
   			<label id="perilInfoLbl" name="gro">Show</label>
   		</span>
   	</div>
</div>
<div id="perilInformationMotherDiv" class="">
	<div id="perilInformationDiv" style="display: none;" class="sectionDiv">
		<input type="hidden" id="itemNoOfPeril" name="itemNoOfPeril" value=""/>
		<div id="perilInformation" style="margin: 10px;" class="tableContainer">
			<div id="itemPerilTable" name="itemPerilTable">
				<div class="tableHeader">
					<label style="width: 25%; text-align: left; padding-left: 40px;">Peril Name</label>
			   		<label style="width:  9%; text-align: right;">Rate</label>
					<label style="width: 13%; text-align: right;">TSI Amount</label>
					<label style="width: 13%; text-align: right;">Premium Amount</label>
					<label style="width: 32%; text-align: left; padding-left: 10px;">Remarks</label>
				</div>
				<div id="deductiblesPerItem" name="deductiblesPerItem">
				</div>
				<div id="itemPerilMotherDiv" name="itemPerilMotherDiv" style=""></div>
			</div>
		</div>
		<div id="removedDedDiv" name="removedDedDiv" style="visibility: hidden;"></div>
		<div style="margin: 10px; margin-top: 1px;" id="quoteItemPerilForm">
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
						<select id="selPerilName" name="selPerilName" style="width: 218px;" class="required"></select>
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
						<div style="border: 1px solid gray; height: 20px; width: 544px;">
							<textarea id="txtRemarks" name="txtRemarks" onKeyDown="limitText(this,50);" onKeyUp="limitText(this,50);" style="width: 490px; border: none; height: 13px;" ></textarea>
							<img id="editRemarks" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit"  />
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<input type="button" id="btnAddPeril"    name="btnAddPeril"    style="width: 70px;" class="button hover"   value="Add" />
						<input type="button" id="btnDeletePeril" name="btnDeletePeril" style="width: 70px;" class="disabledButton" value="Delete" disabled="disabled" />
					</td> 
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
// 	var perilNameChanged = false;
if(isMakeQuotationInformationFormsHidden == 1){
	$("btnAddPeril").hide();
	$("btnDeletePeril").hide();
	$("txtTsiAmount").readOnly = true;
	$("txtPerilRate").readOnly = true;
	$("txtPremiumAmount").readOnly = true;
	$("txtRemarks").readOnly = true;
	$("selPerilName").disabled = true;
}

function btnDeleteSubFunction_hasDependentPerils(perilCode){
	var perilList = objGIPIQuoteItemPerilSummaryList;
	var selectedItemNo = getSelectedRowId("itemRow");
	for(var i=0; i<perilList.length; i++){
		if(perilList[i].perilCode != perilCode && perilList[i].itemNo == selectedItemNo){ // checks if peril is not pointing to itself
			if(perilCode == perilList[i].basicPerilCd){
				showMessageBox("The peril '" + perilList[i].perilName + "' must be deleted first.", imgMessage.ERROR);
				return true;
			}
		}
	}
	return false;
}

try{
	objItemPerilLov = JSON.parse('${perilLovJSON}'.replace(/\\/g, '\\\\'));
	objItemPerilDeductibleLov = JSON.parse('${perilDeductiblesLovJSON}'.replace(/\\/g, '\\\\'));
	objGIPIQuoteItemPerilSummaryList = JSON.parse('${gipiQuoteItemPerilList}'.replace(/\\/g, '\\\\'));
	// set perils to unedited
	// itemRowElement.toggleClassName("selectedRow");
	// loadRowMouseOverMouseOutObserver();
	var origPerilRate = "0";
	$("txtPerilRate").observe("focus", function(){
		origPerilRate = $F("txtPerilRate");
	});

	$("editRemarks").observe("click", function () {
		showEditor("txtRemarks", 50,(isMakeQuotationInformationFormsHidden == 1 ? "true" : ""));
	});

	$("txtPerilRate").observe("change", function(){
		if($F("txtPerilRate") == "" || $F("txtPerilRate") == "NaN" || $F("txtPerilRate") == "Infinity"){
			$F("txtPerilRate") == "0.00000";
		} else if (parseInt($F("txtPerilRate")) > 100 || parseInt($F("txtPerilRate")) < 0){
			showMessageBox("Peril rate must be in range 0 to 100");
			$("txtPerilRate").value = origPerilRate;
		} else {
			computePremiumAmount();
		}
		/*if(parseFloat($F("txtPerilRate")) < 0){
			var temp = parseFloat($F("txtPerilRate")) * (-1);
			$F("txtPerilRate") == temp;
		}*/
	});	

	var origPremiumAmount = "0";
	$("txtPremiumAmount").observe("focus", function(){
		origPremiumAmount = $F("txtPremiumAmount");
	});
	
	$("txtPremiumAmount").observe("change", function(){
		var perilRate = formatToNineDecimal($F("txtPerilRate") == "" ? "0" : $F("txtPerilRate").replace(/,/g, ""));
		var premiumAmount = parseFloat($F("txtPremiumAmount").replace(/,/g, ""));
		var tsiAmt = parseFloat($F("txtTsiAmount") == "" ? "0" : $F("txtTsiAmount").replace(/,/g, ""));
		
		switch (objGIPIQuote.prorateFlag){
			case 1:
				var diff = subtractDatesAddTwelve();
				perilRate = premiumAmount / ((parseInt($F("txtElapsedDays")/diff) * 100)/parseFloat(tsiAmt));
				break;
			case 2:
				perilRate = (premiumAmount/tsiAmt)*100;
				break;
			case 3:
				perilRate = 100(premiumAmount/(tsiAmt*parseFloat(objGIPIQuote.shortRatePercent)));
				break;
			default:
				perilRate = (premiumAmount/tsiAmt)*100;
		}
		
		if(parseInt(perilRate) > 100){
			showMessageBox("Peril rate must be in range 0 to 100");
			$("txtPremiumAmount").value = origPremiumAmount;
		}else{
			$("txtPerilRate").value = formatToNineDecimal(perilRate);
		}
	});
	
	$("txtTsiAmount").observe("change", function(){
		try {
			var perilType  = $("selPerilName").options[$("selPerilName").selectedIndex].readAttribute("perilType");
// 			var tsi = 0;
			var tsiAmt = parseFloat(parseFloat($F("txtTsiAmount")) <= 0 ? "0" : $F("txtTsiAmount").replace(/,/g, ""));
			if(isNaN($F("txtTsiAmount").replace(/,/g, ""))){
				showMessageBox("Invalid TSI Amt. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
				$("txtTsiAmount").value = "0";
				$("txtTsiAmount").focus();
			}else if(tsiAmt > parseFloat(99999999999999.99) || tsiAmt < parseFloat(0.01)){
				showMessageBox("Invalid TSI Amt. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
				$("txtTsiAmount").value = "0";
				$("txtTsiAmount").focus();
			}else if(perilType == "A"){
				computePremiumAmount();
			}else{
				computePremiumAmount();
			}
			$("txtTsiAmount").value = formatCurrency($F("txtTsiAmount"));
		} catch(e){
			showErrorMessage("txtTsiAmount", e);
		}
	});
	
	$("btnAddPeril").observe("click", function(){
		try {
			var wasEmpty = false;
			var selectedItemNo = getSelectedRowId("itemRow");
			if($F("btnAddPeril") == "Add"){
				if(willProceedWithPerilAdd()){
					var newPeril = makeGIPIQuoteItemPerilObject();
					newPeril.attachWc = attachWc;
					newPeril.recordStatus = 0; // new
					var perilRow = makeGIPIQuoteItemPerilRow(newPeril);
					
					if(objGIPIQuoteItemPerilSummaryList==null){
						objGIPIQuoteItemPerilSummaryList = new Array();
					}

					if(hasNoPerils(selectedItemNo)){
						wasEmpty = true;
					}

					objGIPIQuoteItemPerilSummaryList.push(newPeril);
					$("itemPerilMotherDiv").insert({bottom: perilRow});
					resetTableStyle("itemPerilTable","itemPerilMotherDiv","perilRow");
					attachWc = "N";
					clearChangeAttribute("perilInformationDiv");
					if($("txtInvoicePremiumAmount")!=null){
						$("txtInvoicePremiumAmount").value = $F("txtTotalPremiumAmount");
						var inv = pluckInvoiceFromList();
						if(inv != null){
							inv.premAmt = $F("txtTotalPremiumAmount").replace(/\\/g, '\\\\');
						}
					}
					
					resetQuoteItemPerilForm();
					setPerilNameLov();
				}
			}else if($F("btnAddPeril")=="Update"){
				var row = getSelectedRow("perilRow");
				// VALIDATE UPDATE
				if(row!=null){	// just for checking / unecessary
					var perilCd = "";
					row.childElements().each(function(element){
						if(element.id=="hidPerilCd"){
							perilCd = element.value;
						}
					});
					
					var perilObj = getPerilFromPerilList(perilCd,true);
					var origPerilName = perilObj.perilName;
					var perilType = perilObj.perilType;
					
					var newPeril = makeGIPIQuoteItemPerilObject();
					newPeril.recordStatus = 1;
					newPeril.attachWc = attachWc;
					newPeril.perilCd = perilCd;
					newPeril.perilName = origPerilName;
					newPeril.perilType = perilType;

					var perilList = objGIPIQuoteItemPerilSummaryList;
					for(var a=0; a<perilList.length; a++){
						var obj = perilList[a]; 
						if(obj.perilCd == perilCd && obj.itemNo == $F("txtItemNo")){
							// perilList.pop(obj);
							//obj.recordStatus = -1;
							//a = perilList.length; // stop the loop
							perilList.splice(a, 1);
							perilList.push(newPeril);
						}
					}
					
					/*var origPerilName = perilObj.perilName;
					var newPeril = makeGIPIQuoteItemPerilObject();
					newPeril.recordStatus = 1;
					newPeril.attachWc = attachWc;
	
					row.remove();
	
					newPeril.perilCd = perilCd;
					newPeril.perilName = origPerilName;

					perilList.push(newPeril); moved by: Nica 06.05.2012*/
					
					row.remove();
					var newRow = makeGIPIQuoteItemPerilRow(newPeril);
					$("itemPerilMotherDiv").insert({bottom: newRow});
					attachWc = "N";
					//perilNameChanged = false;
					resetQuoteItemPerilForm();
					setPerilNameLov();
					$("selPerilName").enable();
				}
			}
// setPerilNameLov();
			computeInvoiceTsiAmountsAndPremiumAmounts();
// resetQuoteItemPerilForm();
			if(wasEmpty==true){
				generateInvoice();
			}
			if($("addDeductibleForm")!=null){
				// check if deductibles info is loaded, reset its peril lov
				setQuoteDeductiblePerilLov();
			}
			clearChangeAttribute("perilInformationDiv");
		} catch (e){
			showErrorMessage("btnAddPeril", e);
		}
	});

	$("btnDeletePeril").observe("click", function(){
		var perilRow = getSelectedRow("perilRow");
		perilRow.childElements().each(function(elemenowpi){
			if(elemenowpi.id=="hidPerilCd"){
				var perilCd = elemenowpi.value;
				if(btnDeleteSubFunction_hasDependentPerils(perilCd) == false){  // check for dependents
					Effect.Fade(perilRow, {
						duration: .2,
						afterFinish: function(){
							var aPeril = null;
							resetQuoteItemPerilForm();
							aPeril = getPerilFromPerilList(perilCd,false);
							if(aPeril!=null){
								aPeril.recordStatus = -1;
							}
							setPerilNameLov();
							computeInvoiceTsiAmountsAndPremiumAmounts();
							perilRow.remove();
							clearChangeAttribute("perilInformationDiv");
							//perilNameChanged = false;
							$("selPerilName").enable();
							resetTableStyle("itemPerilTable","itemPerilMotherDiv","perilRow");
						}
					});
				}
			}
		});
		
		resetQuoteItemPerilForm();
		setPerilNameLov();
		
		if($("addDeductibleForm")!=null){
			// check if deductibles info is loaded, reset its peril lov
			setQuoteDeductiblePerilLov();
		}
	});
	
	computeInvoiceTsiAmountsAndPremiumAmounts();
	initializeAllMoneyFields();
	initializeChangeAttribute();
	initializeAll();
}catch(e){
	showErrorMessage("Error caught in perilInformationJSON.jsp", e);
}
</script>