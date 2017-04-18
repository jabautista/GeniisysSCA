<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin:0px; margin-bottom:1px;">
		<div id="aviationDiv1" style="float:left; width:50%; margin-top:10px; margin-bottom:10px;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" style="width: 130px;">Aircraft Name</td>
					<td class="leftAligned" style="width: 180px;">
						<select id="vesselCd" name="vesselCd" style="width: 228px;" class="required">
							<option airDesc="" rpcNo="" value=""></option>
							<c:forEach var="vessel" items="${vesselListing}">
								<option airDesc="${fn:escapeXml(vessel.airDesc) }" rpcNo="${vessel.rpcNo }" value="${vessel.vesselCd}">${fn:escapeXml(vessel.vesselName)}</option>				
							</c:forEach>
						</select>
						<input type="hidden" id="txtVesselName" name="txtVesselName" value=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Air Type</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="airType" name="airType" type="text" value="" maxlength="20" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">RPC No.</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="rpcNo" name="rpcNo" type="text" value="" maxlength="15" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Purpose</td>
					<td class="leftAligned">
						<div style="border: 1px solid gray; height: 20px; width: 226px;">
							<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="purpose" name="purpose" style="width: 200px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editPurpose" />
						</div>
						<!-- <textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="purpose" name="purpose"></textarea> -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Excesses</td>
					<td class="leftAligned">
						<div style="border: 1px solid gray; height: 20px; width: 226px;">
							<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="deductText" name="deductText" style="width: 200px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editDeductText" />
						</div>
						<!-- <textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="deductText" name="deductText"></textarea> -->
					</td>
				</tr>
			</table>
		</div>
		<div id="aviationDiv2" style="float:left; width:50%; margin-top:10px; margin-bottom:10px;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" style="width: 33%;">Previous Utilization</td>
					<td class="leftAligned">
						<!-- changed error message and based it to GIPIS019
							 from Please enter valid number for Previous Utilization. Value must range from -999,999 to 999,999.
							 to Invalid Previous Utilization. Valid value should be from 1 to 999999.
							 reymon 03122013 -->
						<input style="width: 220px;" id="prevUtilHrs" name="prevUtilHrs" type="text" value="" maxlength="7" class="integer" errorMsg="Invalid Previous Utilization. Valid value should be from 1 to 999999." />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Estimated Utilization</td>
					<td class="leftAligned">
						<!-- changed error message and based it to GIPIS019
							 from Please enter valid number for Estimated Utilization. Value must range from -999,999 to 999,999.
							 to Invalid Estimated Utilization. Valid value should be from 1 to 999999.
							 reymon 03122013 -->
						<input style="width: 220px;" id="estUtilHrs" name="estUtilHrs" type="text" value="" maxlength="7" class="integer" errorMsg="Invalid Estimated Utilization. Valid value should be from 1 to 999999." />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Fly Time</td>
					<td class="leftAligned">
						<!-- changed error message and based it to GIPIS019
							 from Please enter valid number for Fly Time. Value must range from -999,999 to 999,999.
							 to Invalid Fly Time. Valid value should be from 1 to 999999.
							 reymon 03122013 -->
						<input style="width: 220px;" id="totalFlyTime" name="totalFlyTime" type="text" value="" maxlength="7" class="integer" errorMsg="Please enter valid number for Fly Time. Value must range from -999,999 to 999,999."/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Qualification</td>
					<td class="leftAligned">
						<div class="required" style="border: 1px solid gray; height: 20px; width: 226px;">
							<textarea class="required" onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="qualification" name="qualification" style="width: 200px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editQualification" />
						</div>
						<!-- <textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="qualification" name="qualification"></textarea> -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Geography Limit</td>
					<td class="leftAligned">
						<div class="required" style="border: 1px solid gray; height: 20px; width: 226px;">
							<textarea class="required" onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="geogLimit" name="geogLimit" style="width: 200px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editGeogLimit" />
						</div>
						<!-- <textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="geogLimit" name="geogLimit"></textarea> -->
					</td>
				</tr>
				<tr>
					<td>
						<input type="hidden" name="recFlagAv" id="recFlagAv" value="" />
					</td>
				</tr>
			</table>			
		</div>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAddItem" 	class="button" 			value="Add" />
					<input type="button" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	$("editPurpose").observe("click", function(){
		showEditor("purpose", 200);
	});
	
	$("editDeductText").observe("click", function(){
		showEditor("deductText", 200);
	});
	
	$("editQualification").observe("click", function(){
		showEditor("qualification", 200);
	});

	$("editGeogLimit").observe("click", function(){
		showEditor("geogLimit", 200);
	});

	observeChangeTagOnDate("editPurpose", "purpose");
	observeChangeTagOnDate("editDeductText", "deductText");
	observeChangeTagOnDate("editQualification", "qualification");
	observeChangeTagOnDate("editGeogLimit", "geogLimit");
	
	$("vesselCd").observe("change", function ()	{
    	$("airType").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("airDesc");
    	$("rpcNo").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("rpcNo");
    	$("txtVesselName").value = $("vesselCd").options[$("vesselCd").selectedIndex].text;
	});

	$("prevUtilHrs").observe("blur", function () {
		//replace -999999 to 1 reymon 02262013
		if (parseInt($F("prevUtilHrs").replace(/,/g, "")) < 1 || parseInt($F("prevUtilHrs").replace(/,/g, "")) > 999999){
			//changed message reymon 03122013
			//showMessageBox("Please enter valid number for Previous Utilization. Value must range from -999,999 to 999,999.",imgMessage.ERROR);
			showMessageBox("Invalid Previous Utilization. Valid value should be from 1 to 999999.",imgMessage.ERROR);
			$("prevUtilHrs").clear();
			return false;
		}
	});

	$("estUtilHrs").observe("blur", function () {
		//replace -999999 to 1 reymon 02262013
		if (parseInt($F("estUtilHrs").replace(/,/g, "")) < 1 || parseInt($F("estUtilHrs").replace(/,/g, "")) > 999999){
			//changed message reymon 03122013
			//showMessageBox("Please enter valid number for Estimated Utilization. Value must range from -999,999 to 999,999.",imgMessage.ERROR);
			showMessageBox("Invalid Estimated Utilization. Valid value should be from 1 to 999999.",imgMessage.ERROR);
			$("estUtilHrs").clear();
			return false;
		}
	});

	$("totalFlyTime").observe("blur", function () {
		//replace -999999 to 1 reymon 02262013
		if (parseInt($F("totalFlyTime").replace(/,/g, "")) < 1 || parseInt($F("totalFlyTime").replace(/,/g, "")) > 999999){
			//changed message reymon 03122013
			//showMessageBox("Please enter valid number for Fly Time. Value must range from -999,999 to 999,999.",imgMessage.ERROR);
			showMessageBox("Invalid Fly Time. Valid value should be from 1 to 999999.",imgMessage.ERROR);
			$("totalFlyTime").clear();
			return false;
		}
	});

	$("recFlag").value = "A";
	$("recFlagAv").value = "A";

</script>