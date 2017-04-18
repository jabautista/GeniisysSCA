<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="enterCoInsurerMaindiv" name="enterCoInsurerMaindiv" style="margin-top: 1px;">
	<form id="enterCoInsurerForm" name="enterCoInsurerForm">
		<c:if test="${'Y' ne isPack}">
			<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>
		</c:if>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label id="lblCoInsurerTitle"><c:if test="${'Y' eq isPack}">Package </c:if>Co-Insurer Details</label>
			</div>
		</div>
		<div id="mainCoInsDiv" class="sectionDiv" changeTagAttr="true">
			<table align="center" width="80%">
				<tr>
					<td class="rightAligned" width="15%">Total TSI Amount</td>
					<td class="leftAligned" width="30%">
						<input type="text" id="totalTsiAmt" name="totalTsiAmt" style="width: 200px; margin-left: 10px;" class="applyDecimalRegExp" regExpPatt="nDeci1402" value=""/>
					</td>
					<td class="rightAligned" width="20%">Total Prem Amount</td>
					<td class="leftAligned" width="30%">
						<input type="text" id="totalPremAmt" name="totalPremAmt" style="width: 200px; margin-left: 10px;" class="applyDecimalRegExp" regExpPatt="nDeci1202" value=""/>
					</td>
				</tr>
			</table>
		</div>
		<div id="coInsurerDetailsDiv" class="sectionDiv" align="center">
			<div id="coInsurersTableDiv" style="width: 80%; text-align: center; display: block;">
				<div class="tableHeader">
					<label style="width: 190px; text-align: left; margin-left: 8px; 1px solid #E0E0E0;">Co-Insurer</label>
					<label style="width: 150px; text-align: right; margin-left: 1px; 1px solid #E0E0E0;">Co-Insurer %Share</label>
					<label style="width: 180px; text-align: right; margin-left: 1px; 1px solid #E0E0E0;">Co Insurer Prem Amt</label>
					<label style="width: 180px; text-align: right; margin-left: 1px; 1px solid #E0E0E0;">Co Insurer TSI Amt</label>
				</div>
				<div id="coInsurerListingDiv" name="coInsurerListingDiv"></div>
				<div id="coInsurerTotalDiv" name="coInsurerTotalsDiv" style="margin-top: 5px;">
					<label style="margin-left: 41.9%; text-align: right; margin-top: 5px;">Total:</label>
					<input style="border: none; margin-left: 1px; width: 170px; text-align: right; color: #000000; background-color: white;" type="text" 	id="coRiPremTotals" 	name="coRiPremTotals"  disabled="disabled" />
					<input style="border: none; margin-left: 1px; width: 170px; text-align: right; color: #000000; background-color: white;" type="text"	id="coRiTsiTotals"		name="coRiTsiTotals" disabled="disabled" />
					<input type="hidden" id="pctShareTotals" name="pctShareTotals" value="" />
				</div>
			</div>
			<div id="coInsurerDetailForms">
				<table align="center" style="margin-top: 15px; margin-bottom: 10px;">
					<tr>
						<td class="rightAligned" style="width: 150px;">Co-Insurer</td>
						<td class="leftAligned" style="width: 380px;">
							<input type="hidden" id="selectedCoRiCd" name="selectedCoRiCd" value="" />
							<input type="hidden" id="selectedRiSname" name="selectedRiSname" value="" />
							<div style="float: left; width: 325px; border: 1px solid gray; height: 19px;" class="required">
								<input type="text" style="width: 290px; float: left; border: none; height: 14px; padding-top: 0px;" id="inputCoInsurer" name="inputCoInsurer" value="" class="required" readonly="readonly" />
								<img id="searchCoInsurer" name="searchCoInsurer" alt="Go" style="float: right; visibility: visible;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png">
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 150px;">Co-Insurer %Share</td>
						<td class="leftAligned" style="width: 380px;">
							<input type="text" id="inputPctShare" name="inputPctShare" class="required applyDecimalRegExp" regExpPatt="pDeci0309" style="width: 320px; border: 1px solid gray; text-align: right;" readonly="readonly" customLabel="Co-Insurer %Share" min="0.000000001" max="100.00" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 150px;">Co-Insurer Premium Amt</td>
						<td class="leftAligned" style="width: 380px;">
							<input type="text" id="inputPremAmt" name="inputPremAmt" style="width: 320px; text-align: right;" class="required applyDecimalRegExp" regExpPatt="nDeci1002" readonly="readonly" customLabel="Premium amount" min="0.01" max="9999999999.99"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 150px;">Co-Insurer TSI Amt</td>
						<td class="leftAligned" style="width: 380px;">
							<input type="text" id="inputTsiAmt" name="inputTsiAmt" style="width: 320px; text-align: right;" class="required applyDecimalRegExp" regExpPatt="nDeci1402" readonly="readonly" customLabel="TSI amount" min="0.01" max="9999999999.99"/>
						</td>
					</tr>
				</table>
				<div style="margin-bottom: 10px; margin-top: 10px;">
					<input type="button" class="button" style="width: 60px;" 			id="btnAddInsurer" 		name="btnAddInsurer" 	value="Add" />
					<input type="button" class="disabledButton" style="width: 60px;" 	id="btnDelInsurer" 		name="btnDelInsurer" 	value="Delete" disabled="disabled" />
					<input type="button" class="disabledButton" style="width: 120px;" 	id="btnClearCoRi" 		name="btnClearCoRi" 	value="Clear Co-Insurer" disabled="disabled" />
				</div>
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" id="btnCancel" 	name="btnCancel" 		class="button" value="Cancel" 	style="width: 100px;" />
			<input type="button" id="btnSave" 		name="btnSave" 			class="button" value="Save" 	style="width: 100px;" />			
		</div>
		<input type="hidden" id="region" value="NCR"/>
	</form>
</div>

<script type="text/javascript">
	var objCoInsurers = JSON.parse('${coInsurers}'.replace(/\\/g, '\\\\'));
	var defaultCoInsurer;
	var objDefaults = JSON.parse('${objDefaults}');
	var addedCoRi = new Array();
	var deletedCoRi = new Array();
	hideNotice();
	setModuleId("GIPIS153");
	setDocumentTitle("Enter Co-Insurer");
	
	var totalTsiAmt = objDefaults.tsiAmt == null ? 0 : objDefaults.tsiAmt;	
	var totalPremAmt = objDefaults.premAmt == null ? 0 : objDefaults.premAmt;
	var totalShrPct = 0;		//:control.total_shr_pct
	var editAllowed = false;
	var defaultGenerated = (objCoInsurers.length > 0) ? true : false;

	var sumTsiAmt = nvl(objDefaults.tsiSum, null) == null ? 0 : parseFloat(objDefaults.tsiSum);	//:control.total_tsi_amt
	var sumPremAmt = nvl(objDefaults.premSum, null) == null ? 0 : parseFloat(objDefaults.premSum);	//:control.total_prem_amt
	var msgSw;
	var clickedAmtVal = 0;
	//var sveTsiAmt = $F("totalTsiAmt") == "" ? 0 : parseFloat($F("totalTsiAmt"));
	var totalPremPrevious = $F("totalPremAmt");
	var totalTsiPrevious = $F("totalTsiAmt");

	$("totalTsiAmt").value 	= nvl(formatCurrency(objDefaults.tsiAmt), "");
	$("totalPremAmt").value = nvl(formatCurrency(objDefaults.premAmt), "");
	
	setCoInsurerListing(objCoInsurers);
	
	if(objUWGlobal.parType == "E") {
		$$("input[type='text']").each(function(row) {
			row.readonly = true;
		});
		disableSearch("searchCoInsurer");
	}
	
	function checkInsurerSharePcts() {
		var editOk = 0; // 0 = ciLength >= 1; 1 = ciLength > 1; 2 = ciLength > 1, coRiShrPct w/ values
		var ciLength = objCoInsurers.length;
		if(ciLength > 1) {
			editOk = 1;
			for(var i=1; i<objCoInsurers.length; i++) {
				if(nvl(objCoInsurers[i].coRiShrPct, null) != null ||
						objCoInsurers[i].coRiShrPct != "") {
					editOk = 2;
				}
			}
		}
		return editOk;
	}

	function loadDefaultCoInsurer() {
		try {
			setCoRiFields(null);
			if(!(isNaN(unformatCurrencyValue($F("totalTsiAmt")))) && 
					!(isNaN(unformatCurrencyValue($F("totalPremAmt"))))) {
				editAllowed = true;
				totalTsiAmt = $F("totalTsiAmt") == "" ? 0 : unformatCurrencyValue($F("totalTsiAmt"));
				totalPremAmt = $F("totalPremAmt") == "" ? 0 : unformatCurrencyValue($F("totalPremAmt"));
				if(defaultGenerated) {
					for(var i=0; i<objCoInsurers.length; i++) {
						if(objCoInsurers[i].isDefault == "Y") {
							objCoInsurers[i].coRiShrPct = roundNumber(((objCoInsurers[i].coRiTsiAmt / totalTsiAmt) * 100), 9);

							var updatedContent = prepareCoInsurerRow(objCoInsurers[i]);
							$("coRiRow" + objCoInsurers[i].coRiCd).update(updatedContent);
							addModifiedCoRiObj(objCoInsurers[i]);
						}
					}
				} else {
					new Ajax.Request(contextPath+"/GIPICoInsurerController?action=loadDefaultCoInsurers", {
						method: "POST",
						parameters: {policyId: objDefaults.policyId == null ? "" : objDefaults.policyId},
						evalScripts: true,
						asynchronous: false,
						onComplete: function(response) {
							defaultCoInsurer = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
							for(var i=0; i<defaultCoInsurer.length; i++) {
								defaultGenerated = true;
								defaultCoInsurer[i].parId = objDefaults.parId == null ? $F("globalParId") : objDefaults.parId;
								defaultCoInsurer[i].coRiTsiAmt = sumTsiAmt;
								defaultCoInsurer[i].coRiPremAmt = sumPremAmt;
								defaultCoInsurer[i].coRiShrPct = roundNumber(((defaultCoInsurer[i].coRiTsiAmt / totalTsiAmt)*100), 9);
								defaultCoInsurer[i].isDefault = "Y";
								/* objCoInsurers.push(defaultCoInsurer[i]);
								addedCoRi.push(defaultCoInsurer[i]); */
								//addModifiedCoRiObj(defaultCoInsurer[i]);
								addCoInsurer(defaultCoInsurer[i]);
							}
							enableButton("btnClearCoRi");
						}
					});
				}
				computeCoRiTotals();
			}
		} catch(e) {
			showErrorMessage("loadDefaultCoInsurer", e);
		}
	}
	
	function setCoInsurerListing(objArr) {
		try {
			var listingTable = $("coInsurerListingDiv");
			for(var i=0; i<objArr.length; i++) {
				var content = prepareCoInsurerRow(objArr[i]);
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "coRiRow"+objArr[i].coRiCd);
				newDiv.setAttribute("name", "coRiRow");
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				listingTable.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);
/*				newDiv.observe("click", function() {
					clickCoRiRow(objArr[i], newDiv);
				});*/
			}
			if(objArr.length > 0) {
				defaultGenerated = true;
				enableButton("btnClearCoRi");
				setCoRiFields(null);
			} else {
				disableSearch("searchCoInsurer");
				disableButton("btnClearCoRi");
			}
			checkIfToResizeTable("coInsurerListingDiv", "coRiRow");
			checkTableIfEmpty("coRiRow", "coInsurersTableDiv");
			computeCoRiTotals();
		} catch(e) {
			showErrorMessage("setCoInsurerListing", e);
		}
	}

	function prepareCoInsurerRow(obj) {
		var row = "";
		if(obj != null) {
			var coRiName 		= obj.riSname;
			var coRiSharePct 	= obj.coRiShrPct == null ? "---" : formatToNineDecimal(obj.coRiShrPct);
			var coRiPrem 		= obj.coRiPremAmt == null ? "---" : formatCurrency(obj.coRiPremAmt);
			var coRiTsi 		= obj.coRiTsiAmt == null ? "---" : formatCurrency(obj.coRiTsiAmt);
			var isDefault		= obj.isDefault == null ? "" : obj.isDefault;

			row = '<input type="hidden" id="riCd'+obj.coRiCd+'" name="riCd" value="'+obj.coRiCd+'" />' +
				  '<label style="width: 190px; text-align: left; margin-left: 8px;" >'+coRiName+'</label>' +
				  '<label style="width: 150px; text-align: right; margin-left: 1px;" >'+coRiSharePct+'</label>' +
				  '<label style="width: 180px; text-align: right; margin-left: 1px;" >'+coRiPrem+'</label>' +
				  '<label style="width: 180px; text-align: right; margin-left: 1px;" >'+coRiTsi+'</label>' +
				  '<input type="hidden" id="isDefault" name="isDefault" value="'+isDefault+'" />';
		}

		return row;
	}

	function clickCoRiRow(newDiv) {
		var obj = null;
		newDiv.toggleClassName("selectedRow");
		if(newDiv.hasClassName("selectedRow")) {
			for(var i=0; i<objCoInsurers.length; i++) {
				if(newDiv.down("input", 0).value == objCoInsurers[i].coRiCd) {
					obj = objCoInsurers[i];
					break;
				}
			}
			$$("div[name='coRiRow']").each(function(r) {
				if(newDiv.getAttribute("id") != r.getAttribute("id")) {
					r.removeClassName("selectedRow");
				}
			});
			setCoRiFields(obj);
		} else {
			setCoRiFields(null);
		}
	}

	function setCoRiFields(obj) {
		try {

			$("selectedCoRiCd").value		=	obj == null ? "" : obj.coRiCd;
			$("selectedRiSname").value		=	obj == null ? "" : obj.riSname;
			$("inputCoInsurer").value		=	obj == null ? "" : obj.riName;
			$("inputPctShare").value 		=	obj == null ? "" : formatToNineDecimal(obj.coRiShrPct);
			$("inputPremAmt").value			=	obj == null ? "" : formatCurrency(obj.coRiPremAmt);
			$("inputTsiAmt").value			=	obj == null ? "" : formatCurrency(obj.coRiTsiAmt);

			obj == null ? disableButton("btnDelInsurer") : 
				(obj.isDefault == "Y" ? disableButton("btnDelInsurer") : enableButton("btnDelInsurer"));
			obj == null ? $("btnAddInsurer").value = "Add" : $("btnAddInsurer").value = "Update";

			if(obj != null) {
				//$("searchCoInsurer").setStyle("visibility", "hidden");
				disableSearch("searchCoInsurer");
				if(obj.isDefault == "Y" ||
					($F("inputTsiAmt") == "" && $F("inputPremAmt") == "")) {
					$("inputPctShare").setAttribute("readonly", "readonly");
					$("inputPremAmt").setAttribute("readonly", "readonly");
					$("inputTsiAmt").setAttribute("readonly", "readonly");
					editAllowed = false;
					disableButton("btnAddInsurer");
				} else {
					$("inputPctShare").removeAttribute("readonly");
					$("inputPremAmt").removeAttribute("readonly");
					$("inputTsiAmt").removeAttribute("readonly");
					
					editAllowed = false;
					clickedAmtVal = $F("inputPctShare") == "" ? 0 : parseFloat($F("inputPctShare"));
					enableButton("btnAddInsurer");
				}
			} else {
				clickedAmtVal = 0;
				enableButton("btnAddInsurer");
				//$("searchCoInsurer").setStyle("visibility", "visible");
				$("inputPctShare").removeAttribute("readonly");
				$("inputPremAmt").removeAttribute("readonly");
				$("inputTsiAmt").removeAttribute("readonly");
				if(defaultGenerated) {
					editAllowed = true;
					enableSearch("searchCoInsurer");
				} else {
					disableSearch("searchCoInsurer");
				}
			}
		} catch(e) {
			showErrorMessage("setCoRiFields", e);
		}
	}

	function setInsurerObj() {
		try {
			var newObj = new Object();
			
			newObj.parId			= objDefaults.parId == null ? $F("globalParId") : objDefaults.parId;
			newObj.coRiCd			= $F("selectedCoRiCd");
			newObj.coRiShrPct		= $F("inputPctShare");
			newObj.coRiPremAmt		= unformatCurrencyValue($F("inputPremAmt"));
			newObj.coRiTsiAmt		= unformatCurrencyValue($F("inputTsiAmt"));
			newObj.policyId			= "";
			newObj.riName			= $F("inputCoInsurer");
			newObj.riSname			= $F("selectedRiSname");;
			newObj.isDefault		= "N";

			return newObj;
		} catch(e) {
			showErrorMessage("setInsurerObj", e);
		}
	}

	function addCoInsurer(newObj) {
		try {
			var content = prepareCoInsurerRow(newObj);
			if($F("btnAddInsurer") == "Update") {
				$("coRiRow" + newObj.coRiCd).update(content);
				addModifiedCoRiObj(newObj);
				fireEvent($("coRiRow" + newObj.coRiCd), "click");
			} else {
				newObj.recordStatus = 0;
			
				var itemTable = $("coInsurerListingDiv");
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "coRiRow"+newObj.coRiCd);
				newDiv.setAttribute("name", "coRiRow");
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				itemTable.insert({bottom:newDiv});
				loadRowMouseOverMouseOutObserver(newDiv);

				newDiv.observe("click", function() {
					clickCoRiRow(newDiv);
				});

				objCoInsurers.push(newObj);
				addedCoRi.push(newObj);

				checkIfToResizeTable("coInsurerListingDiv", "coRiRow");
				checkTableIfEmpty("coRiRow", "coInsurersTableDiv");

				new Effect.Appear("coRiRow"+newObj.coRiCd, {
					duration: 0.2
				});
			}
			computeCoRiTotals();
			setCoRiFields(null);
			changeTag = 1; //marco - 05.23.2013
		} catch(e) {
			showErrorMessage("addCoInsurer", e);
		}
	}

	function addModifiedCoRiObj(obj) {
		for(var i=0; i<objCoInsurers.length; i++) {
			if(objCoInsurers[i].coRiCd == obj.coRiCd) {
				objCoInsurers.splice(i, 1);
			}
		}
		objCoInsurers.push(obj);
		for(var i=0; i<addedCoRi.length; i++) {
			if(obj.coRiCd == addedCoRi[i].coRiCd) {
				addedCoRi.splice(i, 1);
			}
		}
		addedCoRi.push(obj);
	}

	function addToDeletedCoRiObj(obj) {
		for(var i=0; i<objCoInsurers.length; i++) {
			if(obj.coRiCd == objCoInsurers[i].coRiCd) {
				deletedCoRi.push(obj);
				objCoInsurers.splice(i, 1);
			}
		}
		for(var i=0; i<addedCoRi.length; i++) {
			if(obj.coRiCd == addedCoRi[i].coRiCd) {
				addedCoRi.splice(i, 1);
			}
		}
	}

	function checkInputs(obj) {
		var result = true;
		for(var i=0; i<objCoInsurers.length; i++) {
			if(obj.coRiCd == objCoInsurers[i].coRiCd && $F("btnAddInsurer") == "Add") {
				showMessageBox("Co-Insurer has been added. Please select a different Co-Insurer", imgMessage.ERROR);
				return false;
			}
		}
		
		if($F("selectedCoRiCd") == "" || $F("inputCoInsurer") == "") {
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			result = false;
		} else if ($F("inputPctShare") == "") {
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			result = false;
		} else if ($F("inputPremAmt") == "") {
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			result = false;	
		} else if ($F("inputTsiAmt") == "") {
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			result = false;
		} else if (parseFloat($F("pctShareTotals")) == 100 && $F("btnAddInsurer") == "Add") {
			showMessageBox("Total co-insurer share percent is already 100%. </br>"+
					"You cannot add another record.", imgMessage.ERROR);
			setInsurerObj(null);
			result = false;
		} else if (parseFloat($F("pctShareTotals")) > 100) {
			
		}
		
		return result;
	}

	function deleteCoInsurer(delObj) {
		try {
			if(delObj.isDefault == "Y") {
				showMessage("Deletion of Default Co-Insurer is not allowed.");
			} else {
				$$("div#coInsurerListingDiv div[id='coRiRow"+delObj.coRiCd+"']").each(function(row) {
					Effect.Fade(row, {
						afterFinish: function() {
							//var delObj = (obj != null ? obj : setInsurerObj());
							addToDeletedCoRiObj(delObj);
							row.remove();

							setCoRiFields(null);
							checkIfToResizeTable("coInsurerListingDiv", "coRiRow");
							checkTableIfEmpty("coRiRow", "coInsurersTableDiv");
							computeCoRiTotals();
						}
					});
				});
				changeTag = 1; //marco - 05.23.2013
			}
		} catch(e) {
			showErrorMessage("deleteCoInsurer", e);
		}
	}

	function computeCoRiTotals() {
		var tempPremTotal = 0;
		var tempTsiTotal = 0;
		var tempPctTotal = 0;
		for(var i=0; i<objCoInsurers.length; i++) {
			tempPremTotal += objCoInsurers[i].coRiPremAmt == null ? 0 : parseFloat(objCoInsurers[i].coRiPremAmt);
			tempTsiTotal += objCoInsurers[i].coRiTsiAmt == null ? 0 : parseFloat(objCoInsurers[i].coRiTsiAmt);
			tempPctTotal += objCoInsurers[i].coRiShrPct == null ? 0 : parseFloat(objCoInsurers[i].coRiShrPct);
		}
		$("coRiTsiTotals").value 	= formatCurrency(tempTsiTotal);
		$("coRiPremTotals").value 	= formatCurrency(tempPremTotal);
		$("pctShareTotals").value 	= tempPctTotal;
	}

	function computePercentageAmounts(base) {
 		try {
			//base = 0, pct share; base = 1, tsi amt; base = 2, prem amt
			var temp = 1;
			totalTsiAmt = $F("totalTsiAmt") == "" ? 0 : unformatCurrencyValue($F("totalTsiAmt"));
			totalPremAmt = $F("totalPremAmt") == "" ? 0 : unformatCurrencyValue($F("totalPremAmt"));
			if(base == 0 && parseFloat($F("inputPctShare")) > 0) {
				temp = parseFloat($F("inputPctShare"));
				$("inputTsiAmt").value = formatCurrency(totalTsiAmt * (temp / 100));
				$("inputPremAmt").value = formatCurrency(totalPremAmt * (temp / 100));
			} else if(base == 1/*  && unformatCurrencyValue($F("inputTsiAmt")) > 0 */) {
				temp = unformatCurrencyValue($F("inputTsiAmt"));
				$("inputPctShare").value = formatToNineDecimal(roundNumber(((temp / totalTsiAmt) * 100),9));
				temp = isNaN($F("inputPctShare")) ? 1 : parseFloat($F("inputPctShare"));
				$("inputPremAmt").value = formatCurrency(totalPremAmt * (temp / 100)); 
			} else if(base == 2/*   && unformatCurrencyValue($F("inputTsiAmt")) > 0 */) {
				temp = unformatCurrencyValue($F("inputPremAmt"));
				$("inputPctShare").value = formatToNineDecimal(roundNumber(((temp / totalPremAmt) * 100),9));
				temp = isNaN($F("inputPctShare")) ? 1 : parseFloat($F("inputPctShare"));
				$("inputTsiAmt").value = formatCurrency(totalTsiAmt * (temp / 100)); 
			}
			
			//added by shan 10.22.2013
			if(computePctShare() > 100){
				showMessageBox("Total co-insurer share percent should not exceed 100%.", "E");
				$("inputTsiAmt").clear();
				$("inputPremAmt").clear();
				$("inputPctShare").clear();
			}
 		} catch(e) {
			showErrorMessage("computePercentageAmounts", e);
 		}
	}

	function saveCoInsurer(refresh) {
		try {
			if(objCoInsurers.length < 1) {
				showMessageBox("Record cannot be saved without Co-Insurer.");
			} else if(!checkCoInsurer()){
				showMessageBox("Record cannot be saved without Co-Insurer.");
			} else if(parseFloat($F("pctShareTotals")) > 100 || parseFloat($F("pctShareTotals")) < 99.999999999) {
				showMessageBox("The total RI share percentage must be 100%.");
			} else if (totalTsiAmt != unformatCurrencyValue($F("coRiTsiTotals"))) {
				showMessageBox("The tsi amount on the second block must be equal</br>"+
						" to the tsi amount on the third block.");
			} else if(totalPremAmt != unformatCurrencyValue($F("coRiPremTotals"))) {
				showMessageBox("The premium amount on the second block must be equal</br>"+
						" to the premium amount on the third block.");
			} else {
				var objParameter = new Object();
				objParameter.parId = $F("globalParId");
				objParameter.totalPremAmt = unformatCurrencyValue($F("totalPremAmt"));
				objParameter.totalTsiAmt = unformatCurrencyValue($F("totalTsiAmt"));
				objParameter.setRows = addedCoRi;
				objParameter.delRows = deletedCoRi;
				
				new Ajax.Request(contextPath+"/GIPICoInsurerController?action=saveCoInsurers", {
					method : "POST",
					parameters: {
						parameters : JSON.stringify(objParameter)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : 
						function(){
							showNotice("Saving Entered Co-Insurers, please wait...");
						},
					onComplete: function(response) {
							hideNotice();
							if(checkErrorOnResponse(response)) {
								changeTag = 0;
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, refresh ? showCoInsurerPage :function(){null;});
							} else {
								showMessageBox(response.responseText, imgMessage.ERROR);	
							}
						}
					
				});
			}
		} catch(e) {
			showErrorMessage("saveCoInsurer", e);
		}
	}
	
	function checkCoInsurer(){
		var result = false;
		$$("div#coInsurerListingDiv div[name='coRiRow']").each(function(row) {
			result = true;
		});
		return result;
	}

	$("totalTsiAmt").observe("change", function() {
		totalTsiAmt = $F("totalTsiAmt") == "" ? 0 : unformatCurrencyValue($F("totalTsiAmt"));
		totalPremAmt = $F("totalPremAmt") == "" ? 0 : unformatCurrencyValue($F("totalPremAmt"));
		
		if(isNaN(unformatCurrencyValue($F("totalTsiAmt"))) || ($F("totalTsiAmt").split(".").size > 2)) {
			clearFocusElementOnError("totalTsiAmt", "Invalid Total TSI amount. Value should be from 0.00 to 9,999,999,999.99.");
			return false;
		} else if((unformatCurrencyValue($F("totalTsiAmt")) < 0.01) || (unformatCurrencyValue($F("totalTsiAmt")) > 99999999999999.99)) {
			clearFocusElementOnError("totalTsiAmt", "Invalid Total TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.");
			return false;
		} else {
			var allowEdit = checkInsurerSharePcts();
			if(allowEdit == 0 || allowEdit == 1) {
				enableButton("btnClearCoRi");
				$("totalTsiAmt").value = formatCurrency($F("totalTsiAmt"));
				if($F("totalTsiAmt") != "" || totalTsiAmt > 0) {
					totalShrPct = roundNumber(((sumTsiAmt*100) / totalTsiAmt), 9);
					if(totalShrPct != parseFloat(100)) {
						msgSw = "N";
					}
					//if($F("totalPremAmt") == "") {	// commented out by shan 10.22.2013
						totalPremAmt = (sumPremAmt * 100) / totalShrPct;
						$("totalPremAmt").value = formatCurrency(totalPremAmt);
					//}
				}

				if(totalTsiAmt < sumTsiAmt) {
					showMessageBox("TSI amount should not be less than the TSI amount ("+sumTsiAmt+") of the policy.");
					$("totalTsiAmt").focus();
					return false;
				} else {
					loadDefaultCoInsurer();
				}
			} else {
				showMessageBox("The total TSI amount of this PAR cannot be updated, for detail records already exist.<br />"+
				 "However, you may choose to delete this record and recreate it with necessary changes.");
				$("totalTsiAmt").value = formatCurrency(totalTsiPrevious);
			}
		}
	});

	$("totalPremAmt").observe("change", function() {
		totalTsiAmt = $F("totalTsiAmt") == "" ? 0 : unformatCurrencyValue($F("totalTsiAmt"));
		totalPremAmt = $F("totalPremAmt") == "" ? 0 : unformatCurrencyValue($F("totalPremAmt"));
		if(isNaN($F("totalPremAmt")) || ($F("totalPremAmt").split(".").size > 2)) {
			clearFocusElementOnError("totalPremAmt", "Invalid Premium amount. Value should be from 0.01 to 9,999,999,999.99.");
		} else if((parseFloat($F("totalPremAmt")) < 0.01) || (unformatCurrencyValue($F("totalPremAmt")) > 99999999999999.99)) {
			clearFocusElementOnError("totalPremAmt",  "Invalid Premium amount. Value should be from 0.01 to 9,999,999,999.99.");
		} else {
			$("totalPremAmt").value = formatCurrency($F("totalPremAmt"));
			var allowEdit = checkInsurerSharePcts();
			if(allowEdit == 0 || allowEdit == 1) {
				if(totalPremAmt == 0) {
					totalShrPct = 100;
				} else {
					totalShrPct = (sumPremAmt * 100) / totalPremAmt;
				}
				if(totalShrPct != parseFloat(100)) {
					msgSw = "N";
				}
				//if(totalTsiAmt == 0) {
				totalTsiAmt = (sumTsiAmt * 100) / totalShrPct;
				$("totalTsiAmt").value = formatCurrency(totalTsiAmt);
				//}
				if(totalPremAmt < sumPremAmt) {
					showMessageBox("Premium amount should not be less than the Premium amount ("+sumPremAmt+") of the policy.");
					$("totalPremAmt").focus();
					return false;
				} else {
					loadDefaultCoInsurer();
				}
			} else {
				showMessageBox("The total premium amount of this PAR cannot be updated, for detail records already exist.<br />"+
				 "However, you may choose to delete this record and recreate it with necessary changes.");
				$("totalPremAmt").value = formatCurrency(totalPremPrevious);
			}
		}
	});

	$("btnAddInsurer").observe("click", function() {
		var newObj = setInsurerObj();
		if(checkInputs(newObj)) {
			addCoInsurer(newObj);
		}
	});

	$("btnDelInsurer").observe("click", function() {
		var delObj = setInsurerObj();
		deleteCoInsurer(delObj);
	});

	$("inputPctShare").observe("change", function() {
		var pctShare = $F("inputPctShare");
		if(!(isNaN(parseFloat(pctShare)))) {
			if ((parseFloat(pctShare) > 100) || (parseFloat(pctShare) < 0)) {
				clearFocusElementOnError("inputPctShare", "Entered Co-Insurer Share % is invalid. Valid value is from 0.00 to 100.00");
			} else if (computePctShare() > 100) {
				clearFocusElementOnError("inputPctShare", "Total co-insurer share percent should not exceed 100%.");
			} else {
				$("inputPctShare").value = formatToNineDecimal(pctShare);
				computePercentageAmounts(0);
			}
		} else {
			$("inputPctShare").focus();
			$("inputPctShare").value = "";
			showMessageBox("Entered Co-Insurer Share % is invalid. Valid value is from 0.00 to 100.00", imgMessage.ERROR);
		}
	});

	$("inputTsiAmt").observe("change", function() {
		var tsi = $F("inputTsiAmt");
		if((tsi.split(".").size > 2)) {
			if(isNaN(unformatCurrencyValue(tsi))) {
				clearFocusElementOnError("inputTsiAmt", "Invalid TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.");
			}
		} else if((parseFloat(tsi) < 0.01) || (unformatCurrencyValue(tsi) > 99999999999999.99)) {
			clearFocusElementOnError("inputTsiAmt", "Invalid TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.");
		} else if (computePctShare() > 100) {
			clearFocusElementOnError("inputTsiAmt", "Total co-insurer share percent should not exceed 100%.");
		} else if (parseFloat(tsi) > parseFloat($("totalTsiAmt").readAttribute("lastValidValue"))) {
			clearFocusElementOnError("inputTsiAmt", "Total co-insurer tsi amount must not exceed " + formatCurrency($F("totalTsiAmt")));
		} else {
			$("inputTsiAmt").value = formatCurrency(tsi);
			computePercentageAmounts(1);
		}
	});

	$("inputPremAmt").observe("change", function() {
		var prem = $F("inputPremAmt");
		if(isNaN(prem) || (prem.split(".").size > 2)) {
			clearFocusElementOnError("inputPremAmt", "Invalid Premium amount. Value should be from 0.01 to 9,999,999,999.99.");
		} else if((parseFloat(prem) < 0.01) || (unformatCurrencyValue(prem) > 99999999999999.99)) {
			clearFocusElementOnError("inputPremAmt", "Invalid Premium amount. Value should be from 0.01 to 9,999,999,999.99.");
		} else if (computePctShare() > 100) {
			clearFocusElementOnError("inputPremAmt", "Total co-insurer share percent should not exceed 100%.");
		} else if (parseFloat(prem) > parseFloat($("totalPremAmt").readAttribute("lastValidValue"))) {
			clearFocusElementOnError("inputPremAmt", "Total co-insurer premium amount must not exceed " + formatCurrency($F("totalPremAmt")));
		} else{
			$("inputPremAmt").value = formatCurrency(prem);
			computePercentageAmounts(2);
		}
	});

	function computePctShare() {
		//var inputPctShare = $F("inputPctShare") == "" ? parseFloat("0") : parseFloat($F("inputPctShare"));	//added by shan 10.22.2013
		return (parseFloat($F("inputPctShare"))) /*  inputPctShare */ + parseFloat($F("pctShareTotals")) - clickedAmtVal;
	}

	$("searchCoInsurer").observe("click", function() {
		var notIn = "";
		var withPrevious = false;
		$$("div#coInsurerListingDiv div[name='coRiRow']").each(function(row) {
			if(withPrevious) {
				notIn += ","+row.down("input", 0).value;
			} else {
				notIn += row.down("input", 0).value;
			}
			withPrevious = true;
		});
		if(editAllowed && $F("btnAddInsurer") == "Add")	{
			showReinsurerLOV($F("inputCoInsurer"), "GIPIS153", notIn);
		}
	});
	
	$("btnClearCoRi").observe("click", function() {
		setCoRiFields(null);
		$$("div[name='coRiRow']").each(function(row) {
			row.remove();
		});
		checkTableIfEmpty("coRiRow", "coInsurersTableDiv");
		defaultGenerated = false;
		$("totalTsiAmt").value = "";
		$("totalPremAmt").value = "";
		for(var i=0; i<addedCoRi.length; i++) {
			addToDeletedCoRiObj(addedCoRi[i]);
			addedCoRi.splice(i, 1);
		}
		for(var i=0; i<objCoInsurers.length; i++) {
			addToDeletedCoRiObj(objCoInsurers[i]);
			objCoInsurers.splice(i, 1);
		}
		disableButton("btnClearCoRi");
		changeTag = 1; //marco - 05.23.2013
	});

	$$("div#coInsurerListingDiv div[name='coRiRow']").each(function(row) {
		row.observe("click", function() {
			clickCoRiRow(row);
		});
	});

	$("totalPremAmt").observe("focus", function() {
		totalPremPrevious = $F("totalPremAmt");
	});

	$("totalTsiAmt").observe("focus", function() {
		totalTsiPrevious = $F("totalTsiAmt");
	});

	initializeAccordion();
	observeReloadForm("reloadForm", showCoInsurerPage);
	observeCancelForm("btnCancel", function(){saveCoInsurer(false);}, showParListing);
	observeSaveForm("btnSave", function() {saveCoInsurer(true);});

	setCursor("default");
	changeTag = 0;
	initializeChangeTagBehavior(saveCoInsurer);
	initializeChangeAttribute();
</script>