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
		
		<table id="motorcarTable" width="920px" cellspacing="1" border="0">
			<tr><td><br /></td></tr>
			<tr>
				<td class="rightAligned" style="width: 120px;">Assignee </td>
				<td class="leftAligned" style="width: 185px;"><input type="text" tabindex="8" style="width: 175px; padding: 2px;" name="assignee" id="assignee" maxlength="30" /></td>
				<td class="rightAligned">Acquired From </td>
				<td class="leftAligned" style="width: 185px;"><input type="text" tabindex="9" style="width: 175px; padding: 2px;" name="acquiredFrom" id="acquiredFrom" maxlength="30" /></td>
				<td class="rightAligned" style="width: 100px;">Motor/Eng No. </td>
				<td class="leftAligned" style="width: 190px;"><input type="text" tabindex="10" style="width: 175px; padding: 2px;" name="motorNo" id="motorNo" class="required" maxlength="30" /></td><!-- changed maxlength to 30 reymon 03312014 -->
			</tr>
			<tr>
				<td class="rightAligned">Origin </td>
				<td class="leftAligned"><input type="text" tabindex="11" style="width: 175px; padding: 2px;" name="origin" id="origin" maxlength="50" /></td>
				<td class="rightAligned">Destination </td>
				<td class="leftAligned"><input type="text" tabindex="12" style="width: 175px; padding: 2px;" name="destination" id="destination" maxlength="50" /></td>
				<td class="rightAligned">Type of Body </td>
				<td class="leftAligned">
					<select tabindex="13" id="typeOfBody" name="typeOfBody" style="width: 180px;">
						<option value=""></option>
						<c:forEach var="typeOfBody" items="${typeOfBodies}">
							<option value="${typeOfBody.typeOfBodyCd}">${typeOfBody.typeOfBody}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Plate No. </td>
				<td class="leftAligned"><input type="text" tabindex="14" style="width: 175px; padding: 2px;" name="plateNo" id="plateNo" maxlength="10" /></td>
				<td class="rightAligned">Model Year </td>
				<td class="leftAligned"><input type="text" tabindex="15" style="width: 175px; padding: 2px;" name="modelYear" id="modelYear" maxlength="4" class="integerNoNegativeUnformatted" errorMessage="Invalid Model Year. Value should be from 0001 to 9999." /></td>
				<td class="rightAligned">Car Company </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 177px; height: 21px; margin-right: 3px;">
						<input type="hidden" id="carCompanyCd" name="carCompanyCd" />
						<input type="text" tabindex="16" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="carCompany" id="carCompany" readonly="readonly" value=""/>
						<img id="hrefCarCompany" alt="goCarcompany" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="16" id="carCompany" name="carCompany" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="carCompany" items="${carCompanies}">
							<option value="${carCompany.carCompanyCd}">${carCompany.carCompany}</option>				
						</c:forEach>
					</select>
					 -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">MV File No. </td>
				<td class="leftAligned"><input type="text" tabindex="17" style="width: 175px; padding: 2px;" name="mvFileNo" id="mvFileNo" maxlength="15" /></td>
				<td class="rightAligned">No. of Pass </td>
				<td class="leftAligned"><input type="text" tabindex="18" style="width: 175px; padding: 2px;" name="noOfPass" id="noOfPass" maxlength="3" class="integerNoNegativeUnformatted" errorMessage="Invalid No. of Pass. Value should be from 1 to 999." /></td>
				<td class="rightAligned">Make </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 177px; height: 21px; margin-right: 3px;">
						<input type="hidden" id="makeCd" name="makeCd" />
						<input type="text" tabindex="19" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="make" id="make" readonly="readonly" value=""/>
						<img id="hrefMake" alt="goMake" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="19" id="makeCd" name="makeCd" style="width: 92.5%;">
						<option name="make" value=""></option>
						<c:forEach var="make" items="${makes}">
							<option name="make" value="${make.makeCd}" carCompanyCd="${make.carCompanyCd}" combinationVal="${make.carCompanyCd}_${make.makeCd}">${make.make}</option>				
						</c:forEach>
					</select>
					 -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Basic Color </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 20px; margin-right: 3px;">
						<input type="hidden" id="basicColorCd" name="basicColorCd" />
						<input class="lov" type="text" tabindex="16" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="basicColor" id="basicColor" readonly="readonly" value=""/>
						<img id="hrefBasicColor" alt="goBasicColor" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
<%-- 					<select tabindex="20" id="basicColor" name="basicColor" style="width: 180px;">
						<option value=""></option>
						<c:forEach var="basicColor" items="${basicColors}">
							<option value="${basicColor.basicColorCd}">${basicColor.basicColor}</option>				
						</c:forEach>
					</select> --%>
				</td>
				<td class="rightAligned">Color </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 20px; margin-right: 3px;">
						<input type="hidden" id="colorCd" name="colorCd" />
						<input class="lov" type="text" tabindex="16" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="color" id="color" readonly="readonly" value=""/>
						<img id="hrefColor" alt="goColor" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<%-- <input type="hidden" id="color" name="color" value="" />
					<select tabindex="21" id="colorCd" name="colorCd" style="width: 180px;">
						<option value=""></option>
						<c:forEach var="color" items="${colors}">
							<option value="${color.colorCd}" basicColorCd="${color.basicColorCd}">${color.color}</option>				
						</c:forEach>
					</select> --%>
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
				<td class="rightAligned">Engine Series </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 177px; height: 21px; margin-right: 3px;">
						<input type="hidden" id="seriesCd" name="seriesCd" />
						<input type="text" tabindex="22" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;" name="engineSeries" id="engineSeries" readonly="readonly" value=""/>
						<img id="hrefEngineSeries" alt="goEngineSeries" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="22" id="engineSeries" name="engineSeries" style="width: 92.5%;">
						<option name="engSeries" value=""></option>
						<c:forEach var="engineSeries" items="${engineSeries}">
							<option name="engSeries" value="${engineSeries.seriesCd}" makeCd="${engineSeries.makeCd}" carCompanyCd="${engineSeries.carCompanyCd}" combinationVal="${engineSeries.carCompanyCd}_${engineSeries.makeCd}_${engineSeries.seriesCd}">${engineSeries.engineSeries}</option>				
						</c:forEach>
					</select>
					 -->
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Motor Type </td>
				<td class="leftAligned">
					<select tabindex="23" id="motorType" name="motorType" style="width: 180px;" class="required">
						<option value=""></option>
						<c:forEach var="motorType" items="${motorTypes}">
							<option value="${motorType.typeCd}">${motorType.motorTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">Unladen Wt. </td>
				<td class="leftAligned"><input type="text" tabindex="24" style="width: 175px; padding: 2px;" name="unladenWt" id="unladenWt" maxlength="20" /></td>
				<td class="rightAligned">Tow Limit </td>
				<td class="leftAligned"><input type="text" tabindex="25" style="width: 175px; padding: 2px;" name="towLimit" id="towLimit" class="money2" maxlength="17" min="0.00" max="99999999999999.99" errorMsg="Invalid Tow Limit. Value should be from 0.00 to 99,999,999,999,999.99" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Chassis/Serial No </td>
				<td class="leftAligned"><input type="text" tabindex="26" style="width: 175px; padding: 2px;" name="serialNo" id="serialNo" maxlength="25" class="required" /></td>
				<td class="rightAligned">Subline Type </td>
				<td class="leftAligned">
					<select tabindex="27" id="sublineType" name="sublineType" style="width: 180px;" class="required">
						<option value=""></option>
						<c:forEach var="sublineType" items="${sublineTypes}">								
							<option value="${sublineType.sublineTypeCd}">${sublineType.sublineTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">Deductibles </td>
				<td class="leftAligned"><input type="text" tabindex="28" style="width: 175px; padding: 2px;" name="deductibleAmount" id="deductibleAmount" class="money2" readonly="readonly" maxlength="16" /></td>
			</tr>
			<tr>
				<td class="rightAligned">COC No. </td>
				<td class="leftAligned" colspan="3">					
					<input type="text" style="width: 10%; float: left;" name="cocType" id="cocType" readonly="readonly" /><label>-</label>
					<input type="text" tabindex="30" style="width: 12%; float: left;" name="cocSerialNo" id="cocSerialNo" maxlength="7" class="integerNoNegativeUnformatted" errorMessage="Invalid COC No. (Serial No.). Value should be from 0 to 9999999." /><label>-</label>
					<input type="text" tabindex="31" style="width: 8%; float: left; margin-right: 5px;" name="cocYy" id="cocYy" maxlength="2" class="integerNoNegativeUnformatted" errorMessage="Invalid COC No. (Year). Value should be from 0 to 99." />
					<input type="checkbox" tabindex="32" style="width: 10px; padding: 2px; float: left;" id="ctv" /><label for="ctv">CTV</label>
				</td>					
				<td class="rightAligned">Repair Limit </td>
				<td class="leftAligned"><input type="text" tabindex="33" style="width: 175px; padding: 2px;" name="repairLimit" id="repairLimit" class="money2" readonly="readonly" maxlength="20" /></td>						
			</tr>									
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAddItem" 	class="button" 			value="Add" />
					<input type="button" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
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
	//initializeChangeTagBehavior();
	//initializeChangeTagAtrBehavior(); temporarily commented by: nica 2.10.2011
	
	$("hrefCarCompany").observe("click", function(){
		showOverlayContent2(contextPath + "/GIPIWVehicleController?action=showCarCompany", "Car Company", 820, "");
	});

	$("hrefMake").observe("click", function(){
		showOverlayContent2(contextPath + "/GIPIWVehicleController?action=showMake&sublineCd="+(objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"))+"&carCompanyCd="+$F("carCompanyCd"), "Make", 820, "");
	});

	$("hrefEngineSeries").observe("click", function(){
		showOverlayContent2(contextPath + "/GIPIWVehicleController?action=showEngineSeries&sublineCd="+(objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd"))+"&carCompanyCd="+$F("carCompanyCd")+"&makeCd="+$F("makeCd"), "Engine Series", 820, "");
	});

	$("hrefBasicColor").observe("click", showBasicColorLOV);
	$("hrefColor").observe("click", function() {
		showColorLOV($F("basicColorCd"));
	});

	// when delete button in basic color field is pressed
	//$("hrefBasicColor").observe("keyup", function(event) {
	$("basicColor").observe("keyup", function(event) {		
		if(event.keyCode == 46){			
			$("basicColorCd").value = "";
			$("basicColor").value = "";
		}
	});
	
	// when delete button in color field is pressed
	//$("hrefColor").observe("keyup", function(event) {
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

	function updateEngineSeriesLOVByCar(){
		for(var i=1, length=$("engineSeries").options.length; i < length; i++){
			combinationVal = $("engineSeries").options[i].getAttribute("combinationVal");					
			combinationValArr = (combinationVal == undefined ? "x_x_x" : combinationVal).split("_");
			if(combinationValArr[0] == $F("carCompany")){						
				$("engineSeries").options[i].show();
				$("engineSeries").options[i].disable = false;
			}else{
				$("engineSeries").options[i].hide();
				$("engineSeries").options[i].disable = true;
			}
		}
	}

	function updateEngineSeriesLOVByCarMake(){
		for(var i=1, length=$("engineSeries").options.length; i < length; i++){
			combinationVal = $("engineSeries").options[i].getAttribute("combinationVal");					
			combinationValArr = (combinationVal == undefined ? "x_x_x" : combinationVal).split("_");
			if(combinationValArr[0] == $F("carCompany") && combinationValArr[1] == $F("makeCd")){
				$("engineSeries").options[i].show();
				$("engineSeries").options[i].disable = false;
			}else{
				$("engineSeries").options[i].hide();
				$("engineSeries").options[i].disable = true;
			}
		}
	}	

	function updateLOV2(lovNameToUpdate, attributeName, valueToCompare){
		if($F(valueToCompare) == ""){
			reloadLOV(lovNameToUpdate);
		}else{
			var list = $(lovNameToUpdate).options;
			for(var i = 1, length = list.length; i < length; i++){ 
				list[i].show();
				list[i].disabled = false;
			}
			
			for(var index=1, length = $(lovNameToUpdate).options.length; index < length; index++){
				var attributeValue = $(lovNameToUpdate).options[index].getAttribute(attributeName); 
				if(attributeValue != $F(valueToCompare)) {
					$(lovNameToUpdate).options[index].hide();
					$(lovNameToUpdate).options[index].disabled = true;
				}
			}
		}		
	}	

	$("towLimit").observe("blur", function(){
		if(!($F("towLimit").empty())){
			var objPre = new Object();
			var objSca = new Object();
			var amount = [];
			var sum	= "";
			
			amount = ($F("deductibleAmount").empty() ? "0.00" : (($F("deductibleAmount")).replace(/,/g, ""))).split(".");
			objPre[0] = parseInt(amount[0]);
			objSca[0] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));

			amount = (($F("towLimit")).replace(/,/g, "")).split(".");
			objPre[1] = parseInt(amount[0]);
			objSca[1] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + (amount[1] == undefined ? 0 : amount[1]));

			sum = addObjectNumbers(objPre, objSca);
			
			if(sum > 99999999999999.99){
				customShowMessageBox("The sum of tow limit and deductibles should not exceed 99,999,999,999,999.99.", imgMessage.ERROR, "towLimit");
			}else{
				$("repairLimit").value = addSeparatorToNumber(sum, ",");
			}				
			
			delete objPre, objSca;
		}		
	});
	
/* 	$("basicColor").observe("change", function(){					
		
		//$("colorCd").value = "";
		//reloadLOV("colorCd");
		//updateLOV2("colorCd", "basicColorCd", "basicColor");
		
		$("colorCd").hide();
		$("colorCd").value = "";
		if($F("basicColor").empty()){
			$("colorCd").value = "";
			(($("colorCd").childElements()).invoke("show")).invoke("removeAttribute", "disabled");
		}else{			
			(($("colorCd").childElements()).invoke("show")).invoke("removeAttribute", "disabled");
			//(($$("select#colorCd option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
			(($$("select#colorCd option:not([basicColorCd='" + $F("basicColor") + "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");

			$("colorCd").options[0].show();
			$("colorCd").options[0].disabled = false;				
		}
		$("colorCd").show();			
	});

	$("colorCd").observe("change", function(){
		if($F("basicColor").blank()){
			$("basicColor").value = $("colorCd").options[$("colorCd").selectedIndex].getAttribute("basicColorCd");
			//reloadLOV("colorCd");
			updateLOV2("colorCd", "basicColorCd", "basicColor");				
		}
	});
 */	
	$("carCompany").observe("change", function(){
		if($F("carCompany").blank()){
			$("makeCd").value		= "";
			$("engineSeries").value	= "";

			reloadLOV("makeCd");
			reloadLOV("engineSeries");
		}else{
			updateLOV2("makeCd", "carCompanyCd", "carCompany");

			if($F("makeCd").blank()){
				$("engineSeries").value	= "";			
				updateEngineSeriesLOVByCar();
			}
		}							
	});

	$("makeCd").observe("change", function(){		
		var combinationVal = "";
		var combinationValArr;
		
		if($F("carCompany").blank()){
			combinationVal = $("makeCd").options[$("makeCd").selectedIndex].getAttribute("combinationVal");
			combinationValArr = combinationVal.split("_");
			$("carCompany").value = combinationValArr[0];
		}else{
			$("engineSeries").value = "";
			$F("makeCd").blank() ? updateEngineSeriesLOVByCar() : updateEngineSeriesLOVByCarMake();			
		}
	});

	$("engineSeries").observe("change",	function(){		
		var combinationVal = "";
		var combinationValArr;
		
		if(!($F("engineSeries").blank())){			
			combinationVal = $("engineSeries").options[$("engineSeries").selectedIndex].getAttribute("combinationVal");
			combinationValArr = combinationVal.split("_");
			$("carCompany").value = combinationValArr[0];
			reloadLOV("makeCd");
			updateLOV2("makeCd", "carCompanyCd", "carCompany");			
			setSelectOptionsValue("makeCd", "combinationVal", combinationValArr[0] + "_" + combinationValArr[1]);			
			updateEngineSeriesLOVByCarMake();
		}
	});	

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
}catch(e){
	showErrorMessage("motorItemInfoAddtional.jsp", e);
}
</script>