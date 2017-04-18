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
	<div class="" id="additionalItemInformation" style="margin: 0px; border-top: 1px solid #E0E0E0;" changeTagAttr="true" masterDetail="true" >		
		<input type="hidden" id="existsDed" 	value="" />
		<input type="hidden" id="existsDed2" 	value="" />
		<input type="hidden" id="quoteId" 		value="0" />
		<input type="hidden" id="towing" 		value="${towing}" />
		
		<input type="hidden" id="motorNumbers"			name="motorNumbers"			value="${motorNumbers}" />
		<input type="hidden" id="serialNumbers"			name="serialNumbers"		value="${serialNumbers}" />
		<input type="hidden" id="plateNumbers"			name="plateNumbers"			value="${plateNumbers}" />
		<input type="hidden" id="userAccess"			name="userAccess"			value="${userAccess}" />		
		
		<table id="motorcarTable" width="920px" cellspacing="1" border="0">
			<tr><td><br /></td></tr>
			<tr>
				<td class="rightAligned" style="width: 120px;">Assignee </td>
				<td class="leftAligned" style="width: 185px;"><input type="text" tabindex="2001" class="allCaps" style="width: 175px; padding: 2px;" name="assignee" id="assignee" maxlength="30" /></td>
				<td class="rightAligned">Acquired From </td>
				<td class="leftAligned" style="width: 185px;"><input type="text" tabindex="2002" style="width: 175px; padding: 2px;" name="acquiredFrom" id="acquiredFrom" maxlength="30" /></td>
				<td class="rightAligned" style="width: 100px;">Motor/Eng No. </td>
				<td class="leftAligned" style="width: 190px;"><input type="text" tabindex="2003" class="allCaps required" style="width: 175px; padding: 2px;" name="motorNo" id="motorNo" class="required" maxlength="30" /></td><!-- changed maxlength to 30 reymon 03312014 -->
			</tr>
			<tr>
				<td class="rightAligned">Origin </td>
				<td class="leftAligned"><input type="text" tabindex="2004" style="width: 175px; padding: 2px;" name="origin" id="origin" maxlength="50" /></td>
				<td class="rightAligned">Destination </td>
				<td class="leftAligned"><input type="text" tabindex="2005" style="width: 175px; padding: 2px;" name="destination" id="destination" maxlength="50" /></td>
				<td class="rightAligned">Type of Body </td>
				<td class="leftAligned">
					<select tabindex="2006" id="typeOfBody" name="typeOfBody" style="width: 180px;">
						<option value=""></option>
						<c:forEach var="typeOfBody" items="${typeOfBodies}">
							<option value="${typeOfBody.typeOfBodyCd}">${typeOfBody.typeOfBody}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Plate No. </td>
				<td class="leftAligned"><input type="text" tabindex="2007" class="allCaps" style="width: 175px; padding: 2px;" name="plateNo" id="plateNo" maxlength="10" /></td>
				<td class="rightAligned" for="modelYear">Model Year </td>
				<td class="leftAligned">
					<!-- 
					<input type="text" tabindex="2008" style="width: 175px; padding: 2px;" name="modelYear" id="modelYear" maxlength="4" class="integerNoNegativeUnformatted" errorMessage="Invalid Model Year. Value should be from 0001 to 9999." />
					 -->
					<input type="text" tabindex="2008" style="width: 175px; padding: 2px;" name="modelYear" id="modelYear" maxlength="4" class="applyWholeNosRegExp" regExpPatt="pDigit04" min="1" max="9999" />
				</td>
				<td class="rightAligned">Car Company </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 177px; height: 21px; margin-right: 3px;">
						<input type="hidden" id="carCompanyCd" name="carCompanyCd" />
						<input type="text" tabindex="2009" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="carCompany" id="carCompany" readonly="readonly" value=""/>
						<img id="hrefCarCompany" alt="goCarcompany" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
			</tr>
			<jsp:include page="/pages/underwriting/parTableGrid/motorcar/subPages/motorItemAddtlColumns.jsp"></jsp:include>
			<tr>
				<td class="rightAligned">MV File No. </td>
				<td class="leftAligned"><input type="text" tabindex="2010" style="width: 175px; padding: 2px;" name="mvFileNo" id="mvFileNo" maxlength="15" /></td>
				<td class="rightAligned" for="noOfPass">No. of Pass </td>
				<td class="leftAligned">
					<!-- 
					<input type="text" tabindex="2011" style="width: 175px; padding: 2px;" name="noOfPass" id="noOfPass" maxlength="3" class="integerNoNegativeUnformatted" errorMessage="Invalid No. of Pass. Value should be from 1 to 999." />
					 -->
					<input type="text" tabindex="2011" style="width: 175px; padding: 2px;" name="noOfPass" id="noOfPass" maxlength="3" class="applyWholeNosRegExp" regExpPatt="pDigit03" min="1" max="999" />
				</td>
				<td class="rightAligned">Make </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 177px; height: 21px; margin-right: 3px;">
						<input type="hidden" id="makeCd" name="makeCd" />
						<input type="text" tabindex="2012" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="make" id="make" readonly="readonly" value=""/>
						<img id="hrefMake" alt="goMake" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Basic Color </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 20px; margin-right: 3px;">
						<input type="hidden" id="basicColorCd" name="basicColorCd" />
						<input class="lov" type="text" tabindex="2013" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="basicColor" id="basicColor" readonly="readonly" value=""/>
						<img id="hrefBasicColor" alt="goBasicColor" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
				<td class="rightAligned">Color </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 20px; margin-right: 3px;">
						<input type="hidden" id="colorCd" name="colorCd" />
						<input class="lov" type="text" tabindex="2014" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="color" id="color" readonly="readonly" value=""/>
						<img id="hrefColor" alt="goColor" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>					
				</td>				
				<td class="rightAligned">Engine Series </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 177px; height: 21px; margin-right: 3px;">
						<input type="hidden" id="seriesCd" name="seriesCd" />
						<input type="text" tabindex="2015" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="engineSeries" id="engineSeries" readonly="readonly" value=""/>
						<img id="hrefEngineSeries" alt="goEngineSeries" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>					
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Motor Type </td>
				<td class="leftAligned">
					<select tabindex="2016" id="motorType" name="motorType" style="width: 180px;" class="required">
						<option value=""></option>
						<c:forEach var="motorType" items="${motorTypes}">
							<option value="${motorType.typeCd}">${motorType.motorTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">Unladen Wt. </td>
				<td class="leftAligned"><input type="text" tabindex="2017" style="width: 175px; padding: 2px;" name="unladenWt" id="unladenWt" maxlength="20" /></td>
				<td class="rightAligned" for="towLimit">Tow Limit </td>
				<td class="leftAligned">
					<!-- 
					<input type="text" tabindex="2018" style="width: 175px; padding: 2px;" name="towLimit" id="towLimit" class="money2" maxlength="17" min="0.00" max="99999999999999.99" errorMsg="Invalid Tow Limit. Value should be from 0.00 to 99,999,999,999,999.99" />
					 -->
					 <input type="text" tabindex="2018" style="width: 175px; padding: 2px;" name="towLimit" id="towLimit" class="applyDecimalRegExp" regExpPatt="pDeci1402" hasOwnChange="Y" hasOwnBlur="Y" maxlength="17" min="0.00" max="99999999999999.99" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Chassis/Serial No </td>
				<td class="leftAligned"><input type="text" tabindex="2019" class="allCaps required" style="width: 175px; padding: 2px;" name="serialNo" id="serialNo" maxlength="25" /></td>
				<td class="rightAligned">Subline Type </td>
				<td class="leftAligned">
					<select tabindex="2020" id="sublineType" name="sublineType" style="width: 180px;" class="required">
						<option value=""></option>
						<c:forEach var="sublineType" items="${sublineTypes}">								
							<option value="${sublineType.sublineTypeCd}">${sublineType.sublineTypeCd} - ${sublineType.sublineTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">Deductibles </td>
				<td class="leftAligned"><input type="text" tabindex="2021" style="width: 175px; padding: 2px;" name="deductibleAmount" id="deductibleAmount" class="money2" readonly="readonly" maxlength="16" /></td>
			</tr>
			<tr>
				<td class="rightAligned">COC No. </td>
				<td class="leftAligned" colspan="3">					
					<input type="text" tabindex="2022" style="width: 10%; float: left;" name="cocType" id="cocType" readonly="readonly" /><label>-</label>
					<!-- 
					<input type="text" tabindex="2023" style="width: 12%; float: left;" name="cocSerialNo" id="cocSerialNo" maxlength="7" class="integerNoNegativeUnformatted" errorMessage="Invalid COC No. (Serial No.). Value should be from 0 to 9999999." /><label>-</label>
					 -->
					<input type="text" tabindex="2023" style="width: 12%; float: left;" name="cocSerialNo" id="cocSerialNo" maxlength="7" class="applyWholeNosRegExp" regExpPatt="pDigit07" min="1" max="9999999" hasOwnKeyUp="Y" hasOwnBlur="Y" hasOwnChange="Y" /><label>-</label>
					<!-- 
					<input type="text" tabindex="2024" style="width: 8%; float: left; margin-right: 5px;" name="cocYy" id="cocYy" maxlength="2" class="integerNoNegativeUnformatted" errorMessage="Invalid COC No. (Year). Value should be from 0 to 99." />
					 -->
					<input type="text" tabindex="2024" style="width: 8%; float: left; margin-right: 5px;" name="cocYy" id="cocYy" maxlength="2" class="applyWholeNosRegExp" regExpPatt="pDigit02" min="0" max="99" hasOwnKeyUp="Y" />
					<label for="ctv"><div title="Motorcar Trailer Vehicle Type Tag"><input type="checkbox" tabindex="2025" style="width: 10px; padding: 2px; float: left;" id="ctv"/>CTV</div></label>
				</td>					
				<td class="rightAligned">Repair Limit </td>
				<td class="leftAligned"><input type="text" tabindex="2026" style="width: 175px; padding: 2px;" name="repairLimit" id="repairLimit" class="money2" readonly="readonly" maxlength="20" /></td>						
			</tr>									
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input tabindex="2027" type="button" id="btnAddItem" 	class="button" 			value="Add" />
					<input tabindex="2028" type="button" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
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
try{	
	$("noOfPass").observe("blur", function(){		
		if($F("noOfPass") == "0"){
			customShowMessageBox("Invalid No. of Pass. Value should be from 1 to 999.", imgMessage.ERROR, "noOfPass");
			return false;
		}
	});	
	
	$("cocSerialNo").observe("keyup", function(){
		var m = $("cocSerialNo");
		var pattern = m.getAttribute("regExpPatt"); 				
		
		if(pattern.substr(0,1) == "p"){
			if(m.value.include("-")){
				m.setAttribute("executeOnBlur", "N");
				showWaitingMessageBox("Invalid COC No. (Serial No.). Value value is from 1 to 9999999.", imgMessage.ERROR, function(){
					m.value = m.getAttribute("lastValidValue");
					m.focus();
				});
				return false;
			}else{						
				m.value = (m.value).match(RegExWholeNumber[pattern])[0];
				m.setAttribute("executeOnBlur", "Y");
			}
		}else{					
			m.value = (m.value).match(RegExWholeNumber[pattern])[0];
			m.setAttribute("executeOnBlur", "Y");
		}
	});
	
	function validateCOCSerialNo(){
		try{
			var m = $("cocSerialNo");
			var message = "Invalid COC No. (Serial No.). Value is from 1 to 9999999.";
			
			if(!($F("cocSerialNo").empty())){
				if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
					if(isNaN(parseInt((m.value).replace(/,/g, ""), 10))){
						m.value = "";
						customShowMessageBox(message, imgMessage.ERROR, m.id);
						return false;
					}else{
						if(parseInt(m.value, 10) < parseInt(m.getAttribute("min"), 10)){						
							showWaitingMessageBox(message, imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else if(parseInt(m.value, 10) > parseInt(m.getAttribute("max"), 10)){
							showWaitingMessageBox(message, imgMessage.ERROR, function(){
								m.value = m.getAttribute("lastValidValue");
								m.focus();
							});
							return false;
						}else{
							m.value = removeLeadingZero((m.value).replace(/,/g, ""));
							m.setAttribute("lastValidValue", m.value);
						}
					}
				}
				
				new Ajax.Request(contextPath + "/GIPIWVehicleController?action=validateCocSerialNo", {
					method : "POST",
					parameters : {
						parId : (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId),
						itemNo : $F("itemNo"),
						cocType : $F("cocType"),
						cocSerialNo : $F("cocSerialNo")
					},
					asynchronous : true,
					evalScripts : true,
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							if(response.responseText != ""){							
								customShowMessageBox(response.responseText, imgMessage.INFO, "cocSerialNo");							
								return false;
							}
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("validateCOCSerialNo", e);
		}
	}
	
	$("cocSerialNo").observe("blur", validateCOCSerialNo);
	$("cocSerialNo").observe("change", validateCOCSerialNo);
	
	$("cocYy").observe("keyup", function(e){
		var m = $("cocYy");
		var pattern = m.getAttribute("regExpPatt"); 				
		
		if(pattern.substr(0,1) == "p"){
			if(m.value.include("-")){
				m.setAttribute("executeOnBlur", "N");
				showWaitingMessageBox("Invalid COC No. (Year). Value value is from 0 to 99.", imgMessage.ERROR, function(){
					m.value = m.getAttribute("lastValidValue");
					m.focus();
				});
				return false;
			}else{						
				m.value = (m.value).match(RegExWholeNumber[pattern])[0];
				m.setAttribute("executeOnBlur", "Y");
			}
		}else{					
			m.value = (m.value).match(RegExWholeNumber[pattern])[0];
			m.setAttribute("executeOnBlur", "Y");
		}					    						
	});
	
	//modified by June Mark SR-5806 [12.14.16]
	$("hrefCarCompany").observe("click", function(){
		validateTowLimit();
		showCarCompanyLOV();
	});

	$("hrefMake").observe("click", function(){		
		showMakeLOV((objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")), $F("carCompanyCd"));
	});

	$("hrefEngineSeries").observe("click", function(){		
		showEngineSeriesLOV((objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")), $F("carCompanyCd"), $F("makeCd"));
	});

	$("hrefBasicColor").observe("click", showBasicColorLOV);
	$("hrefColor").observe("click", function() {
		showColorLOV($F("basicColorCd"));
	});

	// when delete button in basic color field is pressed	
	$("basicColor").observe("keyup", function(event) {		
		if(event.keyCode == 46){			
			$("basicColorCd").value = "";
			$("basicColor").value = "";
		}
	});
	
	// when delete button in color field is pressed	
	$("color").observe("keyup", function(event) {
		if(event.keyCode == 46){
			$("colorCd").value = "";
			$("color").value = "";
		}
	});	
	
	$("carCompany").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("carCompanyCd").value = "";
			$("carCompany").value 	= "";
			$("makeCd").value		= "";
			$("make").value			= "";
			$("seriesCd").value		= "";
			$("engineSeries").value	= "";
		}		
	});

	$("make").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("carCompanyCd").value = "";
			$("carCompany").value 	= "";
			$("makeCd").value		= "";
			$("make").value			= "";			
		}
	});

	$("engineSeries").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("seriesCd").value		= "";
			$("engineSeries").value	= "";
		}
	});
	
	function validateTowLimit(){
		try{
			if(!($F("towLimit").empty())){ //&& $("towLimit").getAttribute("executeOnBlur") != "N" commented out by June Mark SR-5806 [12.14.16]
				var objPre = new Object();
				var objSca = new Object();
				var amount = [];
				var sum	= "";
				
				amount = ($F("deductibleAmount").empty() ? "0.00" : (($F("deductibleAmount")).replace(/,/g, ""))).split(".");
				objPre[0] = parseInt(removeLeadingZero(amount[0]));
				objSca[0] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));

				amount = (Number($F("towLimit").replace(/,/g, "")).toFixed(2)).split("."); // added tofixed to correct computation by robert 01.29.15
				objPre[1] = parseInt(amount[0]); //removed removeLeadingZero by robert 01.29.2015 
				var am = parseInt(amount[0]);
				objSca[1] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));
				
				sum = addObjectNumbers2(objPre, objSca);  //changed function by robert 02.17.15 
				
				if(compareAmounts(sum, "99999999999999.99") == -1){
					customShowMessageBox("The sum of tow limit and deductibles should not exceed 99,999,999,999,999.99.", imgMessage.ERROR, "towLimit");
					return false;
				}else{
					$("repairLimit").value = addSeparatorToNumber2(sum, ",");					
					$("towLimit").value = addSeparatorToNumber2(formatNumberByRegExpPattern($("towLimit")), ",");
					//$("towLimit").value = Number($F("towLimit")).toFixed(2); //added by robert 01.29.2015	commented out by Gzelle 03192015
					$("towLimit").setAttribute("lastValidValue", $F("towLimit"));					
				}				
				
				delete objPre, objSca;				
			}else{ //added by robert 01.29.2015
				$("repairLimit").value = $F("deductibleAmount");
			}		
		}catch(e){
			showErrorMessage("validateTowLimit", e);
		}
	}

	$("towLimit").observe("blur", validateTowLimit);	
	
	$("towLimit").observe("change",validateTowLimit);	

	$("motorType").observe("change", function(){
		$("unladenWt").value = $("unladenWeight").options[$("motorType").selectedIndex].value;
	});

	$("cocSerialSw").observe("click", function(){
		if($("cocSerialSw").checked){
			$("cocSerialNo").disable();
			if(!($F("cocSerialNo").empty())){
				showMessageBox("Delete first the coc_serial_no before tagging the auto generate tag.", imgMessage.INFO);
				$("cocSerialSw").checked = false;
				$("cocSerialNo").enable();
			}
		}else{
			$("cocSerialNo").enable();
		}
	});
	
	$("plateNo").observe("blur", function(){
		if(!($F("plateNo").empty())){
			new Ajax.Request(contextPath + "/GIPIWVehicleController?action=validatePlateNo&plateNo=" + $F("plateNo"), {
				method : "POST",
				asynchronous : true,
				evalScripts : true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);

						if(obj.message != null){
							showWaitingMessageBox(obj.message, obj.messageType == "E" ? imgMessage.ERROR : imgMessage.INFO, function(){
								if(obj.messageType == "E"){
									$("plateNo").focus();
								}
							});
						}
					}
				}
			});	
		}		
	});	
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Additional Page", e);	
}
</script>