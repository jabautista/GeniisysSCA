<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="liabilityMainDiv" name="liabilityMainDiv" style="margin-top: 1px; display: none;">
	<form id="liabilityMainForm" name="liabilityMainForm">
		<jsp:include page="subPages/parInformation.jsp"></jsp:include>

		<input type="hidden" id="mode" name="mode" value="${mode}" />	
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Limits of Liability</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		<div id="limitOfLiabilityDivAndFormDiv" name="limitOfLiabilityDivAndFormDiv" class="sectionDiv"  align="center" style="border: 0px solid transparent;" changeTagAttr="true">
			<div id="liabilityDivAndFormDiv" name="liabilityDivAndFormDiv" class="sectionDiv"  align="center">
				<div id="limitForDeleteDiv" name="limitForDeleteDiv">
				</div>
				<div id="liabilityFormDiv" name="liabilityFormDiv" style="width: 100%; margin: 10px 0px 10px 0px;" changeTagAttr="true">
					<input type="hidden" id="geogCd" 		 name="geogCd" 			value="${openLiab.geogCd}" />
					<input type="hidden" id="currencyCd" 	 name="currencyCd" 		value="${openLiab.currencyCd}" />
					<input type="hidden" id="recFlag" 		 name="recFlag" 		value="${openLiab.recFlag}" />
					<input type="hidden" id="withInvoiceTag" name="withInvoiceTag" 	value="${openLiab.withInvoiceTag}" />
					<table align="center" width="80%">
						<tr>
							<td class="rightAligned" width="8%">Geography</td>
							<td class="leftAligned" width="25%">
								<select id="inputGeography" name="inputGeography" style="width: 100%; overflow: scroll;" class="required">
									<option value=""></option>
									<optgroup label="Aircraft">
										<c:forEach var="geo" items="${geographies}">
											<c:if test="${'Aircraft' eq geo.geogType}">
												<option value="${geo.geogCd}"
													<c:if test="${geo.geogCd eq openLiab.geogCd}">
														selected="selected"
													</c:if> 
												>${geo.geogDesc}</option>
											</c:if>										
										</c:forEach>
									</optgroup>
									<optgroup label="Inland">
										<c:forEach var="geo" items="${geographies}">
											<c:if test="${'Inland' eq geo.geogType}">
												<option value="${geo.geogCd}"
													<c:if test="${geo.geogCd eq openLiab.geogCd}">
														selected="selected"
													</c:if> 
												>${geo.geogDesc}</option>
											</c:if>										
										</c:forEach>
									</optgroup>
									<optgroup label="Vessel">
										<c:forEach var="geo" items="${geographies}">
											<c:if test="${'Vessel' eq geo.geogType}">
												<option value="${geo.geogCd}"
													<c:if test="${geo.geogCd eq openLiab.geogCd}">
														selected="selected"
													</c:if> 
												>${geo.geogDesc}</option>
											</c:if>										
										</c:forEach>
									</optgroup>
								</select>
							</td>
							<td class="rightAligned" width="10%">Currency</td>
							<td class="leftAligned" width="25%">
								<select id="inputCurrency" name="inputCurrency" style="width: 100%;" class="required">
									<option value="" rate="0"></option>
									<c:forEach var="currency" items="${currencies}" varStatus="index">
										<option value="${currency.code}" rate="${currency.valueFloat}"  
											<c:if test="${currency.code eq openLiab.currencyCd}">
												selected="selected"
											</c:if> 
										>${currency.desc}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Limit of Liability</td>
							<td class="leftAligned"><input class="required money2" type="text" id="inputLimit" name="inputLimit" style="width: 97%; text-align: right;" value="${openLiab.limitOfLiability}" maxlength="17" /></td>
							<td class="rightAligned">Currency Rate</td>
							<td class="leftAligned"><input class="moneyRate" type="text" id="inputCurrencyRate" name="inputCurrencyRate" style="width: 97%" value="${openLiab.currencyRate}" lastValidValue="" /></td>
						</tr>
						<tr>
							<td class="rightAligned">Voyage Limit</td>
							<td class="leftAligned" colspan="3">
								<div style="border: 1px solid gray; height: 20px; width: 99.7%;">
									<textarea id="inputVoyLimit" name="inputVoyLimit" style="width: 95%; border: none; height: 13px;">${openLiab.voyLimit}</textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editVoyLimit" />
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<c:if test="${1 eq mode}">			
				<div id="cargoClassDivAndFormDiv" name="cargoClassDivAndFormDiv" class="sectionDiv"  align="center" changeTagAttr="true">
					<jsp:include page="/pages/underwriting/subPages/cargoClass.jsp"></jsp:include>
				</div>
			</c:if>
			
			<div id="perilDivAndFormDiv" name="perilDivAndFormDiv" class="sectionDiv"  align="center" changeTagAttr="true">
				<jsp:include page="/pages/underwriting/subPages/openPeril.jsp"></jsp:include>
			</div>
		</div>				
		<div class="buttonsDiv" id="liabilityButtonsDiv">
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" style="width: 90px;" id="btnDelete" name="btnDelete" value="Delete" />
						<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
						<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>
<script type="text/javascript" defer="defer">
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	var mode = $F("mode");
	var deleted = false;
	addStyleToInputs();
	initializeAll();
	setDocumentTitle(mode == 1 ? "Cargo Limits of Liability" : "Limits of Liabilities Data Entry");
	initializeAccordion();
	initializeAllMoneyFields();
	setModuleId(mode == 1 ? "GIPIS005" : "GIPIS172");

	objLimitsOfLiability = {};
	objLimitsOfLiability.exitPage = null;
	objLimitsOfLiability.saveLimitOfLiability = null;
	
	var liab = '${openLiab}';
	//setLiabMenus();
	
	$("btnSave").observe("click", function () {
		pAction = pageActions.save;
		saveLimitOfLiability();
	});
	
	$("btnCancel").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndCancel, showParListing, "");
		} else {
			showParListing();
		}
	});
	
	$("btnDelete").observe("click", function(){
		showConfirmBox("Confirmation", "All details of this record will be deleted. Are you sure you want to delete this Limit of Liability?", "Yes", "No", deleteLimitOfLiability, "");
	});

	$("inputCurrency").observe("change", function() {
		var index = $("inputCurrency").selectedIndex; 
		toggleCurrency(index);
	});

	$("inputCurrency").observe("keypress", function() {
		var index = $("inputCurrency").selectedIndex;
		toggleCurrency(index);
	});

	$("inputGeography").observe("change", function() {
		var index = $("inputGeography").selectedIndex; 
		toggleGeography(index);
	});

	$("inputCurrency").observe("keypress", function() {
		var index = $("inputGeography").selectedIndex;
		toggleGeography(index);
	});

	//added by dalcantara
	$("inputLimit").observe("focus", function(){
		$("inputLimit").select();
	});
		
	$("inputLimit").observe("blur", function() {
		if (parseFloat($F("inputLimit").replace(/,/g, "")) > 99999999999999.99 ||
						parseFloat($F("inputLimit").replace(/,/g, "")) < 0 ||
						isNaN(parseFloat($F("inputLimit")))) {
			showMessageBox("Invalid Limit of Liability. Value should be from 0.00 to 99,999,999,999,999.99.");
			$("inputLimit").value = "";
			$("inputLimit").focus();
		}
	});

	$("inputCurrencyRate").observe("blur", function() {
		if(parseFloat($F("inputCurrencyRate").replace(/,/g, "")) >= 1000) {
			//showMessageBox("Currency Rate must not be greater than 999.999999999.");
			showMessageBox("Currency Rate must be of form 990.999999999.");
			$("inputCurrencyRate").value = "";
			$("inputCurrencyRate").focus();
		}
	});
	
	setGeography($F("geogCd"));

	function reloadLimitsOfLiab(){
		showLimitsOfLiabilityPage(mode);
	}

	function saveAndReload(){
		pAction = pageActions.reload;
		saveLimitOfLiability();
		reloadLimitsOfLiab();
	}
	
	function saveAndCancel(){
		pAction = pageActions.cancel;
		saveLimitOfLiability();
		objLimitsOfLiability.exitPage = showParListing;
	}
	
	function toggleCurrency(index){
		if(index == 0) {
			$("inputCurrencyRate").value = "";
		} else {
			$("inputCurrencyRate").setAttribute("lastValidValue", $("inputCurrency").options[index].getAttribute("rate"));
			$("inputCurrencyRate").value = formatToNineDecimal($("inputCurrency").options[index].getAttribute("rate"));
			if($("inputCurrencyRate").value == 1 || $("inputCurrencyRate").value == "1") {
				$("inputCurrencyRate").setAttribute("readonly", "readonly");
			} else {
				$("inputCurrencyRate").removeAttribute("readonly");
			}
		}
		$("currencyCd").value = $F("inputCurrency");
	}

	function toggleGeography(index){
		$("geogCd").value = $F("inputGeography");
	}
	
	function setGeography(geogCd){
		try {
			(geogCd == "" ? $("inputGeography").enable() : $("inputGeography").disable());
			(geogCd == "" ? $("inputCurrency").enable() : $("inputCurrency").disable());
			(geogCd == "" ? $("inputCurrencyRate").removeAttribute("readonly") : $("inputCurrencyRate").setAttribute("readonly", "readonly"));
			(geogCd == "" ? disableButton("btnDelete") : enableButton("btnDelete"));
			
		} catch (e) {
			showErrorMessage("setGeography", e);
		}
	}

	function saveLimitOfLiability(){
		try {
			if(deleted && $F("geogCd") != "") {
				deleted = false;
			}
			if(isRecordValid()){
				if ($F("withInvoiceTag") == "Y") {
					$("withInvoice").checked = true;
				} else {
					$("withInvoice").checked = false;
				}
				
				if($F("inputCurrencyRate") != ""){ //marco - 08.13.2014 - added condition to prevent error on delete
					$("inputCurrencyRate").value = parseFloat($F("inputCurrencyRate")); // added by jdiago 07.08.2014 to avoid converting of 0.000000000 to 0E-9 on java. 
				}
				
				new Ajax.Request("GIPIWOpenLiabController?action=saveLimitOfLiability&"+Form.serialize("uwParParametersForm"), {
					method: "POST",
					parameters: fixTildeProblem(Form.serialize("liabilityMainForm")),
					onCreate: function() {
						setCursor("wait");
						$("liabilityMainForm").disable();
						$("inputGeography").disable();
						$("inputCurrency").disable();
						showNotice("Saving " + (mode == 1 ? "Cargo" : "") + " Limits of Liability, please wait...");
					}, 		
					onComplete: function (response)	{		
						hideNotice();
						setCursor("default");
						if (checkErrorOnResponse(response)) {
							changeTagFunc = "";
							$("limitForDeleteDiv").update("");
							changeTag = 0;
							setGeography($F("geogCd"));
														
							$("liabilityMainForm").enable();
							if(!deleted) {
								setGeography("1");
							}
							deleted = false;
							if (pAction == pageActions.reload){
								showLimitsOfLiabilityPage(mode);
							} else if (pAction == pageActions.cancel){
								showParListing();
							} else {
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
									if(objLimitsOfLiability.exitPage != null){
										objLimitsOfLiability.exitPage();
									} else if(lastAction != null && lastAction != "") {
										lastAction();
										lastAction = "";
									} else {
										updateParParameters();
										$("withInvoice").disable();
									}
								});
							}			
						} else {
							$("withInvoice").checked = false;
							$("withInvoiceTag").value = "N";
							result = false;
							updateParParameters();
							$("withInvoice").disable();
						}
						$("inputCurrencyRate").value = formatToNineDecimal($("inputCurrencyRate").value); // added by jdiago 07.08.2014 to reformat currency rate after parsing to float.
					}
				});
			}
		} catch (e) {
			showErrorMessage("saveLimitOfLiability", e);
		} finally {
			hideNotice();
			pAction = pageActions.none;
			liab = "1";
			setLiabMenus();
		}
	}

	function deleteLimitOfLiability(){
		try {
			changeTag = 1;
			var geogCd 				= $F("geogCd");
			var limitForDeleteDiv 	= $("limitForDeleteDiv");
			var content 			= '<input type="hidden" id="delGeogCd" name="delGeogCd" value="'+geogCd+'">';
			limitForDeleteDiv.insert({bottom : content});
			$("inputLimit").value = "";
			resetLimitOfLiabilityForm();
			deleted = true;
		} catch (e){
			showErrorMessage("deleteLimitOfLiability", e);
		}
	}

	function resetLimitOfLiabilityForm(){
		try {
			$("geogCd").value 					= "";
			setGeography($F("geogCd"));
			$("inputGeography").selectedIndex 	= 0;
			$("inputCurrency").selectedIndex 	= 0;
			$("inputLimit").value 				= ""; //formatCurrency("0");
			$("inputCurrencyRate").value 		= ""; //formatToNineDecimal("0");
			$("inputVoyLimit").value 			= "";
			$("withInvoice").checked = false;
			$("withInvoiceTag").value = "N";
	
			if (mode == 1) {
				$$("div[name='rowCargo']").each(function(row) {
					row.remove();
				});
				$("inputCargoClass").value = "";
				checkIfToResizeTable("cargoClassList", "rowCargo");
				checkTableIfEmpty("rowCargo", "cargoClassDiv");
				$("cargoForDeleteDiv").update("");
				$("cargoForInsertDiv").update("");
			}
			
			$$("div[name='rowPeril']").each(function(row){
				row.remove();
			});
			
			checkIfToResizeTable("openPerilList", "rowPeril");
			checkTableIfEmpty("rowPeril", "openPerilDiv");
			$("perilForDeleteDiv").update("");
			$("perilForInsertDiv").update("");
			$("withInvoice").checked = false;
			
			//benjo 10.05.2015 GENQA-4994
			$("txtPerilName").value = "";
			$("inputPremiumRate").value = "";
			$("inputPremiumRate").setAttribute("lastValidValue", "");
			$("inputOpenPerilRemarks").value = "";
	        $("btnAddOpenPeril").value = "Add";
			enableSearch("searchOpenPeril");
			disableButton("btnDeleteOpenPeril");
			//end
		} catch (e){
			showErrorMessage("resetLimitOfLiabilityForm", e);
		}
	}

	function isRecordValid(){
		try {
			var result = true;
			var premAmt = parseFloat(nvl($("perilRateTotal").value, 0))*parseFloat($F("inputLimit").replace(/,/g, ""))/100;
			var polPrem = premAmt * parseFloat($F("inputCurrencyRate"));
			if (!deleted) {
				if ($F("inputGeography") == "") {
					showMessageBox("Geography is required.");
					$("inputGeography").focus();
					result = false;
				} else if ($F("inputLimit") == ""){
					showMessageBox("Limit of Liability is required.");
					$("inputLimit").focus();
					result = false;
				} else if ($F("inputCurrency") == "") {
					showMessageBox("Currency is required.");
					$("inputCurrency").focus();
					result = false;
				} else if (parseFloat($F("inputLimit").replace(/,/g, "")) > 99999999999999.99 ||
						parseFloat($F("inputLimit").replace(/,/g, "")) < 0 ||
						isNaN(parseFloat($F("inputLimit")))) {
					showMessageBox("Invalid Limit of Liability. Value should be from 0.00 to 99,999,999,999,999.99.");
					$("inputLimit").value = "";
					$("inputLimit").focus();
					result = false;
				/*} else if (getCargoClassCount() == 0 && mode == 1) {
					showMessageBox("Cargo Class is required.");
					$("inputCargoClass").focus();
					result = false;
				} else if(nvl(parseFloat($("perilRateTotal").value, 0)) > 0 &&  parseFloat($F("inputLimit").replace(/,/g, "")) > 9999999999.99) {
					*/	
				} else if((parseFloat($F("inputLimit").replace(/,/g, "")) * parseFloat($F("inputCurrencyRate"))) > 99999999999999.99){ //marco - 08.13.2014 - added to prevent error when converted amount is too large
					showMessageBox("The values for Limit of Liability and Currency Rate are too large for the TSI Amount. </br>" + 
					"Please replace their values.");
					$("inputLimit").focus();
					return false;
				} else if(parseFloat(premAmt) >= 10000000000 && !deleted) {
					showMessageBox("The values for Limit of Liability and Total Premium Rate are too large for the Premium Amount. </br>" + 
							"Please replace their values.");
					$("inputLimit").focus();
					return false;
				} else if(parseFloat(polPrem) >= 10000000000 && !deleted) {
					showMessageBox("The values for Limit of Liability and Total Premium Rate are too large for the Premium Amount. </br>" + 
							"Please replace their values.");
					$("inputLimit").focus();
					return false;
				} else if ($$("div[name='rowPeril']").size() == 0){
					showMessageBox("Peril is required.");
					$("inputOpenPeril").focus();
					result = false;
				} else if (changeTag == 0) {
					showMessageBox("No changes to save.");
					result = false;					   
				} else if ($F("inputCurrencyRate") == "") {
					showMessageBox("Currency Rate must be of form 990.999999999");
					result = false;
				}
			}
			return result;
		} catch (e){
			showErrorMessage("isRecordValid", e);
		}
	}

	$("editVoyLimit").observe("click", function () {
		//showEditor("inputVoyLimit", 400); replace by jdiago 07.08.2014
		showOverlayEditor("inputVoyLimit", 400, $("inputVoyLimit").hasAttribute("readonly")); // added by jdiago 07.08.2014
		changeTag = 1;
	});
	
	$("inputVoyLimit").observe("keyup", function () {
		limitText(this, 400);
		changeTag = 1;
	});

	function setLiabMenus() {
		if(liab == null || liab == "" || deleted == true) {
			disableMenu("post");
		} else {
			if($("withInvoice").checked) {
				enableMenu("bill");
				enableMenu("distribution");
				disableMenu("post");
			} else {
				disableMenu("bill");
				disableMenu("distribution");
				enableMenu("post");
			}
		}
	}

	$("inputCurrencyRate").observe("change", function(){
		if(parseFloat($F("inputCurrencyRate")) > 100 || $F("inputCurrencyRate") == ""){
			showWaitingMessageBox("Invalid Currency Rate. Valid value should be from 0.000000000 to 999.999999999.", "I", function(){
				$("inputCurrencyRate").value = ($("inputCurrencyRate").readAttribute("lastValidValue").trim() == "" ? "" : formatToNineDecimal($("inputCurrencyRate").readAttribute("lastValidValue")));
				$("inputCurrencyRate").focus();
			});
		} else {
			$("inputCurrencyRate").setAttribute("lastValidValue", $F("inputCurrencyRate"));
			$("inputCurrencyRate").value = formatToNineDecimal($F("inputCurrencyRate"));	
		}
	});
	
	$("inputCurrencyRate").observe("keyup", function(){
		if(isNaN($F("inputCurrencyRate"))){
			$("inputCurrencyRate").value = ($("inputCurrencyRate").readAttribute("lastValidValue").trim() == "" ? "" : formatToNineDecimal($("inputCurrencyRate").readAttribute("lastValidValue")));
		}
	});	
	
	objLimitsOfLiability.saveLimitOfLiability = saveLimitOfLiability;	
	observeReloadForm("reloadForm", reloadLimitsOfLiab);
	observeSaveForm("btnSave", saveLimitOfLiability);

	$("parExit").stopObserving("click");
	$("parExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	changeTag = 0;
	//initializeChangeTagBehavior(saveLimitOfLiability);
	initializeChangeAttribute();
</script>