<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-cache");
%>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv" style="display: none;">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">
		<input type="hidden" id="region">
		<form name="fireAiForm">
			<table id="fireTable" width="920px" cellspacing="1" border="0">
				<tr><td colspan="6"><br /></td></tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Assignee </td>
					<td class="leftAligned" style="width: 185px;">
						<input type="text" style="width: 175px; padding: 2px;" name="txtAssignee" id="txtAssignee" maxlength="30"class="aiInput" tabindex="301" />
					</td>
					<td class="rightAligned">EQ Zone </td>
					<td class="leftAligned" style="width: 185px;">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="eqZone" name="eqZone" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="eqZoneDesc" id="eqZoneDesc" readonly="readonly" value=""  class="aiInput" tabindex="316"/>
							<img id="hrefEQZone" alt="goEQZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="317"/>
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">From Date </td>
					<td class="leftAligned" style="width: 190px;">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="text" style="width: 155px; border: none; margin-top: 0px; float: left;" name=txtNbtFromDt id="txtNbtFromDt" readonly="readonly" tabindex="332"/>					
			    			<img id="hrefFromDate" alt="Fire From Date" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtNbtFromDt'),this, null);" tabindex="333"/>
			    		</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Type </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="txtFrItemType" name="txtFrItemType" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtDspFrItemType" id="txtDspFrItemType" readonly="readonly" value="" class="aiInput"tabindex="302"/>
							<img id="hrefFrItemType" alt="goEQZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="303"/>
						</div>
					</td>
					<td class="rightAligned">Typhoon Zone </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="typhoonZone" name="typhoonZone" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="typhoonZoneDesc" id="typhoonZoneDesc" readonly="readonly" value="" class="aiInput" tabindex="318"/>
							<img id="hrefTyphoonZone" alt="goTyphoonZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="319"/>
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">To Date </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="text" style="width: 155px; border: none; margin-top: 0px; float: left;" name="txtNbtToDt" id="txtNbtToDt" readonly="readonly" value="${toDate}" tabindex="334"/>
							<img id="hrefToDate" alt="Fire To Date" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtNbtToDt'),this, null);" tabindex="335"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Province </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" >
							<input type="hidden" id="blockId" name="blockId" />
							<input type="hidden" id="provinceCd" name="provinceCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="province" id="province" readonly="readonly" value="" tabindex="304"/>
							<img id="hrefProvince" alt="goProvince" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="305"/>						
						</div>
					</td>
					<td class="rightAligned">Flood Zone </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="floodZone" name="floodZone" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="floodZoneDesc" id="floodZoneDesc" readonly="readonly" value="" tabindex="320"/>
							<img id="hrefFloodZone" alt="goFloodZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="321"/>						
						</div>
					</td>
					<td class="rightAligned" style="width: 100px; ">Location </td>
					<td class="leftAligned">
						<input type="text" style="width: 175px; padding: 2px;" name="txtLocRisk1" id="txtLocRisk1" maxlength="50"  class="aiInput" tabindex="336"/>
					</td>				
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">City </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" >
							<input type="hidden" id="cityCd" name="cityCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="city" id="city" readonly="readonly" value="" tabindex="306"/>
							<img id="hrefCity" alt="goCity" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="307"/>						
						</div>
					</td>
					<td class="rightAligned">Tariff Zone </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="txtTariffZone" name="txtTariffZone" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtDspTariffZone" id="txtDspTariffZone" readonly="readonly" value="" class="aiInput" tabindex="322"/>
							<img id="hrefTariffZone" alt="goEQZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="323"/>
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">&nbsp; </td>
					<td class="leftAligned"><input type="text" style="width: 175px; padding: 2px;" name="txtLocRisk2" id="txtLocRisk2" maxlength="50"  class="aiInput" tabindex="337"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">District </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" >
							<input type="hidden" id="districtNo" name="districtNo" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="district" id="district" readonly="readonly" value=""  tabindex="308"/>
							<img id="hrefDistrict" alt="goDistrict" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="309"/>												
						</div>
					</td>
					<td class="rightAligned">Tariff Code </td>
					<td class="leftAligned">					
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtTarfCd" id="txtTarfCd" readonly="readonly" value="" class="aiInput" tabindex="324"/>
							<img id="hrefTarfCd" alt="goEQZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="325"/>
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">&nbsp; </td>
					<td class="leftAligned"><input type="text" style="width: 175px; padding: 2px;" name="txtLocRisk3" id="txtLocRisk3" maxlength="50"  class="aiInput" tabindex="337"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Block </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" >
							<input type="hidden" id="blockNo" name="blockNo" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="block" id="block" readonly="readonly" tabindex="310"/>
							<img id="hrefBlock" alt="goBlock" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="311"/>						
						</div>
					</td>
					<td class="rightAligned">Construction </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id=txtConstructionCd name="txtConstructionCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtDspConstructionCd" id="txtDspConstructionCd" readonly="readonly" class="aiInput" tabindex="326"/> 
							<img id="hrefConstructionCd" alt="goEQZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="327"/>
						</div>
					</td>
					<!-- Added By MarkS SR-5918 02/02/2017 -->	
					<td class="rightAligned" style="width: 100px;">LAT </td>
					<td class="leftAligned"><input type="text" style="width: 64.2px; padding: 2px;" name="txtLatitude" id="txtLatitude" maxlength="50" class="aiInput" tabindex="337"/>
					LONG
					<input type="text" style="width: 64.3px; padding: 2px;" name="txtLongitude" id="txtLongitude" maxlength="50" class="aiInput" tabindex="337"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Risks </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="riskCd" name="riskCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="risk" id="risk" readonly="readonly" tabindex="312"/>
							<img id="hrefRisk" alt="goRisk" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="313"/>						
						</div>
					</td>
					<td class="rightAligned">Construction Remarks </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<!-- <input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtConstructionRemarks" id="txtConstructionRemarks" class="aiInput" tabindex="328"/>--><!-- commented out by jeffdojello 11.04.2013 -->
							<textarea name="txtConstructionRemarks" id="txtConstructionRemarks" style="width: 150px; border: none; height: 13px; resize: none;" class="aiInput" maxlength="2000" tabindex="328"></textarea> <!-- added by jeffdojello 11.04.2013 -->
							<img id="hrefConstructionRemarks" alt="goConstructionRemarks" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="329"/>
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">Boundary Front </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<!-- <input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtFront" id="txtFront" class="aiInput" maxlength="2000" tabindex="338"/>--><!-- commented out by jeffdojello 11.04.2013 -->
							<textarea name="txtFront" id="txtFront" style="width: 150px; border: none; height: 13px; resize: none;" class="aiInput" maxlength="2000" tabindex="338"></textarea> <!-- added by jeffdojello 11.04.2013 -->
							<img id="hrefFront" alt="goFront" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="339"/>
						</div>
					</td>
				</tr>
				<tr>				
					<td class="rightAligned" style="width: 90px;">Occupancy </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="occupancyCd" name="occupancyCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="occupancy" id="occupancy" readonly="readonly" maxlength="2000" tabindex="314"/>
							<img id="hrefOccupancy" alt="goOccupancy" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex="315"/>						
						</div>
					</td>
					<td class="rightAligned">Occupancy Remarks </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<!--<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtOccupancyRemarks" id="txtOccupancyRemarks"  class="aiInput" maxlength="2000" tabindex="330"/> --><!-- commented out by jeffdojello 11.04.2013 -->
							<textarea name="txtOccupancyRemarks" id="txtOccupancyRemarks" style="width: 150px; border: none; height: 13px; resize: none;" class="aiInput" maxlength="2000" tabindex="330"></textarea> <!-- added by jeffdojello 11.04.2013 -->
							<img id="hrefOccupancyRemarks" alt="goOccupancyRemarks" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="331"/>						
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">Right </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<!--<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtRight" id="txtRight" class="aiInput" maxlength="2000" tabindex="340"/>--><!-- commented out by jeffdojello 11.04.2013 -->
							<textarea  name="txtRight" id="txtRight" style="width: 150px; border: none; height: 13px; resize: none;" class="aiInput" maxlength="2000" tabindex="340"></textarea> <!-- added by jeffdojello 11.04.2013 -->
							<img id="hrefRight" alt="goRight" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="341" />
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>				
					<td class="rightAligned" style="width: 100px;">Left </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<!-- <input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtLeft" id="txtLeft" class="aiInput" maxlength="2000" tabindex="342"/>--><!-- commented out by jeffdojello 11.04.2013 -->
							<textarea name="txtLeft" id="txtLeft" style="width: 150px; border: none; height: 13px; resize: none;" class="aiInput" maxlength="2000" tabindex="342"></textarea> <!-- added by jeffdojello 11.04.2013 -->
							<img id="hrefLeft" alt="goLeft" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="343"/>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>				
					<td class="rightAligned" style="width: 100px;">Rear </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<!-- <input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="txtRear" id="txtRear" class="aiInput" maxlength="2000" tabindex="344"/>--><!-- commented out by jeffdojello 11.04.2013 -->
							<textarea name="txtRear" id="txtRear" style="width: 150px; border: none; height: 13px; resize: none;" class="aiInput" maxlength="2000" tabindex="344"></textarea> <!-- added by jeffdojello 11.04.2013 -->
							<img id="hrefRear" alt="goRear" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" tabindex="345"/>						
						</div>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" style="margin-bottom: 10px;">
				<input type="button" id="aiUpdateBtn" name="aiUpdateBtn" value="Apply Changes" class="disabledButton" tabindex="346"/>
			</div>
		</form>
	</div>
</div>

<script type="text/javascript">	

	$("hrefFromDate").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtNbtFromDt'),this, null);
		}
	});
	
	$("hrefToDate").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtNbtToDt'),this, null);
		}
	});
	
	$("hrefProvince").observe("click", showQuoteProvinceLOV);
	
	$("hrefProvince").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showQuoteProvinceLOV();
		}
	});
	
	$("hrefCity").observe("click", showQuoteCityLOV);
	
	$("hrefCity").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showQuoteCityLOV();
		}
	});
	
	$("hrefDistrict").observe("click", function() {
		showBlock("district");
	});
	
	$("hrefDistrict").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showBlock("district");
		}
	});
	
	$("hrefBlock").observe("click", function() {
		showBlock("block");
	});
	
	$("hrefBlock").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showBlock("block");
		}
	});
	
	$("hrefEQZone").observe("click", showEQZoneLOV);
	
	$("hrefEQZone").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEQZoneLOV();
		}
	});
	
	$("hrefTyphoonZone").observe("click", showTyphoonZoneLOV);
	
	$("hrefTyphoonZone").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showTyphoonZoneLOV();
		}
	});
	
	$("hrefFloodZone").observe("click", showFloodZoneLOV);
	
	$("hrefFloodZone").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showFloodZoneLOV();
		}
	});

	$("hrefRisk").observe("click", function() {
		showQuoteRiskLOV($F("blockId")); 
	});
	
	$("hrefRisk").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showQuoteRiskLOV($F("blockId")); 
		}
	});

	$("hrefOccupancy").observe("click", function() {
		showQuoteOccupancyLOV(); 
	});
	
	$("hrefOccupancy").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showQuoteOccupancyLOV(); 
		}
	});
	
	$("hrefTarfCd").observe("click", showTariffCodeLOV);
	
	$("hrefTarfCd").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showTariffCodeLOV(); 
		}
	});
	
	$("hrefTariffZone").observe("click", showTariffZoneLOV);
	
	$("hrefTariffZone").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showTariffZoneLOV(); 
		}
	});
	
	$("hrefConstructionCd").observe("click", showFireConstructionLOV);
	
	$("hrefConstructionCd").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showFireConstructionLOV(); 
		}
	});
	
	$("hrefFrItemType").observe("click", showFireItemTypeLOV);
	
	$("hrefFrItemType").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showFireItemTypeLOV(); 
		}
	});

	$("hrefFront").observe("click", function() {
		showEditor("txtFront", 2000);
	});
	
	$("hrefFront").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtFront", 2000);
		}
	});

	$("hrefRight").observe("click", function() {
		showEditor("txtRight", 2000);
	});
	
	$("hrefRight").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtRight", 2000);
		}
	});

	$("hrefLeft").observe("click", function() {
		showEditor("txtLeft", 2000);
	});
	
	$("hrefLeft").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtLeft", 2000);
		}
	});

	$("hrefRear").observe("click", function() {
		showEditor("txtRear", 2000);
	});
	
	$("hrefRear").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtRear", 2000);
		}
	});

	$("hrefConstructionRemarks").observe("click", function() {
		showEditor("txtConstructionRemarks", 2000);
	});
	
	$("hrefConstructionRemarks").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtConstructionRemarks", 2000);
		}
	});

	$("hrefOccupancyRemarks").observe("click", function() {
		showEditor("txtOccupancyRemarks", 2000);
	});
	
	$("hrefOccupancyRemarks").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtOccupancyRemarks", 2000);
		}
	});

	$("province").observe("keyup", function(event) {
		if (event.keyCode == 46) {
			$("provinceCd").value = "";
			$("province").value = "";
			$("cityCd").value = "";
			$("city").value = "";
			$("districtNo").value = "";
			$("district").value = "";
			$("blockId").value = "";
			$("block").value = "";
		}
	});

	$("city").observe("keyup", function(event) {
		if (event.keyCode == 46) {
			$("cityCd").value = "";
			$("city").value = "";
			$("districtNo").value = "";
			$("district").value = "";
			$("blockId").value = "";
			$("block").value = "";
		}
	});

	$("district").observe("keyup", function(event) {
		if (event.keyCode == 46) {
			$("districtNo").value = "";
			$("district").value = "";
			$("blockId").value = "";
			$("block").value = "";
		}
	});

	$("block").observe("keyup", function(event) {
		if (event.keyCode == 46) {
			$("blockId").value = "";
			$("block").value = "";
		}
	});

	$("txtFront").observe("keyup", function(event) {
		if (event.keyCode == 46) {
			$("txtFront").value = "";
		}
	});
	
	$("txtRight").observe("keyup", function(event) {
		if (event.keyCode == 46) {
			$("txtRight").value = "";
		}
	});
	
	$("txtLeft").observe("keyup", function(event) {
		if (event.keyCode == 46) {
			$("txtLeft").value = "";
		}
	});
	
	$("txtRear").observe("keyup", function(event) {
		if (event.keyCode == 46) {
			$("txtRear").value = "";
		}
	});
	
	function showBlock(column){
		var regionCd	= $F("region");
		var provinceCd 	= $F("provinceCd");
		var cityCd 		= $F("cityCd");
		var districtNo 	= $F("districtNo");
		
		showQuoteDistrictBlock(regionCd, provinceCd, cityCd, districtNo);
	}
	
	//added by robert 11.18.2014
	function validateFromDate(){
		if(!($F("txtNbtFromDt").empty())){
			var inceptDate 	= makeDate(objGIPIQuote.strInceptDate);
			var expiryDate 	= makeDate(objGIPIQuote.strExpiryDate);
			var fromDate 	= makeDate($F("txtNbtFromDt"));
			var toDate		= makeDate($F("txtNbtToDt"));

			if(fromDate > expiryDate){
				$("txtNbtFromDt").value = (((objGIPIQuote.strInceptDate).split(" "))[0]);
				customShowMessageBox("Start date should not be later than the expiry date. " +
						"Will copy incept date value from basic information.", imgMessage.INFO, "hrefFromDate");				
			}else if(fromDate < inceptDate){
				$("txtNbtFromDt").value = (((objGIPIQuote.strInceptDate).split(" "))[0]);
				customShowMessageBox("Start date should not be earlier than the inception date. " +
						"Will copy incept date value from basic information.", imgMessage.INFO, "hrefFromDate");
			}else if(!($F("txtNbtToDt").empty()) && fromDate > toDate){
				$("txtNbtFromDt").value = (((objGIPIQuote.strInceptDate).split(" "))[0]);
				customShowMessageBox("Start date should not be later than the end date. " +
						"Will copy incept date value from basic information.", imgMessage.INFO, "hrefFromDate");
			}
		}
	}
    
    function validateToDate(){
		if(!($F("txtNbtToDt").empty())){
			var inceptDate 	= makeDate(objGIPIQuote.strInceptDate);
			var expiryDate 	= makeDate(objGIPIQuote.strExpiryDate);
			var fromDate 	= makeDate($F("txtNbtFromDt"));
			var toDate		= makeDate($F("txtNbtToDt"));
			
			if(toDate > expiryDate){
				$("txtNbtToDt").value = ((objGIPIQuote.strExpiryDate).split(" "))[0];
				customShowMessageBox("End date should not be later than the expiry date. " +
						"Will copy expiry date value from basic information.", imgMessage.INFO, "hrefToDate");				
			}else if(toDate < inceptDate){
				$("txtNbtToDt").value = ((objGIPIQuote.strExpiryDate).split(" "))[0];
				customShowMessageBox("End date should not be earlier than the inception date. " +
						"Will copy expiry date value from basic information.", imgMessage.INFO, "hrefToDate");
			}else if(!($F("txtNbtFromDt").empty()) && fromDate > toDate){
				$("txtNbtToDt").value = ((objGIPIQuote.strExpiryDate).split(" "))[0];
				customShowMessageBox("End date should not be earlier than the start date. " +
						"Will copy expiry date value from basic information.", imgMessage.INFO, "hrefToDate");
			}
		}
	}
    
    $("txtNbtFromDt").observe("blur", validateFromDate);
    
    $("txtNbtToDt").observe("blur", validateToDate);
	//end by robert
	initializeAiType("aiUpdateBtn");
	initializeChangeAttribute();
	$("aiUpdateBtn").observe("click", function(){
		objQuote.addtlInfo = 'Y'; //robert 9.28.2012
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("additionalItemInformation"); // added by: Nica 06.13.2012
		disableButton("aiUpdateBtn");
	});
	
</script>