<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="endtLiabilityMainDiv" name="endtLiabilityMainDiv" style="margin-top: 1px; display: none;">
	<form id="endtLiabilityMainForm" name="endtLiabilityMainForm">
		 <jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		
		<%--<input type="hidden" id="mode" name="mode" value="${mode}" /> --%>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Endorsement - Limits of Liability</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		
		<div id="endtLimitOfLiabilityDivAndFormDiv" name="endtLimitOfLiabilityDivAndFormDiv" class="sectionDiv" align="center" style="border: 0px solid transparent; " changeTagAttr="true">
			<div id="endtLiabilityDivAndFormDiv" name="endtLiabilityDivAndFormDiv" class="sectionDiv" align="center">
				<div id="endtLimitForDelete" name="endtLimitForDelete">
				</div>
				<div id="endtLiabilityFormDiv" name="endtLiabilityFormDiv" style="width: 100%; margin: 10px 0px 0px 0px; border: 1px;" changeTagAttr="true"> <!-- margin: 10px 0px 10px 0px; -->
					<input type="hidden" id="parId" name="parId" value="${openLiab.parId}" />
					<input type="hidden" id="geogCd"	name="geogCd"	value="${openLiab.geogCd}" />
					<input type="hidden" id="limitOfLiability" name="limitOfLiability" value="${openLiab.limitOfLiability}" />
					<input type="hidden" id="currencyCd"	name="currencyCd"	value="${openLiab.currencyCd}" />
					<input type="hidden" id="recFlag"		name="recFlag"		value="${openLiab.recFlag}" />
					<input type="hidden" id="withInvoiceTag" name="withInvoiceTag" value="${openLiab.withInvoiceTag}" />
					<table align="center" width="80%">
						<tr>
							<td class="rightAligned" width="10%">Geography</td>
							<td class="leftAligned" width="25%">
								<span class="required lovSpan" style="width: 98%;">
									<input type="text" class="required" id="inputGeography" name="inputGeography" 
												<c:forEach var="geo" items="${geographies}">
													<c:if test="${geo.geogCd eq openLiab.geogCd}">
														value="${geo.geogDesc}"
														readonly="readonly"
													</c:if>
												</c:forEach>
										style="border: none; float: left; width: 200px; height: 13px; margin: 0px;" readonly="readonly" tabindex="201 /">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchGeography" name="searchGeography" alt="Go" style="float: right;" tabindex="202" />
								</span>
							</td>
							<td class="rightAligned" width="10%">Currency</td>
							<td class="leftAligned" width="25%">
								<select id="inputCurrency" name="inputCurrency" style="width: 100%;" class="required" tabindex="203"
									<%-- <c:if test="${openLiab.currencyCd ne null}">
										disabled="disabled"
									</c:if> --%>
								>
									<option value="" rate="0"></option>
									<c:forEach var="currency" items="${currencies}" varStatus="index">
										<option value="${currency.code}-${currency.valueFloat}" rate="${currency.valueFloat}"
											<c:if test="${currency.code eq openLiab.currencyCd}">
												selected="selected"
											</c:if>
										>${currency.desc}</option>
										<%-- <c:if test="${currency.code eq openLiab.currencyCd}">
											"${currency.desc}"
										</c:if> --%>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Limit of Liability</td>
							<td class="leftAligned" width="25%"><input class="required money2" type="text" id="inputLimit" name="inputLimit" style="width: 96%; text-align: right;" value="${openLiab.limitOfLiability}" maxlength="17" tabindex="202" /></td>
							<td class="rightAligned">Currency Rate</td>
							<td class="leftAligned"><input class="moneyRate" type="text" id="inputCurrencyRate" name="inputCurrencyRate" style="width: 97%" value="${openLiab.currencyRate}" tabindex="204" readonly="readonly" /></td>
						</tr>
						<tr>
							<td class="rightAligned">Voyage Limit</td>
							<td class="leftAligned" colspan="3">
								<div style="border: 1px solid gray; height: 20px; width: 99.7%">
									<textarea id="inputVoyLimit" name="inputVoyLimit" style="width: 95%; border: none; height: 13px;" maxlength="255" tabindex="205">${openLiab.voyLimit}</textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editVoyLimit" tabindex="206" />
								</div>
							</td>
						</tr>
					</table>
				</div>
				<div id="endtLiabilityButtonDiv" name="endtLiabilityButtonDiv" class="buttonsDiv" style="height: 40px; margin: 5px 0 0 10px; " > 
					<table align="center">
						<tr>
							<td><input type="button" class="button" style="width: 90px;" name="btnLiab" id="btnLiab" value="Delete" /></td>
						</tr>
					</table>
				</div>
			</div>
		</div>		
	</form>
	
	<div id="endtPerilDivAndFormDiv" name="endtPerilDivAndFormDiv" class="sectionDiv" align="center" changeTagAttr="true" style="padding: 0 0 0 0;">
		<%-- <jsp:include page="/pages/underwriting/subPages/openPeril.jsp"></jsp:include> --%>
		<!-- should replace this page with perils in tablegrid -->
		
		<!-- this is the new page: -->
		<%-- <jsp:include page="/pages/underwriting/endt/basicInfo1/subPages/endtLimitsOfLiabilityOpenPeril.jsp"></jsp:include> --%> 
	</div>	
			
	<div class="buttonsDiv" id="endtLolButtonsDiv" style="border: none; ">
		<table align="center" border="0">
			<tr>
				<td>
					<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
					<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />						
				</td>
			</tr>
		</table>
	</div>		
</div>

<script type="text/javascript" defer="defer">
	var perilRows = new Object();
	
	var deleteSw = "N";
	
	objEndtLol = new Object();
	objEndtLol.vars = JSON.parse('${vars}');
	
	addStyleToInputs();
	initializeAll();
	setDocumentTitle("Endorsement - Limits of Liabilities Data Entry");
	initializeAccordion();
	initializeAllMoneyFields();
	//initializeChangeTagBehavior();
	setModuleId("GIPIS173");
	toggleAddLimitButton();
	showEndtLolPeril();
	
	var liab = '${openLiab}';
	
	
	// fetches the perils 
	function showEndtLolPeril(){
		new Ajax.Updater("endtPerilDivAndFormDiv", contextPath+"/GIPIWOpenPerilController", {
			method: "GET",
			parameters: {
				action: "getEndtLolOpenPeril",
				globalParId: $F("parId"),
				geogCd: $F("geogCd"),
				globalLineCd: $F("globalLineCd")
			},
			evalScripts: true,
			asynchronous: false
		});
	}
	
	//  updates the value of the button if Add or Delete
	function toggleAddLimitButton(){
		try{
			if(nvl('${openLiab}', "") != ""){
				//disableButton("btnLiab");
				enableButton("btnLiab");
				$("inputGeography").disable();
				disableSearch("searchGeography");
			} else {
				//enableButton("btnLiab");
				disableButton("btnLiab");
				enableSearch("searchGeography");
			}
		}catch(e){
			showMessageBox("checkExistingLiab: "+e, e);
		}
	}
	
	//gets the default currency if there is no limit of liability yet
	function getDefaultCurrency(){
		new Ajax.Request(contextPath+"/GIPIWOpenLiabController", {
			method: "GET",
			parameters: {
				action		: "getDefaultCurrencyGIPIS173",
				lineCd		: objEndtLol.vars.lineCd,
				sublineCd	: objEndtLol.vars.sublineCd,
				issCd		: objEndtLol.vars.issCd,
				issueYy		: objEndtLol.vars.issueYy,
				polSeqNo	: objEndtLol.vars.polSeqNo,
				renewNo		: objEndtLol.vars.renewNo,
				currencyRate	: $F("inputCurrencyRate"),
				currencyDesc	: $F("inputCurrency")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				var obj = JSON.parse(response.responseText);
				$("currencyCd").value = obj.currencyCd;
				$("inputCurrency").value = obj.currencyCd+"-"+obj.currencyRt;
				$("inputCurrencyRate").value = formatToNineDecimal(obj.currencyRt);				
			}
		});
	}
	
	function deleteLol(){
		deleteSw = "Y";
		saveEndtLimitOfLiability();
		clearAllFields();
	}
	
	function clearAllFields(){
		$("inputGeography").value = "";
		$("inputLimit").value = "";
		$("inputCurrency").value = "";
		$("inputCurrencyRate").value = "";
		$("inputVoyLimit").value = "";
		$("txtPerilName").value = "";
		$("txtPremiumRate").value = "";
		$("txtRemarks").value = "";
		disableButton("btnLiab");
	}
	
	function checkRequiredFields(){
		if($F("inputGeography") == "" || $F("inputCurrency") == "" || $F("inputLimit") == ""){
			showMessageBox("One or more required fields are empty.", "I");
		} else {
			saveEndtLimitOfLiability();
		}
	}
	
	function saveEndtLimitOfLiability(){
		try{
			
			var objParams = new Object();
			objParams.setPerilRows = getAddedAndModifiedJSONObjects(objEndtLol.openPeril);
			objParams.delPerilRows = getDeletedJSONObjects(objEndtLol.openPeril);	
			
			//$("withInvoiceTag").value = $("withInvoiceTag").checked ? "Y" : "N";
			$("withInvoiceTag").value = $("chkWithInvoice").checked ? "Y" : "N";
			
			new Ajax.Request(contextPath + "/GIPIWOpenLiabController?action=saveEndtLolGIPIS173&"+unescapeHTML2(Form.serialize("endtLiabilityMainForm")), {
				method: "POST",
				parameters: {
					parameters		: JSON.stringify(objParams),
					globalParId		: nvl($F("globalParId"), objUWGlobal.parId),
					lineCd			: nvl($F("globalLineCd"), objUWGlobal.lineCd),
					issCd			: objEndtLol.vars.issCd,
					deleteSw		: deleteSw
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving Endorsement Limits of Liability, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					changeTag = 0;
					deleteSw = "N";
					if(checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							showEndtLimitsOfLiabilityDataEntry();
						});
					}
				}
			});
			
		}catch(e){
			showErrorMessage("saveEndtLimitOfLiability", e);
		}
	}
	
	
	function separateCurrencyAndRate(filter){
		// if filter == 'code' return currencyCd
		// if filter == 'rate'  return rate
		// else return null		
		var curr = $("inputCurrency").value;
		var str = curr.split("-");
		
		return (filter == "code" ? str[0] : filter == "rate" ? formatToNineDecimal(str[1]) : "" );
	}
	
	$("inputCurrency").observe("change", function(){
		if($F("inputCurrency") == ""){
			$("inputCurrencyRate").value = "";
		} else {
			$("inputCurrencyRate").value = separateCurrencyAndRate("rate");
			//$("inputCurrency").value = separateCurrencyAndRate("code"); 
			$("currencyCd").value = separateCurrencyAndRate("code");;
		}
		changeTag = 1;
	});
	
	$("inputGeography").observe("change", function(){
		if($F("inputGeography") == ""){
			$("inputCurrency").value = "";
			$("inputCurrencyRate").value = "";			
		} else {
			$("recFlag").value = "A";
			if($F("inputCurrency") == ""){
				getDefaultCurrency();	
			} 
		}
		changeTag = 1;
	});
	
	$("searchGeography").observe("click", function(){
		showGeographyLOV(); // calls the function in underwriting-lov.js which gets the list of geographies
		if($F("inputCurrency") == ""){
			getDefaultCurrency();	
			$("recFlag").value = "A";
		} 
		changeTag = 1;
	});
	
	$("inputLimit").observe("change", function(){
		if(parseFloat($F("inputLimit")) > parseFloat(99999999999999.99)){
			showMessageBox("Limit of Liability must not exceed 99,999,999,999,999.99", "I");
			$("inputLimit").value = "";
		} else if(parseFloat($F("inputLimit")) < parseFloat(-99999999999999.99)){
			showMessageBox("Limit of Liability must not be less than -99,999,999,999,999.99", "I");
			$("inputLimit").value = "";
		}
		changeTag = 1;
	});
	
	$("editVoyLimit").observe("click", function(){
		showEditor("inputVoyLimit", 255);
		changeTag = 1;
	});
	
	$("inputVoyLimit").observe("change", function(){
		var inputVoyageLimit = $F("inputVoyLimit");
		if(inputVoyageLimit.length == 255){
			showMessageBox("You have reached the maximum allowable characters (255) for this field.", "I");
		}
		changeTag = 1;
	});
	
	$("btnLiab").observe("click", function(){
		showConfirmBox("Confirmation", "All details of this record will be deleted. Are you sure you want to delete this Limit of Liability?", "Yes", "No", deleteLol, "");
	});
		
	observeReloadForm("reloadForm", showEndtLimitsOfLiabilityDataEntry);
	//observeSaveForm("btnSave", saveEndtLimitOfLiability);
	observeSaveForm("btnSave", checkRequiredFields);
	observeCancelForm("btnCancel", saveEndtLimitOfLiability, function(){showParListing();});
	//initializeChangeTagBehavior(saveEndtLimitOfLiability);
</script>