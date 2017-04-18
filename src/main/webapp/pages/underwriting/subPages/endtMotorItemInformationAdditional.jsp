<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="outerDiv">				
		<label id="">Additional Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>									
	</div>
</div>	
	
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">	
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">		
		<input type="hidden" id="existsDed" value="" />
		<input type="hidden" id="existsDed2" value="" />
		<input type="hidden" id="quoteId" value="0" />
		
		<!-- B580 fields -->
		<input type="hidden" id="estValue" name="estValue" value="0" />
		
		<table width="100%" cellspacing="1" border="0">
			<tr><td><br /></td></tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Assignee </td>
				<td class="leftAligned"><input type="text" tabindex="8" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="assignee" maxlength="250" /></td>
				<td class="rightAligned" style="width: 10%;">Acquired From </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="9" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="acquiredFrom" maxlength="30" /></td>
				<td class="rightAligned" style="width: 10%;">Motor No. </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="10" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="motorNo" class="required" maxlength="30" /></td><!-- changed maxlength to 30 reymon 03312014 -->
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Origin </td>
				<td class="leftAligned"><input type="text" tabindex="11" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="origin" maxlength="50" /></td>
				<td class="rightAligned" style="width: 10%;">Destination </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="12" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="destination" maxlength="50" /></td>
				<td class="rightAligned" style="width: 10%;">Type of Body </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="13" id="typeOfBody" name="motorItemAddtl" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="typeOfBodies" items="${typeOfBodies}">
							<option value="${typeOfBodies.typeOfBodyCd}">${typeOfBodies.typeOfBody}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Plate No. </td>
				<td class="leftAligned"><input type="text" tabindex="14" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="plateNo" maxlength="10" /></td>
				<td class="rightAligned" style="width: 10%;">Model Year </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="15" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="modelYear" maxlength="4" /></td>
				<td class="rightAligned" style="width: 10%;">Car Company </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="16" id="carCompany" name="motorItemAddtl" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="carCompanies" items="${carCompanies}">
							<option value="${carCompanies.carCompanyCd}">${carCompanies.carCompany}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">MV File No. </td>
				<td class="leftAligned"><input type="text" tabindex="17" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="mvFileNo" maxlength="15" /></td>
				<td class="rightAligned" style="width: 10%;">No. of Pass </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="18" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="noOfPass" maxlength="3" /></td>
				<td class="rightAligned" style="width: 10%;">Make </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="19" id="makeCd" name="motorItemAddtl" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="makes" items="${makes}">
							<option value="${makes.makeCd}">${makes.make}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Basic Color </td>
				<td class="leftAligned">
					<select tabindex="20" id="basicColor" name="motorItemAddtl" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="basicColors" items="${basicColors}">
							<option value="${basicColors.basicColorCd}">${basicColors.basicColor}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Color </td>
				<td class="leftAligned" style="width: 23%;">
					<input type="hidden" id="color" name="motorItemAddtl" value="" />
					<select tabindex="21" id="colorCd" name="motorItemAddtl" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="colors" items="${colors}">
							<option value="${colors.colorCd}">${colors.color}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Engine Series </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="22" id="engineSeries" name="motorItemAddtl" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="engineSeries" items="${engineSeries}">
							<option value="${engineSeries.seriesCd}">${engineSeries.engineSeries}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Motor Type </td>
				<td class="leftAligned">
					<select tabindex="23" id="motorType" name="motorItemAddtl" style="width: 92.5%;" class="required">
						<option value=""></option>
						<c:forEach var="motorTypes" items="${motorTypes}">
							<option value="${motorTypes.typeCd}">${motorTypes.motorTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Unladen Wt. </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="24" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="unladenWt" class="required" maxlength="20" /></td>
				<td class="rightAligned" style="width: 10%;">Tow Limit </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="25" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="towLimit" class="money" maxlength="16" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Serial No </td>
				<td class="leftAligned"><input type="text" tabindex="26" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="serialNo" maxlength="25" /></td>
				<td class="rightAligned" style="width: 10%;">Subline Type </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="27" id="sublineType" name="motorItemAddtl" style="width: 92.5%;" class="required">
						<option value=""></option>
						<c:forEach var="sublineTypes" items="${sublineTypes}">								
							<option value="${sublineTypes.sublineTypeCd}">${sublineTypes.sublineTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Deductibles </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="28" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="deductibleAmount" class="money" readonly="readonly" maxlength="16" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">COC No. </td>
				<td class="leftAligned" colspan="3">
					<!-- <input type="text" style="width: 10%; " name="cocType" id="cocType" value="" />- -->
					<select tabindex="29" id="cocType" name="motorItemAddtl" style="width: 11.55%;">
						<c:forEach var="cocType" items="${cocType}">								
							<option value="${cocType}">${cocType}</option>				
						</c:forEach>
					</select>-
					<input type="text" tabindex="30" style="width: 10%; " name="motorItemAddtl" id="cocSerialNo" maxlength="7" />-
					<input type="text" tabindex="31" style="width: 10%; " name="motorItemAddtl" id="cocYY" maxlength="2" />
					<input type="checkbox" tabindex="32" style="width: 10px; padding: 2px;" id="ctv" />CTV
				</td>					
				<td class="rightAligned" style="width: 10%;">Repair Limit </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="33" style="width: 90%; padding: 2px;" name="motorItemAddtl" id="repairLimit" class="money" readonly="readonly" maxlength="16" /></td>						
			</tr>
			<tr><td><br /></td></tr>							
		</table>
		<select id="unladenWeight" name="motorItemAddtl" style="display: none;">
			<option value=""></option>
			<c:forEach var="mt" items="${motorTypes}">
				<option value="${mt.unladenWt}">${mt.unladenWt}</option>
			</c:forEach>
		</select>
	</div>
</div>

<script type="text/javascript">

	$("towLimit").observe("blur", updateRepairLimit);
	$("deductibleAmount").observe("blur", updateRepairLimit);

	function updateRepairLimit(){
		$("repairLimit").value = formatCurrency(parseFloat($F("towLimit").replace(/,/g , "")) + parseFloat($F("deductibleAmount").replace(/,/g, "")));		
	}	
	
	$("basicColor").observe("change",
			function(){			
				new Ajax.Updater($("colorCd").up("td", 0), contextPath + "/GIPIParMCItemInformationController?action=filterColors", {
					method : "GET",
					parameters : {
						basicColorCd : $F("basicColor") /*$("basicColor").options[$("basicColor").selectedIndex].text*/,
						globalParId : $F("globalParId")
					},
					asynchronous : true,
					evalScripts : true,
					onCreate : 
						function(){
							$("colorCd").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
						}
				});
			});	
	
	$("carCompany").observe("change",
			function(){			
				new Ajax.Updater($("makeCd").up("td", 0), contextPath + "/GIPIParMCItemInformationController?action=filterMakes", {
					method : "GET",
					parameters : {
						carCompany : $F("carCompany"),
						globalParId : $F("globalParId")
					},
					asynchronous : true,
					evalScripts : true,
					onCreate : 
						function(){
							$("makeCd").up("td", 0).update("<span style='font-size: 9px;'>Refreshing...</span>");
						}
				});
			});	
	
	$("motorType").observe("change", getMotorUnladenWt);

	function getMotorUnladenWt() {
		$("unladenWt").value = $("unladenWeight").options[$("motorType").selectedIndex].value;
	}

	$("modelYear").observe("blur", function () {
		isNumber("modelYear", "Invalid Model Year. Value should be from 1 to 9999.", "messageBox");
	});

	$("noOfPass").observe("blur", function () {
		isNumber("noOfPass", "Invalid No. of Pass. Value should be from 1 to 999.", "messageBox");
	});

	$("towLimit").observe("blur", function () {
		validateCurrency("towLimit", "Invalid Tow Limit. Value should be from 0.00 to 99,999,999,999,999.99.", "popup", 0.00, 99999999999999.99);
		updateRepairLimit();
	});

	$("cocSerialNo").observe("blur", function () {
		isNumber("cocSerialNo", "Invalid COC No. (Serial No.). Value should be from 0 to 9999999.", "messageBox");
		$("cocSerialNo").focus();
	});

	$("cocYY").observe("blur", function () {
		isNumber("cocYY", "Invalid COC No. (Year). Value should be from 0 to 99.", "messageBox");
	});
</script>