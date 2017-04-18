<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<div id="additionalInformationDiv" name="additionalInformationDiv" style="display:none;">
<div id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" class="sectionDiv optionalInformation"  style="display:none;">
	<form id="aviationAdditionalInformationForm" name="aviationAdditionalInformationForm">
		<table align="center" style="width: 50%; margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned" style="width: 120px;">Aircraft Name</td>
				<td class="leftAligned">
					<input type="hidden" id="txtRecFlagAv" 	name="txtRecFlagAv" value=""/>
					<select id="selVessel" name="selVessel" style="width: 198px;" class="required aiInput">
						<option value="" vesselCd="" vesselName="" vesselOldName="" vesselFlag=""
									rpcNo="" airTypeCd="" airDesc="" noOfPass=""></option>
						<c:forEach var="aircraft" items="${aircrafts }" varStatus="status">
							<option value="${aircraft.vesselCd }"
									vesselCd="${aircraft.vesselCd }"
									vesselName="${aircraft.vesselName }"
									vesselOldName="${aircraft.vesselOldName }"
									vesselFlag="${aircraft.vesselFlag }"
									rpcNo="${aircraft.rpcNo }"
									airTypeCd="${aircraft.airTypeCd }"
									airDesc="${aircraft.airDesc }"
									noOfPass="${aircraft.noOfPass }">${aircraft.vesselName }</option>
						</c:forEach>
					</select>
					<div style="display: none;" id="vessels" name="vessels">
						<json:object>
							<json:array name="vessels" var="v" items="${aircrafts}">
								<json:object>
									<json:property name="vesselCd" value="${v.vesselCd}" />
									<json:property name="vesselName" value="${v.vesselName}" />
									<json:property name="vesselOldName" value="${v.vesselOldName}" />
									<json:property name="vesselFlag" value="${v.vesselFlag}" />
									<json:property name="rpcNo" value="${v.rpcNo}" />
									<json:property name="airTypeCd" value="${v.airTypeCd}" />
									<json:property name="airDesc" value="${v.airDesc}" />
									<json:property name="noOfPass" value="${v.noOfPass}" />
								</json:object>
							</json:array>
						</json:object>
					</div>
				</td>
				<td class="rightAligned" style="width: 150px;">Previous Utilization</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px;" id="txtPrevUtilHrs" name="txtPrevUtilHrs" <fmt:formatNumber value="${vessel.prevUtilHrs}" pattern="######"></fmt:formatNumber> maxlength="6" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Air Type</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px;" id="txtAirType" name="txtAirType" readonly="readonly" />
					<input type="hidden" id="txtAirTypeCd" name="txtAirTypeCd" /></td>
				<td class="rightAligned">Estimated Utilization</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px;" id="txtEstUtilHrs" name="txtEstUtilHrs" <fmt:formatNumber value="${vessel.estUtilHrs}" pattern="######"></fmt:formatNumber> maxlength="6" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">RPC No.</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px;" id="txtRpcNo" name="txtRpcNo" readonly="readonly" />
				</td>
				<td class="rightAligned">Fly Time</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px;" id="txtTotalFlyTime" name="txtTotalFlyTime" <fmt:formatNumber value="${vessel.totalFlyTime}" pattern="######"></fmt:formatNumber> maxlength="6" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="margin-top: 20px;">Purpose</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="txtPurpose" name="txtPurpose" style="width: 550px;" value="${vessel.purpose}" maxlength="200" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Qualification</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="txtQualification" name="txtQualification" style="width: 550px;" value="${vessel.qualification}" maxlength="200" class="aiInput"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Excess</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="txtDeductText" name="txtDeductText" style="width: 550px;" value="${vessel.deductText}" maxlength="200" class="aiInput" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Geography Limit</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="txtGeogLimit" name="txtGeogLimit" style="width: 550px;" value="${vessel.geogLimit}" maxlength="200" class="aiInput"/>
				</td>
			</tr>
		</table>
		<div style="margin-left: auto; margin-right: auto; margin-bottom: 20px;">
			<input type="button" id="aiAVUpdateBtn" name="aiAVUpdateBtn" value="Apply Changes" class="disabledButton"/> <!-- edited by steven 11/7/2012 binago ko ung id niya kasi parehas siya sa ibang jsp na tinatawag dito kaya nag-eerror ung function --> 
		</div>
		
	</form>
</div>
</div>
<script type="text/javascript">
try{
	initializeAll();

	var aircrafts = ($("vessels").innerHTML).evalJSON();

	$("selVessel").observe("change", function(){ 
		getVesselDetails(); 
	});

	function getVesselDetails() {
		if ($("selVessel").selectedIndex > 0){
			$("txtAirType").value = aircrafts.vessels[$("selVessel").selectedIndex-1].airDesc;
			$("txtAirTypeCd").value = aircrafts.vessels[$("selVessel").selectedIndex-1].airTypeCd;
			$("txtRpcNo").value = aircrafts.vessels[$("selVessel").selectedIndex-1].rpcNo;
		} else {
			$("txtAirType").value = "";
			$("txtAirTypeCd").value = "";
			$("txtRpcNo").value = "";
		}
	}

	getVesselDetails();

	$("txtPrevUtilHrs").observe("blur", function(){
		if ($F("txtPrevUtilHrs") != ""){
			if ($("txtPrevUtilHrs").value.length != 1){
				$("txtPrevUtilHrs").value = parseInt(($("txtPrevUtilHrs").value.replace(/^[0]+/g,"")).trim());
			}
			isWithinBounds("txtPrevUtilHrs", 0, 999999, "Invalid Previous Utilization. Value should be an integer within 0 and 999999.", false);
		}
	});
	
	$("txtEstUtilHrs").observe("blur", function(){
		if ($F("txtEstUtilHrs") != ""){
			if ($("txtEstUtilHrs").value.length != 1){
				$("txtEstUtilHrs").value = parseInt(($("txtEstUtilHrs").value.replace(/^[0]+/g,"")).trim());
			}	
			isWithinBounds("txtEstUtilHrs", 0, 999999, "Invalid Estimated Utilization. Value should be an integer within 0 and 999999.", false);
		}
	});
	
	$("txtTotalFlyTime").observe("blur", function(){
		if ($F("txtTotalFlyTime") != ""){
			if ($("txtTotalFlyTime").value.length != 1){
				$("txtTotalFlyTime").value = parseInt(($("txtTotalFlyTime").value.replace(/^[0]+/g,"")).trim());
			}
			isWithinBounds("txtTotalFlyTime", 0, 999999, "Invalid Fly Time. Value should be an integer within 0 and 999999.", false);
		}
	});
	
	initializeAiType("aiAVUpdateBtn");
	
	$("aiAVUpdateBtn").observe("click", function(){
		if ($("selVessel").value.blank()){
			customShowMessageBox(objCommonMessage.REQUIRED, "E", "selVessel");
		}else{
			fireEvent($("btnAddItem"), "click");
			clearChangeAttribute("additionalInformationSectionDiv");
		}
	});
	
}catch(e){
	showErrorMessage("Error caught in aviation additional Information", e);
}	
</script>