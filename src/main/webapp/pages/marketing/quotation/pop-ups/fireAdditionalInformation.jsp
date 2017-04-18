<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="additionalInformationDiv${aiItemNo}" name="additionalInformationDiv" style="">
<input type="hidden" id="aiItemNo${aiItemNo}" name="aiItemNo${aiItemNo}" value="${aiItemNo}"/>
<div class="sectionDiv" id="additionalInformationSectionDiv${aiItemNo}" name="additionalInformationSectionDiv" style="overflow: visible;">
	<form id="fireAdditionalInformationForm${aiItemNo}" 	name="fireAdditionalInformationForm">
		<input type="hidden" id="quoteId${aiItemNo}" 		name="quoteId" 			value="${gipiQuote.quoteId}" />
		<input type="hidden" id="userId${aiItemNo}" 		name="userId" 			value="${userId}" />
		<input type="hidden" id="aiItemNo${aiItemNo}" 		name="aiItemNo" 		value="${aiItemNo}" />
		<input type="hidden" id="sublineCd${aiItemNo}" 		name="sublineCd" 		value="${sublineCd}" />
		<!-- <input type="hidden" id="blockId${aiItemNo}" 		name="blockId" 			value="${gipiQuoteItem.blockId}" /> -->
		<input type="hidden" id="inceptionDate${aiItemNo}" 	name="inceptionDate" 	value="${inceptDate}" />
		<input type="hidden" id="expirationDate${aiItemNo}" name="expirationDate" 	value="${expiryDate}" />
		<div id="spinLoadingDiv"></div>
		
		<div id="fireAdditionalInformationDiv" align="center">
			<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
			<table align="center" style="margin-top: 10px;	margin-bottom: 10px;">
				<tr>
					<td class="rightAligned" style="width: 90px;">Assignee</td>
					<td class="leftAligned"colspan="3"><input tabindex="1" id="assignee${aiItemNo}" name="assignee" type="text" style="width: 300px;" value="${gipiQuoteItemFI.assignee}" maxlength="250" /></td>
					<td class="rightAligned" style="width: 90px;">Date</td>
					<td class="leftAligned">
						<!-- <input tabindex="2" id="date" name="date" type="text" style="width: 123px;" value="" /> -->
						<span>
					    	<input style="width: 78px; border: none;" id="date${aiItemNo}" name="date" type="text" value="<fmt:formatDate value="${gipiQuoteItemFI.dateFrom}" pattern="MM-dd-yyyy" />" readonly="readonly" />
					    	<img id="hrefDate${aiItemNo}" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('date${aiItemNo}').focus(); scwShow($('date${aiItemNo}'),this, null);" />
					    </span>
					   <!-- <span style="float: left; margin: 0 10px;"></span>
						 <input tabindex="3" id="date1" name="date1" type="text" style="width: 130px; " value="" /> -->
						<span style="float: left; margin-left: 9px;">
<!--					    	<input style="width: 78px; border: none;" id="date1${aiItemNo}" name="date1" type="text" value="${gipiQuoteItemFI.dateTo}" readonly="readonly" />-->
					    	<input style="width: 78px; border: none;" id="date1${aiItemNo}" name="date1" type="text" value="<fmt:formatDate value="${gipiQuoteItemFI.dateTo}" pattern="MM-dd-yyyy" />" readonly="readonly" />
					    	<img id="hrefDate1${aiItemNo}" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('date1${aiItemNo}').focus(); scwShow($('date1${aiItemNo}'),this, null);" />
					    </span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Type</td>
					<td class="leftAligned"style="width: 300px;" colspan="3" >				
						<select style="width: 308px;" tabindex="4" id="fireItemType${aiItemNo}" name="fireItemType">
							<option value=""></option>
							<c:forEach var="fireItem" items="${itemTypeList}">
								<option value="${fireItem.frItemType}"
								<c:if test="${gipiQuoteItemFI.frItemType == fireItem.frItemType}">
								selected="selected"
								</c:if>
								>${fireItem.frItemTypeDs}</option>
							</c:forEach>
						</select>
					</td>				
					<td class="rightAligned">Location</td>																									
					<td class="leftAligned"><input tabindex="5" id="locRisk1${aiItemNo}" name="locRisk1" type="text" style="width: 217px;" 
						value="${gipiQuoteItemFI.locRisk1}" maxlength="50"/>
					</td>		
					
				</tr>
				<tr>
					<td class="rightAligned">Province</td>
					<td class="leftAligned" colspan="1">	
						<div style="float: left; border: solid 1px gray; width: 130px; height: 21px; margin-right: 3px;" class="required" >
							<input type="hidden" id="regionCd${aiItemNo}" name="regionCd" />
							<input type="hidden" id="provinceCd${aiItemNo}" name="provinceCd" value="${gipiQuoteItemFI.provinceCd}"/>
							<input type="text" tabindex="21" style="float: left; margin-top: 0px; margin-right: 3px; width: 100px; border: none;" name="province" id="province${aiItemNo}" readonly="readonly" value="${gipiQuoteItemFI.provinceDesc}" class="required" />
							<img class="hover" id="hrefProvince${aiItemNo}" alt="goProvince" style="height: 18px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
								
						<!--<select style="width: 132px;" tabindex="6" id="province${aiItemNo}" name="province">
							<option value=""></option>
							<c:forEach var="provinceList" items="${provinceList}">
								<option value="${provinceList.provinceCd}"
								<c:if test="${gipiQuoteItemFI.provinceDesc == provinceList.provinceDesc}">
								selected="selected"
								</c:if>
								>${provinceList.provinceDesc}</option>
							</c:forEach>
						</select>
					--></td>					
					<td class="rightAligned">City</td>
					<td class="leftAligned">
					<div style="float: left; border: solid 1px gray; width: 130px; height: 21px; margin-right: 3px;" class="required" >
						<input type="hidden" id="cityCd${aiItemNo}" name="cityCd" value="${gipiQuoteItemFI.cityCd}"/>
						<input type="text" tabindex="24" style="float: left; margin-top: 0px; margin-right: 3px; width: 100px; border: none;" name="city" id="city${aiItemNo}" readonly="readonly" value="${gipiQuoteItemFI.city}" class="required" />
						<img class="hover" id="hrefCity${aiItemNo}" alt="goCity" style="height: 18px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					
						<!--<select style="width: 132px;" tabindex="7" id="city${aiItemNo}"  >
							<option value="" ></option>
							<c:forEach var="cityList" items="${cityList}">
								<option value="${cityList.cityCd}" provinceCd="${cityList.provinceCd}" 
									
								>${cityList.city}</option>
							</c:forEach>
						</select>				
					--></td>
					<td></td>
					<td class="leftAligned"><input tabindex="8" id="locRisk2${aiItemNo}" name="locRisk2" type="text" style="width: 217px;" value="${gipiQuoteItemFI.locRisk2}" maxlength="50" /></td>			
				</tr>
				<tr>
					<td class="rightAligned">District</td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 130px; height: 21px; margin-right: 3px;" class="required" >
							<input type="hidden" id="districtNo${aiItemNo}" name="districtNo" value="${gipiQuoteItemFI.districtNo}"/>						
							<input type="text" tabindex="27" style="float: left; margin-top: 0px; margin-right: 3px; width: 100px; border: none;" name="district" id="district${aiItemNo}" readonly="readonly" value="${gipiQuoteItemFI.districtNo}" class="required" />
							<img class="hover" id="hrefDistrict${aiItemNo}" alt="goDistrict" style="height: 18px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />												
						</div>
						<!--<select style="width: 132px;" tabindex="9" id="district${aiItemNo}" name="district">
							<option value=""></option>
							<c:forEach var="districtList" items="${districtList}">
								<option value="${districtList.districtNo}" provinceCd="${districtList.provinceCd}" cityCd="${districtList.cityCd}"
									<c:if test="${gipiQuoteItemFI.districtNo eq districtList.districtNo}">
									selected="selected"
									</c:if>
								>${districtList.districtNo}</option>
							</c:forEach>
						</select>
					--></td>					
					<td class="rightAligned">Block</td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 130px; height: 21px; margin-right: 3px;" class="required" >
							<input type="hidden" id="blockId${aiItemNo}" name="blockId" value="${gipiQuoteItemFI.blockId}"/>
							<input type="text" tabindex="30" style="float: left; margin-top: 0px; margin-right: 3px; width: 100px; border: none;" name="blockNo" id="blockNo${aiItemNo}" readonly="readonly" value="${gipiQuoteItemFI.blockNo}" class="required" />
							<img class="hover" id="hrefBlock${aiItemNo}" alt="goBlock" style="height: 18px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
						</div>
						<!--
						<select style="width: 132px;" tabindex="10" id="block${aiItemNo}" name="block">
							<option value=""></option>
							<c:forEach var="block" items="${blockList}">
								<option value="${block.blockId}" provinceCd="${block.provinceCd}" cityCd="${block.cityCd}" districtNo="${block.districtNo}" eqZone="${block.eqZone}" typhoonZone="${block.typhoonZone}" floodZone="${block.floodZone}"
									<c:if test="${gipiQuoteItemFI.blockNo eq block.blockNo}">
									selected="selected"
									</c:if>
								>${block.blockNo}</option>
							</c:forEach>
						</select>
					--></td>
					<td class="rightAligned">&nbsp;</td>
					<td class="leftAligned"colspan="3"><input tabindex="11" id="locRisk3${aiItemNo}" name="locRisk3" type="text" style="width: 217px;" value="${gipiQuoteItemFI.locRisk3}" maxlength="50" /></td>			
				</tr>	
				<tr>
					<td class="rightAligned">Risks</td>
					<td class="leftAligned"colspan="3">	
					<select style="width: 308px;" tabindex="12" id="risk${aiItemNo}" name="risk">
						<option value=""></option>
						<c:forEach var="risk" items="${riskList}">
							<option value="${risk.blockId}_${risk.riskCd}" blockId="${risk.blockId}" disabled="disabled" style="display: none;">${risk.riskDesc}</option>
						</c:forEach>
					</select>		
					<!-- 		
						<select style="width: 308px;" tabindex="12" id="risk${aiItemNo}" name="risk">
							<option value=""></option>
							<c:forEach var="riskList" items="${riskList}">
								<option value="${riskList.riskCd}" blockId="${riskList.blockId}" disabled="disabled"
									<c:if test="${gipiQuoteItemFI.riskCd eq riskList.riskCd}">
									selected="selected"
									</c:if>
								>${riskList.riskDesc}</option>
							</c:forEach>
						</select> -->
					</td>	
					<td class="rightAligned">Boundary Front</td>
					<td class="leftAligned"><input tabindex="12" id="boundaryFront${aiItemNo}" name="boundaryFront" type="text" style="width: 217px;" value="${gipiQuoteItemFI.front}" maxlength="2000" /></td>			
				</tr>
				<tr>
					<td class="rightAligned">EQ Zone</td>
					<td class="leftAligned"colspan="3">	
						<select style="width: 308px;" tabindex="13" id="eqZone${aiItemNo}" name="eqZone">
							<option value=""></option>
							<c:forEach var="eqZoneList" items="${eqZoneList}">
								<option value="${eqZoneList.eqZone}"
								<c:if test="${gipiQuoteItemFI.eqZone == eqZoneList.eqZone}">
								selected="selected"
								</c:if>
								>${eqZoneList.eqDesc}</option>
							</c:forEach>
						</select>
					</td>	
					<td class="rightAligned">Right</td>
					<td class="leftAligned"><input tabindex="14" id="boundaryRight${aiItemNo}" name="boundaryRight" type="text" style="width: 217px;" value="${gipiQuoteItemFI.right}" maxlength="2000" /></td>			
				</tr>
				<tr>
					<td class="rightAligned">Typhoon Zone</td>
					<td class="leftAligned" colspan="3">				
						<select style="width: 308px;" tabindex="14" id="typhoonZone${aiItemNo}" name="typhoonZone">
							<option value=""></option>
							<c:forEach var="typhoon" items="${typhoonList}">
								<option value="${typhoon.typhoonZone}"
								<c:if test="${gipiQuoteItemFI.typhoonZone == typhoon.typhoonZone}">
								selected="selected"
								</c:if>
								>${typhoon.typhoonZoneDesc}</option>
							</c:forEach>
						</select>
					</td>	
					<td class="rightAligned">Left</td>
					<td class="leftAligned"><input tabindex="15" id="boundaryLeft${aiItemNo}" name="boundaryLeft" type="text" style="width: 217px;" value="${gipiQuoteItemFI.left}" maxlength="2000" /></td>			
				</tr>
				<tr>
					<td class="rightAligned">Flood Zone</td>
					<td class="leftAligned"colspan="3">				
						<select style="width: 308px;" tabindex="16" id="floodZone${aiItemNo}" name="floodZone">
							<option value=""></option>
							<c:forEach var="flood" items="${floodList}">
								<option value="${flood.floodZone}"
								<c:if test="${gipiQuoteItemFI.floodZone == flood.floodZone}">
								selected="selected"
								</c:if>
								>${flood.floodZoneDesc}</option>
							</c:forEach>
						</select>
					</td>	
					<td class="rightAligned">Rear</td>
					<td class="leftAligned"><input tabindex="17" id="boundaryRear${aiItemNo}" name="boundaryRear" type="text" style="width: 217px;" value="${gipiQuoteItemFI.rear}" maxlength="2000" /></td>			
				</tr>
				<tr>
					<td class="rightAligned">Tariff Zone</td>
					<td class="leftAligned"colspan="3">				
						<select style="width: 308px;" tabindex="18" id="tariffZone${aiItemNo}" name="tariffZone">
							<option value=""></option>
							<c:forEach var="tariffZone" items="${tariffZoneList}">
								<option value="${tariffZone.tariffZone}" tariffCd="${tariffZone.tariffCd}"
								<c:if test="${gipiQuoteItemFI.tariffZone == tariffZone.tariffZone}">
								selected="selected"
								</c:if>
								>${tariffZone.tariffZoneDesc}</option>
							</c:forEach>
						</select>
					</td>					
					<td class="rightAligned">Tariff Code</td>
					<td class="leftAligned">
						<select style="width: 225px;" tabindex="19" id="tariffCode${aiItemNo}" name="tariffCode">
							<option value=""></option>
							<c:forEach var="tariff" items="${tariffList}">
								<option value="${tariff.tariffCd}"
								<c:if test="${gipiQuoteItemFI.tariffCd == tariff.tariffCd}">
								selected="selected"
								</c:if>
								>${tariff.tariffCd} - ${tariff.tariffDesc}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Occupancy</td>
					<td class="leftAligned"colspan="3">
						<select style="width: 308px;" tabindex="20" id="occupancy${aiItemNo}" name="occupancy">
							<option value=""></option>
							<c:forEach var="occupancy" items="${occupancyList}">
								<option value="${occupancy.occupancyCd}"
								<c:if test="${gipiQuoteItemFI.occupancyCd == occupancy.occupancyCd}">
								selected="selected"
								</c:if>
								 style="width:250px; ">${occupancy.occupancyDesc}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned">Occ Remarks</td>
					<td class="leftAligned"><input tabindex="21" id="occupancyRemarks${aiItemNo}" name="occupancyRemarks" type="text" style="width: 217px;" value="${gipiQuoteItemFI.occupancyRemarks}" maxlength="2000" /></td>
				</tr>
				<tr>
					<td class="rightAligned" class="rightAligned">Construction</td>
					<td class="leftAligned">
						<select style="width: 132px;" tabindex="" id="construction${aiItemNo}" name="construction">
							<option value=""></option>
							<c:forEach var="construction" items="${constructionList}">
								<option value="${construction.constructionCd}"
								<c:if test="${gipiQuoteItemFI.constructionCd == construction.constructionCd}">
								selected="selected"
								</c:if>
								>${construction.constructionDesc}</option>
							</c:forEach>
						</select>
					</td> 
					<!--  <td class="rightAligned">Const Remarks</td> -->
					<td class="leftAligned"  colspan="2"><input tabindex="" id="constructionRemarks${aiItemNo}" name="constructionRemarks" type="text" style="width: 160px;" value="${gipiQuoteItemFI.constructionRemarks}" maxlength="2000" /></td>
				</tr>
			</table>
		</div>
	</form>
</div>
	<!-- <input type="hidden" id="blockNo" name="blockNo" value="${gipiQuoteItemFI.blockNo}"/> -->
</div>
<script>

function setDefaultLoc(){
	$("locRisk1${aiItemNo}").value = "${defaultLoc1}";
	$("locRisk2${aiItemNo}").value = "${defaultLoc2}";
	$("locRisk3${aiItemNo}").value = "${defaultLoc3}";
}

try{
	//filterLOVByBlock();
	initializeAll();
	addStyleToInputs();

	<c:if test="${empty gipiQuoteItemFI}">
		setDefaultLoc();
	</c:if>
	
	// ADDED BY IRWIN, MARCH 4, 2011. OVERLAY FUNCTIONS 
	$("hrefProvince${aiItemNo}").observe("click", function(){
		var aiItemNo = "${aiItemNo}"; //ROY PAG JSON MO NA, REMOVED MO NA TO AT SA CONTROLLER. FOR NOW SET ATTRIBUTE KO MUNA.CHECK MO RIN MGA POPUPS
		showOverlayContent2(contextPath+"/GIPIQuotationFireController?action=showProvince&aiItemNo="+aiItemNo, "List of Province", 620, "");
	});
	$("hrefCity${aiItemNo}").observe("click", function(){
		var aiItemNo = "${aiItemNo}"; //ROY PAG JSON MO NA, REMOVED MO NA TO AT SA CONTROLLER. FOR NOW SET ATTRIBUTE KO MUNA.CHECK MO RIN MGA POPUPS
		var provinceCd 	= $F("provinceCd${aiItemNo}");
		var regionCd 	= $F("regionCd${aiItemNo}");
		var url			= contextPath + "/GIPIQuotationFireController?action=showCity&provinceCd=" + provinceCd + "&regionCd=" + regionCd+"&aiItemNo="+aiItemNo;
		showOverlayContent2(url, "List of Province", 620, "");
	});

	$("hrefDistrict${aiItemNo}").observe("click", function(){	showBlock("district");	});

	$("hrefBlock${aiItemNo}").observe("click", function(){	showBlock("block");	});
	function showBlock(column){
		var aiItemNo = "${aiItemNo}"; //ROY PAG JSON MO NA, REMOVED MO NA TO AT SA CONTROLLER. FOR NOW SET ATTRIBUTE KO MUNA.CHECK MO RIN MGA POPUPS
		var regionCd	= $F("regionCd${aiItemNo}");
		var provinceCd 	= $F("provinceCd${aiItemNo}");
		var cityCd 		= $F("cityCd${aiItemNo}");
		var districtNo 	= $F("districtNo${aiItemNo}");
		var url			= contextPath + "/GIPIQuotationFireController?action=showBlock&column=" + column + "&regionCd=" + regionCd + "&provinceCd=" + provinceCd + "&cityCd=" + cityCd + "&districtNo=" + districtNo+"&aiItemNo="+aiItemNo;
		
		showOverlayContent2(url, "List of Disctrict and Block", 820, "");
		//showOverlayContent(contextPath + "/GIPIWFireItmController?action=showBlock", "List of Disctrict and Block", 400, "", 10, 10, 10);
	}
	// END OF MOD.

	$("btnSave").observe("click", function ()	{
	
		if($F("province${aiItemNo}") != ""){
			if($F("city${aiItemNo}") == "" || $F("district${aiItemNo}") == "" || $F("blockNo${aiItemNo}") == ""){
				showMessageBox("Province, City, District and Block are required if any of the field is filled up.", imgMessage.ERROR);
			}else{
				saveAllInformation2();
			}
		}else{
			saveAllInformation2();
		}
		
	});

	function saveAllInformation2(){
		new Ajax.Request(contextPath+"/GIPIQuotationInformationController?action=saveQuotationInformation&quoteId="+$F("quoteId")+"&lineCd="+$F("lineCd"),
		{	method: "POST",
			postBody: Form.serialize("quotationInformationForm"),
			onCreate: function () {
				$("quotationInformationForm").disable();
				showNotice("Saving, please wait...");
			},
			onComplete: function (response)	{
				$("quotationInformationForm").enable();
				enableButton("btnEditQuotation");
				enableButton("btnSave");
				enableButton("btnPrint");
				if (checkErrorOnResponse(response)) {
					hideNotice(response.responseText);
					if (response.responseText == "SUCCESS")	{
						showMessageBox(response.responseText,imgMessage.SUCCESS);
						enableButton("btnEditQuotation");
						enableButton("btnSave");
						enableButton("btnPrint");
						quoteInfoSaveIndicator = 1;
					} 
				}
				enableQuotationMainButtons();
				showAccordionLabelsOnQuotationMain();
			}
		});
	}
	
	

	function getDefaultEQTYFL(){  // filters the EQ, typhoon and flood for default value. Based on block
		var blockEqZone = $("blockNo${aiItemNo}").options[$("block${aiItemNo}").selectedIndex].getAttribute("eqZone");
		var blockTyphoonZone = $("block${aiItemNo}").options[$("block${aiItemNo}").selectedIndex].getAttribute("typhoonZone");
		var blockFloodZone = $("block${aiItemNo}").options[$("block${aiItemNo}").selectedIndex].getAttribute("floodZone");
		//if ($F("eqZone${aiItemNo}") == ""){}
		for (var i = 0; i<$("eqZone${aiItemNo}").length; i++){
			if($("eqZone${aiItemNo}").options[i].value == blockEqZone){
				$("eqZone${aiItemNo}").options.selectedIndex = i;
			}	
		}
		for (var i = 0; i<$("typhoonZone${aiItemNo}").length; i++){
			if($("typhoonZone${aiItemNo}").options[i].value == blockTyphoonZone){
				$("typhoonZone${aiItemNo}").options.selectedIndex = i;
			}
		}
		for (var i = 0; i<$("floodZone${aiItemNo}").length; i++){
			if($("floodZone${aiItemNo}").options[i].value == blockFloodZone){
				$("floodZone${aiItemNo}").options.selectedIndex = i;
			}	
		}
	}

	$("blockNo${aiItemNo}").observe("change", function ()	{
		//filterRisk($F("blockId${aiItemNo}"));
		//filterRisk();
		updateLocalLOV("risk${aiItemNo}", "blockId${aiItemNo}", $F("blockId${aiItemNo}"));
		getDefaultEQTYFL();
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
	updateLocalLOV("risk${aiItemNo}", "blockId${aiItemNo}", $F("blockId${aiItemNo}"));
	
	function filterRisk(){
		var blockId = $F("blockId${aiItemNo}");
		for (var i = 0; i<$("risk${aiItemNo}").length; i++){
			if(blockId != $("risk${aiItemNo}").options[i].getAttribute("blockId")){
				$("risk${aiItemNo}").options[i].hide();
				$("risk${aiItemNo}").options[0].show(); 
			}else{
				$("risk${aiItemNo}").options[i].show();
			}
		} 
	
	}
	var inceptDate = makeDate($F("inceptionDate${aiItemNo}"));
	var expiryDate = makeDate($F("expirationDate${aiItemNo}"));

	$("date${aiItemNo}").setStyle("border: none; width: 78px; margin: 0;");
	$("date${aiItemNo}").up("span", 0).setStyle("border: 1px solid gray; float: left; padding: 0; width: 106px; background: #FFFFFF;");

	$("date1${aiItemNo}").setStyle("border: none; width: 78px; margin: 0;");	
	$("date1${aiItemNo}").up("span", 0).setStyle("border: 1px solid gray; float: left; padding: 0; width: 106px; background: #FFFFFF;");
	$("date${aiItemNo}").observe("blur", function(){
		var date = makeDate($F("date${aiItemNo}"));
		if(date<inceptDate||date>expiryDate){
			showMessageBox("Date From and Date To must be within the Inception Date and Expiry Date.", imgMessage.ERROR);
			$("date${aiItemNo}").value = "";
			$("date${aiItemNo}").focus();
		}else {
			$("noticePopup").hide();
		}
	});
	$("tariffZone${aiItemNo}").observe("change", function () {
		var tariffCd= $("tariffZone${aiItemNo}").options[$("tariffZone${aiItemNo}").selectedIndex].getAttribute("tariffCd");
		
		for (var i = 0; i<$("tariffCode${aiItemNo}").length; i++){
			if($("tariffCode${aiItemNo}").options[i].value == tariffCd){
				$("tariffCode${aiItemNo}").options.selectedIndex = i;
			}	
		}
	});
	
	
	$("date1${aiItemNo}").observe("blur", function () {
		var date = makeDate($F("date${aiItemNo}"));
		var date1 = makeDate($F("date1${aiItemNo}"));
		
		if(date1<date){
			//showNoticeInPopup("Date To must not be earlier than Date From."); 
			showMessageBox("Date To must not be earlier than Date From.", imgMessage.ERROR);
			$("date1${aiItemNo}").value = "";
			$("date1${aiItemNo}").focus();
		}else if (date1<inceptDate || date1>expiryDate) {
			//showNoticeInPopup("Date From and Date To must be within the Inception Date and Expiry Date.");
			showMessageBox("Date From and Date To must be within the Inception Date and Expiry Date.", imgMessage.ERROR);
			$("date1${aiItemNo}").value = "";
			$("date1${aiItemNo}").focus();
		} else {
			$("noticePopup").hide();
		}
	}); 
}catch(e){
	showErrorMessage("fireAdditionalInformation.jsp", e);
	//showMessageBox("" + e.message, imgMessage.ERROR);
}
</script>