<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="coverageInformationInfo" class="sectionDiv" style="display: none; width:872px; background-color:white; ">
	<jsp:include page="/pages/underwriting/subPages/accidentCoverageListing.jsp"></jsp:include>
	<table align="center" border="0">
		<tr>
			<td class="rightAligned" >Peril Name </td>
			<td class="leftAligned" >
				<select  id="cPerilCd" name="cPerilCd" style="width: 223px" class="required">
					<option value="" wcSw="" perilType=""></option>
					<c:forEach var="perils" items="${perils}">
						<option value="${perils.perilCd}" wcSw="${perils.wcSw }" perilType="${perils.perilType}">${perils.perilName}</option>
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
				<input type="button" class="button" 		id="btnAddCoverage" 	name="btnAddCoverage" 		value="Add" 		style="width: 85px;" />
				<input type="button" class="disabledButton" id="btnDeleteCoverage" 	name="btnDeleteCoverage" 	value="Delete" 		style="width: 85px;" />
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	var fromDateFromItem = $F("fromDate");
	var toDateFromItem = $F("toDate");
	var packBenCdFromItem = $F("accidentPackBenCd");
	var prorateFlagFromItem = $F("accidentProrateFlag");
	var compSwFromItem = $F("accidentCompSw");
	var shortRatePercentFromItem = $F("accidentCompSw");
/*	$$("div#itemTable div[name='rowItem']").each(function(a){
		if (a.hasClassName("selectedRow")){
			fromDateFromItem = a.down("input",14).value;
			toDateFromItem = a.down("input",15).value;
			packBenCdFromItem = a.down("input",27).value;
			prorateFlagFromItem = a.down("input",24).value;
			compSwFromItem = a.down("input",25).value;
			shortRatePercentFromItem = a.down("input",26).value;
		}	
	});*/

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
		
	$("cTsiAmt").observe("blur", function() {
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

		var vMax = 0;
		var vMax2 = 0;
		var origTsiAmtSelected = 0;
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
			if (row.hasClassName("selectedRow")) origTsiAmtSelected = parseFloat(row.down("input",4).value.replace(/,/g, ""));
		});	

		if (parseFloat(vMax) != parseFloat(0)){
			if ($F("btnAddCoverage") == "Update"){
				if ($F("cPerilType") == "A") vMax2 = (vMax2-origTsiAmtSelected)+parseFloat($F("cTsiAmt").replace(/,/g, ""));
				if ($F("cPerilType") == "B") vMax = (vMax-origTsiAmtSelected)+parseFloat($F("cTsiAmt").replace(/,/g, ""));
			}	
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

	function computePremRt(){
		var year = serverDate.getFullYear();
		var noOfDays = getNoOfDaysInYear(year);
		var starDate = (fromDateFromItem == "" ? $F("wpolbasInceptDate") :fromDateFromItem);
		var endDate = (toDateFromItem == "" ? $F("wpolbasExpiryDate") :toDateFromItem);
		var itemNoOfDays = computeNoOfDays(starDate,endDate,"");
		var grpbgNoOfDays = computeNoOfDays($("grpFromDate").value,$("grpToDate").value,"");
		var prorateFlag = prorateFlagFromItem;
		var premRt = (parseFloat($F("cPremRt") == "" ? "0.00" :$F("cPremRt").replace(/,/g, ""))/parseInt(100));
		var tsiAmt = parseFloat($F("cTsiAmt") == "" ? "0.00" :$F("cTsiAmt").replace(/,/g, ""));
		if (prorateFlag == "1"){
			var compSw = compSwFromItem;
			if (compSw == "M"){
				$("cPremRt").value = formatToNineDecimal(roundNumber(((nvl(unformatCurrency("cPremAmt"),0) / nvl(unformatCurrency("cTsiAmt"),0)) * ((nvl(grpbgNoOfDays,noOfDays)-1)/year)) * 100,9));
			} else if (compSw == "Y"){
				$("cPremRt").value = formatToNineDecimal(roundNumber(((nvl(unformatCurrency("cPremAmt"),0) / nvl(unformatCurrency("cTsiAmt"),0)) * ((nvl(grpbgNoOfDays,noOfDays)+1)/year)) * 100,9));
			} else{
				$("cPremRt").value = formatToNineDecimal(roundNumber(((nvl(unformatCurrency("cPremAmt"),0) / nvl(unformatCurrency("cTsiAmt"),0)) * ((nvl(grpbgNoOfDays,noOfDays))/year)) * 100,9));
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
	
	var preCPremAmt = "";
	$("cPremAmt").observe("focus", function() {
		preCPremAmt = $F("cPremAmt");
	});	
	$("cPremAmt").observe("blur", function() {
		if (parseFloat($F('cPremAmt').replace(/,/g, "")) < -9999999999.99) {
			showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("cPremAmt").focus();
			$("cPremAmt").value = "";
		} else if (parseFloat($F('cPremAmt').replace(/,/g, "")) >  9999999999.99){
			showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
			$("cPremAmt").focus();
			$("cPremAmt").value = "";
		} else if (parseFloat($F('cTsiAmt').replace(/,/g, "")) != parseFloat(tsiAmtOrig.replace(/,/g, "")) && tsiAmtOrig != "") {
			if ($F("cTsiAmt") != ""){
				if (preCPremAmt != $F("cPremAmt")){
					computePremRt();
				}
			}else{
				computeVals();
			}
		} else{
			if ($F("cTsiAmt") != ""){
				if (preCPremAmt != $F("cPremAmt")){
					computePremRt();
				}
			}else{
				computeVals();
			}
		}	
	});

	$("cBaseAmt").observe("blur", function() {
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

	$("cNoOfDays").observe("blur", function() {
		if ($F("cNoOfDays") == ""){
			$("cBaseAmt").value = "";
		} else if ($F("cNoOfDays") == "0"){
			$("cBaseAmt").value = "0";
		}	
		computeVals();
	});
	
	function computeVals(){
		try{
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
			$("cAnnPremAmt").value = formatCurrency(premRt*tsiAmt);;	
			$("cAnnTsiAmt").value = $F("cTsiAmt");	
	
			/*if ($F("cPerilCd") == ""){
				$("cPremAmt").value = "";
				$("cAnnPremAmt").value = "";
				$("cAnnTsiAmt").valu = "";
				$("cNoOfDays").value = "";
				$("cBaseAmt").value = "";
			}	*/
		}catch(e){
			showErrorMessage("computeVals", e);
		}
	}	

	$("btnAddCoverage").observe("click", function() {
		$("popBenDiv").hide();
		if (checkGroupedItemNoExist()){
			addCoverage();
		} else{
			return false;
		}		
	});

	$$("div[name='cov']").each(
			function (newDiv)	{
				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});

				newDiv.observe("click", function ()	{
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow"))	{
						$$("div[name='cov']").each(function (li)	{
							if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});

						filterLOV("cPerilCd","cov",2,newDiv.down("input",2).value,"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
						$("cPerilCd").value = newDiv.down("input",2).value;	
						$("cPremRt").value = formatToNineDecimal(newDiv.down("input",3).value);	
						$("cTsiAmt").value = formatCurrency(newDiv.down("input",4).value);	
						$("cPremAmt").value = formatCurrency(newDiv.down("input",5).value);	
						$("cNoOfDays").value = newDiv.down("input",6).value;	
						$("cBaseAmt").value = (newDiv.down("input",7).value == "" ? "" :formatCurrency(newDiv.down("input",7).value));	
						var cAggregateSw = newDiv.down("input",8).value;	
						if(cAggregateSw == 'Y'){
							$("cAggregateSw").checked = true;
						} else {
							$("cAggregateSw").checked = false;
						}
						$("cAnnPremAmt").value = newDiv.down("input",9).value;	
						$("cAnnTsiAmt").value = newDiv.down("input",10).value;	
						$("cGroupedItemNo").value = newDiv.down("input",11).value;	
						$("cLineCd").value = newDiv.down("input",12).value;	
						$("cRecFlag").value = newDiv.down("input",13).value;	
						$("cRiCommRt").value = newDiv.down("input",14).value;	
						$("cRiCommAmt").value = newDiv.down("input",15).value;	
						$("cWcSw").value = newDiv.down("input",16).value;	
						$("cPerilType").value = newDiv.down("input",17).value;	
						
						getDefaults();
					} else {
						clearForm();
					}
				}); 
				
			}	
	);
	
	function addCoverage() {	
		try	{
			var cParId = $F("parId");
			var cItemNo = $F("itemNo");
			var cPerilCd = $F("cPerilCd");
			var cPremRt = $F("cPremRt");
			var cTsiAmt = $F("cTsiAmt");
			var cPremAmt = $F("cPremAmt");
			var cNoOfDays = $F("cNoOfDays");
			var cBaseAmt = $F("cBaseAmt");
			var cAggregateSw = $("cAggregateSw").checked==true?'Y':'N';
			var cAnnPremAmt = $F("cAnnPremAmt");
			var cAnnTsiAmt = $F("cAnnTsiAmt");
			var cGroupedItemNo = getSelectedRowAttrValue("grpItem","groupedItemNo");
			var cLineCd = ($F("cLineCd") == "" ? $F("globalLineCd") :$F("cLineCd")); 
			var cRecFlag = ($F("cRecFlag") == "" ? "C" :$F("cRecFlag"));
			var cRiCommRt = $F("cRiCommRt");
			var cRiCommAmt = $F("cRiCommAmt");
			var cPerilName = changeSingleAndDoubleQuotes2($("cPerilCd").options[$("cPerilCd").selectedIndex].text);
			var cEnrolleeName = changeSingleAndDoubleQuotes2(getSelectedRowAttrValue("grpItem","groupedItemTitle"));
			var cWcSw = $F("cWcSw");
			var cPerilType = $F("cPerilType");	

			var sumTsiAmt = parseFloat($F('amountCovered').replace(/,/g, "")) + parseFloat($F('totalTsiAmtPerItem').replace(/,/g, "")) + parseFloat($F("cTsiAmt").replace(/,/g, ""));
			var sumPremAmt = parseFloat($F('premAmt').replace(/,/g, "")) + parseFloat($F('totalPremAmtPerItem').replace(/,/g, "")) + parseFloat($F("cPremAmt").replace(/,/g, ""));
			var latestTsi = 0;
			var latestPrem = 0;
			$$("div[name='cov']").each(function(row){
				if (row.hasClassName("selectedRow"))	{
					latestTsi = parseFloat($F('amountCovered').replace(/,/g, "")) - parseFloat(row.down("input",4).value.replace(/,/g, ""));
					latestPrem = parseFloat($F('premAmt').replace(/,/g, "")) - parseFloat(row.down("input",5).value.replace(/,/g, ""));
				}
			});
			var sumTsiAmt2 = parseFloat($F('totalTsiAmtPerItem').replace(/,/g, "")) + parseFloat(latestTsi) + parseFloat($F("cTsiAmt").replace(/,/g, ""));
			var sumPremAmt2 = parseFloat($F('totalPremAmtPerItem').replace(/,/g, "")) + parseFloat(latestPrem) + parseFloat($F("cPremAmt").replace(/,/g, ""));
			
			var exists = false;
			
			if (cPerilCd == "") {
				showMessageBox("Peril Name must be entered.", imgMessage.ERROR);
				exists = true;
			} else if (cTsiAmt == "") {
				showMessageBox("TSI Amount must be entered", imgMessage.ERROR);
				exists = true;
			} else if (cPremAmt == "") {
				showMessageBox("Premium Amount must be entered", imgMessage.ERROR);
				exists = true;
			} else if (cPremRt == "") {
				showMessageBox("Peril Rate must be entered", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat($F('cTsiAmt').replace(/,/g, "")) < -99999999999999.99) {
				showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat($F('cTsiAmt').replace(/,/g, "")) >  99999999999999.99){
				showMessageBox("Entered TSI Amount is invalid. Valid value is from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat($F('cPremAmt').replace(/,/g, "")) < -9999999999.99) {
				showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat($F('cPremAmt').replace(/,/g, "")) >  9999999999.99){
				showMessageBox("Entered Premium Amount is invalid. Valid value is from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
				exists = true;
			} else if (parseFloat(sumTsiAmt) < -99999999999999.99) {
				if ($F("btnAddCoverage") != "Update"){
					showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Amount for this PAR. Total TSI Amount value must range from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
					exists = true;
				} else{
					if (parseFloat(sumTsiAmt2) < -99999999999999.99) {
						showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Amount for this PAR. Total TSI Amount value must range from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
						exists = true;
					}	
				}	
			} else if (parseFloat(sumTsiAmt) >  99999999999999.99){
				if ($F("btnAddCoverage") != "Update"){
					showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Amount for this PAR. Total TSI Amount value must range from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
					exists = true;
				} else{
					if (parseFloat(sumTsiAmt2) >  99999999999999.99){
						showMessageBox("Adding this TSI Amount will exceed the maximum Total TSI Amount for this PAR. Total TSI Amount value must range from -99,999,999,999,999.99 - 99,999,999,999,999.99.", imgMessage.ERROR);
						exists = true;
					}	
				}
			} else if (parseFloat(sumPremAmt) < -9999999999.99) {
				if ($F("btnAddCoverage") != "Update"){
					showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Amount for this PAR. Total Premium Amount value must range from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
					exists = true;
				} else{
					if (parseFloat(sumPremAmt2) < -9999999999.99) {
						showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Amount for this PAR. Total Premium Amount value must range from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
						exists = true;
					}	
				}	
			} else if (parseFloat(sumPremAmt) >  9999999999.99){
				if ($F("btnAddCoverage") != "Update"){
					showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Amount for this PAR. Total Premium Amount value must range from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
					exists = true;
				} else{
					if (parseFloat(sumPremAmt2) >  9999999999.99){
						showMessageBox("Adding this Premium Amount will exceed the maximum Total Premium Amount for this PAR. Total Premium Amount value must range from -9,999,999,999.99 - 9,999,999,999.99.", imgMessage.ERROR);
						exists = true;
					}	
				}
			}

			$$("div[name='cov']").each( function(a)	{
				if (a.getAttribute("perilCd") == cPerilCd && $F("btnAddCoverage") != "Update" && a.getAttribute("groupedItemNo") == cGroupedItemNo)	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
				}
			});

			hideNotice("");

			if (!exists)	{
				var content = '<input type="hidden" id="covParIds" 		    name="covParIds" 	        value="'+cParId+'" />'+
			 	  			  '<input type="hidden" id="covItemNos" 		name="covItemNos" 	    	value="'+cItemNo+'" />'+ 
							  '<input type="hidden" id="covPerilCds"       	name="covPerilCds"     		value="'+cPerilCd+'" />'+ 
						 	  '<input type="hidden" id="covPremRts"  	 	name="covPremRts"  	 		value="'+cPremRt+'" />'+  
						 	  '<input type="hidden" id="covTsiAmts" 	 	name="covTsiAmts" 			value="'+cTsiAmt+'" />'+ 
						 	  '<input type="hidden" id="covPremAmts" 		name="covPremAmts"  		value="'+cPremAmt+'" />'+ 
						 	  '<input type="hidden" id="covNoOfDayss" 		name="covNoOfDayss" 		value="'+cNoOfDays+'" />'+ 
						 	  '<input type="hidden" id="covBaseAmts"   		name="covBaseAmts"  	 	value="'+cBaseAmt+'" />'+
						 	  '<input type="hidden" id="covAggregateSws"  	name="covAggregateSws" 		value="'+cAggregateSw+'" />'+
						 	  '<input type="hidden" id="covAnnPremAmts"  	name="covAnnPremAmts" 		value="'+cAnnPremAmt+'" />'+
						 	  '<input type="hidden" id="covAnnTsiAmts"  	name="covAnnTsiAmts" 	 	value="'+cAnnTsiAmt+'" />'+
						 	  '<input type="hidden" id="covGroupedItemNos"  name="covGroupedItemNos" 	value="'+cGroupedItemNo+'" />'+
						 	  '<input type="hidden" id="covLineCds"  	 	name="covLineCds" 	 		value="'+cLineCd+'" />'+
						 	  '<input type="hidden" id="covRecFlags"  	 	name="covRecFlags" 	 		value="'+cRecFlag+'" />'+
						 	  '<input type="hidden" id="covRiCommRts"  	 	name="covRiCommRts" 	 	value="'+cRiCommRt+'" />'+
						 	  '<input type="hidden" id="covRiCommAmts"  	name="covRiCommAmts" 	 	value="'+cRiCommAmt+'" />'+
						 	  '<input type="hidden" id="covWcSws"  			name="covWcSws" 	 		value="'+cWcSw+'" />'+
						 	  '<input type="hidden" id="cPerilTypes"  		name="cPerilTypes" 	 		value="'+cPerilType+'" />'+
 
						 	  '<label style="text-align: left; width: 13%; margin-right: 6px;">'+(cEnrolleeName == "" ? "---" :cEnrolleeName.truncate(15, "..."))+'</label>'+
							  '<label style="text-align: left; width: 13%; margin-right: 6px;">'+(cPerilName == "" ? "---" :cPerilName.truncate(15, "..."))+'</label>'+ 
							  '<label style="text-align: right; width: 10%; margin-right: 5px;" class="moneyRate">'+(cPremRt == "" ? "---" :formatToNineDecimal(cPremRt))+'</label>'+ 
							  '<label style="text-align: right; width: 15%; margin-right: 5px;" class="money">'+(cTsiAmt == "" ? "---" :cTsiAmt.truncate(15, "..."))+'</label>'+
							  '<label style="text-align: right; width: 15%; margin-right: 5px;" class="money">'+(cPremAmt == "" ? "---" :cPremAmt.truncate(15, "..."))+'</label>'+
							  '<label style="text-align: right; width: 10%; margin-right: 5px;">'+(cNoOfDays == "" ? "---" :cNoOfDays.truncate(10, "..."))+'</label>'+
							  '<label style="text-align: right; width: 15%; margin-right: 5px;" class="money">'+(cBaseAmt == "" ? "---" :cBaseAmt.truncate(15, "..."))+'</label>'+
							  '<label style="text-align: center; width: 3%;">';
							  if (cAggregateSw == 'Y') {
									content += '<img name="checkedImg" class="printCheck" src="'+checkImgSrc+'" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 10px;" />';
								} else {
									content += '<span style="width: 3%; height: 10px; text-align: left; display: block; margin-left: 3px;"></span>';
								}
							  content += '</label>';		 
							  			   
				if ($F("btnAddCoverage") == "Update") {	
					origPerilCd = getSelectedRowAttrValue("cov","perilCd");
					$("rowCov"+cGroupedItemNo+origPerilCd).update(content);
					$("rowCov"+cGroupedItemNo+origPerilCd).setAttribute("groupedItemNo",cGroupedItemNo)
					$("rowCov"+cGroupedItemNo+origPerilCd).setAttribute("perilCd",cPerilCd);
					$("rowCov"+cGroupedItemNo+origPerilCd).setAttribute("id","rowCov"+cGroupedItemNo+cPerilCd);
					if (origPerilCd != $("cPerilCd").value){
						createDeleteCoverageItems(origPerilCd);
					}
				} else { 
					var newDiv = new Element('div');
					newDiv.setAttribute("name","cov");
					newDiv.setAttribute("id","rowCov"+cGroupedItemNo+cPerilCd);
					newDiv.setAttribute("item",cItemNo);
					newDiv.setAttribute("groupedItemNo",cGroupedItemNo); 
					newDiv.setAttribute("perilCd",cPerilCd); 
					newDiv.addClassName("tableRow");
  
					newDiv.update(content);
					$('coverageListing').insert({bottom: newDiv});					

					loadRowMouseOverMouseOutObserver(newDiv);
					
					newDiv.observe("click", function ()	{	
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{
							$$("div[name='cov']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});

							filterLOV("cPerilCd","cov",2,newDiv.down("input",2).value,"groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
							$("cPerilCd").value = newDiv.down("input",2).value;	
							$("cPremRt").value = formatToNineDecimal(newDiv.down("input",3).value);	
							$("cTsiAmt").value = formatCurrency(newDiv.down("input",4).value);	
							$("cPremAmt").value = formatCurrency(newDiv.down("input",5).value);	
							$("cNoOfDays").value = newDiv.down("input",6).value;	
							$("cBaseAmt").value = (newDiv.down("input",7).value == "" ? "" :formatCurrency(newDiv.down("input",7).value));	
							var cAggregateSw = newDiv.down("input",8).value;	
							if(cAggregateSw == 'Y'){
								$("cAggregateSw").checked = true;
							} else {
								$("cAggregateSw").checked = false;
							}
							$("cAnnPremAmt").value = newDiv.down("input",9).value;	
							$("cAnnTsiAmt").value = newDiv.down("input",10).value;	
							$("cGroupedItemNo").value = newDiv.down("input",11).value;	
							$("cLineCd").value = newDiv.down("input",12).value;	
							$("cRecFlag").value = newDiv.down("input",13).value;	
							$("cRiCommRt").value = newDiv.down("input",14).value;	
							$("cRiCommAmt").value = newDiv.down("input",15).value;
							$("cWcSw").value = newDiv.down("input",16).value;		
							$("cPerilType").value = newDiv.down("input",17).value;	
							
							getDefaults();
						} else {
							clearForm();
						} 
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditionalModal("coverageTable","coverageListing","cov","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
						}
					});
					//updateTempBeneficiaryItemNos();
					$("tempSave").value = "Y";
				}
				clearForm();
				computeTotal();
				$("tempSave").value = "Y";
			}
		} catch (e)	{
			showErrorMessage("addCoverage", e);
		}
	}

	$("btnDeleteCoverage").observe("click", function() {
		$("popBenDiv").hide();
		deleteCoverage();
	}); 

	function deleteCoverage(){
		$$("div[name='cov']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{
						var groupedItemNo	= getSelectedRowAttrValue("grpItem","groupedItemNo");
						var perilCd	= getSelectedRowAttrValue("cov","perilCd");
						var listingDiv 	    = $("coverageListing");
						var newDiv 		    = new Element("div");
						newDiv.setAttribute("id", "row"+groupedItemNo+perilCd); 
						newDiv.setAttribute("name", "rowDelete"); 
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display : none");
						newDiv.update(										
							'<input type="hidden" name="delCoverageGroupedItemNos" 	value="'+groupedItemNo+'" />' +
							'<input type="hidden" name="delCoveragePerilCds" 	value="'+perilCd+'" />');
						listingDiv.insert({bottom : newDiv});
						//updateTempGroupItemsItemNos();
						$("tempSave").value = "Y";
						acc.remove();
						clearForm();
						computeTotal();
						checkTableItemInfoAdditionalModal("coverageTable","coverageListing","cov","groupedItemNo",groupedItemNo);
						//belle 05052011
						hideAllGroupedItemPerilOptions();
						selectGroupedItemPerilOptionsToShow(); 
						hideExistingGroupedItemPerilOptions(); 
					} 
				});
			}
		});
	}	

	function createDeleteCoverageItems(origPerilCd){
		$$("div[name='cov']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				var groupedItemNo	= getSelectedRowAttrValue("grpItem","groupedItemNo");
				var perilCd	= origPerilCd
				var listingDiv 	    = $("coverageListing");
				var newDiv 		    = new Element("div");
				newDiv.setAttribute("id", "row"+groupedItemNo+perilCd); 
				newDiv.setAttribute("name", "rowDelete"); 
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display : none");
				newDiv.update(										
					'<input type="hidden" name="delCoverageGroupedItemNos" 	value="'+groupedItemNo+'" />' +
					'<input type="hidden" name="delCoveragePerilCds" 	value="'+perilCd+'" />');
				listingDiv.insert({bottom : newDiv});
				//updateTempGroupItemsItemNos();
				$("tempSave").value = "Y";
				clearForm();
				computeTotal();
				checkTableItemInfoAdditionalModal("coverageTable","coverageListing","cov","groupedItemNo",groupedItemNo);
			} 
		});
	}	
	
	function getDefaults()	{
		$("btnAddCoverage").value = "Update";
		enableButton("btnDeleteCoverage"); 
	}  

	function clearForm()	{
		filterLOV("cPerilCd","cov",2,"","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
		$("cPerilCd").selectedIndex = 0;
		$("cPremRt").value = formatToNineDecimal(0);	
		$("cTsiAmt").value = "";	
		$("cPremAmt").value = "";	
		$("cNoOfDays").value = "";	
		$("cBaseAmt").value = "";	
		$("cAggregateSw").checked = true;
		$("cAnnPremAmt").value = "";	
		$("cAnnTsiAmt").value = "";	
		$("cGroupedItemNo").value = "";	
		$("cLineCd").value = "";	
		$("cRecFlag").value = "";	
		$("cRiCommRt").value = "";	
		$("cRiCommAmt").value = "";	
		$("cWcSw").value = "";	
		$("cPerilType").value = "";	
		
		$("btnAddCoverage").value = "Add";
		disableButton("btnDeleteCoverage");
		deselectRows("coverageTable","cov");
		checkTableItemInfoAdditionalModal("coverageTable","coverageListing","cov","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	}

	$$("div[name='cov']").each(function(newDiv){
		no = newDiv.getAttribute("groupedItemNo");
		perilCd = newDiv.getAttribute("perilCd");
		newDiv.setAttribute("groupedItemNo",formatNumberDigits(no,7)); 
		newDiv.setAttribute("id","rowCov"+formatNumberDigits(no,7)+perilCd);
	});

	function computeTotal(){
		var tsiAmtTotal = 0;
		var premAmtTotal = 0;
		$$("div[name='cov']").each(function(row){
			if (row.getAttribute("groupedItemNo") == getSelectedRowAttrValue("grpItem","groupedItemNo")){
				if(row.down("input", 17).value == "B"){
					tsiAmtTotal = parseFloat(tsiAmtTotal) + parseFloat(row.down("input",4).value.replace(/,/g, ""));
					premAmtTotal = parseFloat(premAmtTotal) + parseFloat(row.down("input",5).value.replace(/,/g, ""));
				}				
			}
		});	

		$("amountCovered").value = formatCurrency(tsiAmtTotal);
		$("annTsiAmt").value = formatCurrency(tsiAmtTotal);
		$("annPremAmt").value = formatCurrency(premAmtTotal);
		$("tsiAmt").value = formatCurrency(tsiAmtTotal);
		$("premAmt").value = formatCurrency(premAmtTotal);

		$$("div[name='grpItem']").each(function(grp){
			if (grp.getAttribute("groupedItemNo") == getSelectedRowAttrValue("grpItem","groupedItemNo")){
				grp.down("input",19).value = formatCurrency(tsiAmtTotal);
				grp.down("input",25).value = formatCurrency(tsiAmtTotal);
				grp.down("input",26).value = formatCurrency(premAmtTotal);
				grp.down("input",27).value = formatCurrency(tsiAmtTotal);
				grp.down("input",28).value = formatCurrency(premAmtTotal);
				grp.down("label",7).update(formatCurrency(tsiAmtTotal).truncate(10, "..."));
				grp.down("label",8).update(formatCurrency(premAmtTotal).truncate(10, "..."));
			}	
		});	
	}		

	filterLOV("cPerilCd","cov",2,"","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
	disableButton("btnDeleteCoverage");
	checkTableItemInfoAdditionalModal("coverageTable","coverageListing","cov","groupedItemNo",getSelectedRowAttrValue("grpItem","groupedItemNo"));
</script>
	