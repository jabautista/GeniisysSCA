<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="coverageInformationInfo" class="sectionDiv" style="display: none; width:872px; background-color:white; ">
	<jsp:include page="/pages/underwriting/subPages/accidentCoverageListing.jsp"></jsp:include>
	<table align="center" border="0">
		<tr>
			<td class="rightAligned" >Peril Name</td>
			<td class="leftAligned" >
				<select  id="cPerilCd" name="cPerilCd" style="width: 223px" class="required">
					<option value="" wcSw="" perilType=""></option>
					<c:forEach var="perils" items="${perils}">
						<option value="${perils.perilCd}" wcSw="${perils.wcSw }" perilType="${perils.perilType }">${perils.perilName}</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width:105px;">Peril rate </td>
			<td class="leftAligned" >
				<input id="cPremRt" name="cPremRt" type="text" style="width: 215px;" value="" maxlength="13" class="required moneyRate"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >TSI Amt. </td>
			<td class="leftAligned" >
				<input id="cTsiAmt" name="cTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required money"/>
			</td>
			<td class="rightAligned" >Premium Amt. </td>
			<td class="leftAligned" >
				<input id="cPremAmt" name="cPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required money"/>
			</td>
		</tr>
		
		<tr>
			<td class="rightAligned" >Annual TSI Amt.</td>
			<td class="leftAligned" >
				<input id="acTsiAmt" name="acTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required money"/>
			</td>
			<td class="rightAligned" >Annual Premium</td>
			<td class="leftAligned" >
				<input id="acPremAmt" name="acPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required money"/>
			</td>
		</tr>
		
		<tr>
			<td class="rightAligned" >No. of Days </td>
			<td class="leftAligned" >
				<input id="cNoOfDays" name="cNoOfDays" type="text" style="width: 215px;" value="" maxlength="6" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered No. of Days is invalid. Valid value is from 0 to 999,999"/>
			</td>
			<td class="rightAligned" >Base Amount </td>
			<td class="leftAligned" >
				<input id="cBaseAmt" name="cBaseAmt" type="text" style="width: 215px;" value=""  maxlength="18" class="money"/>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="leftAligned" colspan="3" ><input type="checkbox" id="cAggregateSw" name="cAggregateSw" checked="checked"/><font class="rightAligned"> Aggregate</font></td>
		</tr>
		<tr>
			<td colspan="4">
				<input id="cAnnPremAmt" 	name="cAnnPremAmt" 		type="hidden" style="width: 215px;" value="" maxlength="14" class="money"/>
				<input id="cAnnTsiAmt"	 	name="cAnnTsiAmt" 		type="hidden" style="width: 215px;" value="" maxlength="18" class="money"/>
				<input id="cGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="cLineCd" 		name="cLineCd" 			type="hidden" style="width: 215px;" value="" />
				<input id="cRecFlag" 		name="cRecFlag"	 		type="hidden" style="width: 215px;" value="" />
				<input id="cRiCommRt" 		name="cRiCommRt" 		type="hidden" style="width: 215px;" value="" maxlength="13" class="moneyRate"/>
				<input id="cRiCommAmt" 		name="cRiCommAmt" 		type="hidden" style="width: 215px;" value="" maxlength="16" class="money"/>
				<input id="cWcSw" 			name="cWcSw"	 		type="hidden" style="width: 215px;" value="" />
				<input id="cPerilType" 		name="cPerilType"	 	type="hidden" style="width: 215px;" value="" />
			</td>
		</tr>	
	</table>
	<table align="center" style="margin-bottom: 10px">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnCopyBenefits" 	name="btnCopyBenefits" 		value="Copy Benefits" 		style="width: 95px;" />
				<input type="button" class="button" 		id="btnAddCoverage" 	name="btnAddCoverage" 		value="Add Peril" 		style="width: 85px;" />
				<input type="button" class="disabledButton" id="btnDeleteCoverage" 	name="btnDeleteCoverage" 	value="Delete Peril" 		style="width: 85px;" />
			</td>
		</tr>
	</table>
</div>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	var fromDateFromItem = "";
	var toDateFromItem = "";
	var packBenCdFromItem = "";
	var prorateFlagFromItem = "";
	var compSwFromItem = "";
	var shortRatePercentFromItem = "";

	$$("div#itemTable div[name='row']").each(function(a){
		if (a.hasClassName("selectedRow")){
			fromDateFromItem = a.down("input",14).value;
			toDateFromItem = a.down("input",15).value;
			packBenCdFromItem = a.down("input",27).value;
			prorateFlagFromItem = a.down("input",24).value;
			compSwFromItem = a.down("input",25).value;
			shortRatePercentFromItem = a.down("input",26).value;
		}	
	});

	$("cPerilCd").observe("change", function() {
		if ($("cPerilCd").options[$("cPerilCd").selectedIndex].getAttribute("wcSw") == "Y"){
			showConfirmBox("Message", "Peril has an attached warranties and clauses, would you like to use these as your default values on warranties and clauses?",  
					"Yes", "No", onOkFunc, onCancelFunc);
		} else{
			$("cWcSw").value = "";
		}	
		$("cPerilType").value = $("cPerilCd").options[$("cPerilCd").selectedIndex].getAttribute("perilType");
	});

	function onOkFunc(){
		$("cWcSw").value = "Y";
	}
	function onCancelFunc(){
		$("cWcSw").value = "";
	}

	$("cPremRt").observe("blur", function() {
		if ($F('cPremRt') == "") { 
			showMessageBox("Entered Peril Rate is invalid. Valid value is from 0.000000000 - 100.000000000.", imgMessage.ERROR);
			$("cPremRt").focus();
			$("cPremRt").value = "0.000000000";
		} else if (parseFloat($F('cPremRt').replace(/,/g, "")) >  100.000000000){
			showMessageBox("Entered Peril Rate is invalid. Valid value is from 0.000000000 - 100.000000000.", imgMessage.ERROR);
			$("cPremRt").focus();
			$("cPremRt").value = "0.000000000";
		} else{
			computeVals();
		}
	});

	var tsiAmtOrig = 0;
	$("cTsiAmt").observe("focus", function() {
		if ($F("cTsiAmt") != ""){
			tsiAmtOrig = $F("cTsiAmt");
		}
	});

	$("cTsiAmt").observe("blur", function(){
		if (parseFloat($F("cTsiAmt").replace(/,/g, "")) > 99999999999999.99){
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("cTsiAmt").focus();
			$("cTsiAmt").value = "";
		} else if (parseFloat($F("cTsiAmt").replace(/,/g, "")) != parseFloat(tsiAmtOrig) && tsiAmtOrig != ""){
			if ($F("cBaseAmt") != "" && $F("cNoOfDays") != ""){
				showConfirmBox("Message", "Changing TSI amount will delete base amount and set number of days to its default value, do you want to continue?",
						"Yes", "No", onOkFunc, onCancelFunc);
			} else {
				computeVals();
			}
		} else if (parseFloat($F("cTsiAmt").replace(/,/g, "")) < 0){
			showMessageBox("Valid TSI Amount is required.", imgMessage.ERROR);
			$("cTsiAmt").focus();
			$("cTsiAmt").value = "";
		} else if ($F('cTsiAmt') == 0) { 
			$("cTsiAmt").value = 0;
		} else{
			computeVals();
		}	

		function onOkFunc(){
			$("cBaseAmt").value = "";
			var starDate = (fromDateFromItem == "" ? $F("wpolbasInceptDate") :fromDateFromItem);
			var endDate = (toDateFromItem == "" ? $F("wpolbasExpiryDate") :toDateFromItem);
			var itemNoOfDays = computeNoOfDays(starDate,endDate,"");
			var grpbgNoOfDays = computeNoOfDays($("fromDate").value,$("toDate").value,"");
			$("cNoOfDays").value = (grpbgNoOfDays == "" ? itemNoOfDays : grpbgNoOfDays);
			computeVals();
		}

		function onCancelFunc(){
			computeVals();
		}

		var vMax = 0;
		var vMax2 = 0;

		$$("div[name='cov']").each(function (c){
			if (!c.hasClassName("selectedRow")){
				var perilType = "";
				var tsiAmt 	= 0;
				for (var i = 0; i < objGipiwCoverageItems; i++){
					if (c.id == objGipiwCoverageItems[i].perilCd){
						perilType = objGipiwCoverageItems[i].perilType;
						tsiAmt = objGipiwCoverageItems[i].tsiAmt.replace(/,/g, "");
					}
				}

				if (perilType == "B"){
					if (parseFloat(tsiAmt) > parseFloat(vMax)){
						vMax = parseFloat(tsiAmt);
					}
				} else if(perilType == "A"){
					if (parseFloat(tsiAmt) > parseFloat(vMax2)){
						vMax2 = parseFloat(tsiAmt);
					}
				}
			}
		});

		if (parseFloat(vMax) != parseFloat(0)){
			if ($F("cPerilType") == "A" && parseFloat($F("cTsiAmt").replace(/,/g, "")) > parseFloat(vMax)){
				showMessageBox("TSI amt of allied perils should be less than the maximum TSI amt of basic perils.", imgMessage.ERROR);
				$("cTsiAmt").focus();
				$("cTsiAmt").value = "";
				$("cPremAmt").value = "";
			} else if ($F("cPerilType") == "B" && parseFloat(vMax) < parseFloat(vMax2)){
				showMessageBox("TSI amt of allied perils should be less than the maximum TSI amt of basic perils.", imgMessage.ERROR);
				$("cTsiAmt").focus();
				$("cTsiAmt").value = "";
				$("cPremAmt").value = "";
			}		
		}
	});

	$("cPremAmt").observe("blur", function() {
		if (parseFloat($F('cPremAmt').replace(/,/g, "")) >  9999999999.99){
			showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("cPremAmt").focus();
			$("cPremAmt").value = "";
		} else if (parseFloat($F('cTsiAmt').replace(/,/g, "")) != parseFloat(tsiAmtOrig.replace(/,/g, "")) && tsiAmtOrig != "") {
			if ($F("cBaseAmt") != "" && $F("cNoOfDays") != ""){
				null;
			} else{		
				computeVals();
			}	
		} else if (parseFloat($F('cPremAmt').replace(/,/g, "")) < 0) {
			showMessageBox("Premium must not be less than zero.", imgMessage.ERROR);
			$("cPremAmt").focus();
			$("cPremAmt").value = "";
		} else if ($F('cPremAmt') == 0){
			$("cPremAmt").value = 0;
		}
		else{
			computeVals();
		}	
	});

	$("cBaseAmt").observe("blur", function() {
		if (parseFloat($F('cBaseAmt').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered Base Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("cBaseAmt").focus();
			$("cBaseAmt").value = "";
		} else if (parseFloat($F('cBaseAmt').replace(/,/g, "")) < 0) { 
			showMessageBox("Base Amount must not be less than zero.", imgMessage.ERROR);
			$("cBaseAmt").focus();
			$("cBaseAmt").value = "";
		} else{
			computeVals();
		}
	});

	$("cNoOfDays").observe("blur", function() {
		if ($F("cNoOfDays") == ""){
			$("cBaseAmt").value = 0;
			$("cNoOfDays").value = 0;
		} 

		computeVals();
	});

	function computeVals(){
		if (parseFloat($("cBaseAmt").value) >= 0.00 && parseInt($("cNoOfDays").value.replace(/,/g, "")) >= 0){
			$("cTsiAmt").value = formatCurrency(parseFloat($F("cBaseAmt").replace(/,/g, ""))*parseInt($F("cNoOfDays").replace(/,/g, "")));
		}	
		var year = serverDate.getFullYear();
		var noOfDays = getNoOfDaysInYear(year);
		var starDate = (fromDateFromItem == "" ? $F("wpolbasInceptDate") :fromDateFromItem);
		var endDate = (toDateFromItem == "" ? $F("wpolbasExpiryDate") :toDateFromItem);
		var itemNoOfDays = computeNoOfDays(starDate,endDate,"");
		var grpbgNoOfDays = computeNoOfDays($("fromDate").value,$("toDate").value,"");
		var prorateFlag = prorateFlagFromItem;

		if ($F("cTsiAmt") != ""){
			var premRt = (parseFloat($F("cPremRt") == "" ? "0.00" :$F("cPremRt").replace(/,/g, ""))/parseInt(100));
			var tsiAmt = parseFloat($F("cTsiAmt") == "" ? "0.00" :$F("cTsiAmt").replace(/,/g, ""));
			if (prorateFlag == "1"){
				var compSw = compSwFromItem;
				if (compSw == "M"){
					var days = ((parseInt(grpbgNoOfDays == "" ? itemNoOfDays : grpbgNoOfDays)-parseInt(1))/parseInt(noOfDays));
					$("cPremAmt").value = formatCurrency(premRt*tsiAmt*days);
				} else if (compSw == "Y"){
					var days = ((parseInt(grpbgNoOfDays == "" ? itemNoOfDays : grpbgNoOfDays)+parseInt(1))/parseInt(noOfDays));
					$("cPremAmt").value = formatCurrency(premRt*tsiAmt*days);
				} else{
					var days = (parseInt(grpbgNoOfDays == "" ? itemNoOfDays : grpbgNoOfDays)/parseInt(noOfDays));
					$("cPremAmt").value = formatCurrency(premRt*tsiAmt*days);
				}		
			} else if (prorateFlag == "2"){
				$("cPremAmt").value = formatCurrency(premRt*tsiAmt);
			} else if (prorateFlag == "3"){
				var shortRt = (parseFloat(shortRatePercentFromItem == "" ? "0.00" :shortRatePercentFromItem.replace(/,/g, ""))/parseInt(100));
				$("cPremAmt").value = formatCurrency(premRt*tsiAmt*shortRt);
			} else{
				$("cPremAmt").value = formatCurrency(premRt*tsiAmt);
			}
		}
		$("cAnnPremAmt").value = formatCurrency(premRt*tsiAmt);	
		$("cAnnTsiAmt").value = $F("cTsiAmt");	

		if ($F("cPerilCd") == ""){
			$("cPremAmt").value = "";
			$("cAnnPremAmt").value = "";
			$("cAnnTsiAmt").value = "";
			$("cNoOfDays").value = "";
			$("cBaseAmt").value = "";
		}
	}	

	function getSelectedId(tableRow){
		var id = "";
		
		$$("div[name='" + tableRow + "']").each(function (row){
			if (row.hasClassName("selectedRow")){
				id = row.id;
			}
		});

		return id;
	}

	function removeSelectedClass(groupedItemNo){
		$$("div[name='grpItem']").each(function (gi){
			if (gi.id == groupedItemNo){
				gi.removeClassName("selectedRow");
			}
		});
	}

	$("btnDeleteCoverage").observe("click", function(){
		deleteCoverageItem();
	});

	function deleteCoverageItem(){
		$$("div[name='cov']").each(function (covRow){
			if (covRow.id == $F("cPerilCd")){
				Effect.Fade(covRow, {
					duration : .5,
					afterFinish : function (){
						covRow.remove();
						addDeletedJSONObject(objGipiwCoverageItems, prepareDeletedCovObject(covRow.id));
						checkIfToResizeTable2("coverageListing", "cov");
						checkTableIfEmpty2("cov", "coverageTable");
						clearCoverageForm();
					}
				});
			}
		});
	}	

	function prepareDeletedCovObject(perilCd){
		var deleteObj = new Object();
		for (var i = 0; i < objGipiwCoverageItems.length; i++){
			if (objGipiwCoverageItems[i].perilCd == perilCd){
				deleteObj = objGipiwCoverageItems[i];
			}
		}
		return deleteObj;
	}

	function clearCoverageForm(){
		$("cPerilCd").selectedIndex = 0;
		$("cPremRt").value = "";
		$("cTsiAmt").value = "";
		$("cPremAmt").value = "";
		$("cNoOfDays").value = "";
		$("cBaseAmt").value = "";
		$("cAggregateSw").checked = false;
		$("cAnnPremAmt").value = "";
		$("cAnnTsiAmt").value = "";

		$("btnAddCoverage").value = "Add";
		disableButton("btnDeleteCoverage");
	}

	$("btnCopyBenefits").observe("click",function(){
		if (checkGroupedItemNoExist()){
			$("popBenDiv").down("label").update("Copy Benefits");
			$("popBenDiv").show();
			$("btnOkPopBen").hide();
			$("btnOkCopyBen").show();
			$("btnOkDeleteBen").hide();

			$$("div[name='popBens']").each(function (a){
				if (a.getAttribute("id") == "rowPopBens"+$F("itemNo")+""+getSelectedRowAttrValue("grpItem","groupedItemNo")){
					//a.down("input",4).value = "N";
					a.down("input",0).checked = false;
					a.hide();
				} else{
					//a.down("input",4).value = "Y";
					a.down("input",0).checked = true;
					a.show();
				}		
			});
			var ctr = 0;
			$$("div[name='grpItem']").each( function(a)	{
				ctr++;	
			});
			if (ctr<=5){
				$("accidentPopBenTable").setStyle("height: " + (ctr*31) +"px;"); 
			}
		} else{
			return false;
		}
	});	
	
</script>
		