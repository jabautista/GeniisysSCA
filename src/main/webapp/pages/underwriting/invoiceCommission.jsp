<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="invoiceCommMainDiv" name="invoiceCommMainDiv" style="margin-top: 1px;">
	<jsp:include page="subPages/parInformation2.jsp"></jsp:include>
		
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Invoice Information</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="link" name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" id="InvoiceInfoDiv" name="InvoiceInfoDiv">
		<div style="margin: 10px;">
			<table align="center">
				<tr>
					<td class="rightAligned" width="100px">Item Group</td>
					<td class="leftAligned"  width="200px">
						<select id="txtItemGrp" name="txtItemGrp" style="width: 120px">
							<option value=""></option>
							<!-- 
							<c:forEach var="itemGrp" items="${itemGrpList }" varStatus="status">
								<option value="${itemGrp.itemGrp }">${itemGrp.itemGrp }</option>
							</c:forEach>
							 -->
						</select>
					</td>
					<td class="rightAligned" width="107px">Insured's Name</td>
					<td class="leftAligned">
						<input type="text" style="width: 250px;" id="txtInsured" name="txtInsured" readonly="readonly" value="" />
					</td>		
				</tr>
				<tr>
					<td class="rightAligned">Take Up</td>
					<td class="leftAligned">
						<select id="txtTakeupSeqNo" name="txtTakeupSeqNo" style="width: 120px">
							<option value=""></option>
						</select>
					</td>
					<td class="rightAligned">Booking Date</td>
					<td class="leftAligned">
						<input type="text" style="width: 119px;" id="txtMultiBookingYY" name="txtMultiBookingYY" readonly="readonly" value="" />
						<input type="text" style="width: 119px;" id="txtMultiBookingMM" name="txtMultiBookingMM" readonly="readonly" value="" />
					</td>	
				</tr>
			</table>
		</div>
	</div>
	
	<div id="basicInfoDiv" name="intmInfoDiv" style="display: none;">
	</div>
	
	<form id="intmInfoForm" name="intmInfoForm">
		<input type="hidden" id="txtB240NbEndtYy" name="txtB240NbEndtYy" value="${varEndtYy}"/>
		<input type="hidden" id="txtB240ParId" 	name="txtB240ParId"  value=""/>
		<input type="hidden" id="txtB240AssdNo" name="txtB240AssdNo" value=""/>
		<input type="hidden" id="txtB240LineCd" name="txtB240LineCd" value=""/>
		
		<!-- Other variables, used in underwriting.js -->
		<input type="hidden" id="isIntmOkForValidation" 	name="isIntmOkForValidation" 			value="N"/> <!-- used for checking if intm is ok for validation -->
		
		<jsp:include page="subPages/invCommission.jsp"></jsp:include>
		
		<div id="mainInvoicePerilDiv">
			<jsp:include page="subPages/commInvoicePerils.jsp"></jsp:include>
		</div>
		<div id="bancaDtlDiv" style="display: none">
			<jsp:include page="subPages/bancaDetails.jsp"></jsp:include>
		</div>
	</form>
	
	<div class="buttonsDiv" id="wcButtonsDiv">
		<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
		<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
	</div>
</div>

<script type="text/javascript">	
	/** local variables **/	
	var wcominvLastNo = 0; 						// last row no of WCOMINV
	var currentWcominvRowNo = -1; 				// row no of current WCOMINV record selected. -1 when no rows are selected
	var currentWcominvperRowNo = -1; 			// row no of current BANCA_B record selected. -1 when no rows are selected
	var currentBancaBRowNo = -1; 				// row no of current BANCA_B record selected. -1 when no rows are selected
	var selectedWcominvRow = null;				// the selected WCOMINV row, used for updating
	var selectedWcominvperRow = null;			// the selected WCOMINVPER row, used for updating
	var selectedBancaBRow = null;				// the selected BANCA_B row, used for updating
	var bancaBLastNo = 0; 						// last row no of WCOMINV
	var prevItemGrp = $F("txtItemGrp");
	var prevTakeupSeqNo = "";
	var prevSharePercentage = 0;
	var prevPerilCommissionRt = "";
	var prevPerilCommissionAmt = "";
	var prevPerilWholdingTax = 0;
	var prevSelectedB240Index = 0;
	var selectedB240Index = 0;

	var vOra2010Sw = ('${vOra2010Sw }');
	var vValidateBanca = ('${vValidateBanca }');
	var vAllowApplySlComm = ('${vAllowApplySlComm }');
	var vParType = ('${vParType }');
	var vEndtTax = ('${vEndtTax}');
	var vPolFlag = ('${vPolFlag }');
	var globalCancelTag = ('${globalCancelTag }');
	var wcominvIntmNoLov = "${vWcominvIntmLov}"; // the current LOV name of the Intm No LOV. LOV Names are: cgfk$wcominvDspIntmName5 (Unfiltered/Default), cgfk$wcominvDspIntmName (Filtered), and cgfk$wcominvDspIntmName3
	var userCommUpdateTag = '${userCommUpdateTag}';
	
	/* benjo 09.07.2016 SR-5604 */
	var reqDfltIntmPerAssd = '${reqDfltIntmPerAssd}'; 
	var allowUpdIntmPerAssd = '${allowUpdIntmPerAssd}';
	var overrideUser = '${userId}';
	var override = "N";
	/* end SR-5604 */
	
	var isPack = "${isPack}";	

	/** VARIABLES **/
	var varTaxAmt = 0;
	var varSwitchNo = "N";
	var varSwitchName = "N";
	var varOverrideWhtax = "${varOverrideWhtax}";
	var varVCommUpdateTag = "${varVCommUpdateTag}";
	var varVParamShowComm = "${varVParamShowComm}";
	var varEndtYy = "${varEndtYy}";
	var varParamReqDefIntm = "${varParamReqDefIntm}";
	var varBancRateSw = "${varBancRateSw}";
	var varSharePercentage = "";
	var varRate = 0;
	var varPerilCd;
	var varIssCd;
	var varMissingPerils = "";
	
	// moved by: Nica 11.23.2011
	var dfltIntmNo = "";
	var dfltIntmName = "";
	var dfltParentIntmNo = "";
	var dfltParentIntmName = "";

	/** Record Group **/
	var rgWtRate = new Array();
	
	/** Set default intermediary **/ //koks
	if (vValidateBanca != "Y" && eval('${wcommInvoices}').length == 0 /*&& objGIPIWPolbas.polFlag != 2*/  /**&& objUWParList.parType != "E"**/){ // Apollo Cruz 10.02.2014 - default intermediary will not be set for bancassurance record. //comment out parType by koks //benjo 09.07.2016 SR-5604 comment out polflag
		$("txtIntmNo").value = '${dfltIntmNo}';
		$("txtIntmName").value = '${dfltIntmName}'.replace(/\\/g, '\\\\');
		$("txtDspIntmName").value = '${dfltIntmNo}' + (String(nvl('${dfltIntmNo}', '')).blank() || nvl('${dfltIntmName}').blank() ? '' : ' - ') + '${dfltIntmName}'.replace(/\\/g, '\\\\');
		$("txtParentIntmNo").value = '${dfltParentIntmNo}';
		$("txtParentIntmName").value = '${dfltParentIntmName}'.replace(/\\/g, '\\\\');
		$("txtDspParentIntmName").value = '${dfltParentIntmNo}' + (nvl(String('${dfltParentIntmNo}'), '').blank() || nvl('${dfltParentIntmName}', '').blank() ? '' : ' - ') + '${dfltParentIntmName}'.replace(/\\/g, '\\\\');
	}
	
	if($F("txtIntmNo") != "")
		$("chkLovTag").value = "FILTERED";
	else
		$("chkLovTag").value = "UNFILTERED";
		
	var dfltIntms;
	
	if(objGIPIWPolbas.polFlag == 2 || objUWParList.parType == "E"){
		dfltIntms = eval('${dfltIntms}');
		$("chkLovTag").value = "FILTERED";
	}

	$("txtIntmName").value = unescapeHTML2($F("txtIntmName"));
	$("txtParentIntmName").value = unescapeHTML2($F("txtParentIntmName"));
	$("txtDspIntmName").value = unescapeHTML2($F("txtDspIntmName"));
	$("txtDspParentIntmName").value = unescapeHTML2($F("txtDspParentIntmName"));
	$("chkNbtRetOrig").value = 'N'; //belle 09202012
	
	/** Lists/Data Blocks **/
	var b240 = eval('${b240}');//;JSON.parse('${b240}'.replace(/\\/g, '\\\\'));
	var packParlistParams = [];
	var winvoices = eval('${winvoices }');
	var wcominv = eval('${wcommInvoices }');
	var wcominvper = eval('${wcommInvoicePerils }');
	var bancaB = eval('${bancaB}');

	if (isPack == "Y") {
		packParlistParams = eval('${packParlistParams}');
	}

	for (var i = 0; i < wcominv.length; i++) {
		wcominv[i].nbtIntmType = null;
		wcominv[i].intmNoNbt = wcominv[i].intermediaryNo;
		wcominv[i].sharePercentageNbt = wcominv[i].sharePercentage;
		wcominv[i].recordStatus = null;
	}

	for (var i = 0; i < wcominvper.length; i++) {
		// POST-QUERY for WCOMINVPER
		wcominvper[i].nbtCommissionRtComputed = null;
		wcominvper[i].netCommission = parseFloat(nvl(wcominvper[i].commissionAmount, "0")) - parseFloat(nvl(wcominvper[i].withholdingTax, "0"));
		wcominvper[i].recordStatus = null;
	}

	// assigned b240 values to hidden fields to be used in a function in underwriting.js (for intm listing)
	$("txtB240ParId").value = b240[selectedB240Index].parId;
	$("txtB240AssdNo").value = b240[selectedB240Index].assdNo;
	$("txtB240LineCd").value = b240[selectedB240Index].lineCd;

	/** initialization **/
	
	setModuleId("GIPIS085");
	setDocumentTitle("Invoice Commission");
	//populateTakeupSeqNoList();
	
	// WCOMINV
	displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "L");

	// BANCA_B
	if (bancaB.length > 0) {
		for (var i = 0; i < bancaB.length; i++) {
			var content = generateBancTypeDtlContent(bancaB[i], i);
			bancaB[i].recordStatus = null;
			addTableRow("row"+i, "rowBancTypeDtl", "bancTypeDtlTableContainer", content, clickBancTypeDtlRow);
			bancaBLastNo = bancaBLastNo + 1;
		}
		checkIfToResizeTable("bancTypeDtlTableContainer", "rowBancTypeDtl");
	} else {
		checkTableIfEmpty("rowBancTypeDtl", "bancTypeDtlTableMainDiv");
	}

	executeB450whenNewBlockInstance();
	validateB240Block(false);
	$("assuredName").value = unescapeHTML2(b240[selectedB240Index].dspAssdName);
	//populateItemGrpList();

	//Modified by Apollo 12.10.2014 - added nvl(varVCommUpdateTag, "N") != "Y"
	if(nvl(varVParamShowComm,"N") == "N" && nvl(varVCommUpdateTag, "N") != "Y"){
		$("mainInvoicePerilDiv").style.display = "none";
	}	

	// when-new-form-instance codes
	if (nvl(varVParamShowComm, "N") == "Y" && nvl(varVCommUpdateTag, "N") == "N") {
		$("txtPerilCommissionRt").readOnly = true;
		$("txtPerilCommissionAmt").readOnly = true;
		
	} else {
		if (globalCancelTag == "Y") {
			$("txtPerilCommissionRt").readOnly = true;
			$("txtPerilCommissionAmt").readOnly = true;
		} else {
			$("txtPerilCommissionRt").readOnly = false;
			$("txtPerilCommissionAmt").readOnly = false;
		}
	}


	
	$("parNo").innerHTML = "";
	for (var i = 0; i < b240.length; i++) {
		var newOption = new Element("option");
		newOption.text = b240[i].drvParSeqNo;
		newOption.value = b240[i].drvParSeqNo;

		try {
		    $("parNo").add(newOption, null); // standards compliant; doesn't work in IE
		  }
		catch(ex) {
		    $("parNo").add(newOption); // IE only
		}
	}

	$("parNo").observe("change", function() {
		selectedB240Index = $("parNo").selectedIndex;
		validateB240Block(true);
		prevSelectedB240Index = selectedB240Index;
	});

	// pre-query and post-query codes (emman 06.28.2011)
	if (nvl(isPack, "N") != "Y") {
		$("parInfoPackParDiv").style.display = "none";
	} else {
		$("packParNo").value = b240[selectedB240Index].dspPackParNo;
	}
	
	//$("chkLovTag").value = ("${vLovTag}".blank()) ? "UNFILTERED" : "${vLovTag}";	
	
	if(objUWParList.parType == "E"){
		objUWGlobal.cancelTag = "N";
		if(objGIPIWPolbas.polFlag == 4 || objUWGlobal.cancelTag == "Y"){
			$("chkLovTag").value = "FILTERED";
		}
	}

	if(objUWParList.parType == "E"){
		//objUWGlobal.cancelTag = "N"; commented out - irwin
		if(objGIPIWPolbas.polFlag == 4 || objUWGlobal.cancelTag == "Y"){
			$("chkLovTag").value = "FILTERED";
		}
	}
	
	if ($("chkLovTag").value == "FILTERED") {
		$("chkLovTag").checked = true;
	} else {
		$("chkLovTag").checked = false;
	}

	checkTableIfEmpty("rowWcominvper", "wcominvperTableMainDiv");

	$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId)), 7);

	/** end of initialization **/
	
	/** page functions **/
	
	function generateWcommInvoiceContent(wcommInvoice, rowNum) {
		var content = "";

		var intermediaryName = (wcommInvoice.intermediaryName == null) ? "---" : (wcommInvoice.intermediaryName.blank()) ? "---" : wcommInvoice.intermediaryName.truncate(23, "...");
		var sharePercentage = (wcommInvoice.sharePercentage == null) ? "0.00" : formatCurrency(wcommInvoice.sharePercentage);
		var premiumAmt = (wcommInvoice.premiumAmount == null) ? "0.00" : formatCurrency(wcommInvoice.premiumAmount);
		var commissionAmt = (wcommInvoice.commissionAmount == null) ? "0.00" : formatCurrency(wcommInvoice.commissionAmount);
		var netCommission = (wcommInvoice.netCommission == null) ? "0.00" : formatCurrency(wcommInvoice.netCommission);
		var wholdingTax = (wcommInvoice.withholdingTax == null) ? "0.00" : formatCurrency(wcommInvoice.withholdingTax);
		var intmNumber = (wcommInvoice.intermediaryNo == null) ? "" : wcommInvoice.intermediaryNo;

		content =
			'<label id="labelWcominvIntermediaryName" 	name="labelWcominv" 			   style="width: 167px; text-align: left; margin-left: 5px;">'+intermediaryName+'</label>' +
			'<label id="labelWcominvSharePercentage"  	name="labelWcominv" class="money"  style="width: 130px; text-align: right;">'+sharePercentage+'</label>' +
			'<label id="labelWcominvSharePremium" 		name="labelWcominv" class="money"  style="width: 145px; text-align: right;">'+premiumAmt+'</label>' +
			'<label id="labelWcominvTotalCommission" 	name="labelWcominv" class="money"  style="width: 145px; text-align: right;">'+commissionAmt+'</label>' +
			'<label id="labelWcominvNetCommission" 		name="labelWcominv" class="money"  style="width: 145px; text-align: right;">'+netCommission+'</label>' +
			'<label id="labelWcominvTotalWholdingTax" 	name="labelWcominv" class="money"  style="width: 164px; text-align: right;">'+wholdingTax+'</label>' +
			'<input type="hidden"	id="wcominvCount"	name="wcominvCount"	value="'+rowNum+'" +/>' +
			'<input type="hidden"   id="wcominvIntmNo"  name="wcomInvCount" value="'+intmNumber+'">';

		return content;
	}

	function generateWcommInvoicePerilContent(wcommInvPeril, rowNum) {
		var content = "";

		var perilName  = (wcommInvPeril.perilName == null) ? "---" : (wcommInvPeril.perilName.blank()) ? "---" : wcommInvPeril.perilName.truncate(20, "...");
		var premiumAmt = (wcommInvPeril.premiumAmount == null) ? "0.00" : formatCurrency(wcommInvPeril.premiumAmount);
		var commissionRate = (wcommInvPeril.premiumAmount == null) ? "0.00" : formatCurrency(wcommInvPeril.commissionRate);
		var commissionAmt = (wcommInvPeril.commissionAmount == null) ? "0.00" : formatCurrency(wcommInvPeril.commissionAmount);
		var wholdingTax = (wcommInvPeril.withholdingTax == null) ? "0.00" : formatCurrency(wcommInvPeril.withholdingTax);
		var netCommission = (wcommInvPeril.netCommission == null) ? "0.00" : formatCurrency(wcommInvPeril.netCommission);

		content =
			'<label id="labelWcommInvPerPerilName" 			name="labelWcommInvPer" 			  style="width: 167px; text-align: left; margin-left: 5px;">'+perilName+'</label>' +
			'<label id="labelWcommInvPerPerilAmount" 		name="labelWcommInvPer" class="money" style="width: 145px; text-align: right;">'+premiumAmt+'</label>' +
			'<label id="labelWcommInvPerCommissionRate" 	name="labelWcommInvPer" class="money" style="width: 145px; text-align: right;">'+commissionRate+'</label>' +
			'<label id="labelWcommInvPerCommissionAmount"	name="labelWcommInvPer" class="money" style="width: 145px; text-align: right;">'+commissionAmt+'</label>' +
			'<label id="labelWcommInvPerWithholdingTax" 	name="labelWcommInvPer" class="money" style="width: 145px; text-align: right;">'+wholdingTax+'</label>' +
			'<label id="labelWcommInvPerNetCommission" 		name="labelWcommInvPer" class="money" style="width: 145px; text-align: right;">'+netCommission+'</label>' +
			'<input type="hidden"	id="wcominvperCount"	name="wcominvperCount"	value="'+rowNum+'" />';

		return content;
	}

	function generateBancTypeDtlContent(bancTypeDtl, rowNum) {
		var content = "";

		var itemNo = bancTypeDtl.itemNo == null ? "---" : bancTypeDtl.itemNo;
		var intmNo = bancTypeDtl.intmNo == null ? "---" : bancTypeDtl.intmNo;
		var intmName = bancTypeDtl.intmName == null ? "---" : bancTypeDtl.intmName;
		var intmType = bancTypeDtl.intmTypeDesc == null ? "---" : bancTypeDtl.intmTypeDesc;
		var fixedTag = bancTypeDtl.fixedTag == null ? "" : (bancTypeDtl.fixedTag == "Y" ? "<img name='checkedImg' src='${pageContext.request.contextPath}/images/misc/ok.jpg' style='width: 10px;'/>" : "");

		content = 
			'<label style="width:  90px;font-size: 10px; text-align: center;">'+intmNo+'</label>' +
			'<label style="width:  90px;font-size: 10px; text-align: center;">'+itemNo+'</label>' +
			'<label style="width: 300px;font-size: 10px; text-align:   left;">'+intmName.truncate(50, "...")+'</label>' +
			'<label style="width: 280px;font-size: 10px; text-align: center;">'+intmType+'</label>' +
			'<label style="width:  20px;font-size: 10px; text-align: center;">'+fixedTag+'</label>' +
			'<input type="hidden"	id="bancaBCount"		name="bancaBCount"	value="'+rowNum+'" />';

		return content;
	}

	function clickWcominv(row) {
		$$("div#wcominvTableContainer div[name='rowWcominv']").each(function(r) {
			if (row.id != r.id) {
				r.removeClassName("selectedRow");
			}
		});

		row.toggleClassName("selectedRow");

		disableButton($("btnSavePeril"));

		if (row.hasClassName("selectedRow")) {			
			currentWcominvRowNo = row.down("input", 0).value;
			selectedWcominvRow = row;			
			populateWcominvDetails(currentWcominvRowNo);			
			displayWcominvperRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), wcominv[currentWcominvRowNo].intermediaryNo);			
			enableWcominvperFields();			
			resetWcominvperFields();			
			$("btnSaveIntm").value = "Update";

			//if(!(objUWParList.parType == "E" && (objGIPIWPolbas.polFlag == 4 || objUWGlobal.cancelTag == "Y"))){ // (removed - emman 09.09.2011)
				enableButton($("btnSaveIntm"));
				enableButton($("btnDeleteIntm"));
			//}

			// assign value to var_tax_amt (POST-QUERY of wcominvoice peril)
			varTaxAmt = getDefaultTaxRate(wcominv[currentWcominvRowNo].intermediaryNo);			
		} else {
			currentWcominvRowNo = -1;
			selectedWcominvRow = null;
			resetWcominvFields();
			resetWcominvperFields();
			removeAllWcominvperRecords();
			enableWcominvperFields();
			hidePerilDiv();
			$("btnSaveIntm").value = "Add";
			disableButton($("btnDeleteIntm"));
			$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId)), 7);
		}

		// update other values
		prevSharePercentage = 0;
	}

	function clickWcominvper(row) {
		$$("div#wcominvperTableContainer div[name='rowWcominvper']").each(function(r) {
			if (row.id != r.id) {
				r.removeClassName("selectedRow");
			}
		});

		row.toggleClassName("selectedRow");

		if (row.hasClassName("selectedRow")) {
			currentWcominvperRowNo = row.down("input", 0).value;
			selectedWcominvperRow = row;
			populateWcominvperDetails(currentWcominvperRowNo);
			//enableButton($("btnSavePeril"));
			//robert added condition for cancelTag, disable fields 10.23.2012
			(objUWParList.parType == "E" && objUWGlobal.cancelTag == "Y" ? $("txtSharePercentage").readOnly = true : "");
			(objUWParList.parType == "E" && objUWGlobal.cancelTag == "Y" ? $("txtPerilCommissionRt").readOnly = true : "");
			(objUWParList.parType == "E" && objUWGlobal.cancelTag == "Y" ? $("txtPerilCommissionAmt").readOnly = true : "");
			(objUWParList.parType == "E" && objUWGlobal.cancelTag == "Y" ? $("txtPerilWholdingTax").readOnly = true : "");
			(objUWParList.parType == "E" && objUWGlobal.cancelTag == "Y" ? $("txtPerilNbtCommissionAmt").readOnly = true : "");
			(objUWParList.parType == "E" && objUWGlobal.cancelTag == "Y" ? disableButton("btnSavePeril") : enableButton("btnSavePeril"));
		} else {
			currentWcominvperRowNo = -1;
			selectedWcominvperRow = null;
			resetWcominvperFields();
			disableButton($("btnSavePeril"));
		}
		
		// these lines added by: Nica 09.13.2012 - to disable fields if endt is cancelled
		if(objUWParList.parType == "E"){
			if(objGIPIWPolbas.polFlag == 4 || objUWGlobal.cancelTag == "Y"){
				disableButton($("btnSavePeril"));
				$("txtPerilCommissionRt").readOnly = true;
				$("txtPerilCommissionAmt").readOnly = true;
				$("txtPerilWholdingTax").readOnly = true;
			}else{
				enableButton($("btnSavePeril"));
				//$("txtPerilWholdingTax").readOnly = false;
				if (nvl(varVParamShowComm, "N") == "Y" && nvl(varVCommUpdateTag, "N") == "N") {
					$("txtPerilCommissionRt").readOnly = true;
					$("txtPerilCommissionAmt").readOnly = true;
				}else{
					$("txtPerilCommissionRt").readOnly = false;
					$("txtPerilCommissionAmt").readOnly = false;
				}
			}
		}else{
			enableButton($("btnSavePeril"));
			//$("txtPerilWholdingTax").readOnly = false;
			if (nvl(varVParamShowComm, "N") == "Y" && nvl(varVCommUpdateTag, "N") == "N") {
				$("txtPerilCommissionRt").readOnly = true;
				$("txtPerilCommissionAmt").readOnly = true;
			}else{
				$("txtPerilCommissionRt").readOnly = false;
				$("txtPerilCommissionAmt").readOnly = false;
			}
		}
		
		if(userCommUpdateTag == 'N') //Apollo Cruz 09.12.2014
			$("txtPerilWholdingTax").readOnly = true;
	}

	function clickBancTypeDtlRow(row) {
		$$("div#bancTypeDtlTable div[name='rowBancTypeDtl']").each(function(r) {
			if (row.id != r.id) {
				r.removeClassName("selectedRow");
			}
		});

		row.toggleClassName("selectedRow");

		if (row.hasClassName("selectedRow")) {
			currentBancaBRowNo = row.down("input", 0).value;
			selectedBancaBRow = row;
			populateBancaDetails(currentBancaBRowNo);
		} else {
			currentBancaBRowNo = -1;
			selectedBancaBRow = null;
			resetBancaFields();
		}
		
		if(userCommUpdateTag == 'N') //Apollo Cruz 09.12.2014
			$("txtPerilWholdingTax").readOnly = true;
	}

	// Populates input fields of Wcominv details
	// @param - rowNum: the array index of the Wcominv record to be displayed
	function populateWcominvDetails(rowNum) {
		var wcommInvoice = wcominv[rowNum];
		// main details
		$("txtIntmNo").value = wcommInvoice.intermediaryNo;
		$("txtIntmName").value = unescapeHTML2(wcommInvoice.intermediaryName.replace(/\\/g, '\\\\'));
		$("txtParentIntmNo").value = wcommInvoice.parentIntermediaryNo;		
		$("txtParentIntmName").value = wcommInvoice.parentIntermediaryName == null ? "" : unescapeHTML2(wcommInvoice.parentIntermediaryName.replace(/\\/g, '\\\\'));
		$("txtDspIntmName").value = wcommInvoice.intermediaryName == null ? "" : unescapeHTML2(wcommInvoice.intermediaryNo + " - " + wcommInvoice.intermediaryName.replace(/\\/g, '\\\\'));
		$("txtDspParentIntmName").value = wcommInvoice.parentIntermediaryNo == null ? unescapeHTML2(wcommInvoice.intermediaryNo + " - " + wcommInvoice.intermediaryName.replace(/\\/g, '\\\\')) : unescapeHTML2(wcommInvoice.parentIntermediaryNo + " - " + ((wcommInvoice.parentIntermediaryName == null) ? "" : wcommInvoice.parentIntermediaryName.replace(/\\/g, '\\\\')));		
		$("txtSharePercentage").value = (wcommInvoice.sharePercentage == null) ? "0.00" : formatToNthDecimal(wcommInvoice.sharePercentage, 7);		
		$("txtPremiumAmt").value = (wcommInvoice.premiumAmount == null) ? "0.00" : formatCurrency(wcommInvoice.premiumAmount);
		$("txtCommissionAmt").value = (wcommInvoice.commissionAmount == null) ? "0.00" : formatCurrency(wcommInvoice.commissionAmount);
		$("txtNetCommission").value = (wcommInvoice.netCommission == null) ? "0.00" : formatCurrency(wcommInvoice.netCommission);
		$("txtWholdingTax").value = (wcommInvoice.withholdingTax == null) ? "0.00" : formatCurrency(wcommInvoice.withholdingTax);
		$("txtNbtIntmType").value = (wcommInvoice.nbtIntmType == null) ? "" : wcommInvoice.nbtIntmType;
		$("txtIntmNoNbt").value = (wcommInvoice.intmNoNbt == null) ? "" : wcommInvoice.intmNoNbt;
		$("txtSharePercentageNbt").value = (wcommInvoice.sharePercentageNbt == null) ? "0.00" : formatToNthDecimal(wcommInvoice.sharePercentageNbt, 7);

		$("txtParentIntmLicTag").value = wcommInvoice.parentIntmLicTag;
		$("txtParentIntmSpecialRate").value = wcommInvoice.parentIntmSpecialRate;
		
		$("txtLicTag").value = wcommInvoice.licTag; /*added by christian 08.25.2012*/
		$("txtSpecialRate").value = wcommInvoice.specialRate; /*added by christian 08.25.2012*/
		
		$("chkLovTag").checked = false;
		
		if(objGIPIWPolbas.polFlag == 2 || objUWParList.parType == "E"){			
			for(var i = 0; i < dfltIntms.length; i++){
				if(wcommInvoice.intermediaryNo == dfltIntms[i]){
					$("chkLovTag").checked = true;
					break;
				}
			}			
		} else {
			if('${dfltIntmNo}' == wcommInvoice.intermediaryNo)
				$("chkLovTag").checked = true;
		}
	}

	// Clear wcominv fields
	function resetWcominvFields() {
		clearIntmFields();
		$("txtDspIntmName").value = "";
		$("txtDspParentIntmName").value = "";
		$("txtSharePercentage").value = "";
		$("txtPremiumAmt").value = "";
		$("txtCommissionAmt").value = "";
		$("txtNetCommission").value = "";
		$("txtWholdingTax").value = "";
		$("txtNbtIntmType").value = "";
		$("txtIntmNoNbt").value = "";
		$("txtSharePercentageNbt").value = "";

		if(objUWParList.parType != "E"){
			$("chkLovTag").checked = false; // added by emsy
		}

		$("txtParentIntmLicTag").value = ""; /*added by christian 08.25.2012*/
		$("txtParentIntmSpecialRate").value = ""; /*added by christian 08.25.2012*/
		
		$("txtLicTag").value = "";
		$("txtSpecialRate").value = "";
		
		$("chkNbtRetOrig").checked = false;
		$("chkNbtRetOrig").value = "N";
		
		//benjo 09.07.2016 SR-5604
		if(reqDfltIntmPerAssd == "Y"){
			if(allowUpdIntmPerAssd == "N"){
				$("chkLovTag").value = "FILTERED";
				$("chkLovTag").checked = true;
				$("chkLovTag").disabled = true;
			}else if(allowUpdIntmPerAssd == "O" && override == "Y"){
				$("chkLovTag").value = "FILTERED";
				$("chkLovTag").checked = true;
			}
		}
	}

	// Populates input fields of Wcominvper details
	// @param - rowNum: the array index of the Wcominvper record to be displayed
	function populateWcominvperDetails(rowNum) {
		var wcommInvoicePeril = wcominvper[rowNum];
		
		// main details
		$("txtPerilCd").value = wcommInvoicePeril.perilCd;
		$("txtPerilName").value = unescapeHTML2(wcommInvoicePeril.perilName);
		$("txtPerilPremiumAmt").value = (wcommInvoicePeril.premiumAmount == null) ? "0.00" : formatCurrency(wcommInvoicePeril.premiumAmount);
		$("txtPerilCommissionRt").value = (wcommInvoicePeril.commissionRate == null) ? "0.00" : formatToNthDecimal(wcommInvoicePeril.commissionRate, 7);
		$("txtPerilCommissionAmt").value = (wcommInvoicePeril.commissionAmount == null) ? "0.00" : formatCurrency(wcommInvoicePeril.commissionAmount);
		$("txtPerilWholdingTax").value = (wcommInvoicePeril.withholdingTax == null) ? "0.00" : formatCurrency(wcommInvoicePeril.withholdingTax);
		$("txtPerilNbtCommissionAmt").value = (wcommInvoicePeril.netCommission == null) ? "0.00" : formatCurrency(wcommInvoicePeril.netCommission);
		$("txtPerilNbtCommissionRtComputed").value = (wcommInvoicePeril.nbtCommissionRtComputed == null) ? $("txtPerilCommissionRt").value : wcommInvoicePeril.nbtCommissionRtComputed;
		
	}

	// Clear Wcominvper fields
	function resetWcominvperFields() {
		$("txtPerilCd").value = "";
		$("txtPerilName").value = "";
		$("txtPerilPremiumAmt").value = "";
		$("txtPerilCommissionRt").value = "";
		$("txtPerilCommissionAmt").value = "";
		$("txtPerilWholdingTax").value = "";
		$("txtPerilNbtCommissionAmt").value = "";
		$("txtPerilNbtCommissionRtComputed").value = "";
	}

	// Populates input fields of Banca details
	// @param - rowNum: the array index of the BancTypeDtl record to be displayed
	function populateBancaDetails(rowNum) {
		var bancaDtl = bancaB[rowNum];

		// main details
		$("txtBancaItemNo").value = bancaDtl.itemNo;
		$("txtBancaIntmNo").value = bancaDtl.intmNo;
		$("txtBancaIntmName").value = bancaDtl.intmName == null ? "" : changeSingleAndDoubleQuotes(bancaDtl.intmName);
		$("txtBancaDrvIntmName").value = bancaDtl.intmName == null ? "" : changeSingleAndDoubleQuotes(bancaDtl.intmName);
		$("txtBancaIntmType").value = changeSingleAndDoubleQuotes(bancaDtl.intmType);
		$("txtBancaIntmTypeDesc").value = changeSingleAndDoubleQuotes(bancaDtl.intmTypeDesc);
		$("txtBancaSharePercentage").value = bancaDtl.sharePercentage;
		$("chkBancaFixedTag").checked = bancaDtl.fixedTag == "Y" ? true : false;
	}

	// Clear banca detail fields
	function resetBancaFields() {
		$("txtBancaItemNo").value = "";
		$("txtBancaIntmNo").value = "";
		$("txtBancaIntmName").value = "";
		$("txtBancaDrvIntmName").value = "";
		$("txtBancaIntmType").value = "";
		$("txtBancaIntmTypeDesc").value = "";
		$("txtBancaSharePercentage").value = "";
		$("chkBancaFixedTag").checked = false;
	}

	// displays the WCOMINV records of specified item group and takeup seq no
	function displayWcominvRecords(itemGrp, takeupSeqNo, pageLoad) {
		removeAllWcominvRecords();
		if (wcominv.length > 0) {
			for (var i = 0; i < wcominv.length; i++) {
				if (wcominv[i].itemGroup == parseInt(nvl(itemGrp, "0")) && wcominv[i].takeupSeqNo == parseInt(nvl(takeupSeqNo, "0"))
						&& (wcominv[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0")))
						&& (wcominv[i].recordStatus == null || wcominv[i].recordStatus >= 0)) {
					var content = generateWcommInvoiceContent(wcominv[i], i);
					addTableRow("wcominvRow"+i, "rowWcominv", "wcominvTableContainer", content, clickWcominv);
				}
			}
			checkIfToResizeTable("wcominvTableContainer", "rowWcominv");
			if(pageLoad != "L") checkTableIfEmpty("rowWcominv", "wcominvTableMainDiv");  //edited, 10-04-2011
		} else {
			checkTableIfEmpty("rowWcominv", "wcominvTableMainDiv");
		}
	}

	// removes all WCOMINV records of the current item grp and takeup seq no in display
	// equivalent of CLEAR_BLOCK of WCOMINV
	function removeAllWcominvRecords() {
		$$("div[name='rowWcominv']").each(function (row) {
			/*Effect.Fade(row, {
				duration: .2,
				afterFinish: function() {
					row.remove();
				}
			});*/
			row.remove();
		});
	}

	// deletes all WcominvRecord of selected item grp, and takeup seq no
	// removes all displayed WCMINV record afterwards
	function deleteAllWcominvRecords() {
		if (wcominv.length > 0) {
			for (var i = 0; i < wcominv.length; i++) {
				if (wcominv[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominv[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& (wcominv[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0")))
						&& (wcominv[i].recordStatus == null || wcominv[i].recordStatus >= 0)) {
					deleteWcominvRow(i);
				}
			}
		}
	} 

	// deletes a WCOMINV record
	function deleteWcominvRow(index) {
		// tag the record as deleted. if previously added, mark as -2
		if (wcominv[index].recordStatus == 0 || wcominv[index].recordStatus == -2) {
			wcominv[index].recordStatus = -2;
		} else {
			wcominv[index].recordStatus = -1;
		}
	}

	// remove WCOMINV record in the table div
	function removeWcominvRecord(row) {
		//deletes intm row
		Effect.Fade(row, {
			afterFinish: function() {
				row.remove();
			}
		});
	}

	// displays the WCOMINVPER records of specified item group and takeup seq no
	function displayWcominvperRecords(itemGrp, takeupSeqNo, intmNo) {
		removeAllWcominvperRecords();
		
		if ($("perilInfoDiv").style.display == "none") {
			Effect.Appear($("wcominvperTableMainDiv"), {
				duration: .2
			});
			
			Effect.Appear($("perilInfoDiv"), {
				duration: .2
			});
		}

		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl(itemGrp, "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl(takeupSeqNo, "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(intmNo, "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					var content = generateWcommInvoicePerilContent(wcominvper[i], i);
					//wcominvper[i].recordStatus = null; (removed by emman to fix bug on not saving peril 04.14.2011)
					addTableRow("wcominvperRow"+i, "rowWcominvper", "wcominvperTableContainer", content, clickWcominvper);
				}
			}
			checkIfToResizeTable("wcominvperTableContainer", "rowWcominvper");
			checkTableIfEmpty("rowWcominvper", "wcominvperTableMainDiv");
		} else {
			checkTableIfEmpty("rowWcominvper", "wcominvperTableMainDiv");
		}
	}

	// removes all WCOMINV records of the current item grp and takeup seq no
	function removeAllWcominvperRecords() {
		$$("div[name='rowWcominvper']").each(function (row) {
			Effect.Fade(row, {
				duration: .2,
				afterFinish: function() {
					row.remove();
				}
			});
		});
	}

	// deletes all WcominvperRecord of selected item grp, takeup seq no, and specified intermediary no
	// removes all displayed WCMINVPER record afterwards
	function deleteAllWcominvperRecords(intmNo) {
		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(intmNo, "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					deleteWcominvperRow(i);
				}
			}
		}
	}

	// deletes all WcominvperRecord of selected item grp and takeup seq no
	function deleteAllWcominvperRecords2() {
		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					deleteWcominvperRow(i);
				}
			}
		}
	}

	// deletes a WCOMINV record of specified WCOMINV record
	function deleteWcominvperRow(index) {
		// tag the record as deleted. if previously added, mark as -2
		if (wcominvper[index].recordStatus == 0 || wcominvper[index].recordStatus == -2) {
			wcominvper[index].recordStatus = -2;
		} else {
			wcominvper[index].recordStatus = -1;
		}
	}

	// remove WCOMINV record in the table div
	function removeWcominvperRecord(row) {
		//deletes intm row
		Effect.Fade(row, {
			afterFinish: function() {
				row.remove();
			}
		});
	}

	// add WCOMINV record to the obj array
	function addWcominvRecord(wcommInvoice) {
		var exists = false;
		var index = 0;
		var status = "";

		if (wcominv.length > 0) {
			for (var i = 0; i < wcominv.length; i++) {
				if (wcominv[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominv[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominv[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& wcominv[i].intermediaryNo == wcommInvoice.intermediaryNo) {
					exists = true;
					index = i;
					status = wcominv[i].recordStatus;
					break;
				}
			}
		}

		if (exists) {
			if (status = -1 || status == null) {
				wcommInvoice.recordStatus = 1;
			} else if (status == 0 || status == -2) {
				wcommInvoice.recordStatus = 0;
			} 
			wcominv[index] = wcommInvoice;
		} else {
			wcommInvoice.recordStatus = 0;
			wcominv.push(wcommInvoice);
			// added by: Nica 11.23.2011 - to add default intermediary to the succeeding par
		    dfltIntmNo = wcommInvoice.intermediaryNo;
			dfltIntmName = wcommInvoice.intermediaryName;
			dfltParentIntmNo = wcommInvoice.parentIntermediaryNo;
			dfltParentIntmName = wcommInvoice.parentIntermediaryName;
		}
	}

	// add WCOMINVPER record to the obj array
	function addWcominvperRecord(wcommInvoicePeril) {
		var exists = false;
		var index = 0;
		var status = "";

		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(wcommInvoicePeril.intermediaryIntmNo, "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& wcominvper[i].perilCd == wcommInvoicePeril.perilCd) {
					exists = true;
					index = i;
					status = wcominvper[i].recordStatus;
					break;
				}
			}
		}

		if (exists) {
			if (status = -1 || status == null) {
				wcommInvoicePeril.recordStatus = 1;
			} else if (status == 0 || status == -2) {
				wcommInvoicePeril.recordStatus = 0;
			}
			wcominvper[index] = wcommInvoicePeril;
		} else {
			wcommInvoicePeril.recordStatus = 0;
			wcominvper.push(wcommInvoicePeril);
		}
	}

	function hidePerilDiv() {
		if ($("perilInfoDiv").style.display != "none") {
			Effect.Fade($("perilInfoDiv"), {
				duration: .2,
				afterFinish: function() {
					Effect.Fade($("wcominvperTableMainDiv"), {
						duration: .2
					});
				}
			});
		}
	}

	function enableWcominvperFields() {
		if (nvl(varVCommUpdateTag, "N") == "N" && nvl(varVParamShowComm,"N") == "Y") { //modified by Irwin 11.02.11
			$("txtPerilCommissionRt").readOnly = true;
			$("txtPerilCommissionAmt").readOnly = true;
			$("txtPerilWholdingTax").readOnly = true;
		}else {
			$("txtPerilCommissionRt").readOnly = false;
			$("txtPerilCommissionAmt").readOnly = false;
			//$("txtPerilWholdingTax").readOnly = false;
		}	
		
		if(userCommUpdateTag == 'N') //Apollo Cruz 09.12.2014
			$("txtPerilWholdingTax").readOnly = true;		
	}

	function executeB450whenNewBlockInstance() {
		if (vOra2010Sw == "Y" && vValidateBanca == "Y") {
			if (wcominv.length == 0) {
				showWaitingMessageBox("This is a bancassurance record. Please check the list of intermediaries.", imgMessage.INFO,
						function(){
							showBancaDetails();
							disableSearch("oscmIntm");
							disableButton("btnSaveIntm");
							$("txtSharePercentage").readOnly = true;
						});
			}
		} else {
			$("btnShowBancaDetails").style.display = "none";
		}
	}

	function showBancaDetails() {
		$("showBancaDetails").innerHTML = "Hide";
		$("bancaDtlDiv").style.display = "block";
		$("bancaDetailsInfo").show();
		$("txtBancTypeCd").focus();
		$("txtBancTypeCd").scrollTo();
	}

	function hideBancaDetails() {
		$("showBancaDetails").innerHTML = "Show";
		$("bancaDtlDiv").style.display = "none";
		$("bancaDetailsInfo").hide();
		$("txtIntmNo").focus();
		$("txtIntmNo").scrollTo();
	}

	function clearIntmFields() {
		$("txtIntmNo").value = "";
		$("txtIntmName").value = "";
		$("txtParentIntmNo").value = "";
		$("txtParentIntmName").value = "";
		$("txtIntmActiveTag").value = "";
		$("txtDspIntmName").value = "";
		$("txtDspParentIntmName").value = "";
	}

	function validateIntmNo(wcommInvoice) {
		var ok = true;
		
		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=validateGipis085IntmNo", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				parId: b240[selectedB240Index].parId,
				intmNo: wcommInvoice.intermediaryNo,
				nbtIntmType: wcommInvoice.nbtIntmType,
				assdNo: b240[selectedB240Index].assdNo,
				lineCd: b240[selectedB240Index].lineCd,
				parType: b240[selectedB240Index].parType,
				drvParSeqNo: b240[selectedB240Index].drvParSeqNo,
				vLovTag: $("chkLovTag").checked ? "FILTERED" : "UNFILTERED"
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					$("chkLovTag").value = result.vLovTag;
					wcommInvoice.nbtIntmType = result.nbtIntmType;

					if ($("chkLovTag").value == "FILTERED") {
						$("chkLovTag").checked = true;
					} else {
						$("chkLovTag").checked = false;
					}

					if (result.msgAlert == "INTNO_NOT_IN_LOV") {
						showConfirmBox("", "Intermediary No. " + result.intmNo +" is not included in the list of default intermediaries for this assured/policy. Continue?",
								"Yes", "No",
								function() {
									$("chkLovTag").value = "UNFILTERED";
									$("chkLovTag").checked = false;
								},
								function() {
									ok = false;
									clearIntmFields();
									checkAndDeleteWcominvIfExisting(wcommInvoice.intermediaryNo);
								});
					} else if (result.msgAlert == "ISS_CD_NOT_MATCH") {
						showConfirmBox("", "The issuing source of this intermediary is " + result.issName + ". Do you want to continue?",
								"Yes", "No",
								function() {
								},
								function() {
									ok = false;
									clearIntmFields();
									checkAndDeleteWcominvIfExisting(wcommInvoice.intermediaryNo);
								});
					} else {
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
					ok = false;
				}
			}
		});

		return ok;
	}

	// populate item grp list by par id (emman 06.29.2011)
	function populateItemGrpList() {
		$("txtItemGrp").innerHTML = "";
		for (var i = 0; i < winvoices.length; i++) {
			if (winvoices[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0")) &&
				$$("#txtItemGrp option[value="+winvoices[i].itemGrp+"]").length == 0) {
				var newOption = new Element("option");
				newOption.text = winvoices[i].itemGrp;
				newOption.value = winvoices[i].itemGrp;
				
				try {
				    $("txtItemGrp").add(newOption, null); // standards compliant; doesn't work in IE
				  }
				catch(ex) {
				    $("txtItemGrp").add(newOption); // IE only
				}
			}
		}

		$("txtItemGrp").stopObserving();
		$("txtItemGrp").observe("change", function() {
			validateItemGrp();
		});

		if (winvoices.length > 0) {
			$("txtItemGrp").selectedIndex = 0;
			populateTakeupSeqNoList();
			prevItemGrp = $F("txtItemGrp");
		}
	}

	function populateTakeupSeqNoList() {
		$("txtTakeupSeqNo").innerHTML = "";
		for (var i = 0; i < winvoices.length; i++) {
			if (winvoices[i].itemGrp == parseInt(nvl($F("txtItemGrp"), "0")) &&
				winvoices[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0")) &&
				$$("#txtTakeupSeqNo option[value="+winvoices[i].takeupSeqNo+"]").length == 0) {
				var newOption = new Element("option");
				newOption.text = winvoices[i].takeupSeqNo;
				newOption.value = winvoices[i].takeupSeqNo;
				newOption.setAttribute("multiBookingMM", winvoices[i].multiBookingMM);
				newOption.setAttribute("multiBookingYY", winvoices[i].multiBookingYY);
				newOption.setAttribute("insured", winvoices[i].insured);

				try {
				    $("txtTakeupSeqNo").add(newOption, null); // standards compliant; doesn't work in IE
				  }
				catch(ex) {
				    $("txtTakeupSeqNo").add(newOption); // IE only
				}
			}
		}

		$("txtTakeupSeqNo").stopObserving();
		$("txtTakeupSeqNo").observe("change", function() {
			validateTakeupSeqNo();
		});

		if (winvoices.length > 0) {
			$("txtTakeupSeqNo").selectedIndex = 0;
			$("txtMultiBookingMM").value = (nvl($("txtTakeupSeqNo").options[0], null) == null) ? "" : $("txtTakeupSeqNo").options[0].readAttribute("multiBookingMM");
			$("txtMultiBookingYY").value = (nvl($("txtTakeupSeqNo").options[0], null) == null) ? "" : $("txtTakeupSeqNo").options[0].readAttribute("multiBookingYY");
			$("txtInsured").value		 = unescapeHTML2((nvl($("txtTakeupSeqNo").options[0], null) == null) ? "" : $("txtTakeupSeqNo").options[0].readAttribute("insured"));
			prevTakeupSeqNo = $F("txtTakeupSeqNo");

			//validateTakeupSeqNo();
			displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "");
			//resetWcominvFields(); -- mark jm 07.07.2011 UCPB_PRF_7136
			resetWcominvperFields();
			removeAllWcominvperRecords();
			hidePerilDiv();
			prevTakeupSeqNo = $F("txtTakeupSeqNo");

			$("txtMultiBookingMM").value = (nvl($("txtTakeupSeqNo").options[0], null) == null) ? "" : $("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("multiBookingMM");
			$("txtMultiBookingYY").value = (nvl($("txtTakeupSeqNo").options[0], null) == null) ? "" : $("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("multiBookingYY");
			$("txtInsured").value		 = unescapeHTML2((nvl($("txtTakeupSeqNo").options[0], null) == null) ? "" : $("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("insured"));
		}
	}

	function checkRequiredWcominvFieldsBeforeSaving() {
		var ok = true;
		var item = "";
		if (!$F("txtIntmNo").blank() && !$F("txtSharePercentage").blank()) {
			enableButton($("btnSaveIntm"));
		} else {
			disableButton($("btnSaveIntm"));
		}
	}

	function getTotalSharePercentage(itemGrp, takeupSeqNo, parId) {
		var total = 0;
		
		for (var i = 0; i < wcominv.length; i++) {
			if (wcominv[i].itemGroup == parseInt(nvl(itemGrp, "0")) && wcominv[i].takeupSeqNo == parseInt(nvl(takeupSeqNo, "0"))
					&& (wcominv[i].parId == parseInt(nvl(parId, "0")))
					&& (wcominv[i].recordStatus == null || wcominv[i].recordStatus >= 0)) {
				total = total + parseFloat(nvl(wcominv[i].sharePercentage, "0"));
			}
		}

		return total;
	}

	/**
	 * Shows the overlay containing the list of records of WTRATE record group
	 * Emman 07.28.2011
	 */
	function showWtRateRecordGroupListing(){
	    var contentDiv = new Element("div", {id : "modal_content_wtrate"});
	    var contentHTML = '<div id="modal_content_wtrate"></div>';
	    
	    winWorkflow = Overlay.show(contentHTML, {
							id: 'modal_dialog_wtrate',
							title: "",
							width: 400,
							height: 400,
							draggable: true,
							closable: true
						});

		var objParameters = new Object();
		objParameters.wtRateList = prepareJsonAsParameter(rgWtRate);
	    
	    new Ajax.Updater("modal_content_wtrate", contextPath+"/GIPIWCommInvoiceController?action=showWtRateRecordGroupListing&parameters="+JSON.stringify(objParameters), {
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	// Executes SHOW_TAX_RATES procedure
	function showTaxRates() {
		var vBool = false;
		
		showWaitingMessageBox("There were changes made to the withholding tax rate, please choose which rate will be used.", imgMessage.INFO,
				function() {
					
					
					if (vBool) {
					} else {
						showWaitingMessageBox("No witholding tax rate chosen, will now exit form.", imgMessage.INFO,
								cancelFuncWcommInvoice);
						return false;
					}
				});
	}

	// Executes BANCASSURANCE.get_default_tax_rt function, for enhancement
	function executeBancassuranceGetDefaultTaxRt(wcommInvoice, wcommInvoicePerils, recordStatus) {
		var invoicePeril = (wcommInvoicePerils == null) ? null : ((wcommInvoicePerils.length == 0) ? null : wcommInvoicePerils[0]);
		var ok = true;
		
		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=executeBancassuranceGetDefaultTaxRt", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				parId: b240[selectedB240Index].parId,
				parType: b240[selectedB240Index].parType,
				wcomInvParId: b240[selectedB240Index].parId,
				intrmdryIntmNo: wcommInvoice.intermediaryNo,
				intrmdryIntmNoNbt: wcommInvoice.intmNoNbt,
				sharePercentage: wcommInvoice.sharePercentage,
				sharePercentageNbt: wcommInvoice.sharePercentageNbt,
				perilCommissionAmount: (invoicePeril == null) ? "" : invoicePeril.commissionAmount,
				takeupSeqNo: $F("txtTakeupSeqNo"),
				systemRecordStatus: recordStatus,
				itemGrp: $F("txtItemGrp"),
				globalCancelTag: globalCancelTag,
				vPolicyId: ""
			},
			onCreate: function() {
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (result.vRgId == "Y") {
						rgWtRate.splice(0, rgWtRate.length);
					}

					/*var wtRate = new Object();
					wtRate.rec = rgWtRate.length + 1;
					wtRate.wtr = varTaxAmt;

					new Ajax.Request(contextPath+"/GIPIPolbasicController?action=getPolicyNo", {
						method: "GET",
						asynchronous: false,
						evalScripts: false,
						parameters: {
							policyId: 1//result.vPolicyId
						},
						onComplete: function(response2) {
							if (checkErrorOnResponse(response2)) {
								wtRate.pol = response2.responseText;

								rgWtRate.push(wtRate);

								showWtRateRecordGroupListing();
							} else {
								showMessageBox(response2.responseText, imgMessage.INFO);
							}
						}
					});*/

					if (result.vOv == "Y") {
						new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=validateUserFunc", {
							method: "GET",
							asynchronous: false,
							evalScripts: false,
							parameters: {
								funcCode: "OV",
								moduleName: "GIPIS085"
							},
							onComplete: function(response2) {
								if (checkErrorOnResponse(response2)) {
									if (response2.responseText == "TRUE") {
										showTaxRates();
									}
								} else {
									showMessageBox(response2.responseText, imgMessage.ERROR);
								}
							}
						});
					}

					if (result.vAddGroupRow == "Y") {
						var wtRate = new Object();
						wtRate.rec = rgWtRate.length + 1;
						wtRate.pol = varTaxAmt;

						new Ajax.Request(contextPath+"/GIPIPolbasicController?action=getPolicyNo", {
							method: "GET",
							asynchronous: false,
							evalScripts: false,
							parameters: {
								policyId: result.vPolicyId
							},
							onComplete: function(response2) {
								if (checkErrorOnResponse(response2)) {
									wtRate.wtr = response2.responseText;

									rgWtRate.push(wtRate);
								} else {
									showMessageBox(response2.responseText, imgMessage.INFO);
								}
							}
						});
					}

					/** removed - this is supposed to be used in oracle forms only (emman 8/18/2011) **/
					/*
					if (result.vGoClearBlock == "Y") {
						deleteAllWcominvperRecords(wcommInvoice.intermediaryNo);
					}

					if (result.vRemoveClrdRwFrmGrp == "Y") {
						//pass
					}*/

					if (result.vCheckCommPeril == "Y") {
						new Ajax.Request(contextPath+"/GIACDirectPremCollnsController?action=checkPerilCommRate", {
							method: "GET",
							asynchronous: false,
							evalScripts: false,
							parameters: {
								intrmdryIntmNo: "OV",
								parId: "GIPIS085",
								itemGrp: wcommInvoice.itemGroup,
								takeupSeqNo: wcommInvoice.takeupSeqNo,
								lineCd: b240[selectedB240Index].lineCd,
								issCd: b240[selectedB240Index].issCd,
								nbtIntmType: wcommInvoice.nbtIntmType					
							},
							onComplete: function(response2) {
								if (checkErrorOnResponse(response2)) {
									varMissingPerils = response2.responseText;
									if (!response2.responseText.blank()) {
										showMessageBox("Please check intermediary commission rates for the following perils: " + response2.responseText, imgMessage.ERROR);
										ok = false;
									}
								} else {
									showMessageBox(response2.responseText, imgMessage.ERROR);
								}
							}
						});
					}

					if (!ok) {
						return;
					}

					if (result.vMsgAlert1 == "Y") {
						showMessageBox("Intermediary is required.", imgMessage.INFO);
						return false;
					}

					if (result.vUpdWcommInvPerils == "Y") {
						updateWcommInvPerils(wcommInvoice);
						populateWcommInvPerils(wcommInvoice);	// UCPBGEN-Phase 3 SR-589 : shan 11.18.2013
					}

					if (result.vPopWcommInvPerils == "Y" || $("chkNbtRetOrig").checked) {
						deleteAllWcominvperRecords(wcommInvoice.intermediaryNo);
						populateWcommInvPerils(wcommInvoice);
					}

					if (result.vDelWcommInvPerils == "Y") {
						deleteWcommInvPerils(wcommInvoice.intermediaryNo);
					}

					if (result.vMsgAlert2 == "Y") {
						showMessageBox("No data found on giac_parameters for parameter 'SHOW_COMM_AMT'", imgMessage.INFO);
						ok = false;
						return;
					}

					if (parseFloat(nvl(String(result.vSetItmProp1, "0"))) == 1) {
						$("txtPerilCommissionRt").readOnly = true;
						$("txtPerilCommissionAmt").readOnly = true;
					} else if (parseFloat(nvl(String(result.vSetItmProp1, "0"))) == 2) {
						$("txtPerilCommissionRt").readOnly = true;
					}

					if (parseFloat(nvl(String(result.vSetItmProp2, "0"))) == 1) {
						$("txtPerilCommissionRt").readOnly = true;
						$("txtPerilCommissionAmt").readOnly = true;
					} else if (parseFloat(nvl(String(result.vSetItmProp2, "0"))) == 2) {
						$("txtPerilCommissionRt").readOnly = false;
						$("txtPerilCommissionAmt").readOnly = false;
					}

					if (result.vGoItem == "Y") {
						$("txtPerilCommissionRt").focus();
					}

					if (result.vComputeTotCom == "Y") {
						computeTotCom(wcommInvoice);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});

		return ok;
	}

	// gets the :WCOMINV.v_share_percentage value
	function getVSharePercentage(intmNo) {
		var vSharePercentage = 0;

		for (var i = 0; i < wcominv.length; i++) {
			if (wcominv[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominv[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
					&& wcominv[i].intermediaryNo == intmNo
					&& wcominv[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
					&& (wcominv[i].recordStatus == null || wcominv[i].recordStatus >= 0)) {
				vSharePercentage = vSharePercentage + parseFloat(wcominv[i].sharePercentage);
			}
		}

		return 100 - vSharePercentage;
	}

	// gets the V_OTHER_PREM value
	function getVOtherPrem(perilCd) {
		var vOtherPrem = 0;
		
		for (var i = 0; i < wcominvper.length; i++) {
			if (wcominvper[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
					&& wcominvper[i].perilCd == perilCd
					&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
					&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
				vOtherPrem = vOtherPrem + parseFloat(wcominvper[i].premiumAmount);
			}
		}

		return vOtherPrem;
	}

	// get default tax rate (for varTaxAmt) for specified intermediary
	function getDefaultTaxRate(intmNo) {
		var wtaxRate = 0;
		
		new Ajax.Request(contextPath+"/GIISIntermediaryController?action=getDefaultTaxRate", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				intmNo: nvl(intmNo, "0")
			},
			onComplete: function(response) {
				if (checkErrorOnResponse) {
					if (response.responseText.blank() || !isNaN(response.responseText)) {
						wtaxRate = parseFloat(response.responseText);
					} else {
						wtaxRate = 0;
					}
				}
			}
		});

		return wtaxRate;
	}

	function saveWcommInvoice() {
		if (!hasChanges()) {
			showMessageBox("No changes to save.", imgMessage.INFO);
		} else if (getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId) < 100) { 
			showMessageBox("Total Share Percentage per group must be equal to 100%.", imgMessage.INFO);
			$("txtItemGrp").value = prevItemGrp;
		} else {
			var objParameters = new Object();
			var delWcominv = [];
			var delWcominvper = [];
			var strParam;
			
			// wcominv
			var addedWcominvRows = getAddedJSONObjects(wcominv);
			var modifiedWcominvRows = getModifiedJSONObjects(wcominv);
			var delWcominvRows = getDeletedJSONObjects(wcominv);
			var setWcominvRows = addedWcominvRows.concat(modifiedWcominvRows);
			
			// wcominvper
			var addedWcominvperRows = getAddedJSONObjects(wcominvper);
			var modifiedWcominvperRows = getModifiedJSONObjects(wcominvper);
			var delWcominvperRows = getDeletedJSONObjects(wcominvper);
			var setWcominvperRows = addedWcominvperRows.concat(modifiedWcominvperRows);

			objParameters.setWcominvRows = setWcominvRows;
			objParameters.setWcominvperRows = setWcominvperRows;
			objParameters.delWcominvRows = delWcominvRows;
			objParameters.delWcominvperRows = delWcominvperRows;
			
			objParameters.parId = $F("txtB240ParId");
			objParameters.coinsurerSw = '${coinsurerSw}';

			strParam = JSON.stringify(objParameters);
			
			new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=saveWcommInvoice", {
				evalScripts: true,
				asynchronous: false,
				parameters: {
					strParameters: strParam
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						if(nvl(isPack, "N") == "Y") {
							new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=getPackParlistParams", {
								evalScripts: true,
								asynchronous: false,
								parameters: {
									parId: $F("globalPackParId") == "" ? objUWGlobal.packParId : $F("globalPackParId")
								},
								onComplete: function(response) {
									if (checkErrorOnResponse(response)) {
										packParlistParams = eval(response.responseText);	
									}
								}
							});
						}
						
						//updateParParameters(); // commented by tonio 07/15/2011 andrew - 05.16.2011
						//Added by Tonio 07-11-2011
						if (($F("globalPackParId") != "" || $F("globalPackParId") != null) && $F("globalPackParId") > 0){
							updatePackParParameters();
						}else{
							updateParParameters();
						}
						
						parameters = "";
						
						for (var i = 0; i < wcominv.length; i++) {
							if (wcominv[i].recordStatus == 0 || wcominv[i].recordStatus == 1) {
								wcominv[i].recordStatus = null;
							} else if (wcominv[i].recordStatus == -1) {
								wcominv[i].recordStatus = -2;
							}
						}

						for (var i = 0; i < wcominvper.length; i++) {
							if (wcominvper[i].recordStatus == 0 || wcominvper[i].recordStatus == 1) {
								wcominvper[i].recordStatus = null;
							} else if (wcominvper[i].recordStatus == -1) {
								wcominvper[i].recordStatus = -2;
							}
						}
						
						changeTag = 0;
						showInvoiceCommissionPage(); //added by d.alcantara, nagkakaproblem kasi kung magupdate ng records agad after magsave
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	}

	function cancelFuncWcommInvoice() {
		try {
			if (isPack == "Y") {
				goBackToPackagePARListing();
			}else{
				goBackToParListing();
			}
			/*Effect.Fade("parInfoDiv", {
				duration: .001,
				afterFinish: function () {
					if ($("parListingMainDiv").down("div", 0).next().innerHTML.blank()) {
						if($F("globalParType") == "E"){
							showEndtParListing();
						}else{							
							showParListing();
						}
					} else {
						$("parInfoMenu").hide();
						Effect.Appear("parListingMainDiv", {duration: .001});
					}
					$("parListingMenu").show();
				}
			});*/ // replaced by: Nica 11.23.2011 
		} catch (e) {
			showErrorMessage("cancelFuncWcommInvoice", e);
		}
	}

	// checks if changes have been made
	function hasChanges() {
		var result = false;
		for (var i = 0; i < wcominv.length; i++) {
			if (wcominv[i].recordStatus == 0 || wcominv[i].recordStatus == 1 || wcominv[i].recordStatus == -1) {
				result = true;
				break;
			}
		}

		if (!result) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].recordStatus == 0 || wcominvper[i].recordStatus == 1 || wcominvper[i].recordStatus == -1) {
					result = true;
					break;
				}
			}
		}

		return result;
	}

	function checkAndDeleteWcominvIfExisting(intmNo) {
		intmNo = parseInt(nvl(intmNo, "0"));
		for (var i = 0; i < wcominv.length; i++) {
			if (wcominv[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominv[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
					&& wcominv[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
					&& wcominv[i].intermediaryNo == intmNo) {
				deleteWcominvRow(i);
				$$("div[name='rowWcominv']").each(function (row) {
					if (row.down("input", 0).value == i) {
						removeWcominvRecord(row);
					}
				});
				break;
			}
		}
	}

	/** end of page functions **/
	
	/** item field triggers/validations **/
	
	$("btnSave").observe("click", function() {
		/*if (hasUnsavedChanges()) {
			showMessageBox("Please save changes first.", imgMessage.INFO);
		} else {*/
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO);
			//objUW.hidObjGIPIS002.forSaving = false;
			return;
		} else if ('${coinsurerSw}' == "Y") {
			showWaitingMessageBox("Records in Co-Insurance will be deleted because Invoice Commission was updated.", imgMessage.INFO, saveWcommInvoice);
		} else {
			saveWcommInvoice();
		}
		//}
	});

	$("btnCancel").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){saveWcommInvoice(); /*cancelFuncWcommInvoice();*/}, cancelFuncWcommInvoice, "");
		} else {
			cancelFuncWcommInvoice();
		}
	});
	
	/*$("txtItemGrp").observe("change", function() {
		validateItemGrp();
	});

	$("txtTakeupSeqNo").observe("change", function() {
		validateTakeupSeqNo();
	});*/

	$("btnShowBancaDetails").observe("click", function() {
		if ($("bancaDtlDiv").style.display == "none") {
			showBancaDetails();
		} else {
			hideBancaDetails();
		}
	});
	
	//apollo cruz 10.27.2014
	function applyBancassurance(){
		var index = 0;
		var wcommInvoice = new Object();
		
		function start(){
				
			if (index < bancaB.length){
				wcommInvoice = {};				
				wcommInvoice.parId = b240[selectedB240Index].parId;
				wcommInvoice.intermediaryNo = bancaB[index].intmNo;
				wcommInvoice.intermediaryName = bancaB[index].intmName;
				wcommInvoice.parentIntermediaryNo = bancaB[index].parentIntmNo;
				wcommInvoice.parentIntermediaryName = bancaB[index].parentIntmName;
				wcommInvoice.sharePercentage = (bancaB[index].sharePercentage == null) ? null : parseFloat(bancaB[index].sharePercentage);
				wcommInvoice.premiumAmount = 0;
				wcommInvoice.commissionAmount = 0;
				wcommInvoice.netCommission = 0;
				wcommInvoice.withholdingTax = 0;
				wcommInvoice.nbtIntmType = null;
				wcommInvoice.intmNoNbt = parseInt(nvl(bancaB[index].intmNo, "0"));
				wcommInvoice.sharePercentageNbt = (bancaB[index].sharePercentage == null) ? null : parseFloat(bancaB[index].sharePercentage);
				wcommInvoice.itemGroup = parseInt(nvl($F("txtItemGrp"), "0"));
				wcommInvoice.takeupSeqNo = parseInt(nvl($F("txtTakeupSeqNo"), "0"));
				wcommInvoice.recordStatus = 0;
				validate(wcommInvoice);		
			} else {
				done();
			}
		}
		
		function add(){
			if (executeBancassuranceGetDefaultTaxRt(wcommInvoice, null, "INSERT")) {
				wcominvListTableGrid.createNewRow(wcommInvoice);
				index++;
				start();
			}
		}
		
		function add(){
			if (executeBancassuranceGetDefaultTaxRt(wcommInvoice, null, "INSERT")) {
				wcommInvoice.recordStatus = 0;
				if (wcominv.length > 0) {
					addWcominvRecord(wcommInvoice);
				} else {
					if (wcominv == null) {
						wcominv = new Array();
					}
					addWcominvRecord(wcommInvoice);
				}
				//displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "");
				index++;
				start();
			}
		}
		
		function done(){
			displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "");
			resetWcominvFields();
			resetWcominvperFields();
			enableWcominvperFields();
			hidePerilDiv();
			hideBancaDetails();
			
			enableSearch("oscmIntm");
			enableButton("btnSaveIntm");
			$("txtSharePercentage").readOnly = false;
		}
		
		function validate(wcommInvoice) {
			new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=validateGipis085IntmNo", {
				method: "GET",
				asynchronous: false, 
				evalScripts: true,
				parameters: {
					parId: b240[selectedB240Index].parId,
					intmNo: wcommInvoice.intermediaryNo,
					nbtIntmType: wcommInvoice.nbtIntmType,
					assdNo: b240[selectedB240Index].assdNo,
					lineCd: b240[selectedB240Index].lineCd,
					parType: b240[selectedB240Index].parType,
					drvParSeqNo: b240[selectedB240Index].drvParSeqNo,
					vLovTag: ""
				},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();						
						if (result.msgAlert == "ISS_CD_NOT_MATCH") {						
							showConfirmBox("", "The issuing source of this intermediary is '" + result.issName + ". Do you want to continue?",
								"Yes", "No", add, function(){
													index++;
													start();
												}
							);
						} else
							add();
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		start();
	}
	
	$("btnBancaApply").observe("click", function() {		
		var isIntmComplete = true;
		
		for (var i = 0; i < bancaB.length; i++) {
			if(bancaB[i].intmNo == null || bancaB[i].intmNo == ""){
				isIntmComplete = false;
				break;
			}				
		}
		
		if(!isIntmComplete){
			showMessageBox("Item Group without Intermediary still exists.", imgMessage.INFO);
			return;
		}
		
		deleteAllWcominvRecords();
		deleteAllWcominvperRecords2();
		varBancRateSw = "Y";
		
		applyBancassurance();		
	});

	/* $("btnBancaApply").observe("click", function() {
		
		//apollo cruz 09.24.2014 - checks bancassurance details with no intermediary
		var isIntmComplete = true;
		
		for (var i = 0; i < bancaB.length; i++) {
			if(bancaB[i].intmNo == null || bancaB[i].intmNo == ""){
				isIntmComplete = false;
				break;
			}				
		}
		
		if(!isIntmComplete){
			showMessageBox("Item Group without Intermediary still exists.", imgMessage.INFO);
			return;
		}
		
		deleteAllWcominvRecords();
		deleteAllWcominvperRecords2();
		varBancRateSw = "Y";
		var intmNoOk = true;

		for (var i = 0; i < bancaB.length; i++) {
			var wcommInvoice = new Object();
			var count = 0;
			var recordStatus = "INSERT";
			wcommInvoice.parId = b240[selectedB240Index].parId;
			wcommInvoice.intermediaryNo = bancaB[i].intmNo;
			wcommInvoice.intermediaryName = bancaB[i].intmName;
			wcommInvoice.parentIntermediaryNo = bancaB[i].parentIntmNo;
			wcommInvoice.parentIntermediaryName = bancaB[i].parentIntmName;
			wcommInvoice.sharePercentage = (bancaB[i].sharePercentage == null) ? null : parseFloat(bancaB[i].sharePercentage);
			wcommInvoice.premiumAmount = 0;
			wcommInvoice.commissionAmount = 0;
			wcommInvoice.netCommission = 0;
			wcommInvoice.withholdingTax = 0;
			wcommInvoice.nbtIntmType = null;
			wcommInvoice.intmNoNbt = parseInt(nvl(bancaB[i].intmNo, "0"));
			wcommInvoice.sharePercentageNbt = (bancaB[i].sharePercentage == null) ? null : parseFloat(bancaB[i].sharePercentage);
			wcommInvoice.itemGroup = parseInt(nvl($F("txtItemGrp"), "0"));
			wcommInvoice.takeupSeqNo = parseInt(nvl($F("txtTakeupSeqNo"), "0"));

			intmNoOk = validateIntmNo(wcommInvoice);

			if (intmNoOk) {
				if (executeBancassuranceGetDefaultTaxRt(wcommInvoice, null, recordStatus)) {
					var index = 0; //tag record as added
					wcommInvoice.recordStatus = 0;
					if (wcominv.length > 0) {
						index = wcominv.length;
						addWcominvRecord(wcommInvoice);
					} else {
						index = 0;
						if (wcominv == null) {
							wcominv = new Array();
						}
						addWcominvRecord(wcommInvoice);
					}
					displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "");
				}
			}
		}

		displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "");
		resetWcominvFields();
		resetWcominvperFields();
		enableWcominvperFields();
		hidePerilDiv();
		hideBancaDetails();
		
		enableSearch("oscmIntm");
		enableButton("btnSaveIntm");
		$("txtSharePercentage").readOnly = false;
	}); */

	function saveIntm() {
		var wcommInvoice = new Object();
		var wcommInvoicePerils = new Array(); // this will contain the current list of WCOMINVPER records for selected/new WCOMINV record
		var count = 0;
		var recordStatus = (currentWcominvRowNo == -1) ? "INSERT" : "CHANGED";
		wcommInvoice.parId = b240[selectedB240Index].parId;
		wcommInvoice.intermediaryNo = parseInt(nvl($F("txtIntmNo"), "0"));
		wcommInvoice.intermediaryName = changeSingleAndDoubleQuotes2($F("txtIntmName"));
		wcommInvoice.parentIntermediaryNo = $F("txtParentIntmNo").blank() ? wcommInvoice.intermediaryNo : parseInt($F("txtParentIntmNo"));
		wcommInvoice.parentIntermediaryName = $F("txtParentIntmName").blank() ? wcommInvoice.intermediaryName : changeSingleAndDoubleQuotes2($F("txtParentIntmName"));
		wcommInvoice.sharePercentage = $F("txtSharePercentage").blank() ? 0 : parseFloat($F("txtSharePercentage").replace(/,/g,""));
		wcommInvoice.premiumAmount = $F("txtPremiumAmt").blank() ? 0 : parseFloat($F("txtPremiumAmt").replace(/,/g,""));
		wcommInvoice.commissionAmount = $F("txtCommissionAmt").blank() ? 0 : parseFloat($F("txtCommissionAmt").replace(/,/g,""));
		wcommInvoice.netCommission = $F("txtNetCommission").blank() ? 0 : parseFloat($F("txtNetCommission").replace(/,/g,""));
		wcommInvoice.withholdingTax = $F("txtWholdingTax").blank() ? 0 : parseFloat($F("txtWholdingTax").replace(/,/g,""));
		wcommInvoice.nbtIntmType = $F("txtNbtIntmType");
		wcommInvoice.intmNoNbt = parseInt(nvl($F("txtIntmNoNbt"), "0"));
		wcommInvoice.sharePercentageNbt = $F("txtSharePercentageNbt").blank() ? 0 : parseFloat($F("txtSharePercentageNbt").replace(/,/g,""));
		wcommInvoice.itemGroup = parseInt(nvl($F("txtItemGrp"), "0"));
		wcommInvoice.takeupSeqNo = parseInt(nvl($F("txtTakeupSeqNo"), "0"));

		wcommInvoice.parentIntmLicTag = $F("txtParentIntmLicTag");
		wcommInvoice.parentIntmSpecialRate = $F("txtParentIntmSpecialRate");
		/*added by christian 08.25.2012*/
		wcommInvoice.licTag = $F("txtLicTag");
		wcommInvoice.specialRate = $F("txtSpecialRate");
		
		if (wcominvper.length > 0 && currentWcominvRowNo > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(wcominv[currentWcominvRowNo].intermediaryNo, "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					wcommInvoicePerils[count] = wcominvper[i];
					count++;
				}
			}
		}

		// added by emman - to check if record is still recently added (do not change recordStatus to "CHANGED") 04.14.2011 
		if ($("btnSaveIntm").value == "Update") {
			if (wcominv[currentWcominvRowNo].recordStatus == 0) {
				recordStatus = "INSERT";
			}
		}

		// set default tax rate (emman 09.09.2011)
		if (nvl(wcommInvoice.intermediaryNo, null) != null) {
			varTaxAmt = getDefaultTaxRate(wcommInvoice.intermediaryNo);
		}
		
		if (executeBancassuranceGetDefaultTaxRt(wcommInvoice, wcommInvoicePerils, recordStatus)) {
			if ($("btnSaveIntm").value == "Update") {
				//tag record as update/modified
				if (wcominv[currentWcominvRowNo].recordStatus == 0) {
					wcommInvoice.recordStatus = 0;
				} else {
					wcommInvoice.recordStatus = 1;
				}
				
				if (currentWcominvRowNo >= 0) {
					var content = generateWcommInvoiceContent(wcommInvoice, currentWcominvRowNo);
					wcominv[currentWcominvRowNo] = wcommInvoice;
					selectedWcominvRow.update(content);
				}
				//
				populateWcominvDetails(currentWcominvRowNo);
				//added line 1648-1657 to reset fields after updating invoice commission info record
				displayWcominvperRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), wcommInvoice.intermediaryNo);
				currentWcominvRowNo = -1;
				selectedWcominvRow = null;
				resetWcominvFields();
				resetWcominvperFields();
				enableWcominvperFields();
				hidePerilDiv();
				$("btnSaveIntm").value = "Add";
				disableButton($("btnDeleteIntm"));
				$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId)), 7); 
				//clickWcominv(selectedWcominvRow); //disselect row
				
				//apollo 09.24.2014 - deselect row after update
				$$("div#wcominvTableContainer div[name='rowWcominv']").each(function(r) {
					r.removeClassName("selectedRow");
				});
				
			} else if ($("btnSaveIntm").value == "Add") {
				//tag record as added
				var index = 0;
				wcommInvoice.recordStatus = 0;
				if (wcominv.length > 0) {
					index = wcominv.length;
					addWcominvRecord(wcommInvoice);
				} else {
					index = 0;
					if (wcominv == null) {
						wcominv = new Array();
					}
					addWcominvRecord(wcommInvoice);
				}
				displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "");					
				resetWcominvFields();
				resetWcominvperFields();
				$("txtSharePercentage").value = formatToNthDecimal(((100 - getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId))).toPrecision(12), 7);//Apollo Cruz 09.12.2014
			}
		}
		changeTag = 1;
	}
	
	$("btnSaveIntm").observe("click", function(){
		var totalPercentage = getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId);  //added by steven 9/20/2012
		var sharePercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), "0"));
		
		if ($("btnSaveIntm").value == "Add") {
			shareVal2 = (100 - totalPercentage.toPrecision(12)).toPrecision(12);
		} else if ($("btnSaveIntm").value == "Update") {
			shareVal2 = (100 - totalPercentage.toPrecision(12) + sharePercentage.toPrecision(12));
			shareVal2 = parseFloat(shareVal2).toPrecision(12);
		}
		
		if ($F("txtIntmNo").blank() || $F("txtSharePercentage").blank()) {
			showMessageBox("Please fill up the required fields.", imgMessage.ERROR);
		}else if(parseFloat($("txtSharePercentage").value) == 0){
			customShowMessageBox("Enter value for Share Percentage.", "I", "txtSharePercentage");
		}else if ($("btnSaveIntm").value == "Add" && totalPercentage == 100) {
			showMessageBox("Share percentage is already 100%.", imgMessage.ERROR);			
			$("txtSharePercentage").value = formatToNthDecimal(0, 7);
		} else if(sharePercentage > shareVal2 && parseFloat(shareVal2) != 0) {
			showMessageBox("Share Percentage should not exceed " + parseFloat(shareVal2) + "%.", imgMessage.ERROR);
			$("txtSharePercentage").value = formatToNthDecimal(shareVal2, 7);
		} else {
			/* if ($("chkNbtRetOrig").checked && $F("txtIntmNo") != '${dfltIntmNo}'){
				showConfirmBox("", "Intermediary No. " + $F("txtIntmNo") + " is not included in the list of default intermediaries for this assured/policy. Continue?",
						"Yes", "No", saveIntm);
			} else {
				saveIntm();
			} */
			saveIntm();
		}
	});

	$("btnDeleteIntm").observe("click", function() {
		if (currentWcominvRowNo < 0) {
			return false;
		}

		// tag the record as deleted. if previously added, mark as -2
		deleteWcominvRow(currentWcominvRowNo);
		deleteAllWcominvperRecords(wcominv[currentWcominvRowNo].intermediaryNo);

		// delete the record from the main container div
		var row = $("wcominvRow"+currentWcominvRowNo);
		Effect.Fade(row, {
			duration: .2,
			afterFinish: function() {
				currentWcominvRowNo = -1;
				selectedWcominvRow = null;
				//$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
				row.remove();
				currentWcominvRowNo = -1;
				selectedWcominvRow = null;
				resetWcominvFields();
				resetWcominvperFields();
				removeAllWcominvperRecords();
				enableWcominvperFields();
				hidePerilDiv();
				$("btnSaveIntm").value = "Add";
				disableButton($("btnDeleteIntm"));
				disableButton($("btnSavePeril"));
				$("txtSharePercentage").value = formatToNthDecimal(((100 - getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId))).toPrecision(12), 7);

				changeTag = 1;
			}
		});

		checkIfToResizeTable("wcominvTableContainer", "rowWcominv");
		checkTableIfEmpty("rowWcominv", "wcominvTableMainDiv");
		checkIfToResizeTable("wcominvperTableContainer", "rowWcominvper");
		checkTableIfEmpty("rowWcominvper", "wcominvperTableMainDiv");
	});

	$("oscmIntm").observe("click", function() {
		if (currentWcominvRowNo == -1 && !nvl($F("txtItemGrp"),"").blank() && !nvl($F("txtTakeupSeqNo"),"").blank()) {
/*  			 Modalbox.show(contextPath+"/GIISIntermediaryController?action=openSearchGipis085IntmListing&intmLOVName="+wcominvIntmNoLov, 
					  {title: "List of Intermediary", 
					  width: 921,
					  asynchronous: false});  */
					  
			// andrew - 02.14.2012 - replaced the lov
			// moved to underwriting-lov.js; function showGIPIS085IntermediaryLOV
  			/* LOV.show({ 
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getGIPIS085IntermediaryLOV",
								parId : objUWGlobal.packParId != null ? b240[selectedB240Index].parId : objGIPIWPolbas.parId,
								assdNo : objGIPIWPolbas.assdNo,
								lineCd : objUWGlobal.packParId != null ? b240[selectedB240Index].lineCd : objGIPIWPolbas.lineCd,
								parType : objUWParList.parType,
								defaultIntm : $("chkLovTag").checked,
								page : 1},
				title: "Intermediary",
				width: 700,
				height: 380,
				columnModel : [	{	id : "intmName",
									title: "Intermediary Name",
									width: '380px'
								},
								{	id : "intmNo",
									title: "Intermediary No.",
									align: 'right',
									width: '120px'
								},
								{	id : "refIntmCd",
									title: "Ref. Intermediary Cd",
									width: '150px'
								}
							],
				draggable: true,
				onSelect: function(row){
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = row.intmName;
					$("txtParentIntmNo").value = row.parentIntmNo;
					$("txtParentIntmName").value = row.parentIntmName;
					$("txtIntmActiveTag").value = row.activeTag;
					$("txtDspIntmName").value = row.intmNo + " - " + row.intmName;
					$("txtDspParentIntmName").value = row.parentIntmNo != null ? row.parentIntmNo + " - " + row.parentIntmName : ""; 
					$("isIntmOkForValidation").value = "Y"; 
					$("txtDspIntmName").focus();
				}
			  }); */
			  
			var parId = objUWGlobal.packParId != null ? b240[selectedB240Index].parId : objGIPIWPolbas.parId;
			var assdNo = objGIPIWPolbas.assdNo;
			var lineCd = objGIPIWPolbas.lineCd; /*objUWGlobal.packParId != null ? b240[selectedB240Index].lineCd : objGIPIWPolbas.lineCd;*/ //benjo 09.07.2016 SR-5604
			var parType = objUWParList.parType;
			var defaultIntm = $("chkLovTag").checked;
			var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;
			if("4" == polFlag && parType == "E"){ // added by: steven 10/08/2012 - to check if Endt. PAR is a cancelled endt	
				defaultIntm = true; 
			}
			var notIn = "";
			var withPrevious = false;
			$$("div#wcominvTableContainer div[name='rowWcominv']").each(function(r) {
				notIn += withPrevious ? "," : "";
				notIn += r.down("input",1).value;
				withPrevious = true;
			});
			notIn = notIn != "" ? "("+notIn+")" : 0;
			
			showGIPIS085IntermediaryLOV(parId, assdNo, lineCd, parType, defaultIntm, notIn, polFlag); //Apollo Cruz 11.13.2014 - added polFlag
		}
	});

	// this is for the banca_details intermediary
	$("oscmIntermediary").observe("click", function ()	{
		if (currentBancaBRowNo >= 0) {
			if (!$("chkBancaFixedTag").checked) {
				openSearchBancaIntermediary();
			} else {
				showMessageBox("This item may not be updated.", imgMessage.INFO);
			}
		}
	});
	
	$("chkLovTag").observe("change", function() {
		/* benjo 09.07.2016 SR-5604 */
		if(reqDfltIntmPerAssd == "Y" && override == "Y"){
			showConfirmBox("Confirmation", "Update of default intermediary is not allowed. Would you like to override?", "Yes", "No", 
					function(){
						showGenericOverride("GIPIS085", "OV",
								function(ovr, userId, result){
									if(result == "FALSE"){
										showMessageBox(userId + " is not allowed to Override.", imgMessage.ERROR);
										$("txtOverrideUserName").clear();
										$("txtOverridePassword").clear();
										return false;
									}else if(result == "TRUE"){
										override = "N";
										ovr.close();
										delete ovr;
										
										if($F("btnSaveIntm") == "Update"){
											$("chkLovTag").checked = !$("chkLovTag").checked;
											return;
										}
										
										if ($("chkLovTag").checked) {
											$("chkLovTag").value = "FILTERED";
											wcominvIntmNoLov = "cgfk$wcominvDspIntmName";
										} else {
											$("chkLovTag").value = "UNFILTERED";
											wcominvIntmNoLov = "cgfk$wcominvDspIntmName5";
										}
									}
								},
								function(){
									$("chkLovTag").checked = !$("chkLovTag").checked;
									return;
								},
								null);
					},
					function(){
						$("chkLovTag").checked = !$("chkLovTag").checked;
						return;
					},
					"");
		}else{
			if($F("btnSaveIntm") == "Update"){
				$("chkLovTag").checked = !$("chkLovTag").checked;
				return;
			}
			
			if ($("chkLovTag").checked) {
				$("chkLovTag").value = "FILTERED";
				wcominvIntmNoLov = "cgfk$wcominvDspIntmName";
			} else {
				$("chkLovTag").value = "UNFILTERED";
				wcominvIntmNoLov = "cgfk$wcominvDspIntmName5";
			}
		}
	});

	$("chkNbtRetOrig").observe("change", function() {
		if ($("chkNbtRetOrig").checked) {
			$("chkNbtRetOrig").value = "Y";
		} else {
			$("chkNbtRetOrig").value = "N";
		}
	});

	$("txtDspIntmName").observe("focus", function() {
		if ($F("isIntmOkForValidation") == "Y") {
			var intmNo = parseInt(nvl($F("txtIntmNo"), "0"));
			var exists = false;
			
			$("isIntmOkForValidation").value = "N";
			
			if ($F("txtIntmActiveTag") != "A") {
				showMessageBox("Intermediary no. is not tagged Active in maintenance.", imgMessage.INFO);
				clearIntmFields();
				return;
			}

			/*if (vParType == "E" && (nvl(globalCancelTag, "N") == "Y") || vPolFlag == 4) {
				showMessageBox("Update of intermediary/agent is not allowed during cancellation endorsement.", imgMessage.INFO);
				clearIntmFields();
			}*/ // (removed - emman 09.09.2011)

			for (var i = 0; i < wcominv.length; i++) {
				if (wcominv[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominv[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominv[i].intermediaryNo == intmNo
						&& wcominv[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& (wcominv[i].recordStatus == null || wcominv[i].recordStatus >= 0)) {
					exists = true;
					break;
				}
			}

			if (exists) {
				showMessageBox("Intermediary must be unique.", imgMessage.INFO);
				clearIntmFields();
				return;
			}

			varSwitchNo = "Y";

			// create WCOMINV object first
			var wcommInvoice = new Object();
			wcommInvoice.intermediaryNo = $F("txtIntmNo");
			wcommInvoice.nbtIntmType = $F("txtNbtIntmType");
			
			validateIntmNo(wcommInvoice);

			// save nbtIntmType value to text
			$("txtNbtIntmType").value = wcommInvoice.nbtIntmType;

			checkRequiredWcominvFieldsBeforeSaving();
		}
	});

	$("txtBancaDrvIntmName").observe("focus", function() {
		if ($F("isBancaIntmOkForValidation") == "Y") {
			var content = "";
			$("isBancaIntmOkForValidation").value = "N";

			bancaB[currentBancaBRowNo].intmNo = parseInt(nvl($F("txtBancaIntmNo"), "0"));
			bancaB[currentBancaBRowNo].intmName = changeSingleAndDoubleQuotes2($F("txtBancaIntmName"));
			
			content = generateBancTypeDtlContent(bancaB[currentBancaBRowNo], currentBancaBRowNo);
			
			selectedBancaBRow.update(content);
		}
	});

	$("txtSharePercentage").observe("focus", function() {
		prevSharePercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), 0));
		if (!$F("txtIntmNo").blank()) {
			varSharePercentage = $F("txtSharePercentage");
			$("txtSharePercentageNbt").value = $F("txtSharePercentage");
		}
	});

	$("txtSharePercentage").observe("change", function() {
		if (isNaN($F("txtSharePercentage").replace(/,/g,""))||$F("txtSharePercentage") > 100||$F("txtSharePercentage") < 0) {
			showMessageBox("Invalid share percentage. Value  must be from 0.000000001 to 100.000000000", imgMessage.ERROR);
			$("txtSharePercentage").value = "";
			return;
		/*} else if(sharePercentage > shareVal) {
			if (wcominv.length>1){
				showMessageBox("Share Percentage should not exceed " + parseFloat(shareVal) + "%!", imgMessage.ERROR);
				$("txtSharePercentage").value = "";
			}
			return;*/
		} else if (vParType == "E" && vEndtTax == "Y") {
			disableButton("btnSaveIntm");
		} else {
			var shareVal = 0;
			var totalPercentage = getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId);
			var sharePercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), "0"));
			if ($("btnSaveIntm").value == "Add") {
				shareVal = 100 - totalPercentage;
			} else if ($("btnSaveIntm").value == "Update") {
				shareVal = 100 - totalPercentage + wcominv[currentWcominvRowNo].sharePercentage;
			}

			if ($("btnSaveIntm").value == "Add" && totalPercentage == 100) {
				showMessageBox("Share percentage is already 100%.", imgMessage.ERROR);			
				$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
				return;
			}else if(sharePercentage > shareVal && parseFloat(shareVal) != 0) {
				showMessageBox("Share Percentage should not exceed " + parseFloat(shareVal) + "%.", imgMessage.ERROR);			
				$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
				return;
			}else if(sharePercentage == ""||sharePercentage == null||sharePercentage == 0 ) {
				showMessageBox("Please fill up the required fields.", imgMessage.ERROR);
				return false;
			}/*  else if(sharePercentage < 0) {
				showMessageBox("Share Percentage should be greater than 0%!", imgMessage.ERROR);
				$("txtSharePercentage").value = formatToNthDecimal(prevSharePercentage, 7);
				return;
			} */else {
				$("txtSharePercentage").value = formatToNthDecimal($F("txtSharePercentage").replace(/,/g,""), 7);
				prevSharePercentage = parseFloat(nvl($F("txtSharePercentage").replace(/,/g,""), 0));
				checkRequiredWcominvFieldsBeforeSaving();
			}
		}
	});

	$("txtPerilCommissionRt").observe("focus", function() {
		if(prevPerilCommissionRt == "" || prevPerilCommissionAmt == ""){
			prevPerilCommissionRt = parseFloat(nvl($F("txtPerilCommissionRt").replace(/,/g,""), "0"));
			prevPerilCommissionAmt = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
		}
	});

	$("txtPerilCommissionRt").observe("change", function() {
		var commRate = parseFloat(nvl($F("txtPerilCommissionRt").replace(/,/g,""), "0"));
		if ($F("txtPerilCommissionRt").blank()) {
			return;
		} else if ((isNaN(commRate))||(commRate < 0) || (commRate > 100)) {
			showMessageBox("Invalid Rate. Value must be from 0.00 to 100.0000000");
			$("txtPerilCommissionRt").value = formatToNthDecimal(nvl(prevPerilCommissionRt, "0"), 7);
		} else {
			var wcommInvoicePeril = new Object();

			//save the values of WCOMINVPER text fields to a WCOMINVPER Object
			wcommInvoicePeril.intermediaryIntmNo = parseInt(nvl($F("txtIntmNo"), "0"));
			wcommInvoicePeril.premiumAmount = parseFloat(nvl($F("txtPerilPremiumAmt").replace(/,/g,""),"0"));
			wcommInvoicePeril.commissionRate = parseFloat(nvl($F("txtPerilCommissionRt").replace(/,/g,""),"0"));
			wcommInvoicePeril.commissionAmount = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""),"0"));
			wcommInvoicePeril.withholdingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""),"0"));
			wcommInvoicePeril.netCommission = parseFloat(nvl($F("txtPerilNbtCommissionAmt").replace(/,/g,""),"0"));
			wcommInvoicePeril.nbtCommissionRtComputed = ($F("txtPerilNbtCommissionRtComputed").blank()) ? null : parseFloat(nvl($F("txtPerilNbtCommissionRtComputed").replace(/,/g,""),"0"));

			if(valCommRate(wcommInvoicePeril)){
							
				validateWcominvperCommissionRate(wcommInvoicePeril);
				
				//change the WCOMINVPER text field values
				$("txtPerilPremiumAmt").value = formatCurrency(parseFloat(nvl(wcommInvoicePeril.premiumAmount, "0")));
				$("txtPerilCommissionAmt").value = formatCurrency(parseFloat(nvl(wcommInvoicePeril.commissionAmount, "0")));
				$("txtPerilWholdingTax").value = formatCurrency(parseFloat(nvl(wcommInvoicePeril.withholdingTax, "0")));
				$("txtPerilNbtCommissionAmt").value = formatCurrency(parseFloat(nvl(wcommInvoicePeril.netCommission, "0")));
				prevPerilCommissionRt = parseFloat(nvl($F("txtPerilCommissionRt").replace(/,/g,""), "0"));
				prevPerilCommissionAmt = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
				$("txtPerilCommissionRt").value = formatToNthDecimal(prevPerilCommissionRt, 7);
			}
		}
	});

	$("txtPerilCommissionAmt").observe("focus", function() {
		if(prevPerilCommissionRt == "" || prevPerilCommissionAmt == ""){
			prevPerilCommissionRt = parseFloat(nvl($F("txtPerilCommissionRt").replace(/,/g,""), "0"));
			prevPerilCommissionAmt = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
		}
	});

	$("txtPerilCommissionAmt").observe("change", function() {
		var commAmt = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
		var premAmt = parseFloat(nvl($F("txtPerilPremiumAmt").replace(/,/g,""), "0"));
		var maxAmt = parseFloat(9999999999.99); //added by robert 11.19.13
		//if(recordStatus != null ){
			if ($F("txtPerilCommissionRt").blank()) {
				return;
			//} else if ((isNaN(commAmt))|| commAmt<0 ||commAmt>=premAmt) {
			} else if ((isNaN(commAmt))|| commAmt<0 || commAmt>maxAmt) {	// modified condition by robert 11.19.13; removed commAmt>=premAmt
				showMessageBox("Invalid Commission Amount. Value must be from 0.00 to 9,999,999,999.99");
				$("txtPerilCommissionAmt").value = formatCurrency(nvl(prevPerilCommissionAmt, "0"));
			} else if (commAmt != 0 && premAmt != 0) {
				if (Math.abs(premAmt) >= Math.abs(commAmt)) {
					var wcommInvoicePeril = new Object();
		
					//save the values of WCOMINVPER text fields to a WCOMINVPER Object
					wcommInvoicePeril.intermediaryIntmNo = parseInt(nvl($F("txtIntmNo"), "0"));
					wcommInvoicePeril.premiumAmount = parseFloat(nvl($F("txtPerilPremiumAmt").replace(/,/g,""),"0"));
					wcommInvoicePeril.commissionRate = parseFloat(nvl($F("txtPerilCommissionRt").replace(/,/g,""),"0"));
					wcommInvoicePeril.commissionAmount = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""),"0"));
					wcommInvoicePeril.withholdingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""),"0"));
					wcommInvoicePeril.netCommission = parseFloat(nvl($F("txtPerilNbtCommissionAmt").replace(/,/g,""),"0"));
					wcommInvoicePeril.nbtCommissionRtComputed = ($F("txtPerilNbtCommissionRtComputed").blank()) ? null : parseFloat(nvl($F("txtPerilNbtCommissionRtComputed").replace(/,/g,""),"0"));
					validateWcominvperCommissionAmount(wcommInvoicePeril);
		
					//change the WCOMINVPER text field values
					$("txtPerilCommissionRt").value = formatToNthDecimal(parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")), 7);
					$("txtPerilWholdingTax").value = formatCurrency(parseFloat(nvl(wcommInvoicePeril.withholdingTax, "0")));
					$("txtPerilNbtCommissionAmt").value = formatCurrency(parseFloat(nvl(wcommInvoicePeril.netCommission, "0")));
					//prevPerilCommissionAmt = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
				} else {
					showWaitingMessageBox("Commission Amount must not be greater than Premium Amount.", imgMessage.INFO, function(){
						$("txtPerilCommissionAmt").value = formatCurrency(nvl(prevPerilCommissionAmt, "0"));
						$("txtPerilCommissionRt").value = formatToNthDecimal(prevPerilCommissionRt, 7);
					});
				}
			}
		//}
	});

	$("txtPerilWholdingTax").observe("focus", function() {
		prevPerilWholdingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""), "0"));
	});

	$("txtPerilWholdingTax").observe("change", function() {
		var perilWholdingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""), "0"));
		if ($F("txtPerilWholdingTax").blank()) {
			return;
		}else if(isNaN(perilWholdingTax)||perilWholdingTax<0){
			showMessageBox("Invalid Withholding Tax. Value must be from 0.00 to 9,999,999,999.99");
			$("txtPerilWholdingTax").value = formatCurrency(nvl(prevPerilWholdingTax, "0"));
		} else if (perilWholdingTax>parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"))){ //Apollo Cruz 09.12.2014
			showMessageBox("Invalid Withholding Tax. Value must not be greater than the Commission Amount.");
			$("txtPerilWholdingTax").value = formatCurrency(nvl(prevPerilWholdingTax, "0"));
		}else {
		
			var wcommInvoicePeril = new Object();

			//save the values of WCOMINVPER text fields to a WCOMINVPER Object
			wcommInvoicePeril.commissionAmount = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""),"0"));
			wcommInvoicePeril.withholdingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""),"0"));
			wcommInvoicePeril.netCommission = parseFloat(nvl($F("txtPerilNbtCommissionAmt").replace(/,/g,""),"0"));
			
			validateWcominvperWithholdingTax(wcommInvoicePeril);

			//change the WCOMINVPER text field values
			$("txtPerilNbtCommissionAmt").value = formatCurrency(parseFloat(nvl(wcommInvoicePeril.netCommission, "0")));
			prevPerilWholdingTax = parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""), "0"));
		}
	});

	$("btnSavePeril").observe("click", function() {
		if (selectedWcominvperRow != null) {
			var wcommInvoicePeril = wcominvper[currentWcominvperRowNo];
			var wcommInvoice = wcominv[currentWcominvRowNo];

			wcommInvoicePeril.premiumAmount 	= parseFloat(nvl($F("txtPerilPremiumAmt").replace(/,/g,""), "0"));
			wcommInvoicePeril.commissionRate 	= parseFloat(nvl($F("txtPerilCommissionRt").replace(/,/g,""), "0"));
			wcommInvoicePeril.commissionAmount 	= parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
			wcommInvoicePeril.withholdingTax 	= parseFloat(nvl($F("txtPerilWholdingTax").replace(/,/g,""), "0"));
			wcommInvoicePeril.netCommission 	= parseFloat(nvl($F("txtPerilNbtCommissionAmt").replace(/,/g,""), "0"));

			var content = generateWcommInvoicePerilContent(wcommInvoicePeril, currentWcominvperRowNo);
			selectedWcominvperRow.update(content);
			selectedWcominvperRow.removeClassName("selectedRow"); // andrew - 05.13.2011 - to remove the highlight after updating
			disableButton("btnSavePeril");
			computeTotCom(wcommInvoice);

			// save WCOMINV values
			$("txtSharePercentage").value = formatToNthDecimal(wcommInvoice.sharePercentage, 7);
			$("txtPremiumAmt").value = formatCurrency(parseFloat(nvl(wcommInvoice.premiumAmount)));
			$("txtCommissionAmt").value = formatCurrency(parseFloat(nvl(wcommInvoice.commissionAmount)));
			$("txtNetCommission").value = formatCurrency(parseFloat(nvl(wcommInvoice.netCommission)));
			$("txtWholdingTax").value = formatCurrency(parseFloat(nvl(wcommInvoice.withholdingTax)));

			var content = generateWcommInvoiceContent(wcommInvoice, currentWcominvRowNo);
			selectedWcominvRow.update(content);
			
			if (wcommInvoice.recordStatus == -2) {
				wcommInvoice.recordStatus = -2;
			} else if (wcommInvoice.recordStatus == 0) {
				wcommInvoice.recordStatus = 0;
			} else {
				wcommInvoice.recordStatus = 1;
			}

			if (wcommInvoicePeril.recordStatus == -2) {
				wcommInvoicePeril.recordStatus = -2;
			} else if (wcommInvoicePeril.recordStatus == 0) {
				wcommInvoicePeril.recordStatus = 0;
			} else {
				wcommInvoicePeril.recordStatus = 1;
			}

			resetWcominvperFields();
		}
	});

	/*$("reloadForm").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", 
					function(){saveWcommInvoice(); if (changeTag == 0){showInvoiceCommissionPage();}}, showInvoiceCommissionPage);
		} else {
			showInvoiceCommissionPage();
		}
	});*/ // replaced by: Nica 11.24.2011
	
	observeReloadForm("reloadForm", function(){
		changeTag = 0;
		showInvoiceCommissionPage();
	});

	/** end of item field triggers/validations **/
	
	/** oracle forms functions **/
	
	// the procedure UPDATE_WCOMM_INV_PERILS
	function updateWcommInvPerils(wcommInvoice) {
		var count = 0;
		
		for (var i = 0; i < wcominvper.length; i++) {
			if (wcominvper[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
					&& wcominvper[i].intermediaryIntmNo == wcommInvoice.intermediaryNo
					&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
					&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
				count = count + 1;
			}
		}
		
		if (count > 0) {
			var vOtherPrem = 0;
			var vPremiumAmt;
			var cnt = 0;

			$$("div[name='rowWcominvper']").each(function (row) {
				var c = row.down("input", 0).value;

				vPremiumAmt = parseFloat(nvl(wcominvper[c].premiumAmount, "0")) * 100 / parseFloat(nvl(varSharePercentage, "0"));
				
				if (parseFloat(nvl(wcommInvoice.sharePercentage, "0")) == parseFloat(nvl(varSharePercentage, "0"))) {
					if (cnt == 0 && parseFloat(nvl(wcominvper.premiumAmount, "0")) != 0) {
						vOtherPrem = getVOtherPrem(wcominvper[c].perilCd);
					} else if (cnt > 0) {
						vOtherPrem = getVOtherPrem(wcominvper[c].perilCd);
					}

					wcominvper[c].premiumAmount = vPremiumAmt - vOtherPrem;
				} else {
					wcominvper[c].premiumAmount = vPremiumAmt * parseFloat(nvl(wcommInvoice.sharePercentage, "0")) / 100;
				}

				wcominvper[c].withholdingTax = roundNumber(parseFloat(nvl(wcominvper[c].commissionAmount, "0")), 2) * parseFloat(nvl(varTaxAmt, "0")) / 100;

				// tag as updated
				wcominvper[c].recordStatus = 1;
			});

			//displayWcominvperRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), wcommInvoice.intermediaryNo);
		}
	}

	// The procedure POPULATE_WCOMM_INV_PERILS
	function populateWcommInvPerils(wcommInvoice) {
		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=populateWcommInvPerils", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				parId: b240[selectedB240Index].parId,
				lineCd: b240[selectedB240Index].lineCd,
				itemGrp: wcommInvoice.itemGroup
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var result = response.responseText.toQueryParams();

					if (result.message == "POPULATE_WCOMM_INV_PERILS") {
						new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=populateWcommInvPerils2", {
							method: "GET",
							asynchronous: false,
							evalScripts: true,
							parameters: {
								parId: b240[selectedB240Index].parId,
								itemGrp: wcommInvoice.itemGroup,
								takeupSeqNo: wcommInvoice.takeupSeqNo,
								lineCd: b240[selectedB240Index].lineCd
							},
							onComplete: function(response2) {
								if (checkErrorOnResponse(response2)) {
									var gipiWinvperlList = eval(response2.responseText);
									var vOtherPrem = 0;
									
									var slidingComm = "Y";									

									for (var i = 0; i < gipiWinvperlList.length; i++) {
										var wcommInvoicePeril = new Object(); // the new WCOMINVPER record to be added
										var premAmt = (gipiWinvperlList[i].premAmt == null) ? 0 : parseFloat(gipiWinvperlList[i].premAmt);
										varPerilCd = gipiWinvperlList[i].perilCd;

										wcommInvoicePeril.parId = b240[selectedB240Index].parId;
										wcommInvoicePeril.itemGroup = $F("txtItemGrp");
										wcommInvoicePeril.takeupSeqNo = $F("txtTakeupSeqNo");
										wcommInvoicePeril.intermediaryIntmNo = wcommInvoice.intermediaryNo;
										wcommInvoicePeril.recordStatus = 0; // newly added

										if (result.varIssCd.blank()) {
											showMessageBox("Parameter HO does not exist in giis parameters.", imgMessage.ERROR);
											return;
										}

										varIssCd = result.varIssCd;

										if (vOra2010Sw == "Y" && vValidateBanca == "Y" && varBancRateSw == "Y") {
											varRate = parseFloat(nvl($F("txtBancRate").replace(/,/g,""), "0"));
										} else {
											if (vAllowApplySlComm == "Y") {
												var appRes;
												
												// Get independent applyComm and Rate. added by irwin. 10.13.11 - from bonds
												new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=applySlidingCommission", {
													method: "GET",
													asynchronous: false,
													evalScripts: true,
													parameters: {
														parId: b240[selectedB240Index].parId,
														lineCd: b240[selectedB240Index].lineCd,
														sublineCd: b240[selectedB240Index].sublineCd,
														perilCd: varPerilCd,
														itemGrp : $F("txtItemGrp")
													},
													onComplete: function(r) {
														if (checkErrorOnResponse(r)) {
															if (!r.responseText.blank()) {
																appRes = r.responseText.toQueryParams();
																slidingComm = appRes.slidingComm;
																varRate = appRes.rate;
																//intmdryRate = parseFloat(response.responseText);
															}
														} else {
															showMessageBox(r.responseText, imgMessage.ERROR);
														}
													}
												});
												
												if(slidingComm =="Y"){  // Y means sliding comm will not be applied
													varRate = getIntmdryRate(wcommInvoice, varPerilCd);
												}
											} else {
												varRate = getIntmdryRate(wcommInvoice, varPerilCd);
											}
											
											//if (($F("globalParType") != "E" && !$("chkNbtRetOrig").checked && slidingComm == "Y")) {
											//if ((!$("chkNbtRetOrig").checked && slidingComm == "Y") && !($F("globalParType") == "E" && $F("txtIntmNo") == '${dfltIntmNo}')) {
											//marco - 06-03-2015 - GENQA SR 4547 - created globalParType variable to be used in the condition 
											var globalParType = $("globalParType") == null ? vParType : $F("globalParType");
											if ((!$("chkNbtRetOrig").checked && slidingComm == "Y") && !(globalParType == "E" && $F("txtIntmNo") == '${dfltIntmNo}')) {
												varRate = parseFloat(varRate) + getAdjustIntmdryRate(wcommInvoice, varPerilCd);
											}
										}
										
										wcommInvoicePeril.nbtCommissionRtComputed = varRate;

										if (!(nvl(String(varRate), "0").blank())) {
											wcommInvoicePeril.perilCd = gipiWinvperlList[i].perilCd;
											wcommInvoicePeril.perilName = gipiWinvperlList[i].perilName;

											if(parseFloat(nvl(wcommInvoice.sharePercentage, "0")) == getVSharePercentage(wcommInvoice.intermediaryNo)
												&& parseFloat(wcommInvoice.sharePercentage) != 100) {
												vOtherPrem = getVOtherPrem(gipiWinvperlList[i].perilCd);

												wcommInvoicePeril.premiumAmount = premAmt - vOtherPrem;
											} else {
												wcommInvoicePeril.premiumAmount = premAmt * (parseFloat(nvl(wcommInvoice.sharePercentage), "0")) / 100;
											}

											wcommInvoicePeril.commissionRate = roundNumber(parseFloat(nvl(varRate, "0")), 7);
											validateWcominvperCommissionRate(wcommInvoicePeril);
										}

										if(wcommInvoicePeril != null) {
											wcommInvoicePeril.nbtCommissionRtComputed = null;
											addWcominvperRecord(wcommInvoicePeril);
										}
									}
								} else {
									showMessageBox(response2.responseText, imgMessage.ERROR);
								}
							}
						});
					} else if (result.message = "POPULATE_PACKAGE_PERILS") {
						new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=populatePackagePerils", {
							method: "GET",
							asynchronous: false,
							evalScripts: true,
							parameters: {
								parId: b240[selectedB240Index].parId,
								itemGrp: wcommInvoice.itemGroup
							},
							onComplete: function(response2) {
								if (checkErrorOnResponse(response2)) {
									var wcommInvoicePeril = new Object(); // the new WCOMINVPER record to be added
									var gipiWitmperlList = eval(response2.responseText);
									var vOtherPrem = 0;

									for (var i = 0; i < gipiWitmperlList.length; i++) {
										var premAmt = (gipiWitmperlList[i] == null) ? 0 : parseFloat(gipiWitmperlList[i].premAmt);
										varPerilCd = gipiWitmperlList[i].perilCd;

										wcommInvoicePeril.parId = b240[selectedB240Index].parId;
										wcommInvoicePeril.takeupSeqNo = $F("txtTakeupSeqNo");
										wcommInvoicePeril.intermediaryIntmNo = wcommInvoice.intermediaryNo;
										wcommInvoicePeril.recordStatus = 0; // newly added

										if (result.varIssCd.blank()) {
											showMessageBox("Parameter HO does not exist in giis parameters.", imgMessage.ERROR);
											return;
										}

										varIssCd = result.varIssCd;

										varRate = getPackageIntmRate(gipiWitmperlList[i].itemNo, gipiWitmperlList[i].packLineCd, gipiWitmperlList[i].perilCd, wcommInvoices.intermediaryNo);

										if(!String(varRate).blank()) {
											wcommInvoicePeril.itemGrp = gipiWitmperlList[i].itemNo;
											wcommInvoicePeril.perilCd = gipiWitmperlList[i].perilCd;
											wcommInvoicePeril.perilName = gipiWitmperlList[i].perilName;
											wcommInvoicePeril.premiumAmount = gipiWitmperlList[i].premAmt * parseFloat(nvl(wcommInvoice.sharePercentage, "0")) /100;
											wcommInvoicePeril.commissionRate = varRate;
											validateWcominvperCommissionRate(wcommInvoicePeril);
										}

										if(wcommInvoicePeril != null) {
											addWcominvperRecord(wcommInvoicePeril);
										}
									}
								} else {
									showMessageBox(response2.responseText, imgMessage.ERROR);
								}
							}
						});
					} else {
						showMessageBox(result.message, imgMessage.INFO);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	// The procedure DELETE_WCOMM_INV_PERILS
	function deleteWcommInvPerils(intmNo) {
		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(intmNo, "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					deleteWcominvperRow(i);
				}
			}
		}
	}

	// The procedure GET_INTMDRY_RATE. Returns the intermediary rate
	function getIntmdryRate(wcommInvoice, perilCd) {
		var intmdryRate = 0;

		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=getIntmdryRate", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				parId: b240[selectedB240Index].parId,
				b240ParType: b240[selectedB240Index].parType,
				b240LineCd: b240[selectedB240Index].lineCd,
				b240IssCd: b240[selectedB240Index].issCd,
				intmNo: wcommInvoice.intermediaryNo,
				nbtRetOrig: $("chkNbtRetOrig").value,
				varPerilCd: perilCd,
				nbtIntmType: wcommInvoice.nbtIntmType,
				globalCancelTag: globalCancelTag,
				itemGrp: wcommInvoice.itemGroup
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (!response.responseText.blank()) {
						intmdryRate = parseFloat(response.responseText);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});

		return intmdryRate;
	}

	// The procedure GET_ADJUST_INTMDRY_RATE. Returns the intermediary rate
	function getAdjustIntmdryRate(wcommInvoice, perilCd) {
		var intmdryRate = 0;

		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=getAdjustIntmdryRate", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				intrmdryIntmNo: wcommInvoice.intermediaryNo,
				parId: b240[selectedB240Index].parId,
				perilCd: perilCd
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (!response.responseText.blank()) {
						intmdryRate = parseFloat(response.responseText);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});

		return intmdryRate;
	}

	// the procedure GET_PACKAGE_INTM_RATE
	function getPackageIntmRate(itemNo, packLineCd, perilCd, intmNo) {
		var intmdryRate = "";

		new Ajax.Request(contextPath+"/GIPIWCommInvoiceController?action=getPackageIntmRate", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				itemNo: itemNo,
				lineCd: lineCd,
				perilCd: perilCd,
				intmNo: intmno,
				parId: b240[selectedB240Index].parId,
				itemGrp: $F("txtItemGrp"),
				issCd: b240[selectedB240Index].issCd,
				varIssCd: varIssCd
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					if (!response.responseText.blank()) {
						intmdryRate = parseFloat(response.responseText);
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});

		return intmdryRate;
	}

	// the procedure COMPUTE_TOT_COM
	function computeTotCom(wcommInvoice) {
		var commissionAmount = 0;
		var withholdingTax = 0;
		var netCommission = 0;
		var premiumAmount = 0;

		if (wcominvper.length > 0) {
			for (var i = 0; i < wcominvper.length; i++) {
				if (wcominvper[i].itemGroup == parseInt(nvl($F("txtItemGrp"), "0")) && wcominvper[i].takeupSeqNo == parseInt(nvl($F("txtTakeupSeqNo"), "0"))
						&& wcominvper[i].intermediaryIntmNo == parseInt(nvl(String(wcommInvoice.intermediaryNo), "0"))
						&& wcominvper[i].parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))
						&& (wcominvper[i].recordStatus == null || wcominvper[i].recordStatus >= 0)) {
					commissionAmount = commissionAmount + roundNumber(parseFloat(nvl(wcominvper[i].commissionAmount, "0")), 2);
					withholdingTax = withholdingTax + roundNumber(parseFloat(nvl(wcominvper[i].withholdingTax, "0")), 2);
					netCommission = netCommission + roundNumber(parseFloat(nvl(wcominvper[i].netCommission, "0")), 2);
					premiumAmount = premiumAmount + roundNumber(parseFloat(nvl(wcominvper[i].premiumAmount, "0")), 2);
				}
			}
		}

		wcommInvoice.commissionAmount = commissionAmount;
		wcommInvoice.withholdingTax = withholdingTax;
		wcommInvoice.netCommission = netCommission;
		wcommInvoice.premiumAmount = premiumAmount;
	}

	// the WHEN-VALIDATE-ITEM trigger of WCOMINVPER.COMMISSION_RT
	// accepts a WCOMINVPER parameter and updates fields based on the changed commission rate
	function validateWcominvperCommissionRate(wcommInvoicePeril) {
		//wcommInvoicePeril.commissionAmount = roundNumber(parseFloat(nvl(wcommInvoicePeril.premiumAmount, "0")) * parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")) / 100, 2);
		//wcommInvoicePeril.commissionAmount = parseFloat((parseFloat(nvl(wcommInvoicePeril.premiumAmount, "0")) * parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")) / 100).toFixed(2)); // andrew - 3.25.2014 - use toFixed in rounding to handle negative value SR#14087
		wcommInvoicePeril.commissionAmount = roundNumber2(parseFloat(nvl(wcommInvoicePeril.premiumAmount, "0")) * parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")) / 100, 2); //robert SR 21760 03.16.16 - used roundNumber2

		if (b240[selectedB240Index].parType == "P") {
			varTaxAmt = getDefaultTaxRate(wcommInvoicePeril.intermediaryIntmNo);
		}

		wcommInvoicePeril.withholdingTax = roundNumber(roundNumber(parseFloat(nvl(wcommInvoicePeril.commissionAmount, "0")), 2) * parseFloat(nvl(varTaxAmt, "0")) / 100, 2);
		wcommInvoicePeril.netCommission = roundNumber(parseFloat(nvl(wcommInvoicePeril.commissionAmount, "0")), 2) - roundNumber(parseFloat(nvl(wcommInvoicePeril.withholdingTax, "0")), 2);

		if (wcommInvoicePeril.nbtCommissionRtComputed == null || String(wcommInvoicePeril.nbtCommissionRtComputed).blank()) {
			return;
		} 
		//removed by apollo 09.26.2014 - validation was done in valCommRate()
		/*else if (parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")) < parseFloat(nvl(wcommInvoicePeril.nbtCommissionRtComputed, "0"))) {
			showMessageBox("Commission Rate is lower than the Computed Commission Rate of " + wcommInvoicePeril.nbtCommissionRtComputed + "%", imgMessage.INFO);
		}*/
	}

	// the WHEN-VALIDATE-ITEM trigger of WCOMINVPER.COMMISSION_AMT
	// accepts a WCOMINVPER parameter and updates fields based on the changed commission amount
	function validateWcominvperCommissionAmount(wcommInvoicePeril) {
		varTaxAmt = getDefaultTaxRate(wcommInvoicePeril.intermediaryIntmNo);
		
		if (parseFloat(wcommInvoicePeril.commissionAmount) != 0 && parseFloat(wcommInvoicePeril.premiumAmount) != 0) {
			if (Math.abs(parseFloat(wcommInvoicePeril.premiumAmount)) > Math.abs(parseFloat(wcommInvoicePeril.commissionAmount))) {
				wcommInvoicePeril.commissionRate = (parseFloat(wcommInvoicePeril.commissionAmount) / parseFloat(wcommInvoicePeril.premiumAmount)) * 100;


				if (wcommInvoicePeril.nbtCommissionRtComputed == null || String(wcommInvoicePeril.nbtCommissionRtComputed).blank())
					return;
				
				$("txtPerilCommissionRt").value = roundNumber(parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")), 7);
				
				//Apollo Cruz 11.04.2014
				if(valCommRate()){
					wcommInvoicePeril.withholdingTax = roundNumber(parseFloat(nvl(wcommInvoicePeril.commissionAmount, "0")), 2) * parseFloat(nvl(varTaxAmt, "0")) / 100;
					wcommInvoicePeril.netCommission = roundNumber(parseFloat(nvl(wcommInvoicePeril.commissionAmount, "0")), 2) - roundNumber(parseFloat(nvl(wcommInvoicePeril.withholdingTax, "0")), 2);
					prevPerilCommissionRt = parseFloat(nvl($F("txtPerilCommissionRt").replace(/,/g,""), "0"));
					prevPerilCommissionAmt = parseFloat(nvl($F("txtPerilCommissionAmt").replace(/,/g,""), "0"));
				}
				
				//Apollo Cruz 11.04.2014 - validation was done in valCommRate()
				/* if (parseFloat(nvl(wcommInvoicePeril.commissionRate, "0")) < parseFloat(nvl(wcommInvoicePeril.nbtCommissionRtComputed, "0"))) {
					showMessageBox("Commission Rate is lower than the Computed Commission Rate of " + wcommInvoicePeril.nbtCommissionRtComputed + "%", imgMessage.INFO);
				} */
			}
		} /* else {
			showMessageBox("Commission Amount must be lower than Premium Amount.", imgMessage.INFO);
			return;
		} */
	}

	// the WHEN-VALIDATE-ITEM trigger of WCOMINVPER.WHOLDING_TAX
	// accepts a WCOMINVPER parameter and updates fields based on the changed withholding tax
	function validateWcominvperWithholdingTax(wcommInvoicePeril) {
		wcommInvoicePeril.netCommission = roundNumber(parseFloat(nvl(wcommInvoicePeril.commissionAmount, "0")), 2) - roundNumber(parseFloat(nvl(wcommInvoicePeril.withholdingTax, "0")), 2);
	}

	function validateTakeupSeqNo() {
		if (getTotalSharePercentage($F("txtItemGrp"), prevTakeupSeqNo, b240[selectedB240Index].parId) != 100) { 
			showMessageBox("Total share percentage should be equal to 100%", imgMessage.INFO);
			$("txtTakeupSeqNo").value = prevTakeupSeqNo;
		} else {
			displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "");
			resetWcominvFields();
			resetWcominvperFields();
			removeAllWcominvperRecords();
			hidePerilDiv();
			prevTakeupSeqNo = $F("txtTakeupSeqNo");
			
			$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId)), 7);

			$("txtMultiBookingMM").value = $("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("multiBookingMM");
			$("txtMultiBookingYY").value = $("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("multiBookingYY");
			$("txtInsured").value		 = unescapeHTML2($("txtTakeupSeqNo").options[$("txtTakeupSeqNo").selectedIndex].readAttribute("insured"));
		}
	}

	// emman (06.29.2011)
	function validateItemGrp() {
		if (getTotalSharePercentage(prevItemGrp, $F("txtTakeupSeqNo"), b240[selectedB240Index].parId) != 100) { 
			showMessageBox("Total share percentage should be equal to 100%", imgMessage.INFO);
			$("txtItemGrp").value = prevItemGrp;
		} else {
			populateTakeupSeqNoList();
			
			displayWcominvRecords($F("txtItemGrp"), $F("txtTakeupSeqNo"), "");
			resetWcominvFields();
			resetWcominvperFields();
			removeAllWcominvperRecords();
			hidePerilDiv();
			prevItemGrp = $F("txtItemGrp");
			
			if($$("div [name='rowWcominv']").size() == 0){ // andrew - 05.11.2012 - reset share to 100.00
				$("txtSharePercentage").value = "100.00";
			} 
		}
	}

	// now accepts parameter to check if Item Grp and Takeup are to be validated first
	// prevents problems on validating while loading (emman 07.12.2011)
	function validateB240Block(validateItemAndTakeup) {
		if (nvl(validateItemAndTakeup, false) && !nvl($F("txtItemGrp"),"").blank() && !nvl($F("txtTakeupSeqNo"),"").blank() && getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[prevSelectedB240Index].parId) != 100) { 
			showMessageBox("Total share percentage should be equal to 100%", imgMessage.INFO);
			$("parNo").selectedIndex = prevSelectedB240Index;
			selectedB240Index = prevSelectedB240Index;
		} else if(changeTag != 0) {
			showMessageBox("Please save before proceeding to the next PAR.");
			$("parNo").selectedIndex = prevSelectedB240Index;
			selectedB240Index = prevSelectedB240Index;
		} else {
			/* var dfltIntmNo = "";
			var dfltIntmName = "";
			var dfltParentIntmNo = "";
			var dfltParentIntmName = ""; */ // declaration moved by: Nica 11.23.2011
			var intmNoPar1 = "";
			var intmNamePar1 = "";
			var parentIntmNoPar1 = "";
			var parentIntmNamePar1 = "";
			
			$("assuredName").value = unescapeHTML2(b240[selectedB240Index].dspAssdName);
			$("txtSharePercentage").value = formatToNthDecimal((100 - getTotalSharePercentage($F("txtItemGrp"), $F("txtTakeupSeqNo"), b240[selectedB240Index].parId)), 7);
			for (var i = 0; i < packParlistParams.length; i++) {
				var pp = packParlistParams[i];
				if (pp.packParId == parseInt(nvl(b240[selectedB240Index].packParId, "0")) && pp.parId == parseInt(nvl(b240[selectedB240Index].parId, "0"))) {
					var invCount = 0;
					vValidateBanca = pp.vValidateBanca;
					vPolFlag = pp.vPolFlag;
					vParType = pp.parType;
					wcominvIntmNoLov == pp.vWcominvIntmLov;
					
					if(nvl(pp.intmNo, "") != ""){ // condition added by Nica 11.23.2011
						dfltIntmNo = pp.intmNo;
						dfltIntmName = pp.intmName;
						dfltParentIntmNo = pp.parentIntmNo;
						dfltParentIntmName = pp.parentIntmName;
						if(i==0) {
							intmNoPar1 = pp.intmNo;
							intmNamePar1 = pp.intmName;
							parentIntmNoPar1 = pp.parentIntmNo;
							parentIntmNamePar1 = pp.parentIntmName;
						}
					} else {
						dfltIntmNo = i>0 ? intmNoPar1 : '${dfltIntmNo}';
						dfltIntmName = i>0 ? intmNamePar1 : '${dfltIntmName}';
						dfltParentIntmNo = i>0 ? parentIntmNoPar1 : '${dfltParentIntmNo}';
						dfltParentIntmName = i>0 ? parentIntmNamePar1 : '${dfltParentIntmName}';
					}
					
					$("nbtLineCd").value = pp.lineCd;
					$("nbtSublineCd").value = pp.sublineCd;

					/* benjo 09.14.2016 SR-5604 */
					//$("chkLovTag").value = (nvl(pp.vLovTag, "").blank()) ? "UNFILTERED" : pp.vLovTag;
					if (!nvl(pp.vLovTag, "").blank()){
						$("chkLovTag").value = pp.vLovTag;
					}

					if (!nvl(pp.vMsgAlert, "").blank()) {
						showMessageBox(pp.vMsgAlert, imgMessage.INFO);
					}

					break;
				}
			
			}

			executeB450whenNewBlockInstance();
			populateItemGrpList();
			
			if (packParlistParams.length > 0) {
				invCount = $$("div#wcominvTableContainer div[name='rowWcominv']").length;
				var displayField = invCount == 0 && !nvl($F("txtItemGrp"),"").blank() && !nvl($F("txtTakeupSeqNo"),"").blank();
				
				$("txtIntmNo").value = (!displayField) ? '' : nvl(dfltIntmNo, '');
				$("txtIntmName").value = (!displayField) ? '' : nvl(dfltIntmName, '').replace(/\\/g, '\\\\');
				$("txtDspIntmName").value = (!displayField) ? '' :nvl(dfltIntmNo, '') + (String(nvl(dfltIntmNo, '')).blank() || nvl(dfltIntmName, '').blank() ? '' : ' - ') + nvl(dfltIntmName, '').replace(/\\/g, '\\\\');
				$("txtParentIntmNo").value = (!displayField) ? '' :nvl(dfltParentIntmNo, '');
				$("txtParentIntmName").value = (!displayField) ? '' :nvl(dfltParentIntmName, '').replace(/\\/g, '\\\\');
				$("txtDspParentIntmName").value = (!displayField) ? '' :nvl(dfltParentIntmNo, '') + (String(nvl(dfltParentIntmNo, '')).blank() || nvl(dfltParentIntmName, '').blank() ? '' : ' - ') + nvl(dfltParentIntmName, '').replace(/\\/g, '\\\\');
	
				$("txtIntmName").value = unescapeHTML2($F("txtIntmName"));
				$("txtParentIntmName").value = unescapeHTML2($F("txtParentIntmName"));
				$("txtDspIntmName").value = unescapeHTML2($F("txtDspIntmName"));
				$("txtDspParentIntmName").value = unescapeHTML2($F("txtDspParentIntmName"));
			}
			
			/* benjo 09.07.2016 SR-5604 */
			if(reqDfltIntmPerAssd == "Y"){
				if(String(nvl('${maintainedDfltIntmNo}', '')).blank() || nvl('${maintainedDfltIntmNo}').blank()){
					//showWaitingMessageBox("No default intermediary maintained for this assured. Please contact MIS for the set-up of intermediary", imgMessage.INFO, cancelFuncWcommInvoice); //benjo 03.07.2017 SR-5893
					showMessageBox("No default intermediary maintained for this assured. Please contact MIS for the set-up of intermediary.", imgMessage.INFO); //benjo 03.07.2017 SR-5893
				}else{
					if(allowUpdIntmPerAssd == "N"){
						$("chkLovTag").value = "FILTERED";
						$("chkLovTag").disabled = true;
					}else if(allowUpdIntmPerAssd == "O"){
						if(validateUserFunc3(overrideUser, "OV", "GIPIS085")==true){
							override = "N";
						}else{
							$("chkLovTag").value = "FILTERED";
							override = "Y";
						}
					}
					if((objGIPIWPolbas.polFlag == 2 || objUWParList.parType == "E") && '${maintainedDfltIntmNo}' != $F("txtIntmNo") && !$F("txtIntmNo").blank()){
						showMessageBox("Policy Intermediary is not the same as the default Intermediary for the assured.", imgMessage.INFO);
					}
				}
			}
			
			if ($("chkLovTag").value == "FILTERED") {
				$("chkLovTag").checked = true;
			} else {
				$("chkLovTag").checked = false;
			}

			if (vOra2010Sw == "Y") {
				$("chkBancaCheck").style.display = "inline";
			} else {
				$("chkBancaCheck").style.display = "none";
			}

			if (nvl($F("txtItemGrp"),"").blank() || nvl($F("txtTakeupSeqNo"),"").blank()) {
				disableButton("btnSaveIntm");
			} else {
				enableButton("btnSaveIntm");
			}
		}
	}
	
	/** end of oracle forms functions **/
	if(objUWParList.parType == "E"){
		//objUWGlobal.cancelTag = "N"; commented out by robert 10.09.2012
		if(objGIPIWPolbas.polFlag == 4 || objUWGlobal.cancelTag == "Y"){
			$("txtSharePercentage").disabled = true;
			$("txtPremiumAmt").disabled = true;
			$("txtCommissionAmt").disabled = true;
			$("txtNetCommission").disabled = true;
			$("txtWholdingTax").disabled = true;
			showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", imgMessage.WARNING);
			$("txtSharePercentage").readOnly = true; // robert 10.23.2012
			objUWGlobal.cancelTag = "Y"; // irwin
		}
		// $("oscmIntm").stopObserving(); (removed - emman 09.09.2011)
	}
	
	function valCommRate (obj) {		
		var bool = true;
		new Ajax.Request(contextPath+"/GIISIntermediaryController", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				action : "valCommRate",
				intmNo: obj == null ? $F("txtIntmNo") : obj.intermediaryIntmNo,
				//lineCd : $F("globalLineCd"),
				//sublineCd : $F("globalSublineCd"),
				//issCd : $F("globalIssCd"),
				//nieko 03202017, SR 23817
				lineCd : b240[selectedB240Index].lineCd,
				sublineCd : b240[selectedB240Index].sublineCd,
				issCd : b240[selectedB240Index].issCd,
				perilCd : $F("txtPerilCd"),
				commRate : unformatCurrencyValue($F("txtPerilCommissionRt"))
			},
			onCreate : function(){
				showNotice("Validating Rate, please wait...");
			},
			onComplete: function(response) {
				hideNotice();
				if(response.responseText != "SUCCESS"){					
					if(response.responseText.include("Error")){
						bool = false;
						var message = response.responseText.split("#");
						showWaitingMessageBox(message[1], "E", function(){
							$("txtPerilCommissionRt").value = formatToNthDecimal(prevPerilCommissionRt, 7);
							$("txtPerilCommissionAmt").value = formatCurrency(nvl(prevPerilCommissionAmt, "0"));
						});
					} else {
						showMessageBox(response.responseText, "I");
					}
				}
			}
		});
		
		return bool;
	}

	changeTag = 0;
	initializeChangeTagBehavior(saveWcommInvoice);
	initializeChangeAttribute();
	initializeAccordion();
</script>
