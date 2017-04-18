<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">
		<table id="fireTable" width="920px" cellspacing="1" border="0">
			<tr><td colspan="6"><br /></td></tr>
			<tr>
				<td class="rightAligned" style="width: 90px;">Assignee </td>
				<td class="leftAligned" style="width: 185px;"><input type="text" tabindex="15" style="width: 175px; padding: 2px;" name="assignee" id="assignee" maxlength="30" /></td>
				<td class="rightAligned">EQ Zone </td>
				<td class="leftAligned" style="width: 185px;">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" id="zoneDiv" name="zoneDiv"><!-- Gzelle 05252015 SR4347 -->
						<input type="hidden" id="eqZone" name="eqZone" />
						<input type="text" tabindex="23" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="eqZoneDesc" id="eqZoneDesc" readonly="readonly" value="" />
						<img id="hrefEQZone" alt="goEQZone" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="23" id="eqZone" name="eqZone" style="width: 182px;">
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
						<input type="text" tabindex="31" style="width: 155px; border: none; margin-top: 0px; float: left;" name="fromDate" id="fromDate" readonly="readonly" value=""/>					
		    			<img id="hrefFromDate" alt="Fire From Date" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('fromDate'),this, null);" />
		    		</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 90px;">Type </td>
				<td class="leftAligned">
					<select tabindex="16" id="frItemType" name="frItemType" style="width: 182px;">
						<option value=""></option>
						<c:forEach var="itemType" items="${itemTypeList}">
							<option value="${itemType.frItemType}">${itemType.frItemTypeDs}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">Typhoon Zone </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;"  id="zoneDiv" name="zoneDiv"><!-- Gzelle 05252015 SR4347 -->
						<input type="hidden" id="typhoonZone" name="typhoonZone" />
						<input type="text" tabindex="24" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="typhoonZoneDesc" id="typhoonZoneDesc" readonly="readonly" value="" />
						<img id="hrefTyphoonZone" alt="goTyphoonZone" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="24" id="typhoonZone" name="typhoonZone" style="width: 182px;">
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
						<input type="text" tabindex="32" style="width: 155px; border: none; margin-top: 0px; float: left;" name="toDate" id="toDate" readonly="readonly" value="${toDate}" />
						<img id="hrefToDate" alt="Fire To Date" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('toDate'),this, null);" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 90px;">Province </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" class="required" >
						<input type="hidden" id="provinceCd" name="provinceCd" />
						<input type="text" tabindex="17" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="province" id="province" readonly="readonly" value="" class="required" />
						<img id="hrefProvince" alt="goProvince" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="21" id="province" name="province" style="width: 182px;" class="required">
						<option value=""></option>
						<c:forEach var="province" items="${provinceList}">
							<option value="${province.provinceCd}" regionCd="${province.regionCd}">${province.provinceCd} - ${province.provinceDesc}</option>
						</c:forEach>
					</select>
					 -->
				</td>
				<td class="rightAligned">Flood Zone </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;"  id="zoneDiv" name="zoneDiv"><!-- Gzelle 05252015 SR4347 -->
						<input type="hidden" id="floodZone" name="floodZone" />
						<input type="text" tabindex="25" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="floodZoneDesc" id="floodZoneDesc" readonly="readonly" value="" />
						<img id="hrefFloodZone" alt="goFloodZone" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="25" id="floodZone" name="floodZone" style="width: 182px;">
						<option value=""></option>
						<c:forEach var="flood" items="${floodList}">
							<option value="${flood.floodZone}">${flood.floodZoneDesc}</option>				
						</c:forEach>
					</select>
					 -->
				</td>
				<td class="rightAligned" style="width: 100px;">Location </td>
				<td class="leftAligned"><input type="text" tabindex="33" style="width: 175px; padding: 2px;" name="locRisk1" id="locRisk1" maxlength="50" value="${mailAddr1}" /></td>				
			</tr>
			<tr>
				<td class="rightAligned" style="width: 90px;">City </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" class="required" >
						<input type="hidden" id="cityCd" name="cityCd" />
						<input type="text" tabindex="18" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="city" id="city" readonly="readonly" value="" class="required" />
						<img id="hrefCity" alt="goCity" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="24" id="city" name="city" style="width: 182px;" class="required">
						<option value=""></option>
						<c:forEach var="city" items="${cityList}">
							<option value="${city.cityCd}" combVal="${city.provinceCd}_${city.cityCd}" provinceCd="${city.provinceCd}">${city.provinceCd} - ${city.cityCd} - ${city.city}</option>
						</c:forEach>
					</select>
					 -->
				</td>
				<td class="rightAligned">Tariff Zone </td>
				<td class="leftAligned">
					<select tabindex="26" id="tariffZone" name="tariffZone" style="width: 182px;" class="required">
						<option value=""></option>
						<c:forEach var="tariffZone" items="${tariffZoneList}">
							<option value="${tariffZone.tariffZone}">${tariffZone.tariffZoneDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 100px;">&nbsp; </td>
				<td class="leftAligned"><input type="text" tabindex="34" style="width: 175px; padding: 2px;" name="locRisk2" id="locRisk2" maxlength="50" value="${mailAddr2}" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 90px;">District </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" class="required" >
						<input type="hidden" id="districtNo" name="districtNo" />						
						<input type="text" tabindex="19" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="district" id="district" readonly="readonly" value="" class="required" />
						<img id="hrefDistrict" alt="goDistrict" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />												
					</div>
					<!-- 
					<select tabindex="27" id="district" name="district" style="width: 182px;" class="required">
						<option value=""></option>
						<c:forEach var="district" items="${districtList}">
							<option value="${district.districtNo}" combVal="${district.provinceCd}_${district.cityCd}_${district.districtNo}" combVal1="${district.provinceCd}_${district.cityCd}" provinceCd="${district.provinceCd}" cityCd="${district.cityCd}">${district.provinceCd} - ${district.cityCd} - ${district.districtNo} - ${district.districtDesc}</option>
						</c:forEach>
					</select>
					 -->
				</td>
				<td class="rightAligned">Tariff Code </td>
				<td class="leftAligned">					
					<select tabindex="27" id="tarfCd" name="tarfCd" style="width: 182px;" class="required">
						<option value=""></option>
						<c:forEach var="tariff" items="${tariffList}">
							<option value="${tariff.tariffCd}" tariffRate="${tariff.tariffRate}">${tariff.tariffCd} - ${tariff.tariffDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 100px;">&nbsp; </td>
				<td class="leftAligned"><input type="text" tabindex="35" style="width: 175px; padding: 2px;" name="locRisk3" id="locRisk3" maxlength="50" value="${mailAddr3}" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 90px;">Block </td>
				<td class="leftAligned">
					<!-- blockNo column -->
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" class="required" >
						<input type="hidden" id="blockId" name="blockId" />
						<input type="text" tabindex="20" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="block" id="block" readonly="readonly" value="" class="required" />
						<img id="hrefBlock" alt="goBlock" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 					
					<select tabindex="30" id="block" name="block" style="width: 182px;" class="required">
						<option value=""></option>
						<c:forEach var="block" items="${blockList}">
							<option value="${block.blockId}" combVal="${block.provinceCd}_${block.cityCd}_${block.districtNo}_${block.blockId}" combVal1="${block.provinceCd}_${block.cityCd}_${block.districtNo}" combVal2="${block.provinceCd}_${block.cityCd}" provinceCd="${block.provinceCd}" cityCd="${block.cityCd}" districtNo="${block.districtNo}" blockNo="${block.blockNo}" eqZone="${block.eqZone}" floodZone="${block.floodZone}" typhoonZone="${block.typhoonZone}">${block.provinceCd} - ${block.cityCd} - ${block.districtNo} - ${block.blockNo} - ${block.blockDesc}</option>
						</c:forEach>
					</select>
					 -->
				</td>
				<td class="rightAligned">Construction </td>
				<td class="leftAligned">
					<select tabindex="28" id="construction" name="construction" style="width: 182px;" >
						<option value=""></option>
						<c:forEach var="construction" items="${constructionList}">
							<option value="${construction.constructionCd}">${construction.constructionDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">LAT</td>
				<td class="leftAligned">
					<input type ="text" id="txtLatitude" name="txtLatitude" style="width: 60px;" tabindex="36" maxlength="50">&nbsp;
					LONG <input type ="text" id="txtLongitude" name="txtLongitude" style="width: 60px;" tabindex="37" maxlength="50">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 90px;">Risks </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
						<input type="hidden" id="riskCd" name="riskCd" />
						<input type="text" tabindex="21" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="risk" id="risk" readonly="readonly" />
						<img id="hrefRisk" alt="goRisk" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					
					<!-- riskCd column -->
					<!-- 
					<select tabindex="21" id="risk" name="risk" style="width: 182px;" >
						<option value=""></option>
						<c:forEach var="risk" items="${riskList}">
							<option value="${risk.blockId}_${risk.riskCd}" blockId="${risk.blockId}" disabled="disabled" style="display: none;">${risk.riskDesc}</option>
						</c:forEach>						
					</select>
					 -->
				</td>
				<td class="rightAligned">Construction Remarks </td>
				<td class="leftAligned">
					<!-- <input type="text" tabindex="29" style="width: 175px; padding: 2px;" name="constructionRemarks" id="constructionRemarks" maxlength="2000" /> -->
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
						<textarea tabindex="29" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; height: 13px; border: none; resize: none;" name="constructionRemarks" id="constructionRemarks" value=""></textarea>
						<img id="hrefConstructionRemarks" alt="goConstructionRemarks" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
					</div>
				</td>
				<td class="rightAligned" style="width: 100px;">Boundary Front </td>
				<td class="leftAligned">
					<!-- <input type="text" tabindex="36" style="width: 175px; padding: 2px;" name="front" id="front" maxlength="2000" class="required" /> -->
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" class="required" >						
						<textarea tabindex="37" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; height: 13px; border: none; resize: none;" name="front" id="front" value="" class="required" ></textarea>
						<img id="hrefFront" alt="goFront" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
					</div>
				</td>
			</tr>
			<tr>				
				<td class="rightAligned" style="width: 90px;">Occupancy </td>
				<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
						<input type="hidden" id="occupancyCd" name="occupancyCd" />
						<input type="text" tabindex="22" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; border: none;" name="occupancy" id="occupancy" readonly="readonly" value="" />
						<img id="hrefOccupancy" alt="goOccupancy" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<!-- 
					<select tabindex="36" id="occupancy" name="occupancy" style="width: 182px;">
						<option value=""></option>
						<c:forEach var="occupancy" items="${occupancyList}">								
							<option value="${occupancy.occupancyCd}">${occupancy.occupancyDesc}</option>				
						</c:forEach>
					</select>
					 -->
				</td>
				<td class="rightAligned">Occupancy Remarks </td>
				<td class="leftAligned">
					<!-- <input type="text" tabindex="30" style="width: 175px; padding: 2px;" name="occupancyRemarks" id="occupancyRemarks" maxlength="2000" /> -->
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">						
						<textarea tabindex="30" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; height: 13px; border: none; resize: none;" name="occupancyRemarks" id="occupancyRemarks" value=""></textarea>
						<img id="hrefOccupancyRemarks" alt="goOccupancyRemarks" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
					</div>
				</td>
				<td class="rightAligned" style="width: 100px;">Right </td>
				<td class="leftAligned">
					<!-- <input type="text" tabindex="37" style="width: 175px; padding: 2px;" name="right" id="right" maxlength="2000" class="required" /> -->
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" class="required" >						
						<textarea tabindex="38" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; height: 13px; border: none; resize: none;" name="right" id="right" value="" class="required"></textarea>
						<img id="hrefRight" alt="goRight" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
				<td class="rightAligned" style="width: 100px;">Left </td>
				<td class="leftAligned">
					<!-- <input type="text" tabindex="38" style="width: 175px; padding: 2px;" name="left" id="left" maxlength="2000" class="required" /> -->
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" class="required" >						
						<textarea tabindex="39" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; height: 13px; border: none; resize: none;" name="left" id="left" value="" class="required"></textarea>
						<img id="hrefLeft" alt="goLeft" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>				
				<td class="rightAligned" style="width: 100px;">Rear </td>
				<td class="leftAligned">
					<!-- <input type="text" tabindex="39" style="width: 175px; padding: 2px;" name="rear" id="rear" maxlength="2000" class="required" /> -->
					<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;" class="required" >						
						<textarea tabindex="40" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="float: left; margin-top: 0px; margin-right: 3px; width: 152px; height: 13px; border: none; resize: none;" name="rear" id="rear" value="" class="required"></textarea>
						<img id="hrefRear" alt="goRear" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
					</div>
				</td>
			</tr>
		</table>		
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align: center;">
					<input type="button" id="btnAddItem" 	class="button" value="Add" />
					<input type="button" id="btnDeleteItem"	class="disabledButton" value="Delete" />
				</td>
			</tr>
		</table>		
	</div>
</div>

<script type="text/javascript">

    var paramRequireLatLong = '${requireLatLong}';
    
	function showBlock(column){
		var regionCd	= $F("region");
		var provinceCd 	= $F("provinceCd");
		var cityCd 		= $F("cityCd");
		var districtNo 	= $F("districtNo");
		//var url			= contextPath + "/GIPIWFireItmController?action=showBlock&column=" + column + "&regionCd=" + regionCd + "&provinceCd=" + provinceCd + "&cityCd=" + cityCd + "&districtNo=" + districtNo;
		
		//showOverlayContent2(url, "List of Disctrict and Block", 820, "");
		//showOverlayContent(contextPath + "/GIPIWFireItmController?action=showBlock", "List of Disctrict and Block", 400, "", 10, 10, 10);
		showDistrictBlock(regionCd, provinceCd, cityCd, ''); //edited by Gab 07.22.2015
	}
	
	if (paramRequireLatLong == "Y") { //Added by Jerome 11.10.2016 SR 5749
		$("txtLatitude").setAttribute("class","required");
		$("txtLongitude").setAttribute("class", "required");
	}

	$("hrefProvince").observe("click", showProvinceLOV);
	
	$("hrefCity").observe("click", showCityLOV);
	
	$("hrefDistrict").observe("click", function(){	showBlock("district");	});
	
	$("hrefBlock").observe("click", function(){	showBlock("block");	});

	$("hrefRisk").observe("click", function(){
		showRiskLOV($F("blockId"));
		//showOverlayContent2(contextPath + "/GIPIWFireItmController?action=showRisks&blockId=" + $F("blockId"), "Risks", 820, "");
	});

	$("hrefOccupancy").observe("click", function(){
		showOccupancyLOV();
		//showOverlayContent2(contextPath + "/GIPIWFireItmController?action=showOccupancy", "Occupancy", 820, "");
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
	
	//Gzelle 05252015 SR4347
	$("eqZoneDesc").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("eqZone").value  = null;
		}
	});
	
	$("typhoonZoneDesc").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("typhoonZone").value  = null;
		}
	});
	
	$("floodZoneDesc").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("floodZone").value  = null;
		}
	});
	//end
	
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
	$("riskNo").observe("blur", function(){
		if(!($F("riskNo").empty())){
			var riskItemNo = getNextRiskItemNoFromObj($F("riskNo"));			
			$("riskItemNo").value =  riskItemNo == "" ? "1" : riskItemNo;
		}else{
			$("riskItemNo").value = "";
		}
	});
	
//gzelle 1.30.2013 SR11980 RSIC
	function validateFromDate(){
		if(!($F("fromDate").empty())){
/* 			var arrInceptDate 	= (((objGIPIWPolbas.inceptDate).split(" "))[0]).split("-");
			var arrExpiryDate 	= (((objGIPIWPolbas.expiryDate).split(" "))[0]).split("-");
			var arrFromDate 	= ($F("fromDate")).split("-");
			var arrToDate		= ($F("toDate")).split("-");
			
			var inceptDate 	= new Date().setFullYear(arrInceptDate[2], arrInceptDate[0], arrInceptDate[1]);
			var expiryDate 	= new Date().setFullYear(arrExpiryDate[2], arrExpiryDate[0], arrExpiryDate[1]);
			var fromDate 	= new Date().setFullYear(arrFromDate[2], arrFromDate[0], arrFromDate[1]);
			var toDate 		= new Date().setFullYear(arrToDate[2], arrToDate[0], arrToDate[1]); */
			
			var formattedEffDate 			= (makeDate(objGIPIWPolbas.formattedEffDate));
			var formattedEndtExpiryDate		= (makeDate(objGIPIWPolbas.formattedEndtExpiryDate));
			var formattedFromdate 			= (makeDate($F("fromDate")));
			var formattedTodate 			= (makeDate($F("toDate")));
			
			if(formattedFromdate > formattedEndtExpiryDate){
				customShowMessageBox("Start date should not be later than the endorsement expiry date.", imgMessage.INFO, "hrefFromDate");
			}else if(formattedFromdate < formattedEffDate){
				customShowMessageBox("Start date should not be earlier than the endorsement effectivity date.", imgMessage.INFO, "hrefFromDate");		
			}else if(!($F("toDate").empty()) && formattedFromdate > formattedTodate){
				customShowMessageBox("Start date should not be later than the end date.", imgMessage.INFO, "hrefFromDate");
			}
		}
	}

	function validateToDate(){
		if(!($F("toDate").empty())){
/* 			var arrInceptDate 	= (((objGIPIWPolbas.inceptDate).split(" "))[0]).split("-");
			var arrExpiryDate 	= (((objGIPIWPolbas.expiryDate).split(" "))[0]).split("-");
			var arrFromDate 	= ($F("fromDate")).split("-");
			var arrToDate		= ($F("toDate")).split("-");
			
			var inceptDate 	= new Date().setFullYear(arrInceptDate[2], arrInceptDate[0], arrInceptDate[1]);
			var expiryDate 	= new Date().setFullYear(arrExpiryDate[2], arrExpiryDate[0], arrExpiryDate[1]);
			var fromDate 	= new Date().setFullYear(arrFromDate[2], arrFromDate[0], arrFromDate[1]);
			var toDate 		= new Date().setFullYear(arrToDate[2], arrToDate[0], arrToDate[1]); */
			
			var formattedEffDate 			= (makeDate(objGIPIWPolbas.formattedEffDate));
			var formattedEndtExpiryDate		= (makeDate(objGIPIWPolbas.formattedEndtExpiryDate));
			var formattedFromdate 			= (makeDate($F("fromDate")));
			var formattedTodate 			= (makeDate($F("toDate")));
			
			if(formattedTodate > formattedEndtExpiryDate){
				customShowMessageBox("End date should not be later than the endorsement expiry date.", imgMessage.INFO, "hrefToDate");					
			}else if(formattedTodate < formattedEffDate){
				customShowMessageBox("End date should not be earlier than the endorsement effectivity date.", imgMessage.INFO, "hrefToDate");				
			}else if(!($F("fromDate").empty()) && formattedFromdate > formattedTodate){
				customShowMessageBox("End date should not be earlier than the start date.", imgMessage.INFO, "hrefToDate");
			}
		}
	}
//gzelle --END---
	observeBackSpaceOnDate("fromDate");
	$("fromDate").observe("blur", validateFromDate);
	$("fromDate").observe("keyup", function(event){	if(event.keyCode == 46){	$("fromDate").value = "";	}});
	
	observeBackSpaceOnDate("toDate");
	$("toDate").observe("blur", validateToDate);
	$("toDate").observe("keyup", function(event){	if(event.keyCode == 46){	$("toDate").value = "";	}});	
	
	$("hrefEQZone").observe("click", showEQZoneLOV);
	$("hrefTyphoonZone").observe("click", showTyphoonZoneLOV);
	$("hrefFloodZone").observe("click", showFloodZoneLOV);
	
</script>