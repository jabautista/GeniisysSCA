<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;">
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv">
		<form id="casualtyAdditionalInformationForm" name="casualtyAdditionalInformationForm" >
			<table align="center" style="width: 25%; margin-top: 10px;">
				<tr>
					<td class="rightAligned" style="width: 100px;">Location</td>
					<td class="leftAligned">
						<input type="text" id="txtLocation" name="txtLocation" style="width: 250px;" maxlength="150"  class="aiInput upper"  tabindex="301"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Section/Hazard</td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 65px; height: 20px; margin-right: 2px; margin-bottom: 2px;" class="withIconDIv">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 38px; border: none;" name="txtSectionOrHazardCd" id="txtSectionOrHazardCd"  class="upper" maxlength="3"  tabindex="302"/>
							<img id="sectionOrHazardLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"  tabindex="303"/>						
						</div>
						<div style="float: left; width: 181px;">
							<input id="txtSectionOrHazardTitle" class="leftAligned upper" type="text" name="txtSectionOrHazardTitle" style="float: left; margin-top: 0px; margin-right: 3px; border: solid 1px gray; height: 14px; width: 100%" value="" maxlength="2000" class="upper"  tabindex="304"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Capacity</td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 65px; height: 20px; margin-right: 2px; margin-bottom: 2px;" class="withIconDIv">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 38px; border: none;" name="txtCapacityCd" id="txtCapacityCd"  class="integerNoNegativeUnformatted" maxlength="5"  tabindex="305"/>
							<img id="capacityLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"  tabindex="306"/>						
						</div>
						<div style="float: left; width: 181px;">
							<input id="txtPosition" class="leftAligned upper" type="text" name="txtPosition" style="float: left; margin-top: 0px; margin-right: 3px; border: solid 1px gray; height: 14px; width: 100%" value="" maxlength="40" class="upper"  tabindex="307"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Liability</td>
					<td class="leftAligned">
						<input type="text" style="width: 250px;" id="txtLimitOfLiability" name="txtLimitOfLiability"  maxlength="500" class="aiInput upper"  tabindex="308"/>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" style="margin-bottom: 10px;">
				<input type="button" id="aiUpdateBtn" name="aiUpdateBtn" value="Apply Changes" class="disabledButton"  tabindex="309"/>
			</div>
		</form>
	</div>
</div>
<script>
	initializeAll();
	initializeAiType("aiUpdateBtn");
	initializeChangeAttribute();
	makeInputFieldUpperCase();
	
	$("capacityLOV").observe("click", getCapacityLOV);
	
	$("capacityLOV").observe("keypress", function (event) {
		if (event.keyCode == 13){
			getCapacityLOV();
		}
	});
	
	$("sectionOrHazardLOV").observe("click", getSectionOrHazardLOV);
	
	$("sectionOrHazardLOV").observe("keypress", function (event) {
		if (event.keyCode == 13){
			getSectionOrHazardLOV();
		}
	});
	
	$("txtSectionOrHazardCd").observe("change", function(){
		if($F("txtSectionOrHazardCd") != ""){
			 getSectionOrHazardLOV();
		}else{
			$("txtSectionOrHazardTitle").value = "";
		}
	});
	
	$("txtCapacityCd").observe("change", function(){
		if($F("txtCapacityCd") != ""){
			getCapacityLOV();
		}else{
			$("txtPosition").value = "";
		}
	});
	
	$("aiUpdateBtn").observe("click", function(){
		objQuote.addtlInfo = 'Y'; //robert 9.28.2012
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("additionalInformationSectionDiv");
		disableButton("aiUpdateBtn");
	});
	
</script>