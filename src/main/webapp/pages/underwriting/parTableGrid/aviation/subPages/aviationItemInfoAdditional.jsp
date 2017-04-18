<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

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
						<div style="float: left; border: solid 1px gray; width: 226px; height: 21px; margin-right: 3px;" class="required">
							<input type="hidden" id="vesselCd" name="vesselCd" />
							<input type="text" tabindex="6003" style="float: left; margin-top: 0px; margin-right: 3px; width: 196px; border: none;" name="txtVesselName" id="txtVesselName" readonly="readonly" class="required" />
							<img id="hrefAviationVessel" alt="goAviationVessel" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div> 
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
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editPurpose" />
						</div>
						<!-- <textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="purpose" name="purpose"></textarea> -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Excesses</td>
					<td class="leftAligned">
						<div style="border: 1px solid gray; height: 20px; width: 226px;">
							<textarea onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="deductText" name="deductText" style="width: 200px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editDeductText" />
						</div>
						<!-- <textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="deductText" name="deductText"></textarea> -->
					</td>
				</tr>
			</table>
		</div>
		<div id="aviationDiv2" style="float:left; width:50%; margin-top:10px; margin-bottom:10px;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" style="width: 33%;" for="prevUtilHrs">Previous Utilization</td>
					<td class="leftAligned">
						<!-- 
						<input style="width: 220px;" id="prevUtilHrs" name="prevUtilHrs" type="text" value="" maxlength="7" class="integer" errorMsg="Please enter valid number for Previous Utilization. Value must range from -999,999 to 999,999." />
						 -->
						<input style="width: 220px;" id="prevUtilHrs" name="prevUtilHrs" type="text" value="" maxlength="7" class="applyWholeNosRegExp" regExpPatt="nDigit06" min="1" max="999999" /> <!-- changed min value from -999999 to 1 -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned" for="estUtilHrs">Estimated Utilization</td>
					<td class="leftAligned">
						<!-- 
						<input style="width: 220px;" id="estUtilHrs" name="estUtilHrs" type="text" value="" maxlength="7" class="integer" errorMsg="Please enter valid number for Estimated Utilization. Value must range from -999,999 to 999,999." />
						 -->
						<input style="width: 220px;" id="estUtilHrs" name="estUtilHrs" type="text" value="" maxlength="7" class="applyWholeNosRegExp" regExpPatt="nDigit06" min="1" max="999999" /> <!-- changed min value from -999999 to 1 -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned" for="totalFlyTime">Fly Time</td>
					<td class="leftAligned">
						<!-- 
						<input style="width: 220px;" id="totalFlyTime" name="totalFlyTime" type="text" value="" maxlength="7" class="integer" errorMsg="Please enter valid number for Fly Time. Value must range from -999,999 to 999,999."/>
						 -->
						<input style="width: 220px;" id="totalFlyTime" name="totalFlyTime" type="text" value="" maxlength="7" class="applyWholeNosRegExp" regExpPatt="nDigit06" min="1" max="999999" /> <!-- changed min value from -999999 to 1 -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Qualification</td>
					<td class="leftAligned">
						<div class="required" style="border: 1px solid gray; height: 20px; width: 226px;">
							<textarea class="required" onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="qualification" name="qualification" style="width: 200px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editQualification" />
						</div>
						<!-- <textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="qualification" name="qualification"></textarea> -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Geography Limit</td>
					<td class="leftAligned">
						<div class="required" style="border: 1px solid gray; height: 20px; width: 226px;">
							<textarea class="required" onKeyDown="limitText(this, 200);" onKeyUp="limitText(this, 200);" id="geogLimit" name="geogLimit" style="width: 200px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editGeogLimit" />
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
<script type="text/javascript">
try{
	function selectAviationVessel(){
		try{
			var notIn = "";
			var withPrevious = false;			

			var objArrFiltered = objGIPIWItem.filter(function(o){	return nvl(o.recordStatus, 0) != -1 && o.gipiWAviationItem != null;	});

			for(var i=0, length=objArrFiltered.length; i < length; i++){			
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + objArrFiltered[i].gipiWAviationItem.vesselCd + "'";
				withPrevious = true;
			}
			
			notIn = (notIn != "" ? "("+notIn+")" : "");
			
			showAviationVesselLOV(notIn);
		}catch(e){
			showErrorMessage("selectAviationVessel", e);
		}
	}
	$("hrefAviationVessel").observe("click", selectAviationVessel);
	
	$("txtVesselName").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("vesselCd").value = "";
			$("airType").value 	= "";
			$("rpcNo").value	= "";
		}
	});
	
	$("editPurpose").observe("click", function() {
		showOverlayEditor("purpose", 200, $("purpose").hasAttribute("readonly"));
	});
	
	$("editDeductText").observe("click", function() {
		showOverlayEditor("deductText", 200, $("deductText").hasAttribute("readonly"));
	});
	
	$("editQualification").observe("click", function() {
		showOverlayEditor("qualification", 200, $("qualification").hasAttribute("readonly"));
	});
	
	$("editGeogLimit").observe("click", function() {
		showOverlayEditor("geogLimit", 200, $("geogLimit").hasAttribute("readonly"));
	});
	
	/* $("editPurpose").observe("click", function(){
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
	}); */

	observeChangeTagOnDate("editPurpose", "purpose");
	observeChangeTagOnDate("editDeductText", "deductText");
	observeChangeTagOnDate("editQualification", "qualification");
	observeChangeTagOnDate("editGeogLimit", "geogLimit");	

	$("recFlag").value = "A";
	$("recFlagAv").value = "A";
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Additional Page", e);
}
</script>