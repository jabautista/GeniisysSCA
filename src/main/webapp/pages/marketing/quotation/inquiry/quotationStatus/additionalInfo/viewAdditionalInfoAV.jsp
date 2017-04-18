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
							<input type="hidden" id="txtVesselCd" name="txtVesselCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 220px; height: 15px;" name="txtVesselName" id="txtVesselName"  class="aiInput" tabindex="301" readonly="readonly"/>
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
								<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="txtPurpose" name="txtPurpose" style="width: 200px; border: none; height: 13px;" class="aiInput" tabindex="305" readonly="readonly"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editPurpose" tabindex="306"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Excesses</td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 226px;">
								<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="txtDeductText" name="txtDeductText" style="width: 200px; border: none; height: 13px;" class="aiInput" tabindex="307" readonly="readonly"></textarea>
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
							<input style="width: 220px;" id="txtPrevUtilHrs" name="txtPrevUtilHrs" type="text" value="" maxlength="7" class="applyWholeNosRegExp aiInput" regExpPatt="nDigit06" min="-999999" max="999999" tabindex="309" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" for="estUtilHrs">Estimated Utilization</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="txtEstUtilHrs" name="txtEstUtilHrs" type="text" value="" maxlength="7" class="applyWholeNosRegExp aiInput" regExpPatt="nDigit06" min="-999999" max="999999" tabindex="310" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" for="totalFlyTime">Fly Time</td>
						<td class="leftAligned">
							<input style="width: 220px;" id="txtTotalFlyTime" name="txtTotalFlyTime" type="text" value="" maxlength="7" class="applyWholeNosRegExp aiInput" regExpPatt="nDigit06" min="-999999" max="999999" tabindex="311" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Qualification</td>
						<td class="leftAligned">
							<div  style="border: 1px solid gray; height: 20px; width: 226px;">
								<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="txtQualification" name="txtQualification" style="width: 200px; border: none; height: 13px;" class="aiInput" tabindex="312" readonly="readonly"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editQualification" tabindex="313"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Geography Limit</td>
						<td class="leftAligned">
							<div  style="border: 1px solid gray; height: 20px; width: 226px;">
								<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="txtGeogLimit" name="txtGeogLimit" style="width: 200px; border: none; height: 13px;" class="aiInput" tabindex="314" readonly="readonly"></textarea>
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
		</form>
	</div>
</div>
<script type="text/javascript">
	$("editPurpose").observe("click", function(){
		showEditor("txtPurpose", 200, "true");
	});
	
	$("editPurpose").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtPurpose", 200, "true");
		}
	});
	
	$("editDeductText").observe("click", function(){
		showEditor("txtDeductText", 200, "true");
	});
	
	$("editDeductText").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtDeductText", 200, "true");
		}
	});
	
	$("editQualification").observe("click", function(){
		showEditor("txtQualification", 200, "true");
	});
	
	$("editQualification").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtQualification", 200, "true");
		}
	});
	
	$("editGeogLimit").observe("click", function(){
		showEditor("txtGeogLimit", 200, "true");
	});
	
	$("editGeogLimit").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtGeogLimit", 200, "true");
		}
	});
</script>