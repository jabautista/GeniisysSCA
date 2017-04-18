<!--Remarks: For deletion
	Date : 06-06-2012
	Developer: Steven P. Ramirez
	Replacement : /pages/accounting/officialReceipt/otherTrans/withholdingTaxTableGrid.jsp
 -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" id="taxesWheldDiv" name="taxesWheldDiv">
	<!-- page variables -->
	<input type="hidden" id="txtDrvPayeeCd"			name="txtDrvPayeeCd"			value=""/>
	<input type="hidden" id="txtPayeeFirstName"		name="txtPayeeFirstName"		value=""/>
	<input type="hidden" id="txtPayeeMiddleName"	name="txtPayeeMiddleName"		value=""/>
	<input type="hidden" id="txtPayeeLastName"		name="txtPayeeLastName"			value=""/>
	<input type="hidden" id="txtWhtaxDesc"			name="txtWhtaxDesc"				value=""/>
	<input type="hidden" id="txtGwtxWhtaxId"		name="txtGwtxWhtaxId"			value=""/>
	<input type="hidden" id="txtSlCd"				name="txtSlCd"					value=""/>
	<input type="hidden" id="txtSlTypeCd"			name="txtSlTypeCd"				value=""/>
	<input type="hidden" id="txtOrPrintTag"			name="txtOrPrintTag"			value=""/>
	<input type="hidden" id="txtGenType"			name="txtGenType"				value="P"/>
	
	<jsp:include page="subPages/taxesWheldListingTable.jsp"></jsp:include>
	
	<table align="center" style="margin: 10px">
		<tr>
			<td class="rightAligned" style="width: 160px">Item No</td>
			<td class="leftAligned"	 style="width: 240px;"><input type="text" id="txtItemNo" name="txtItemNo" maxlength="30" class="required" style="width: 117px" tabindex=12></td>
			<td class="rightAligned" style="width: 140px">Rate</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtPercentRate" name="txtPercentRate" maxlength="30" readonly="readonly" class="required" style="width: 200px" tabindex=12></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px">Payee Class</td>
			<td class="leftAligned"	 style="width: 240px;">
				<select id="txtPayeeClassCd" name="txtPayeeClassCd" class="required" style="width: 230px" tabindex=1>
					<option value=""></option>
					<c:forEach var="payeeClass" items="${payeeClassCdListing }" varStatus="ctr">
						<option value="${payeeClass.payeeClassCd }" description="${payeeClass.classDesc }">${payeeClass.payeeClassCd } - ${payeeClass.classDesc }</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width: 140px">SL Name</td>
			<td class="leftAligned"  style="width: 260px">
				<div id="divSl" class="required" style="border: 1px solid gray; width: 206px; height: 21px; float: left; margin-right: 7px">
					<input type="text" id="txtSlName" name="txtSlName" maxlength="30" class="required" readonly="readonly" style="width: 170px; border: none; float: left;" tabindex=12></input>
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmSlCd" name="oscmSlCd" alt="Go" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px">Payee No</td>
			<td class="leftAligned"	 style="width: 240px;">
				<select id="txtPayeeCd" name="txtPayeeCd" class="required" style="width: 230px;" tabindex=1>
					<option value=""></option>
				</select>
			</td>
			<td class="rightAligned" style="width: 140px">Income Amount</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtIncomeAmt" name="txtIncomeAmt" maxlength="30" class="required" style="width: 200px" tabindex=12></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px">Tax Description</td>
			<td class="leftAligned"	 style="width: 240px;">
				<select id="txtWhtaxCode" name="txtWhtaxCode" class="required" style="width: 230px" tabindex=1>
					<option value=""></option>
					<c:forEach var="wholdingTax" items="${whtaxCodeListing }" varStatus="ctr">
						<option value="${wholdingTax.whtaxCode }"
								whtaxDesc="${wholdingTax.whtaxDesc }"
								birTaxCd="${wholdingTax.birTaxCd }"
								percentRate="${wholdingTax.percentRate }">
							${wholdingTax.whtaxCode } - ${wholdingTax.whtaxDesc }
						</option>
					</c:forEach>
				</select>
			</td>
			<td class="rightAligned" style="width: 140px">Withholding Tax Amount</td>
			<td class="leftAligned"  style="width: 260px"><input type="text" id="txtWholdingTaxAmt" name="txtWholdingTaxAmt" maxlength="30" readonly="readonly" class="required" style="width: 200px" tabindex=12></input></td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 160px">BIR Tax Code</td>
			<td class="leftAligned"	 style="width: 240px;">
				<!-- 
				<select id="txtBirTaxCd" name="txtBirTaxCd" style="width: 230px" tabindex=1>
				</select>
				 -->
				 <input type="text" id="txtBirTaxCd" name="txtBirTaxCd" maxlength="30" readonly="readonly" style="width: 223px" tabindex=12></input>
			</td>
			<td class="rightAligned" style="width: 140px">Remarks</td>
			<td class="leftAligned"  style="width: 260px">
				<div style="border: 1px solid gray; width: 206px; height: 21px; float: left;">
					<input style="width: 180px; float: left; border: none;" id="txtRemarks" name="txtRemarks" type="text" value="" maxlength="4000" tabindex=18/>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarksPremDep" />
				</div>
				<!--  
				<input type="text" id="txtRemarks" name="txtRemarks" maxlength="30" readonly="readonly" style="width: 200px" tabindex=12></input>-->
			</td>
		</tr>
		<tr>
			<td style="width: 300px;" align="center" colspan="4">
				<input type="button" class="button" 		style="width: 80px;font-size: 12px;text-align: center" id="btnSaveRecord" 	name="btnSaveRecord" 	value="Add" 	tabindex=18></input>
				<input type="button" class="disabledButton" style="width: 80px;font-size: 12px;text-align: center" id="btnDeleteRecord" name="btnDeleteRecord"  value="Delete"  tabindex=19 disabled="disabled" ></input>
			</td>
		</tr>
	</table>
</div>
<div class="buttonsDiv" style="float:left;">			
	<input type="button" style="width: 70px; font-size: 12px;" id="btnSaveTaxesWheld" 	name="btnSaveTaxesWheld"	class="button" value="Save"   tabindex=20/>
	<input type="button" style="width: 70px; font-size: 12px;" id="btnCancel" 			name="btnCancel"			class="button" value="Cancel" tabindex=21/>
</div>
<script type="text/javascript">
	/** local variables **/
	setModuleId("GIACS022");
	setDocumentTitle("WithHolding Tax");
	var lastNo = 0; 						// last row no
	var currentRowNo = -1; 					// row no of current record selected. f-1 when no rows are selected
	var allowUpdateWholdingTax = ('${allowUpdateWholdingTax}').blank() ? "Y" : ('${allowUpdateWholdingTax}'); // the tag to indicate if Wholding Tax field is updateable
	var lastIncomeAmt = "";					// variable to store last value of income amt
	var lastItemNo = "";					// variable to store last value of item no

	var varWholdingTaxAmt 	= "";				// variables.wholding_tax_amt
	var varWholding 		= "";				// variables.wholding
	var varModuleName		= "GIACS022";		// variables.module_name
	
	/** objects and lists */
	var taxesWheldList = eval('${giacTaxesWheldList}');
	
	if (objAC.tranFlagState != 'O'){
		showMessageBox("Form running in query-only mode. Cannot change database fields.");
		disableButton("btnDirectClaimSave");
		disableButton("btnAddDCP");
		disableButton("btnDelDCP");
		$("selTransactionType").disable();
		disableSearch("searchAdvice2");
		disableSearch("searchPayee");
		$$("div#taxesWheldDiv input[type='text']").each(function(row) {
			row.readonly = true;
		});
	}

	/** initialization */
	if (taxesWheldList.length > 0) {
		for (var i = 0; i < taxesWheldList.length; i++) {
			var content = generateContent(taxesWheldList[i], i);
			taxesWheldList[i].recordStatus = null;
			//generateInitialItemValue(taxesWheldList[i]);
			addTableRow("row"+i, "rowTaxesWheld", "taxesWheldTableContainer", content, clickTaxesWheldRow);
			lastNo = lastNo + 1;
			$("lblSumIncomeAmt").innerHTML = formatCurrency(parseFloat($("lblSumIncomeAmt").innerHTML.replace(/,/g,"")) + parseFloat(taxesWheldList[i].incomeAmt == null ? 0 : taxesWheldList[i].incomeAmt));
			$("lblSumWholdingTaxAmt").innerHTML = formatCurrency(parseFloat($("lblSumWholdingTaxAmt").innerHTML.replace(/,/g,"")) + parseFloat(taxesWheldList[i].wholdingTaxAmt == null ? 0 : taxesWheldList[i].wholdingTaxAmt));
		}
		checkIfToResizeTable2("taxesWheldTableContainer", "rowTaxesWheld");
	} else {
		checkTableIfEmpty("rowTaxesWheld", "taxesWheldTableMainDiv");
	}

	$("txtItemNo").value = generateItemNo();
	lastItemNo = $F("txtItemNo");

	/** field events **/
	$("editTxtRemarksPremDep").observe("click", function() {
		if (currentRowNo == -1) {
			showEditor("txtRemarks", 4000);
		} else {
			showMessageBox("You cannot update this record.", imgMessage.INFO);
		}
	});

	$("txtItemNo").observe("change", function() {
		if ($F("txtItemNo").blank()) {
			showWaitingMessageBox("Field must be entered", imgMessage.INFO,
					function() {
						$("txtItemNo").value = lastItemNo;
						$("txtItemNo").focus();
					});
		} else if (isNaN($F("txtItemNo"))) {
			showWaitingMessageBox("Field must be of form 09", imgMessage.INFO,
					function() {
						$("txtItemNo").value = lastItemNo;
						$("txtItemNo").focus();
					});
		} else {
			lastItemNo = $F("txtItemNo");
		}
	});
	
	$("txtPayeeClassCd").observe("change", function() {
		populatePayeeCdListing($F("txtPayeeClassCd"));
	});

	$("txtWhtaxCode").observe("change", function() {
		$("txtSlCd").value 		= "";
		$("txtSlName").value 	= "";
		$("txtSlTypeCd").value 	= "";
		
		var selectedOpt = $("txtWhtaxCode").options[$("txtWhtaxCode").selectedIndex];
		$("txtWhtaxDesc").value = selectedOpt.readAttribute("whtaxDesc");
		//populateListingWithSingleValue("txtBirTaxCd", selectedOpt.readAttribute("birTaxCd"));
		$("txtBirTaxCd").value = selectedOpt.readAttribute("birTaxCd");
		$("txtPercentRate").value = selectedOpt.readAttribute("percentRate") == null ? "" : formatCurrency(parseFloat(selectedOpt.readAttribute("percentRate")));

		if ($F("txtWhtaxCode").blank() && $F("txtBirTaxCd").blank() && $F("txtPercentRate").blank() && $F("txtWhtaxDesc").blank()) {
			$("txtGwtxWhtaxId").value = "";
		}

		validateWhtax();

		validatePercentRate();
	});

	$("txtPercentRate").observe("change", function() {
		validatePercentRate();
	});

	$("oscmSlCd").observe("click", function() {
		if (currentRowNo == -1) {
			if (!$F("txtGwtxWhtaxId").blank()) {
				Modalbox.show(contextPath+"/GIACSlListsController?action=showSlListsDetails", 
						  {title: "SL Listing", 
						  width: 600,
						  asynchronous: false});
			} else {
				//showMessageBox("List of values contains no entries.", imgMessage.INFO);
			}
		} else {
			showMessageBox("You cannot update this record.", imgMessage.INFO);
		}
	});

	$("txtIncomeAmt").observe("change", function() {
		if ($F("txtIncomeAmt").blank()) {
			showWaitingMessageBox("Field must be entered", imgMessage.INFO,
					function() {
						$("txtIncomeAmt").value = lastIncomeAmt;
						$("txtIncomeAmt").focus();
					});
		} else if (isNaN($F("txtIncomeAmt").replace(/,/g,""))) {
			showWaitingMessageBox("Field must be of form 9,999,999,990.00", imgMessage.INFO,
					function() {
						$("txtIncomeAmt").value = lastIncomeAmt;
						$("txtIncomeAmt").focus();
					});
		} else if (parseFloat(nvl($F("txtIncomeAmt"), "0").replace(/,/g,"")) == parseFloat(nvl(lastIncomeAmt, "0").replace(/,/g,""))) {
			$("txtIncomeAmt").value = formatCurrency(parseFloat(nvl($F("txtIncomeAmt"),0)));
		} else {
			var amount = 0;
	
			amount = (parseFloat(nvl($F("txtPercentRate"), 0)) / 100) * parseFloat(nvl($F("txtIncomeAmt"), 0));
	
			if (parseFloat(nvl(amount, 0)) != (parseFloat(nvl(varWholdingTaxAmt,0))) && !$F("txtWholdingTaxAmt").blank()) {
				showConfirmBox("Overwrite", "Amount already exists. Do you want to overwrite it ?", "Yes", "No",
						function() {
							$("txtWholdingTaxAmt").value = formatCurrency(parseFloat(nvl(amount, 0)));
							validateIncomeAmt(amount);
						},
						function() {
							$("txtIncomeAmt").value = lastIncomeAmt;
							validateIncomeAmt();
						});
			} else {
				validateIncomeAmt(amount);
			}
		}
	});

	$("txtWholdingTaxAmt").observe("change", function() {
		validateWholdingTaxAmt();
		varWholdingTaxAmt = $F("txtWholdingTaxAmt");
	});

	$("btnSaveRecord").observe("click", function() {
		//if (checkRequiredFields()) {checkAllRequiredFields
		if (checkAllRequiredFields()) {
			saveRecord();
		}
	});

	$("btnSaveTaxesWheld").observe("click", function() {
		if (hasUnsavedChanges()) {
			showMessageBox("Please save changes first.", imgMessage.INFO);
		} else {
			saveTaxesWheld();
		}
	});

	$("btnDeleteRecord").observe("click", function() {
		if (currentRowNo < 0) {
			return false;
		}

		// key-delrec
		if (taxesWheldList[currentRowNo].orPrintTag == "Y") {
			showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
			return false;
		} else if (taxesWheldList[currentRowNo].genType != "P") {
			showMessageBox("Delete not allowed. This record was generated by another module.", imgMessage.ERROR);
			return false;
		} else {
			if (taxesWheldList[currentRowNo].recordStatus == 0) {
					taxesWheldList[currentRowNo].recordStatus = -2;
				} else {
					taxesWheldList[currentRowNo].recordStatus = -1;
				}
		
			// delete the record from the main container div
			var row = $("row"+currentRowNo);
			Effect.Fade(row, {
				duration: .2,
				afterFinish: function() {
					$("lblSumIncomeAmt").innerHTML = formatCurrency(parseFloat($("lblSumIncomeAmt").innerHTML.replace(/,/g,"")) - parseFloat(taxesWheldList[currentRowNo].incomeAmt == null ? 0 : taxesWheldList[currentRowNo].incomeAmt));
					$("lblSumWholdingTaxAmt").innerHTML = formatCurrency(parseFloat($("lblSumWholdingTaxAmt").innerHTML.replace(/,/g,"")) - parseFloat(taxesWheldList[currentRowNo].wholdingTaxAmt == null ? 0 : taxesWheldList[currentRowNo].wholdingTaxAmt));
					row.remove();
					checkIfToResizeTable2("taxesWheldTableContainer", "rowTaxesWheld");
					checkTableIfEmpty("rowTaxesWheld", "taxesWheldTableMainDiv");
					resetFields();
				}
			});
		}
	});

	/** page functions */
	// generate the item no for new record, default value is max item no + 1
	function generateItemNo() {
		var itemNo = 0;
		
		for (var i = 0; i < taxesWheldList.length; i++) {
			if (taxesWheldList[i].itemNo > itemNo && taxesWheldList[i].recordStatus != -1) {
				itemNo = parseInt(taxesWheldList[i].itemNo);
			}
		}

		return itemNo + 1;
	}
	
	// Generates content for the div of a new Overriding Comm Payts table row to be added
	function generateContent(taxesWheld, rowNum) {
		var content = "";

		var itemNo = taxesWheld.itemNo;
		var payeeClass = "---"; //taxesWheld.payeeClassCd;
		var payee = taxesWheld.drvPayeeCd.truncate(15, "...");
		var taxDescription = taxesWheld.whtaxDesc.truncate(13, "...");
		var birTaxCode = taxesWheld.birTaxCd.truncate(11, "...");
		var rate = parseFloat(taxesWheld.percentRate).toFixed(6) + "%";
		var slName = taxesWheld.slName == null ? "---" : (taxesWheld.slName.blank() ? "---" : taxesWheld.slName.truncate(17, "..."));
		var incomeAmt = formatCurrency(parseFloat((taxesWheld.incomeAmt == null ? "0" : taxesWheld.incomeAmt)));
		var wholdingTaxAmt = formatCurrency(parseFloat((taxesWheld.wholdingTaxAmt == null ? "0" : taxesWheld.wholdingTaxAmt)));
		
		for (var i = 0; i < $("txtPayeeClassCd").options.length; i++) {
			var selectedOpt = $("txtPayeeClassCd").options[i];

			if (parseInt(nvl(selectedOpt.value, "0")) == taxesWheld.payeeClassCd) {
				payeeClass = selectedOpt.readAttribute("description").truncate(11, "...");
				break;
			}
		}

		content = 
			'<label style="width:  60px;font-size: 10px; text-align: center;">'+itemNo+'</label>' + 
			'<label style="width:  70px;font-size: 10px; text-align: center;">'+payeeClass+'</label>' + 
			'<label style="width: 120px;font-size: 10px; text-align: center;">'+payee+'</label>' + 
			'<label style="width: 110px;font-size: 10px; text-align: center;">'+taxDescription+'</label>' + 
			'<label style="width:  80px;font-size: 10px; text-align: center;">'+birTaxCode+'</label>' + 
			'<label style="width:  90px;font-size: 10px; text-align: right;">'+rate+'</label>' + 
			'<label style="width: 130px;font-size: 10px; text-align: center;">'+slName+'</label>' + 
			'<label style="width: 110px;font-size: 10px; text-align: right;">'+incomeAmt+'</label>' + 
			'<label style="width: 115px;font-size: 10px; text-align: right; margin-left: 5px;">'+wholdingTaxAmt+'</label>' +
			'<input type="hidden"	id="count"		name="count"	value="'+rowNum+'" />';

		return content;
	}
	
	function clickTaxesWheldRow(row) {
		$$("div#taxesWheldTable div[name='rowTaxesWheld']").each(function(r) {
			if (row.id != r.id) {
				r.removeClassName("selectedRow");
			}
		});

		row.toggleClassName("selectedRow");

		currentRowNo = row.down("input", 0).value;

		if (row.hasClassName("selectedRow")) {
			populateDetails(taxesWheldList[currentRowNo]);

			// disable text fields
			$("txtItemNo").readOnly = true;
			$("txtPayeeClassCd").disable();
			$("txtPayeeCd").disable();
			$("txtWhtaxCode").disable();
			$("txtIncomeAmt").readOnly = true;
			$("txtRemarks").readOnly = true;

			// change button properties
			disableButton("btnSaveRecord");
			enableButton("btnDeleteRecord");
		} else {
			resetFields();
		}
	}

	// Populates input fields of Facul Claim Payts details
	// @param - the Withholding Tax record to be displayed
	function populateDetails(taxesWheld) {
		if (taxesWheld == null) {
			showMessageBox("An error has occured while displaying the record.", imgMessage.ERROR);
		}
		
		// main details
		$("txtItemNo").value = taxesWheld.itemNo;
		$("txtPayeeClassCd").value = taxesWheld.payeeClassCd;
		//populateListingWithSingleValue("txtPayeeCd", taxesWheld.payeeCd);
		$("txtWhtaxCode").value = taxesWheld.whtaxCode;
		$("txtBirTaxCd").value = taxesWheld.birTaxCd;
		$("txtPercentRate").value = taxesWheld.percentRate;
		$("txtSlName").value = (taxesWheld.slName == null) ? "" : unescapeHTML2(taxesWheld.slName);
		$("txtIncomeAmt").value = formatCurrency(taxesWheld.incomeAmt);
		$("txtWholdingTaxAmt").value = formatCurrency(taxesWheld.wholdingTaxAmt);
		$("txtRemarks").value = (taxesWheld.remarks == null) ? "" : unescapeHTML2(taxesWheld.remarks);
		$("txtSlTypeCd").value = taxesWheld.slTypeCd;
		$("txtOrPrintTag").value = taxesWheld.orPrintTag;

		// other fields
		$("txtDrvPayeeCd").value = taxesWheld.drvPayeeCd;
		$("txtPayeeFirstName").value = (taxesWheld.payeeFirstName == null) ? "" : unescapeHTML2(taxesWheld.payeeFirstName);
		$("txtPayeeMiddleName").value = (taxesWheld.payeeMiddleName == null) ? "" : unescapeHTML2(taxesWheld.payeeMiddleName);
		$("txtPayeeLastName").value = (taxesWheld.payeeLastName == null) ? "" : unescapeHTML2(taxesWheld.payeeLastName);
		$("txtWhtaxDesc").value = (taxesWheld.whtaxDesc == null) ? "" : unescapeHTML2(taxesWheld.whtaxDesc);
		$("txtGwtxWhtaxId").value = taxesWheld.gwtxWhtaxId;
		$("txtSlCd").value = taxesWheld.slCd;
		$("txtGenType").value = taxesWheld.genType;

		if ($F("txtPayeeFirstName").blank()) {
			populateListingWithSingleValue("txtPayeeCd", taxesWheld.payeeCd + " - " + $F("txtPayeeLastName"));
		} else {
			populateListingWithSingleValue("txtPayeeCd", taxesWheld.payeeCd + " - " + $F("txtPayeeFirstName") + " " + $F("txtPayeeMiddleName") + " " + $F("txtPayeeLastName"));
		}

		varWholdingTaxAmt = $F("txtWholdingTaxAmt");
		varWholding = "";
		lastIncomeAmt = $F("txtIncomeAmt");
		lastItemNo = $F("txtItemNo");

		$("txtSlName").removeClassName("required");
		$("divSl").style.backgroundColor = "";
	}

	// reset fields
	function resetFields() {
		currentRowNo = -1;

		var itemFields = ["PayeeClassCd", "PayeeCd", "WhtaxCode", 
		                  "BirTaxCd", "PercentRate", "SlName", "IncomeAmt", 
		                  "WholdingTaxAmt", "Remarks", "DrvPayeeCd", "PayeeFirstName", 
		                  "PayeeMiddleName", "PayeeLastName", "GwtxWhtaxId", "SlCd", "SlTypeCd",
		                  "WhtaxDesc", "OrPrintTag"];

		for (var i = 0; i < itemFields.length; i++) {
			$("txt"+itemFields[i]).value = "";
		}

		// generate item no
		$("txtItemNo").value = generateItemNo();

		// set Gen Type to default value
		$("txtGenType").value = "P";

		// other fields
		varWholdingTaxAmt = "";
		varWholding = "";
		lastIncomeAmt = "";
		lastItemNo = $F("txtItemNo");

		// clear listing
		clearDropDownList("txtPayeeCd");

		// enable text fields
		$("txtItemNo").readOnly = false;
		$("txtPayeeClassCd").enable();
		$("txtPayeeCd").enable();
		$("txtWhtaxCode").enable();
		$("txtIncomeAmt").readOnly = false;
		$("txtRemarks").readOnly = false;

		// remove required class
		$("txtSlName").removeClassName("required");

		// change button properties
		enableButton("btnSaveRecord");
		disableButton("btnDeleteRecord");

		$("txtSlName").removeClassName("required");
		$("divSl").style.backgroundColor = "";
	}

	// check if required fields have values
	function checkRequiredFields() {
		var ok = true;
		var item = "";

		$$("[class='required']").each(function(field) {
			if (field.value == "") {
				if (field.id == "txtItemNo") {
					item = "Item No";
				} else if (field.id == "txtPayeeClassCd") {
					item = "Payee Class";
				} else if (field.id == "txtPayeeCd") {
					item = "Payee No";
				} else if (field.id == "txtWhtaxCode") {
					item = "Tax Description";
				} else if (field.id == "txtPercentRate") {
					item = "Rate";
				} else if (field.id == "txtSlName") {
					item = "SL Name";
				} else if (field.id == "txtIncomeAmt") {
					item = "Income Amount";
				} else if (field.id == "txtWholdingTaxAmt") {
					item = "Withholding  Tax Amount";
				}

				ok = false;
			}
		});

		if (!ok) {
			showMessageBox("User supplied value is required for " + item + ".", imgMessage.ERROR);
		}

		return ok;
	}

	// clears an LOV listing
	/*function clearDropDownList(listName) {
		$(listName).innerHTML = "";

		var newOption = new Element("option");
		newOption.text = "";
		newOption.value = "";

		try {
		    $(listName).add(newOption, null); // standards compliant; doesn't work in IE
		  }
		catch(ex) {
		    $(listName).add(newOption); // IE only
		}
	}*/

	// testing function to clear options fast
	function clearDropDownList(listName)
	{
		var selectObj = document.getElementById(listName);
		var selectParentNode = selectObj.parentNode;
		var newSelectObj = selectObj.cloneNode(false); // Make a shallow copy
		selectParentNode.replaceChild(newSelectObj, selectObj);

		var newOption = new Element("option");
		newOption.text = "";
		newOption.value = "";

		try {
		    $(listName).add(newOption, null); // standards compliant; doesn't work in IE
		  }
		catch(ex) {
		    $(listName).add(newOption); // IE only
		}
		
		//return newSelectObj;
	}	

	// populates payee cd listing depending on the specified payee class cd
	function populatePayeeCdListing(payeeClassCd) {
		if (!payeeClassCd.blank()) {
			new Ajax.Request(contextPath+"/GIACTaxesWheldController?action=getPayeeCdListingByClassCd", {
				evalScripts: true,
				asynchronous: true,
				method: "GET",
				parameters: {
					payeeClassCd: payeeClassCd
				},
				onCreate: function() {
					$("txtPayeeClassCd").disable();
					$("txtPayeeCd").disable();
					populateListingWithSingleValue("txtPayeeCd", "Refreshing...");
				},
				onComplete: function(response) {
					clearDropDownList("txtPayeeCd");
					$("txtPayeeClassCd").enable();
					$("txtPayeeCd").enable();
					if (checkErrorOnResponse(response)) {
						var payeeListing = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
	
						for (var i = 0; i < payeeListing.length; i++) {
							var newOption = new Element("option");
							var drvPayeeCd = "";
							newOption.width = $("txtPayeeCd").width;
							newOption.value = payeeListing[i].payeeNo;
							var payeeFirstName  = (payeeListing[i].payeeFirstName  == null) ? null : changeSingleAndDoubleQuotes(payeeListing[i].payeeFirstName);
							var payeeMiddleName = (payeeListing[i].payeeMiddleName == null) ? null : changeSingleAndDoubleQuotes(payeeListing[i].payeeMiddleName);
							var payeeLastName   = (payeeListing[i].payeeLastName   == null) ? null : changeSingleAndDoubleQuotes(payeeListing[i].payeeLastName);

							// the following attributes are used for validation
							drvPayeeCd = (payeeFirstName == null ? "" : payeeFirstName + " " ) +
										 (payeeMiddleName == null ? "" : payeeMiddleName + " " ) +
										  payeeLastName;
							
							newOption.setAttribute("payeeFirstName",  payeeFirstName);
							newOption.setAttribute("payeeMiddleName", payeeMiddleName);
							newOption.setAttribute("payeeLastName",   payeeLastName);
							newOption.setAttribute("payeeCd", drvPayeeCd);

							if (payeeFirstName == null) {
								newOption.text = payeeListing[i].payeeNo + " - " + payeeLastName;
							} else {
								newOption.text = payeeListing[i].payeeNo + " - " + payeeFirstName + " " + (payeeMiddleName == null ? "" : payeeMiddleName) + " " + payeeLastName;
							}

							//newOption.text = newOption.text.truncate(100, "...");
		
							try {
							    $("txtPayeeCd").add(newOption, null); // standards compliant; doesn't work in IE
							  }
							catch(ex) {
							    $("txtPayeeCd").add(newOption); // IE only
							}
						}

						$("txtPayeeCd").focus();

						// validation
						$("txtPayeeCd").observe("change", function() {
							var selectedOpt = $("txtPayeeCd").options[$("txtPayeeCd").selectedIndex];
							$("txtDrvPayeeCd").value = selectedOpt.readAttribute("payeeCd");
							$("txtPayeeFirstName").value = selectedOpt.readAttribute("payeeFirstName");
							$("txtPayeeMiddleName").value = selectedOpt.readAttribute("payeeMiddleName");
							$("txtPayeeLastName").value = selectedOpt.readAttribute("payeeLastName");
						});
					}
				}
			});
		} else {
			clearDropDownList("txtPayeeCd");
		}
	}

	// checks if changes have been made
	function hasChanges() {
		var result = false;
		for (var i = 0; i < taxesWheldList.length; i++) {
			if (taxesWheldList[i].recordStatus == 0 || taxesWheldList[i].recordStatus == 1 || taxesWheldList[i].recordStatus == -1) {
				result = true;
				break;
			}
		}

		return result;
	}

	// checks if there is currently an unsaved change on addition of record
	function hasUnsavedChanges() {
		var result = false;
		
		var itemFields = ["PayeeClassCd", "PayeeCd", "WhtaxCode", 
		                  "BirTaxCd", "PercentRate", "SlName", "IncomeAmt", 
		                  "WholdingTaxAmt", "Remarks"];

		for (var i = 0; i < itemFields.length; i++) {
			if (!$F("txt"+itemFields[i]).blank()) {
				result = true;
				break;
			}
		}

		return result;
	}

	// Add new withholding taxes record
	function saveRecord() {
		var content = "";
		var ok = true;
		var rowNum =lastNo;
		var taxesWheld = new Object();
		var recordExist = false;
		var exist = false;

		taxesWheld.gaccTranId = objACGlobal.gaccTranId;
		taxesWheld.itemNo = parseInt($F("txtItemNo"));
		taxesWheld.payeeClassCd = $F("txtPayeeClassCd");
		taxesWheld.payeeCd = parseInt($F("txtPayeeCd"));
		taxesWheld.whtaxCode = $F("txtWhtaxCode");
		taxesWheld.birTaxCd = $F("txtBirTaxCd");
		taxesWheld.percentRate = $F("txtPercentRate").blank() ? null : parseFloat($F("txtPercentRate"));
		taxesWheld.slName = changeSingleAndDoubleQuotes2($F("txtSlName"));
		taxesWheld.incomeAmt = $F("txtIncomeAmt").blank() ? null : parseFloat($F("txtIncomeAmt").replace(/,/g,""));;
		taxesWheld.wholdingTaxAmt = $F("txtWholdingTaxAmt").blank() ? null : parseFloat($F("txtWholdingTaxAmt").replace(/,/g,""));;
		taxesWheld.remarks = changeSingleAndDoubleQuotes2($F("txtRemarks"));
		taxesWheld.drvPayeeCd = $F("txtDrvPayeeCd");
		taxesWheld.payeeFirstName = changeSingleAndDoubleQuotes2($F("txtPayeeFirstName"));
		taxesWheld.payeeMiddleName = changeSingleAndDoubleQuotes2($F("txtPayeeMiddleName"));
		taxesWheld.payeeLastName = changeSingleAndDoubleQuotes2($F("txtPayeeLastName"));
		taxesWheld.gwtxWhtaxId = $F("txtGwtxWhtaxId");
		taxesWheld.slCd = $F("txtSlCd").blank() ? null : parseInt($F("txtSlCd"));
		taxesWheld.slTypeCd = $F("txtSlTypeCd");
		taxesWheld.whtaxDesc = changeSingleAndDoubleQuotes2($F("txtWhtaxDesc"));
		taxesWheld.orPrintTag = "N";
		taxesWheld.genType = $F("txtGenType");
		taxesWheld.recordStatus = 0;

		// check if record exists
		for (var i = 0; i < taxesWheldList.length; i++) {
			if (taxesWheldList[i].itemNo 			== taxesWheld.itemNo &&
					taxesWheldList[i].payeeClassCd	== taxesWheld.payeeClassCd &&
					taxesWheldList[i].payeeCd		== taxesWheld.payeeCd) {
				if (taxesWheldList[i].recordStatus == -1) {
					taxesWheld.recordStatus = 1;
				} else if (taxesWheldList[i].recordStatus == null) {
					// tag record as existing, then display error message
					recordExist = true;
				} else if (taxesWheldList[i].recordStatus == -2) {
					taxesWheld.recordStatus = 0;
				}
				rowNum = i;
				taxesWheldList[i] = taxesWheld;
				exist = true;
				break;
			}
		}

		if (recordExist) {
			showMessageBox("Row with the same Item No., Payee Cd and Payee Class Cd already exists.", imgMessage.INFO);
		} else {
			if (!exist) {
				taxesWheldList.push(taxesWheld);
				lastNo = lastNo + 1;
			}

			content = generateContent(taxesWheld, rowNum);
			
			addTableRow("row"+rowNum, "rowTaxesWheld", "taxesWheldTableContainer", content, clickTaxesWheldRow);
			resetFields();

			$("lblSumIncomeAmt").innerHTML = formatCurrency(parseFloat($("lblSumIncomeAmt").innerHTML.replace(/,/g,"")) + parseFloat(taxesWheld.incomeAmt == null ? 0 : taxesWheld.incomeAmt));
			$("lblSumWholdingTaxAmt").innerHTML = formatCurrency(parseFloat($("lblSumWholdingTaxAmt").innerHTML.replace(/,/g,"")) + parseFloat(taxesWheld.wholdingTaxAmt == null ? 0 : taxesWheld.wholdingTaxAmt));

			checkIfToResizeTable("taxesWheldTableContainer", "rowTaxesWheld");
			checkTableIfEmpty("rowTaxesWheld", "taxesWheldTableMainDiv");
		}
	}

	function saveTaxesWheld() {
		if (!hasChanges()) {
			showMessageBox("No changes to save.", imgMessage.INFO);
		} else {
			var addedRows = getAddedJSONObjects(taxesWheldList);
			var modifiedRows = getModifiedJSONObjects(taxesWheldList);
			var delRows = getDeletedJSONObjects(taxesWheldList);
			var setRows = addedRows.concat(modifiedRows);
			
			new Ajax.Request(contextPath+"/GIACTaxesWheldController?action=saveTaxesWheld", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					gaccTranId : objACGlobal.gaccTranId,
					gaccBranchCd: objACGlobal.branchCd,
					gaccFundCd: objACGlobal.fundCd,
					tranSource: objACGlobal.tranSource,
					orFlag: objACGlobal.orFlag,
					varModuleName: varModuleName,
					setRows: prepareJsonAsParameter(setRows),
					delRows: prepareJsonAsParameter(delRows)
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();

						if (nvl(result.message, "SUCCESS") == "SUCCESS") {
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);

							for (var i = 0; i < taxesWheldList.length; i++) {
								if (taxesWheldList[i].recordStatus == 0 || taxesWheldList[i].recordStatus == 1) {
									taxesWheldList[i].recordStatus = null;
								} else if (taxesWheldList[i].recordStatus == -1) {
									taxesWheldList[i].recordStatus = -2;
								}
							}
						} else {
							showMessageBox(result.message, imgMessage.INFO);
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	}

	// module validations/procs
	function validatePercentRate() {
		if ($F("txtWhtaxCode").blank() && $F("txtBirTaxCd").blank() && $F("txtPercentRate").blank() && $F("txtWhtaxDesc").blank()) {
			$("txtGwtxWhtaxId").value = "";
		}

		validateWhtax();
	}

	function validateWhtax() {
		new Ajax.Request(contextPath+"/GIACTaxesWheldController?action=validateWhtaxCode", {
			evalScripts: true,
			asynchronous: true,
			method: "GET",
			parameters: {
				whtaxCode: $F("txtWhtaxCode"),
				birTaxCd: $F("txtBirTaxCd"),
				percentRate: $F("txtPercentRate").replace(/,/g,""),
				whtaxDesc: $F("txtWhtaxDesc")
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (result.message != "SUCCESS") {
						showMessageBox(result.message, imgMessage.WARNING);
					}

					$("txtGwtxWhtaxId").value = result.whtaxId;

					if (result.slRequired == "Y") {
						$("txtSlName").addClassName("required");
						$("divSl").style.backgroundColor = "cornsilk";
					} else {
						$("txtSlName").removeClassName("required");
						$("divSl").style.backgroundColor = "";
					}

					$("txtSlCd").value = "";
				}
			}
		});
	}

	function validateIncomeAmt(amount) {
		if ($F("txtWholdingTaxAmt").blank()) {
			$("txtWholdingTaxAmt").value = formatCurrency(parseFloat(nvl(amount, 0)));
		}
		varWholding = $F("txtWholdingTaxAmt");

		validateWholdingTaxAmt();

		if ($F("txtIncomeAmt").blank()) {
			$("txtWholdingTaxAmt").value = "";
			varWholdingTaxAmt = "";
			varWholding = "";
		}
		
		$("txtIncomeAmt").value = formatCurrency(parseFloat(nvl($F("txtIncomeAmt").replace(/,/g,""),0)));
		lastIncomeAmt = $F("txtIncomeAmt");
	}

	function validateWholdingTaxAmt() {
		if (allowUpdateWholdingTax == "N") {
			$("txtWholdingTaxAmt").value = varWholding.blank() ? "" : formatCurrency(parseFloat(varWholding));
			showMessageBox("Update of withholding tax amount is not allowed", imgMessage.INFO);
		}
		varWholdingTaxAmt = $F("txtWholdingTaxAmt");
	}
	
	$("btnCancel").observe("click", function() {
		fireEvent($("acExit"), "click");
	});
</script>