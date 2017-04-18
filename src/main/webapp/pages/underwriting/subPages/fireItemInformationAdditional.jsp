<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>	
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">	
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;" masterDetail="true">		
		<input type="hidden" id="quoteId" value="0" />
		<input type="hidden" id="isLoaded" value="1" />
		
		<table width="100%" cellspacing="1" border="0">
			<tr><td><br /></td></tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Risk No. </td>
				<td class="leftAligned" style="padding-left: 3px;">
					<table style="width: 92%;" cellpadding="0">
						<tr>
							<td style="width: 20%;">
								<input type="text" tabindex="8" style="width: 100%; padding: 2px;" name="riskNo" id="riskNo" maxlength="5" value="1" />
							</td>
							<td class="rightAligned">Risk Item No. </td>
							<td style="width: 40%;" ><input type="text" tabindex="9" style="width: 96%; padding: 2px;" name="riskItemNo" id="riskItemNo" maxlength="9" 
								<c:if test="${pDisplayRisk ne 'Y' && parType eq 'E'}">
									disabled="disabled"
								</c:if>
								/></td>
						</tr>
					</table>					
				</td>
				<td class="rightAligned" style="width: 10%;">EQ Zone </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="10" id="eqZone" name="eqZone" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="eqZone" items="${eqZoneList}">
							<option value="${eqZone.eqZone}">${eqZone.eqDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">From Date </td>
				<td class="leftAligned">
					<div style="border: solid 1px white; width: 90%; height: 21px; ">
						<input type="text" tabindex="11" style="width: 85%; border: solid 1px gray;" name="fireFromDate" id="fireFromDate" readonly="readonly" value="${fromDate}"/>					
		    			<img id="hrefFromDate" style="float: right;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('fireFromDate'),this, null);" />
		    		</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Assignee </td>
				<td class="leftAligned"><input type="text" tabindex="12" style="width: 90%; padding: 2px;" name="assignee" id="assignee" maxlength="250" /></td>
				<td class="rightAligned" style="width: 10%;">Typhoon Zone </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="13" id="typhoonZone" name="typhoonZone" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="typhoon" items="${typhoonList}">
							<option value="${typhoon.typhoonZone}">${typhoon.typhoonZoneDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">To Date </td>
				<td class="leftAligned">
					<div style="border: solid 1px white; width: 90%; height: 21px; ">
						<input type="text" tabindex="14" style="width: 85%; border: solid 1px gray" name="fireToDate" id="fireToDate" readonly="readonly" value="${toDate}" />
						<img id="hrefToDate" style="float: right;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('fireToDate'),this, null);" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Type </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="15" id="frItemType" name="frItemType" style="width: 92.5%;" class="required">
						<option value=""></option>
						<c:forEach var="itemType" items="${itemTypeList}">
							<option value="${itemType.frItemType}">${itemType.frItemTypeDs}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Flood Zone </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="16" id="floodZone" name="floodZone" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="flood" items="${floodList}">
							<option value="${flood.floodZone}">${flood.floodZoneDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Location </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="17" style="width: 90%; padding: 2px;" name="locRisk1" id="locRisk1" maxlength="50" value="${mailAddr1}" /></td>				
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Region </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="18" id="fireRegionCd" name="fireRegionCd" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="fireRegion" items="${regionList}">
							<option value="${fireRegion.regionCd}"><fmt:formatNumber value='${fireRegion.regionCd}' pattern='0000' /> - ${fireRegion.regionDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Tariff Zone </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="19" id="tariffZone" name="tariffZone" style="width: 92.5%;" class="required">
						<option value=""></option>
						<c:forEach var="tariffZone" items="${tariffZoneList}">
							<option value="${tariffZone.tariffZone}">${tariffZone.tariffZoneDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">&nbsp; </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="20" style="width: 90%; padding: 2px;" name="locRisk2" id="locRisk2" maxlength="50" value="${mailAddr2}" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Province </td>
				<td class="leftAligned">
					<select tabindex="21" id="province" name="province" style="width: 92.5%;" class="required">
						<option value=""></option>
						<c:forEach var="province" items="${provinceList}">
							<option value="${province.provinceCd}" regionCd="${province.regionCd}">${province.provinceDesc}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Tariff Code </td>
				<td class="leftAligned" style="width: 23%;">					
					<select tabindex="22" id="tarfCd" name="tarfCd" style="width: 92.5%;" class="required">
						<option value=""></option>
						<c:forEach var="tariff" items="${tariffList}">
							<option value="${tariff.tariffCd}" tariffRate="${tariff.tariffRate}">${tariff.tariffCd} - ${tariff.tariffDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">&nbsp; </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="23" style="width: 90%; padding: 2px;" name="locRisk3" id="locRisk3" maxlength="50" value="${mailAddr3}" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">City </td>
				<td class="leftAligned">
					<select tabindex="24" id="city" name="city" style="width: 92.5%;" class="required">
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Construction </td>
				<td class="leftAligned">
					<select tabindex="25" id="construction" name="construction" style="width: 92.5%;" >
						<option value=""></option>
						<c:forEach var="construction" items="${constructionList}">
							<option value="${construction.constructionCd}">${construction.constructionDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Boundary Front </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="26" style="width: 90%; padding: 2px;" name="front" id="front" maxlength="2000" class="required" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">District </td>
				<td class="leftAligned">
					<select tabindex="27" id="district" name="district" style="width: 92.5%;" class="required">
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Construction Desc </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="28" style="width: 90%; padding: 2px;" name="constructionRemarks" id="constructionRemarks" maxlength="2000" /></td>
				<td class="rightAligned" style="width: 10%;">Right </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="29" style="width: 90%; padding: 2px;" name="right" id="right" maxlength="2000" class="required" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Block </td>
				<td class="leftAligned">
					<!-- blockNo column -->
					<select tabindex="30" id="block" name="block" style="width: 92.5%;" class="required">
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Occupancy </td>
				<td class="leftAligned" style="width: 23%;">
					<select tabindex="31" id="occupancy" name="occupancy" style="width: 92.5%;">
						<option value=""></option>
						<c:forEach var="occupancy" items="${occupancyList}">								
							<option value="${occupancy.occupancyCd}">${occupancy.occupancyDesc}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Left </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="32" style="width: 90%; padding: 2px;" name="left" id="left" maxlength="2000" class="required" /></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">Risks </td>
				<td class="leftAligned">
					<!-- riskCd column -->
					<select tabindex="33" id="risk" name="risk" style="width: 92.5%;" ><!-- class="<c:if test="${paramRiskTag eq 'Y'}"><c:out value="required"></c:out></c:if>" -->
					</select>
				</td>
				<td class="rightAligned" style="width: 10%;">Occupancy Desc</td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="34" style="width: 90%; padding: 2px;" name="occupancyRemarks" id="occupancyRemarks" maxlength="2000" /></td>
				<td class="rightAligned" style="width: 10%;">Rear </td>
				<td class="leftAligned" style="width: 23%;"><input type="text" tabindex="35" style="width: 90%; padding: 2px;" name="rear" id="rear" maxlength="2000" class="required" /></td>
			</tr>									
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input type="button" id="btnAdd" 	class="button" 			value="Add" />
					<input type="button" id="btnDelete" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>
		<select id="blockId" name="blockId" style="display: none;">
			<option value=""></option>
			<c:forEach var="block" items="${blockList}">
				<option value="${block.blockId}">${block.blockNo}</option>				
			</c:forEach>
		</select>
	</div>
</div>

<script type="text/javascript">
	var objProvinceListing = JSON.parse('${objProvinceListing}');
	var objCityListing = JSON.parse('${objCityListing}');
	var objDistrictListing = JSON.parse('${objDistrictListing}');
	var objBlockListing = JSON.parse('${objBlockListing}');
	var objRiskListing = JSON.parse('${objRiskListing}');

	function setProvince(province, itemProvinceCd){
		var region = $("fireRegionCd").options[$("fireRegionCd").selectedIndex].value;
		$("province").update("");
		$("province").insert({bottom : '<option value=""/>'});
		for (var i=0; i<province.length; i++){
			if(region != ""){
				if(province[i].regionCd == region){					
					var opt = '<option value="'+province[i].provinceCd+'" regionCd="'+province[i].regionCd+'">'+province[i].provinceDesc+'</option>';
					$("province").insert({bottom : opt});
				}
			}else{
				reloadProvinceList(province);
			}
		}
		$("province").value = itemProvinceCd;
	}

	function setCity(city, itemCityDesc){
		var provCode = $("province").options[$("province").selectedIndex].value;
		
		$("city").update("");
		$("city").insert({bottom : '<option value=""/>'});
		for(var i=0; i<city.length; i++){
			if(provCode == city[i].provinceCd){
				var opt= '<option value="'+city[i].cityCd+'" provinceCd="'+city[i].provinceCd+'" cityDesc="'+city[i].city+'">'+city[i].city+'</option>';
				$("city").insert({bottom : opt});
			}
		}
		for(var i=0; i<city.length; i++){
			if(provCode == city[i].provinceCd && itemCityDesc == city[i].city){
				$("city").value = city[i].cityCd;
			}
		}
	}

	function setDistrict(district, itemDistrictNo){
		var provCode = $("city").options[$("city").selectedIndex].getAttribute("provinceCd");
		var cityCode = $("city").options[$("city").selectedIndex].value;

		$("district").update("");
		$("district").insert({bottom : '<option value=""/>'});
		for(var i=0; i<district.length; i++){
			if(provCode == district[i].provinceCd && cityCode == district[i].cityCd){
				var opt='<option value="'+district[i].districtNo+'" provinceCd="'+district[i].provinceCd+'" cityCd="'+district[i].cityCd+'">'+district[i].districtNo+'</option>';
				$("district").insert({bottom : opt});
			}
		}
		$("district").value = itemDistrictNo;
	}

	function setBlock(block, itemBlockNo){
		var provCode = $("district").options[$("district").selectedIndex].getAttribute("provinceCd");
		var cityCode = $("district").options[$("district").selectedIndex].getAttribute("cityCd");
		var districtNo = $("district").options[$("district").selectedIndex].value;
		
		$("block").update("");
		$("block").insert({bottom : '<option value=""/>'});
		for(var i=0; i<block.length; i++){
			if(block[i].provinceCd == provCode && block[i].cityCd == cityCode && block[i].districtNo == districtNo){
				var opt='<option value="'+block[i].blockId+'" provinceCd="'+block[i].provinceCd+'" cityCd="'+block[i].cityCd+'" districtNo="'+block[i].districtNo+'" eqZone="'+block[i].eqZone+'" floodZone="'+block[i].floodZone+'" typhoonZone="'+block[i].typhoonZone+'">'+block[i].blockNo+'</option>';
				$("block").insert({bottom : opt});
			}
		}
		for(var i=0; i<block.length; i++){
			if(block[i].provinceCd == provCode && block[i].cityCd == cityCode && block[i].districtNo == districtNo && itemBlockNo == block[i].blockNo){
				$("block").value = block[i].blockId;
			}
		}
	}

	function setRisk(risk, itemRisk){
		var blockId = $("block").options[$("block").selectedIndex].value;
		
		$("risk").update("");
		$("risk").insert({bottom : '<option value=""/>'});
		for(var i=0; i<risk.length; i++){
			if(blockId == risk[i].blockId){
				var opt = '<option value="'+risk[i].riskCd+'" blockId="'+risk[i].blockId+'">'+risk[i].riskDesc+'</option>';
				$("risk").insert({bottom : opt});
			}
		}
		$("risk").value = itemRisk;
	}

	function reloadProvinceList(province){
		$("province").update("");
		$("province").insert({bottom : '<option value=""/>'});
		for (var i=0; i<province.length; i++){
				var opt = '<option value="'+province[i].provinceCd+'" regionCd="'+province[i].regionCd+'">'+province[i].provinceDesc+'</option>';
				$("province").insert({bottom : opt});
		}
	}

	function reloadCityList(city){
		$("city").update("");
		$("city").insert({bottom : '<option value=""/>'});
		for(var i=0; i<city.length; i++){
			var opt= '<option value="'+city[i].cityCd+'" provinceCd="'+city[i].provinceCd+'" cityDesc="'+city[i].city+'">'+city[i].city+'</option>';
			$("city").insert({bottom : opt});
		}
	}


	/*function getCityCode(cityList, paramVal){
		for (var i=0; i<cityList.length; i++){
			if (paramVal == cityList[i].city){
				$("city").value = cityList[i].cityCd;
			}
		}
	}*/
	
	$("riskNo").observe("blur",
		function(){
			var message = "Entered Risk No. is invalid. Valid value is from 1 to 99999.";

			if($("riskNo").value == ""){
				$("riskItemNo").value = "";
			}else if($("riskNo").value <= 0 || isNaN($("riskNo").value)){
				showMessageBox(message, imgMessage.INFO);		// modified by nica
				$("riskNo").value = "";
				$("riskItemNo").value = "";
			}else{
				if(($("riskNo").value - parseInt($("riskNo").value)) != 0){
					showMessageBox(message, imgMessage.INFO);
					$("riskNo").value = parseInt($("riskNo").value);
				}
				if ($F("riskItemNo") == null || $F("riskItemNo").blank()){
					generateRiskItemNo();
				}
			}
		});

	$$("div[name='rowItem']").each(function(row){
		row.observe("click", function(){
			if(row.hasClassName('selectedRow')){
				reloadCityList(objCityListing);
				//getCityCode(objCityListing,row.down("input", 45).value);
				//setProvince(objProvinceListing, row.down("input", 42).value);
				$("province").value = row.down("input", 42).value; // nica
				//setCity(objCityListing, $("city").value);
				setCity(objCityListing, row.down("input", 45).value);
				setDistrict(objDistrictListing, row.down("input", 48).value);
				setBlock(objBlockListing, row.down("input", 51).value);
				setRisk(objRiskListing,row.down("input", 54).value );
				
			}else{
				reloadProvinceList(objProvinceListing);
				$("province").value 			= "";
				$("city").value 				= "";
				$("district").value 			= "";
				$("block").value 				= "";
				$("risk").value 				= "";
			}
		});
	});
	
	$("riskItemNo").observe("blur",
		function(){
			var message =  "Entered risk item no. is invalid. Valid value is from 1 to 999999999.";
			
			if(($("riskItemNo").value <= 0 || isNaN($("riskItemNo").value)) && $("riskItemNo").value != ""){
				showMessageBox(message, imgMessage.INFO);		// modified by nica
				$("riskItemNo").value = "";
			}else if ($("riskItemNo").value != ""){
				if(($("riskItemNo").value - parseInt($("riskItemNo").value)) != 0){
					showMessageBox(message, imgMessage.INFO);
					generateRiskItemNo();
				}
			}
	});	

	$("fireFromDate").observe("blur",
		function(){			
			var dateElem	= $F("fromDate").split("-");
			var inceptDate 	= new Date().setFullYear(dateElem[2], dateElem[0], dateElem[1]);
			dateElem = $F("toDate").split("-");
			var expiryDate 	= new Date().setFullYear(dateElem[2], dateElem[0], dateElem[1]);
			dateElem = $F("fireFromDate").split("-");
			var fromDate	= new Date().setFullYear(dateElem[2], dateElem[0], dateElem[1]);
			dateElem = $F("fireToDate").split("-");
			var toDate		= new Date().setFullYear(dateElem[2], dateElem[0], dateElem[1]);
				if(fromDate > expiryDate){
					showMessageBox("From Date should not be later than the Expiry date.", imgMessage.INFO); /* I */
					$("fireFromDate").value = $F("fromDate");
					return false;
				} else if(fromDate < inceptDate){
					showMessageBox("From Date should not be earlier than the Inception date.", imgMessage.INFO); /* I */
					$("fireFromDate").value = $F("fromDate");
					return false;
				}else if(fromDate > toDate){
					if($F("fireToDate") != null && !($F("fireToDate").blank())){
						showMessageBox("From Date should not be later than the To Date.", imgMessage.INFO); /* I */
						$("fireFromDate").value = $F("fromDate");
						return false;
					}
				}			
		});

	$("fireToDate").observe("blur",
			function(){			
				var dateElem	= $F("fromDate").split("-");
				var inceptDate 	= new Date().setFullYear(dateElem[2], dateElem[0], dateElem[1]);
				dateElem = $F("toDate").split("-");
				var expiryDate 	= new Date().setFullYear(dateElem[2], dateElem[0], dateElem[1]);
				dateElem = $F("fireFromDate").split("-");
				var fromDate	= new Date().setFullYear(dateElem[2], dateElem[0], dateElem[1]);
				dateElem = $F("fireToDate").split("-");
				var toDate		= new Date().setFullYear(dateElem[2], dateElem[0], dateElem[1]);

					if(toDate > expiryDate){
						showMessageBox("To Date should not be later than the Expiry Date.", imgMessage.INFO); /* I */
						$("fireToDate").value = $F("toDate");
						return false;
					} else if(toDate < inceptDate){
						showMessageBox("To Date should not be earlier than the Inception Date.", imgMessage.INFO); /* I */
						$("fireToDate").value = $F("toDate");
						return false;
					}else if(toDate < fromDate){
						if($F("fireFromDate") != null && !($F("fireFromDate").blank())){
							showMessageBox("To Date should not be earlier than From Date", imgMessage.INFO);
							$("fireToDate").value = $F("toDate");
							return false;
						}
					}			
			});

		$("fireRegionCd").observe("change", 
			function(){
			$("regionCd").value = $("fireRegionCd").options[$("fireRegionCd").selectedIndex].value;
			setProvince(objProvinceListing, "");
			$("province").value = "";
			$("city").value = "";
			$("district").value = "";
			$("block").value = "";
			$("risk").value = "";
			
		});
		
		$("province").observe("change", 
			function ()	{
			var regionCd = $("province").options[$("province").selectedIndex].getAttribute("regionCd");
			
			for(var i=0; i<$("fireRegionCd").length; i++){
				if($("fireRegionCd").options[i].value == regionCd ){
					$("fireRegionCd").selectedIndex = i;
				}
			}
			$("regionCd").value = $("fireRegionCd").options[$("fireRegionCd").selectedIndex].value;
			if($("province").value != ""){
				$("city").enable();
			}else{
				showMessageBox("Province is required!", imgMessage.ERROR);
			}
			setCity(objCityListing, "");
			$("city").value = "";
			$("district").value = "";
			$("block").value ="";
			$("risk").value = "";
			
		});	
	
		$("city").observe("change", 
			function(){
			var provCode = $("city").options[$("city").selectedIndex].getAttribute("provinceCd");

			if($("city").value != ""){
				$("district").enable();
			}else{
				showMessageBox("City is required!", imgMessage.ERROR);
			}
			
			setDistrict(objDistrictListing, "");
			$("block").value = "";
			$("risk").value = "";
		});

		$("district").observe("change", 
			function(){
			if($("district").value != ""){
				$("block").enable();
			}else{
				showMessageBox("District is required!", imgMessage.ERROR);
			}
			setBlock(objBlockListing, "");
			$("risk").value = "";
		});

		$("block").observe("change", 
			function(){
			
			var eqZone = $("block").options[$("block").selectedIndex].getAttribute("eqZone");
			var floodZone = $("block").options[$("block").selectedIndex].getAttribute("floodZone");
			var typhoonZone = $("block").options[$("block").selectedIndex].getAttribute("typhoonZone");

			$("eqZone").value = eqZone;
			$("floodZone").value = floodZone;
			$("typhoonZone").value = typhoonZone;

			if($("block").value != ""){
				$("risk").enable();
			}else{
				showMessageBox("Block is required!", imgMessage.ERROR);
			}
			
			setRisk(objRiskListing, "");
			$("risk").value = "";
			
		});
		
		//

	function generateRiskItemNo(){
		var riskNos = $F("riskNumbers").trim().split(" ");
		var riskItemNos = $F("riskItemNumbers").trim().split(" ");		
		var riskItemNosList = "";
		var lastItemNo = 0;
		
		for(var index=0, len=riskNos.length; index < len; index++){			
			if(riskNos[index] == $F("riskNo")){				
				riskItemNosList = riskItemNosList + riskItemNos[index] + " ";
			}			
		}

		var itemNos = riskItemNosList.trim().split(" ");		
		for(var index=0, len = itemNos.length; index < len; index++){
			for(var elem=0; elem < len; elem++){
				var temp = 0;			
				if(parseInt(itemNos[elem]) > parseInt(itemNos[elem+1])){
					temp = itemNos[elem];
					itemNos[elem] = itemNos[elem+1];
					itemNos[elem+1] = temp;
				}
			}			
		}

		riskItemNosList = itemNos;
		
		for(var index=0, len = riskItemNosList.length; index < len; index++){
			var currentItem = parseInt(riskItemNosList[index]);
			var nextItem = parseInt(riskItemNosList[index+1]);
			
			if((nextItem - currentItem) > 1){
				lastItemNo = currentItem + 1;
				break;
			}
		}		
		
		if(riskItemNosList.last().trim() == ""){
			$("riskItemNo").value = "1";
		} else{
			$("riskItemNo").value = lastItemNo == 0 ? parseInt(riskItemNosList.last()) + 1 : lastItemNo; 
		}		
	}
	
</script>