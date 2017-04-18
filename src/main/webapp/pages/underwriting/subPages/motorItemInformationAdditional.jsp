<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
	
<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">	
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;" changeTagAttr="true" masterDetail="true" >		
		<input type="hidden" id="existsDed" 	value="" />
		<input type="hidden" id="existsDed2" 	value="" />
		<input type="hidden" id="quoteId" 		value="0" />		
		<input type="hidden" id="towing" 		value="${towing}" />
		
		<input type="hidden" id="motorNumbers"			name="motorNumbers"			value="${motorNumbers}" />
		<input type="hidden" id="serialNumbers"			name="serialNumbers"		value="${serialNumbers}" />
		<input type="hidden" id="plateNumbers"			name="plateNumbers"			value="${plateNumbers}" />
		<input type="hidden" id="userAccess"			name="userAccess"			value="${userAccess}" />
		
		<!-- form variables -->
		<input type="hidden" id="varSublineMotorcycle"	value="${varSublineMotorcycle}" />
		<input type="hidden" id="varSublineCommercial"	value="${varSublineCommercial}" />
		<input type="hidden" id="varSublinePrivate"		value="${varSublinePrivate}" />
		<input type="hidden" id="varSublineLto"			value="${varSublineLto}" />
		<input type="hidden" id="varCocLto"				value="${varCocLto }" />
		<input type="hidden" id="varCocNlto"			value="${varCocNlto}" />
		<input type="hidden" id="varMcCompanySw"		value="${varMcCompanySw}" />
		<input type="hidden" id="varGenerateCoc"		value="${varGenerateCoc}" />
		
		<!-- form parameters -->
		<!-- <input type="hidden" id="parDefaultCoverage"	value="${parDefaultCoverage}" /> -->
		
		<table width="100%" cellspacing="1" border="0">
			<tr><td><br /></td></tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Assignee </td>
				<td class="leftAligned"><input type="text" tabindex="8" style="width: 90%; padding: 2px;" name="assignee" id="assignee" maxlength="250" /></td>
				<td class="rightAligned" style="width: 10%;">Acquired From </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="9" style="width: 90%; padding: 2px;" name="acquiredFrom" id="acquiredFrom" maxlength="30" /></td>
				<td class="rightAligned" style="width: 10%;">Motor No. </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="10" style="width: 90%; padding: 2px;" name="motorNo" id="motorNo" class="required" maxlength="30" /></td><!-- changed maxlength to 30 reymon 03312014 -->
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Origin </td>
				<td class="leftAligned"><input type="text" tabindex="11" style="width: 90%; padding: 2px;" name="origin" id="origin" maxlength="50" /></td>
				<td class="rightAligned" style="width: 10%;">Destination </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="12" style="width: 90%; padding: 2px;" name="destination" id="destination" maxlength="50" /></td>
				<td class="rightAligned" style="width: 10%;">Type of Body </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="13" id="typeOfBody" name="typeOfBody" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="typeOfBody" items="${typeOfBodies}">
							<option value="${typeOfBody.typeOfBodyCd}">${typeOfBody.typeOfBody}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Plate No. </td>
				<td class="leftAligned"><input type="text" tabindex="14" style="width: 90%; padding: 2px;" name="plateNo" id="plateNo" maxlength="10" /></td>
				<td class="rightAligned" style="width: 10%;">Model Year </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="15" style="width: 90%; padding: 2px;" name="modelYear" id="modelYear" maxlength="4" class="integerNoNegativeUnformatted" errorMessage="Invalid Model Year. Value should be from 0001 to 9999." /></td>
				<td class="rightAligned" style="width: 10%;">Car Company </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="16" id="carCompany" name="carCompany" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="carCompany" items="${carCompanies}">
							<option value="${carCompany.carCompanyCd}">${carCompany.carCompany}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">MV File No. </td>
				<td class="leftAligned"><input type="text" tabindex="17" style="width: 90%; padding: 2px;" name="mvFileNo" id="mvFileNo" maxlength="15" /></td>
				<td class="rightAligned" style="width: 10%;">No. of Pass </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="18" style="width: 90%; padding: 2px;" name="noOfPass" id="noOfPass" maxlength="3" class="integerNoNegativeUnformatted" errorMessage="Invalid No. of Pass. Value should be from 1 to 999." /></td>
				<td class="rightAligned" style="width: 10%;">Make </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="19" id="makeCd" name="makeCd" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="make" items="${makes}">
							<option value="${make.makeCd}" carCompanyCd="${make.carCompanyCd}">${make.make}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Basic Color </td>
				<td class="leftAligned">
					<select tabindex="20" id="basicColor" name="basicColor" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="basicColor" items="${basicColors}">
							<option value="${basicColor.basicColorCd}">${basicColor.basicColor}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Color </td>
				<td class="leftAligned" style="width: 23%;">
					<input type="hidden" id="color" name="color" value="" />
					<select tabindex="21" id="colorCd" name="colorCd" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="color" items="${colors}">
							<option value="${color.colorCd}" basicColorCd="${color.basicColorCd}">${color.color}</option>				
						</c:forEach>
					</select>
				</td>
				<!-- 
				<td class="rightAligned" style="width: 10%;">Engine Series </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="22" id="engineSeries" name="engineSeries" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="engineSeries" items="${engineSeries}">
							<option value="${engineSeries.seriesCd}" makeCd="${engineSeries.makeCd}" carCompanyCd="${engineSeries.carCompanyCd}">${engineSeries.engineSeries}</option>				
						</c:forEach>
					</select>
				</td>
				 -->
				<td class="rightAligned" style="width: 10%;">Engine Series </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="22" id="engineSeries" name="engineSeries" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="engineSeries" items="${engineSeries}">
							<option value="${engineSeries.seriesCd}" makeCd="${engineSeries.makeCd}" carCompanyCd="${engineSeries.carCompanyCd}" combinationVal="${engineSeries.carCompanyCd}_${engineSeries.makeCd}_${engineSeries.seriesCd}">${engineSeries.engineSeries}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Motor Type </td>
				<td class="leftAligned">
					<select tabindex="23" id="motorType" name="motorType" style="width: 92.5%;" class="required">
						<option value=""></option>
						<c:forEach var="motorType" items="${motorTypes}">
							<option value="${motorType.typeCd}">${motorType.motorTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Unladen Wt. </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="24" style="width: 90%; padding: 2px;" name="unladenWt" id="unladenWt" maxlength="20" /></td>
				<td class="rightAligned" style="width: 10%;">Tow Limit </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="25" style="width: 90%; padding: 2px;" name="towLimit" id="towLimit" class="money2" maxlength="17" min="0.00" max="99999999999999.98" errorMsg="Invalid Tow Limit. Value should be from 0.00 to 99,999,999,999,999.98" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Serial No </td>
				<td class="leftAligned"><input type="text" tabindex="26" style="width: 90%; padding: 2px;" name="serialNo" id="serialNo" maxlength="25" /></td>
				<td class="rightAligned" style="width: 10%;">Subline Type </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="27" id="sublineType" name="sublineType" style="width: 92.5%;" class="required">
						<option value=""></option>
						<c:forEach var="sublineType" items="${sublineTypes}">								
							<option value="${sublineType.sublineTypeCd}">${sublineType.sublineTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Deductibles </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="28" style="width: 90%; padding: 2px;" name="deductibleAmount" id="deductibleAmount" class="money" readonly="readonly" maxlength="16" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">COC No. </td>
				<td class="leftAligned" colspan="3">					
					<!--  
					<select tabindex="29" id="cocType" name="cocType" style="width: 11.55%;">
						<c:forEach var="cocType" items="${cocType}">								
							<option value="${cocType}">${cocType}</option>				
						</c:forEach>
					</select>-
					-->
					<input type="text" style="width: 10%; float: left;" name="cocType" id="cocType" readonly="readonly" /><label>-</label>
					<input type="text" tabindex="30" style="width: 12%; float: left;" name="cocSerialNo" id="cocSerialNo" maxlength="7" class="integerNoNegativeUnformatted" errorMessage="Invalid COC No. (Serial No.). Value should be from 0 to 9999999." /><label>-</label>
					<input type="text" tabindex="31" style="width: 8%; float: left; margin-right: 5px;" name="cocYy" id="cocYy" maxlength="2" class="integerNoNegativeUnformatted" errorMessage="Invalid COC No. (Year). Value should be from 0 to 99." />
					<input type="checkbox" tabindex="32" style="width: 10px; padding: 2px; float: left;" id="ctv" /><label for="ctv">CTV</label>
				</td>					
				<td class="rightAligned" style="width: 10%;">Repair Limit </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="33" style="width: 90%; padding: 2px;" name="repairLimit" id="repairLimit" class="money" readonly="readonly" maxlength="20" /></td>						
			</tr>									
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAdd" 	class="button" 			value="Add" />
					<input type="button" id="btnDelete" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
		<select id="unladenWeight" name="unladenWeight" style="display: none;">
			<option value=""></option>
			<c:forEach var="mt" items="${motorTypes}">
				<option value="${mt.unladenWt}">${mt.unladenWt}</option>
			</c:forEach>
		</select>
	</div>
</div>

<script type="text/javascript">
	if($F("varGenerateCoc") == "Y"){
		$("generateCOCSerialNo").enable();
	}else{
		$("generateCOCSerialNo").disable();
	}

	if($F("userAccess") != "Y"){		
		disableButton("btnMotorCarIssuance");		
		$("generateCocSerialNoDiv").hide();
	}else{
		enableButton("btnMotorCarIssuance");		
		$("generateCocSerialNoDiv").show();
	}

	function updateRepairLimit(){
		var deductible = $F("deductibleAmount").blank() ? "0.00" : $F("deductibleAmount").replace(/,/g, "");		

		$("repairLimit").value = formatCurrency(parseFloat($F("towLimit").replace(/,/g , "")) + parseFloat(deductible));

		/*
		if(!(isNaN($F("towLimit")))){
			var min = $("towLimit").getAttribute("min");
			var max = $("towLimit").getAttribute("max");
			var towing = $F("towLimit").replace(/,/g , "");
			
			if(towing >= min && towing <= max){				
				var towingVals = [towing.substr(0, towing.indexOf(".", 0)), towing.substr(towing.indexOf(".", 0))];
				var deductibleVals = [deductible.substr(0, deductible.indexOf(".", 0)), deductible.substr(deductible.indexOf(".", 0))];
				
				var wholeNum = parseInt(towingVals[0]) + parseInt(deductibleVals[0]);
				var decNum = parseFloat(towingVals[1]) + parseFloat(deductibleVals[1]);
				
				var deciVals = [decNum.toString().substr(0, decNum.toString().indexOf(".", 0)), decNum.toString().substr(decNum.toString().indexOf(".", 0) + 1)];

				wholeNum = wholeNum + parseInt(deciVals[0]);
				
				var result = wholeNum + "." + deciVals[1];
				
				$("repairLimit").value = formatCurrency(result);	
			}else{
				$("repairLimit").value = "";
			}				
		}
		*/	
		//$("repairLimit").value = formatCurrency(parseFloat($F("towLimit").replace(/,/g , "")) + parseFloat(deductible));		
	}

	function getMotorUnladenWt() {
		$("unladenWt").value = $("unladenWeight").options[$("motorType").selectedIndex].value;
	}

	$("towLimit").observe("blur", updateRepairLimit);
	$("deductibleAmount").observe("blur", updateRepairLimit);
	
	$("basicColor").observe("change",
		function(){			
			$("colorCd").value = "";
			reloadLOV("colorCd");
			updateLOV("colorCd", "basicColorCd", "basicColor");			
		});

	$("colorCd").observe("change",
		function(){
			if($F("basicColor").blank()){
				$("basicColor").value = $("colorCd").options[$("colorCd").selectedIndex].getAttribute("basicColorCd");
				reloadLOV("colorCd");
				updateLOV("colorCd", "basicColorCd", "basicColor");				
			}
	});
	
	$("carCompany").observe("change",
		function(){
			$("makeCd").value = "";
			$("engineSeries").value = "";

			if($F("carCompany").blank()){
				reloadLOV("makeCd");
				reloadLOV("engineSeries");
			}else{				
				reloadLOV("makeCd");
				updateLOV("makeCd", "carCompanyCd", "carCompany");

				if($F("makeCd") == ""){
					for(var index=0, length = $("engineSeries").options.length; index < length; index++){
						$("engineSeries").options[index].hide();
					}
				}
			}						
		});

	$("makeCd").observe("change",
		function(){
			if($F("carCompany").blank()){
				$("carCompany").value = $("makeCd").options[$("makeCd").selectedIndex].getAttribute("carCompanyCd");
				reloadLOV("makeCd");
				updateLOV("makeCd", "carCompanyCd", "carCompany");
			}else{
				if($F("makeCd") == ""){
					$("engineSeries").value = "";
					reloadLOV("engineSeries");
				}else{
					for(var index=0, length = $("engineSeries").options.length; index < length; index++){
						var attributeValue1 = $("engineSeries").options[index].getAttribute("makeCd");
						var attributeValue2 = $("engineSeries").options[index].getAttribute("carCompanyCd"); 
						if((parseInt(attributeValue1) == parseInt($F("makeCd"))) && 
							(parseInt(attributeValue2) == parseInt($F("carCompany")))){
								$("engineSeries").options[index].show();
						}else{
							$("engineSeries").options[index].hide();
						}													
						
					}
				}
			}			
		});

	$("engineSeries").observe("change",
		function(){
			if($F("carCompany").blank() || $F("makeCd").blank()){
				$("carCompany").value = $("engineSeries").options[$("engineSeries").selectedIndex].getAttribute("carCompanyCd");
				reloadLOV("makeCd");
				updateLOV("makeCd", "carCompanyCd", "carCompany");
				$("makeCd").value = $("engineSeries").options[$("engineSeries").selectedIndex].getAttribute("makeCd");
				for(var index=0, length = $("engineSeries").options.length; index < length; index++){
					var attributeValue1 = $("engineSeries").options[index].getAttribute("makeCd");
					var attributeValue2 = $("engineSeries").options[index].getAttribute("carCompanyCd"); 
					if((parseInt(attributeValue1) != parseInt($F("makeCd")))){
						if((parseInt(attributeValue2) == parseInt($F("carCompany")))){
							$("engineSeries").options[index].show();
						}else{
							$("engineSeries").options[index].hide();
						}												
					}
				}
			}
	});
	
	$("motorType").observe("change", getMotorUnladenWt);	

	$("modelYear").observe("blur", function () {
		//isNumber("modelYear", "Invalid Model Year. Value should be from 1 to 9999.", "popup");
		if(!($F("modelYear").empty()) && $F("modelYear").length < 4){
			//showMessageBox("Entered Model Year is invalid. Valid value is from 0001 to 9999.", imgMessage.ERROR);			
			//return false;
			$("modelYear").value = new Number($F("modelYear")).toPaddedString(4);
		}
	});

	$("noOfPass").observe("blur", function () {		
		if(!($F("noOfPass").empty()) && ($F("noOfPass") < 1 || $F("noOfPass") > 999)){
			showMessageBox("Entered no. of passenger is invalid. Valid value is from 1 to 999.", imgMessage.ERROR);			
		}
	});

	$("towLimit").observe("blur", function () {
		//validateCurrency("towLimit", "Invalid Tow Limit. Value should be from 0.00 to 99,999,999,999,999.99.", "popup", 0.00, 99999999999999.99);
		if(!($F("towLimit").empty())){
			if($F("towLimit") < 0 || $F("towLimit") > 99999999999999.98){
				showMessageBox("Invalid Tow Limit. Value should be from 0.00 to 99,999,999,999,999.98", imgMessage.ERROR);
				$("towLimit").value = "";
				$("repairLimit").value = "";
				return false;
			}else if(isNaN($F("towLimit"))){
				showMessageBox("Invalid Tow Limit. Value should be from 0.00 to 99,999,999,999,999.98", imgMessage.ERROR);
				$("towLimit").value = "";
				$("repairLimit").value = "";
				return false;
			}else{				
				updateRepairLimit();
			}
		}		
	});

	$("cocSerialNo").observe("blur", function () {
		//isNumber("cocSerialNo", "Invalid COC No. (Serial No.). Value should be from 0 to 9999999.", "popup");
		//$("cocSerialNo").focus();
		var cocSerialNo = $F("cocSerialNo").replace(/,/g, "");
		if(!(cocSerialNo.empty) && ((cocSerialNo < 0) || (cocSerialNo > 9999999))){
			showMessageBox("Invalid COC No. (Serial No.). Value should be from 0 to 9999999.", imgMessage.WARNING);
		}
	});

	$("cocYy").observe("blur", function () {
		//isNumber("cocYY", "Invalid COC No. (Year). Value should be from 0 to 99.", "popup");
		
		if($F("cocYy").length < 2){
			$("cocYy").value = new Number($F("cocYy")).toPaddedString(2);
		}
	});

	function generateCOCSerialNoBehavior(){
		if($("generateCOCSerialNo").checked){
			$("cocSerialNo").disable();
			if(!($F("cocSerialNo").empty())){
				showMessageBox("Delete first the coc_serial_no before tagging the auto generate tag.", imgMessage.INFO);
				$("generateCOCSerialNo").checked = false;
				$("cocSerialNo").enable();
			}
		}else{
			$("cocSerialNo").enable();
		}
	}

	$("generateCOCSerialNo").observe("click", generateCOCSerialNoBehavior);	
</script>