<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">	
	<div id="message" style="display:none;">${message}</div>
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;" masterDetail="true">
		<div id="aviationDiv1" style="float:left; width:50%; margin-top:10px; margin-bottom:10px;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" style="width: 130px;">Aircraft Name</td>
					<td class="leftAligned" style="width: 180px;">
						<select id="vesselCd" name="vesselCd" style="width: 228px;" class="required">
							<option value=""></option>
							<c:forEach var="vessel" items="${vesselListing}">
								<option airDesc="${vessel.airDesc }" rpcNo="${vessel.rpcNo }" value="${vessel.vesselCd}">${vessel.vesselName}</option>				
							</c:forEach>
						</select>
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
						<textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="purpose" name="purpose"></textarea>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Excesses</td>
					<td class="leftAligned">
						<textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="deductText" name="deductText"></textarea>
					</td>
				</tr>
			</table>
		</div>
		<div id="aviationDiv2" style="float:left; width:50%; margin-top:10px; margin-bottom:10px;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" style="width: 33%;">Previous Utilization</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="prevUtilHrs" name="prevUtilHrs" type="text" value="" maxlength="7" class="integer" errorMsg="Please enter valid number for Previous Utilization. Value must range from -999,999 to 999,999." />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Estimated Utilization</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="estUtilHrs" name="estUtilHrs" type="text" value="" maxlength="7" class="integer" errorMsg="Please enter valid number for Estimated Utilization. Value must range from -999,999 to 999,999." />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Fly Time</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="totalFlyTime" name="totalFlyTime" type="text" value="" maxlength="7" class="integer" errorMsg="Please enter valid number for Fly Time. Value must range from -999,999 to 999,999."/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Qualification</td>
					<td class="leftAligned">
						<textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="qualification" name="qualification"></textarea>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Geography Limit</td>
					<td class="leftAligned">
						<textarea onKeyDown="limitText(this,200);" onKeyUp="limitText(this,200);" rows="2" cols="1" style="width: 220px;" id="geogLimit" name="geogLimit"></textarea>
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
					<input type="button" id="btnAdd" 	class="button" 			value="Add" />
					<input type="button" id="btnDelete" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	$("vesselCd").observe("change", function ()	{
    	$("airType").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("airDesc");
    	$("rpcNo").value = $("vesselCd").options[$("vesselCd").selectedIndex].getAttribute("rpcNo");
	});

	$("prevUtilHrs").observe("blur", function () {
		if (parseInt($F("prevUtilHrs").replace(/,/g, "")) < -999999 || parseInt($F("prevUtilHrs").replace(/,/g, "")) > 999999){
			showMessageBox("Please enter valid number for Previous Utilization. Value must range from -999,999 to 999,999.",imgMessage.ERROR);
			$("prevUtilHrs").value = "";
			return false;
		}
	});

	$("estUtilHrs").observe("blur", function () {
		if (parseInt($F("estUtilHrs").replace(/,/g, "")) < -999999 || parseInt($F("estUtilHrs").replace(/,/g, "")) > 999999){
			showMessageBox("Please enter valid number for Estimated Utilization. Value must range from -999,999 to 999,999.",imgMessage.ERROR);
			$("estUtilHrs").clear();
			return false;
		}
	});

	$("totalFlyTime").observe("blur", function () {
		if (parseInt($F("totalFlyTime").replace(/,/g, "")) < -999999 || parseInt($F("totalFlyTime").replace(/,/g, "")) > 999999){
			showMessageBox("Please enter valid number for Fly Time. Value must range from -999,999 to 999,999.",imgMessage.ERROR);
			$("totalFlyTime").clear();
			return false;
		}
	});

	if ($F("globalParType") == "P"){
		$("recFlag").value = "A";
		$("recFlagAv").value = "A";
		$("qualification").addClassName("required");
		$("geogLimit").addClassName("required");
	} else if ($F("globalParType") == "E"){
		$("vesselCd").observe("change", function ()	{
			new Ajax.Request(contextPath + "/GIPIWAviationItemController?", {
				method : "POST",
				parameters: {
					action : "preCommitAviationItem",
					itemNo : $F("itemNo"),
					vesselCd : $F("vesselCd"),
					globalParId : $F("globalParId")
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : 
					function(){
						hideNotice("Getting Rec Flag for Endt, please wait...");
					},
				onComplete :
					function(response){
						hideNotice("");
						if (checkErrorOnResponse(response)) {		
							if (response.responseText == "A"){		
								$("recFlag").value = "A";
								$("recFlagAv").value = "A";
								$("qualification").addClassName("required");
								$("geogLimit").addClassName("required");
							} else if (response.responseText == "C"){
								$("recFlag").value = "C";
								$("recFlagAv").value = "C";
								$("qualification").removeClassName("required");
								$("geogLimit").removeClassName("required");
							}
						}
					}
			});
		});	
	}	
</script>	