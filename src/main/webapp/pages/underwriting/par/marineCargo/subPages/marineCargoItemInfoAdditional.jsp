<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/subPages/additionalItemInfoHeader.jsp"></jsp:include>
<div id="additionalItemInformationDiv" name="additionalItemInformationDiv">
	<div class="sectionDiv" id="additionalItemInformation" style="margin: 0px;" masterDetail="true">
		<table id="marineCargoTable" width="920px" cellspacing="1" border="0">
			<tr><td colspan="4"><br /></td></tr>
			<tr>
				<td class="rightAligned">Geography Description</td>
				<td class="leftAligned" style="width: 180px;">
					<select id="geogCd" name="geogCd" style="width: 228px;" tabindex="15">
						<option value=""></option>
						<c:forEach var="geog" items="${geogListing}">
							<option geogType="${geog.geogType }" geogClassType="${geog.geogClassType }" value="${geog.geogCd}">${geog.geogDesc}</option>				
						</c:forEach>
					</select>
				</td>				
				<td class="rightAligned">Voyage No.</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="voyageNo" name="voyageNo" type="text" value="" maxlength="30" tabindex="23" />
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Carrier</td>
				<td class="leftAligned">
					<select id="vesselCd" name="vesselCd" style="width: 228px;" class="required" tabindex="16">
						<option value=""></option>
						<c:forEach var="vessel" items="${vesselListing}">
							<option vesselFlag="${vessel.vesselFlag }" value="${vessel.vesselCd}">${vessel.vesselName}</option>				
						</c:forEach>
					</select>
				</td>				
				<td class="rightAligned">LC No.</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="lcNo" name="lcNo" type="text" value="" maxlength="30" tabindex="24" />
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Cargo Class</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:4px;" class="required">
						<input type="hidden" id="cargoClassCd" name="cargoClassCd" />
						<input type="text" tabindex="17" style="float: left; margin-top: 0px; margin-right: 3px; width: 200px; border: none;" name="cargoClass" id="cargoClass" readonly="readonly" class="required" value="" tabindex="19" />
						<img id="hrefCargoClass" alt="goCargoClass" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					</div>
					<!-- 
					<select id="cargoClassCd" name="cargoClassCd" style="width: 228px;" class="required">					
						<option value=""></option>
						<c:forEach var="cargo" items="${cargoClassListing}">
							<option value="${cargo.cargoClassCd}">${cargo.cargoClassDesc}</option>				
						</c:forEach>
					</select>
					 -->
				</td>				
				<td class="rightAligned">ETD/ETA</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 110.5px; height: 21px; margin-right:4px;">
		    			<input style="width: 88px; border: none; margin-top : 0px; float : left;" id="etd" name="etd" type="text" value="" readonly="readonly" tabindex="25"/>
		    			<img id="hrefEtdDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('etd'),this, null);" alt="ETD" />
					</div>
					<div style="float:left; border: solid 1px gray; width: 110px; height: 21px; margin-right:3px;">
		    			<input style="width: 88px; border: none; margin-top : 0px; float : left;" id="eta" name="eta" type="text" value="" readonly="readonly" tabindex="26"/>
		    			<img id="hrefEtaDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('eta'),this, null);" alt="ETA" />
					</div>
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Cargo Type</td>
				<td class="leftAligned">
					<select id="cargoType" name="cargoType" style="width: 228px;" class="required" tabindex="18">
						<option value=""></option>
						<c:forEach var="cargoT" items="${cargoTypeListing}">
							<option cargoClassCd="${cargoT.cargoClassCd}" value="${cargoT.cargoType}">${cargoT.cargoTypeDesc}</option>				
						</c:forEach>
					</select>
				</td>				
				<td class="rightAligned">Print?</td>
				<td class="leftAligned">
					<select id="printTag" name="printTag" style="width: 228px;" tabindex="27">
						<c:forEach var="print" items="${printTagListing}">
							<option value="${print.rvLowValue}">${print.rvMeaning}</option>				
						</c:forEach>
					</select>
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Type of Packing</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="packMethod" name="packMethod" type="text" value="" maxlength="50" tabindex="19" />
				</td>				
				<td class="rightAligned">Origin</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="origin" name="origin" type="text" value="" maxlength="50" tabindex="28" />
				</td>			
			</tr>
			<tr>
				<td class="rightAligned">BL/AWB</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="blAwb" name="blAwb" type="text" value="" maxlength="30" tabindex="20" />
				</td>				
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="destn" name="destn" type="text" value="" maxlength="50" tabindex="29" />
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Transhipment Origin</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="transhipOrigin" name="transhipOrigin" type="text" value="" maxlength="30" tabindex="21" />
				</td>				
				<td class="rightAligned">Invoice Value</td>
				<td class="leftAligned">
					<select id="invCurrCd" name="invCurrCd" style="width: 58px;" tabindex="30">
						<option value=""></option>
						<c:forEach var="invoice" items="${invoiceListing}">
							<option invCurrRt="${invoice.valueFloat }" value="${invoice.code}">${invoice.shortName}</option>				
						</c:forEach>
					</select>
					<input style="width: 158px;" id="invCurrRt" name="invCurrRt" type="text" value="" maxlength="13" class="moneyRate2" min="0.000000001" max="999.999999999"  errorMsg="Invalid Invoice Currency Rate. Value should be from 0.000000001 to 999.999999999." tabindex="30" />					
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Transhipment Destination</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="transhipDestination" name="transhipDestination" type="text" value="" maxlength="30" tabindex="22" />
				</td>
				<td class="rightAligned">&nbsp;</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="invoiceValue" name="invoiceValue" type="text" value="" maxlength="18" class="money2" maxlength="17" min="0.00" max="99999999999999.99" errorMsg="Invalid Invoice Value. Value should be from 0.00 to 99,999,999,999,999.99" tabindex="31" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">&nbsp;</td>
				<td class="leftAligned">&nbsp;</td>
				<td class="rightAligned">Markup Rate</td>
				<td class="leftAligned">
					<input style="width: 220px;" id="markupRate" name="markupRate" type="text" value="" maxlength="13" class="moneyRate2" min="0.000000001" max="999.999999999"  errorMsg="Invalid Markup Rate. Value should be from 0.000000001 to 999.999999999." tabindex="32" />
				</td>
			</tr>
		</table>
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
	function showCargoClass() {
		showOverlayContent2(contextPath + "/GIPIWCargoController?action=showCargoClass", "Cargo Class", 820, "");
	}

	$("hrefCargoClass").observe("click", function(){
		showCargoClass();
	});

	function updateVesselCdLOV(){
		var geogClassType = ($("geogCd").options[$("geogCd").selectedIndex]).getAttribute("geogClassType");
		
		(($$("select#vesselCd option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
		(($$("select#vesselCd option:not([vesselFlag='" + geogClassType + "'])")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");

		$("vesselCd").options[0].show();
		$("vesselCd").options[0].disabled = false;
	}

	$("geogCd").observe("focus", function(){		
		objFormVariables.varVOldGeogClass	= nvl($("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType"), "");
		objFormVariables.varVOldGeogCd 		= $F("geogCd");
		objFormVariables.varVOldGeogDesc 	= $("geogCd").options[$("geogCd").selectedIndex].text;		
	});
	
	$("geogCd").observe("change", function(){		
		$("vesselCd").hide();		
		
		if($F("geogCd").empty()){
			(($("vesselCd").childElements()).invoke("show")).invoke("removeAttribute", "disabled");
		}else{			
			updateVesselCdLOV();

			var oldVesselCd = $F("vesselCd");
			var perilExist = ($$('div#parItemPerilTable div[item="' + $F("itemNo") + '"]')).size();
			
			if(objFormVariables.varVOldGeogClass != $("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType")){
				$("vesselCd").value = "";
				if(objFormVariables.varVOldGeogClass.toUpperCase() == "V" && perilExist > 0){
					showConfirmBox("Geography", "User has updated the geog description from " + initCap(objFormVariables.varVOldGeogDesc) + 
						" to " + initCap($("geogCd").options[$("geogCd").selectedIndex].text) + ". Previously created record will now be deleted. Continue ?", "Yes", "Cancel",
						function(){
							deleteFromVesAccumulation($F("itemNo"));
						},
						function(){
							$("geogCd").value = objFormVariables.varVOldGeogCd;
							$("vesselCd").value = oldVesselCd;
							updateVesselCdLOV();
						});
				}
			}else{
				$("vesselCd").value = "";
			}
		}		
				
		$("vesselCd").show();

		(($("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType")).toUpperCase() == "V") ? $("listOfCarriersPopup").show() : $("listOfCarriersPopup").hide();		
	});

	$("vesselCd").observe("blur", function(){
		objFormParameters.paramCarrierSw = $F("vesselCd") == objFormVariables.varVMultiCarrier ? "Y" : "N";

		if($F("vesselCd").empty() || $F("vesselCd") != objFormVariables.varVMultiCarrier){
			deleteFromCargoCarrier($F("itemNo"));
			$("listOfCarriersPopup").hide();
		}else{
			$("listOfCarriersPopup").show();
		}
	});

	$("invCurrCd").observe("focus", function(){
		$("invCurrCd").hide();
		var length = nvl((objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == $F("itemNo") && nvl(obj.recordStatus, 0) != -1;	})).length, 0);

		if(length > 0){
			showConfirmBox("Delete Peril", "There are existing perils already, any change or update for Invoice Value, Mark-Up Rate or Currency Rate will " + 
				" automatically delete the perils. Would you like to continue?", "Yes", "No", 
				function(){
					//deleteFromItemPeril(0);
					deleteFromItemPeril($F("itemNo"));	//edited by gab 04.13.2016 SR 21693
				}, 
				function(){					
					$("invCurrCd").focus();
				});
		}else{
			$("invCurrCd").show();
		}		
	});

	$("invCurrCd").observe("change", function() {		
		if ($("invCurrCd").value != "") {
			$("invCurrRt").value = formatToNineDecimal($("invCurrCd").options[$("invCurrCd").selectedIndex].getAttribute("invCurrRt"));
			//$("invoiceValue").value = "";
		} else{
			$("invoiceValue").value = "";
			$("invCurrRt").value = "";
		}	
	});

	$("invCurrRt").observe("focus", function(){
		objFormVariables.varVInvCurrRtOld = $F("invCurrRt");
	});

	$("invCurrRt").observe("change", function(){
		objFormVariables.varVInvCurrRtNew = $F("invCurrRt");

		var length = nvl((objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == $F("itemNo") && nvl(obj.recordStatus, 0) != -1;	})).length, 0);
		
		if(length > 0 && objFormVariables.varVInvCurrRtNew != objFormVariables.varVInvCurrRtOld){
			showConfirmBox("Delete Peril", "There are existing perils already, any change or update for Invoice Value, Mark-Up Rate or Currency Rate will " + 
				" automatically delete the perils. Would you like to continue?", "Yes", "No", 
				function(){
				//deleteFromItemPeril(0); 
				deleteFromItemPeril($F("itemNo")); //edited by gab 04.13.2016 SR 21693				
				}, 
				function(){
					$("invCurrRt").value = objFormVariables.varVInvCurrRtOld;
				});
		}
	});

	$("invoiceValue").observe("focus", function(){
		objFormVariables.varVInvoiceValueOld = $F("invoiceValue");
	});

	$("invoiceValue").observe("change", function(){
		objFormVariables.varVInvoiceValueNew = $F("invoiceValue");
		var length = nvl((objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == $F("itemNo") && nvl(obj.recordStatus, 0) != -1;	})).length, 0);
		
		if(length > 0 && objFormVariables.varVInvoiceValueNew != objFormVariables.varVInvoiceValueOld){
			showConfirmBox("Delete Peril", "There are existing perils already, any change or update for Invoice Value, Mark-Up Rate or Currency Rate will " + 
				" automatically delete the perils. Would you like to continue?", "Yes", "No", 
				function(){
				//deleteFromItemPeril(0);
				deleteFromItemPeril($F("itemNo"));	//edited by gab 04.13.2016 SR 21693
				}, 
				function(){
					$("invoiceValue").value = objFormVariables.varVInvoiceValueOld;
				});
		}
	});

	$("markupRate").observe("focus", function(){
		objFormVariables.varVMarkupRateOld = $F("markupRate");
	});

	$("markupRate").observe("change", function(){
		objFormVariables.varVMarkupRateNew = $F("markupRate");
		var length = nvl((objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == $F("itemNo") && nvl(obj.recordStatus, 0) != -1;	})).length, 0);
		
		if(length > 0 && objFormVariables.varVMarkupRateNew != objFormVariables.varVMarkupRateOld){
			showConfirmBox("Delete Peril", "There are existing perils already, any change or update for Invoice Value, Mark-Up Rate or Currency Rate will " + 
				" automatically delete the perils. Would you like to continue?", "Yes", "No", 
				function(){
				//deleteFromItemPeril(0);
				deleteFromItemPeril($F("itemNo"));	//edited by gab 04.13.2016 SR 21693				
				}, 
				function(){
					$("markupRate").value = objFormVariables.varVMarkupRateOld;
				});
		}
	});

	$("etd").observe("blur", function(){
		var etd = $F("etd");
		var eta = $F("eta");
		
		if(!(etd.blank()) && !(eta.blank())){
			if(!(eta.blank())){
				etd = makeDate(etd);
				eta = makeDate(eta);
				
				if(!(etd <= eta)){
					$("eta").value = $F("etd");
					customShowMessageBox("Departure date should not be later than the arrival date (" + dateFormat(eta, 'mmmm dd, yyyy') + ")." +
							" Will copy arrival date value from depature date.", imgMessage.INFO, "etd");
				}
			}
		}
	});

	$("eta").observe("blur", function(){
		var etd = $F("etd");
		var eta = $F("eta");

		if(!(etd.blank()) && !(eta.blank())){
			etd = makeDate(etd);
			eta = makeDate(eta);

			if(!(eta >= etd)){
				$("eta").value = $F("etd");
				customShowMessageBox("Arrival date should not be earlier than the departure date (" + dateFormat(etd, 'mmmm dd, yyyy') + ")." +
						" Will copy arrival date value from departure date.", imgMessage.INFO, "eta");
			}
		}
	});

	$("etd").observe("keyup", function(event){	if(event.keyCode == 46){	$("etd").value = "";	}});
	$("eta").observe("keyup", function(event){	if(event.keyCode == 46){	$("eta").value = "";	}});
	
	observeReloadForm("reloadForm", showCargoClass);//emsy 12.21.2011 ~ added this to validate reloadForm
</script>