<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;" >
	<div id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" class="sectionDiv">
		<form id="aviationAdditionalInformationForm" name="aviationAdditionalInformationForm">
			<div id="aviationDiv1" style="float:left; width:50%; margin-top:10px; margin-bottom:10px;">		
				<table align="center" cellspacing="1" border="0" width="100%">
					<tr>
						<td class="rightAligned" style="width: 130px;">Aircraft Name</td>
						<td class="leftAligned" style="width: 180px;">						
							<div style="float: left; border: solid 1px gray; width: 226px; height: 21px; margin-right: 3px; background-color: #FFFACD" >
								<input type="hidden" id="txtVesselCd" name="txtVesselCd" />
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 196px; border: none; height: 15px;" name="txtVesselName" id="txtVesselName"  class="required aiInput" tabindex="301" readonly="readonly"/>
								<img id="hrefAviationVessel" alt="goAviationVessel" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="302"/>						
							</div> 
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Air Type</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="txtAirType" name="txtAirType" type="text" value="" maxlength="20" readonly="readonly" class="aiInput" tabindex="303"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">RPC No.</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="txtRpcNo" name="txtRpcNo" type="text" value="" maxlength="15" readonly="readonly" class="aiInput" tabindex="304"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Purpose</td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 226px;">
								<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="txtPurpose" name="txtPurpose" style="width: 200px; border: none; height: 13px;" class="aiInput" tabindex="305"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editPurpose" tabindex="306"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Excesses</td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 226px;">
								<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="txtDeductText" name="txtDeductText" style="width: 200px; border: none; height: 13px;" class="aiInput" tabindex="307"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editDeductText" tabindex="308"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div id="aviationDiv2" style="float:left; width:50%; margin-top:10px;">		
				<table align="center" cellspacing="1" border="0" width="100%">
					<tr>
						<td class="rightAligned" style="width: 33%;" for="prevUtilHrs">Previous Utilization</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="txtPrevUtilHrs" name="txtPrevUtilHrs" type="text" value="" maxlength="7" class="applyWholeNosRegExp aiInput" regExpPatt="nDigit06" min="-999999" max="999999" tabindex="309"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" for="estUtilHrs">Estimated Utilization</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="txtEstUtilHrs" name="txtEstUtilHrs" type="text" value="" maxlength="7" class="applyWholeNosRegExp aiInput" regExpPatt="nDigit06" min="-999999" max="999999" tabindex="310"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" for="totalFlyTime">Fly Time</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="txtTotalFlyTime" name="txtTotalFlyTime" type="text" value="" maxlength="7" class="applyWholeNosRegExp aiInput" regExpPatt="nDigit06" min="-999999" max="999999" tabindex="311"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Qualification</td>
						<td class="leftAligned">
							<div  style="border: 1px solid gray; height: 20px; width: 226px;">
								<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="txtQualification" name="txtQualification" style="width: 200px; border: none; height: 13px;" class="aiInput" tabindex="312"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editQualification" tabindex="313"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Geography Limit</td>
						<td class="leftAligned">
							<div  style="border: 1px solid gray; height: 20px; width: 226px;">
								<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="txtGeogLimit" name="txtGeogLimit" style="width: 200px; border: none; height: 13px;" class="aiInput" tabindex="314"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editGeogLimit"tabindex="315"/>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" name="recFlagAv" id="recFlagAv" value="" />
						</td>
					</tr>
				</table>			
			</div>
			<div class="buttonsDiv" style="margin-bottom: 10px;">
				<input type="button" id="aiUpdateBtn" name="aiUpdateBtn" value="Apply Changes" class="disabledButton" tabindex="316"/>
			</div>
		</form>
	</div>
</div>
<script>
	initializeAll();
	initializeAiType("aiUpdateBtn");
	initializeChangeAttribute();
	$("aiUpdateBtn").observe("click", function(){
		objQuote.addtlInfo = 'Y'; //robert 9.28.2012
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("additionalInformationSectionDiv");
		disableButton("aiUpdateBtn");
	});
	
	//$("hrefAviationVessel").observe("click", getAircraftNameLOV);
	$("hrefAviationVessel").observe("click", prepareAircraftNameNotInParam);
	
	$("hrefAviationVessel").observe("keypress", function (event) {
		if (event.keyCode == 13){
			//getAircraftNameLOV();
			prepareAircraftNameNotInParam();
		}
	});
	
	$("editPurpose").observe("click", function(){
		showEditor("txtPurpose", 200);
	});
	
	$("editPurpose").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtPurpose", 200);
		}
	});
	
	$("editDeductText").observe("click", function(){
		showEditor("txtDeductText", 200);
	});
	
	$("editDeductText").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtDeductText", 200);
		}
	});
	
	$("editQualification").observe("click", function(){
		showEditor("txtQualification", 200);
	});
	
	$("editQualification").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtQualification", 200);
		}
	});

	$("editGeogLimit").observe("click", function(){
		showEditor("txtGeogLimit", 200);
	});
	
	$("editGeogLimit").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtGeogLimit", 200);
		}
	});
	
	function prepareAircraftNameNotInParam(){
		var notIn = "";
		var withPrevious = false;
		var avArray = (objQuote.itemInfo).filter(function(o){ return nvl(o.recordStatus, 0) != -1 && nvl(o.gipiQuoteAVItem.vesselCd, "") != "";});
		if(avArray.length > 0){
			for(var i=0; i<avArray.length; i++){
				notIn += withPrevious ? "," : "";
				notIn += "'" + avArray[i].gipiQuoteAVItem.vesselCd + "'";
				withPrevious = true;
			}
		}
		getAircraftNameLOV2(notIn);
	}
	
	//added by christian 03/09/13
	$("txtPrevUtilHrs").observe("change", function(){
		if ($F("txtPrevUtilHrs") != ""){
			if ($("txtPrevUtilHrs").value.length != 1){
				$("txtPrevUtilHrs").value = parseInt(($("txtPrevUtilHrs").value.replace(/^[0]+/g,"")).trim());
			}
			isWithinBounds("txtPrevUtilHrs", 0, 999999, "Invalid Previous Utilization. Value should be an integer within 0 and 999999.", false);
		}
	});
	
	$("txtEstUtilHrs").observe("change", function(){
		if ($F("txtEstUtilHrs") != ""){
			if ($("txtEstUtilHrs").value.length != 1){
				$("txtEstUtilHrs").value = parseInt(($("txtEstUtilHrs").value.replace(/^[0]+/g,"")).trim());
			}	
			isWithinBounds("txtEstUtilHrs", 0, 999999, "Invalid Estimated Utilization. Value should be an integer within 0 and 999999.", false);
		}
	});
	
	$("txtTotalFlyTime").observe("change", function(){
		if ($F("txtTotalFlyTime") != ""){
			if ($("txtTotalFlyTime").value.length != 1){
				$("txtTotalFlyTime").value = parseInt(($("txtTotalFlyTime").value.replace(/^[0]+/g,"")).trim());
			}
			isWithinBounds("txtTotalFlyTime", 0, 999999, "Invalid Fly Time. Value should be an integer within 0 and 999999.", false);
		}
	});
	
</script>