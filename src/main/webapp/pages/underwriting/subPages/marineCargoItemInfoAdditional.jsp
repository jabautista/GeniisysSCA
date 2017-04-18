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
		<div id="marineCargoDiv1" style="float:left; width:50%; margin-top:10px; margin-bottom:10px;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" style="width: 130px;">Geography Description</td>
					<td class="leftAligned" style="width: 180px;">
						<select id="geogCd" name="geogCd" style="width: 228px;">
							<option value=""></option>
							<c:forEach var="geog" items="${geogListing}">
								<option geogType="${geog.geogType }" geogClassType="${geog.geogClassType }" value="${geog.geogCd}">${geog.geogDesc}</option>				
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Carrier</td>
					<td class="leftAligned" style="height:28px;">
						<select id="vesselCd" name="vesselCd" style="width: 228px;" class="required">
							<option value=""></option>
							<c:forEach var="vessel" items="${vesselListing}">
								<option vesselFlag="${vessel.vesselFlag }" value="${vessel.vesselCd}">${vessel.vesselName}</option>				
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Cargo Class</td>
					<td class="leftAligned">
						<select id="cargoClassCd" name="cargoClassCd" style="width: 228px;" class="required">
							<option value=""></option>
							<c:forEach var="cargo" items="${cargoClassListing}">
								<option value="${cargo.cargoClassCd}">${cargo.cargoClassDesc}</option>				
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Cargo Type</td>
					<td class="leftAligned">
						<select id="cargoType" name="cargoType" style="width: 228px;" class="required">
							<option value=""></option>
							<c:forEach var="cargoT" items="${cargoTypeListing}">
								<option cargoClassCd="${cargoT.cargoClassCd}" value="${cargoT.cargoType}">${cargoT.cargoTypeDesc}</option>				
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Type of Packing</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="packMethod" name="packMethod" type="text" value="" maxlength="50" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">BL/AWB</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="blAwb" name="blAwb" type="text" value="" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Transhipment Origin</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="transhipOrigin" name="transhipOrigin" type="text" value="" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Transhipment Destination</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="transhipDestination" name="transhipDestination" type="text" value="" maxlength="30" />
					</td>
				</tr>
			</table>
		</div>
		<div id="marineCargoDiv2" style="float:left; width:50%; margin-top:10px; margin-bottom:10px;">		
			<table align="center" cellspacing="1" border="0" width="100%">
				<tr>
					<td class="rightAligned" style="width: 33%;">Voyage No.</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="voyageNo" name="voyageNo" type="text" value="" maxlength="30" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">LC No.</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="lcNo" name="lcNo" type="text" value="" maxlength="30" />
					</td>
				</tr>
				<tr>
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
					<td class="rightAligned">Origin</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="origin" name="origin" type="text" value="" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="destn" name="destn" type="text" value="" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Invoice Value</td>
					<td class="leftAligned">
						<select id="invCurrCd" name="invCurrCd" style="width: 58px;">
							<option value=""></option>
							<c:forEach var="invoice" items="${invoiceListing}">
								<option invCurrRt="${invoice.valueFloat }" value="${invoice.code}">${invoice.shortName}</option>				
							</c:forEach>
						</select>
						<input style="width: 158px;" id="invCurrRt" name="invCurrRt" type="text" value="" maxlength="30" class="moneyRate"/>
						<input style="width: 220px;" id="invoiceValue" name="invoiceValue" type="text" value="" maxlength="18" class="money"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Markup Rate</td>
					<td class="leftAligned">
						<input style="width: 220px;" id="markupRate" name="markupRate" type="text" value="" maxlength="30" class="moneyRate"/>
					</td>
				</tr>
				<tr>
					<td>
						<input style="width: 220px;" id="recFlagWCargo" name="recFlagWCargo" type="hidden" value="" maxlength="1"/>
						<input style="width: 220px;" id="cpiRecNo" 		name="cpiRecNo" 	 type="hidden" value="" maxlength="12"/>
						<input style="width: 220px;" id="cpiBranchCd" 	name="cpiBranchCd" 	 type="hidden" value="" maxlength="2"/>
						<input style="width: 220px;" id="deductText" 	name="deductText"    type="hidden" value="" maxlength="200"/>
						<input style="width: 220px;" id="perilExist" 	name="perilExist" 	 type="hidden" value="" maxlength="1"/>
						<input style="width: 220px;" id="deleteWVes" 	name="deleteWVes" 	 type="hidden" value="" maxlength="1"/>
						<input style="width: 220px;" id="origGeogDesc" 	name="origGeogDesc"  type="hidden" value="" />
						<input style="width: 220px;" id="origGeogCd" 	name="origGeogCd" 	 type="hidden" value="" />
						<input style="width: 220px;" id="origGeogType" 	name="origGeogType"  type="hidden" value="" />
						<input style="width: 220px;" id="origGeogClassType" 	name="origGeogClassType"  type="hidden" value="" />
						<input style="width: 220px;" id="origVesselCd" 	name="origVesselCd"  type="hidden" value="" />
						<input style="width: 220px;" id="multiVesselCd" 	name="multiVesselCd"  type="hidden" value="${multiVesselCd }" />
						<input style="width: 220px;" id="paramVesselCd" 	name="paramVesselCd"  type="hidden" value="" />
					</td>
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
		</div>
	</div>
</div>
<script type="text/javaScript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

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
			hideListing($("vesselCd"));
			for(var i = 1; i < $("vesselCd").options.length; i++){ 
				if (geogClassType == $("vesselCd").options[i].getAttribute("vesselFlag")){
					$("vesselCd").options[i].show();
					$("vesselCd").options[i].disabled = false;
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
	}	

	function getCargoTypeList(cargoClassCd){
		hideListing($("cargoType"));	
		if (cargoClassCd != ""){
			for(var i = 1; i < $("cargoType").options.length; i++){  
				if ($("cargoType").options[i].getAttribute("cargoClassCd") == cargoClassCd){
					$("cargoType").options[i].show();
					$("cargoType").options[i].disabled = false;
				}
			}
		}
	}	

	$("etd").observe("blur", function() {
		var fromDate = makeDate($F("etd"));
		var toDate = makeDate($F("eta"));
		var iDate = makeDate($F("wpolbasInceptDate"));
		var eDate = makeDate($F("wpolbasExpiryDate"));
		if (toDate < fromDate){
			showMessageBox("Departure Date should not be later than the Arrival Date "+$F("eta")+".", imgMessage.ERROR);
			$("etd").value = "";
			$("etd").focus();			
		} else if (fromDate < iDate){
			showMessageBox("Departure Date should not be earlier than the Inception Date", imgMessage.ERROR);
			$("etd").value = "";
			$("etd").focus();	
		}
	});

	$("eta").observe("blur", function() {
		var fromDate = makeDate($F("etd"));
		var toDate = makeDate($F("eta"));
		var iDate = makeDate($F("wpolbasInceptDate"));
		var eDate = makeDate($F("wpolbasExpiryDate"));
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
	});
	
	initMarineCargo();
</script>
