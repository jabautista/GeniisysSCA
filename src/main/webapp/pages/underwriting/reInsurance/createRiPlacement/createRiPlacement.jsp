<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<jsp:include page="/pages/underwriting/reInsurance/menu.jsp"/>
<div id="createRiPlacementMainDiv">
	<form id="createRiPlacementForm" name="createRiPlacementForm">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">FRPS Details</label> 
				<span class="refreshers" style="margin-top: 0;">
				 	<label name="gro" style="margin-left: 5px;">Hide</label> 
				 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
				</span>
			</div>
		</div>
		<div id="frpsDetailsDiv" name="frpsDetailsDiv" class="sectionDiv" style="margin-top: 1px; padding-bottom: 10px;">
			<table style="margin: auto; margin-top: 10px; margin-bottom: 10px;" border="0">
				<tr>
					<td class="rightAligned" style="width: 140px;">FRPS No.</td>
					<td class="leftAligned"  style="width: 230px;"> 
						<div style="width: 206px; float: left;" class="withIconDiv">
							<input type="text" id="txtV100FrpsNo" name="txtV100FrpsNo" value="" style="width: 170px;" class="withIcon" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWFrpsRi" name="searchWFrpsRi" alt="Go" />
						</div>			
					</td>
					<td class="rightAligned" style="width: 140px;">Facultative TSI %</td>
					<td class="leftAligned"	 style="width: 230px;"> <input style="width: 200px; text-align: right;" type="text" id="txtV100TotFacSpct" name="txtV100TotFacSpct" value="" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Currency</td>
					<td class="leftAligned"> <input style="width: 200px;" type="text" id="txtV100CurrencyDesc" name="txtV100CurrencyDesc" value="" readonly="readonly" /></td>
					<td class="rightAligned">Facultative Premium %</td>
					<td class="leftAligned"> <input style="width: 200px; text-align: right;" type="text" id="txtV100TotFacSpct2" name="txtV100TotFacSpct2" value="" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Total Premium</td>
					<td class="leftAligned"> <input style="width: 200px; text-align: right;" type="text" id="txtV100PremAmt" name="txtV100PremAmt" value="" readonly="readonly" /></td>
					<td class="rightAligned">Facultative Premium</td>
					<td class="leftAligned"> <input style="width: 200px; text-align: right;" type="text" id="txtV100TotFacPrem" name="txtV100TotFacPrem" value="" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Total TSI</td>
					<td class="leftAligned"> <input style="width: 200px; text-align: right;" type="text" id="txtV100TsiAmt" name="txtV100TsiAmt" value="" readonly="readonly" /></td>
					<td class="rightAligned">Facultative TSI</td>
					<td class="leftAligned"> <input style="width: 200px; text-align: right;" type="text" id="txtV100TotFacTsi" name="txtV100TotFacTsi" value="" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">&nbsp;</td>
					<td class="leftAligned" colspan="3"><input disabled="disabled" style="float: left;" type="checkbox" id="chkV100DistByTsiPrem" name="chkV100DistByTsiPrem" value="Y"/> 
						<label style="float: left; margin-left: 5px;" for="chkV100DistByTsiPrem">Dist By TSI/Premium</label>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="outerDiv">
				<label id="">List of Reinsurers</label> 
				<span class="refreshers" style="margin-top: 0;">
				 	<label name="gro" style="margin-left: 5px;">Hide</label> 
				</span>
			</div>
		</div>
		<div id="reinsurersListingDiv" name="reinsurersListingDiv" class="sectionDiv" style="margin-top: 1px; padding-bottom: 10px;">
			<div id="reinsurersTableGrid" style="position: relative; height: 230px; margin: 10px;"> </div>
			<div style="width: 100%; margin-top: 10px;">
				<table style="margin: auto;" border="0">
					<tr>
						<td class="rightAligned" style="width: 140px;">Total TSI Share %</td>
						<td class="leftAligned"  style="width: 230px;"> <input id="sumRiShrPct" name="sumRiShrPct" type="text" readonly="readonly" style="text-align: right; width: 200px;" /></td>
						<td class="rightAligned" style="width: 140px;">Total Prem Share %</td>
						<td class="leftAligned"  style="width: 230px;"> <input id="sumRiShrPct2" name="sumRiShrPct2" type="text" readonly="readonly" style="text-align: right; width: 200px;" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Total TSI Amount</td>
						<td class="leftAligned"> <input id="sumRiTsiAmt" name="sumRiTsiAmt" type="text" readonly="readonly" style="text-align: right; width: 200px;" /></td>
						<td class="rightAligned">Total Prem Amount</td>
						<td class="leftAligned"> <input id="sumRiPremAmt" name="sumRiPremAmt" type="text" readonly="readonly" style="text-align: right; width: 200px;" /></td>
					</tr>
				</table>	
			</div>
		</div>
		<div class="sectionDiv" style="margin-top: 1px;">
			<table style="margin: auto; margin-bottom: 5px; margin-top: 5px;" border="0">
				<tr>
					<td class="rightAligned" >Reinsurer</td>
					<td class="leftAligned" > 
						<div style="width: 246px; float: left;" class="required withIconDiv">
							<input type="text" id="txtDspRiSname" name="txtDspRiSname" value="" style="width: 220px;" class="required withIcon allCaps" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtDspRiSnameIcon" name="txtDspRiSnameIcon" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>	
					<td class="rightAligned" >RI TSI Share %</td>
					<td class="leftAligned" > <input id="txtRiShrPct" name="txtRiShrPct" type="text" style="width: 240px;" class="required nthDecimal" nthDecimal="14" errorMsg="Field must be of form 990.99999999999999"/></td>
				</tr>
				<tr>	
					<td class="rightAligned" >RI TSI Amount</td>
					<td class="leftAligned" > <input id="txtRiTsiAmt" name="txtRiTsiAmt" type="text" style="width: 240px;" class="required money" errorMsg="Entered ri tsi amount is invalid. Valid value is from -999,999,999,999.99 to 999,999,999,999.99."/></td>
				</tr>
				<tr>	
					<td class="rightAligned" >RI Premium Share %</td>
					<td class="leftAligned" > <input id="txtRiShrPct2" name="txtRiShrPct2" type="text" style="width: 240px;" class="required nthDecimal" nthDecimal="9" errorMsg="Field must be of form 990.999999999"/></td>
				</tr>
				<tr>	
					<td class="rightAligned" >RI Premium Amount</td>
					<td class="leftAligned" > <input id="txtRiPremAmt" name="txtRiPremAmt" type="text" style="width: 240px;" class="required money"/ errorMsg="Entered ri premium amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99."></td>
				</tr>
				<tr>	
					<td class="rightAligned" >Premium Warranty Days</td>
					<!-- <td class="leftAligned" > <input id="txtPremWarrDays" name="sumRiShrPct2" type="text" style="width: 240px; text-align: right;" class="integerUnformattedNoComma" errorMsg="Entered premium warr days is invalid. Valid value is from -999 to 999." maxlength="3" readonly="readonly"/></td>  -->
					<td class="leftAligned" > <input id="txtPremWarrDays" name="sumRiShrPct2" type="text" style="width: 240px; text-align: right;" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered premium warr days is invalid. Valid value is from 0 to 999." maxlength="3" readonly="readonly"/></td>
				</tr>
				<tr>	
					<td class="rightAligned" ></td>
					<td class="leftAligned" ><input type="checkbox" id="chkPremWarrTag" name="chkPremWarrTag" value="" style="float: left;"/><label style="float: left; margin-left: 3px;" for="chkPremWarrTag">W/ Prem Warranty?</label></td>
				</tr>
				<tr>
					<td  colspan="2" align="center">
						<input type="button" id="btnAddRi" name="btnAddRi" class="button" value="Add" style="margin: auto; width: 80px; margin-top: 5px;"/>
						<input type="button" id="btnDeleteRi" name="btnDeleteRi" class="disabledButton" value="Delete" style="margin: auto; width: 80px; margin-top: 5px;"/>
					</td>	
				</tr>
			</table>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnPrevRi" name="btnPrevRi" class="button"	value="List of Previous RI" style="display: none; width: 140px;"/>
			<input type="button" id="btnCancel"	name="btnCancel" class="button"	value="Cancel" />
			<input type="button" id="btnSave" 	name="btnSave" 	 class="button"	value="Save" />			
		</div>
	</form>
</div>
<script type="text/javascript">
try{
	//Re-designed from tablegrid to usual manual adding/updating 01.19.2012 - Niknok as req by maam grace - pag may bugzszs pacheck nalang po baka di ko lang nabago yaiksz! ^_^ gudluck
	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	objUW.hidObjGIRIS001 = {};
	objUW.hidObjGIRIS001.viewJSON = JSON.parse('${viewJson}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIRIS001.viewJSON = objUW.hidObjGIRIS001.viewJSON.length>0 ? objUW.hidObjGIRIS001.viewJSON[0] :objUW.hidObjGIRIS001.viewJSON;
	objUW.hidObjGIRIS001.reinsurerTableGrid = JSON.parse('${reinsurerTableGrid}'.replace(/\\/g, '\\\\'));
	objUW.hidObjGIRIS001.reinsurer = objUW.hidObjGIRIS001.reinsurerTableGrid.rows || [];
	objUW.hidObjGIRIS001.selIndex = "";
	objUW.hidObjGIRIS001.selObj = null;
	objUW.hidObjGIRIS001.sumRiShrPct = 0;
	objUW.hidObjGIRIS001.sumRiTsiAmt = 0;
	objUW.hidObjGIRIS001.sumRiShrPct2 = 0;
	objUW.hidObjGIRIS001.sumRiPremAmt = 0;
	if (nvl(objUW.newObjGIRIS001,null) == null){ //create object for new record if not exists
		objUW.newObjGIRIS001 = {};
	}
	
	//Validate range for Premium warr days
	$("txtPremWarrDays").observe("blur", function(){
		if ($F("txtPremWarrDays") != "" && Number($F("txtPremWarrDays")) > 999){
			$("txtPremWarrDays").clear();
			customShowMessageBox($("txtPremWarrDays").getAttribute("errorMsg"), "E", "txtPremWarrDays");
			return false;
		}	
		if ($F("txtPremWarrDays") != "" && Number($F("txtPremWarrDays")) < -999){
			$("txtPremWarrDays").clear();
			customShowMessageBox($("txtPremWarrDays").getAttribute("errorMsg"), "E", "txtPremWarrDays");
			return false;
		}	
	});
	
	//Observe Prem Warr Tag
	$("chkPremWarrTag").observe("click", function(){
    	if (nvl($F("txtPremWarrDays"),null) != null) $("txtPremWarrDays").clear();
    	if ($("chkPremWarrTag").checked == true){
    		 $("txtPremWarrDays").addClassName("required");	
    		 $("txtPremWarrDays").readOnly = false;
    		 getWarrDays();
    	}else{
    		$("txtPremWarrDays").removeClassName("required");
    		$("txtPremWarrDays").readOnly = true;
    	}	
	});
	
	//Observe LOV on Reinsurer
	$("txtDspRiSnameIcon").observe("click", function(){
		showReinsurerLOV2(tableGrid.createNotInParam("riCd"), tableGrid);
	});
	
	//Observe RI TSI Share %
	initPreTextOnField("txtRiShrPct");
	$("txtRiShrPct").observe("change", function(){
		if(isNaN($F("txtRiShrPct"))){ // bonok :: 09.17.2012
			customShowMessageBox("Field must be of form 990.99999999999999.", "E", "txtRiShrPct");
			return false;
		}	
		if ($F("txtRiShrPct") != "" && Number($F("txtRiShrPct")) > 999.99999999999999){
			$("txtRiShrPct").clear();
			customShowMessageBox($("txtRiShrPct").getAttribute("errorMsg"), "E", "txtRiShrPct");
			return false;
		}	
		if ($F("txtRiShrPct") != "" && Number($F("txtRiShrPct")) < -999.99999999999999){
			$("txtRiShrPct").clear();
			customShowMessageBox($("txtRiShrPct").getAttribute("errorMsg"), "E", "txtRiShrPct");
			return false;
		}	
		
		//computeSumAmt(); // andrew - 1.3.2012
		var value = $F("txtRiShrPct");
		var button = $F("btnAddRi");
		var oldValue = 0;
		if (button == "Update"){
			oldValue = nvl(objUW.hidObjGIRIS001.selObj.riShrPct,0);	
		} 	
		
   		if (getPreTextValue("txtRiShrPct") != value){
   			//when-validate-item
			if (nvl(value,null) != null && value > 0){
				//varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct,0) - nvl(oldValue,0),14);
		        //var2Percent = roundNumber(nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0) - nvl(varPercent,0),14);
		        // bonok :: 06.25.2013 :: computed in java because the value computed in javascript is not precise
		        new Ajax.Request(contextPath+"/GIRIWFrpsRiController",{
					parameters:{
						action: "validateSharePercent",
						sumRiSHrPct: nvl(objUW.hidObjGIRIS001.sumRiShrPct,0),
						oldValue: oldValue,
						v100TotFacSpct: nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)
					},
					asynchronous: false,
					evalScripts: true,
					onComplete:function(response){
						var2Percent = formatToNthDecimal(response.responseText,14);
					}
		        });
		        
		        if (value > parseFloat(var2Percent)){
		        	$("txtRiShrPct").clear();
		          	customShowMessageBox('Share percent cannot be greater than '+formatToNthDecimal(var2Percent,14)+' %.', 'I',"txtRiShrPct");
		           	return false;
				}
			}else{
				if (nvl(value,0) < 0){
					$("txtRiShrPct").clear();
					customShowMessageBox('Valid share percent is required.', 'I', "txtRiShrPct");
					return false;
				}
			}

			//post-text-item
			computeRiPremAmt(value,$F("txtRiShrPct2"));
			if (nvl(value,null) == null){//COMPUTE_RI_TSI_AMT
				value = $F("txtRiShrPct2");
			}
			//tableGrid.setValueAt(value,tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
		 	//tableGrid.setValueAt(roundNumber((value/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2),tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
		 	$("txtRiShrPct").value = formatToNthDecimal(value,14);
		 	//$("txtRiTsiAmt").value = formatCurrency(roundNumber((value/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2));
		 	computeRiTsiAmt(value); // bonok :: 06.25.2013 :: computed in java because the value computed in javascript is not precise
		 	
   			//added by steven 10/11/2012 for pre-added values
   			var sumRiShrPctTemp = parseFloat($F("txtRiShrPct")) + parseFloat(objUW.hidObjGIRIS001.sumRiShrPct);
   			var sumRiTsiAmtTemp = unformatCurrencyValue($F("txtRiTsiAmt")) + parseFloat(objUW.hidObjGIRIS001.sumRiTsiAmt);
			var sumRiPremAmtTemp = unformatCurrencyValue($F("txtRiPremAmt")) + parseFloat(objUW.hidObjGIRIS001.sumRiPremAmt);
			var sumRiShrPct2Temp = parseFloat($F("txtRiShrPct2")) + parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2);
		 	
			if (sumRiShrPctTemp == nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiShrPct to: sumRiShrPctTemp 
				if (sumRiTsiAmtTemp  != nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiTsiAmt to: sumRiTsiAmtTemp
		          	var varTsi = nvl(sumRiTsiAmtTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0);
		            var var2Tsi = nvl(unformatCurrencyValue($F("txtRiTsiAmt"))/*tableGrid.getValueAt(tableGrid.getColumnIndex('riTsiAmt'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varTsi,0);
		            //tableGrid.setValueAt(roundNumber(var2Tsi,2), tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiTsiAmt").value = formatCurrency(roundNumber(var2Tsi,2));
				}

				if (nvl(sumRiPremAmtTemp,0) != nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiPremAmt to: sumRiPremAmtTemp
		            var varPrem = nvl(sumRiPremAmtTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0);
		            var var2Prem = nvl(unformatCurrencyValue($F("txtRiPremAmt"))/*tableGrid.getValueAt(tableGrid.getColumnIndex('riPremAmt'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPrem,0);
		            //tableGrid.setValueAt(roundNumber(var2Prem,2), tableGrid.getIndexOf('riPremAmt'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiPremAmt").value = formatCurrency(roundNumber(var2Prem,2));
		            computeRiPremVat1(var2Prem);
				}	

				if (nvl(sumRiShrPct2Temp,0)  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiShrPct2 to: sumRiShrPct2Temp
		            var varPercent = roundNumber(nvl(sumRiShrPct2Temp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0),9);
		            var var2Percent = roundNumber(nvl($F("txtRiShrPct2")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPercent,0),9);
		            //tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiShrPct2").value = formatToNthDecimal(var2Percent,9);
				}						
			}
				
			//computeSumAmt(); // andrew - 1.3.2012		
   		}	 
	});
	
	function computeRiTsiAmt(value){
		/* Commented out by reymon 04152014
		** Moved the computation to jsp from java
		new Ajax.Request(contextPath+"/GIRIWFrpsRiController",{
			parameters:{
				action: "computeRiTsiAmt",
				value: value,
				v100TotFacSpct: nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0),
				v100TotFacTsi: nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0)
			},
			asynchronous: false,
			evalScripts: true,
			onComplete:function(response){
				$("txtRiTsiAmt").value = formatCurrency(response.responseText);
			}
        });*/
        $("txtRiTsiAmt").value = formatCurrency((value/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0))*nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0));
	}
	
	//Observe RI TSI Amount
	initPreTextOnField("txtRiTsiAmt");
	$("txtRiTsiAmt").observe("blur", function(){
		if ($F("txtRiTsiAmt") != "" && Number($F("txtRiTsiAmt")) > 999999999999.99){
			$("txtRiTsiAmt").clear();
			customShowMessageBox($("txtRiTsiAmt").getAttribute("errorMsg"), "E", "txtRiTsiAmt");
			return false;
		}	
		if ($F("txtRiTsiAmt") != "" && Number($F("txtRiTsiAmt")) < -999999999999.99){
			$("txtRiTsiAmt").clear();
			customShowMessageBox($("txtRiTsiAmt").getAttribute("errorMsg"), "E", "txtRiTsiAmt");
			return false;
		}	
		
		//computeSumAmt(); // andrew - 1.3.2012
		var value = unformatCurrencyValue($F("txtRiTsiAmt"));
		var button = $F("btnAddRi");
		var oldValue = 0;
		if (button == "Update"){
			oldValue = nvl(objUW.hidObjGIRIS001.selObj.riTsiAmt,0);	
		} 	
			
		if (getPreTextValue("txtRiTsiAmt") != value){
			//when-validate-item
			if (nvl(value,null) != null && value > 0){
				varAmt = nvl(objUW.hidObjGIRIS001.sumRiTsiAmt,0) - nvl(oldValue,0);
		        var2Amt = roundNumber((nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0) - nvl(varAmt,0)),2);  //added by steven 10/11/2012 to round off
		        if (value > var2Amt){
		        	$("txtRiTsiAmt").clear();
					customShowMessageBox('TSI amount cannot be greater than '+formatCurrency(var2Amt)+'.', 'I', "txtRiTsiAmt");
		           	return false;
				}
			}else{
				if (nvl(value,0) < 0 && nvl(unformatCurrencyValue($F("txtV100TsiAmt")),0) > 0){
					$("txtRiTsiAmt").clear();
					customShowMessageBox('Valid TSI amt is required.', 'I', "txtRiTsiAmt");
					return false;
				}
			}

			//post-text-item
   			if (nvl(value,0) != 0){ //compute_ri_shr_pct1
       		    //tableGrid.setValueAt(roundNumber((nvl(value,0)/nvl(unformatCurrencyValue($F("txtV100TsiAmt")),0)) * 100,14), tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
   				$("txtRiShrPct").value = formatToNthDecimal(roundNumber((nvl(value,0)/nvl(unformatCurrencyValue($F("txtV100TsiAmt")),0)) * 100,14),14);
   			}else{
   				//tableGrid.setValueAt("0", tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
   				$("txtRiShrPct").value = formatToNthDecimal("0",14);
   			}
   			computeRiPremAmt($F("txtRiShrPct"),$F("txtRiShrPct2"));//tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex), tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex));
   			$("txtRiTsiAmt").value = formatCurrency(value);//tableGrid.setValueAt(value, tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true); 
   				
   			//added by steven 10/11/2012 for pre-added values
			var sumRiTsiAmtTemp = parseFloat(value) + parseFloat(objUW.hidObjGIRIS001.sumRiTsiAmt);
			var sumRiShrPctTemp = parseFloat($F("txtRiShrPct")) + parseFloat(objUW.hidObjGIRIS001.sumRiShrPct);
			var sumRiPremAmtTemp = unformatCurrencyValue($F("txtRiPremAmt")) + parseFloat(objUW.hidObjGIRIS001.sumRiPremAmt);
			var sumRiShrPct2Temp = parseFloat($F("txtRiShrPct2")) + parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2);
   			if (sumRiTsiAmtTemp == nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiTsiAmt to: sumRiTsiAmtTemp
   				if (sumRiShrPctTemp  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiShrPct to: sumRiShrPctTemp
		          	var varPercent = roundNumber(nvl(sumRiShrPctTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0),14);
		            var var2Percent = roundNumber(nvl($F("txtRiShrPct")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPercent,0),14);
		            //tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiShrPct").value = formatToNthDecimal(var2Percent,14);
				}
   				if (nvl(sumRiPremAmtTemp,0) != nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiPremAmt to: sumRiPremAmtTemp
   					var varPrem = nvl(sumRiPremAmtTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0);
		            var var2Prem = nvl(unformatCurrencyValue($F("txtRiPremAmt"))/*tableGrid.getValueAt(tableGrid.getColumnIndex('riPremAmt'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPrem,0);
		            //tableGrid.setValueAt(roundNumber(var2Prem,2), tableGrid.getIndexOf('riPremAmt'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiPremAmt").value = formatCurrency(roundNumber(var2Prem,2));
		            computeRiPremVat1(var2Prem);
				}

   				if (nvl(sumRiShrPct2Temp,0)  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiShrPct2 to: sumRiShrPct2Temp
		            var varPercent = roundNumber(nvl(sumRiShrPct2Temp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0),9);
		            var var2Percent = roundNumber(nvl($F("txtRiShrPct2")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPercent,0),9);
		            //tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiShrPct2").value = formatToNthDecimal(var2Percent,9);
				}	
   			}	
   			
   			//computeSumAmt(); // andrew - 1.3.2012	
		}	
	});	
	
	//Observe RI Premium Share %
	initPreTextOnField("txtRiShrPct2");
	$("txtRiShrPct2").observe("blur", function(){
		if ($F("txtRiShrPct2") != "" && Number($F("txtRiShrPct2")) > 999.999999999){
			$("txtRiShrPct2").clear();
			customShowMessageBox($("txtRiShrPct2").getAttribute("errorMsg"), "E", "txtRiShrPct2");
			return false;
		}	
		if ($F("txtRiShrPct2") != "" && Number($F("txtRiShrPct2")) < -999.999999999){
			$("txtRiShrPct2").clear();
			customShowMessageBox($("txtRiShrPct2").getAttribute("errorMsg"), "E", "txtRiShrPct2");
			return false;
		}	
		
		//computeSumAmt(); // andrew - 1.3.2012
		var value = unformatCurrencyValue($F("txtRiShrPct2"));
		var button = $F("btnAddRi");
		var oldValue = 0;
		if (button == "Update"){
			oldValue = nvl(objUW.hidObjGIRIS001.selObj.riShrPct2,0);	
		} 
		
		if (getPreTextValue("txtRiShrPct2") != value){
			//when-validate-item
			if (nvl(value,null) != null && value > 0){
				//varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0) - nvl(oldValue,0),14);
		        //var2Percent = roundNumber(nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0) - nvl(varPercent,0),14);
		        // bonok :: 06.25.2013 :: computed in java because the value computed in javascript is not precise
		        new Ajax.Request(contextPath+"/GIRIWFrpsRiController",{
					parameters:{
						action: "validateSharePercent",
						sumRiSHrPct: nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0),
						oldValue: oldValue,
						v100TotFacSpct: nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)
					},
					asynchronous: false,
					evalScripts: true,
					onComplete:function(response){
						var2Percent = formatToNthDecimal(response.responseText,9);
					}
		        });
		        
		        if (value > parseFloat(var2Percent)){
		        	$("txtRiShrPct2").clear();
					customShowMessageBox('Share percent cannot be greater than '+formatToNthDecimal(var2Percent,9)+' %.', 'I', "txtRiShrPct2");
		           	return false;
				}
			}else{
				if (nvl(value,0) < 0){
					$("txtRiShrPct2").clear();
					customShowMessageBox('Valid share percent is required.', 'I', "txtRiShrPct2");
					return false;
				}
			}

			//post-text-item
			computeRiPremAmt($F("txtRiShrPct")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)*/, value);
			if (nvl($F("txtRiShrPct")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)*/,null) == null){//COMPUTE_RI_TSI_AMT
				//tableGrid.setValueAt(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex),tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
				$("txtRiShrPct").value = formatToNthDecimal($F("txtRiShrPct2"),14);
			}
		 	//tableGrid.setValueAt(roundNumber((tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2),tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
   			$("txtRiTsiAmt").value = formatCurrency(roundNumber(($F("txtRiShrPct")/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2));
   			
   			//added by steven 10/11/2012 for pre-added values
   			var sumRiShrPct2Temp = parseFloat($F("txtRiShrPct2")) + parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2);
		 	var sumRiPremAmtTemp = unformatCurrencyValue($F("txtRiPremAmt")) + parseFloat(objUW.hidObjGIRIS001.sumRiPremAmt);
		 	var sumRiTsiAmtTemp = unformatCurrencyValue($F("txtRiTsiAmt")) + parseFloat(objUW.hidObjGIRIS001.sumRiTsiAmt);
		 	var sumRiShrPctTemp = parseFloat($F("txtRiShrPct")) + parseFloat(objUW.hidObjGIRIS001.sumRiShrPct);
			if (sumRiShrPct2Temp== nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)){ //added by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiShrPct2 to: sumRiShrPct2Temp
				if (nvl(sumRiPremAmtTemp,0) != nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0)){ //added by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiPremAmt to: sumRiPremAmtTemp
		            var varPrem = nvl(sumRiPremAmtTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0);
		            var var2Prem = nvl(unformatCurrencyValue($F("txtRiPremAmt"))/*tableGrid.getValueAt(tableGrid.getColumnIndex('riPremAmt'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPrem,0);
		            //tableGrid.setValueAt(roundNumber(var2Prem,2), tableGrid.getIndexOf('riPremAmt'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiPremAmt").value = formatCurrency(roundNumber(var2Prem,2));
		            computeRiPremVat1(var2Prem);
				}	 
				//added by steven 10/11/2012
				if (nvl(sumRiTsiAmtTemp,0) != nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiTsiAmt to: sumRiTsiAmtTemp
		            var varTsi = nvl(sumRiTsiAmtTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0);
		            var var2Tsi = nvl(unformatCurrencyValue($F("txtRiTsiAmt"))/*tableGrid.getValueAt(tableGrid.getColumnIndex('riTsiAmt'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varTsi,0);
		            //tableGrid.setValueAt(roundNumber(var2Tsi,2), tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiTsiAmt").value = formatCurrency(roundNumber(var2Tsi,2));
				}
   				if (nvl(sumRiShrPctTemp,0)  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiShrPct to: sumRiShrPctTemp
		            var varPercent = roundNumber(nvl(sumRiShrPctTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0),14);
		            var var2Percent = roundNumber(nvl($F("txtRiShrPct")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPercent,0),14);
		            //tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiShrPct").value = formatToNthDecimal(var2Percent,14);
				}	
			}
				
			//computeSumAmt(); // andrew - 1.3.2012
		}
	});	
	
	//Observe RI Premium Amount
	initPreTextOnField("txtRiPremAmt");
	$("txtRiPremAmt").observe("blur", function(){
		if ($F("txtRiPremAmt") != "" && Number($F("txtRiPremAmt")) > 9999999999.99){
			$("txtRiPremAmt").clear();
			customShowMessageBox($("txtRiPremAmt").getAttribute("errorMsg"), "E", "txtRiPremAmt");
			return false;
		}	
		if ($F("txtRiPremAmt") != "" && Number($F("txtRiPremAmt")) < -9999999999.99){
			$("txtRiPremAmt").clear();
			customShowMessageBox($("txtRiPremAmt").getAttribute("errorMsg"), "E", "txtRiPremAmt");
			return false;
		}
		
		//computeSumAmt(); // andrew - 1.3.2012
		var value = unformatCurrencyValue($F("txtRiPremAmt"));
		var button = $F("btnAddRi");
		var oldValue = 0;
		if (button == "Update"){
			oldValue = nvl(objUW.hidObjGIRIS001.selObj.riPremAmt,0);	
		} 
		if (getPreTextValue("txtRiPremAmt") != value){
			//when-validate-item
			if (nvl(value,null) != null && value > 0){
				varAmt = nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0) - nvl(oldValue,0);
		        var2Amt = roundNumber((nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0) - nvl(varAmt,0)),2); //added by steven 10/11/2012 to round-off
		        if (value > var2Amt){
		        	$("txtRiPremAmt").clear();
					customShowMessageBox('Premium amount cannot be greater than '+formatCurrency(var2Amt)+'.', 'I', "txtRiPremAmt");
		           	return false;
				}
			}else{
				if (nvl(value,0) < 0 && nvl(unformatCurrencyValue($F("txtV100PremAmt")),0) > 0){
					$("txtRiPremAmt").clear();
					customShowMessageBox('Valid Premium amt is required.', 'I', "txtRiPremAmt");
					return false;
				}
			}

			//post-text-item
   			if (nvl(value,0) != 0){ //compute_ri_shr_pct2
       		    //tableGrid.setValueAt(roundNumber((nvl(value,0)/nvl(unformatCurrencyValue($F("txtV100PremAmt")),0)) * 100,9), tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true);
       		 	$("txtRiShrPct2").value = formatToNthDecimal(roundNumber((nvl(value,0)/nvl(unformatCurrencyValue($F("txtV100PremAmt")),0)) * 100,9),9);
   			}else{
   				//tableGrid.setValueAt("0", tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true); 
   				$("txtRiShrPct2").value = formatToNthDecimal("0",9);
   			}
   			if (nvl($F("txtRiShrPct")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)*/,null) == null){//COMPUTE_RI_TSI_AMT
				//tableGrid.setValueAt(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex),tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
   				$("txtRiShrPct").value = formatToNthDecimal($F("txtRiShrPct2"),14);
			}
		 	//tableGrid.setValueAt(roundNumber((tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2),tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
   			//$("txtRiTsiAmt").value = formatCurrency(roundNumber((tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2));
		 	$("txtRiTsiAmt").value = formatCurrency(roundNumber((parseFloat($F("txtRiShrPct"))/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2));
		 	//added by steven 10/11/2012 for pre-added values
		 	var sumRiPremAmtTemp = parseFloat(value) + parseFloat(objUW.hidObjGIRIS001.sumRiPremAmt);
		 	var sumRiShrPct2Temp = parseFloat($F("txtRiShrPct2")) + parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2);
		 	var sumRiTsiAmtTemp = unformatCurrencyValue($F("txtRiTsiAmt")) + parseFloat(objUW.hidObjGIRIS001.sumRiTsiAmt);
		 	var sumRiShrPctTemp = parseFloat($F("txtRiShrPct")) + parseFloat(objUW.hidObjGIRIS001.sumRiShrPct);
		 	
   			if (sumRiPremAmtTemp == nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiPremAmt to: sumRiPremAmtTemp
   				if (sumRiShrPct2Temp  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiPremAmt to: sumRiShrPct2
		          	var varPercent = roundNumber(nvl(sumRiShrPct2Temp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0),9);
		            var var2Percent = roundNumber(nvl($F("txtRiShrPct2")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPercent,0),9);
		            //tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiShrPct2").value = formatToNthDecimal(var2Percent,9);
				}
   				if (nvl(sumRiTsiAmtTemp,0) != nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiTsiAmt to: sumRiTsiAmtTemp
		            var varTsi = nvl(sumRiTsiAmtTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0);
		            var var2Tsi = nvl(unformatCurrencyValue($F("txtRiTsiAmt"))/*tableGrid.getValueAt(tableGrid.getColumnIndex('riTsiAmt'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varTsi,0);
		            //tableGrid.setValueAt(roundNumber(var2Tsi,2), tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiTsiAmt").value = formatCurrency(roundNumber(var2Tsi,2));
				}
   				if (nvl(sumRiShrPctTemp,0)  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)){ //change by steven 10/11/2012 from: objUW.hidObjGIRIS001.sumRiShrPct to: sumRiShrPctTemp
		            var varPercent = roundNumber(nvl(sumRiShrPctTemp,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0),14);
		            var var2Percent = roundNumber(nvl($F("txtRiShrPct")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)*/,0) - nvl(varPercent,0),14);
		            //tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
		            $("txtRiShrPct").value = formatToNthDecimal(var2Percent,14);
				}	
   			}	
   			
   			//computeSumAmt(); // andrew - 1.3.2012	
		}	
	});
	
	function disableTagPerRow(obj){
		/*for (var a=0; a<tableGrid.rows.length; a++){
			var giriFrpsRiCtr = tableGrid.rows[a][tableGrid.getColumnIndex('giriFrpsRiCtr')];
			if (giriFrpsRiCtr == "0"){
				$("mtgInput"+tableGrid._mtgId+"_2,"+tableGrid.rows[a][tableGrid.getColumnIndex('divCtrId')]).enable();
			}else{
				$("mtgInput"+tableGrid._mtgId+"_2,"+tableGrid.rows[a][tableGrid.getColumnIndex('divCtrId')]).disable();
			}	
		}*/
		if (nvl(obj,null) == null){
			$("chkPremWarrTag").enable();
		}else{	
			if (obj.giriFrpsRiCtr == "0"){
				$("chkPremWarrTag").enable(); 
			}else{
				$("chkPremWarrTag").disable();
			}
		}
	}

	function newFormInst(){
		computeSumAmt();
		objUW.hidObjGIRIS001.computeSumAmt = computeSumAmt;
		changeTag = 0;
		initializeChangeTagBehavior(function(){tableGrid.saveGrid(false);});
	}

	function getWarrDays(){
		try {
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController",{
				parameters:{
					action: 	"getWarrDays",
					lineCd:		objRiFrps.lineCd,
					frpsYy: 	objRiFrps.frpsYy,
					frpsSeqNo: 	objRiFrps.frpsSeqNo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));	
					if (checkErrorOnResponse(response)){
						//nvl(res.premWarrDays,null) == null ? null :tableGrid.setValueAt(res.premWarrDays,tableGrid.getIndexOf('premWarrDays'), objUW.hidObjGIRIS001.selIndex, true);
						nvl(res.premWarrDays,null) == null ? null :$("txtPremWarrDays").value = res.premWarrDays;
					}	
				}	
			});	
		}catch(e){
			showErrorMessage("getWarrDays", e);
		}	
	}	
	function computeSumAmt(){
		var sumRiShrPct = 0;
		var sumRiTsiAmt = 0;
		var sumRiShrPct2 = 0;
		var sumRiPremAmt = 0;

		// andrew - 1.2.2012 - get the total amounts from values retrieved from database
		if(tableGrid.geniisysRows.length > 0){
			sumRiShrPct = tableGrid.geniisysRows[0].totalRiShrPct;
			sumRiTsiAmt = tableGrid.geniisysRows[0].totalRiTsiAmt;
			sumRiShrPct2 = tableGrid.geniisysRows[0].totalRiShrPct2;
			sumRiPremAmt = tableGrid.geniisysRows[0].totalRiPremAmt;	
		}
		
 		 var arr = tableGrid.getDeletedIds();

/* 		 for (var i=0; i< tableGrid.rows.length; i++){ // andrew - 1.2.2012 - replaced with the loop below
			var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
			if (arr.indexOf(divCtrId) == -1){
				var riShrPct = nvl(tableGrid.rows[i][tableGrid.getColumnIndex('riShrPct')],"") == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('riShrPct')];
				sumRiShrPct = parseFloat(sumRiShrPct) + parseFloat(riShrPct);

				var riTsiAmt = nvl(tableGrid.rows[i][tableGrid.getColumnIndex('riTsiAmt')],"") == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('riTsiAmt')];
				sumRiTsiAmt = parseFloat(sumRiTsiAmt) + parseFloat(riTsiAmt);

				var riShrPct2 = nvl(tableGrid.rows[i][tableGrid.getColumnIndex('riShrPct2')],"") == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('riShrPct2')];
				sumRiShrPct2 = parseFloat(sumRiShrPct2) + parseFloat(riShrPct2);
				
				var riPremAmt = nvl(tableGrid.rows[i][tableGrid.getColumnIndex('riPremAmt')],"") == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('riPremAmt')];
				sumRiPremAmt = parseFloat(sumRiPremAmt) + parseFloat(riPremAmt);
			}
		} */

/* 		for (var i=0; i< tableGrid.rows.length; i++){ // andrew 1.2.2012 -replacement
			var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];			
			if (arr.indexOf(divCtrId) != -1){
				var riShrPct = nvl(tableGrid.rows[i][tableGrid.getColumnIndex('riShrPct')],"") == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('riShrPct')];
				sumRiShrPct = parseFloat(sumRiShrPct) - parseFloat(riShrPct);

				var riTsiAmt = nvl(tableGrid.rows[i][tableGrid.getColumnIndex('riTsiAmt')],"") == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('riTsiAmt')];
				sumRiTsiAmt = parseFloat(sumRiTsiAmt) - parseFloat(riTsiAmt);

				var riShrPct2 = nvl(tableGrid.rows[i][tableGrid.getColumnIndex('riShrPct2')],"") == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('riShrPct2')];
				sumRiShrPct2 = parseFloat(sumRiShrPct2) - parseFloat(riShrPct2);
				
				var riPremAmt = nvl(tableGrid.rows[i][tableGrid.getColumnIndex('riPremAmt')],"") == "" ? 0 :tableGrid.rows[i][tableGrid.getColumnIndex('riPremAmt')];
				sumRiPremAmt = parseFloat(sumRiPremAmt) - parseFloat(riPremAmt);
			}
		}
		
		var newRowsAdded = tableGrid.getNewRowsAdded();
		for (var i=0; i<newRowsAdded.length; i++){
			if (newRowsAdded[i] != null){
				var riShrPct = nvl(newRowsAdded[i].riShrPct, 0);
				sumRiShrPct = parseFloat(sumRiShrPct) + parseFloat(riShrPct);

				var riTsiAmt = nvl(newRowsAdded[i].riTsiAmt, 0);
				sumRiTsiAmt = parseFloat(sumRiTsiAmt) + parseFloat(riTsiAmt);

				var riShrPct2 = nvl(newRowsAdded[i].riShrPct2, 0);
				sumRiShrPct2 = parseFloat(sumRiShrPct2) + parseFloat(riShrPct2);
				
				var riPremAmt = nvl(newRowsAdded[i].riPremAmt, 0);
				sumRiPremAmt = parseFloat(sumRiPremAmt) + parseFloat(riPremAmt);
			}
		} */

		objUW.hidObjGIRIS001.sumRiShrPct = sumRiShrPct;	
		objUW.hidObjGIRIS001.sumRiTsiAmt = sumRiTsiAmt;	
		objUW.hidObjGIRIS001.sumRiShrPct2 = sumRiShrPct2;	
		objUW.hidObjGIRIS001.sumRiPremAmt = sumRiPremAmt;	
		
		$("sumRiShrPct").value = formatToNthDecimal(sumRiShrPct,14);	
		$("sumRiTsiAmt").value = formatCurrency(sumRiTsiAmt);	
		$("sumRiShrPct2").value = formatToNthDecimal(sumRiShrPct2,9);	
		$("sumRiPremAmt").value = formatCurrency(sumRiPremAmt);
	}

	function prepareAdjustPremVatParams(){
		var objParameters = {};
		var riPremVat = 0;
		var riCd = "";
		if ($("btnAddRi").value == "Update"){
			riPremVat = objUW.hidObjGIRIS001.selObj.riPremVat;
			riCd = objUW.hidObjGIRIS001.selObj.riCd;
		}else{
			riPremVat = objUW.newObjGIRIS001.riPremVat;
			riCd = objUW.newObjGIRIS001.riCd;
		}
		objParameters.riPremVat = riPremVat; //tableGrid.getValueAt(tableGrid.getColumnIndex('riPremVat'), objUW.hidObjGIRIS001.selIndex);
		objParameters.riCd 		= riCd; //tableGrid.getValueAt(tableGrid.getColumnIndex('riCd'), objUW.hidObjGIRIS001.selIndex);
		objParameters.lineCd 	= objUW.hidObjGIRIS001.viewJSON.lineCd;
		objParameters.issCd 	= objUW.hidObjGIRIS001.viewJSON.issCd;
		objParameters.parYy 	= objUW.hidObjGIRIS001.viewJSON.parYy;
		objParameters.parSeqNo 	= objUW.hidObjGIRIS001.viewJSON.parSeqNo;
		objParameters.sublineCd = objUW.hidObjGIRIS001.viewJSON.sublineCd;
		objParameters.issueYy 	= objUW.hidObjGIRIS001.viewJSON.issueYy;
		objParameters.polSeqNo 	= objUW.hidObjGIRIS001.viewJSON.polSeqNo;
		objParameters.renewNo 	= objUW.hidObjGIRIS001.viewJSON.renewNo;
		return objParameters; 
	}	
	
	function computeRiPremAmt(riShrPct, riShrPct2){
		try{
			var objParameters = new Object();
			objParameters = prepareAdjustPremVatParams();
			objParameters.action = "computeRiPremAmt";
			objParameters.riShrPct = nvl(riShrPct, $F("txtRiShrPct")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)*/);
			objParameters.riShrPct2 =  nvl(riShrPct2,$F("txtRiShrPct2")/*tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex)*/);
			//objParameters.totFacSpct = unformatCurrencyValue($F("txtV100TotFacSpct")); // replaced by andrew 1.4.2012
			objParameters.totFacSpct2 = unformatCurrencyValue($F("txtV100TotFacSpct2"));
			objParameters.totFacPrem =	unformatCurrencyValue($F("txtV100TotFacPrem"));
			
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController",{
				parameters: objParameters,
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText);
						//tableGrid.setValueAt(res.riPremVat,tableGrid.getIndexOf('riPremVat'), objUW.hidObjGIRIS001.selIndex, true);
						//tableGrid.setValueAt(res.riShrPct2,tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true);
						//tableGrid.setValueAt(res.riPremAmt,tableGrid.getIndexOf('riPremAmt'), objUW.hidObjGIRIS001.selIndex, true);
						if ($("btnAddRi").value == "Update"){
							objUW.hidObjGIRIS001.selObj.riPremVat = res.riPremVat;
						}else{
							objUW.newObjGIRIS001.riPremVat = res.riPremVat;
						}
						$("txtRiShrPct2").value = formatToNthDecimal(res.riShrPct2,9);
						$("txtRiPremAmt").value = formatCurrency(res.riPremAmt);
					}
				}
			});	
		}catch(e){
			showErrorMessage("computeRiPremAmt", e);
		}		
	}	

	function computeRiPremVat1(var2Prem){
		try{
			var objParameters = new Object();
			objParameters = prepareAdjustPremVatParams();
			objParameters.action = "computeRiPremVat1";
			objParameters.var2Prem = var2Prem;
			
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController",{
				parameters: objParameters,
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText);
						//tableGrid.setValueAt(res.riPremVat,tableGrid.getIndexOf('riPremVat'), objUW.hidObjGIRIS001.selIndex, true);
						if ($("btnAddRi").value == "Update"){
							objUW.hidObjGIRIS001.selObj.riPremVat = res.riPremVat;
						}else{
							objUW.newObjGIRIS001.riPremVat = res.riPremVat;
						}
					}	
				}
			});	
		}catch(e){
			showErrorMessage("computeRiPremVat1", e);
		}		
	}

	function enableForm(params){
		try{
			if (params){
				/* comment by Niknok re-design
				tableGrid.columnModel[tableGrid.getColumnIndex('riSname')].editable = true;
				tableGrid.columnModel[tableGrid.getColumnIndex('riShrPct')].editable = true;
				tableGrid.columnModel[tableGrid.getColumnIndex('riShrPct2')].editable = true;
				tableGrid.columnModel[tableGrid.getColumnIndex('riPremAmt')].editable = true;
				tableGrid.columnModel[tableGrid.getColumnIndex('riTsiAmt')].editable = true;
				*/
				$("txtRiShrPct").readOnly = false;
				$("txtRiTsiAmt").readOnly = false;
				$("txtRiShrPct2").readOnly = false;
				$("txtRiPremAmt").readOnly = false;
				$("txtPremWarrDays").readOnly = false;
				enableSearch("txtDspRiSnameIcon");
			}else{
				/*
				tableGrid.columnModel[tableGrid.getColumnIndex('riSname')].editable = false;
				tableGrid.columnModel[tableGrid.getColumnIndex('riShrPct')].editable = false;
				tableGrid.columnModel[tableGrid.getColumnIndex('riShrPct2')].editable = false;
				tableGrid.columnModel[tableGrid.getColumnIndex('riPremAmt')].editable = false;
				tableGrid.columnModel[tableGrid.getColumnIndex('riTsiAmt')].editable = false;
				tableGrid.columnModel[tableGrid.getColumnIndex('premWarrDays')].editable = false;
				*/
				$("txtRiShrPct").readOnly = true;
				$("txtRiTsiAmt").readOnly = true;
				$("txtRiShrPct2").readOnly = true;
				$("txtRiPremAmt").readOnly = true;
				$("txtPremWarrDays").readOnly = true;
				disableSearch("txtDspRiSnameIcon");
			}
		}catch(e){
			showErrorMessage("enableForm", e);
		}
	}	

	function supplyCreateRi(obj){
		try{
			$("txtDspRiSname").value 	= nvl(obj,null) == null ? null :unescapeHTML2(obj.riSname);
			$("txtRiShrPct").value 		= nvl(obj,null) == null ? null :formatToNthDecimal(obj.riShrPct,14);
			$("txtRiTsiAmt").value 		= nvl(obj,null) == null ? null :formatCurrency(obj.riTsiAmt);
			$("txtRiShrPct2").value 	= nvl(obj,null) == null ? null :formatToNthDecimal(obj.riShrPct2,9);
			$("txtRiPremAmt").value 	= nvl(obj,null) == null ? null :formatCurrency(obj.riPremAmt);
			$("txtPremWarrDays").value 	= nvl(obj,null) == null ? null :obj.premWarrDays;
			$("chkPremWarrTag").checked = nvl(obj,null) == null ? false :(nvl(obj.premWarrTag,"N") == "Y" ? true :false);

			// andrew - 1.3.2012
			$("txtRiShrPct").writeAttribute("oldRiShrPct", nvl(obj,null) == null ? null : obj.riShrPct);
			$("txtRiTsiAmt").writeAttribute("oldRiTsiAmt", nvl(obj,null) == null ? null : obj.riTsiAmt);
			$("txtRiShrPct2").writeAttribute("oldRiShrPct2", nvl(obj,null) == null ? null : obj.riShrPct2);
			$("txtRiPremAmt").writeAttribute("oldRiPremAmt", nvl(obj,null) == null ? null : obj.riPremAmt);			
			// end andrew - 1.3.2012
			
			$("btnAddRi").value   		= nvl(obj,null) == null ? "Add" :"Update";
			(obj == null ? disableButton("btnDeleteRi") : enableButton("btnDeleteRi"));
			if (nvl(obj,null) != null) disableTagPerRow(obj);
			if ($("chkPremWarrTag").checked == true){
	    		 $("txtPremWarrDays").addClassName("required");	
	    	}else{
	    		$("txtPremWarrDays").removeClassName("required");
	    	}
			tableGrid.releaseKeys();
		}catch(e){
			showErrorMessage("supplyCreateRi", e);	
		}	
	}	
	
	var tableModel = {
		url: contextPath+"/GIRIWFrpsRiController?action=refreshCreateRiPlacement"+"&lineCd="+objRiFrps.lineCd+ "&frpsYy="+objRiFrps.frpsYy+"&frpsSeqNo="+objRiFrps.frpsSeqNo,
		options : {
			pager: { 
			},
			onCellFocus: function(element, value, x, y, id){
				enableForm(true);
				objUW.hidObjGIRIS001.selIndex = Number(y);
				objUW.hidObjGIRIS001.selObj = tableGrid.getRow(y);
				a//lert(objUW.hidObjGIRIS001.selObj.riCommAmt)
				//to disable Local Currency if Gen is not equal to variable.itemGenType else enable
				if (id=="premWarrDays" && nvl(value,"N")=="N"){
					//tableGrid.columnModel[tableGrid.getColumnIndex('premWarrDays')].editable = false;
					$("txtPremWarrDays").readOnly = true;
				}else{
					getWarrDays();
					//tableGrid.columnModel[tableGrid.getColumnIndex('premWarrDays')].editable = true;
					$("txtPremWarrDays").readOnly = false;
				}

				if (y>=0){	
					if (tableGrid.rows[y][tableGrid.getColumnIndex('giriFrpsRiCtr')]=="0"){
						enableForm(true);
					}else{
						enableForm(false);
					}			
				}else{
					if (y<0){
						if (tableGrid.newRowsAdded[Math.abs(y)-1] != null){
							if (nvl(tableGrid.newRowsAdded[Math.abs(y)-1][tableGrid.getColumnIndex('giriFrpsRiCtr')],"0")!="0"){
								enableForm(false);
							}else{
								enableForm(true);
							}	
						}else{
							enableForm(true);
						}	
					}	
				}		
				//computeSumAmt();
				observeChangeTagInTableGrid(tableGrid);
				supplyCreateRi(objUW.hidObjGIRIS001.selObj);
			},
			onCellBlur : function(element, value, x, y, id) {
				//computeSumAmt();
			},
			onRemoveRowFocus: function() {
				enableForm(true);
				objUW.hidObjGIRIS001.selIndex = "";
				objUW.hidObjGIRIS001.selObj = null;
				//computeSumAmt();
				supplyCreateRi(null);
			},
			toolbar: {
				elements: [/* MyTableGrid.DEL_BTN, */ MyTableGrid.FILTER_BTN],
				onAdd: function(){
					if (!checkRequiredPremWarrDays()) return false;
					if (((nvl(unformatCurrencyValue($F("txtV100TotFacSpct")), 0) <= nvl(objUW.hidObjGIRIS001.sumRiShrPct,0) 
					      && nvl(unformatCurrencyValue($F("txtV100TotFacSpct")), 0) != 0)
					      && (nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")), 0) <= nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0)
					      && nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")), 0) != 0)
					      && (nvl(unformatCurrencyValue($F("txtV100TotFacPrem")), 0) <=  nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0)
					      && nvl(unformatCurrencyValue($F("txtV100TotFacPrem")), 0) != 0))){
						showMessageBox('RI Placement cannot exceed the allowed share fac.percent', 'I');
					    return false;
					}
					computeSumAmt();
				},
				/* onDelete: function(){
					var ok = true;
					new Ajax.Request(contextPath+"/GIRIWFrpsRiController?action=checkDelRecRiPlacement",{
						method: "POST",
						parameters:{
							preBinderId: tableGrid.getValueAt(tableGrid.getColumnIndex('preBinderId'), objUW.hidObjGIRIS001.selIndex)
						},
						asynchronous: false,
						evalScripts: true,
						onComplete: function(response){
							if(checkErrorOnResponse(response)) {
								if (nvl(response.responseText,'0') != '0'){
									showMessageBox('The preliminary binder for this reinsurer has been generated.', "I");
									ok = false;
								}	
							}else{
								showMessageBox(response.responseText, "E");
								ok = false;
							}
						}	 
					});	
					return ok;
				},	
				postDelete: function(){
					computeSumAmt();
					clearAll();
				}, */
				onCancel: function(){
				},
				onSave: function(a){
					var ok = true;
					//computeSumAmt();
					//if (!checkRequiredPremWarrDays()) return false;
					//edited by d.alcantara, 07-02-2012
					if(nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0) == nvl(objUW.hidObjGIRIS001.sumRiShrPct,0) && 
							nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0) < nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)) {
						ok = false;
						showMessageBox("Cannot save if only one of the share percentage is fully consumed.");
						return false;
					} else if (nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0) == nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0) &&
							nvl(objUW.hidObjGIRIS001.sumRiShrPct,0) < nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) {
						ok = false;
						showMessageBox("Cannot save if only one of the share percentage is fully consumed.");
						return false;
					}else{
						
					 	var addedRows 	 	= tableGrid.getNewRowsAdded();
						var modifiedRows 	= tableGrid.getModifiedRows();
						var delRows  	 	= tableGrid.getDeletedRows();

						var objParameters = new Object();
						objParameters.delRows = delRows.concat(modifiedRows);
						objParameters.setRows = addedRows.concat(modifiedRows);
						objParameters.giriDistFrpsWdistFrpsV = prepareJsonAsParameter(objUW.hidObjGIRIS001.viewJSON);
						
						new Ajax.Request(contextPath+"/GIRIWFrpsRiController?action=saveRiPlacement",{
							method: "POST",
							parameters:{
								parameters: JSON.stringify(objParameters)
							},
							asynchronous: false,
							evalScripts: true,
							onCreate: function(){
								showNotice("Saving, please wait...");
							},
							onComplete: function(response){
								hideNotice("");
								if(checkErrorOnResponse(response)) {
									var res = JSON.parse(response.responseText);
									if (res.message == "SUCCESS"){
										showMessageBox(objCommonMessage.SUCCESS, "S");
										changeTag = 0;
										ok = true;
									}else{
										showMessageBox(res.message, "E");
										ok = false;
									}	
								}else{
									showMessageBox(response.responseText, "E");
									ok = false;
								}
							}	 
						});	
					}
					return ok;
				},
				postSave: function(){
					showCreateRiPlacementPage();
				}		
			},
			beforeSort : function(){
				if(changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			checkChanges: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailRequireSaving: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailValidation: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetail: function(){
				return (changeTag == 1 ? true : false);
			},
			masterDetailSaveFunc: function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailNoFunc: function(){
				return (changeTag == 1 ? true : false);
			}
		},
		columnModel : [
			{ 								// this column will only use for deletion
				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
			   	title: '&#160;D',
			   	altTitle: 'Delete?',
			   	titleAlign: 'center',
			   	width: 18,
			   	sortable: false,
			   	editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
			   	//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
			   	//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
			   //	editor: 'checkbox',
			   	hideSelectAllBox: true,
			   	visible: false
			},
			{
			   	id: 'divCtrId',
			   	width: '0',
			   	visible: false 
			},
			{
	            id: 'premWarrTag',
	            title: '&#160;P',
	            altTitle: 'W/ Prem Warranty?',
	            titleAlign: 'center',
	            width: 18,
	            maxlength: 1, 
	            sortable: false, 
			   	hideSelectAllBox: true,
			   	editor: new MyTableGrid.CellCheckbox({ 
		            getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";	
	            		}	
	            	}
			   	})	
	            /*
	            //selectAllFlg: true,
	            defaultValue: false,		//if editor has 'getValueOf' property it will get the default value from getValueOf condition, for newly added row
	            otherValue: false,		//for check box mapping of other values
	            editor: new MyTableGrid.CellCheckbox({
	            	//selectable: true,
		            getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";	
	            		}	
	            	},
	            	onClick: function(value, checked){
		            	var value = tableGrid.getValueAt(tableGrid.getColumnIndex('premWarrDays'), objUW.hidObjGIRIS001.selIndex);
		            	nvl(value,null) == null ? null :tableGrid.setValueAt("",tableGrid.getIndexOf('premWarrDays'), objUW.hidObjGIRIS001.selIndex, true);
	            	}
	            }) */
	        },
	        {
	            id: 'riSname',
	            title: 'Reinsurer',
	            titleAlign: 'center',
	            width: 150,
	            maxlength: 15,
	            editable: false,
	            filterOption: true
	            /*editor: new MyTableGrid.BrowseInput({
	            	onClick: function(){
	            		showReinsurerLOV2(tableGrid.createNotInParam("riCd"), tableGrid);
	            	},
	            	validate: function(input, value){
						return false;
					}	
	            })*/    
	        },
	        {
				id: 'riShrPct',
				title: 'RI TSI Share %',
				titleAlign: 'center',
				width: 130,
				maxlength: 19,
				editable: false,
				align: 'right',
				geniisysMinValue: '-999.99999999999999',
				geniisysMaxValue: '999.99999999999999',
				geniisysErrorMsg: 'Field must be of form 990.99999999999999',    
				editor: new MyTableGrid.CellInput({
	            	validate: function(value, input){
						computeSumAmt();
						if (input){
		            		if (getPreTextValue(input.id) != value){
		            			//when-validate-item
								if (nvl(value,null) != null && value > 0){
									varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct,0) - nvl(getPreTextValue(input.id),0),14);
							        var2Percent = roundNumber(nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0) - nvl(varPercent,0),14);
							        if (value > var2Percent){
							          	showMessageBox('Share percent cannot be greater than '+formatToNthDecimal(var2Percent,14)+' %.', 'I');
							           	return false;
									}
								}else{
									if (nvl(value,0) < 0){
										showMessageBox('Valid share percent is required.', 'I');
										return false;
									}
								}

								//post-text-item
								computeRiPremAmt(value,tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex));
								if (nvl(value,null) == null){//COMPUTE_RI_TSI_AMT
									value = tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex);
								}
								tableGrid.setValueAt(value,tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
							 	tableGrid.setValueAt(roundNumber((value/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2),tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);

								if (objUW.hidObjGIRIS001.sumRiShrPct == nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)){
									if (objUW.hidObjGIRIS001.sumRiTsiAmt  != nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0)){
							          	var varTsi = nvl(objUW.hidObjGIRIS001.sumRiTsiAmt,0) - nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0);
							            var var2Tsi = nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riTsiAmt'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varTsi,0);
							            tableGrid.setValueAt(roundNumber(var2Tsi,2), tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true); 
									}

									if (nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0) != nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0)){
							            var varPrem = nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0) - nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0);
							            var var2Prem = nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riPremAmt'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varPrem,0);
							            tableGrid.setValueAt(roundNumber(var2Prem,2), tableGrid.getIndexOf('riPremAmt'), objUW.hidObjGIRIS001.selIndex, true); 
							            computeRiPremVat1(var2Prem);
									}	

									if (nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0)  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)){
							            var varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0),9);
							            var var2Percent = roundNumber(nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varPercent,0),9);
							            tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true); 
									}						
								}
									
								computeSumAmt();		
		            		}	
	            		}
						return true;
	            	}
	            }),
	            geniisysClass: 'rate',
	            deciRate: 14,
	            filterOption: true,
	            filterOptionType: 'number' 		
			},
			{
	            id: 'riTsiAmt',
	            title: 'RI TSI Amount',
	            titleAlign: 'center',
	            type : 'number',
	            width : 133,
	            maxlength: 18,
	            geniisysClass : 'money',     //added geniisysClass properties by Jerome Orio
	            geniisysMinValue: '-999999999999.99',       //please use string for more accurate
	            geniisysMaxValue: '999,999,999,999.99',
	            geniisysErrorMsg: 'Entered ri tsi amount is invalid. Valid value is from -999,999,999,999.99 to 999,999,999,999.99.',    
	            editable: false,
	            editor: new MyTableGrid.CellInput({
	            	validate: function(value, input){
	            		computeSumAmt();
	            		if (input){
	            			if (getPreTextValue(input.id) != value){
	            				//when-validate-item
	            				if (nvl(value,null) != null && value > 0){
									varAmt = nvl(objUW.hidObjGIRIS001.sumRiTsiAmt,0) - nvl(getPreTextValue(input.id),0);
							        var2Amt = nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0) - nvl(varAmt,0);
							        if (value > var2Amt){
							          	showMessageBox('TSI amount cannot be greater than '+formatCurrency(var2Amt)+'.', 'I');
							           	return false;
									}
								}else{
									if (nvl(value,0) < 0 && nvl(unformatCurrencyValue($F("txtV100TsiAmt")),0) > 0){
										showMessageBox('Valid TSI amt is required.', 'I');
										return false;
									}
								}

	            				//post-text-item
		            			if (nvl(value,0) != 0){ //compute_ri_shr_pct1
			            		    tableGrid.setValueAt(roundNumber((nvl(value,0)/nvl(unformatCurrencyValue($F("txtV100TsiAmt")),0)) * 100,14), tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true); 
		            			}else{
		            				tableGrid.setValueAt("0", tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true); 
		            			}
		            			computeRiPremAmt(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex), tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex));
		            			tableGrid.setValueAt(value, tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true); 
		            				
		            			if (objUW.hidObjGIRIS001.sumRiTsiAmt == nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0)){
		            				if (objUW.hidObjGIRIS001.sumRiShrPct  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)){
							          	var varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0),14);
							            var var2Percent = roundNumber(nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varPercent,0),14);
							            tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true); 
									}

		            				if (nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0) != nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0)){
							            var varPrem = nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0) - nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0);
							            var var2Prem = nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riPremAmt'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varPrem,0);
							            tableGrid.setValueAt(roundNumber(var2Prem,2), tableGrid.getIndexOf('riPremAmt'), objUW.hidObjGIRIS001.selIndex, true); 
							            computeRiPremVat1(var2Prem);
									}

		            				if (nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0)  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)){
							            var varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0),9);
							            var var2Percent = roundNumber(nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varPercent,0),9);
							            tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true); 
									}	
		            			}	
		            			
		            			computeSumAmt();	
	            			}	
	            		}	
						return true;
	            	}
	            }),
	            filterOption: true,
	            filterOptionType: 'number'
	        },
	        {
				id: 'riShrPct2',
				title: 'RI Prem Share %',
				titleAlign: 'center',
				width: 130,
				editable: false,
				align: 'right',
				geniisysClass: 'rate',
	            filterOption: true,
	            filterOptionType: 'number',
	            editor: new MyTableGrid.CellInput({
	            	validate: function(value, input){
	            		computeSumAmt();
	            		if (input){
	            			if (getPreTextValue(input.id) != value){
	            				//when-validate-item
	            				if (nvl(value,null) != null && value > 0){
									varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0) - nvl(getPreTextValue(input.id),0),14);
							        var2Percent = roundNumber(nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0) - nvl(varPercent,0),14);
							        if (value > var2Percent){
							          	showMessageBox('Share percent cannot be greater than '+formatToNthDecimal(var2Percent,14)+' %.', 'I');
							           	return false;
									}
								}else{
									if (nvl(value,0) < 0){
										showMessageBox('Valid share percent is required.', 'I');
										return false;
									}
								}

	            				//post-text-item
								computeRiPremAmt(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex), value);
								if (nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex),null) == null){//COMPUTE_RI_TSI_AMT
									tableGrid.setValueAt(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex),tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
								}
							 	tableGrid.setValueAt(roundNumber((tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2),tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
		            			
								if (objUW.hidObjGIRIS001.sumRiShrPct2 == nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)){
									if (nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0) != nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0)){
							            var varPrem = nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0) - nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0);
							            var var2Prem = nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riPremAmt'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varPrem,0);
							            tableGrid.setValueAt(roundNumber(var2Prem,2), tableGrid.getIndexOf('riPremAmt'), objUW.hidObjGIRIS001.selIndex, true); 
							            computeRiPremVat1(var2Prem);
									}	
								}
									
								computeSumAmt();
	            			}
	            		}
	            	}
	            })			
			},
			{
	            id: 'riPremAmt',
	            title: 'RI Premium Amount',
	            titleAlign: 'center',
	            type : 'number',
	            width : 133,
	            maxlength: 16,
	            geniisysClass : 'money',     //added geniisysClass properties by Jerome Orio
	            geniisysMinValue: '-9999999999.99',       //please use string for more accurate
	            geniisysMaxValue: '9,999,999,999.99',
	            geniisysErrorMsg: 'Entered ri premium amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.',    
	            editable: true,
	            editor: new MyTableGrid.CellInput({
	            	validate: function(value, input){
            		computeSumAmt();
            		if (input){
            			if (getPreTextValue(input.id) != value){
            				//when-validate-item
            				if (nvl(value,null) != null && value > 0){
								varAmt = nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0) - nvl(getPreTextValue(input.id),0);
						        var2Amt = nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0) - nvl(varAmt,0); 
						        if (value > var2Amt){
						          	showMessageBox('Premium amount cannot be greater than '+formatCurrency(var2Amt)+'.', 'I');
						           	return false;
								}
							}else{
								if (nvl(value,0) < 0 && nvl(unformatCurrencyValue($F("txtV100PremAmt")),0) > 0){
									showMessageBox('Valid Premium amt is required.', 'I');
									return false;
								}
							}

            				//post-text-item
	            			if (nvl(value,0) != 0){ //compute_ri_shr_pct2
		            		    tableGrid.setValueAt(roundNumber((nvl(value,0)/nvl(unformatCurrencyValue($F("txtV100PremAmt")),0)) * 100,9), tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true); 
	            			}else{
	            				tableGrid.setValueAt("0", tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true); 
	            			}
	            			
	            			if (nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex),null) == null){//COMPUTE_RI_TSI_AMT
								tableGrid.setValueAt(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex),tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
							}
						 	tableGrid.setValueAt(roundNumber((tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex)/nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)) * nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0),2),tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
	            			
	            			if (objUW.hidObjGIRIS001.sumRiPremAmt == nvl(unformatCurrencyValue($F("txtV100TotFacPrem")),0)){
	            				if (objUW.hidObjGIRIS001.sumRiShrPct2  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0)){
						          	var varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")),0),9);
						            var var2Percent = roundNumber(nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varPercent,0),9);
						            tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true); 
								}

	            				if (nvl(objUW.hidObjGIRIS001.sumRiTsiAmt,0) != nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0)){
						            var varTsi = nvl(objUW.hidObjGIRIS001.sumRiTsiAmt,0) - nvl(unformatCurrencyValue($F("txtV100TotFacTsi")),0);
						            var var2Tsi = nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riTsiAmt'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varTsi,0);
						            tableGrid.setValueAt(roundNumber(var2Tsi,2), tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true); 
								}

	            				if (nvl(objUW.hidObjGIRIS001.sumRiShrPct,0)  != nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0)){
						            var varPercent = roundNumber(nvl(objUW.hidObjGIRIS001.sumRiShrPct,0) - nvl(unformatCurrencyValue($F("txtV100TotFacSpct")),0),14);
						            var var2Percent = roundNumber(nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex),0) - nvl(varPercent,0),14);
						            tableGrid.setValueAt(var2Percent, tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true); 
								}	
	            			}	
	            			
	            			computeSumAmt();	
            			}	
            		}	
					return true;
            	}
	            }),
	            filterOption: true,
	            filterOptionType: 'number'
	        },
	        {
	            id: 'premWarrDays', 
	            title: 'Prem Warr Days',
	            titleAlign: 'center',
	            type : 'number',
	            width: 105,
	            maxlength: 4,
	            editable: false,
	            geniisysClass: 'integerUnformattedNoComma',
	            geniisysMinValue: '-999',
	            geniisysMaxValue: '999',
	            geniisysErrorMsg: 'Entered prem warr days is invalid. Valid value is from -999 to 999.',
	            editor: new MyTableGrid.CellInput({
	            	/*validate: function(value, input){
						return true;
	            	}*/
	            }),
	            filterOption: true,
	            filterOptionType: 'integer'
	        },
	        {
				id: 'lineCd',
				width: '0',
				defaultValue: objUW.hidObjGIRIS001.viewJSON.lineCd,
				visible: false 	
			},
	        {
				id: 'frpsYy',
				width: '0',
				defaultValue: objUW.hidObjGIRIS001.viewJSON.frpsYy,
				visible: false 	
			},
	        {
				id: 'frpsSeqNo',
				width: '0',
				defaultValue: objUW.hidObjGIRIS001.viewJSON.frpsSeqNo,
				visible: false 	
			},
	        {
				id: 'riSeqNo',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riCd',
				width: '0',
				visible: false 	
			},
	        {
				id: 'origRiCd',
				width: '0',
				visible: false 	
			},
	        {
				id: 'preBinderId',
				width: '0',
				visible: false 	
			},
	        {
				id: 'annRiSAmt',
				width: '0',
				visible: false 	
			},
	        {
				id: 'annRiPct',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riCommAmt',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riCommRt',
				width: '0',
				visible: false 	
			},
	        {
				id: 'premTax',
				width: '0',
				visible: false 	
			},
	        {
				id: 'otherCharges',
				width: '0',
				visible: false 	
			},
	        {
				id: 'renewSw',
				width: '0',
				visible: false 	
			},
	        {
				id: 'reverseSw',
				width: '0',
				visible: false 	
			},
	        {
				id: 'facobligSw',
				width: '0',
				visible: false 	
			},
	        {
				id: 'bndrRemarks1',
				width: '0',
				visible: false 	
			}
			,
	        {
				id: 'bndrRemarks2',
				width: '0',
				visible: false 	
			}
			,
	        {
				id: 'bndrRemarks3',
				width: '0',
				visible: false 	
			},
	        {
				id: 'deleteSw',
				width: '0',
				visible: false 	
			},
	        {
				id: 'remarks',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riAsNo',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riAcceptBy',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riAcceptDate',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riPremVat',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riCommVat',
				width: '0',
				visible: false 	
			},
	        {
				id: 'address1',
				width: '0',
				visible: false 	
			},
	        {
				id: 'address2',
				width: '0',
				visible: false 	
			},
	        {
				id: 'address3',
				width: '0',
				visible: false 	
			},
	        {
				id: 'arcExtData',
				width: '0',
				visible: false 	
			},
	        {
				id: 'riName',
				width: '0',
				visible: false 	
			},
	        {
				id: 'giriFrpsRiCtr', //fnl_binder_id = pre_binder_id counter for enabling/disabling forms
				width: '0',
				visible: false,
				defaultValue: "0"
			},
	        {
				id: 'reusedBinder', // indicator if the binder was resused - irwin 11.18.2012
				width: '0',
				visible: false
			}
		],
		resetChangeTag: true,
		//requiredColumns: 'riSname riShrPct riShrPct2 riPremAmt riTsiAmt',
		rows : objUW.hidObjGIRIS001.reinsurer
	};

	tableGrid = new MyTableGrid(tableModel);
	tableGrid.pager = objUW.hidObjGIRIS001.reinsurerTableGrid;
	tableGrid.afterRender = newFormInst;
	tableGrid.render('reinsurersTableGrid'); 
	
	function supplyFrpsDetails(obj){
		try{
			$("txtV100FrpsNo").value 			= nvl(obj.lineCd, '') == '' ? null : obj.lineCd+"-"+formatNumberDigits(obj.frpsYy,2)+"-"+formatNumberDigits(obj.frpsSeqNo,8); // modified by Kris 07.07.2014 PHILFIRE 16244: used nvl function
			$("txtV100TotFacSpct").value 		= nvl(obj.totFacSpct,'') == '' ? null :formatToNthDecimal(obj.totFacSpct,14);
			$("txtV100CurrencyDesc").value 		= nvl(obj.currencyDesc, '');  // modified by Kris 07.07.2014 PHILFIRE 16244: used nvl function
			$("txtV100TotFacSpct2").value 		= nvl(obj.totFacSpct2,'') == '' ? null :formatToNthDecimal(obj.totFacSpct2,9);
			$("txtV100PremAmt").value 			= nvl(obj.premAmt,'') == '' ? null :formatCurrency(obj.premAmt);
			$("txtV100TotFacPrem").value 		= nvl(obj.totFacPrem,'') == '' ? null :formatCurrency(obj.totFacPrem);
			$("txtV100TsiAmt").value 			= nvl(obj.tsiAmt,'') == '' ? null :formatCurrency(obj.tsiAmt);
			$("txtV100TotFacTsi").value 		= nvl(obj.totFacTsi,'') == '' ? null :formatCurrency(obj.totFacTsi);
			$("chkV100DistByTsiPrem").checked 	= nvl(obj.distByTsiPrem,"N") == "Y" ? true :false;
			if (nvl(obj.riBtn,"N") == "Y"){
				enableButton("btnPrevRi"); 
				$("btnPrevRi").show();
			}else{
				disableButton("btnPrevRi"); 
				$("btnPrevRi").hide();
			}
		}catch(e){
			showErrorMessage("supplyFrpsDetails", e);
		}		
	}	

	supplyFrpsDetails(objUW.hidObjGIRIS001.viewJSON);	

	function checkRequiredPremWarrDays(){
		var arr = tableGrid.getDeletedIds();
		for (var i=0; i<tableGrid.rows.length; i++){
			var divCtrId = tableGrid.rows[i][tableGrid.getColumnIndex('divCtrId')];
			var days = tableGrid.rows[i][tableGrid.getColumnIndex('premWarrDays')];
			var tag	= tableGrid.rows[i][tableGrid.getColumnIndex('premWarrTag')];
			if (tag == "Y" && arr.indexOf(divCtrId) == -1){
				if (nvl(days,"") == ""){
					tableGrid.unselectRows();
					tableGrid.selectRow(divCtrId);
					showWaitingMessageBox("Prem warr days is required.", "E", function(){
						fireEvent($("mtgC"+tableGrid._mtgId+"_8,"+divCtrId), "click");
						});
					return false;
				}	
			}	
		}	
		return true;
	}

	$("btnPrevRi").observe("click", function(){
		//call modal 
		/* Modalbox.show(contextPath+"/GIRIWFrpsRiController?action=searchPreviousRiModal&ajaxModal=1&distNo=" + objUW.hidObjGIRIS001.viewJSON.distNo,  
				  {title: "List of Previous RI", 
				  width: 760,
				  asynchronous: false}); */
		
		//marco - GENQA 5256 - changed to overlay to prevent messages from appearing behind the modalbox
		previousRiListOverlay = Overlay.show(contextPath+"/GIRIWFrpsRiController", {
			urlParameters: {
				action: "searchPreviousRiModal",
				distNo: objUW.hidObjGIRIS001.viewJSON.distNo
			},
			urlContent : true,
			draggable: true,
		    title: "List of Previous RI",
		    height: 380,
		    width: 700
		});
	});
	
	function clearNewObj(clear){
		if (nvl(objUW.newObjGIRIS001,null) == null){
			objUW.newObjGIRIS001 = {};
		}
		objUW.newObjGIRIS001.riSname	  = clear == true ? null:objUW.newObjGIRIS001.riSname;
		objUW.newObjGIRIS001.riName		  = clear == true ? null:objUW.newObjGIRIS001.riName;
		objUW.newObjGIRIS001.riCd		  = clear == true ? null:objUW.newObjGIRIS001.riCd;
		objUW.newObjGIRIS001.billAddress1 = clear == true ? null:objUW.newObjGIRIS001.billAddress1;
		objUW.newObjGIRIS001.billAddress2 = clear == true ? null:objUW.newObjGIRIS001.billAddress2;
		objUW.newObjGIRIS001.billAddress3 = clear == true ? null:objUW.newObjGIRIS001.billAddress3;
		objUW.newObjGIRIS001.address1 	  = clear == true ? null:objUW.newObjGIRIS001.billAddress1;
		objUW.newObjGIRIS001.address2 	  = clear == true ? null:objUW.newObjGIRIS001.billAddress2;
		objUW.newObjGIRIS001.address3 	  = clear == true ? null:objUW.newObjGIRIS001.billAddress3;
		objUW.newObjGIRIS001.riPremVat 	  = clear == true ? null:objUW.newObjGIRIS001.riPremVat;
		objUW.newObjGIRIS001.riShrPct 	  = clear == true ? null :$F("txtRiShrPct");
		objUW.newObjGIRIS001.riTsiAmt 	  = clear == true ? null :unformatCurrencyValue($F("txtRiTsiAmt"));
		objUW.newObjGIRIS001.riShrPct2 	  = clear == true ? null :$F("txtRiShrPct2");
		objUW.newObjGIRIS001.riPremAmt 	  = clear == true ? null :unformatCurrencyValue($F("txtRiPremAmt"));
		objUW.newObjGIRIS001.premWarrDays = clear == true ? null :$F("txtPremWarrDays");
		objUW.newObjGIRIS001.premWarrTag  = clear == true ? null :($("chkPremWarrTag").checked == true ? "Y" :"N");
		objUW.newObjGIRIS001.lineCd 	  = clear == true ? null :objUW.hidObjGIRIS001.viewJSON.lineCd;
		objUW.newObjGIRIS001.frpsYy 	  = clear == true ? null :objUW.hidObjGIRIS001.viewJSON.frpsYy;
		objUW.newObjGIRIS001.frpsSeqNo 	  = clear == true ? null :objUW.hidObjGIRIS001.viewJSON.frpsSeqNo;

		return objUW.newObjGIRIS001;
	}	
	clearNewObj(true);
	
	function clearAll(){
		objUW.hidObjGIRIS001.selIndex = "";
		objUW.hidObjGIRIS001.selObj = null;
		clearNewObj(true);
		//computeSumAmt();
		supplyCreateRi(null);	
		tableGrid.unselectRows();
		observeChangeTagInTableGrid(tableGrid);
	}	
	
	//Observe Add/Update button
	$("btnAddRi").observe("click", function(){
		try{
			if(checkAllRequiredFields()){
				if ($F("btnAddRi") == "Update"){
					var oldRiCd = tableGrid.getValueAt(tableGrid.getColumnIndex('riCd'), objUW.hidObjGIRIS001.selIndex);
					if (oldRiCd != nvl(objUW.newObjGIRIS001.riCd,nvl(objUW.hidObjGIRIS001.selObj.riCd,null))){
						tableGrid.setValueAt(escapeHTML2($F("txtDspRiSname")),tableGrid.getIndexOf('riSname'), objUW.hidObjGIRIS001.selIndex, true);
						tableGrid.setValueAt(nvl(objUW.newObjGIRIS001.riName,""),tableGrid.getIndexOf('riName'), objUW.hidObjGIRIS001.selIndex, true);
						tableGrid.setValueAt(nvl(objUW.newObjGIRIS001.riCd,""),tableGrid.getIndexOf('riCd'), objUW.hidObjGIRIS001.selIndex, true);
						tableGrid.setValueAt(nvl(objUW.newObjGIRIS001.billAddress1,""),tableGrid.getIndexOf('address1'), objUW.hidObjGIRIS001.selIndex, true);
						tableGrid.setValueAt(nvl(objUW.newObjGIRIS001.billAddress2,""),tableGrid.getIndexOf('address2'), objUW.hidObjGIRIS001.selIndex, true);
						tableGrid.setValueAt(nvl(objUW.newObjGIRIS001.billAddress3,""),tableGrid.getIndexOf('address3'), objUW.hidObjGIRIS001.selIndex, true);
					}
					if ($F("txtRiShrPct") != formatToNthDecimal(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct'), objUW.hidObjGIRIS001.selIndex),14)){
						tableGrid.setValueAt($F("txtRiShrPct"),tableGrid.getIndexOf('riShrPct'), objUW.hidObjGIRIS001.selIndex, true);
					}	
					if (unformatCurrencyValue($F("txtRiTsiAmt")) != tableGrid.getValueAt(tableGrid.getColumnIndex('riTsiAmt'), objUW.hidObjGIRIS001.selIndex)){
						tableGrid.setValueAt(unformatCurrencyValue($F("txtRiTsiAmt")),tableGrid.getIndexOf('riTsiAmt'), objUW.hidObjGIRIS001.selIndex, true);
					}	
					if ($F("txtRiShrPct2") != formatToNthDecimal(tableGrid.getValueAt(tableGrid.getColumnIndex('riShrPct2'), objUW.hidObjGIRIS001.selIndex),9)){
						tableGrid.setValueAt($F("txtRiShrPct2"),tableGrid.getIndexOf('riShrPct2'), objUW.hidObjGIRIS001.selIndex, true);
					}
					if (unformatCurrencyValue($F("txtRiPremAmt")) != tableGrid.getValueAt(tableGrid.getColumnIndex('riPremAmt'), objUW.hidObjGIRIS001.selIndex)){
						tableGrid.setValueAt(unformatCurrencyValue($F("txtRiPremAmt")),tableGrid.getIndexOf('riPremAmt'), objUW.hidObjGIRIS001.selIndex, true);
					}
					if ($F("txtPremWarrDays") != nvl(tableGrid.getValueAt(tableGrid.getColumnIndex('premWarrDays'), objUW.hidObjGIRIS001.selIndex),"")){
						tableGrid.setValueAt($F("txtPremWarrDays"),tableGrid.getIndexOf('premWarrDays'), objUW.hidObjGIRIS001.selIndex, true);
					}
					var tag = ($("chkPremWarrTag").checked == true ? "Y" :"N");
					if (tag != tableGrid.getValueAt(tableGrid.getColumnIndex('premWarrTag'), objUW.hidObjGIRIS001.selIndex)){
						tableGrid.setValueAt(tag,tableGrid.getIndexOf('premWarrTag'), objUW.hidObjGIRIS001.selIndex, true);
					}

					objUW.hidObjGIRIS001.sumRiShrPct = (parseFloat(objUW.hidObjGIRIS001.sumRiShrPct) - parseFloat($("txtRiShrPct").getAttribute("oldRiShrPct"))) + parseFloat($F("txtRiShrPct"));
					objUW.hidObjGIRIS001.sumRiTsiAmt = (parseFloat(objUW.hidObjGIRIS001.sumRiTsiAmt) - parseFloat($("txtRiTsiAmt").getAttribute("oldRiTsiAmt"))) + parseFloat($F("txtRiTsiAmt").replace(/,/g, ""));
					objUW.hidObjGIRIS001.sumRiShrPct2 = (parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2) - parseFloat($("txtRiShrPct2").getAttribute("oldRiShrPct2"))) + parseFloat($F("txtRiShrPct2"));
					objUW.hidObjGIRIS001.sumRiPremAmt = (parseFloat(objUW.hidObjGIRIS001.sumRiPremAmt) - parseFloat($("txtRiPremAmt").getAttribute("oldRiPremAmt"))) + parseFloat($F("txtRiPremAmt").replace(/,/g, ""));
					
					$("sumRiShrPct").value = formatToNthDecimal(objUW.hidObjGIRIS001.sumRiShrPct, 14);
					$("sumRiTsiAmt").value = formatCurrency(objUW.hidObjGIRIS001.sumRiTsiAmt);
					$("sumRiShrPct2").value = formatToNthDecimal(objUW.hidObjGIRIS001.sumRiShrPct2, 9);
					$("sumRiPremAmt").value = formatCurrency(objUW.hidObjGIRIS001.sumRiPremAmt);
				}else{
					if (((nvl(unformatCurrencyValue($F("txtV100TotFacSpct")), 0) <= nvl(objUW.hidObjGIRIS001.sumRiShrPct,0) 
					      && nvl(unformatCurrencyValue($F("txtV100TotFacSpct")), 0) != 0)
					      && (nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")), 0) <= nvl(objUW.hidObjGIRIS001.sumRiShrPct2,0)
					      && nvl(unformatCurrencyValue($F("txtV100TotFacSpct2")), 0) != 0)
					      && (nvl(unformatCurrencyValue($F("txtV100TotFacPrem")), 0) <=  nvl(objUW.hidObjGIRIS001.sumRiPremAmt,0)
					      && nvl(unformatCurrencyValue($F("txtV100TotFacPrem")), 0) != 0))){
						showMessageBox('RI Placement cannot exceed the allowed share fac.percent', 'I');
					    return false;
					}
					tableGrid.createNewRow(clearNewObj(false));
					objUW.hidObjGIRIS001.sumRiShrPct = parseFloat(objUW.hidObjGIRIS001.sumRiShrPct) + parseFloat($F("txtRiShrPct"));
					objUW.hidObjGIRIS001.sumRiTsiAmt = parseFloat(objUW.hidObjGIRIS001.sumRiTsiAmt) + parseFloat($F("txtRiTsiAmt").replace(/,/g, ""));
					objUW.hidObjGIRIS001.sumRiShrPct2 = parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2) + parseFloat($F("txtRiShrPct2"));
					objUW.hidObjGIRIS001.sumRiPremAmt = parseFloat(objUW.hidObjGIRIS001.sumRiPremAmt) + parseFloat($F("txtRiPremAmt").replace(/,/g, ""))
					
					$("sumRiShrPct").value = formatToNthDecimal(objUW.hidObjGIRIS001.sumRiShrPct, 14);
					$("sumRiTsiAmt").value = formatCurrency(objUW.hidObjGIRIS001.sumRiTsiAmt);	
					$("sumRiShrPct2").value = formatToNthDecimal(objUW.hidObjGIRIS001.sumRiShrPct2,9);	
					$("sumRiPremAmt").value = formatCurrency(objUW.hidObjGIRIS001.sumRiPremAmt);
				}	
				//computeSumAmt();
				clearAll();
			}
		}catch(e){
			showErrorMessage("Adding function", e);
		}	
	});
	
	//observe Delete button
	$("btnDeleteRi").observe("click", function(){
		new Ajax.Request(contextPath+"/GIRIWFrpsRiController?action=checkDelRecRiPlacement",{
			method: "POST",
			parameters:{
				preBinderId: tableGrid.getValueAt(tableGrid.getColumnIndex('preBinderId'), objUW.hidObjGIRIS001.selIndex)
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					if (nvl(response.responseText,'0') != '0'){
						showMessageBox('The preliminary binder for this reinsurer has been generated.', "I");
						enableForm(true);
					}else{
						tableGrid.deleteRow(tableGrid.getCurrentPosition()[1]);
						//tableGrid.deleteVisibleRowOnly(tableGrid.getCurrentPosition()[1]);
					}
					//computeSumAmt();
					
					// andrew - 1.3.2012
					objUW.hidObjGIRIS001.sumRiShrPct = parseFloat(objUW.hidObjGIRIS001.sumRiShrPct) - parseFloat($F("txtRiShrPct"));
					objUW.hidObjGIRIS001.sumRiTsiAmt = parseFloat(objUW.hidObjGIRIS001.sumRiTsiAmt) - parseFloat($F("txtRiTsiAmt").replace(/,/g, ""));
					objUW.hidObjGIRIS001.sumRiShrPct2 = parseFloat(objUW.hidObjGIRIS001.sumRiShrPct2) - parseFloat($F("txtRiShrPct2"));
					objUW.hidObjGIRIS001.sumRiPremAmt = parseFloat(objUW.hidObjGIRIS001.sumRiPremAmt) - parseFloat($F("txtRiPremAmt").replace(/,/g, ""))
					
					$("sumRiShrPct").value = formatToNthDecimal(objUW.hidObjGIRIS001.sumRiShrPct, 14);
					$("sumRiTsiAmt").value = formatCurrency(objUW.hidObjGIRIS001.sumRiTsiAmt);	
					$("sumRiShrPct2").value = formatToNthDecimal(objUW.hidObjGIRIS001.sumRiShrPct2,9);	
					$("sumRiPremAmt").value = formatCurrency(objUW.hidObjGIRIS001.sumRiPremAmt);
					
					clearAll();
				}else{
					showMessageBox(response.responseText, "E");
				}
			}	 
		});	
	});
	
	//Observe Save button
	$("btnSave").observe("click", function(){
		tableGrid.saveGrid(true);
	});
	
	observeCancelForm("btnCancel", function(){ changeTag = tableGrid.getChangeTag(); tableGrid.saveGrid('onCancel');}, function(){fireEvent($("riExit"), "click");});
	observeReloadForm("reloadForm", function() {showCreateRiPlacementPage();});
	
	$("searchWFrpsRi").observe("click", function() {
		showDistFrpsLOV("getDistFrpsWDistFrpsVLOV", "GIRIS001");
	});
	
	setDocumentTitle("Create RI Placement");
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GIRIS001");
	
	var wdistFrpsV = JSON.parse('${wdistFrpsVJSON}');
	if (retrievedDtlsGIRIS001 == false){
		wdistFrpsV.lineName = objRiFrps.lineName;//edgar 12/19/2014
		objRiFrps = wdistFrpsV;
		showCreateRiPlacementPage();
		retrievedDtlsGIRIS001 = true;
	}
}catch (e) {
	showErrorMessage("Create RI Placement page", e);
}
</script>