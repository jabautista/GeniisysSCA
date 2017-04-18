<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% 	
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<!--<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="outerDiv">				
		<label id="">Additional Item Information</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
		</span>									
	</div>
</div>

-->
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv" changeTagAttr="true">	
	<div id="message" style="display:none;">${message}</div>
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;">
		<!-- Previous policy/ies endorsement of the par --><!--
		<div id="policyHistoryDiv" style="display: none;">
			<c:forEach var="policy" items="${gipiPolbasics}">
				<div id="policyRow${policy.policyId}" name="policyRow" style="display: none;">
					<input type="hidden" id="policyId${policy.policyId}" 			name="policyId" 		value="${policy.policyId}" />
					<input type="hidden" id="policyEndtNo${policy.endtNo}" 			name="policyEndtNo" 	value="${policy.endtNo}" />
					<input type="hidden" id="policyInceptDate${policy.inceptDate}" 	name="policyInceptDate" value="${policy.inceptDate}" />
					<input type="hidden" id="policyEffDate${policy.effDate}" 		name="policyEffDate" 	value="${policy.effDate}" />
					<input type="hidden" id="policyExpiryDate${policy.expiryDate}" 	name="policyExpiryDate" value="${policy.expiryDate}" />
					<input type="hidden" id="policyEndtIssCd${policy.policyId}" 	name="policyEndtIssCd" 	value="${policy.endtIssCd}" />
					<input type="hidden" id="policyEndtYy${policy.policyId}" 		name="policyEndtYy" 	value="${policy.endtYy}" />
					<input type="hidden" id="policyEndtSeqNo${policy.policyId}" 	name="policyEndtSeqNo" 	value="${policy.endtSeqNo}" />
					<input type="hidden" id="policyPolFlag${policy.policyId}" 		name="policyPolFlag" 	value="${policy.polFlag}" />
					<c:forEach var="item" items="${policy.gipiItems}">
						<div id="itemRow${item.itemNo}" name="itemRow" style="display: none;">		                   	
							<input type="hidden" id="polItemNo${item.itemNo}" 			name="polItemNo" 			value="${item.itemNo}" />
							<input type="hidden" id="polItemTitle${item.itemNo}" 		name="polItemTitle" 		value="${item.itemTitle}" />
							<input type="hidden" id="polItemGrp${item.itemNo}" 			name="polItemGrp" 			value="${item.itemGrp}" />
							<input type="hidden" id="polItemDesc${item.itemNo}" 		name="polItemDesc" 			value="${item.itemDesc}" />
							<input type="hidden" id="polItemDesc2${item.itemNo}" 		name="polItemDesc2" 		value="${item.itemDesc2}" />
							<input type="hidden" id="polTsiAmt${item.itemNo}" 			name="polTsiAmt" 			value="${item.tsiAmt}" />
							<input type="hidden" id="polPremAmt${item.itemNo}"    		name="polPremAmt" 			value="${item.premAmt}" />
							<input type="hidden" id="polAnnPremAmt${item.itemNo}" 		name="polAnnPremAmt" 		value="${item.annPremAmt}" />
							<input type="hidden" id="polAnnTsiAmt${item.itemNo}" 		name="polAnnTsiAmt" 		value="${item.annTsiAmt}" />
							<input type="hidden" id="polRecFlag${item.itemNo}" 			name="polRecFlag" 			value="${item.recFlag}" />
							<input type="hidden" id="polCurrencyCd${item.itemNo}" 		name="polCurrencyCd" 		value="${item.currencyCd}" />
							<input type="hidden" id="polCurrencyRt${item.itemNo}" 		name="polCurrencyRt" 		value="${item.currencyRt}" />
							<input type="hidden" id="polGroupCd${item.itemNo}" 			name="polGroupCd" 			value="${item.groupCd}" />
							<input type="hidden" id="polFromDate${item.itemNo}" 		name="polFromDate" 			value='<fmt:formatDate value='${item.fromDate}' pattern="MM-dd-yyyy" />' />
							<input type="hidden" id="polToDate${item.itemNo}" 			name="polToDate" 			value='<fmt:formatDate value='${item.toDate}' pattern="MM-dd-yyyy" />' />
							<input type="hidden" id="polPackLineCd${item.itemNo}" 		name="polPackLineCd" 		value="${item.packLineCd}" />
							<input type="hidden" id="polPackSublineCd${item.itemNo}" 	name="polPackSublineCd" 	value="${item.packSublineCd}" />
							<input type="hidden" id="polDiscountSw${item.itemNo}" 		name="polDiscountSw" 		value="${item.discountSw}" />
							<input type="hidden" id="polCoverageCd${item.itemNo}" 		name="polCoverageCd" 		value="${item.coverageCd}" />
							<input type="hidden" id="polOtherInfo${item.itemNo}" 		name="polOtherInfo" 		value="${item.otherInfo}" />
							<input type="hidden" id="polSurchargeSw${item.itemNo}" 		name="polSurchargeSw" 		value="${item.surchargeSw}" />
							<input type="hidden" id="polRegionCd${item.itemNo}" 		name="polRegionCd" 			value="${item.regionCd}" />
							<input type="hidden" id="polChangedTag${item.itemNo}" 		name="polChangedTag" 		value="${item.changedTag}" />
							<input type="hidden" id="polProrateFlag${item.itemNo}" 		name="polProrateFlag" 		value="${item.prorateFlag}" />
							<input type="hidden" id="polCompSw${item.itemNo}" 			name="polCompSw" 			value="${item.compSw}" />
							<input type="hidden" id="polShortRtPercent${item.itemNo}" 	name="polShortRtPercent" 	value="${item.shortRtPercent}" />
							<input type="hidden" id="polPackBenCd${item.itemNo}" 		name="polPackBenCd" 		value="${item.packBenCd}" />
							<input type="hidden" id="polPaytTerms${item.itemNo}" 		name="polPaytTerms" 		value="${item.paytTerms}" />
							<input type="hidden" id="polRiskNo${item.itemNo}" 			name="polRiskNo" 			value="${item.riskNo}" />
							<input type="hidden" id="polRiskItemNo${item.itemNo}" 		name="polRiskItemNo" 		value="${item.riskItemNo}" />
		
							<input type="hidden" id="polCargoPackMethod${item.itemNo}" 			name="polCargoPackMethod" 			value="${item.gipiCargo.packMethod}" />
							<input type="hidden" id="polCargoBlAwb${item.itemNo}" 				name="polCargoBlAwb" 				value="${item.gipiCargo.blAwb}" />
							<input type="hidden" id="polCargoTranshipOrigin${item.itemNo}"		name="polCargoTranshipOrigin" 		value="${item.gipiCargo.transhipOrigin}" />
							<input type="hidden" id="polCargoTranshipDestination${item.itemNo}"	name="polCargoTranshipDestination" 	value="${item.gipiCargo.transhipDestination}" />
							<input type="hidden" id="polCargoVoyageNo${item.itemNo}"			name="polCargoVoyageNo" 			value="${item.gipiCargo.voyageNo}" />
							<input type="hidden" id="polCargoLcNo${item.itemNo}"				name="polCargoLcNo" 				value="${item.gipiCargo.lcNo}" />
							<input type="hidden" id="polCargoEtd${item.itemNo}"					name="polCargoEtd" 					value="<fmt:formatDate value="${item.gipiCargo.etd}" pattern="MM-dd-yyyy" />" />
							<input type="hidden" id="polCargoEta${item.itemNo}"					name="polCargoEta" 					value="<fmt:formatDate value="${item.gipiCargo.eta}" pattern="MM-dd-yyyy" />" />
							<input type="hidden" id="polCargoOrigin${item.itemNo}"				name="polCargoOrigin" 				value="${item.gipiCargo.origin}" />
							<input type="hidden" id="polCargoDestn${item.itemNo}"				name="polCargoDestn" 				value="${item.gipiCargo.destination}" />
							<input type="hidden" id="polCargoInvCurrRt${item.itemNo}"			name="polCargoInvCurrRt" 			value="${item.gipiCargo.invCurrRate}" />
							<input type="hidden" id="polCargoInvoiceValue${item.itemNo}"		name="polCargoInvoiceValue" 		value="${item.gipiCargo.invoiceValue}" />
							<input type="hidden" id="polCargoMarkupRate${item.itemNo}"			name="polCargoMarkupRate" 			value="${item.gipiCargo.markupRate}" />
							<input type="hidden" id="polCargoRecFlagWCargo${item.itemNo}"		name="polCargoRecFlag" 				value="${item.gipiCargo.recFlag}" />
							<input type="hidden" id="polCargoDeductText${item.itemNo}"			name="polCargoDeductText" 			value="${item.gipiCargo.deductText}" />
							<input type="hidden" id="polCargoGeogCd${item.itemNo}"				name="polCargoGeogCd" 				value="${item.gipiCargo.geogCd}" />
							<input type="hidden" id="polCargoVesselCd${item.itemNo}"			name="polCargoVesselCd" 			value="${item.gipiCargo.vesselCd}" />
							<input type="hidden" id="polCargoCargoClassCd${item.itemNo}"		name="polCargoCargoClassCd" 		value="${item.gipiCargo.cargoClassCd}" />
							<input type="hidden" id="polCargoCargoType${item.itemNo}"			name="polCargoCargoType" 			value="${item.gipiCargo.cargoType}" />
							<input type="hidden" id="polCargoPrintTag${item.itemNo}"			name="polCargoPrintTag" 			value="${item.gipiCargo.printTag}" />
							<input type="hidden" id="polCargoInvCurrCd${item.itemNo}"			name="polCargoInvCurrCd" 			value="${item.gipiCargo.invCurrCd}" />						
						</div>						   				
					</c:forEach>					
				</div>
			</c:forEach> 		
		</div>
		--><div id="marineCargoDiv1" style="float:left; width:100%; margin-top:10px;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" width="200px">Geography Description</td>
					<td class="leftAligned" >
						<select id="geogCd" name="geogCd" style="width:228px;"></select>
					</td>				
					<td class="rightAligned" width="150px">Voyage No.</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="voyageNo" name="voyageNo" type="text" value="" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Carrier</td>					
					<td class="leftAligned" style="height:28px;" width="228px">
						<select id="vesselCd" name="vesselCd" style="width: 228px;"></select>
					</td>
					<td class="rightAligned">LC No.</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="lcNo" name="lcNo" type="text" value="" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Cargo Class</td>
					<td class="leftAligned" >
						<select id="cargoClassCd" name="cargoClassCd" style="width: 228px;"></select>
					</td>
					<td class="rightAligned">ETD/ETA</td>
					<td class="leftAligned">
						<div style="float:left; border: solid 1px gray; width: 110.5px; height: 21px; margin-right:4px;">
			    			<input style="width: 82px; border: none;" id="etd" name="etd" type="text" value="" readonly="readonly"/>
			    			<img id="hrefEtdDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('etd'),this, null);" alt="ETD" />
						</div>
						<div style="float:left; border: solid 1px gray; width: 110px; height: 21px; margin-right:3px;">
			    			<input style="width: 82px; border: none;" id="eta" name="eta" type="text" value="" readonly="readonly"/>
			    			<img id="hrefEtaDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('eta'),this, null);" alt="ETA" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Cargo Type</td>
					<td class="leftAligned" >
						<select id="cargoType" name="cargoType" style="width: 228px;"></select>
					</td>
					<td class="rightAligned">Print?</td>
					<td class="leftAligned">
						<select id="printTag" name="printTag" style="width: 228px;">
							<c:forEach var="print" items="${printTagListing}">
								<option value="${print.rvLowValue}">${print.rvMeaning}</option>				
							</c:forEach>
						</select>
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">Type of Packing</td>
					<td class="leftAligned" >
						<input style="width: 220px;" id="packMethod" name="packMethod" type="text" value="" maxlength="50" />
					</td>
					<td class="rightAligned">Origin/Destination</td>
					<td class="leftAligned">
						<input style="width: 104px;" id="origin" name="origin" type="text" value="" maxlength="50"/>
						<input style="width: 104px;" id="destn" name="destn" type="text" value="" maxlength="50"/>
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">BL/AWB</td>
					<td class="leftAligned" >
						<input style="width: 220px;" id="blAwb" name="blAwb" type="text" value="" maxlength="30" />
					</td>
					<td class="rightAligned">Invoice Value</td>
					<td class="leftAligned">
						<select id="invCurrCd" name="invCurrCd" style="width: 58px;">
							<option value=""></option>
							<c:forEach var="invoice" items="${invoiceListing}">
								<option invCurrRt="${invoice.valueFloat }" value="${invoice.code}">${invoice.shortName}</option>				
							</c:forEach>
						</select>
						<input style="width: 158px;" id="invCurrRt" name="invCurrRt" type="text" value="" maxlength="30" class="moneyRate"/>						
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">Transhipment Origin</td>
					<td class="leftAligned" >
						<input style="width: 220px;" id="transhipOrigin" name="transhipOrigin" type="text" value="" maxlength="30" />
					</td>
					<td></td>
					<td class="leftAligned">
						<input style="width: 220px;" id="invoiceValue" name="invoiceValue" type="text" value="" maxlength="18" class="money"/>					
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">Transhipment Destination</td>
					<td class="leftAligned" >
						<input style="width: 220px;" id="transhipDestination" name="transhipDestination" type="text" value="" maxlength="30" />
					</td>
					<td class="rightAligned">Markup Rate</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="markupRate" name="markupRate" type="text" value="" maxlength="30" class="moneyRate"/>
					</td>					
				</tr>
				<tr>
					<td class="rightAligned" style="width: 161px;">Deductible/Remarks</td>
					<td class="leftAligned" colspan="4">
						<div style="border: 1px solid gray; height: 20px; width: 614px; float: left;">
							<textarea id="deductibleRemarks" name="deductibleRemarks" style="width: 585px; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editDeductibleRemarks" />
						</div>
					</td>
				</tr>				
			</table>
		</div>		
		<div id="marineCargoDiv2" style="float:left; width:45%; margin-top:10px; display: none;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td>
						<input style="width: 220px;" id="recFlagWCargo" 	name="recFlagWCargo" 	type="hidden" value="" maxlength="1"/>
						<input style="width: 220px;" id="cpiRecNo" 			name="cpiRecNo" 	 	type="hidden" value="" maxlength="12"/>
						<input style="width: 220px;" id="cpiBranchCd" 		name="cpiBranchCd" 	 	type="hidden" value="" maxlength="2"/>
						<input style="width: 220px;" id="deductText" 		name="deductText"    	type="hidden" value="" maxlength="200"/>
						<input style="width: 220px;" id="perilExist" 		name="perilExist" 	 	type="hidden" value="" maxlength="1"/>
						<input style="width: 220px;" id="deleteWVes" 		name="deleteWVes" 	 	type="hidden" value="" maxlength="1"/>
						<input style="width: 220px;" id="origGeogDesc" 		name="origGeogDesc"  	type="hidden" value="" />
						<input style="width: 220px;" id="origGeogCd" 		name="origGeogCd" 	 	type="hidden" value="" />
						<input style="width: 220px;" id="origGeogType" 		name="origGeogType"  	type="hidden" value="" />
						<input style="width: 220px;" id="origGeogClassType" name="origGeogClassType"  type="hidden" value="" />
						<input style="width: 220px;" id="origVesselCd" 		name="origVesselCd"  	type="hidden" value="" />
						<input style="width: 220px;" id="multiVesselCd" 	name="multiVesselCd"  	type="hidden" value="${multiVesselCd }" />
						<input style="width: 220px;" id="paramVesselCd" 	name="paramVesselCd"  	type="hidden" value="" />
					</td>
				</tr>
			</table>
		</div>
		<div id="itemButtonsDiv" align="center" style="float: left; padding-top: 10px; padding-bottom: 10px; width: 100%;">		
			<input type="button" id="btnAddItem" 		class="button" value="Add"/>
			<input type="button" id="btnDeleteItem" 	class="disabledButton" value="Delete" disabled="disabled" />
		</div>
	</div>
</div>
<script type="text/javaScript" defer="defer">
	var objGeogListing 			= JSON.parse('${endtGeogListing}');
	var objCarrierListing 		= JSON.parse('${endtCarriers}');
	var objCargoClassListing	= JSON.parse('${cargoClassListing}');
	var objCargoTypeListing 	= JSON.parse('${cargoTypeListing}');

	setGeogListing(objGeogListing, "");
	setCarrierListing(objCarrierListing, "");
	setCargoClassListing(objCargoClassListing, "");
	setCargoTypeListing(objCargoTypeListing, "");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	// Hides the geography group without options
	var optgroups = $$("select#geogCd optgroup");
	for(var i=0; i<optgroups.size(); i++){		
		var optsCount = optgroups[i].childElementCount;
		if(optsCount == 0){
			//optgroups[i].show();
		//} else {
			optgroups[i].hide();
		}
	}
	
	// Function to set geography listing
	function setGeogListing(obj, value){
		$("geogCd").update('<option geogType="" geogClassType="" value=""></option>' +
							'<optgroup label="Aircraft" id="aircraft"></optgroup>' +
							'<optgroup label="Inland" id="inland"></optgroup>' +
							'<optgroup label="Vessel" id="vessel"></optgroup>');
		var aircraft = "";
		var inland = "";
		var vessel = "";	
		for(var i=0; i<obj.length; i++){
			if('A' == obj[i].geogClassType){
				aircraft+= '<option geogType="'+obj[i].geogType+'" geogClassType="'+obj[i].geogClassType+'" value="'+obj[i].geogCd+'">'+obj[i].geogDesc+'</option>';
			} else if ('I' == obj[i].geogClassType){
				inland+= '<option geogType="'+obj[i].geogType+'" geogClassType="'+obj[i].geogClassType+'" value="'+obj[i].geogCd+'">'+obj[i].geogDesc+'</option>';
			} else if ('V' == obj[i].geogClassType){
				vessel+= '<option geogType="'+obj[i].geogType+'" geogClassType="'+obj[i].geogClassType+'" value="'+obj[i].geogCd+'">'+obj[i].geogDesc+'</option>';
			}
		}
		
		$("geogCd").down("optgroup", 0).update(aircraft);
		$("geogCd").down("optgroup", 1).update(inland);
		$("geogCd").down("optgroup", 2).update(vessel);
		$("geogCd").selectedIndex = value;
	}

	// Function to set carrier listing
	function setCarrierListing(obj, value){
		$("vesselCd").update('<option value="" vesselFlag=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){						
			options+= '<option value="'+obj[i].vesselCd+'" vesselFlag="'+obj[i].vesselFlag+'">'+obj[i].vesselName+'</option>';
		}
		$("vesselCd").insert({bottom: options}); 
		$("vesselCd").selectedIndex = value;
	}

	// Function to set cargo class listing
	function setCargoClassListing(obj, value){
		$("cargoClassCd").update('<option value=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){
			options+='<option value="'+obj[i].cargoClassCd+'">'+obj[i].cargoClassDesc.truncate(90, "...")+'</option>';
		}
		$("cargoClassCd").insert({bottom: options});
		$("cargoClassCd").selectedIndex = value;
	}

	// Function to set cargo type listing
	function setCargoTypeListing(obj, value){
		$("cargoType").update('<option cargoClassCd="" value=""></option>');
		var options = "";
		for(var i=0; i<obj.length; i++){
			options+='<option cargoClassCd="'+obj[i].cargoClassCd+'" value="'+obj[i].cargoType+'">'+obj[i].cargoTypeDesc+'</option>';
		}
		$("cargoType").insert({bottom: options});
		$("cargoType").selectedIndex = value;
	}
	
	$("itemNo").observe("change", function(){ 
		if(carrierExist == "N") {
			showConfirmBox("Message", "Carrier information for this policy does not exist.", "Enter Info", "Get Latest Info", showCarrierInfoPage, toggleEndtMarineCargoDetails);
		} else {
			toggleEndtMarineCargoDetails(parseInt($F("itemNo")));
		}
	});
	
	$("geogCd").observe("focus", function () {	
		$("origGeogType").value = $("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogType");
		$("origGeogClassType").value = $("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType");
		$("origGeogCd").value = $("geogCd").value;
		$("origGeogDesc").value = $("geogCd").options[$("geogCd").selectedIndex].text;
		$("origVesselCd").value = $("vesselCd").value;
	});
	
	$("geogCd").observe("change", function () {	
		geogClassType = $("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType");
		if ($("geogCd").value == "") {
			showListing($("vesselCd"));
		} else {
			//hideListing($("vesselCd"));
			for(var i = 1; i < $("vesselCd").options.length; i++){
				if (geogClassType == $("vesselCd").options[i].getAttribute("vesselFlag")){
					showOption($("vesselCd").options[i]);
					//$("vesselCd").options[i].show();
				} else {
					hideOption($("vesselCd").options[i]);
				}
			}
		}
		
		if ($("origGeogClassType").value.toUpperCase() == "V"){
			if ($("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType").toUpperCase() != "V"){
				//showConfirmBox("Message", "User has updated the geog description from "+$("origGeogDesc").value+" "+$("origGeogType").value.toUpperCase()+" to "+$("geogCd").options[$("geogCd").selectedIndex].text+" "+$("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogType").toUpperCase()+". Previously created record will now be deleted. Continue?",  
						//"Yes", "No", onOkFunc, onCancelFunc);
				showConfirmBox("Message", "User has updated the geog description from "+$("origGeogDesc").value+" to "+$("geogCd").options[$("geogCd").selectedIndex].text+". Previously created record will now be deleted. Continue?",  
						"Yes", "No", onOkFunc, onCancelFunc);
			}
		}	 	
		function onOkFunc() {
			$("deleteWVes").value = "Y";
		}	
		function onCancelFunc() {
			$("geogCd").value = $("origGeogCd").value;
			$("vesselCd").value = $("origVesselCd").value;
		}	
	});

	$("vesselCd").observe("change", function ()	{
		if ($("vesselCd").value == $("multiVesselCd").value) {
			$("listOfCarriersPopup").show();
			checkTableItemInfoAdditional("carrierTable","carrierListing","carr","item",$F("itemNo"));
			computeTotalAmountInTable("carrierTable","carr",7,"item",$F("itemNo"),"listOfCarrierTotalAmtDiv");
		} else{
			$("listOfCarriersPopup").hide();
		}
	});
	
	$("cargoClassCd").observe("change", function ()	{
		if ($("cargoClassCd").value != ""){
			getCargoTypeList($("cargoClassCd").value);
		} else {
			hideListing($("cargoType"));	
		}	
	});	

	$("invCurrCd").observe("change", function() {
		if ($("invCurrCd").value != "") {
			$("invCurrRt").value = formatToNineDecimal($("invCurrCd").options[$("invCurrCd").selectedIndex].getAttribute("invCurrRt"));
			$("invoiceValue").value = "";
		} else{
			$("invoiceValue").value = "";
			$("invCurrRt").value = "";
		}	
	});

	$("invCurrRt").observe("blur", function() {
		if (($("invCurrRt").value == "") || ($("invCurrRt").value == "0.000000000")){
			$("invCurrCd").selectedIndex = 0;
			$("invoiceValue").value = "";
		}	
		if (parseFloat($("invCurrRt").value) < -999.999999999 || parseFloat($('invCurrRt').value) >  999.999999999 || $('invCurrRt').value=="NaN") {
			showMessageBox("Entered invoice currency rate is invalid. Valid value is from -999.999999999 to 999.999999999.", imgMessage.ERROR);
			$("invCurrRt").focus();
			$("invCurrRt").value = "";
		}	
	});

	$("markupRate").observe("blur", function() {
		if (parseFloat($("markupRate").value) < -999.999999999 || parseFloat($('markupRate').value) >  999.999999999 || $('markupRate').value=="NaN") {
			showMessageBox("Entered markup rate is invalid. Valid value is from -999.999999999 to 999.999999999.", imgMessage.ERROR);
			$("markupRate").focus();
			$("markupRate").value = "";
		}	
	});

	$("invoiceValue").observe("blur", function() {
		if (parseInt($F('invoiceValue').replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered invoice value is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR);
			$("invoiceValue").focus();
			$("invoiceValue").value = "";
		} else if (parseInt($F('invoiceValue').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered invoice value is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR);
			$("invoiceValue").focus();
			$("invoiceValue").value = "";
		}		
	});
	
	function initMarineCargo(){
		hideListing($("cargoType"));
		if ($("message").innerHTML != "SUCCESS"){
			showMessageBox($("message").innerHTML, imgMessage.ERROR);
		}	
		$("printTag").value = "1";
		$("listOfCarriersPopup").hide();
		$("markupRate").clear();
		$("invCurrRt").clear();
		$("region").addClassName("required");
	}	

	function getCargoTypeList(cargoClassCd){
		try {
			//hideListing($("cargoType"));	
			if (cargoClassCd != ""){
				for(var i = 1; i < $("cargoType").options.length; i++){  
					if ($("cargoType").options[i].getAttribute("cargoClassCd") == cargoClassCd){
						showOption($("cargoType").options[i]);
						//$("cargoType").options[i].show();
					} else {
						hideOption($("cargoType").options[i]);
					}
				}
			}
		} catch (e) {
			showErrorMessage("getCargoTypeList", e);
			//showMessageBox("getCargoTypeList : " + e.message);
		}	
	}
	
	$("etd").observe("blur", checkDepartureDate);
	$("eta").observe("blur", checkArrivalDate);
	
	function checkDepartureDate () {
		try {
			var fromDate = makeDate($F("etd"));
			var toDate = makeDate($F("eta"));
			var iDate = makeDate($F("globalInceptDate"));
			var eDate = makeDate($F("globalExpiryDate"));
			if (toDate < fromDate){
				showMessageBox("Departure Date should not be later than the Arrival Date "+$F("eta")+".", imgMessage.ERROR);
				$("etd").value = "";
				$("etd").focus();			
			} else if (fromDate < iDate){
				showMessageBox("Departure Date should not be earlier than the Inception Date", imgMessage.ERROR);
				$("etd").value = "";
				$("etd").focus();	
			}
		} catch (e) {
			showErrorMessage("checkDepartureDate", e);
			//showMessageBox("checkDepartureDate : " + e.message);
		}		
	}

	function checkArrivalDate() {
		try {
			var fromDate = makeDate($F("etd"));
			var toDate = makeDate($F("eta"));
			var iDate = makeDate($F("globalInceptDate"));
			var eDate = makeDate($F("globalExpiryDate"));
			if (toDate < fromDate){
				showMessageBox("Arrival Date should not be earlier than the Departure Date "+$F("etd")+".", imgMessage.ERROR);
				$("eta").value = "";
				$("eta").focus();			
			} else if (toDate > eDate){
				showMessageBox("Arrival Date must be earlier than the Expiry Date." , imgMessage.ERROR);
				$("eta").value = "";
				$("eta").focus();
			} else if (toDate < iDate){
				showMessageBox("Arrival Date should not be earlier than Inception date", imgMessage.ERROR);
				$("eta").value = "";
				$("eta").focus();
			}			
		} catch (e) {
			showErrorMessage("checkArrivalDate", e);
			//showMessageBox("checkArrivalDate : " + e.message);			
		}
	}
	
	$("editDeductibleRemarks").observe("click", function () { 
		showEditor("deductibleRemarks", 200);
	});
	
	$("deductibleRemarks").observe("keyup", function () {
		limitText(this, 200);
	});

	var carrierExist = "Y";
	<c:if test="${empty vesselListing}">
		carrierExist = "N";
	</c:if>

	var itemsExist = "Y";
	<c:if test="${empty items}">
		itemsExist = "N";
	</c:if>

	function toggleEndtMarineCargoDetails(itemNo){
		try {
			var item = null;
			for (var i=0; i<objPolbasics.length; i++){
				for(var j=0; j<objPolbasics[i].gipiItems.length; j++){
					if(objPolbasics[i].gipiItems[j].itemNo == itemNo){
						item = objPolbasics[i].gipiItems[j]; 
					}
				}
			}

			$("itemTitle").value 	= (item != null ? item.itemTitle : "");
			$("itemDesc").value		= (item != null ? item.itemDesc : "");
			$("itemDesc2").value	= (item != null ? item.itemDesc2 : "");
			$("currency").value		= (item != null ? item.currencyCd : "1");
			$("rate").value			= (item != null ? formatToNineDecimal(item.currencyRt) : formatToNineDecimal("1"));
			$("region").value		= (item != null ? item.regionCd : "");
			$("vesselCd").value		= (item != null ? item.vesselCd : "");
			$("recFlag").value 		= (item != null ? "C" : "A");
			setRequiredFields((item != null ? false : true));			
		} catch (e) {
			showErrorMessage("toggleEndtMarineCargoDetails", e);
		}
	}
	
	initMarineCargo();
</script>
