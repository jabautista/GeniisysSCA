<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="endtLimitsOfLiabMainDiv" name="endtLimitsOfLiabMainDiv">
	<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Limits of Liability</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<form id="limitsOfLiabilityForm" name="limitsOfLiabilityForm">
		<div id="limitsOfLiabilityInfoDiv" name="limitsOfLiabilityInfoDiv" class="sectionDiv" style="float: left; width: 100%" changeTagAttr="true">
			<input type="hidden" id="parId"  name="parId" value="${openLiab.parId}" />
			<input type="hidden" id="geogCd"  name="geogCd" value="${openLiab.geogCd}" />
			<input type="hidden" id="currencyCd" name="currencyCd" value="${openLiab.currencyCd}" />
			<input type="hidden" id="recFlag" name="recFlag" value="${openLiab.recFlag}" />
			<input type="hidden" id="withInvoiceTag" name="withInvoiceTag" 	value="${openLiab.withInvoiceTag}" /> 
			<table align="center" width="80%" style="padding: 10px 0 10px 0;">
				<tr>
					<td class="rightAligned" width="8%">Geography</td>
					<td class="leftAligned" width="25%">
						<select id="inputGeography" name="inputGeography" style="width: 100%; overflow: scroll;" class="required" tabindex="201">
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
						<input id="inputCurrency" name="inputCurrency" type="text" style="width: 97%;" class="required" tabindex="203" readonly="readonly" value=
						<c:forEach var="currency" items="${currencies}">
							<c:if test="${currency.code eq openLiab.currencyCd}">
								"${currency.desc}"
							</c:if>
						</c:forEach>>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Limit of Liability</td>
					<td class="leftAligned"><input class="money" type="text" id="inputLimit" name="inputLimit" style="width: 97%; text-align: right;" value="${openLiab.limitOfLiability}" maxlength="22" tabindex="202"/></td>
					<td class="rightAligned">Currency Rate</td>
					<td class="leftAligned"><input class="moneyRate" type="text" id="inputCurrencyRate" name="inputCurrencyRate" style="width: 97%" value="${openLiab.currencyRate}" tabindex="204" readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Voyage Limit</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 99.7%;">
							<textarea id="inputVoyLimit" name="inputVoyLimit" style="width: 95%; border: none; height: 13px;" maxlength="400" tabindex="205">${openLiab.voyLimit}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editVoyLimit" tabindex="206"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</form>
	
	<div id="endtCargoClassDiv" name="endtCargoClassDiv">
		
	</div>
	
	<div id="endtOpenPerilDiv" nmae="endtOpenPerilDiv">
	
	</div>
	
	<div id="lolButtonsDiv" name="lolButtonsDiv" class="buttonsDiv">
		<input type="button" class="button" style="width: 90px;" id="btnDeleteLol" name="btnDelete" value="Delete" />
		<input type="button" class="button" style="width: 90px;" id="btnCancelLol" name="btnCancel" value="Cancel" />
		<input type="button" class="button" style="width: 90px;" id="btnSaveLol" name="btnSave" value="Save" />
	</div>
</div>

<script type="text/javascript">
	var deleteSw = "N";
	objEndtLol = new Object();
	objEndtLol.vars = JSON.parse('${vars}');
	changeTagCargo = 0;
	changeTagPeril = 0;
	
	function showEndtCargoClass(){
		new Ajax.Updater("endtCargoClassDiv", contextPath+"/GIPIWOpenCargoController",{
			method: "GET",
			parameters: {
				action 		: "getEndtWOpenCargo",
				globalParId : $F("parId"),
				geogCd 		: $F("geogCd")
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(){
				showEndtOpenPeril();
			}
		});
	}
	
	function showEndtOpenPeril(){
		new Ajax.Updater("endtOpenPerilDiv", contextPath+"/GIPIWOpenPerilController",{
			method: "GET",
			parameters: {
				action 		 : "getEndtOpenPeril",
				globalParId  : $F("parId"),
				geogCd 		 : $F("geogCd"),
				globalLineCd : $F("globalLineCd")
			},
			evalScripts: true,
			asynchronous: false
		});
	}
	
	function initializeLolFields(){
		$("inputLimit").value = formatCurrency(nvl($F("inputLimit"), "0"));
		$("inputCurrencyRate").value = formatToNineDecimal($F("inputCurrencyRate"));
		$("inputVoyLimit").value = unescapeHTML2($F("inputVoyLimit"));
		
		if(nvl('${openLiab}', "") != ""){
			$("inputGeography").disable();
		}else{
			disableButton("btnDeleteLol");
		}
	}
	
	function deleteLol(){
		$("inputGeography").selectedIndex = 0;
		$("inputCurrency").value = "";
		$("inputLimit").value = "";
		$("inputCurrencyRate").value = "";
		$("inputVoyLimit").value = "";
		$("inputGeography").enable();
		
		$("parId").value = "";
		$("geogCd").value = "";
		$("currencyCd").value = "";
		$("recFlag").value = "";
		$("withInvoiceTag").value = "";
		
		enableInputField("inputLimit");
		disableButton("btnDeleteLol");
		
		cargoClassTableGrid.url = contextPath+"/GIPIWOpenCargoController?action=getEndtWOpenCargo&refresh=1&globalParId=0&geogCd=0",
		cargoClassTableGrid._refreshList();
		cargoClassTableGrid.onRemoveRowFocus();
		
		openPerilTableGrid.url = contextPath+"/GIPIWOpenPerilController?action=getEndtOpenPeril&refresh=1&globalParId=0&geogCd=0&lineCd=0",
		openPerilTableGrid._refreshList();
		openPerilTableGrid.onRemoveRowFocus();
		
		deleteSw = "Y";
		changeTag = 1;
	}
	
	function saveEndtLol(){
		if(deleteSw == "N" ? checkAllRequiredFieldsInDiv("limitsOfLiabilityInfoDiv") : true){
			try{
				var objParams = new Object();
				objParams.setCargoRows = getAddedJSONObjects(objEndtLol.cargoClass);
				objParams.delCargoRows = getDeletedJSONObjects(objEndtLol.cargoClass);
				objParams.setPerilRows = getAddedAndModifiedJSONObjects(objEndtLol.openPeril);
				objParams.delPerilRows = getDeletedJSONObjects(objEndtLol.openPeril);
				$("withInvoiceTag").value = $("withInvoice").checked ? "Y" : "N";
				
				new Ajax.Request(contextPath+"/GIPIWOpenLiabController?action=saveEndtLimitsOfLiability",{
					method: "POST",
					parameters:{
						parameters: JSON.stringify(objParams),
						globalParId: nvl($F("globalParId"), objUWGlobal.parId),
						lineCd: nvl($F("globalLineCd"), objUWGlobal.lineCd),
						issCd: nvl($F("globalIssCd"), objUWGlobal.issCd),
						deleteSw: deleteSw,
						currencyCd: $F("currencyCd"),
						geogCd: $F("geogCd"),
						inputCurrency :	$F("inputCurrency"),
						inputCurrencyRate :	$F("inputCurrencyRate"),
						inputLimit:	$F("inputLimit"),
						inputVoyLimit :$F("inputVoyLimit"),
						parId: $F("parId"),
						recFlag: $F("recFlag"),
						withInvoiceTag:	$F("withInvoiceTag"),
						inputGeography: $F("inputGeography")
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: function(){
						showNotice("Saving Limits Of Liability, please wait...");
					},
					onComplete: function(response){
						hideNotice("");
						deleteSw = "N";
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							//changeTag = 0;
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								changeTag = 0;
								changeTagCargo = 0;
								changeTagPeril = 0;
								if(exitSw)
									showEndtParListing();
								else {
									if(saveSw)
										showEndtLimitsOfLiabilityPage();
									else if(logOutOngoing != "Y")
										lastAction();
								}
							});
						}
					}
				});
			}catch(e){
				showErrorMessage("saveEndtLol", e);
			}
		}
	}
	
	function getDefaultCurrency(){
		new Ajax.Request(contextPath+"/GIPIWOpenLiabController",{
			method: "GET",
			parameters:{
				action    : "getDefaultCurrency",
				lineCd	  : objEndtLol.vars.lineCd,
				sublineCd : objEndtLol.vars.sublineCd,
				issCd	  : objEndtLol.vars.issCd,
				issueYy	  : objEndtLol.vars.issueYy,
				polSeqNo  : objEndtLol.vars.polSeqNo,
				renewNo   : objEndtLol.vars.renewNo
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					var obj = JSON.parse(response.responseText);
					$("currencyCd").value = obj.currencyCd;
					$("inputCurrency").value = unescapeHTML2(obj.currencyDesc);
					$("inputCurrencyRate").value = formatToNineDecimal(obj.currencyRt);
				}
			}
		});
	}
	
	$("inputGeography").observe("change", function(){
		if($F("inputGeography") == ""){
			$("inputCurrency").value = "";
			$("inputCurrencyRate").value = "";
			$("geogCd").value = "";
			$("recFlag").value = "";
		}else{
			$("geogCd").value = $F("inputGeography");
			$("recFlag").value = "A";
			getDefaultCurrency();
		}
	});
	
	$("inputLimit").observe("change", function(){
		if(parseFloat(unformatCurrencyValue($F("inputLimit"))) > parseFloat(99999999999999.99)){
			showMessageBox("Invalid Limit of Liability. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.", "I");
			$("inputLimit").value = "";
		}else if(parseFloat(unformatCurrencyValue($F("inputLimit"))) < parseFloat(-99999999999999.99)){
			showMessageBox("Invalid Limit of Liability. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99.", "I");
			$("inputLimit").value = "";
		}
	});
	
	$("editVoyLimit").observe("click", function (){
		showOverlayEditor("inputVoyLimit", $("inputVoyLimit").readAttribute("maxLength"), $("inputVoyLimit").hasAttribute("readonly"), null);
	});
	
	$("btnDeleteLol").observe("click", function(){
		showConfirmBox("Confirmation", "All details of this record will be deleted. Are you sure you want to delete this Limit of Liability?",
				"Yes", "No", deleteLol, "");
	});
	
	showEndtCargoClass();
	initializeAll();
	initializeLolFields();
	initializeAccordion();
	initializeAllMoneyFields();
	initializeChangeTagBehavior(saveEndtLol);
	
	observeReloadForm("reloadForm", showEndtLimitsOfLiabilityPage);
	observeSaveForm("btnSaveLol", function(){saveSw = true; saveEndtLol();});
	//observeCancelForm("btnCancelLol", saveEndtLol, showEndtParListing);
	
	var exitSw = false;
	var saveSw = false;
	
	function exitGIPIS078(){
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){exitSw = true; saveEndtLol();}, 
					function(){changeTag=0; showEndtParListing();},
					"");
		} else {
			showEndtParListing();
		}
	}
	
	$("parExit").stopObserving("click");
	
	$("btnCancelLol").observe("click", exitGIPIS078);
	$("parExit").observe("click", exitGIPIS078);
</script>