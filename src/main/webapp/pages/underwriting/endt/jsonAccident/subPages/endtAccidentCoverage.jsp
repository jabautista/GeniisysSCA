<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="coverageInfoDiv" class="sectionDiv" style="width:872px; background-color:white; display: none;">
	<table align="center" style="width: 865px; border-bottom: 1px solid #D8D8D8">
		<tr>
			<td class="rightAligned">Total TSI Amount</td>
			<td class="leftAligned">
				<input tabindex="11001" type="text" name="cTotalTsiAmt" id="cTotalTsiAmt" style="width: 215px;" class="money2" readonly="readonly" />
			<td>
			<td class="rightAligned">Total Premium Amount</td>
			<td class="leftAligned">
				<input tabindex="11002" type="text" name="cTotalPremAmt" id="cTotalPremAmt" style="width: 215px;" class="money2" readonly="readonly" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Annual TSI Amount</td>
			<td class="leftAligned">
				<input tabindex="11001" type="text" name="cTotalAnnTsiAmt" id="cTotalAnnTsiAmt" style="width: 215px;" class="money2" readonly="readonly" />
			<td>
			<td class="rightAligned">Annual Premium Amount</td>
			<td class="leftAligned">
				<input tabindex="11002" type="text" name="cTotalAnnPremAmt" id="cTotalAnnPremAmt" style="width: 215px;" class="money2" readonly="readonly" />
			</td>
		</tr>
	</table>
	
	<div style="margin: 10px;" id="coverageTable" name="coverageTable">
		<div class="tableHeader" style="margin-top: 5px;">
			<label style="text-align: left; width: 180px; margin-right: 6px; margin-left: 5px;">Enrollee Name</label>
			<label style="text-align: left; width: 180px; margin-right: 6px;">Peril Name</label>
			<label style="text-align: right; width: 100px; margin-right: 5px;">Rate</label>
			<label style="text-align: right; width: 150px; margin-right: 5px;">TSI Amount</label>
			<label style="text-align: right; width: 150px; margin-right: 5px;">Prem Amount</label>				
			<label style="text-align: center; width: 20px; margin-left: 10px;">A</label>
		</div>
		<div id="coverageListing" name="coverageListing" class="tableContainer" style="display: block;"></div>
	</div>
	
	<table align="center" border="0">
		<tr>
			<td class="rightAligned" >Peril Name </td>
			<td class="leftAligned" >
				<div style="float: left; border: solid 1px gray; width: 220px; height: 21px; margin-right: 3px;" class="required">
					<input type="hidden" id="cBascPerlCd" />
					<input type="hidden" id="cBasicPerilName" />
					<input type="hidden" id="cPerilCd" name="cPerilCd"/>
					<input type="hidden" id="annTsiCopy" name="annTsiCopy" value="0" />
					<input type="hidden" id="annPremCopy" name="annPremCopy" value="0" />
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 192px; border: none;" name="cPerilName" id="cPerilName" readonly="readonly" class="required" />
					<img id="hrefCPeril" alt="goCPeril" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div>
				<%-- <input type="text" id="cPerilName" name="cPerilName" value="" class="required" style="display: none; width: 215px;" />
				<select  id="cPerilCd" name="cPerilCd" style="width: 223px" class="required">
					<option value="" wcSw="" perilType=""></option>
					<c:forEach var="perils" items="${perils}">
						<option value="${perils.perilCd}" wcSw="${perils.wcSw}" perilType="${perils.perilType}">${perils.perilName}</option>
					</c:forEach>
				</select> --%>
			</td>
			<td class="rightAligned" style="width:105px;">Peril Rate </td>
			<td class="leftAligned" >
				<input id="cPremRt" name="cPremRt" type="text" style="width: 215px;" value="" maxlength="13" class="required applyDecimalRegExp" regExpPatt="pDeci0309" max="100.000000000" min="0.000000000" hasOwnBlur="N" hasOwnChange="Y" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >TSI Amt. </td>
			<td class="leftAligned" >
				<input id="cTsiAmt" name="cTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required money"/>
			</td>
			<td class="rightAligned" >Premium Amt. </td>
			<td class="leftAligned" >
				<input id="cPremAmt" name="cPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required applyDecimalRegExp" regExpPatt="nDeci1002" max="9999999999.99" min="-9999999999.99" hasOwnBlur="N" hasOwnChange="Y"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Ann TSI Amt. </td>
			<td class="leftAligned" >
				<input id="cAnnTsiAmt" name="cAnnTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required money" readonly="readonly"/>
			</td>
			<td class="rightAligned" >Ann Premium Amt. </td>
			<td class="leftAligned" >
				<input id="cAnnPremAmt" name="cAnnPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required money" readonly="readonly"/>
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
			<td class="leftAligned" colspan="3" ><input type="checkbox" id="cAggregateSw" name="cAggregateSw"/><font class="rightAligned"> Aggregate</font></td>
		</tr>
		<tr>
			<td colspan="4">
				<!-- <input id="cAnnPremAmt" 	name="cAnnPremAmt" 		type="hidden" style="width: 215px;" value="" maxlength="14" class="money"/>
				<input id="cAnnTsiAmt"	 	name="cAnnTsiAmt" 		type="hidden" style="width: 215px;" value="" maxlength="18" class="money"/> -->
				<input id="cGroupedItemNo" 	name="cGroupedItemNo" 	type="hidden" style="width: 215px;" value="" />
				<input id="cLineCd" 		name="cLineCd" 			type="hidden" style="width: 215px;" value="" />
				<input id="cRecFlag" 		name="cRecFlag"	 		type="hidden" style="width: 215px;" value="A" />
				<input id="cRiCommRt" 		name="cRiCommRt" 		type="hidden" style="width: 215px;" value="" maxlength="13" class="moneyRate"/>
				<input id="cRiCommAmt" 		name="cRiCommAmt" 		type="hidden" style="width: 215px;" value="" maxlength="16" class="money"/>
				<input id="cWcSw" 			name="cWcSw"	 		type="hidden" style="width: 215px;" value="" />
				<input id="cPerilType" 		name="cPerilType"	 	type="hidden" style="width: 215px;" value="" />
				<input id="" name="" type="hidden" value="0">
				<input id="" name="" type="hidden" value="0">
			</td>
		</tr>		
	</table>
	
	<table align="center" style="margin-bottom: 10px">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnCopyBenefits" 	name="btnCopyBenefits" 		value="Copy Benefits" 	style="width: 95px;" />
				<input type="button" class="button" 		id="btnAddCoverage" 	name="btnAddCoverage" 		value="Add" 			style="width: 85px;" />
				<input type="button" class="disabledButton" id="btnDeleteCoverage" 	name="btnDeleteCoverage" 	value="Delete" 			style="width: 85px;" />
			</td>
		</tr>
	</table> 
</div>

<script type="text/javascript">
//try{
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	var fromDateFromItem = "";
	var toDateFromItem = "";
	var packBenCdFromItem = "";
	var prorateFlagFromItem = "";
	var compSwFromItem = "";
	var shortRatePercentFromItem = "";
	
	function onOkFunc() {
		$("cBaseAmt").value = "";
		var starDate = (fromDateFromItem == "" ? $F("wpolbasInceptDate") :fromDateFromItem);
		var endDate = (toDateFromItem == "" ? $F("wpolbasExpiryDate") :toDateFromItem);
		var itemNoOfDays = computeNoOfDays(starDate,endDate,"");
		var grpbgNoOfDays = computeNoOfDays($("fromDate").value,$("toDate").value,"");
		$("cNoOfDays").value = (grpbgNoOfDays == "" ? itemNoOfDays : grpbgNoOfDays);
		computeVals();
	}	
	
	function onCancelFunc() {
		computeVals();
	}	

	$("cPerilCd").observe("change", function() {
		if ($("cPerilCd").options[$("cPerilCd").selectedIndex].getAttribute("wcSw") == "Y"){
			showConfirmBox("Message", "Peril has an attached warranties and clauses, would you like to use these as your default values on warranties and clauses?",  
					"Yes", "No", onOkFunc, onCancelFunc);
		} else{
			$("cWcSw").value = "";
		}	
		$("cPerilType").value = $("cPerilCd").options[$("cPerilCd").selectedIndex].getAttribute("perilType");
	});

	$("cPremRt").observe("change", function() {
		if (parseFloat($F('cPremRt').replace(/,/g, "")) < 0.000000000) {
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

	var tsiAmtOrig = "";
	$("cTsiAmt").observe("focus", function() {
		if ($F("cTsiAmt") != ""){
			tsiAmtOrig = $F("cTsiAmt");
		}
	});
		
	$("cTsiAmt").observe(/*"blur"*/ "change", function() {
		if (parseFloat($F("cTsiAmt").replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("cTsiAmt").focus();
			$("cTsiAmt").value = "";
		} else if (parseFloat($F("cTsiAmt").replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("cTsiAmt").focus();
			$("cTsiAmt").value = "";
		} else if (parseFloat($F("cTsiAmt").replace(/,/g, "")) != parseFloat(tsiAmtOrig.replace(/,/g, "")) && tsiAmtOrig != "") {
			if ($F("cBaseAmt") != "" && $F("cNoOfDays") != ""){
				showConfirmBox("Message", "Changing TSI amount will delete base amount and set number of days to its default value, do you want to continue?",  
						"Yes", "No", onOkFunc, onCancelFunc);
			} else{
				computeVals();
			}		
		} else{
			computeVals();
		}
		
		var vMax = 0;
		var vMax2 = 0;
		
		$$("div[name='cov']").each(function (row)	{
			if (!row.hasClassName("selectedRow") && row.down("input",17).value == "B"){
				if (parseFloat(row.down("input",4).value.replace(/,/g, "")) > parseFloat(vMax)){
					vMax = parseFloat(row.down("input",4).value.replace(/,/g, ""));
				}	 
			} else if (!row.hasClassName("selectedRow") && row.down("input",17).value == "A"){
				if (parseFloat(row.down("input",4).value.replace(/,/g, "")) > parseFloat(vMax2)){
					vMax2 = parseFloat(row.down("input",4).value.replace(/,/g, ""));
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

/* 	$("cPremAmt").observe("blur", function() {
		if (parseFloat($F('cPremAmt').replace(/,/g, "")) < -9999999999.99) {
			showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("cPremAmt").focus();
			$("cPremAmt").value = "";
		} else if (parseFloat($F('cPremAmt').replace(/,/g, "")) >  9999999999.99){
			showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("cPremAmt").focus();
			$("cPremAmt").value = "";
		} else if (parseFloat($F('cTsiAmt').replace(/,/g, "")) != parseFloat(tsiAmtOrig.replace(/,/g, "")) && tsiAmtOrig != "") {
			if ($F("cBaseAmt") != "" && $F("cNoOfDays") != ""){
				null;
			} else{		
				computeVals();
			}	
		} else{
			computeVals();
		}	
	}); */	
	var origPremAmt = "0.00";
	$("cPremAmt").observe("focus", function() {
		if ($F("cPremAmt") != ""){
			origPremAmt = $F("cPremAmt");
		}
	});
	$("cPremAmt").observe("change", function(){computeCoveragePremAmt("change");});
	$("cBaseAmt").observe(/*"blur"*/ "change", function() {
		if (parseFloat($F('cBaseAmt').replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered Base Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("cBaseAmt").focus();
			$("cBaseAmt").value = "";
		} else if (parseFloat($F('cBaseAmt').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered Base Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
			$("cBaseAmt").focus();
			$("cBaseAmt").value = "";
		} else{
			computeVals();
		}
	});

	$("cNoOfDays").observe(/*"blur"*/ "change", function() {
		if ($F("cNoOfDays") == ""){
			$("cBaseAmt").value = "";
		} else if ($F("cNoOfDays") == "0"){
			$("cBaseAmt").value = "0";
		}	
		computeVals();
	});
	
	function computeVals(){
		// dapat meron pang compute_tsi proc from gipis065.fmb
		if (parseFloat($("cBaseAmt").value) > 0.00 && parseInt($("cNoOfDays").value.replace(/,/g, "")) > 0){
			$("cTsiAmt").value = formatCurrency(parseFloat($F("cBaseAmt").replace(/,/g, ""))*parseInt($F("cNoOfDays").replace(/,/g, "")));
		}	
		var year = serverDate.getFullYear();
		var noOfDays = getNoOfDaysInYear(year);
		var starDate = (fromDateFromItem == "" ? $F("wpolbasInceptDate") :fromDateFromItem);
		var endDate = (toDateFromItem == "" ? $F("wpolbasExpiryDate") :toDateFromItem);
		var itemNoOfDays = computeNoOfDays(starDate,endDate,"");
		var grpbgNoOfDays = computeNoOfDays($("grpFromDate").value,$("grpToDate").value,"");
		var prorateFlag = prorateFlagFromItem;
		var tsiAmt = 0;
		var premRt = 0;
		var annTsiCopy = unformatCurrency("annTsiCopy");
		var annPremCopy = unformatCurrency("annPremCopy");
		if ($F("cTsiAmt") != ""){
			premRt = (parseFloat($F("cPremRt") == "" ? "0.00" :$F("cPremRt").replace(/,/g, ""))/parseInt(100));
			tsiAmt = parseFloat($F("cTsiAmt") == "" ? "0.00" :$F("cTsiAmt").replace(/,/g, ""));
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
		/* $("cAnnPremAmt").value = formatCurrency(premRt*tsiAmt);;	
		$("cAnnTsiAmt").value = $F("cTsiAmt");	 */
		
		$("cAnnTsiAmt").value = formatCurrency(annTsiCopy+tsiAmt);
		$("cAnnPremAmt").value = formatCurrency(annPremCopy+unformatCurrency("cPremAmt"));

		if ($F("cPerilCd") == ""){
			$("cPremAmt").value = "";
			$("cAnnPremAmt").value = "";
			$("cAnnTsiAmt").valu = "";
			$("cNoOfDays").value = "";
			$("cBaseAmt").value = "";
		}	
	}

	function addCoverage(){
		try {
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			
			var newObj = setItemPerilGrouped();//setGrpCoverageObj();
			var content = prepareCoverageDisplay(newObj);//prepareGrpCoverageInfo(newObj);
			var tableContainer = $("coverageListing");
			var rowId = "rowCoverage"+newObj.itemNo+newObj.groupedItemNo+newObj.perilCd;
			//objFormMiscVariables.miscNbtInvoiceSw = "Y";
			
			if(validateAmountCoverage()){
				if($F("btnAddCoverage") == "Update") {	
					
					
					$(rowId).update(content);		
					newObj.recordStatus = 1;	

					for (var i=0; i<objGIPIWItmperlGrouped.length; i++) {
						//if(objArray[i].recordStatus == 0 && objArray[i].itemNo == editedObj.itemNo){
						if(objGIPIWItmperlGrouped[i].itemNo == newObj.itemNo && 
								objGIPIWItmperlGrouped[i].groupedItemNo == newObj.groupedItemNo &&
								objGIPIWItmperlGrouped[i].perilCd == newObj.perilCd){
							objGIPIWItmperlGrouped.splice(i, 1);
						}
					}
					objGIPIWItmperlGrouped.push(newObj);
					//addModifiedJSONObject(objGIPIWItmperlGrouped, newObj);				
					fireEvent($(rowId), "click");
					setCoverageAmounts(1, newObj);
					computeEndtCoverageTotals(newObj.itemNo, newObj.groupedItemNo);
				} else {		
					
					//validateAmountCoverage();
					newObj.recordStatus = 0;
					objGIPIWItmperlGrouped.push(newObj);
					
					var newDiv = new Element("div");
					
					newDiv.setAttribute("id", rowId);
					newDiv.setAttribute("name", "rowCoverage");
					newDiv.setAttribute("item", newObj.itemNo);
					newDiv.setAttribute("grpItem", newObj.groupedItemNo);
					newDiv.setAttribute("perilCd", newObj.perilCd);
					newDiv.setAttribute("parId", newObj.parId);
					newDiv.addClassName("tableRow");				
					
					newDiv.update(content);

					setRowCoverageObserver(newDiv);				
					
					tableContainer.insert({bottom:newDiv});	
					setCoverageAmounts(0, null);		
					computeEndtCoverageTotals(newObj.itemNo, newObj.groupedItemNo);	
							
				}
				($$("div#coverageListing div:not([item="+newObj.itemNo+"])")).invoke("hide");
				($$("div#coverageListing div:not([grpItem="+newObj.groupedItemNo+"])")).invoke("hide");
				resizeTableBasedOnVisibleRows("coverageTable", "coverageListing");
				//checkIfToResizeTable("coverageListing", "rowCoverage");
				checkTableIfEmpty("rowCoverage", "coverageListing");

				setCoverForm(null);
			}
			//validateAmountCoverage();
			
		} catch(e) {
			showErrorMessage("addCoverage", e);
		}
	}

	// irwin
	function validateAmountCoverage(){
		try{
			
			var bool = true;
			var objArrBasic = [];
			var objArrAllied = [];
			var maxBasic = 0;
			var maxAllied = 0;
			var groupedItemNo = parseInt(removeLeadingZero($F("groupedItemNo")));
			objArrBasic = objGIPIWItmperlGrouped.filter(function(o){
				return nvl(o.recordStatus, 0) != -1 && parseInt(o.groupedItemNo) == groupedItemNo && o.perilType == "B";
			});
			
			objArrAllied = objGIPIWItmperlGrouped.filter(function(o){
				return nvl(o.recordStatus, 0) != -1 && parseInt(o.groupedItemNo) == groupedItemNo && o.perilType == "A";
			});
			
			maxBasic = parseInt(objArrBasic.max(function(o) {
				return parseFloat((nvl(o.tsiAmt, "0")).toString().replace(/,/g, ""));
			}));
			

			maxAllied = parseInt(objArrAllied.max(function(o) {
				return parseFloat((nvl(o.tsiAmt, "0")).toString().replace(/,/g, ""));
			}));
			
			if (parseFloat(maxBasic) != parseFloat(0)){			
				if ($F("cPerilType") == "A" && parseFloat($F("cTsiAmt").replace(/,/g, "")) > parseFloat(maxBasic)){
					customShowMessageBox("TSI amt of allied perils should be less than the maximum TSI amt of basic perils.", imgMessage.ERROR, "cTsiAmt");				
					$("cTsiAmt").value = "";
					$("cPremAmt").value = "";
					bool = false;
				} else if ($F("cPerilType") == "B" && parseFloat(maxBasic) < parseFloat(maxAllied)){
					customShowMessageBox("TSI amt of allied perils should be less than the maximum TSI amt of basic perils.", imgMessage.ERROR, "cTsiAmt");				
					$("cTsiAmt").value = "";
					$("cPremAmt").value = "";
					bool = false;
				}else{
					bool = true;
				}
			}
			return bool;
		}catch(e){
			showErrorMessage("validateAmountCoverage",e)
		}
	}
		
	$("btnAddCoverage").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("coverageInfoDiv")){
			if(($$("div#accidentGroupedItemsTable .selectedRow")).length < 1){
				showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.ERROR);
				return false;
			} else if ($F("isItmPerilExists") == "Y") {
				showMessageBox("You cannot insert grouped item perils because there are "+
						"existing item perils for this item. Please check the records in the item peril module", "e");
				setCoverForm(null);
				return false;
			}else if (unformatCurrency("cTsiAmt") == 0){	//added by steven to check if you will add a zero TSI Amt.
				showMessageBox("TSI amount must not be equal to zero.",imgMessage.ERROR);
				$("cTsiAmt").focus();
			}else{
				var itemNo = $F("itemNo");
				var grpItemNo = parseInt($F("groupedItemNo"));
				var perilCd = $F("cPerilCd");

				if($((("rowCoverage" + itemNo) + grpItemNo) + perilCd) != null && $F("btnAddCoverage") == "Add"){
					showMessageBox("Record already exists!", imgMessage.ERROR);
					return false;
				}
				
				addCoverage();
				//selectAccidentGroupedItemPerilOptionsToShow(grpItemNo); // andrew - 01.10.2012 - comment out
				//filterLOV3("cPerilCd", "rowCoverage", "perilCd", "grpItem", grpItemNo);
			}	
		}
				
	});

	function setGrpCoverageObj() {
		try {
			var newObj = new Object();
			
			newObj.parId 			= objUWGlobal.parId;
			newObj.itemNo 			= $F("itemNo");
			newObj.groupedItemNo	= $F("groupedItemNo");
			newObj.lineCd			= $F("grpLineCd");
			newObj.perilCd			= $F("cPerilCd");
			newObj.perilName		= $("cPerilCd").options[$("cPerilCd").selectedIndex].text;
			newObj.recFlag			= nvl($F("cRecFlag"), "A"); // changed from recFlag to cRecFlag (emman 05.18.2011)
			newObj.noOfDays			= $F("cNoOfDays");
			newObj.premRt			= $F("cPremRt");
			newObj.tsiAmt			= $F("cTsiAmt");
			newObj.premAmt			= $F("cPremAmt");
			newObj.annTsiAmt		= $F("cAnnTsiAmt");
			newObj.annPremAmt		= $F("cAnnPremAmt");
			newObj.aggregateSw		= $("cAggregateSw").checked ? "Y" : "N";
			newObj.baseAmt			= $F("cBaseAmt");
			newObj.riCommRate		= $F("cRiCommRt");
			newObj.riCommAmt		= $F("cRiCommAmt");			
			
			return newObj;
		} catch(e) {
			showErrorMessage("setGrpCoverageObj", e);
		}
	}

	$("btnDeleteCoverage").observe("click", function() {
		try {			
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			//objFormMiscVariables.miscNbtInvoiceSw = "Y";
			//$$("div#coverageTable div[id='cvgRow"+$F("itemNo")+delObj.groupedItemNo+delObj.perilCd+"']").each(function(row) {
			var delObj = setItemPerilGrouped();//setGrpCoverageObj();
			var cnt = 1;
			var perilName = "";
			for ( var i = 0; i < objGIPIWItmperlGrouped.length; i++) {		// added by steven 9/6/2012
				if(objGIPIWItmperlGrouped[i].recordStatus == -1){
					cnt++;
				}
				if(objGIPIWItmperlGrouped[i].perilType == "A" && objGIPIWItmperlGrouped[i].recordStatus != -1){
					perilName =objGIPIWItmperlGrouped[i].perilName;
				}
			}
			if (delObj.perilType == "B" && objGIPIWItmperlGrouped.length != cnt && perilName != ""){	// added by steven 9/25/2012 validation for deleting. 
				showMessageBox("The peril '"+perilName+"' must be deleted first.");
			}else{
				$$("div#coverageTable div[name='rowCoverage']").each(function(row) {	
					if(row.hasClassName("selectedRow")) {
						Effect.Fade(row, {
							duration: .2,
							afterFinish: function() {
								
								
									addDelObjByAttr(objGIPIWItmperlGrouped, delObj, "groupedItemNo perilCd");
									row.remove();
									
									setCoverForm(null);
									//checkIfToResizeTable("coverageListing", "rowCoverage");
									resizeTableBasedOnVisibleRows("coverageTable", "coverageListing");
									//checkTableIfEmpty("rowCoverage", "coverageTable");
									//selectAccidentGroupedItemPerilOptionsToShow(delObj.groupedItemNo); // andrew - 01.10.2012 - comment out
									//filterLOV3("cPerilCd", "rowCoverage", "perilCd", "grpItem", delObj.groupedItemNo);
									computeEndtCoverageTotals(delObj.itemNo, delObj.groupedItemNo);
									setCoverageAmounts(-1, null);
							}
						});
					}
				});
			}
		} catch(e) {
			showErrorMessage("deleteCoverage", e);
		}
	});		
	
	showCoverageList(objGIPIWItmperlGrouped);
	hideAllGroupedItemPerilOptions();
	showGroupedBasicPerilsOnly();
	
	function computePremRt(action){
		var year = serverDate.getFullYear();
		var noOfDays = getNoOfDaysInYear(year);
		var starDate = (fromDateFromItem == "" ? objGIPIWPolbas.inceptDate.split(" ")[0] :fromDateFromItem);
		var endDate = (toDateFromItem == "" ? objGIPIWPolbas.expiryDate.split(" ")[0] :toDateFromItem);
		var itemNoOfDays = computeNoOfDays(starDate,endDate,"");
		var grpbgNoOfDays = computeNoOfDays($("grpFromDate").value,$("grpToDate").value,"");
		var prorateFlag = prorateFlagFromItem;		
		var premRt = (parseFloat($F("cPremRt") == "" ? "0.00" :$F("cPremRt").replace(/,/g, ""))/parseInt(100));
		var tsiAmt = parseFloat($F("cTsiAmt") == "" ? "0.00" :$F("cTsiAmt").replace(/,/g, ""));
		
		if (prorateFlag == "1"){
			var compSw = compSwFromItem;
			
			switch(compSw){
				case "M" : $("cPremRt").value = formatToNineDecimal(roundNumber(((nvl(unformatCurrency("cPremAmt"),0) / nvl(unformatCurrency("cTsiAmt"),0)) * ((nvl(grpbgNoOfDays,noOfDays)-1)/year)) * 100,9)); break;
				case "Y" : $("cPremRt").value = formatToNineDecimal(roundNumber(((nvl(unformatCurrency("cPremAmt"),0) / nvl(unformatCurrency("cTsiAmt"),0)) * ((nvl(grpbgNoOfDays,noOfDays)+1)/year)) * 100,9)); break;
				default	 : $("cPremRt").value = formatToNineDecimal(roundNumber(((nvl(unformatCurrency("cPremAmt"),0) / nvl(unformatCurrency("cTsiAmt"),0)) * ((nvl(grpbgNoOfDays,noOfDays))/year)) * 100,9)); break;
			}				
		} else if (prorateFlag == "2"){
			$("cPremRt").value = formatToNineDecimal(roundNumber((nvl(unformatCurrency("cPremAmt"),0)/(nvl(unformatCurrency("cTsiAmt"),0)))* 100,9));
		} else if (prorateFlag == "3"){
			var shortRt = (parseFloat(shortRatePercentFromItem == "" ? "0.00" :shortRatePercentFromItem.replace(/,/g, ""))/parseInt(100));
			$("cPremRt").value = formatToNineDecimal(roundNumber((((nvl(unformatCurrency("cPremAmt"),0)/100)/(nvl(unformatCurrency("cTsiAmt"),0))) * shortRt)*10000,9));
		} else{			
			$("cPremRt").value = formatToNineDecimal(roundNumber((nvl(unformatCurrency("cPremAmt"),0)/(nvl(unformatCurrency("cTsiAmt"),0)))* 100,9));
		}
		computeVals();
	}	
	
	function computeCoveragePremAmt(action){
		try{
			$("cPremAmt").value = $F("cPremAmt") == "" ? "0.00" : $F("cPremAmt");			
			if(isAmountWithinRange($F("cPremAmt"), $("cPremAmt").getAttribute("min"), $("cPremAmt").getAttribute("max"))){
				if (parseFloat($F('cTsiAmt').replace(/,/g, "")) != parseFloat(tsiAmtOrig.replace(/,/g, "")) && tsiAmtOrig != "") {
					if ($F("cTsiAmt") != ""){	
						computePremRt(action);
					}else{				
						computeVals();				
					}
				} else{			
					if ($F("cTsiAmt") != ""){	
						computePremRt(action);
					}else{				
						computeVals();				
					}
				}	
			}

			if(!isAmountWithinRange($F("cPremRt"), $("cPremRt").getAttribute("min"), $("cPremRt").getAttribute("max"))){
				fireEvent($("cPremRt"), "change");
				$("cPremAmt").value = origPremAmt;
				fireEvent($("cPremAmt"), "change");
			}
		}catch(e){
			showErrorMessage("computeCoveragePremAmt", e);
		}
	}
	
	function getEndtCoveragePerilAmounts(){
		new Ajax.Request(contextPath + "/GIPIWItmperlGroupedController", { 
			parameters : {action : "getEndtCoveragePerilAmounts",
						  parId : $F("globalParId"),			
						  itemNo : $F("itemNo"),
						  groupedItemNo : $F("groupedItemNo"),
						  perilCd : $F("cPerilCd"),
						  perilType : $F("cPerilType"),
						  premRt : $F("cPremRt"),
						  tsiAmt : $F("cTsiAmt"),
						  annTsiAmt : $F("annTsiAmt"),
						  premAmt : $F("cPremAmt"),
						  annPremAmt : $F("cAnnPremAmt"),
						  //itemTsiAmt : "itemTsiAmt",
						  //itemAnnTsiAmt : "itemAnnTsiAmt",
						  //itemPremAmt : "itemPremAmt",
						  //itemAnnPremAmt : "itemAnnPremAmt",
						  baseAmt : $F("cBaseAmt"),
						  riCommRate : $F("cRiCommRt"),
						  riCommAmt : $F("cRiCommAmt"),
						  backEndt : $F("globalBackEndt")},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){			
					var result = JSON.parse(response.responseText);
					if(result.messageType == "INFO") {
						$("cTsiAmt").value = formatCurrency(result.tsiAmt);
						$("cPremAmt").value = formatCurrency(result.premAmt);
						$("cAnnTsiAmt").value = formatCurrency(nvl(result.annTsiAmt, '0'));
						$("cAnnPremAmt").value = formatCurrency(nvl(result.annPremAmt, '0'));
						$("cPremRt").value = formatToNineDecimal(result.premRt);
						$("cRecFlag").value = result.recFlag;
						$("cRiCommRt").value = formatToNineDecimal(result.riCommRt);
						$("cRiCommAmt").value = formatCurrency(result.riCommAmt);
						$("cBaseAmt").value = formatCurrency(result.baseAmt);
						$("annTsiCopy").value = $F("cAnnTsiAmt");
						$("annPremCopy").value = $F("cAnnPremAmt");
						if(result.aggregateSw == "Y"){
							$("cAggregateSw").checked = true;
						} else {
							$("cAggregateSw").checked = false;
						}
						if(result.message != "SUCCESS"){
							showMessageBox(result.message, imgMessage.INFO);
						}
					} else if(result.messageType = "ERROR"){
						showMessageBox(result.message, imgMessage.ERROR);
					}
				}
			}
		});
	}
	
	$("hrefCPeril").observe("click", function(){
		if($$("#accidentGroupedItemsListing .selectedRow").length > 0){
			var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
			var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWGlobal.lineCd);
			var sublineCd = nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")));			

			var notIn = "";
			var withPrevious = false;
			var withSelectedRow = false;
			$$("div#coverageListing div[name='rowCoverage']").each(function(row){		
				if(row.hasClassName("selectedRow")){	
					withSelectedRow = true;
				} 
				if(parseInt(row.getAttribute("item")) == parseInt($F("itemNo")) &&
						parseInt(row.getAttribute("grpItem")) == removeLeadingZero($F("groupedItemNo"))) {	
					if(withPrevious) notIn += ",";
					notIn += row.getAttribute("perilCd");
					withPrevious = true;
				}			
			});
			
			if(!withSelectedRow){
				notIn = (notIn != "" ? "("+notIn+")" : "");
				var perilType = ""; 
				if(notIn == null || notIn == ""){
					perilType = "B";
				}
				
				showGroupedPerilLOV(parId, lineCd, sublineCd, notIn, perilType, function(){
					getEndtCoveragePerilAmounts();
					if(!($F("cPerilName").empty()) && $F("cWcSw") == "Y"){
						showConfirmBox("Message", "Peril has an attached warranties and clauses, would you like to use these as your default values on warranties and clauses?",  
								"Yes", "No", 
								function(){
									$("cWcSw").value = "Y";
								}, 
								function(){
									$("cWcSw").value = "N";
								});
					}
					
					var bascPerilExists = false;
					if($F("cBascPerlCd") != "") {
						for(var i=0; i<objGIPIWItmperlGrouped.length; i++){
							if(objGIPIWItmperlGrouped[i].itemNo == itemNo && objGIPIWItmperlGrouped[i].perilType == "B" 
								&& objGIPIWItmperlGrouped[i].groupedItemNo == groupedItemNo && objGIPIWItmperlGrouped[i].recordStatus != -1
								&& $F("cBascPerlCd") == objGIPIWItmperlGrouped[i].perilCd){
								bascPerilExists = true;
								break;
							}
						}
						if(!bascPerilExists) {
							showErrorMessage("Basic Peril "+$F("cBasicPerilName")+" must be added first before this peril.", "error");
							setCoverForm(null);
						}
					}
				});
			}
		}else{
			showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.INFO);
			return false;
		}		
	});
</script>