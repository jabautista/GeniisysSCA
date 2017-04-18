<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

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
					<select id="geogCd" name="geogCd" style="width: 228px;" tabindex="1501">
						<option value=""></option>
						<c:forEach var="geog" items="${geogListing}">
							<option geogType="${geog.geogType }" geogClassType="${geog.geogClassType }" value="${geog.geogCd}">${geog.geogDesc}</option>				
						</c:forEach>
					</select>
				</td>				
				<td class="rightAligned">Voyage No.</td>
				<td class="leftAligned">
					<input tabindex="1502" style="width: 220px;" id="voyageNo" name="voyageNo" type="text" value="" maxlength="30" class="allCaps" />
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Carrier</td>
				<td class="leftAligned">
					<select tabindex="1503" id="vesselCd" name="vesselCd" style="width: 228px;" class="required">
						<option value=""></option>
						<c:forEach var="vessel" items="${vesselListing}">
							<option vesselFlag="${vessel.vesselFlag }" value="${vessel.vesselCd}">${vessel.vesselName}</option>				
						</c:forEach>
					</select>
				</td>				
				<td class="rightAligned">LC No.</td>
				<td class="leftAligned">
					<input tabindex="1504" style="width: 220px;" id="lcNo" name="lcNo" type="text" value="" maxlength="30" tabindex="24" />
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Cargo Class</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:4px;" class="required">
						<input type="hidden" id="cargoClassCd" name="cargoClassCd" />
						<input type="text" tabindex="1505" style="float: left; margin-top: 0px; margin-right: 3px; width: 197px; border: none;" name="cargoClass" id="cargoClass" readonly="readonly" class="required" value="" tabindex="19" />
						<img id="hrefCargoClass" alt="goCargoClass" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					</div>					
				</td>				
				<td class="rightAligned">ETD/ETA</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 110.5px; height: 21px; margin-right:4px;">
		    			<input tabindex="1506" style="width: 88px; border: none; margin-top : 0px; float : left;" id="etd" name="etd" type="text" value="" readonly="readonly"/>
		    			<img id="hrefEtdDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('etd'),this, null);" alt="ETD" />
					</div>
					<div style="float:left; border: solid 1px gray; width: 110px; height: 21px; margin-right:3px;">
		    			<input tabindex="1507" style="width: 88px; border: none; margin-top : 0px; float : left;" id="eta" name="eta" type="text" value="" readonly="readonly" />
		    			<img id="hrefEtaDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('eta'),this, null);" alt="ETA" />
					</div>
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Cargo Type</td>
				<td class="leftAligned">
					<div style="float:left; border: solid 1px gray; width: 226px; height: 21px; margin-right:4px;" class="required">
						<input type="hidden" id="cargoType" name="cargoType" />
						<input tabindex="1508" type="text" tabindex="17" style="float: left; margin-top: 0px; margin-right: 3px; width: 197px; border: none;" name="cargoTypeDesc" id="cargoTypeDesc" readonly="readonly" class="required" value=""/>
						<img id="hrefCargoType" alt="goCargoType" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
					</div>					
				</td>				
				<td class="rightAligned">Print?</td>
				<td class="leftAligned">
					<select tabindex="1509" id="printTag" name="printTag" style="width: 228px;">
						<c:forEach var="print" items="${printTagListing}">
							<option value="${print.rvLowValue}">${print.rvMeaning}</option>				
						</c:forEach>
					</select>
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Type of Packing</td>
				<td class="leftAligned">
					<input tabindex="1510" style="width: 220px;" id="packMethod" name="packMethod" type="text" value="" maxlength="50" class="allCaps" />
				</td>				
				<td class="rightAligned">Origin</td>
				<td class="leftAligned">
					<input tabindex="1511" style="width: 220px;" id="origin" name="origin" type="text" value="" maxlength="50" class="allCaps" />
				</td>			
			</tr>
			<tr>
				<td class="rightAligned">BL/AWB</td>
				<td class="leftAligned">
					<input tabindex="1512" style="width: 220px;" id="blAwb" name="blAwb" type="text" value="" maxlength="30" class="allCaps" />
				</td>				
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<input tabindex="1513" style="width: 220px;" id="destn" name="destn" type="text" value="" maxlength="50" class="allCaps" />
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Transhipment Origin</td>
				<td class="leftAligned">
					<input tabindex="1514" style="width: 220px;" id="transhipOrigin" name="transhipOrigin" type="text" value="" maxlength="30" />
				</td>				
				<td class="rightAligned" for="invoiceValue">Invoice Value</td>
				<td class="leftAligned">
					<select tabindex="1515" id="invCurrCd" name="invCurrCd" style="width: 58px;">
						<option value=""></option>
						<c:forEach var="invoice" items="${invoiceListing}">
							<option invCurrRt="${invoice.valueFloat }" value="${invoice.code}">${invoice.shortName}</option>				
						</c:forEach>
					</select>
					<!-- 
					<input tabindex="1516" style="width: 158px;" id="invCurrRt" name="invCurrRt" type="text" value="" maxlength="13" class="moneyRate2" min="0.000000001" max="999.999999999"  errorMsg="Invalid Invoice Currency Rate. Value should be from 0.000000001 to 999.999999999." tabindex="30" />
					 -->
					<input tabindex="1516" style="width: 158px;" id="invCurrRt" name="invCurrRt" type="text" value="" maxlength="13" class="applyDecimalRegExp" regExpPatt="pDeci0309" min="0.000000001" max="999.999999999" hasOwnBlur="Y" hasOwnKeyUp="Y" hasOwnChange="Y" />					
				</td>				
			</tr>
			<tr>
				<td class="rightAligned">Transhipment Destination</td>
				<td class="leftAligned">
					<input tabindex="1517" style="width: 220px;" id="transhipDestination" name="transhipDestination" type="text" value="" maxlength="30" />
				</td>
				<td class="rightAligned">&nbsp;</td>
				<td class="leftAligned">
					<!-- 
					<input tabindex="1518" style="width: 220px;" id="invoiceValue" name="invoiceValue" type="text" value="" maxlength="18" class="money2" maxlength="17" min="0.00" max="99999999999999.99" errorMsg="Invalid Invoice Value. Value should be from 0.00 to 99,999,999,999,999.99" />
					 -->
					<input tabindex="1518" style="width: 220px;" id="invoiceValue" name="invoiceValue" type="text" value="" maxlength="18" class="applyDecimalRegExp" regExpPatt="pDeci1402" maxlength="17" min="0.00" max="99999999999999.99" hasOwnChange="Y" hasOwnBlur="Y" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">&nbsp;</td>
				<td class="leftAligned">&nbsp;</td>
				<td class="rightAligned" for="markupRate">Markup Rate</td>
				<td class="leftAligned">
					<!-- 
					<input tabindex="1519" style="width: 220px;" id="markupRate" name="markupRate" type="text" value="" maxlength="13" class="moneyRate2" min="0.000000001" max="999.999999999"  errorMsg="Invalid Markup Rate. Value should be from 0.000000001 to 999.999999999." />
					 -->
					<input tabindex="1519" style="width: 220px;" id="markupRate" name="markupRate" type="text" value="" maxlength="13" class="applyDecimalRegExp" regExpPatt="pDeci0309" min="0.000000001" max="999.999999999"  hasOwnChange="Y" hasOwnBlur="Y" />
				</td>
			</tr>
		</table>
		<table style="margin: auto; width: 100%;" border="0">
			<tr>
				<td style="text-align:center;">
					<input tabindex="1520" type="button" id="btnAddItem" 	class="button" 			value="Add" />
					<input tabindex="1521" type="button" id="btnDeleteItem" class="disabledButton" 	value="Delete" />
				</td>
			</tr>
		</table>		
	</div>
</div>
<script type="text/javascript">
try{	
	$("hrefCargoClass").observe("click", showCargoClassLOV);
	
	$("hrefCargoType").observe("click", function(){	showCargoTypeLOV($F("cargoClassCd"));	});
	
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
			$("vesselCd").selectedIndex = 0;
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
			
			//(($("geogCd").options[$("geogCd").selectedIndex].getAttribute("geogClassType")).toUpperCase() == "V") ? $("listOfCarriersPopup").show() : $("listOfCarriersPopup").hide();
		}		
				
		$("vesselCd").show();				
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
	
	function confirmInvoiceMarkUpUpdate(flag){
		try{
			var flagCond = false;
			
			switch(flag){
				case "invCurrCd" 	: flagCond = true; break;
				case "invCurrRt" 	: objFormVariables.varVInvCurrRtNew = $F("invCurrRt"); 
									  flagCond = objFormVariables.varVInvCurrRtNew != objFormVariables.varVInvCurrRtOld ? true : false;
									  break;
				case "invoiceValue"	: objFormVariables.varVInvoiceValueNew = $F("invoiceValue"); 
									  flagCond = objFormVariables.varVInvoiceValueNew != objFormVariables.varVInvoiceValueOld ? true : false;
									  break;
				case "markupRate"	: objFormVariables.varVMarkupRateNew = $F("markupRate"); 
									  flagCond = objFormVariables.varVMarkupRateNew != objFormVariables.varVMarkupRateOld ? true : false;
									  break;
			}
			
			var length = nvl((objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == $F("itemNo") && nvl(obj.recordStatus, 0) != -1;	})).length, 0);
			
			if(length > 0 && flagCond){
				showConfirmBox("Delete Peril", "There are existing perils already, any change or update for Invoice Value, Mark-Up Rate or Currency Rate will " + 
					" automatically delete the perils. Would you like to continue?", "Yes", "No", 
					function(){
					// deleteFromItemPeril(0);
					deleteFromItemPeril($F("itemNo"));		//edited by gab 04.13.2016 SR 21693		
					}, 
					function(){						
						switch(flag){
							case "invCurrCd" 	: $("invCurrCd").value = $("invCurrCd").getAttribute("lastValidValue");
												  $("invCurrRt").value = $("invCurrRt").getAttribute("lastValidValue");
												  $("invCurrCd").focus(); break;
							case "invCurrRt" 	: $("invCurrRt").value = objFormVariables.varVInvCurrRtOld; break;
							case "invoiceValue"	: $("invoiceValue").value = objFormVariables.varVInvoiceValueOld; break;
							case "markupRate"	: $("markupRate").value = objFormVariables.varVMarkupRateOld; break;
						}
					});
			}
		}catch(e){
			showErrorMessage("confirmInvoiceMarkUpUpdate", e);
		}
	}
	
	$("invCurrCd").observe("focus", function(){
		$("invCurrCd").setAttribute("lastValidValue", $F("invCurrCd"));
		$("invCurrRt").setAttribute("lastValidValue", $F("invCurrRt"));
		if (postedBinderExists()){ //added edgar 02/06/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("invCurrCd").value = $("invCurrCd").getAttribute("lastValidValue");
				$("invCurrRt").value = $("invCurrRt").getAttribute("lastValidValue");
			});	
			return false;
		}	
	});

	$("invCurrCd").observe("change", function(){
		if (postedBinderExists()){ //added edgar 01/27/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("invCurrCd").value = $("invCurrCd").getAttribute("lastValidValue");
				$("invCurrRt").value = $("invCurrRt").getAttribute("lastValidValue");
			});	
			return false;
		}	
		$("invCurrCd").hide();
		confirmInvoiceMarkUpUpdate("invCurrCd");		
		$("invCurrCd").show();
	});
	
	$("invCurrCd").observe("change", function() {
		if (postedBinderExists()){ //added edgar 01/27/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("invCurrCd").value = $("invCurrCd").getAttribute("lastValidValue");
				$("invCurrRt").value = $("invCurrRt").getAttribute("lastValidValue");
			});	
			return false;
		}	
		if ($("invCurrCd").value != "") {
			$("invCurrRt").value = formatToNineDecimal($("invCurrCd").options[$("invCurrCd").selectedIndex].getAttribute("invCurrRt"));
			//$("invoiceValue").value = "";
			
			//marco - 04.12.2013 - disable currency rate text field when currency is PHP
			if($("invCurrCd").value == objFormParameters.paramDefaultCurrency){
				disableInputField("invCurrRt");
			}else{
				enableInputField("invCurrRt");
			}
		}else{
			$("invoiceValue").value = "";
			$("invCurrRt").value = "";
			enableInputField("invCurrRt"); //marco - 04.12.2013
		}	
	});

	$("invCurrRt").observe("focus", function(){
		objFormVariables.varVInvCurrRtOld = $F("invCurrRt");
		if (postedBinderExists()){ //added edgar 02/06/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("invCurrRt").value = objFormVariables.varVInvCurrRtOld;
			});	
			return false;
		}
	});
	
	$("invCurrRt").observe("keyup", function(e){
		if (postedBinderExists()){ //added edgar 02/06/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("invCurrRt").value = objFormVariables.varVInvCurrRtOld;
			});	
			return false;
		}	
		var m = $("invCurrRt");
		var pattern = m.getAttribute("regExpPatt"); 				
		
		if(pattern.substr(0,1) == "p"){
			if(m.value.include("-")){				
				showWaitingMessageBox("Invalid Invoice Currency Rate. Value should be from 0.000000001 to 999.999999999.", imgMessage.ERROR, function(){
					m.value = formatToNineDecimal($("invCurrCd").options[$("invCurrCd").selectedIndex].getAttribute("invCurrRt"));
					m.focus();
				});
				return false;
			}else{						
				m.value = (m.value).match(RegExDecimal[pattern])[0];						
			}
		}else{					
			m.value = (m.value).match(RegExDecimal[pattern])[0];
		}					    						
	});	
	
	function validateInvCurrRt(){
		try{
			var val = $("invCurrRt").value;
			
			if(isNaN(val.replace(/,/g, "")) || val.blank()){				
				$("invCurrRt").value = "";
			}else{									
				if(compareAmounts(val, $("invCurrRt").getAttribute("min")) == 1 || compareAmounts(val, $("invCurrRt").getAttribute("max")) == -1){
					showWaitingMessageBox("Invalid Invoice Currency Rate. Value should be from 0.000000001 to 999.999999999.", imgMessage.ERROR, function(){					
						$("invCurrRt").value = formatToNineDecimal($("invCurrCd").options[$("invCurrCd").selectedIndex].getAttribute("invCurrRt"));					
						$("invCurrRt").focus();
					});
					return false;
				}else{
					$("invCurrRt").value = (val == "" ? "" : formatTo9DecimalNoParseFloat(val));
					
					confirmInvoiceMarkUpUpdate("invCurrRt");
				}
			}
		}catch(e){
			showErrorMessage("validateInvCurrRt", e);
		}
	}

	//$("invCurrRt").observe("blur", validateInvCurrRt); //commented out edgar 02/06/2015
	$("invCurrRt").observe("change", function(){
		if (postedBinderExists()){ //added edgar 01/27/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("invCurrRt").value = objFormVariables.varVInvCurrRtOld;
			});	
			return false;
		}	
		validateInvCurrRt();
	});

	$("invoiceValue").observe("focus", function(){
		objFormVariables.varVInvoiceValueOld = $F("invoiceValue");
		if (postedBinderExists()){ //added edgar 02/06/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("invoiceValue").value = objFormVariables.varVInvoiceValueOld;
			});	
			return false;
		}	
	});
	
	function validateInvoiceValue(){
		try{			
			if($("invoiceValue").getAttribute("executeOnBlur") != "N"){				
				confirmInvoiceMarkUpUpdate("invoiceValue");	
				$("invoiceValue").value = addSeparatorToNumber2(formatNumberByRegExpPattern($("invoiceValue")), ",");
				$("invoiceValue").setAttribute("lastValidValue", $("invoiceValue").value);				
			}			
		}catch(e){
			showErrorMessage("validateInvoiceValue", e);
		}
	}

	//$("invoiceValue").observe("blur", validateInvoiceValue); //commented out edgar 02/06/2015
	$("invoiceValue").observe("change", function(){
		if (postedBinderExists()){ //added edgar 01/27/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("invoiceValue").value = objFormVariables.varVInvoiceValueOld;
			});	
			return false;
		}	
		validateInvoiceValue();
	});

	$("markupRate").observe("focus", function(){
		objFormVariables.varVMarkupRateOld = $F("markupRate");
		if (postedBinderExists()){ //added edgar 02/06/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("markupRate").value = objFormVariables.varVMarkupRateOld;
			});	
			return false;
		}	
	});
	
	function validateMarkupRate(){
		try{
			if($("markupRate").getAttribute("executeOnBlur") != "N"){
				confirmInvoiceMarkUpUpdate("markupRate");
				$("markupRate").value = formatNumberByRegExpPattern($("markupRate"));				
				$("markupRate").setAttribute("lastValidValue", $("markupRate").value);
			}
		}catch(e){
			showErrorMessage("validateMarkupRate", e);
		}
	}

	//$("markupRate").observe("blur", validateMarkupRate);	//commented out edgar 02/06/2015
	$("markupRate").observe("change", function(){
		if (postedBinderExists()){ //added edgar 01/27/2015 : for checking posted binders
			showWaitingMessageBox('Update of invoice value, currency, and markup rate is not allowed for PAR with posted binder(s).', 'I', function(){
				$("markupRate").value = objFormVariables.varVMarkupRateOld;
			});	
			return false;
		}	
		validateMarkupRate();
	});

	$("etd").observe("blur", function(){
		var etd = $F("etd");
		var eta = $F("eta");
		
		if(!(etd.blank()) && !(eta.blank())){
			if(!(eta.blank())){
				etd = makeDate(etd);
				eta = makeDate(eta);
				
				if(!(etd <= eta)){
					//$("eta").value = $F("etd");
					$("etd").value = $("etd").getAttribute("lastValidValue");
					customShowMessageBox("Departure date should not be later than the arrival date (" + dateFormat(eta, 'mmmm dd, yyyy') + ").",
							imgMessage.INFO, "etd");
				}else{
					$("etd").setAttribute("lastValidValue", $F("etd"));	
					$("etd").setAttribute("changed", "changed");
				}
			}
		}else if(!($F("etd").blank())){
			$("etd").setAttribute("lastValidValue", $F("etd"));
			$("etd").setAttribute("changed", "changed");
		}
	});

	$("eta").observe("blur", function(){
		var etd = $F("etd");
		var eta = $F("eta");

		if(!(etd.blank()) && !(eta.blank())){
			etd = makeDate(etd);
			eta = makeDate(eta);

			if(!(eta >= etd)){
				//$("eta").value = $F("etd");
				$("eta").value = $("eta").getAttribute("lastValidValue");
				customShowMessageBox("Arrival date should not be earlier than the departure date (" + dateFormat(etd, 'mmmm dd, yyyy') + ").", 
						imgMessage.INFO, "eta");
			}else{
				$("eta").setAttribute("lastValidValue", $F("eta"));	
				$("eta").setAttribute("changed", "changed");
			}
		}else if(!($F("eta").blank())){
			$("eta").setAttribute("lastValidValue", $F("eta"));	
			$("eta").setAttribute("changed", "changed");
		}
	});

	$("etd").observe("keyup", function(event){	if(event.keyCode == 46){	$("etd").value = "";	}});
	$("eta").observe("keyup", function(event){	if(event.keyCode == 46){	$("eta").value = "";	}});
	
	observeChangeTagOnDate("hrefEtdDate", "etd");
	observeChangeTagOnDate("hrefEtaDate", "eta");
	
	$("cargoClass").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("cargoClassCd").value = "";
			$("cargoType").value = "";
			$("cargoTypeDesc").value = "";
		}
	});
	
	$("cargoTypeDesc").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("cargoType").value = "";
			$("cargoTypeDesc").value = "";	
		}		
	});
	
	function postedBinderExists(){ //edgar 01/27/2015 : Check if PAR has posted binder/s.
		try{
			var exists = false;
			new Ajax.Request(contextPath+"/GIPIPARListController",{
				parameters:{
					action: "checkForPostedBinder",
					parId : $F("globalParId"),
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						if(response.responseText == 'Y'){
							exists = true;
						}
					}
				}
			});
			return exists;
		} catch(e){
			showErrorMessage("postedBinderExists", e);
		}
	}
}catch(e){
	showErrorMessage("Item Info - " + objUWParList.lineCd + " Item Additional Page", e);
}
</script>