<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="coverageInfoDiv" class="sectionDiv" style="display: block; width:872px; background-color:white; ">
	<table align="center" border="0">
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
	</table>
	<div id="grpItemsCoverageTable" name="grpItemsCoverageTable" style="width : 100%;">
		<div id="grpItemsCoverageTableGridSectionDiv" class="">
			<div id="grpItemsCoverageTableGridDiv" style="padding: 10px;">
				<div id="grpItemsCoverageTableGrid" style="height: 0px; width: 872px;"></div>
			</div>
		</div>	
	</div>
	<table align="center" border="0">
		<tr>
			<td class="rightAligned" >Peril Name </td>
			<td class="leftAligned" >
				<div style="float: left; border: solid 1px gray; width: 220px; height: 21px; margin-right: 3px;" class="required">
					<input type="hidden" id="cPerilCd" name="cPerilCd" />
					<input tabindex="11003" type="text" tabindex="6002" style="float: left; margin-top: 0px; margin-right: 3px; width: 192px; border: none;" name="cPerilName" id="cPerilName" readonly="readonly" class="required" />
					<img id="hrefCPeril" alt="goCPeril" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div>				
			</td>
			<td class="rightAligned" style="width:105px;" for="cPremRt">Peril Rate </td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="11004" id="cPremRt" name="cPremRt" type="text" style="width: 215px;" value="" maxlength="13" class="required moneyRate2" max="100" min="0" errorMsg="Entered Peril Rate is invalid. Valid value is from 0.000000000 to 100.000000000."/>
				 -->
				<input tabindex="11004" id="cPremRt" name="cPremRt" type="text" style="width: 215px;" value="" maxlength="13" class="required applyDecimalRegExp" regExpPatt="pDeci0309" max="100.000000000" min="0.000000000" hasOwnBlur="Y" hasOwnChange="Y" />
			</td>
		</tr>
		<tr>
			<td class="rightAligned" for="cTsiAmt">TSI Amt. </td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="11004" id="cTsiAmt" name="cTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required money2" max="99999999999999.99" min="0" errorMsg="Entered TSI Amount is invalid. Valid value is from 0.00 to 99,999,999,999,999.99." />
				 -->
				<input tabindex="11004" id="cTsiAmt" name="cTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required applyDecimalRegExp" regExpPatt="pDeci1402" max="99999999999999.99" min="0.00" hasOwnBlur="Y" hasOwnChange="Y" customLabel="TSI Amt"/>
			</td>
			<td class="rightAligned" for="cPremAmt">Premium Amt. </td>
			<td class="leftAligned" >
				<!-- 
				<input tabindex="11005" id="cPremAmt" name="cPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required money2" max="9999999999.99" min="0" errorMsg="Entered Premium Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99."/>
				 -->
				<input tabindex="11005" id="cPremAmt" name="cPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required applyDecimalRegExp" regExpPatt="pDeci1002" max="9999999999.99" min="0.00" hasOwnBlur="Y" hasOwnChange="Y" customLabel="Premium Amt"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" for="cNoOfDays">No. of Days </td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="11006" id="cNoOfDays" name="cNoOfDays" type="text" style="width: 215px;" value="" maxlength="5" class="integerUnformattedOnBlur" min="0" max="99999" errorMsg="Entered No. of Days is invalid. Valid value is from 0 to 99,999"/>
				 -->
				<input tabindex="11006" id="cNoOfDays" name="cNoOfDays" type="text" style="width: 215px;" value="" maxlength="5" class="applyWholeNosRegExp" regExpPatt="pDigit05" min="0" max="99999" hasOwnBlur="Y" hasOwnChange="Y" />
			</td>
			<td class="rightAligned" for="cBaseAmt">Base Amount </td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="11007" id="cBaseAmt" name="cBaseAmt" type="text" style="width: 215px;" value=""  maxlength="18" class="money2" max="99999999999999.99" min="0" errorMsg="Entered Base Amount is invalid. Valid value is from 0.00 to 99,999,999,999,999.99." />
				 -->
				<input tabindex="11007" id="cBaseAmt" name="cBaseAmt" type="text" style="width: 215px;" value=""  maxlength="18" class="applyDecimalRegExp" regExpPatt="pDeci1402" max="99999999999999.99" min="0" hasOwnBlur="Y" hasOwnChange="Y" />
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="leftAligned" colspan="3" ><input tabindex="11008" type="checkbox" id="cAggregateSw" name="cAggregateSw" checked="checked" disabled="disabled"/><font class="rightAligned"> Aggregate</font></td>
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
				<input id="cBascPerlCd"		name="cBascPerlCd"		type="hidden" value="" />
				<input id="cBasicPerilName"	name="cBasicPerilName"	type="hidden" value="" />
			</td>
		</tr>		
	</table>
	
	<table align="center" style="margin-bottom: 10px">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input tabindex="11009" type="button" class="button" 			id="btnCopyBenefits" 	name="btnCopyBenefits" 		value="Copy Benefits" 	style="width: 95px;" />
				<input tabindex="11010" type="button" class="button" 			id="btnAddCoverage"		name="btnAddCoverage" 		value="Add" 			style="width: 85px;" />
				<input tabindex="11011" type="button" class="disabledButton" 	id="btnDeleteCoverage"	name="btnDeleteCoverage" 	value="Delete" 			style="width: 85px;" />
			</td>
		</tr>
	</table> 
</div>
<script type="text/javascript">
try{
	var fromDateFromItem = "";
	var toDateFromItem = "";
	var packBenCdFromItem = "";
	var prorateFlagFromItem = "";
	var compSwFromItem = "";
	var shortRatePercentFromItem = "";

	
	
	function computeVals(elem, action){
		var baseAmt = $F("cBaseAmt").replace(/,/g, "");
		var noOfDays = removeLeadingZero($F("cNoOfDays").replace(/,/g, ""));
		
		if (parseFloat(baseAmt) >= 0.00 && parseFloat(noOfDays) >= 0){ // (parseFloat(baseAmt) >= 0.00 && noOfDays >= 0)
			if(elem == "cBaseAmt"){
				tsiAmtOrig = $F("cTsiAmt");	
			}
			$("cTsiAmt").value = formatCurrency(parseFloat(baseAmt) * parseInt(noOfDays));
		}
		//var year = serverDate.getFullYear();
		//var days = checkDuration2('01-01-'+year, '12-31-'+year); // checks if the year if a "leap year". This value holds the # of days of the current year and not the "year" (serverDate.getFullYear())
		var days =  $F("daysDuration");
		
		/* var noOfDays = getNoOfDaysInYear(year);
	 	var starDate = (fromDateFromItem == "" ? objGIPIWPolbas.inceptDate.split(" ")[0] :fromDateFromItem);
		var endDate = (toDateFromItem == "" ? objGIPIWPolbas.expiryDate.split(" ")[0] :toDateFromItem);  */ // irwin
		
		/******
			Applied changes based on the latest module - 3/23/2011 - irwin 
			- Fixed computations for all fields.
		******/
		var vNoOfDays = computeNoOfDays(nvl($F("itemFromDate"), $F("globalInceptDate")), nvl($F("itemToDate"),$F("globalExpiryDate"))); // came from item or policy values
		var vNoOfDaysGrp = computeNoOfDays($F("grpFromDate"), $F("grpToDate"));
		
	
		var prorateFlag = $F("itemProrateFlag"); //prorateFlagFromItem;
		var compSw = $F("itemCompSw");
		
		var premRt = (parseFloat($F("cPremRt") == "" ? "0.00" :$F("cPremRt"))/parseInt(100));
		var tsiAmt = parseFloat($F("cTsiAmt") == "" ? "0.00" :$F("cTsiAmt").replace(/,/g, ""));
		var premAmt = "";
		if ($F("cTsiAmt") != ""){
			
			if(prorateFlag == "1"){
				if(compSw == "M"){
					premAmt = ((premRt * tsiAmt) * ((nvl(vNoOfDaysGrp,vNoOfDays) - parseInt(1)) / days )) ;
				}else if(compSw == "Y"){
					premAmt = ((premRt * tsiAmt) * ((nvl(vNoOfDaysGrp,vNoOfDays) + parseInt(1)) / days )) ;
				}else{ // ordinary 
					premAmt = ((premRt * tsiAmt) * ((nvl(vNoOfDaysGrp,vNoOfDays) ) / days) );
				}
				//premAmt = addSeparatorToNumber(formatToNthDecimal(premAmt), ",");
			}else if(prorateFlag == "2"){ // straight
				premAmt = (premRt*tsiAmt);
			}else if(prorateFlag == "3"){ // short rate percent
				
				var shortRt = parseFloat($F("itemShortRtPercent")) / 100;
				premAmt =((premRt*tsiAmt)*shortRt);
			}else{
				premAmt = (premRt*tsiAmt);
			}
			
			if(compareAmounts(premAmt.toString().replace(/,/g, ""), $("cPremAmt").getAttribute("max").replace(/,/g, "")) == -1){
				showWaitingMessageBox("Computed premium amount exceeds the maximum value of 9,999,999,999.99.", imgMessage.INFO, function(){
					if(elem == "cTsiAmt"){
						$(elem).value =  tsiAmtOrig;	
					} else if(elem == "cPremRt"){
						$(elem).value =  premRtOrig;
					}else if(elem  == "cNoOfDays"){
						$(elem).value =  origCNoOfDays;
					}else if(elem == "cBaseAmt"){
						$("cTsiAmt").value = tsiAmtOrig;
						$(elem).value =  origCBaseAmt;
					}
					$(elem).focus();
				});
				return false;
			}else{					
				$("cPremAmt").value = roundNumber(premAmt,2);
			}
				
		}
		$("cAnnPremAmt").value = addSeparatorToNumber(formatToNthDecimal(roundNumber(premRt*tsiAmt,2), 2), ",");	//formatCurrency(premRt*tsiAmt); //added by steven 1/14/2013  "roundNumber"	
		$("cAnnTsiAmt").value = $F("cTsiAmt");
		
		// added for base amount computation 10.8.2012
		/* if(elem == "cBaseAmt"){
			if($F("baseAmt") != ""){
				if($F("baseAmt") )
			}
		} */
		
	
		$("cTsiAmt").value = formatCurrency($F("cTsiAmt"));
		$("cPremAmt").value = formatCurrency($F("cPremAmt"));
			
		$("cPremRt").value = formatToNthDecimal($F("cPremRt"),9);
		$("cNoOfDays").value = noOfDays;
		//$("cTsiAmt").setAttribute("lastValidValue", $F("cTsiAmt")); // removed, causing negative values to retain even after the error - irwin
		$("cPremAmt").setAttribute("lastValidValue", $F("cPremAmt"));
		$("cPremRt").setAttribute("lastValidValue", $F("cPremRt"));

		if ($F("cPerilCd") == ""){
			$("cPremAmt").value = "";
			$("cAnnPremAmt").value = "";
			$("cAnnTsiAmt").value = "";
			$("cNoOfDays").value = "";
			$("cBaseAmt").value = "";
		}
		computeCoverageTotalTsiAndPremAmt();
		
	}
	
	function onOkFunc(elem) {
		$("cBaseAmt").value = "";
	
		//var inceptDate = nvl(nvl($F("grpFromDate"), $F("itemFromDate")), $F("globalInceptDate"));
		//var expiryDate = nvl(nvl($F("grpToDate"), $F("itemToDate")), $F("globalExpiryDate"));
		//var noOfDaysPerilBlk = computeNoOfDays(inceptDate,expiryDate,""); // peril block no of days
		//$("cNoOfDays").value = noOfDaysPerilBlk;
		$("cNoOfDays").value = "";
		computeVals(elem);
		$("cWcSw").value = "Y";
	}	
	
	function onCancelFunc(elem) {
		computeVals(elem);
	}
	
	$("hrefCPeril").observe("click", function(){
		if($$("#accGroupedItemsTable .selectedRow").length > 0){
			var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
			var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : objUWGlobal.lineCd);
			var sublineCd = nvl($("sublineCd") != null ? $F("sublineCd") : null, (objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")));
			var perilType = ((tbgItmperlGrouped.bodyTable.down('tbody').childElements()).filter(function(row){ return row.style.display != "none"; })).length < 1 ? "B" : "";
			var notIn = "";

			notIn = createNotInParamInObj(objGIPIWItmperlGrouped, function(o){	return nvl(o.recordStatus, 0) != -1 && o.groupedItemNo == $F("groupedItemNo");	}, "perilCd");		
			
			showGroupedPerilLOV(parId, lineCd, sublineCd, notIn, perilType, function(){
				if(!($F("cPerilName").empty()) && $F("cWcSw") == "Y"){
					showConfirmBox("Message", "Peril has an attached warranties and clauses, would you like to use these as your default values on warranties and clauses?",  
							"Yes", "No", function(){	onOkFunc("cTsiAmt");}, function(){	onCancelFunc("cTsiAmt");}	);
				}
				
				$("cAggregateSw").checked = true;
				$("cAggregateSw").disabled = false;
				$("cRecFlag").value = "A"; //recFlag value must be "A" (Additional) for newly added perils. apollo cruz - sr#19914 09.22.2015
			});
		}else{
			showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.INFO);
			return false;
		}		
	});
	
	function validateCoveragePremRt(action){
		try{	
			
			
			if(compareAmounts($F("cPremRt").replace(/,/g, ""), $("cPremRt").getAttribute("min")) == 1){
				showWaitingMessageBox(getNumberFieldErrMsg($("cPremRt"), true), imgMessage.ERROR, function(){				
					$("cPremRt").value = $("cPremRt").getAttribute("lastValidValue");
					$("cPremRt").focus();						
				});
				return false;			
			}else if(compareAmounts($F('cPremRt').replace(/,/g, ""), $("cPremRt").getAttribute("max")) == -1){
				showWaitingMessageBox(getNumberFieldErrMsg($("cPremRt"), true), imgMessage.ERROR, function(){					
					$("cPremRt").value = $("cPremRt").getAttribute("lastValidValue");
					$("cPremRt").focus();	
				});
				return false;
			}else{
				computeVals("cPremRt", action);
			}
		}catch(e){
			showErrorMessage("validateCoveragePremRt", e);
		}
	}
	
	var premRtOrig = "";
	$("cPremRt").observe("focus", function() {
		if ($F("cPremRt") != ""){
			premRtOrig = $F("cPremRt");
		}
	});
	
	
	$("cPremRt").observe("blur", function(){ /* validateCoveragePremRt("blur"); */ 
		if(unformatNumber(premRtOrig) == unformatNumber($F("cPremRt"))){
			$("cPremRt").value = formatToNthDecimal($F("cPremRt"));
		}
	});	
	$("cPremRt").observe("change", function(){ validateCoveragePremRt("change"); });

	var tsiAmtOrig = "";
	$("cTsiAmt").observe("focus", function() {
		if ($F("cTsiAmt") != ""){
			tsiAmtOrig = $F("cTsiAmt");
			//this.setAttribute("lastValidValue",tsiAmtOrig);
		}
	});
	
	function validateCoverageTsiAmt(action){
		try{
			var objArrBasic = [];
			var objArrAllied = [];
			var maxBasic = 0;
			var maxAllied = 0;
			var maxBasicName = "";
			//var maxAlliedName = "";
			
			
			objArrBasic = objGIPIWItmperlGrouped.filter(function(o){
				return nvl(o.recordStatus, 0) != -1 && parseInt(o.groupedItemNo) == $F("groupedItemNo") && o.perilType == "B";
			});
			
			objArrAllied = objGIPIWItmperlGrouped.filter(function(o){
				return nvl(o.recordStatus, 0) != -1 && parseInt(o.groupedItemNo) == $F("groupedItemNo") && o.perilType == "A";
			});
			
			maxBasic = parseFloat(objArrBasic.max(function(o) {
				maxBasicName = o.perilName;
				return parseFloat((nvl(o.tsiAmt, "0")).toString().replace(/,/g, ""));
			}));
			
			maxAllied = parseFloat(objArrAllied.max(function(o) {
				maxAlliedName = o.perilName;
				return parseFloat((nvl(o.tsiAmt, "0")).toString().replace(/,/g, ""));
			}));
			
			if (parseFloat(maxBasic) != parseFloat(0)){			
				if ($F("cPerilType") == "A" && parseFloat($F("cTsiAmt").replace(/,/g, "")) > parseFloat(maxBasic)){
					customShowMessageBox('TSI Amount of this peril should be less than '+formatCurrency(maxBasic)+'.', imgMessage.ERROR, "cTsiAmt");				
					$("cTsiAmt").value = "";
					$("cPremAmt").value = "";
				} else if ($F("cPerilType") == "B" && parseFloat(maxBasic) < parseFloat(maxAllied)){
					customShowMessageBox("TSI amt of allied perils should be less than the maximum TSI amt of basic perils.", imgMessage.ERROR, "cTsiAmt");				
					$("cTsiAmt").value = "";
					$("cPremAmt").value = "";
				}else if($F("cPerilType") == "B" && parseFloat($F("cTsiAmt").replace(/,/g, "")) < parseFloat(maxAllied)){
					customShowMessageBox("TSI Amount must be greater than "+formatCurrency(maxAllied)+".", imgMessage.ERROR, "cTsiAmt");				
					$("cTsiAmt").value = "";
					$("cPremAmt").value = "";
				}		
			}
			
			if (parseFloat($F("cTsiAmt").replace(/,/g, "")) != parseFloat(tsiAmtOrig.replace(/,/g, "")) && tsiAmtOrig != "") {
				if ($F("cBaseAmt") != "" && $F("cNoOfDays") != ""){
					showConfirmBox("Message", "Changing TSI amount will delete base amount and set number of days to its default value, do you want to continue?",  
							"Yes", "No", function(){	onOkFunc("cTsiAmt");}, function(){	onCancelFunc("cTsiAmt");}	);
				} else{
					computeVals("cTsiAmt", action);
				}		
			} else{
				computeVals("cTsiAmt", action);
			}
		}catch(e){
			showErrorMessage("validateCoverageTsiAmt", e);
		}
	}
	
	$("cTsiAmt").observe("blur", function(){
		if(unformatNumber(tsiAmtOrig) == unformatNumber($F("cTsiAmt"))){
			$("cTsiAmt").value = formatCurrency($F("cTsiAmt"));
		}
	});
	$("cTsiAmt").observe("change", function(){ 
		
		if(!((this.value).empty()) ){
			if(isNaN(parseInt((this.value).replace(/,/g, "")))){
				this.value = "";
				customShowMessageBox(getNumberFieldErrMsg(this, true,"Y"), imgMessage.ERROR, this.id);
			}else{
				if(parseInt(this.value) < parseInt(this.getAttribute("min"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,"Y"), imgMessage.ERROR, function(){
						this.value = this.getAttribute("lastValidValue");
						this.focus();
					});
					return false;
				}else if(parseInt(this.value) > parseInt(this.getAttribute("max"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,"Y"), imgMessage.ERROR, function(){
						this.value = this.getAttribute("lastValidValue");
						this.focus();
					});
					return false;
				}else{
					var val = formatNumberByRegExpPattern(this);							
					this.value = val;							
					this.setAttribute("lastValidValue", this.value);
					validateCoverageTsiAmt("change");
				}
			}
		}		
		
			
	});
	
	
	
	function computePremRt(action){		
		//var year = serverDate.getFullYear();
		//var days = checkDuration('01-01-'+year, '12-31-'+year); // checks if the year if a "leap year". This value holds the # of days of the current year and not the "year" (serverDate.getFullYear())
		var days =  $F("daysDuration"); // irwin 10-8-2012
		
		// edited by irwin - 9.13.2012
	//	var starDate = nvl($F("itemFromDate"), $F("globalInceptDate"));
	//	var endDate = nvl($F("itemToDate"), $F("globalExpiryDate"));
		
		var itemNoOfDays = computeNoOfDays(nvl($F("itemFromDate"), $F("globalInceptDate")), nvl($F("itemToDate"),$F("globalExpiryDate"))); // came from item or policy values
		var grpbgNoOfDays = computeNoOfDays($F("grpFromDate"), $F("grpToDate"));
		
		
		var prorateFlag = $F("itemProrateFlag");	
		var cPremRt = null;
		if(unformatNumber(preCPremAmt) != unformatNumber($F("cPremAmt"))){
			var cPremAmt = nvl(unformatCurrencyValue($F("cPremAmt")),0);
			var cTsiAmt = nvl(unformatCurrencyValue($F("cTsiAmt")),0);
			var hundred = parseInt(100);
			if (prorateFlag == "1"){
				var compSw = $F("itemCompSw");
			
				if(compSw == "M"){
					cPremRt = (cPremAmt /( cTsiAmt * ((nvl(grpbgNoOfDays,itemNoOfDays) - 1) / days))) * hundred;
				}else if(compSw == "Y"){
					cPremRt = (cPremAmt /( cTsiAmt * ((nvl(grpbgNoOfDays,itemNoOfDays) + 1) / days))) * hundred;
				}else{
					cPremRt = (cPremAmt /( cTsiAmt * ((nvl(grpbgNoOfDays,itemNoOfDays)) / days))) * hundred;
				}
			} else if (prorateFlag == "2"){
				cPremRt = (nvl(unformatCurrencyValue($F("cPremAmt")),0)/(nvl(unformatCurrencyValue($F("cTsiAmt")),0)))* hundred; 
			} else if (prorateFlag == "3"){
				var shortRt = (parseFloat($F("itemShortRtPercent").replace(/,/g, ""))/hundred);
				cPremRt = (cPremAmt / hundred) / (cTsiAmt * shortRt) * parseInt(10000); 
			} else{			
				cPremRt =(nvl(unformatCurrencyValue($F("cPremAmt")),0)/(nvl(unformatCurrencyValue($F("cTsiAmt")),0)))* hundred;
			}
		}
		
		if(cPremRt > parseFloat(100.000000000)){
			showWaitingMessageBox(getNumberFieldErrMsg($("cPremRt"), true), imgMessage.ERROR, function(){					
				$("cPremAmt").value = $("cPremAmt").getAttribute("lastValidValue");
				$("cPremAmt").focus();	
			});
			return false;
		}
		$("cPremRt").value = formatToNineDecimal(roundNumber(cPremRt,9));
		
		computeVals("cPremAmt", action); // $("cPremAmt")
	}
	
	function computeCoveragePremAmt(action){
		try{
			if($F("cPremAmt") != "" && isAmountWithinRange($F("cPremAmt"), $("cPremAmt").getAttribute("min"), $("cPremAmt").getAttribute("max"))){
				if (parseFloat($F('cTsiAmt').replace(/,/g, "")) != parseFloat(tsiAmtOrig.replace(/,/g, "")) && tsiAmtOrig != "") {
					if ($F("cTsiAmt") != ""){
						computePremRt(action);
					}else{				
						computeVals("cPremAmt", action);				
					}
				} else{			
					if ($F("cTsiAmt") != ""){
						computePremRt(action);
					}else{				
						computeVals("cPremAmt", action);				
					}
				}	
			}
		}catch(e){
			showErrorMessage("computeCoveragePremAmt", e);
		}
	}
	var preCPremAmt = "";
	$("cPremAmt").observe("focus", function() {
		preCPremAmt = $F("cPremAmt");
	});	
	$("cPremAmt").observe("blur", function(){ 
		if(unformatCurrencyValue(preCPremAmt) == unformatCurrencyValue($F("cPremAmt"))){
			$("cPremAmt").value = formatCurrency($F("cPremAmt"));
		}
	}); 
	$("cPremAmt").observe("change", function(){ computeCoveragePremAmt("change"); });
	
	function validateCoverageBaseAmt(action){
		try{
			if(!($F("cBaseAmt").empty()) &&	isAmountWithinRange($F("cBaseAmt"), $("cBaseAmt").getAttribute("min"), $("cBaseAmt").getAttribute("max"))){			
				computeVals("cBaseAmt", action);
				$("cBaseAmt").value = formatCurrency($F("cBaseAmt"));
			}
		}catch(e){
			showErrorMessage("validateCoverageBaseAmt", e);
		}
	}
	var origCBaseAmt = "";
	$("cBaseAmt").observe("focus", function() {
		origCBaseAmt = $F("cBaseAmt");
	});	
	$("cBaseAmt").observe("blur", function(){
		if(unformatCurrencyValue(origCBaseAmt) == unformatCurrencyValue($F("cBaseAmt"))){
			$("cBaseAmt").value = formatCurrency($F("cBaseAmt"));
		}
	});
	$("cBaseAmt").observe("change", function(){ validateCoverageBaseAmt("change");	});
	
	function validateCoverageNoOfDays(action){
		try{
			if ($F("cNoOfDays") == ""){
				$("cBaseAmt").value = "";
			} else if ($F("cNoOfDays") == "0"){
				$("cBaseAmt").value = "0.00";
			}
			
			computeVals("cNoOfDays", action);
		}catch(e){
			showErrorMessage("validateCoverageNoOfDays", e);
		}
	}
	var origCNoOfDays = "";
	$("cNoOfDays").observe("focus", function() {
		origCNoOfDays = $F("cNoOfDays");
	});	
	//$("cNoOfDays").observe("blur", function(){ validateCoverageNoOfDays("blur"); });
	$("cNoOfDays").observe("change", function(){ validateCoverageNoOfDays("change"); });
	
	function addItmperlGrouped(){
		try{
			var newObj = setItmperlGroupedObj();
			objGIPIWGroupedItems.coverageUpdated = 1;
			
			if($F("btnAddCoverage") == "Update"){
				addModedObjByAttr(objGIPIWItmperlGrouped, newObj, "groupedItemNo perilCd");							
				tbgItmperlGrouped.updateVisibleRowOnly(newObj, tbgItmperlGrouped.getCurrentPosition()[1]);
			}else{
				addNewJSONObject(objGIPIWItmperlGrouped, newObj);
				tbgItmperlGrouped.addBottomRow(newObj);			
			}			
			
			setItmperlGroupedFormTG(null);
			($$("div#accCoverageInfo [changed=changed]")).invoke("removeAttribute", "changed");
			changeTag = 1;
		}catch(e){
			showErrorMessage("addItmperlGrouped", e);
		}
	}
	
	$("btnAddCoverage").observe("click", function(){
		if($$("#accGroupedItemsTable .selectedRow").length > 0){
			if($F("cPerilCd") == "" && $F("cPerilName") == ""){
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "cPerilName");
				return false;
			}else if($F("cPremRt") == ""){
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "cPremRt");
				return false;
			}else if($F("cTsiAmt") == ""){
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "cTsiAmt");
				return false;
			}else if($F("cPremAmt") == ""){
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "cPremAmt");
				return false;
			}else if($F("cBasicPerilName") != "" && (objGIPIWItmperlGrouped.filter(function(o){ return nvl(o.recordStatus, 0) != -1 
					&& o.groupedItemNo == $F("groupedItemNo") && o.perilCd == $F("cBascPerlCd"); }).length < 1)){				 
				showMessageBox($F("cBasicPerilName") + " should exists before this peril can be added.", imgMessage.ERROR);
				return false;
			}
			
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			
			addItmperlGrouped();
		}else{
			showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.INFO);
			return false;
		}		
	});
	
	function validateCoverageBeforeDelete(){
		try{
			
			if ("B" == $F("cPerilType")) {
				var basicExist = false;
				for (var i=0; i<objGIPIWItmperlGrouped.length; i++){
						if($F("groupedItemNo") == objGIPIWItmperlGrouped[i].groupedItemNo && $F("cPerilCd") == objGIPIWItmperlGrouped[i].bascPerlCd){
							basicExist = true;
							break;
						}
				}
				
				if(basicExist){				
					showMessageBox("The peril '"+objGIPIWItmperlGrouped[i].perilName+"' must be deleted first.", imgMessage.ERROR);
					return false;
				}
				
				var diffTsiAmt = parseFloat(unformatNumber($F("cTotalTsiAmt"))) - parseFloat(unformatNumber($F("cTsiAmt")));
				var totalTsiAmtAllied = 0;
				var tsiAmtAllied = new Array;
				var maxTsiAmtAllied = 0;			
				var maxAlliedName;
				
				for(var i=0; i<objGIPIWItmperlGrouped.length; i++){
					if ($F("groupedItemNo") == objGIPIWItmperlGrouped[i].groupedItemNo && "A" == objGIPIWItmperlGrouped[i].perilType && objGIPIWItmperlGrouped[i].recordStatus != -1) {
						tsiAmtAllied = parseFloat(objGIPIWItmperlGrouped[i].tsiAmt);
						totalTsiAmtAllied += tsiAmtAllied;
								
						if(maxTsiAmtAllied < tsiAmtAllied) {
							maxTsiAmtAllied = tsiAmtAllied;
							maxAlliedName = objGIPIWItmperlGrouped[i].perilName;
						}
					}
				}
				
				if ("B" == $F("cPerilType")){
					if (diffTsiAmt < totalTsiAmtAllied ) {				
						showMessageBox("The peril '"+maxAlliedName+"' must be deleted first.", imgMessage.ERROR);
						return false;
					}
				}
				
			}
			return true;
		}catch(e){
			showErrorMessage("validateCoverageBeforeDelete",e);
		}
	}
	
	$("btnDeleteCoverage").observe("click", function(){
		if (objUWParList.binderExist == "Y"){
			showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
			return false;
		}
		
		if(validateCoverageBeforeDelete()){
			objGIPIWGroupedItems.coverageUpdated = 1;
			var delObj = setItmperlGroupedObj();
			addDelObjByAttr(objGIPIWItmperlGrouped, delObj, "groupedItemNo perilCd");			
			tbgItmperlGrouped.deleteVisibleRowOnly(tbgItmperlGrouped.getCurrentPosition()[1]);
			setItmperlGroupedFormTG(null);
			updateTGPager(tbgItmperlGrouped);
			changeTag = 1;
		}
		
		
		//computeCoverageTotalTsiAndPremAmt();
	});
	
	$("btnCopyBenefits").observe("click", function(){
		if(hasPendingGroupedItemsChildRecords()){			
			showMessageBox("Please save changes first.", imgMessage.INFO);
			return false;
		}else{
			if($$("#accGroupedItemsTable .selectedRow").length > 0){
				showPopulateBenefits("Copy", $F("groupedItemNo"), "(" + $F("groupedItemNo") + ")", "N");
			}else{				
				showMessageBox("Please select an Enrollee in Grouped Items first.", imgMessage.INFO);
				return false;
			}				
		}		
	});
	
	setItmperlGroupedFormTG(null);
}catch(e){
	showErrorMessage("Accident Grouped Items Coverage Page", e);
}
</script>