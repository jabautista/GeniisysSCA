<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-cache");
%>
<script type="text/javascript">
//*** start 
	var nextField = "eqZoneDesc";
	function changeFocus(next){
		nextField = next;
	}
//*** end 
</script>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv" style="display: none;">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px; display: none;">
		<input type="hidden" id="region">
		<form name="fireAiForm">
			<table id="fireTable" width="920px" cellspacing="1" border="0">
				<tr><td colspan="6"><br /></td></tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Assignee </td>
					<td class="leftAligned" style="width: 185px;">
						<input type="text" style="width: 175px; padding: 2px;" name="assignee" id="assignee" maxlength="250" tabindex="1" onFocus="nextField='eqZoneDesc';" class="aiInput"/>
					</td>
					<td class="rightAligned">EQ Zone </td>
					<td class="leftAligned" style="width: 185px;">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="eqZone" name="eqZone" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="eqZoneDesc" id="eqZoneDesc" readonly="readonly" value="" tabindex="2" onFocus="nextField='fromDate';" class="aiInput"/>
							<img id="hrefEQZone" alt="goEQZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
						</div>
						<!-- 
							<select id="eqZone" name="eqZone" style="width: 182px;">
								<option value=""></option>
								<c:forEach var="eqZone" items="${eqZoneList}">
									<option value="${eqZone.eqZone}">${eqZone.eqDesc}</option>				
								</c:forEach>
							</select>
						 -->
					</td>
					<td class="rightAligned" style="width: 100px;">From Date </td>
					<td class="leftAligned" style="width: 190px;">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="text" style="width: 155px; border: none; margin-top: 0px; float: left;" name="fromDate" id="fromDate" readonly="readonly" value="${fromDate}" tabindex="3" onFocus="nextField='frItemType';"/>					
			    			<img id="hrefFromDate" alt="Fire From Date" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('fromDate'),this, null);"/>
			    		</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Type </td>
					<td class="leftAligned">
						<select id="frItemType" name="frItemType" style="width: 182px;" tabindex="4" onFocus="nextField='typhoonZoneDesc';" class="aiInput">
							<option value=""></option>
							<c:forEach var="itemType" items="${itemTypeList}">
								<option value="${itemType.frItemType}">${itemType.frItemTypeDs}</option>				
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned">Typhoon Zone </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="typhoonZone" name="typhoonZone" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="typhoonZoneDesc" id="typhoonZoneDesc" readonly="readonly" value="" tabindex="5" onFocus="nextField='toDate';" class="aiInput"/>
							<img id="hrefTyphoonZone" alt="goTyphoonZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
						</div>
						<!-- 
							<select id="typhoonZone" name="typhoonZone" style="width: 182px;">
								<option value=""></option>
								<c:forEach var="typhoon" items="${typhoonList}">
									<option value="${typhoon.typhoonZone}">${typhoon.typhoonZoneDesc}</option>				
								</c:forEach>
							</select>
						 -->
					</td>
					<td class="rightAligned" style="width: 100px;">To Date </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="text" style="width: 155px; border: none; margin-top: 0px; float: left;" name="toDate" id="toDate" readonly="readonly" value="${toDate}" tabindex="6" onFocus="nextField='province';"/>
							<img id="hrefToDate" alt="Fire To Date" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('toDate'),this, null);" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Province </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" >
							<input type="hidden" id="provinceCd" name="provinceCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="province" id="province" readonly="readonly" value="" tabindex="7" onFocus="nextField='floodZoneDesc';"/>
							<img id="hrefProvince" alt="goProvince" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
						<!-- 
							<select id="province" name="province" style="width: 182px;" class="required">
								<option value=""></option>
								<c:forEach var="province" items="${provinceList}">
									<option value="${province.provinceCd}" regionCd="${province.regionCd}">${province.provinceCd} - ${province.provinceDesc}</option>
								</c:forEach>
							</select>
						 -->
					</td>
					<td class="rightAligned">Flood Zone </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="floodZone" name="floodZone" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="floodZoneDesc" id="floodZoneDesc" readonly="readonly" value="" tabindex="8" onFocus="nextField='locRisk1';"/>
							<img id="hrefFloodZone" alt="goFloodZone" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
						<!-- 
						<select id="floodZone" name="floodZone" style="width: 182px;">
							<option value=""></option>
							<c:forEach var="flood" items="${floodList}">
								<option value="${flood.floodZone}">${flood.floodZoneDesc}</option>				
							</c:forEach>
						</select>
						 -->
					</td>
					<td class="rightAligned" style="width: 100px; ">Location </td>
					<td class="leftAligned">
						<input type="text" style="width: 175px; padding: 2px;" name="locRisk1" id="locRisk1" maxlength="50" value="${gipiQuote.address1}" tabindex="9" onFocus="nextField='city';" class="aiInput" /> <!--  emsy 12.02.2011 ~ modified value to show default loc -->
					</td>				
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">City </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;"> <!-- emsy 12.02.2011 ~ modified this; added required class -->
							<input type="hidden" id="cityCd" name="cityCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="city" id="city" readonly="readonly" value="" tabindex="10" onFocus="nextField='tariffZone';"/>  <!-- emsy 12.02.2011 ~ modified this; added required class -->
							<img id="hrefCity" alt="goCity" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
						<!-- 
						<select id="city" name="city" style="width: 182px;" class="required">
							<option value=""></option>
							<c:forEach var="city" items="${cityList}">
								<option value="${city.cityCd}" combVal="${city.provinceCd}_${city.cityCd}" provinceCd="${city.provinceCd}">${city.provinceCd} - ${city.cityCd} - ${city.city}</option>
							</c:forEach>
						</select>
						 -->
					</td>
					<td class="rightAligned">Tariff Zone </td>
					<td class="leftAligned">
						<select id="tariffZone" name="tariffZone" style="width: 182px;" tabindex="11" onFocus="nextField='locRisk2';" class="aiInput">
							<option value=""></option>
							<c:forEach var="tariffZone" items="${tariffZoneList}">
								<option value="${tariffZone.tariffZone}">${tariffZone.tariffZoneDesc}</option>				
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned" style="width: 100px;">&nbsp; </td>
					<td class="leftAligned"><input type="text" style="width: 175px; padding: 2px;" name="locRisk2" id="locRisk2" maxlength="50" value="${gipiQuote.address2}" tabindex="12" onFocus="nextField='district';" class="aiInput"/></td>  <!--  emsy 12.02.2011 ~ modified value to show default loc -->
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">District </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">  <!-- emsy 12.02.2011 ~ modified this; added required class -->
							<input type="hidden" id="districtNo" name="districtNo" />						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="district" id="district" readonly="readonly" value="" tabindex="13" onFocus="nextField='tarfCd';"/>  <!-- emsy 12.02.2011 ~ modified this; added required class -->
							<img id="hrefDistrict" alt="goDistrict" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />												
						</div>
						<!-- 
						<select id="district" name="district" style="width: 182px;" class="required">
							<option value=""></option>
							<c:forEach var="district" items="${districtList}">
								<option value="${district.districtNo}" combVal="${district.provinceCd}_${district.cityCd}_${district.districtNo}" combVal1="${district.provinceCd}_${district.cityCd}" provinceCd="${district.provinceCd}" cityCd="${district.cityCd}">${district.provinceCd} - ${district.cityCd} - ${district.districtNo} - ${district.districtDesc}</option>
							</c:forEach>
						</select>
						 -->
					</td>
					<td class="rightAligned">Tariff Code </td>
					<td class="leftAligned">					
						<select id="tarfCd" name="tarfCd" style="width: 182px;" onFocus="nextField='locRisk3';" class="aiInput">
							<option value=""></option>
							<c:forEach var="tariff" items="${tariffList}">
								<option value="${tariff.tariffCd}" tariffRate="${tariff.tariffRate}">${tariff.tariffCd} - ${tariff.tariffDesc}</option>				
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned" style="width: 100px;">&nbsp; </td>
					<td class="leftAligned"><input type="text" style="width: 175px; padding: 2px;" name="locRisk3" id="locRisk3" maxlength="50" value="${gipiQuote.address3}" onFocus="nextField='block';" class="aiInput"/></td> <!--  emsy 12.02.2011 ~ modified value to show default loc -->
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Block </td>
					<td class="leftAligned">
						<!-- blockNo column -->
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">  <!-- emsy 12.02.2011 ~ modified this; added required class -->
							<input type="hidden" id="blockId" name="blockId" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="block" id="block" readonly="readonly" value="" onFocus="nextField='construction';"/>  <!-- emsy 12.02.2011 ~ modified this; added required class -->
							<img id="hrefBlock" alt="goBlock" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>						
						</div>
						<!-- 					
						<select id="block" name="block" style="width: 182px;" class="required">
							<option value=""></option>
							<c:forEach var="block" items="${blockList}">
								<option value="${block.blockId}" combVal="${block.provinceCd}_${block.cityCd}_${block.districtNo}_${block.blockId}" combVal1="${block.provinceCd}_${block.cityCd}_${block.districtNo}" combVal2="${block.provinceCd}_${block.cityCd}" provinceCd="${block.provinceCd}" cityCd="${block.cityCd}" districtNo="${block.districtNo}" blockNo="${block.blockNo}" eqZone="${block.eqZone}" floodZone="${block.floodZone}" typhoonZone="${block.typhoonZone}">${block.provinceCd} - ${block.cityCd} - ${block.districtNo} - ${block.blockNo} - ${block.blockDesc}</option>
							</c:forEach>
						</select>
						 -->
					</td>
					<td class="rightAligned">Construction </td>
					<td class="leftAligned">
						<select id="construction" name="construction" style="width: 182px;" onFocus="nextField='front';" class="aiInput">
							<option value=""></option>
							<c:forEach var="construction" items="${constructionList}">
								<option value="${construction.constructionCd}">${construction.constructionDesc}</option>				
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned" style="width: 100px;">Boundary Front </td>
					<td class="leftAligned">
						<!-- <input type="text" style="width: 175px; padding: 2px;" name="front" id="front" maxlength="2000" class="required" /> -->
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="front" id="front" value="" onFocus="nextField='risk';" class="aiInput"/>
							<img id="hrefFront" alt="goFront" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 90px;">Risks </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="riskCd" name="riskCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="risk" id="risk" readonly="readonly" onFocus="nextField='constructionRemarks';"/>
							<img id="hrefRisk" alt="goRisk" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
						
						<!-- riskCd column -->
						<!-- 
						<select id="risk" name="risk" style="width: 182px;" >
							<option value=""></option>
							<c:forEach var="risk" items="${riskList}">
								<option value="${risk.blockId}_${risk.riskCd}" blockId="${risk.blockId}" disabled="disabled" style="display: none;">${risk.riskDesc}</option>
							</c:forEach>						
						</select>
						 -->
					</td>
					<td class="rightAligned">Construction Remarks </td>
					<td class="leftAligned">
						<!-- <input type="text" style="width: 175px; padding: 2px;" name="constructionRemarks" id="constructionRemarks" maxlength="2000" /> -->
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="constructionRemarks" id="constructionRemarks" value="" onFocus="nextField='right';" class="aiInput"/>
							<img id="hrefConstructionRemarks" alt="goConstructionRemarks" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" />
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">Right </td>
					<td class="leftAligned">
						<!-- <input type="text" style="width: 175px; padding: 2px;" name="right" id="right" maxlength="2000" class="required" /> -->
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="right" id="right" value="" onFocus="nextField='occupancy';" class="aiInput"/>
							<img id="hrefRight" alt="goRight" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" />
						</div>
					</td>
				</tr>
				<tr>				
					<td class="rightAligned" style="width: 90px;">Occupancy </td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
							<input type="hidden" id="occupancyCd" name="occupancyCd" />
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="occupancy" id="occupancy" readonly="readonly" value="" onFocus="nextField='occupancyRemarks';"/>
							<img id="hrefOccupancy" alt="goOccupancy" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
						<!-- 
						<select id="occupancy" name="occupancy" style="width: 182px;">
							<option value=""></option>
							<c:forEach var="occupancy" items="${occupancyList}">								
								<option value="${occupancy.occupancyCd}">${occupancy.occupancyDesc}</option>				
							</c:forEach>
						</select>
						 -->
					</td>
					<td class="rightAligned">Occupancy Remarks </td>
					<td class="leftAligned">
						<!-- <input type="text" style="width: 175px; padding: 2px;" name="occupancyRemarks" id="occupancyRemarks" maxlength="2000" /> -->
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="occupancyRemarks" id="occupancyRemarks" value="" onFocus="nextField='left';" class="aiInput"/>
							<img id="hrefOccupancyRemarks" alt="goOccupancyRemarks" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
						</div>
					</td>
					<td class="rightAligned" style="width: 100px;">Left </td>
					<td class="leftAligned">
						<!-- <input type="text" style="width: 175px; padding: 2px;" name="left" id="left" maxlength="2000" class="required" /> -->
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="left" id="left" value="" onFocus="nextField='rear';" class="aiInput"/>
							<img id="hrefLeft" alt="goLeft" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" />
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;</td>				
					<td class="rightAligned" style="width: 100px;">Rear </td>
					<td class="leftAligned">
						<!-- <input type="text" style="width: 175px; padding: 2px;" name="rear" id="rear" maxlength="2000" class="required" /> -->
						<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
							<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="rear" id="rear" value="" onFocus="nextField='assignee';" class="aiInput"/>
							<img id="hrefRear" alt="goRear" style="height: 18px;" class="hover aiInput" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
						</div>
					</td>
				</tr>
			</table>
			<div style="margin-left: auto; margin-right: auto; margin-bottom: 20px;">
				<input type="button" id="aiFIUpdateBtn" name="aiFIUpdateBtn" value="Apply Changes" class="disabledButton"/>  <!-- edited by steven 11/7/2012 binago ko ung id niya kasi parehas siya sa ibang jsp na tinatawag dito kaya nag-eerror ung function --> 
			</div>
		</form>
		<!--		
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align: center;">
					<input type="button" id="btnAddItem" 	class="button" value="Add" />
					<input type="button" id="btnDeleteItem"	class="disabledButton" value="Delete" />
				</td>
			</tr>
		</table>		
	--></div>
</div>

<script type="text/javascript">
	function showCity(column){
		var provinceCd 	= $F("provinceCd");
		var regionCd 	= $F("region");// ~ emsy 12.02.2011
		var url			= contextPath + "/GIPIWFireItmController?action=showCity&column=" + column + "&provinceCd=" + provinceCd + "&regionCd=" + regionCd;

		showOverlayContent2(url, "List of Province and City", 620, "");
	}

	function showBlock(column){
		var regionCd	= $F("region"); // ~ emsy 12.02.2011
		var provinceCd 	= $F("provinceCd");
		var cityCd 		= $F("cityCd");
		var districtNo 	= $F("districtNo");
		var url			= contextPath + "/GIPIWFireItmController?action=showBlock&column=" + column + "&regionCd=" + regionCd + "&provinceCd=" + provinceCd + "&cityCd=" + cityCd + "&districtNo=" + districtNo;
		
		//showOverlayContent2(url, "List of Disctrict and Block", 820, ""); ~ emsy 12.02.2011
		//showOverlayContent(contextPath + "/GIPIWFireItmController?action=showBlock", "List of Disctrict and Block", 400, "", 10, 10, 10);
		showQuoteDistrictBlock(regionCd, provinceCd, cityCd, districtNo); // emsy 12.02.2011 ~ added this
	}

	//$("hrefProvince").observe("click", function(){	showCity("province");	});  ~ emsy 12.02.2011
	//$("hrefCity").observe("click", function(){	showCity("city");	});	~ emsy 12.02.2011
	//$("hrefDistrict").observe("click", function(){	showBlock("district");	}); ~ emsy 12.02.2011
	
	$("hrefProvince").observe("click", showQuoteProvinceLOV);
	
	$("hrefCity").observe("click", showQuoteCityLOV);
	
	$("hrefDistrict").observe("click", function(){	showBlock("district");	});

	$("hrefBlock").observe("click", function(){	showBlock("block");	});

	$("hrefRisk").observe("click", function(){
		showQuoteRiskLOV($F("blockId")); // ~[uncommented by emsy 12.02.2011] //commented by rencela ---  this function has no corresponding action in Controller 
		//showOverlayContent2(contextPath + "/GIPIWFireItmController?action=showRisks&blockId=" + $F("blockId"), "Risks", 820, ""); ~ emsy 12.02.2011
	});

	$("hrefOccupancy").observe("click", function(){
		showQuoteOccupancyLOV(); // ~[uncommented by emsy 12.02.2011] //commented by rencela ---  this function has no corresponding action in Controller 
		//showOverlayContent2(contextPath + "/GIPIWFireItmController?action=showOccupancy", "Occupancy", 820, ""); ~ emsy 12.02.2011
	});

	$("hrefFront").observe("click", function(){	showEditor("front", 2000);	});	

	$("hrefRight").observe("click", function(){	showEditor("right", 2000);	});

	$("hrefLeft").observe("click", function(){	showEditor("left", 2000);	});

	$("hrefRear").observe("click", function(){	showEditor("rear", 2000);	});

	$("hrefConstructionRemarks").observe("click", function(){	showEditor("constructionRemarks", 2000);	});

	$("hrefOccupancyRemarks").observe("click", function(){	showEditor("occupancyRemarks", 2000);	});

	$("province").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("provinceCd").value 	= "";
			$("province").value 	= "";
			$("cityCd").value 		= ""; 
			$("city").value 		= "";
			$("districtNo").value 	= "";
			$("district").value 	= "";
			$("blockId").value 		= "";
			$("block").value 		= "";

			//updateLocalLOV("risk", "blockId", $F("blockId"));
		}
	});
	
	$("city").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("cityCd").value 		= ""; 
			$("city").value 		= "";
			$("districtNo").value 	= "";
			$("district").value 	= "";
			$("blockId").value 		= "";
			$("block").value 		= "";

			//updateLocalLOV("risk", "blockId", $F("blockId"));
		}
	});

	$("district").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("districtNo").value 	= "";
			$("district").value 	= "";
			$("blockId").value 		= "";
			$("block").value 		= "";

			//updateLocalLOV("risk", "blockId", $F("blockId"));
		}
	});
	
	$("block").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("blockId").value 	= "";
			$("block").value 	= "";

			//updateLocalLOV("risk", "blockId", $F("blockId"));
		}
	});

	$("block").observe("change", function(){
		//updateLocalLOV("risk", "blockId", $F("blockId"));
	});
	
	$("front").observe("keyup", function(event){	if(event.keyCode == 46){	$("front").value = "";	}});
	$("right").observe("keyup", function(event){	if(event.keyCode == 46){	$("right").value = "";	}});
	$("left").observe("keyup", function(event){	if(event.keyCode == 46){	$("left").value = "";	}});
	$("rear").observe("keyup", function(event){	if(event.keyCode == 46){	$("rear").value = "";	}});

	$("risk").observe("keyup", function(event){
		if(event.keyCode == 46){	
			$("riskCd").value 	= "";
			$("risk").value		= "";
		}
	});

	$("occupancy").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("occupancyCd").value 	= "";
			$("occupancy").value	= "";
		}
	});
	
	function updateLocalLOV(select, attr, value){
		try{
			$(select).hide();
			//(($(select).childElements()).invoke("show")).invoke("removeAttribute", "disabled");
			(($$("select#" + select + " option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
			(($$("select#" + select +" option:not([" + attr + "='" + value + "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");

			$(select).options[0].show();
			$(select).options[0].disabled = false;
			$(select).show();
		}catch(e){
			showErrorMessage("updateLocalLOV", e);
			//showMessageBox("updateLOVByProvince : " + e.message);
		}
	}
	/*
	$("province").observe("change", function(){
		if($F("province").empty()){			
			(($("city").childElements()).invoke("show")).invoke("removeAttribute", "disabled");
			(($("district").childElements()).invoke("show")).invoke("removeAttribute", "disabled");			
			(($("block").childElements()).invoke("show")).invoke("removeAttribute", "disabled");			
			
			$("block").value 	= "";
			fireEvent($("block"), "change");
			$("district").value = "";
			$("city").value 	= "";			
		}else{
			var selectedOption = $("province").options[$("province").selectedIndex];
			$("region").value = selectedOption.getAttribute("regionCd");			
			
			updateLocalLOV("city", "provinceCd", $F("province"));

			$F("district").empty() 	? updateLocalLOV("district", "provinceCd", $F("province")) : null;
			$F("block").empty()		? updateLocalLOV("block", "provinceCd", $F("province")) : null;			
		}
	});

	$("city").observe("change", function(){
		if($F("city").empty()){
			$("district").value = "";
			fireEvent($("district"), "change");
		}else{
			var selectedOption = $("city").options[$("city").selectedIndex];

			if($F("province").empty()){
				setSelectOptionsValue("province", "value", selectedOption.getAttribute("provinceCd"));
				fireEvent($("province"), "change");
			}

			updateLocalLOV("district", "combVal1", selectedOption.getAttribute("combVal"));
			updateLocalLOV("block", "combVal2", selectedOption.getAttribute("combVal"));						
		}
	});

	$("district").observe("change", function(){
		if($F("district").empty()){
			$("block").value = "";
			fireEvent($("block"), "change");
		}else{
			var selectedOption = $("district").options[$("district").selectedIndex];
			
			if($F("province").empty()){
				$("province").value = selectedOption.getAttribute("provinceCd");
				setSelectOptionsValue("city", "combVal", selectedOption.getAttribute("combVal1"));
				fireEvent($("province"), "change");				
				fireEvent($("city"), "change");
			}
			
			updateLocalLOV("block", "combVal1", selectedOption.getAttribute("combVal"));			
		}
	});
	
	$("block").observe("change", function(){
		if($F("block").empty()){
			$("eqZone").value 		= "";
			$("typhoonZone").value 	= "";
			$("floodZone").value 	= "";
		}else{
			var selectedBlock = $("block").options[$("block").selectedIndex];
			var arrCombinationVal = (selectedBlock.getAttribute("combVal")).split("_");
			
			if($F("province").empty()){
				setCursor("wait");
				$("province").value = arrCombinationVal[0];
				fireEvent($("province"), "change");				
				setSelectOptionsValue("city", "combVal", arrCombinationVal[0] + "_" + arrCombinationVal[1]);
				fireEvent($("city"), "change");				
				setSelectOptionsValue("district", "combVal", arrCombinationVal[0] + "_" + arrCombinationVal[1] + "_" + arrCombinationVal[2]);				
				setCursor("default");
			}else if($F("city").empty()){
				setSelectOptionsValue("city", "combVal", arrCombinationVal[0] + "_" + arrCombinationVal[1]);
				fireEvent($("city"), "change");				
				setSelectOptionsValue("district", "combVal", arrCombinationVal[0] + "_" + arrCombinationVal[1] + "_" + arrCombinationVal[2]);
			}else if($F("district").empty()){
				setSelectOptionsValue("district", "combVal", arrCombinationVal[0] + "_" + arrCombinationVal[1] + "_" + arrCombinationVal[2]);
			}
			
			$("eqZone").value 		= selectedBlock.getAttribute("eqZone");
			$("typhoonZone").value 	= selectedBlock.getAttribute("typhoonZone");
			$("floodZone").value 	= selectedBlock.getAttribute("floodZone");

			updateLocalLOV("risk", "blockId", $F("block"));
		}
	});
	*/
	/*
	$("riskNo").observe("blur", function(){
		if(!($F("riskNo").empty())){
			var riskItemNo = getNextRiskItemNoFromObj($F("riskNo"));			
			$("riskItemNo").value =  riskItemNo == "" ? "1" : riskItemNo;
		}else{
			$("riskItemNo").value = "";
		}
	});*/

	function validateFromDate(){
		if(!($F("fromDate").empty())){
			// modified by: nica 06.22.2011 - to be reusable by package quotation
			var quoteIncept = objMKGlobal.packQuoteId != null ? objCurrPackQuote.inceptDate : objGIPIQuote.inceptDate;
			var quoteExpiry = objMKGlobal.packQuoteId != null ? objCurrPackQuote.expiryDate : objGIPIQuote.expiryDate;
			
			var arrInceptDate 	= (((quoteIncept).split(" "))[0]).split("-");
			var arrExpiryDate 	= (((quoteExpiry).split(" "))[0]).split("-");
			var arrFromDate 	= ($F("fromDate")).split("-");
			var arrToDate		= ($F("toDate")).split("-");
			
			var inceptDate 	= new Date().setFullYear(arrInceptDate[2], arrInceptDate[0], arrInceptDate[1]);
			var expiryDate 	= new Date().setFullYear(arrExpiryDate[2], arrExpiryDate[0], arrExpiryDate[1]);
			var fromDate 	= new Date().setFullYear(arrFromDate[2], arrFromDate[0], arrFromDate[1]);
			var toDate 		= new Date().setFullYear(arrToDate[2], arrToDate[0], arrToDate[1]);
			
			if(fromDate > expiryDate){
				$("fromDate").value = (((quoteIncept).split(" "))[0]);
				customShowMessageBox("Start date should not be later than the expiry date. " +
						"Will copy incept date value from basic information.", imgMessage.INFO, "hrefFromDate");				
			}else if(fromDate < inceptDate){
				$("fromDate").value = (((quoteIncept).split(" "))[0]);
				customShowMessageBox("Start date should not be earlier than the inception date. " +
						"Will copy incept date value from basic information.", imgMessage.INFO, "hrefFromDate");
			}else if(!($F("toDate").empty()) && fromDate > toDate){
				$("fromDate").value = (((quoteIncept).split(" "))[0]);
				customShowMessageBox("Start date should not be later than the end date. " +
						"Will copy incept date value from basic information.", imgMessage.INFO, "hrefFromDate");
			}
		}
	}

	function validateToDate(){
		if(!($F("toDate").empty())){
			// modified by: nica 06.22.2011 - to be reusable by package quotation
			var quoteIncept = objMKGlobal.packQuoteId != null ? objCurrPackQuote.inceptDate : objGIPIQuote.inceptDate;
			var quoteExpiry = objMKGlobal.packQuoteId != null ? objCurrPackQuote.expiryDate : objGIPIQuote.expiryDate;
			
			var arrInceptDate 	= (((quoteIncept).split(" "))[0]).split("-");
			var arrExpiryDate 	= (((quoteExpiry).split(" "))[0]).split("-");
			var arrFromDate 	= ($F("fromDate")).split("-");
			var arrToDate		= ($F("toDate")).split("-");
			
			var inceptDate 	= new Date().setFullYear(arrInceptDate[2], arrInceptDate[0], arrInceptDate[1]);
			var expiryDate 	= new Date().setFullYear(arrExpiryDate[2], arrExpiryDate[0], arrExpiryDate[1]);
			var fromDate 	= new Date().setFullYear(arrFromDate[2], arrFromDate[0], arrFromDate[1]);
			var toDate 		= new Date().setFullYear(arrToDate[2], arrToDate[0], arrToDate[1]);
			
			if(toDate > expiryDate){
				$("toDate").value = ((quoteExpiry).split(" "))[0];
				customShowMessageBox("End date should not be later than the expiry date. " +
						"Will copy expiry date value from basic information.", imgMessage.INFO, "hrefToDate");				
			}else if(toDate < inceptDate){
				$("toDate").value = ((quoteExpiry).split(" "))[0];
				customShowMessageBox("End date should not be earlier than the inception date. " +
						"Will copy expiry date value from basic information.", imgMessage.INFO, "hrefToDate");
			}else if(!($F("fromDate").empty()) && fromDate > toDate){
				$("toDate").value = ((quoteExpiry).split(" "))[0];
				customShowMessageBox("End date should not be earlier than the start date. " +
						"Will copy expiry date value from basic information.", imgMessage.INFO, "hrefToDate");
			}
		}
	}

	$("fromDate").observe("blur", validateFromDate);	
	$("fromDate").observe("keyup", function(event){	if(event.keyCode == 46){	$("fromDate").value = "";	}});
	
	$("toDate").observe("blur", validateToDate);
	$("toDate").observe("keyup", function(event){	if(event.keyCode == 46){	$("toDate").value = "";	}});		
	$("hrefEQZone").observe("click", showEQZoneLOV);
	$("hrefTyphoonZone").observe("click", showTyphoonZoneLOV);
	$("hrefFloodZone").observe("click", showFloodZoneLOV);	


	//**

	var netscape = "";
	var ver = navigator.appVersion; len = ver.length;
	
	for(iln = 0; iln < len; iln++) 
		if (ver.charAt(iln) == "(") 
			break;
	netscape = (ver.charAt(iln+1).toUpperCase() != "C");
	
/* 	function keyDown(DnEvents){
		k = (netscape) ? DnEvents.which : window.event.keyCode;
		if (k == 13 || k == 9) { // enter key pressed
			if (nextField == 'done'){ 
				return true; // submit, we finished all fields
			}else { // we're not done yet, send focus to next box
				//eval('document.fireAiForm.' + nextField + '.focus()');
				$(nextField).focus();
				return false;
			}
	   }
	}	
	
	document.onkeydown = keyDown; // work together to analyze keystrokes
	
	if (netscape){
		document.captureEvents(Event.KEYDOWN|Event.KEYUP);
	} */
	
	initializeAiType("aiFIUpdateBtn");
	
	$("aiFIUpdateBtn").observe("click", function(){
		// emsy 12.01.2011 ~ added this to check if the req'd fields are null
// 		if($("province").value == "" || $("city").value == "" || $("district").value == "" || $("block").value == "") { //remove by steven 11/8/2012 -> base on SR 0011201
// 			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
// 		}
// 		else{
			fireEvent($("btnAddItem"), "click");
			clearChangeAttribute("additionalItemInformation");
// 		}
	});
	
</script>