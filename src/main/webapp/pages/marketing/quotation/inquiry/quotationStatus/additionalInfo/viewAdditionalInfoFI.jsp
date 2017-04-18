<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-cache");
%>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv" style="display: none;">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px; padding-bottom: 15px;">
		<input type="hidden" id="region">
		<form name="fireAiForm">
			<table id="fireTable" width="920px" cellspacing="1" border="0">
				<tr><td colspan="6"><br /></td></tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Assignee </td>
					<td class="leftAligned" style="width: 185px;">
						<input type="text" readonly="readonly" style="width: 175px; padding: 2px;" name="txtAssignee" id="txtAssignee" maxlength="30"class="aiInput" tabindex="301" />
					</td>
					<td class="rightAligned">EQ Zone </td>
					<td class="leftAligned" style="width: 185px;">
						<input type="hidden" id="eqZone" name="eqZone" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="eqZoneDesc" id="eqZoneDesc" readonly="readonly" value=""  class="aiInput" tabindex="316"/>
					</td>
					<td class="rightAligned" style="width: 100px;">From Date </td>
					<td class="leftAligned" style="width: 190px;">
						<input type="text" style="width: 173px; margin-top: 0px; float: left;" name=txtNbtFromDt id="txtNbtFromDt" readonly="readonly" tabindex="332"/>					
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Type </td>
					<td class="leftAligned">
							<input type="hidden" id="txtFrItemType" name="txtFrItemType" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtDspFrItemType" id="txtDspFrItemType" readonly="readonly" value="" class="aiInput"tabindex="302"/>
					</td>
					<td class="rightAligned">Typhoon Zone </td>
					<td class="leftAligned">
						<input type="hidden" id="typhoonZone" name="typhoonZone" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="typhoonZoneDesc" id="typhoonZoneDesc" readonly="readonly" value="" class="aiInput" tabindex="318"/>
					</td>
					<td class="rightAligned" style="width: 100px;">To Date </td>
					<td class="leftAligned">
						<input type="text" style="width: 173px; margin-top: 0px; float: left;" name="txtNbtToDt" id="txtNbtToDt" readonly="readonly" value="${toDate}" tabindex="334"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Province </td>
					<td class="leftAligned">
						<input type="hidden" id="blockId" name="blockId" />
						<input type="hidden" id="provinceCd" name="provinceCd" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="province" id="province" readonly="readonly" value="" tabindex="304"/>
					</td>
					<td class="rightAligned">Flood Zone </td>
					<td class="leftAligned">
						<input type="hidden" id="floodZone" name="floodZone" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="floodZoneDesc" id="floodZoneDesc" readonly="readonly" value="" tabindex="320"/>
					</td>
					<td class="rightAligned" style="width: 100px; ">Location </td>
					<td class="leftAligned">
						<input type="text" style="width: 175px; padding: 2px;" name="txtLocRisk1" id="txtLocRisk1" maxlength="50"  class="aiInput" tabindex="336" readonly="readonly"/>
					</td>				
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">City </td>
					<td class="leftAligned">
						<input type="hidden" id="cityCd" name="cityCd" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="city" id="city" readonly="readonly" value="" tabindex="306"/>
					</td>
					<td class="rightAligned">Tariff Zone </td>
					<td class="leftAligned">
						<input type="hidden" id="txtTariffZone" name="txtTariffZone" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtDspTariffZone" id="txtDspTariffZone" readonly="readonly" value="" class="aiInput" tabindex="322"/>
					</td>
					<td class="rightAligned" style="width: 100px;">&nbsp; </td>
					<td class="leftAligned"><input type="text" style="width: 175px; padding: 2px;" name="txtLocRisk2" id="txtLocRisk2" maxlength="50"  class="aiInput" tabindex="337" readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">District </td>
					<td class="leftAligned">
						<input type="hidden" id="districtNo" name="districtNo" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="district" id="district" readonly="readonly" value=""  tabindex="308"/>
					</td>
					<td class="rightAligned">Tariff Code </td>
					<td class="leftAligned">					
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtTarfCd" id="txtTarfCd" readonly="readonly" value="" class="aiInput" tabindex="324"/>
					</td>
					<td class="rightAligned" style="width: 100px;">&nbsp; </td>
					<td class="leftAligned"><input type="text" style="width: 175px; padding: 2px;" name="txtLocRisk3" id="txtLocRisk3" maxlength="50" class="aiInput" tabindex="337" readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Block </td>
					<td class="leftAligned">
						<input type="hidden" id="blockNo" name="blockNo" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="block" id="block" readonly="readonly" tabindex="310"/>
					</td>
					<td class="rightAligned">Construction </td>
					<td class="leftAligned">
						<input type="hidden" id=txtConstructionCd name="txtConstructionCd" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="txtDspConstructionCd" id="txtDspConstructionCd" readonly="readonly" class="aiInput" tabindex="326"/>
					</td>
					<td class="rightAligned" style="width: 100px;">Boundary Front </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtFront" id="txtFront" class="aiInput" maxlength="2000" tabindex="338" readonly="readonly"/>
							<img id="hrefFront" alt="goFront" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="339"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Risks </td>
					<td class="leftAligned">
						<input type="hidden" id="riskCd" name="riskCd" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="risk" id="risk" readonly="readonly" tabindex="312"/>
					</td>
					<td class="rightAligned">Construction Remarks </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtConstructionRemarks" id="txtConstructionRemarks" class="aiInput" tabindex="328" readonly="readonly"/>
							<img id="hrefConstructionRemarks" alt="goConstructionRemarks" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="329"/>
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">Right </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtRight" id="txtRight" class="aiInput" maxlength="2000" tabindex="340" readonly="readonly"/>
							<img id="hrefRight" alt="goRight" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="341" />
						</div>
					</td>
				</tr>
				<tr>				
					<td class="rightAligned" style="width: 90px;">Occupancy </td>
					<td class="leftAligned">
						<input type="hidden" id="occupancyCd" name="occupancyCd" />
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 173px;" name="occupancy" id="occupancy" readonly="readonly" maxlength="2000" tabindex="314"/>
					</td>
					<td class="rightAligned">Occupancy Remarks </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtOccupancyRemarks" id="txtOccupancyRemarks"  class="aiInput" maxlength="2000" tabindex="330" readonly="readonly"/>
							<img id="hrefOccupancyRemarks" alt="goOccupancyRemarks" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="331"/>						
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">Left </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtLeft" id="txtLeft" class="aiInput" maxlength="2000" tabindex="342" readonly="readonly"/>
							<img id="hrefLeft" alt="goLeft" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="343"/>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>				
					<td class="rightAligned" style="width: 100px;">Rear </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtRear" id="txtRear" class="aiInput" maxlength="2000" tabindex="344" readonly="readonly"/>
							<img id="hrefRear" alt="goRear" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="345"/>						
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>

<script type="text/javascript">	
	$("hrefFront").observe("click", function() {
		showEditor("txtFront", 2000, "true");
	});
	
	$("hrefFront").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtFront", 2000, "true");
		}
	});

	$("hrefRight").observe("click", function() {
		showEditor("txtRight", 2000, "true");
	});
	
	$("hrefRight").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtRight", 2000, "true");
		}
	});

	$("hrefLeft").observe("click", function() {
		showEditor("txtLeft", 2000, "true");
	});
	
	$("hrefLeft").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtLeft", 2000, "true");
		}
	});

	$("hrefRear").observe("click", function() {
		showEditor("txtRear", 2000, "true");
	});
	
	$("hrefRear").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtRear", 2000, "true");
		}
	});

	$("hrefConstructionRemarks").observe("click", function() {
		showEditor("txtConstructionRemarks", 2000, "true");
	});
	
	$("hrefConstructionRemarks").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtConstructionRemarks", 2000, "true");
		}
	});

	$("hrefOccupancyRemarks").observe("click", function() {
		showEditor("txtOccupancyRemarks", 2000, "true");
	});
	
	$("hrefOccupancyRemarks").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtOccupancyRemarks", 2000, "true");
		}
	});
</script>