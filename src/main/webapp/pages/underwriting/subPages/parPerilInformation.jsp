<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%

	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="outerDiv">
		<label id="">Peril Information</label> 
		<span class="refreshers" style="margin-top: 0;"> 
			<label id="showPeril" name="gro" style="margin-left: 5px;">Show</label> 
		</span>
	</div>
</div>

<div class="sectionDiv" id="perilInformationDiv"name="perilInformationDiv" changeTagAttr="true">
	<div id="hiddenDiv" name="hiddenDiv">
		<input type="hidden" id="deldiscItemNos" name="deldiscItemNos" value="" /> 
		<input type="hidden" id="delDiscSw" name="delDiscSw" value="N" /> 
		<input type="hidden" id="addItemNo" name="addItemNo" /> 
		<input type="hidden" id="addPerilCd" name="addPerilCd" /> 
		<input type="hidden" id="perilExist2" name="perilExist2" /> 
		<input type="hidden" id="discExists" name="discExists" value="${parDetails.discExists}" />
		<input type="hidden" id="perilItem" name="perilItem" /> 
		<input type="hidden" id="dumPerilCd" name="dumPerilCd" /> 
		<!--input type="hidden" id="perilTarfCd" name="perilTarfCd" /-->
		<input type="hidden" id="perilAnnTsiAmt" name="perilAnnTsiAmt" value="0.00" /> 
		<input type="hidden" id="perilAnnPremAmt" name="perilAnnPremAmt" value="0.00" /> 
		<input type="hidden" id="perilPrtFlag" name="perilPrtFlag" />
		<!--
			removed by emman, changed into text fields. display fields if Reinsurance (emman 05.17.2011)
		<input type="hidden" id="perilRiCommRate" name="perilRiCommRate" value="0" /> 
		<input type="hidden" id="perilRiCommAmt" name="perilRiCommAmt" value="0.00" />
			-->
		<input type="hidden" id="perilSurchargeSw" name="perilSurchargeSw" /> 
		<!-- input type="hidden" id="perilBaseAmt" 		name="perilBaseAmt" value="0.00"/-->
		<input type="hidden" id="perilAggregateSw" name="perilAggregateSw" /> 
		<input type="hidden" id="perilDiscountSw" name="perilDiscountSw" /> 
		<input type="hidden" id="varVPackageSw" name="varVPackageSw" value="N" /> 
		<input type="hidden" id="vOldPlan" name="vOldPlan" value="0" /> 
		<input type="hidden" id="copyPerilPageLoaded" name="copyPerilPageLoaded" value="N" /> 
		<input type="hidden" id="varPackPlanSw" name="varPackPlanSw" value="" /> 
		<input type="hidden" id="varPackPlanCd" name="varPackPlanCd" value="" /> 
		<input type="hidden" id="varPlanSw" name="varPlanSw" value="" /> 
		<input type="hidden" id="varPlanAmtCh" name="varPlanAmtCh" value="" /> 
		<input type="hidden" id="varPlanPerilCh" name="varPlanPerilCh" value="" /> 
		<input type="hidden" id="varPlanCreateCh" name="varPlanCreateCh" value="N" />
		<input type="hidden" id="varPlanSwUntag" name="varPlanSwUntag" value="N" />
		<input type="hidden" id="vOra2010Sw" name="vOra2010Sw" value="" /> 
		<input type="hidden" id="changedPlanChTag" name="changedPlanChTag" value="N" />
		<input type="hidden" id="varPerilTsiAmt" name="varPerilTsiAmt" value="" />
		<input type="hidden" id="ctplDfltTsiAmt" name="ctplDfltTsiAmt" value="${ctplDfltTsiAmt}" />
		<input type="hidden" id="ctplCd" name="ctplCd" value="${ctplCd}" />
	</div>

	<div id="perilTotalsDiv" style="margin-top: 10px;">
		<table align="center" style="width: 100%;">
			<tr>
				<td id="totalTsi" class="rightAligned" style="width: 25%;">Total TSI Amt.</td>
				<td id="totalTsiRi" class="rightAligned" style="width: 25%; display: none;">Total TSI Amt. Ceded</td>
				<td class="leftAligned" style="width: 25%;">
					<input tabindex="600" type="text" id="perilTotalTsiAmt" class="money" readonly="readonly" style="width: 80%;" />
				</td>
				<td id="totalPrem" class="rightAligned" style="width: 15%;">Total Premium Amt.</td>
				<td id="totalPremRi" class="rightAligned" style="width: 18%; display: none;">Total Premium Amt. Ceded</td>
				<td class="leftAligned" style="width: 35%;">
					<input tabindex="601" type="text" id="perilTotalPremAmt" class="money" readonly="readonly"	style="width: 60%;" />
				</td>
			</tr>
			<tr id="planRow" style="display: none;">
				<td class="rightAligned" style="width: 25%;">Plan</td>
				<td class="leftAligned" style="width: 25%;">
					<select id="perilPackageCd" name="perilPackageCd" style="width: 83%;">
						<option></option>
						<c:forEach var="plan" items="${plans}" varStatus="ctr">
							<option value="${plan.packBenCd}">${plan.packageCd}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 15%;"></td>
				<td class="leftAligned" style="width: 35%;"></td>
			</tr>
		</table>
	</div>

	<div id="perilInformation" style="margin: 5px;"><!-- peril listing table will be placed here -->
		<!--div id="parItemPerilTable" name="parItemPerilTable">
				<div id="itemPerilHeaderDiv" class="tableHeader" style="padding-right: 0px;">
					<label style="width: 5%; text-align: right; margin-right: 5px;">Item</label>
					<label style="width: 20%; text-align: left; margin-left: 5px;">Peril Name</label>
					<label style="width: 15%; text-align: right;">Rate</label>
			   		<label style="width: 15%; text-align: right; margin-left: 5px;">TSI Amount</label>
					<label style="width: 15%; text-align: right; margin-left: 5px;">Premium Amount</label>
					<label style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">Remarks</label>
					<label style="width: 3%; text-align: right;">A</label>
					<label style="width: 3%; text-align: right;">S</label>
					<label style="width: 3%; text-align: right;">D</label>
				</div>
				<div class="tableContainer" id="itemPerilMainDiv">
					<div id="hiddenDiv" name="hiddenDiv" style="display: none;">
						<select id="itemNos" name="itemNos">
							<c:forEach var="itemNum" items="${itemNos}">
								<option value="${itemNum}">${itemNum}</option>
							</c:forEach>
						</select>
						<input type="hidden" id="wItemPeril" name="wItemPeril" value="${wItemPeril}"/>
					</div>
				</div>
			</div-->
	</div>
	<div id="defaultPerilDiv" name="defaultPerilDiv"><!-- default perils listing placed here in instance of pressing CREATE PERILS -->
	</div>
	<div id="addItemPerilContainerDiv" changeTagAttr="true">
		<table align="center">
			<tr>
				<td class="rightAligned">Peril Name</td>
				<td class="leftAligned">
					<select tabindex="602" name="perilCd" id="perilCd" class="required" style="width: 214px;">
						<option value="" riCommRt="" perilType="" bascPerlCd="" wcSw=""></option>
						<c:forEach var="peril" items="${perilListing}">
							<option value="${peril.perilCd}" riCommRt="${peril.riCommRt}"
								perilType="${peril.perilType}" bascPerlCd="${peril.bascPerlCd}" defaultTsi = "${peril.defaultTsi}"
								defaultRate="${peril.defaultRate}" wcSw="${peril.wcSw}" tarfCd="${peril.tarfCd}" perilName="${peril.perilName}">${peril.perilName}</option>
						</c:forEach>
					</select> 
					<input type="text" id="txtPerilName" name="txtPerilName" style="display: none; width: 206px;" class="required" readonly="readonly" /> 
					<input type="hidden" id="txtPerilCd" name="txtPerilCd" /> 
					<input type="hidden" id="riCommRt" name="riCommRt" /> 
					<input type="hidden" id="perilType" name="perilType" /> 
					<input type="hidden" id="bascPerlCd" name="bascPerlCd" /> 
					<input type="hidden" id="wcSw" name="wcSw" />
				<!--input type="hidden" id="perilTarfCd" name="perilTarfCd"/--> 
					<input type="hidden" id="defaultRate" name="defaultRate" />
					<input type="hidden" id="defaultTsi" name="defaultTsi" /></td> 
					<td class="rightAligned">Peril Rate</td>
				<td class="leftAligned">
					<input tabindex="603" type="text" class="required"	value="" maxlength="13" style="width: 206px; text-align: right;" id="perilRate" name="perilRate" /><br />
				</td>
				<td rowspan="6" style="width: 20%;">
					<table cellpadding="1" border="0" align="center">
						<tr align="center">
							<td>
								<input tabindex="619" id="btnCreatePerils" class="disabledButton"	type="button" style="width: 100%;" value="Create Perils" name="btnCreatePerils" />
							</td>
						</tr>
						<tr align="center">
							<td>
								<input tabindex="620" id="btnDeleteDiscounts" class="disabledButton" type="button" style="width: 100%;" value="Delete Discounts" name="btnDeleteDiscounts" />
							</td>
						</tr>
						<tr align="center">
							<td>
								<input tabindex="621" id="btnCopyPeril" class="disabledButton"	type="button" style="width: 100%;" value="Copy Peril" name="btnCopyPeril" />
							</td>
						</tr>
						<tr align="center">
							<td style="width: 100%;">&nbsp;</td>
						</tr>
					</table>
			   </td>
			</tr>
			<tr>
				<td id="tsi" class="rightAligned">TSI Amt.</td>
				<td id="tsiRi" class="rightAligned" style="display: none;">TSI Amt. Ceded</td>
				<td class="leftAligned">
					<input tabindex="604" type="text" class="required money2" value="" maxlength="18" style="width: 206px; text-align: right;" id="perilTsiAmt" name="perilTsiAmt" /><br />
				</td>
				<td id="prem" class="rightAligned">Premium Amt.</td>
				<td id="premRi" class="rightAligned" style="display: none;">Premium Amt. Ceded</td>
				<td class="leftAligned">
					<input tabindex="605" type="text" class="required" value="" maxlength="17" style="width: 206px; text-align: right;" id="premiumAmt" name="premiumAmt" value="${premiumAmt}" /><br />
				</td>
			</tr>
			<tr id="remarks">
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="3">
					<input tabindex="606" type="text" style="width: 524px;" id="compRem" name="compRem" maxlength="50" /><br />
				</td>
			</tr>
			<tr id="trRi" style="display: none;">
				<td class="rightAligned">RI Comm Rt.</td>
				<td class="leftAligned">
					<input tabindex="607" type="text" class="required percentRate" value="" maxlength="18" style="width: 206px; text-align: right;" id="perilRiCommRate" name="perilRiCommRate" /><br />
				</td>
				<td class="rightAligned">RI Comm Amt.</td>
				<td class="leftAligned">
					<input tabindex="608" type="text" class="required" value="" maxlength="17" style="width: 206px; text-align: right;" id="perilRiCommAmt" name="perilRiCommAmt" value="" /><br />
				</td>
			</tr>
			<tr id="remarksRi" style="display: none;">
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="3">
					<input tabindex="609" type="text" style="width: 524px;" id="compRemRi" name="compRemRi" maxlength="50" /><br />
				</td>
			</tr>
			
			<tr id="accPerilDetailsDiv" style="display: none;">
				<td class="rightAligned">Base Amount</td>
				<td class="leftAligned">
					<input tabindex="610" type="text" class="" value="" maxlength="17" style="width: 206px; text-align: right;" id="perilBaseAmt" name="perilBaseAmt" /><br />
				</td>
				<td class="rightAligned">Number of Days</td>
				<td class="leftAligned">
					<input tabindex="611" type="text" class="" value="" maxlength="5" style="width: 206px; text-align: right;"	id="perilNoOfDays" name="perilNoOfDays" value="" /><br />
				</td>
			</tr>
			<tr id="firePerilDetailsDiv" style="display: none;">
				<td class="rightAligned">Tariff Code</td>
				<td class="leftAligned">
					<input tabindex="612" type="text" class="" value="" maxlength="30"	style="width: 206px; text-align: right; display: none;"	id="perilTarfCd" name="perilTarfCd" /> 
					<select id="selPerilTarfCd" name="selPerilTarfCd" style="width: 213px; text-align: left;">
						<option value="" perilCd=""></option>
						<c:forEach var="tariff" items="${perilTariffList}" varStatus="ctr">
							<option value="${tariff.tarfCd}" perilCd="${tariff.perilCd}">${tariff.tarfCd} - ${tariff.tarfDesc}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned"></td>
				<td class="leftAligned"></td>
			</tr>
			<tr>
				<td style="margin-right: 10px;"></td>
				<td colspan="6" style="margin-left: 10px; text-align: left;">
					<input tabindex="613" type="checkbox" id="chkAggregateSw" style="margin-left: 30px;" /> Aggregate &nbsp;&nbsp;&nbsp; 
					<input tabindex="614" type="checkbox" id="chkSurchargeSw" style="margin-left: 30px;" disabled="disabled" /> Surcharge &nbsp;&nbsp;&nbsp; 
					<input tabindex="615" type="checkbox" id="chkDiscountSw"  style="margin-left: 30px;" disabled="disabled" /> Discount &nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td>
				<input type="hidden" id="hidDiscountExists" name="hidDiscountExists"/>
				<input type="hidden" id="tarfSw" name="tarfSw" value="N" />
				<input type="hidden" name="lineMotor" id="lineMotor" /> 
				<input type="hidden" name="lineFire" id="lineFire" /> 
				<input type="hidden" name="tempPerilCd" id="tempPerilCd" /> 
				<input type="hidden" name="tempPerilRate" id="tempPerilRate" /> 
				<input type="hidden" name="tempTsiAmt" id="tempTsiAmt" /> 
				<input type="hidden" name="tempPremAmt" id="tempPremAmt" /> 
				<input type="hidden" name="tempCompRem" id="tempCompRem" /> 
				<input type="hidden" name="issCdRi" id="issCdRi" value="${issCdRi}" /> 
				<input type="hidden" name="paramName" id="paramName" value="${paramName}" />
				<input type="hidden" name="dedItemPerilExists" id="dedItemPerilExists">
				<input type="hidden" name="deductiblesDeleted" id="deductiblesDeleted" value="N" /> 
				<input type="hidden" name="fireDeleteDeductibles" id="fireDeleteDeductibles" value="N" /> 
				<input type="hidden" name="dedItemPeril" id="dedItemPeril" value="${dedItemPeril}" /> 
				<input type="hidden" name="deductibleLevel" id="deductibleLevel" value="" />
				<input type="hidden" name="deleteTag" id="deleteTag" value="N" /> 
				<input type="hidden" name="copyPerilTag" id="copyPerilTag" value="N" /> 
				<input type="hidden" name="destinationItem" id="destinationItem" value="" />
				<input type="hidden" name="validateDedCallingElement" id="validateDedCallingElement" fieldInWord="" value="" /></td>
			</tr>
			<tr>
				<td colspan="4" align="center" style="margin-left: 20px;">
				<input tabindex="616" id="btnAddItemPeril" class="button" type="button" value="Add" name="btnAddPeril" style="margin-left: 150px;" /> 
				<input tabindex="617" id="btnDeletePeril" class="disabledButton" type="button" value="Delete" name="btnDeletePeril" /> 
				<input tabindex="618" id="btnSaveItemPerils" name="btnSaveItemPerils" class="button" type="button" value="View JSON Perils" style="display: none;" /></td>
			</tr>
		</table>
	</div>
	<div id="itemPerilDeductiblesDiv" style="display: none;">
		<c:forEach items="${dedItemPeril}" var="ded" varStatus="ctr">
			<input name="itemPerilDed" type="hidden" itemNo="${ded.itemNo}" perilCd="${ded.perilCd}" />
		</c:forEach>
	</div>
	<div id="itemPerilDetailsDiv" style="display: none;">
		<input type="hidden" name="perilGroupExists" id="perilGroupExists" value="N" />
		<input type="hidden" name="basicSw" id="basicSw" />
	</div>
</div>

<script type="text/javaScript" defer="defer">
	var vAlert = 1;
    $("prorateFlag").value = objUWParList.prorateFlag;
	
	loadPerilListingTable(); 

	$("chkAggregateSw").readOnly = true;
	
	if (("AH" == objUWGlobal.menuLineCd || objLineCds.AC == objUWParList.lineCd)){ 
		$("accPerilDetailsDiv").show();
		$("planRow").show();
	}
	
	if ((objUWGlobal.lineCd == objLineCds.FI) || ("FI" == objUWGlobal.menuLineCd)){
		$("firePerilDetailsDiv").show();
	}
	
	if (objUWParList.issCd == "RI"){
		$("totalTsi").hide();
		$("totalPrem").hide();
		$("tsi").hide();
		$("prem").hide();
		$("remarks").hide();

		$("totalTsiRi").show();
		$("totalPremRi").show();
		$("premRi").show();
		$("tsiRi").show();
		$("remarksRi").show();
		$("trRi").show();
	}

	if (objUWParList.discExists == 'Y') {
		$("hidDiscountExists").value = "Y";
		enableButton("btnDeleteDiscounts");
	}else {
		disableButton("btnDeleteDiscounts");
	}
	
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	showPerilTarfOption(null);
	checkIfDefaultPerilExist();
		
	/******************INITIALIZING BUTTONS AND ELEMENTS**********************/
	
	$("perilRate").observe("focus", function() {
		if(($$("div#itemTable .selectedRow")).length < 1) {
			showMessageBox("Please select an item first.", imgMessage.INFO);					
			return false;			
		}
	});

	$("perilTsiAmt").observe("focus", function() {
		if(($$("div#itemTable .selectedRow")).length < 1) {
			showMessageBox("Please select an item first.", imgMessage.INFO);					
			return false;			
		}
	});

	$("premiumAmt").observe("focus", function() {
		if(($$("div#itemTable .selectedRow")).length < 1) {
			showMessageBox("Please select an item first.", imgMessage.INFO);					
			return false;			
		}
	});
	
	$("compRem").observe("focus", function() {
		if(($$("div#itemTable .selectedRow")).length < 1) {
			showMessageBox("Please select an item first.", imgMessage.INFO);					
			return false;			
		}
	});	
	
	$("chkAggregateSw").observe("focus", function() {
		if(($$("div#itemTable .selectedRow")).length < 1) {
			showMessageBox("Please select an item first.", imgMessage.INFO);					
			return false;			
		}
	});	

	$("perilCd").observe("focus", function(){
		if(($$("div#itemTable .selectedRow")).length < 1){
			showMessageBox("Please select an item first.", imgMessage.INFO);					
			return false;
		}
	});

	$("perilCd").observe("click", function(){
		if(($$("div#itemTable .selectedRow")).length < 1){
			$("perilCd").hide();
			showMessageBox("Please select an item first.", imgMessage.INFO);
			$("perilCd").show();					
			return false;
		}
	});
				
	$("perilCd").observe("change",function(){
		//belle 11.09.2011
		$("perilRate").value 		    = ""; 
		$("perilTsiAmt").value			= "";
		$("premiumAmt").value			= "";
		//
		if ("" != $("perilCd").value){ 
			$("validateDedCallingElement").value = "perilCd";
			$("validateDedCallingElement").setAttribute("fieldInWord", "perils");
			validateParDetailsBeforeEditing();
		} else {
			clearItemPerilFields();
		}
	});

	$("compRem").observe("change",
		function(){
			$("validateDedCallingElement").value = "compRem";
			$("validateDedCallingElement").setAttribute("fieldInWord", "perils");
			validateParDetailsBeforeEditing();
		}
	);

	$("selPerilTarfCd").observe("change", function(){
		$("perilTarfCd").value = $("selPerilTarfCd").value;
	});

	$("chkAggregateSw").observe("change", function(){
		
	});


	function validateParDetailsBeforeEditing(){
		try {
			if ("Y" == $F("perilGroupExists")){
				clearItemPerilFields();
				showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", "info");
			} else if ("Y" == objUWParList.discExists && "N" == objFormMiscVariables.miscDeletePerilDiscById){
				if ($F("deleteTag") == "Y"){
					showMessageBox("Deleting of peril is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.", "info");
				} else if ($("btnAddItemPeril").value != "Update"){
					clearItemPerilFields();
					showMessageBox("Adding of new "+$("validateDedCallingElement").getAttribute("fieldInWord")+" is not allowed because Policy have existing discount. If you want to make any changes please delete all discounts.", "info");
				} else if ("compRem" == $F("validateDedCallingElement")){
					clearItemPerilFields();
					showMessageBox("Adding of new "+$("validateDedCallingElement").getAttribute("fieldInWord")+" is not allowed because Policy have existing discount. If you want to make any changes please delete all discounts.", "info");
				} else { //if Update
					clearItemPerilFields();
					showMessageBox("Changes in "+$("validateDedCallingElement").getAttribute("fieldInWord")+"s is not allowed because Policy have existing discount. If you want to make any changes please delete all discounts.", "info");
				}
			} else {
				if (($F("validateDedCallingElement") == "perilBaseAmt")/* && ("0" == nvl($F("perilNoOfDays"), "0"))*/){
					validateBaseAmt();
				} else if (($F("validateDedCallingElement") == "perilNoOfDays")/* && (0 == parseFloat(nvl($F("perilBaseAmt"), 0)))*/){
					validateNoOfDays();
				} else {
					validateDeductible();
				}
			}
		} catch (e) {
			showErrorMessage("validateParDetailsBeforeEditing", e);
		}
	}

	function validateDeductible(){
		try {	
			var deductibleFired = false;
			if ("N" == $F("deductiblesDeleted")){
				/*$$("div[name='ded3']").each(function(ded){
					if (!deductibleFired){
						if ((ded.down("input", 2).value == $("perilCd").value) && (ded.down("input", 0).value == $("itemNo").value)){
							if ("T" == ded.down("input", 13).value){
								$("deductibleLevel").value = "peril";
								deductibleFired = true;
								callDeleteDeductiblesAlert();
								return false;
							}
						}
					}
				});*/
				//check for peril level deductibles
				if (!deductibleFired){
					for (var i=0; i<objDeductibles.length; i++){
						if ((objDeductibles[i].itemNo == $F("itemNo")) 
								&& (objDeductibles[i].perilCd == $("perilCd").value)
								&& (objDeductibles[i].deductibleType == "T")
								&& (objDeductibles[i].recordStatus != -1)){
							$("deductibleLevel").value = "peril";
							deductibleFired = true;
							callDeleteDeductiblesAlert();
							return false;
						}
					}
				}
				/*$$("div[name='ded2']").each(function(ded){
					if (!deductibleFired){
						if (ded.down("input", 0).value == $("itemNo").value){
							if ("T" == ded.down("input", 13).value){
								$("deductibleLevel").value = "item";
								deductibleFired = true;
								callDeleteDeductiblesAlert();
								return false;
							}
						}
					}
				});*/
				//check for item level deductibles
				if (!deductibleFired){ 
					for (var i=0; i<objDeductibles.length; i++){
						if ((objDeductibles[i].itemNo == $F("itemNo")) 
								&& (objDeductibles[i].deductibleType == "T")
								&& (objDeductibles[i].recordStatus != -1)){
							$("deductibleLevel").value = "item";
							deductibleFired = true;
							callDeleteDeductiblesAlert();
							return false;
						}
					}
				}
				/*$$("div[name='ded1']").each(function(ded){
					if (!deductibleFired){
						if ("T" == ded.down("input", 13).value){
							$("deductibleLevel").value = "PAR";
							deductibleFired = true;
							callDeleteDeductiblesAlert();
							return false;
						}
					}
				});*/
				//checks policy level deductibles
				if (!deductibleFired){ 
					for (var i=0; i<objDeductibles.length; i++){
						if ((objDeductibles[i].deductibleType == "T")
								&& (objDeductibles[i].recordStatus != -1)){
							$("deductibleLevel").value = "PAR";
							deductibleFired = true;
							callDeleteDeductiblesAlert();
							return false;
						}
					}
				}
			} 
			if (!deductibleFired){
				if ($F("deleteTag") == "Y"){
					deleteItemPeril();
				} else if ("perilCd" == $F("validateDedCallingElement")){
					getPerilDetails();
				} else if ("premiumAmt" == $F("validateDedCallingElement")){
					validateItemPerilPremAmt();
				} else if ("perilRate" == $F("validateDedCallingElement")){
					validateItemPerilRate();
				} else if ("perilTsiAmt" == $F("validateDedCallingElement")){
					validateItemPerilTsiAmt();
				} else if ("perilBaseAmt" == $F("validateDedCallingElement")){
					validateBaseAmt();
				} else if ("perilNoOfDays" == $F("validateDedCallingElement")){
					validateNoOfDays();
				}
			}
		} catch(e){
			showErrorMessage("validateDeductible", e);
		}
	}

	function callDeleteDeductiblesAlert(){
		try {
			if ($F("deleteTag") == "Y"){
				showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Deleting perils will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, clearItemPerilFields);
			} else if ($("btnAddItemPeril").value != "Update"){
				showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Adding "+$("validateDedCallingElement").getAttribute("fieldInWord")+" will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, clearItemPerilFields);
			} else {
				showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Changing "+$("validateDedCallingElement").getAttribute("fieldInWord")+" will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, clearItemPerilFields);
			}
		} catch(e){
			showErrorMessage("callDeleteDeductiblesAlert", e);
		}
	}	

	function getPerilDetails()	{
		try {
			var index				 = $("perilCd").selectedIndex;
			var itemNo				 = $F("itemNo");
			var riCommRt			 = $("perilCd").options[index].getAttribute("riCommRt");
			var perilType			 = $("perilCd").options[index].getAttribute("perilType");
			var bascPerlCd			 = $("perilCd").options[index].getAttribute("bascPerlCd");
			var basicPeril			 = "";
			var wcSw				 = $("perilCd").options[index].getAttribute("wcSw");
			var tarfCd				 = $("perilCd").options[index].getAttribute("tarfCd");
			var defaultRate	 		 = $("perilCd").options[index].getAttribute("defaultRate");
			var defaultTsi	         = $("perilCd").options[index].getAttribute("defaultTsi"); 
			var requiresBasicPeril	 = false;
			
									
			$("perilCd").childElements().each(function (o) {
				if (o.value == bascPerlCd){
					basicPeril = o.getAttribute("perilName");
				}
			});
			
			if (bascPerlCd != "") {
				requiresBasicPeril = true;
				/*$$("div[name='row2']").each(function(row){
					if (row.getAttribute("item") == itemNo){
						if (row.getAttribute("peril") == bascPerlCd){
							requiresBasicPeril = false;
						}	
					} 
				});*/
				
				for (var i = 0; i<objGIPIWItemPeril.length; i++){
					if ((itemNo == objGIPIWItemPeril[i].itemNo)
							&& (bascPerlCd == objGIPIWItemPeril[i].perilCd)
							&& (objGIPIWItemPeril[i].recordStatus != -1)){
						requiresBasicPeril = false;
					}
				}
			} 
			
			if (!requiresBasicPeril){
				$("riCommRt").value		= formatToNineDecimal(riCommRt);
				$("perilType").value	= perilType;
				$("bascPerlCd").value	= bascPerlCd;
				$("wcSw").value 		= wcSw;
				$("defaultRate").value	= defaultRate; //belle 11.09.2011
				$("defaultTsi").value 	= defaultTsi;
				
				var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")); 
				if (lineCd == objLineCds.FI || "FI" == lineCd){
					$("perilTarfCd").value = tarfCd;
				}
	
				if(objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == objLineCds.AC){
					showBaseAmt($("perilCd").value);
				}

				$("dumPerilCd").value	 = $("perilCd").value;
				showPerilTarfOption($("perilCd").value);
				validatePeril();
				showNoOfDays();
			} else {
				showMessageBox(basicPeril+" should exist before this peril can be added.", imgMessage.ERROR);
				$("perilCd").selectedIndex = 0;
			} 
		} catch(e){
			showErrorMessage("getPerilDetails", e);
		} 
	}
	
	function showBaseAmt(perilCd){
		if (("" != document.getElementById("accPerilDetailsDiv").style.display)){ 
			for (var x=0; x<objBeneficiaries.length; x++){
				if ((objBeneficiaries[x].perilCd == perilCd) && (objBeneficiaries[x].packBenCd == $F("packBenCd"))){
					$("perilBaseAmt").value = objBeneficiaries[x].benefit == null ? "" : formatCurrency(objBeneficiaries[x].benefit);
					return false;
				}
			}
		}
	}

	function validateItemPerilPremAmt(){
		var premAmt 		= parseFloat($F("premiumAmt").replace(/,/g, ""));
		var perilTsiAmt 	= parseFloat($F("perilTsiAmt").replace(/,/g, ""));
		var perilRate   = null;
		
		if ($F("premiumAmt") == ""){
			$("premiumAmt").focus();
			showMessageBox("Premium Amount is required.", imgMessage.ERROR);
		} else if(!(isNaN($F("premiumAmt")))){
			if (($F("premiumAmt")!="") && !(premAmt < 0.00) && !(premAmt > 99999999999999.99)){
				if (($F("perilTsiAmt")!="") && (!(perilTsiAmt < 0.00)) && (!(perilTsiAmt > 99999999999999.99))){
					if (!(premAmt > perilTsiAmt)){
						/* computeItmPerilRate();
					 	$("tempPremAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, ""));
						$("perilRiCommAmt").value = formatCurrency(premAmt * ($F("perilRiCommRate")/100)); */
						//belle 04.24.2012 replaced by codes below
						perilRate = computeItmPerilRate();
						if (perilRate > 100){
							$("perilRate").value = "";
							$("premiumAmt").value = objCurrItemPeril.premAmt;
							showMessageBox("Premium Rate (" +perilRate+ ") exceeds 100%, please check your Premium Computation Conditions at Basic Information Screen", imgMessage.ERROR);
						}else{
							$("perilRate").value = perilRate;
							$("tempPremAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, ""));
							$("perilRiCommAmt").value = formatCurrency(premAmt * ($F("perilRiCommRate")/100));
						}
						//end belle 04.24.2012
					}else {
						$("premiumAmt").focus();
						$("premiumAmt").value = "";
						showMessageBox("Premium Amount must not be greater than TSI amount.", imgMessage.ERROR);
					}
				}			
			} else {
				$("premiumAmt").focus();
				$("premiumAmt").value = "";
				showMessageBox("Entered Premium Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR);
			}
		} else {
			$("premiumAmt").focus();
			$("premiumAmt").value = "";
			showMessageBox("Entered Premium Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR);
		}
	}

	function validateItemPerilRate(){
		if ($F("perilRate") == ""){
			$("perilRate").focus();
			showMessageBox("Peril Rate is required.", "error");
		} else if (!(isNaN($F("perilRate")))){
			if (($F("perilRate") != "") 
					&& (!(parseFloat($F("perilRate")) > 100)) 
					&& (!(parseFloat($F("perilRate")) < 0))){
				if((objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN) && "Y" == $F("markUpTag")){
					$("perilRate").value = formatToNineDecimal($F("perilRate")); 
					$("perilTsiAmt").value = formatCurrency(($F("invCurrRt")*$F("invoiceValue").replace(/,/g, ""))+($F("invCurrRt")*$F("invoiceValue").replace(/,/g, "")*$F("markupRate")/100));
					$("premiumAmt").value = formatCurrency($("perilTsiAmt").value.replace(/,/g, "") * $F("perilRate")/100);
					$("perilRiCommAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, "") * $F("perilRiCommRate")/100);
				} else {
					$("tempPerilRate").value = $F("perilRate");
					$("perilRate").value = formatToNineDecimal($F("perilRate"));
					$("premiumAmt").value = computePerilPremAmount(objUWParList.prorateFlag, $F("perilTsiAmt"), $F("perilRate"));
					$("perilRiCommAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, "") * $F("perilRiCommRate")/100);
				}
			} else {
				$("perilRate").focus();
				$("perilRate").value = "";
				showMessageBox("Entered Peril Rate is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
			}
		} else {
			$("perilRate").focus();
			$("perilRate").value = "";
			showMessageBox("Entered Peril Rate is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
		}
	}

	function validateItemPerilTsiAmt(){
		try {
			var tsiAmt = ($F("perilTsiAmt")).replace(/,/g, "");
			if (tsiAmt == ""){
				$("perilTsiAmt").focus();
				showMessageBox("TSI Amount is required.", imgMessage.ERROR);
			} else if((isNaN(tsiAmt)) || (tsiAmt.split(".").size > 2)){
				/*$("perilTsiAmt").focus();
				$("perilTsiAmt").value = "";
				showMessageBox("Invalid TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);*/
				clearFocusElementOnError("perilTsiAmt", "Invalid TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.");
			} else if ((parseFloat(tsiAmt) < 0.01) || (parseFloat(tsiAmt) > 99999999999999.99)) {
				$("perilTsiAmt").focus();
				$("perilTsiAmt").value = "";
				showMessageBox("Invalid TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
			} else {
				if (validateTsiAmt()){
					getPostTextTsiAmtDetails();
				}
			}
		} catch (e){
			showErrorMessage("validateItemPerilTsiAmt", e);
		}
	}

	function validatePeril(){
		var index		= $("perilCd").selectedIndex;
		var premRt      = 0;
		var tsiAmt      = 0;
		var premAmt     = 0;
		var annTsiAmt   = 0;
		var annPremAmt  = 0;
		var riCommRt	= $F("riCommRt").replace(/,/g, "");
		var riCommAmt  	= 0;
		var issCd 		= (objUWGlobal.packParId != null ? objCurrPackPar.issCd : $F("globalIssCd"));
		var paramName	= $F("paramName"); 
		var issCdRi		= $F("issCdRi");
		var tarfRate 	= "";
		var inputPremAmt = $F("premiumAmt").replace(/,/g, "");
		var riCommAmt  	 = 0;
		//var defaultRate	 = $("perilCd").options[index].getAttribute("defaultRate"); //belle 11092011
		//var defaultTsi	 = $("perilCd").options[index].getAttribute("defaultTsi");
		var prorateFlag  = parseFloat($F("prorateFlag")); 
		var premAmt		 = computePerilPremAmount(prorateFlag, $("ctplDfltTsiAmt").value, $("perilRate").value);
		
		if ($("tarfCd") != null){
			tarfRate = $("tarfCd").options[$("tarfCd").selectedIndex].getAttribute("tariffRate");
		}
		
		if (objUWParList.issCd == "RI"){
			if (!("0" == riCommRt)){
				$("perilRiCommRate").value = riCommRt;
				$("perilRiCommAmt").value = formatCurrency((parseFloat(riCommRt == "" ? 0 : riCommRt)* parseFloat(inputPremAmt == "" ? 0 : inputPremAmt))/100);
			}
		} 
			if (((0 == parseFloat($F("perilTsiAmt"))) || ("" == $F("perilTsiAmt"))) 
					&& ((0 == parseFloat($F("premiumAmt"))) || ("" == $F("premiumAmt"))) 
					&& (!(issCd == issCdRi))&& ("" == $F("compRem"))){
				if ("" != tarfRate){
					$("perilRate").value = formatToNineDecimal(tarfRate);
				}
			}
			
		if (((0 == parseFloat($F("perilTsiAmt"))) || ("" == $F("perilTsiAmt"))) 
				&& ((0 == parseFloat($F("premiumAmt"))) || ("" == $F("premiumAmt")))
				&& ((0 == parseFloat($F("perilRate"))) || ("" == $F("perilRate")))
				&& (!(issCd == issCdRi)) && ("" == $F("compRem"))){ 
			if (!("" == $F("defaultRate"))){ 
				$("perilRate").value = formatToNineDecimal($("defaultRate").value); //belle 11.09.2011
			}
		}
		
		if (objUWParList.issCd != "RI"){
			//edited by d.alcantara, to retrieve MC line when in package
			if (/*objUWGlobal.lineCd*/$F("globalLineCd") == objLineCds.MC && $("perilCd").value == $("ctplCd").value 
					&& ("" == $("perilTsiAmt").value || 0 == $("perilTsiAmt").value)) {
				$("perilTsiAmt").value = formatCurrency($("ctplDfltTsiAmt").value);
				$("premiumAmt").value  = formatCurrency((premAmt == "0.00")? "" : premAmt);
			}
		}
	}

	$("perilBaseAmt").observe("change", function(){
		$("validateDedCallingElement").value = "perilBaseAmt";
		$("validateDedCallingElement").setAttribute("fieldInWord", "peril");
		validateParDetailsBeforeEditing();
	});

	function validateBaseAmt(){
		try {
			var baseAmt = nvl($F("perilBaseAmt").replace(/,/g , ""), 0);
			var noOfDays = nvl($F("perilNoOfDays"), 0);
			if ("none" != document.getElementById("accPerilDetailsDiv").style.display){
				if ("" != baseAmt){
					if ((isNaN(baseAmt)) || ((baseAmt.split(".")).size > 2)){
						$("perilBaseAmt").focus();
						$("perilBaseAmt").value = "";
						showMessageBox("Entered Base Amount is invalid. Valid value is from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR);
					} else if ((parseFloat(baseAmt) > 99999999999999.99) || (parseFloat(baseAmt) < 0)){
						$("perilBaseAmt").focus();
						$("perilBaseAmt").value = "";
						showMessageBox("Entered Base Amount is invalid. Valid value is from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR);
					} else {
						if (($F("perilNoOfDays") == "") || ($F("perilNoOfDays") == "0")){
							$("perilBaseAmt").value = formatCurrency(parseFloat(baseAmt));
						} else {
							$("perilTsiAmt").value = noOfDays * baseAmt;
							getPostTextTsiAmtDetails();
							//$("perilBaseAmt").value = formatCurrency($F("perilBaseAmt").replace(/,/g , ""));
							$("perilBaseAmt").value = formatCurrency(parseFloat(baseAmt));
						}
					}
				} else {
					$("perilTsiAmt").value = "0.00";
				}
			}
		} catch(e){
			showErrorMessage("validateBaseAmt", e);
		}
	}

	$("perilNoOfDays").observe("change", function(){
		$("validateDedCallingElement").value = "perilNoOfDays";
		$("validateDedCallingElement").setAttribute("fieldInWord", "peril");
		validateParDetailsBeforeEditing();
	});

	function validateNoOfDays(){
		try {
			var noOfDays = nvl($F("perilNoOfDays").replace(/,/g , ""), 0);
			var baseAmt = nvl($F("perilBaseAmt").replace(/,/g , ""), 0);
			if ("none" != document.getElementById("accPerilDetailsDiv").style.display){
				if(noOfDays == 0) {
					$("perilTsiAmt").value = "0.00";
				} else {
					if ("Y" == $F("perilGroupExists")){
						clearItemPerilFields();
						showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", "info");
					} else if (isNaN(noOfDays) || (noOfDays.include("."))){//handling non-numerical or decimal values
						$("perilNoOfDays").focus();
						$("perilNoOfDays").value = "";
						showMessageBox("Entered No. of Days is invalid. Valid value is from 0 to 99,999.", imgMessage.ERROR);
					} else if ((parseFloat(noOfDays) < 0) || (parseFloat(noOfDays) > 99999)){
						$("perilNoOfDays").focus();
						$("perilNoOfDays").value = "";
						showMessageBox("Entered No. of Days is invalid. Valid value is from 0 to 99,999.", imgMessage.ERROR);
					} else {
						if ((noOfDays != 0) && (baseAmt != 0)){
							$("perilTsiAmt").value = noOfDays * baseAmt;
							getPostTextTsiAmtDetails();
						}
						$("perilNoOfDays").value = parseFloat(noOfDays);
					} 
				}
			}
		}catch (e){
			showErrorMessage("validateNoOfDays",e);
		}
	}

	$("btnDeletePeril").observe("click", function ()	{
		try {
			$("deleteTag").value = "Y";
			$("validateDedCallingElement").value = "delete"; 
			$("validateDedCallingElement").setAttribute("fieldInWord", "delete");
			validateParDetailsBeforeEditing(); 
			clearChangeAttribute("addItemPerilContainerDiv");
			//togglePKFieldView("perilCd", "txtPerilName", "", false);		
		} catch (e) {
			showErrorMessage("parPerilInformation.jsp - btnDeletePeril", e);
			//showMessageBox (e.message);
		}	
	});

	var newPerilObj = null;
	
	$("btnAddItemPeril").observe("click", function(){
		try {
			if (!checkItemExists2($F("itemNo"))){
				showMessageBox("Please select an item first.", imgMessage.INFO);
				return false;
			}
			if (validateBeforeSave()){
				var itemNoOfPeril = $F("itemNo");
				var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
				var perilCd = $("perilCd").value;
				var perilName = $F("btnAddItemPeril") == "Update" ? $F("txtPerilName"):$("perilCd").options[$("perilCd").selectedIndex].getAttribute("perilName");
				var perilRate = formatToNineDecimal($F("perilRate"));
				var tsiAmt = $F("perilTsiAmt").replace(/,/g , "");
				var premAmt = $F("premiumAmt").replace(/,/g , "");
				if (!(validateTotalPARPremAmt(premAmt))){
					$("premiumAmt").value = "";
					$("premiumAmt").focus();
					showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Allowed for this PAR. Total Premium Amount value must range from 0.00 to 999,999,999,999.99.", imgMessage.ERROR);
					return false;
				}
				if (!(validateTotalPARTsiAmt(tsiAmt))){
					$("perilTsiAmt").value = "";
					$("perilTsiAmt").focus();
					showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Allowed for this PAR. Total TSI Amount value must range from 0.00 to 9,999,999,999,999,999.99.", imgMessage.ERROR);
					return false;
				}
				newPerilObj = createObjFromCurrPeril();
				if ($F("btnAddItemPeril") == "Update")	{
					newPerilObj.recordStatus = 1;
					updateObjPeril(objGIPIWItemPeril, newPerilObj);
				    addObjToPerilTable(newPerilObj);
					clearChangeAttribute("addItemPerilContainerDiv");
					//$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);
				} else { //if button is add peril
					perilName = ($("perilCd").options[$("perilCd").selectedIndex].getAttribute("perilName"));
					if ("Y" == objUWParList.discExists && "N" == objFormMiscVariables.miscDeletePerilDiscById){ 
						showMessageBox("Adding of new peril is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.", "error");
						return false;
					} else {
						$("addItemNo").value = itemNoOfPeril;
						$("addPerilCd").value = perilCd;
						newPerilObj.recordStatus = 0;
						addObjToPerilTable(newPerilObj);
						addNewPerilObject(newPerilObj);
						
						//check perilClauses listing for insertion
						for (var i=0; i<objGIISPerilClauses.length; i++){
							if (objGIISPerilClauses[i].perilCd == newPerilObj.perilCd){
								var wcExists = false;
								
								//checks if WC is already in GIPIWPolWC
								for (var j=0; j<objGIPIWPolWC.length; j++){
									if ((objGIPIWPolWC[j].wcCd == objGIISPerilClauses[i].mainWcCd)
											&& (objGIPIWPolWC[j].recordStatus != -1)) {
										wcExists = true;
									}
								}
								if (!wcExists){
									showConfirmBox("Warranty & Clauses", "Peril has an attached warranties and clauses, would you like"+
										" to use these as your default values on warranties and clauses?", "Yes", "No", 
										addClauseToWPolWC, ""
									);
									//$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);
									clearChangeAttribute("addItemPerilContainerDiv");									
									return false;
								}
							}
						}
						newPerilObj = null;
						clearChangeAttribute("addItemPerilContainerDiv");
					}
				}
				clearChangeAttribute("addItemPerilContainerDiv");
				//$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNoOfPeril);		
			}
		} catch(e){
			showErrorMessage("parPerilInformation.jsp - btnAddItemPeril", e);
		}
	});

	function addClauseToWPolWC(){
		for (var i=0; i<objGIISPerilClauses.length; i++){
			if (objGIISPerilClauses[i].perilCd == newPerilObj.perilCd){
				var wcExists = false;
				//checks if WC is already in GIPIWPolWC
				for (var j=0; j<objGIPIWPolWC.length; j++){
					if (objGIPIWPolWC[j].wcCd == objGIISPerilClauses[i].mainWcCd){
						wcExists = true;
					}
				}
				if (!wcExists){
					//fetch records from giis_warrcla then add to objWPolicyWC
					var newWCObj 			= new Object();
					
					newWCObj.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
					newWCObj.lineCd 		= nvl(objGIISPerilClauses[i].lineCd, (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")));
					newWCObj.wcCd 			= objGIISPerilClauses[i].mainWcCd;
					newWCObj.swcSeqNo 		= 0;
					newWCObj.printSeqNo 	= 1;
					newWCObj.wcTitle 		= nvl(objGIISPerilClauses[i].wcTitle, null);
					newWCObj.recFlag 		= "A";
					newWCObj.printSw 		= nvl(objGIISPerilClauses[i].printSw, null);
					newWCObj.changeTag 		= "N";
					newWCObj.lastUpdate 	= null;
					newWCObj.wcSw 			= null;
					newWCObj.wcTitle2 		= null;
					newWCObj.userId 		= null;
					newWCObj.wcText 		= null;
					newWCObj.wcRemarks 		= null;
					newWCObj.recordStatus 	= 0;
					addNewJSONObject(objGIPIWPolWC, newWCObj);
				}
			}
		}
		newPerilObj = null;
	}

	function validateTotalPARPremAmt(newPremAmt){
		var totalPARPremium = 0.00;
		var newPremValid = true;
		for (var i=0; i<objGIPIWItemPeril.length; i++){
			if (objGIPIWItemPeril[i].recordStatus != -1){
				var perilPremAmt = parseFloat(objGIPIWItemPeril[i].premAmt);
				var itemCurrRt = parseFloat(getObjAttrValueForItem($F("itemNo"), "currencyRate"));
				totalPARPremium = totalPARPremium + (itemCurrRt * perilPremAmt);
			}
		}
		totalPARPremium = totalPARPremium + parseFloat(newPremAmt);
		if (totalPARPremium > 9999999999.99){
			newPremValid = false;
		}
		return newPremValid;
	}

	function validateTotalPARTsiAmt(newTsiAmt){
		var totalPARTsi = 0.00;
		var newTsiValid = true;
		for (var i=0; i<objGIPIWItemPeril.length; i++){
			if (objGIPIWItemPeril[i].recordStatus != -1){
				var perilTsiAmt = parseFloat(objGIPIWItemPeril[i].tsiAmt);
				var itemCurrRt = parseFloat(getObjAttrValueForItem($F("itemNo"), "currencyRate"));
				totalPARTsi = totalPARTsi + (itemCurrRt * perilTsiAmt);
			}
		}
		totalPARTsi = totalPARTsi + parseFloat(newTsiAmt);
		if (totalPARTsi > 99999999999999.99){
			newTsiValid = false;
		}
		return newTsiValid;
	}

	$("btnCreatePerils").observe("click", function() {
		if ("Y" == $F("perilGroupExists")){
			clearItemPerilFields();
			showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", imgMessage.INFO);
			return false;
		}else {
			showConfirmBox("Create Perils", "Existing perils for this policy will be deleted and"+
					" will be replaced by default perils for this policy. "+
					"Do you want to continue?", "Yes", "No", function(){
						$("btnAddItemPeril").value = "Add";
						deleteDiscounts();
						getDefaultPerils();						
					}, "");
		}
	});
	
	$("btnDeleteDiscounts").observe("click", function() {
		showConfirmBox("Delete Discounts", "Are you sure you want to delete all discounts for this policy?",
				 "Yes", "No", deleteDiscounts, "");
	});	

	function getDefaultPerils(){
		try {
			new Ajax.Request(contextPath+"/GIISPerilController?action=getDefaultPerils",{ //+Form.serialize("parInformationForm"),{  
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				parameters: {
					parLineCd: (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd")),
					nbtSublineCd: (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")),
					packLineCd: $F("packLineCd"), 
					packSublineCd: $F("packSublineCd")
				},
				//onCreate: showNotice("Getting default peril values..."),
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							var objDPerils = JSON.parse(response.responseText);
							deleteAllItemPerils();
							for (var j=0; j<objGIPIWItem.length; j++){
								if(objGIPIWItem[j].recordStatus != -1){
									for (var i=0; i<objDPerils.length; i++){
										var perilCd 		= objDPerils[i].perilCd;
										var perilName 		= escapeHTML2(objDPerils[i].perilName); 
										var perilRate 		= objDPerils[i].defaultRate == null ? "0" : objDPerils[i].defaultRate;
										var tsiAmt 			= objDPerils[i].defaultTsi == null ? "0" : objDPerils[i].defaultTsi;
										var premAmt 		= null; 
										var prorateFlag 	= $F("prorateFlag");
										var perilType		= objDPerils[i].perilType;
										var riCommRate		= objDPerils[i].riCommRt == null ? "0" : objDPerils[i].riCommRt;
										
										premAmt = computePerilPremAmount(prorateFlag, objDPerils[i].defaultTsi, objDPerils[i].defaultRate);
										
										var objPeril 			= new Object();
										objPeril.parId 			= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
										objPeril.itemNo 		= objGIPIWItem[j].itemNo;
										objPeril.lineCd 		= (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
										objPeril.perilCd 		= perilCd;
										objPeril.perilName 		= perilName;
										objPeril.perilType 		= perilType;
										objPeril.tarfCd 		= null;
										objPeril.premRt 		= perilRate;
										objPeril.tsiAmt 		= tsiAmt;
										objPeril.premAmt 		= premAmt;
										objPeril.annTsiAmt 		= tsiAmt;
										objPeril.annPremAmt 	= computePerilAnnPremAmount(tsiAmt, perilRate);
										objPeril.recFlag 		= null;
										objPeril.compRem 		= null;
										objPeril.discountSw 	= "N";
										objPeril.prtFlag 		=  1;
										objPeril.riCommRate	    = riCommRate; 
										objPeril.riCommAmt 		= premAmt * (riCommRate/100);
										objPeril.asChargeSw 	= null;
										objPeril.surchargeSw 	= null;
										objPeril.noOfDays 		= null;
										objPeril.baseAmt 		= null;
										objPeril.aggregateSw 	= null;
										objPeril.bascPerlCd 	= null;
		
										addObjToPerilTable(objPeril);
										addNewPerilObject(objPeril);
										objPeril = null; 
										clearChangeAttribute("addItemPerilContainerDiv");
									}
								}
							}
						}
					}
				});
		} catch (e) {
			showErrorMessage("getDefaultPerils", e);
		}
	}

	$("btnCopyPeril").observe("click", function() {
		var fireDeductibleAlert = false;
		if (!checkItemExists2($F("itemNo"))){
			showMessageBox("Please select an item first.", imgMessage.INFO);
			return false;
		}

		if ("Y" == $F("perilGroupExists")){
			clearItemPerilFields();
			showMessageBox("Copying of grouped item perils is not allowed.", imgMessage.INFO);
			return false;
		}

		for (var i=0; i<objDeductibles.length; i++){
			if ((objDeductibles[i].deductibleType == "T") 
					&& (objDeductibles[i].recordStatus != -1)){
				fireDeductibleAlert = true;
				return false;
			}
		}
		if (!fireDeductibleAlert){
			showCopyPerilOverlay();
		} else {
			$("copyPerilTag").value = "Y";
			showConfirmBox("Delete Deductibles", "The PAR has an existing policy level deductible based on % of TSI.  Adding a peril will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, clearItemPerilFields);
		}
	});

	function showCopyPerilOverlay(){
		if (countPerilsForItem($F("itemNo")) > 0) {
			if ("Y" == $F("copyPerilPageLoaded")){
				$("itemToCopyPeril").update("");
				var selectContent = "<option value=''></option>";
				/*$$("div#parItemTableContainer div[name='rowItem']").each(function(item){
					var itemNo = item.down("input", 1).value;
					if (itemNo != $F("itemNo")){
						selectContent = selectContent + "<option value='"+itemNo+"'>"+itemNo+"</option>";
					}
				});*/
				
				/*for (var i=0; i<objGIPIWItem.length; i++){
					if (objGIPIWItem[i].recordStatus != -1){
						var itemNo = objGIPIWItem[i].itemNo;
						if (itemNo != $F("itemNo")){
							selectContent = selectContent + "<option value='"+itemNo+"'>"+itemNo+"</option>";
						}
					}
				}
				$("itemToCopyPeril").update(selectContent);*/ 
			} 
			//showOverlayContent(contextPath+"/GIPIWItemController?action=showCopyPerilItems&itemNo="+$F("itemNo"), "Copy Peril/s to Item No. ?", "", 450, 100, 450);
			showOverlayContent2(contextPath+"/GIPIWItemController?action=showCopyPerilItems&itemNo="+$F("itemNo"), "Copy Peril/s to Item No. ?", 300, "");
		} else {
			showMessageBox("Item has no existing peril(s) to copy.", imgMessage.INFO);
			return false;
		}
	}

	function validateBeforeSave(){
		var result = false;//true;

		if ("Y" == objUWParList.discExists  && "N" == objFormMiscVariables.miscDeletePerilDiscById){
			//result = false;
			if ("Add" == $("btnAddItemPeril").value){
				showMessageBox("Adding peril is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.", "info");
			} else {// if update 
				showMessageBox("Changing perils is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.", "info");
			}
		} else if (($F("txtPerilName")=="") && (0 == $("perilCd").selectedIndex)){
			//result = false;
			$("perilCd").focus();
			showMessageBox("Peril Name is required.", imgMessage.ERROR);
		} else if ($F("perilRate")==""){
			//result = false;
			$("perilRate").focus();
			showMessageBox("Peril Rate is required.", imgMessage.ERROR);
		} else if (($F("perilTsiAmt")=="") || (0 == parseFloat($F("perilTsiAmt")))){
			//result = false;
			$("perilTsiAmt").focus();
			showMessageBox("TSI Amount is required.", imgMessage.ERROR);
		} else if ($F("premiumAmt")==""){
			//result = false;
			$("premiumAmt").focus();
			showMessageBox("Premium Amount is required.", imgMessage.ERROR);
		} else if (validateTsiAmt2()){
			result = true;
		}
		return result;
	}

	$("perilRate").observe("change", function () {
		$("validateDedCallingElement").value = "perilRate";
		$("validateDedCallingElement").setAttribute("fieldInWord", "Peril Rate");
		validateParDetailsBeforeEditing();
	});

	$("premiumAmt").observe("change", function () {
		$("validateDedCallingElement").value = "premiumAmt";
		$("validateDedCallingElement").setAttribute("fieldInWord", "Premium Amt");
		validateParDetailsBeforeEditing();
	});

	$("perilTsiAmt").observe("change", function () {
		$("validateDedCallingElement").value = "perilTsiAmt";
		$("validateDedCallingElement").setAttribute("fieldInWord", "TSI Amt");
		validateParDetailsBeforeEditing();
		if(("AH" == objUWGlobal.menuLineCd || objLineCds.AC == objUWParList.lineCd)) { 
			$("perilNoOfDays").value = "0";
		}
	});
	
	$("perilRate").observe("keypress", function(event){		
		if(event.keyCode == 9){
			//$("perilCd").focus();
		}
	});	

	// ri_comm_rate v
	$("perilRiCommRate").observe("change", function() {
		if (isNaN(nvl($F("perilRiCommRate").replace(/,/g,""),"0"))) {
			showWaitingMessageBox("Invalid input.", imgMessage.ERROR,
					function() {
						$("perilRiCommRate").focus();
					});
		} else {
			var vRiCommRate = parseFloat(nvl($F("perilRiCommRate").replace(/,/g,""),"0"));
			if (vRiCommRate < 0 || vRiCommRate > 100) {
				showWaitingMessageBox("RI Comm Rate must be in range 0.000000000 to 100.000000000.", imgMessage.ERROR,
						function() {
							$("perilRiCommRate").focus();
						});
			} else {
				$("perilRiCommAmt").value = formatCurrency(vRiCommRate * parseFloat(nvl($F("premiumAmt").replace(/,/g,""),"0")) / 100);
			}
			$("perilRiCommRate").value = formatToNineDecimal(vRiCommRate);
		}
	});

	// ri_comm_rate v
	$("perilRiCommAmt").observe("change", function() {
		if (isNaN(nvl($F("perilRiCommAmt").replace(/,/g,""),"0"))) {
			showWaitingMessageBox("Invalid input.", imgMessage.ERROR,
					function() {
						$("perilRiCommAmt").focus();
					});
		} else {
			var vRiCommAmt = parseFloat(nvl($F("perilRiCommAmt").replace(/,/g,""),"0"));
			if (vRiCommAmt < 0 || vRiCommAmt > 999999999999.99) {
				showWaitingMessageBox("RI Comm Amt must be of form 99,999,999,999,990.99", imgMessage.ERROR,
						function() {
							$("perilRiCommAmt").focus();
						});
			} else {
				$("perilRiCommRate").value = formatToNineDecimal(vRiCommAmt / parseFloat(nvl($F("premiumAmt").replace(/,/g,""),"0")) * 100);
				$("riCommRt").value = $F("perilRiCommRate");
			}
			$("perilRiCommAmt").value = formatCurrency(vRiCommAmt);
		}
	});

	$("showPeril").observe("click", function(){
		if (($$("div#itemTable .selectedRow")).length < 1){
			$("itemPerilMainDiv").hide();
			if (0 == $("perilCd").selectedIndex){
				$("premiumAmt").value = "";
				$("perilTsiAmt").value = "";
				$("perilRate").value = "";
			}
		}
	});
</script>

