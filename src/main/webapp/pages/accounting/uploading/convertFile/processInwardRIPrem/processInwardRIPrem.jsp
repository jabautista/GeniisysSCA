<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="processInwardRIPremDiv" name="processInwardRIPremDiv" style="float: left; width: 100%;">
	<div id="toolbarGiacs608">
		<div id="toolbarDiv" name="toolbarDiv">	
			<div class="toolButton" style="float: right;">
				<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="uploadingExit">Exit</span>
				<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
			</div>
	 	</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Uploading of Inward RI Premium Payments</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormGIACS608" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id = "gufDiv" class="sectionDiv" style="padding: 15px 0 15px 0;">
			<table align="center">
				<tr>
					<td class="rightAligned">Batch No</td>
					<td class="leftAligned" style="padding-left: 4px">
						<input type="text" id="txtFileNo" style="width: 140px; text-align: right; margin-bottom: 0px;" readonly="readonly" tabindex="101"/>
					</td>	
					<td class="rightAligned" style="padding-left: 260px">Filename</td>
					<td class="leftAligned" colspan="">
						<input type="text" id="txtFileName"  style="width: 180px; margin-bottom: 0px;" readonly="readonly" tabindex="102"/>
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">Source</td>
					<td class="leftAligned" style="padding-left: 4px">
						<input type="text" id="txtNbtSourceCd" style="width: 140px; margin-bottom: 0px;" readonly="readonly" tabindex="103"/>
					</td>
					<td class="leftAligned" colspan="2" style="padding-left: 0">
						<input type="text" id="txtNbtSourceName" style="width: 500px; margin-bottom: 0px;" readonly="readonly" tabindex="104"/>
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">Ceding Company</td>
					<td class="leftAligned" colspan="3" style="padding-left: 0; padding-left: 4px">
						<input type="text" id="txtRiCd" style="width: 140px; float: left; margin-bottom: 0px;" readonly="readonly" tabindex="104"/>
						<input type="text" id="txtDspRi" style="width: 500px; text-align: left; margin: 2px 0 0 3px; float: left;" readonly="readonly" tabindex="105"/>
					</td>					
				</tr>
				<tr>
					<td class="rightAligned">Tran Date</td>
					<td class="leftAligned" style="padding-left: 4px">
						<input type="text" id="txtTranDate" style="width: 140px; margin-bottom: 0px;" readonly="readonly" tabindex="108"/>
					</td>
					<td class="rightAligned">OR/Req/JV No</td>
					<td class="leftAligned" colspan="">
						<input type="text" id="txtOrReqJVNo"  style="width: 180px; margin-bottom: 0px;" readonly="readonly" tabindex="109"/>
					</td>					 
				</tr>
			</table>
			
			<div align="center" style="width: 100%; margin-top: 15px;">
				<input type="button" class="button" id="btnPayments" name="btnPayments" value="Payment Details" style="width: 125px;" tabindex="110"/>
			</div>
		</div>
		
		<div id = "recordsDiv" class="sectionDiv" style="margin-bottom: 1px; padding: 15px 0 1px 0;">
			<div id="giacUploadInwfaculPrem" style="margin-left: 10px; height: 200px; margin-top: 10px;"></div>
			
			<fieldset class="sectionDiv" style="width:900px; margin:10px;">
				<legend style="font-weight: bold; font-size: 11px;">Totals</legend>
				<div id="totalsDiv" align="center" class="" style="padding:7px 10px 10px 10px;">
					<table>
						<tr>
							<td class="rightAligned" style="width:120px;">Premium</td>
							<td class="leftAligned"><input type="text" id="txtPremTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned" style="width:120px;">Tax</td>
							<td class="leftAligned"><input type="text" id="txtTaxTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned" style="width:120px;">Commission</td>
							<td class="leftAligned"><input type="text" id="txtCommTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="rightAligned" style="width:120px;">Commission VAT</td>
							<td class="leftAligned"><input type="text" id="txtCommVatTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned">Collection Amount</td>
							<td class="leftAligned"><input type="text" id="txtCollectionAmtTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned">Premium Difference</td>
							<td class="leftAligned"><input type="text" id="txtPremDiffTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							
						</tr>
						<tr>
							<td class="rightAligned">Commission VAT Diff</td>
							<td class="leftAligned"><input type="text" id="txtCommVatDiffTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned">Prem VAT Difference</td>
							<td class="leftAligned"><input type="text" id="txtPremVatDiffTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned">Commission Diff</td>
							<td class="leftAligned"><input type="text" id="txtCommDiffTotal" style="width: 100px; text-align: right;" readonly="readonly"/></td>
						</tr>		
					</table>
				</div>
			</fieldset>
			
				<table style="margin-top: 5px;" align="center">
					<th></th>
					<th></th>
					<th>Legend</th>
					<tr>
						<td class="rightAligned">Assured</td>
						<td class="leftAligned">
							<input id="txtAssured" type="text" class="" style="width: 450px;" tabindex="201" readonly="readonly">
						</td>
						<td class="leftAligned" rowspan="3">
						<div>
							<textarea class="required" readonly="readonly" style="float: left; height: 90px; width: 190px; margin-top: 0; resize: none;" id="txtLegend" name="txtLegend" maxlength="4000" onkeyup="limitText(this,4000);" tabindex="204"></textarea>
						</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Checking Results</td>
						<td class="leftAligned">
							<input id="txtCheckingResults" type="text" class="" style="width: 450px;" tabindex="202" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center" style="padding-top: 10px; padding-bottom: 10px;">
							<input type="button" class="button" id="btnForeignCurrency" value="Foreign Currency" tabindex="203">
						</td>
					</tr>				
				</table>
		</div>	
		<div class="sectionDiv" align="center" id="giacs603Header" style="margin-bottom: 15px;">
		<table>
			<tr>
				<td>
					<fieldset style="width: 240px; height: 50px; margin: 20px;">
						<legend>Transaction</legend>
						<table style="margin-top: 8px;">
							<tr>
								<td class="rightAligned">
									<input type="radio" name="transaction" id="rdoOR" style="float: left; margin: 3px 2px 3px 30px;" tabindex="301"/>
									<label for="rdoOR" style="float: left; height: 20px; padding-top: 3px;" title="OR">OR</label>
								</td>
								<td class="rightAligned">
									<input type="radio" name="transaction" id="rdoDV" style="float: left; margin: 3px 2px 3px 30px;" tabindex="302"/>
									<label for="rdoDV" style="float: left; height: 20px; padding-top: 3px;" title="DV">DV</label>
								</td>
								<td class="rightAligned">
									<input type="radio" name="transaction" id="rdoJV" style="float: left; margin: 3px 2px 3px 30px;" tabindex="303"/>
									<label for="rdoJV" style="float: left; height: 20px; padding-top: 3px;" title="JV">JV</label>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
				<td class="rightAligned" style="width: 60px"><label id="lblOrDate">O.R. Date</label></td>
				<td class="leftAligned" style="width: 170px">
					<!-- <input id="txtOrDate" type="text" class="" style="width: 150px;" tabindex="304" readonly="readonly">  -->
					<div id="OrDateDiv" style="float: left; width: 150px;" class="withIconDiv">
						<input type="text" id="txtOrDate" name="txtOrDate" class="withIcon date" readonly="readonly" style="width: 125px;" tabindex="1005"/>
						<img id="btnOrDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="OR Date" tabindex="107"/>
					</div>
				</td>
				<td class="rightAligned">Upload Date</td>
				<td class="leftAligned">
					<input id="txtUploadDate" type="text" class="" style="width: 150px;" tabindex="305" readonly="readonly">
				</td>
			</tr>
		</table>
		<div align="center" style="padding: 10px 0 10px 0; border-top: 1px solid #E0E0E0;">
			<input type="button" class="button" id="btnCheckData" value="Check Data" tabindex="401" style="width: 150px; ">
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="402" style="width: 150px;">
			<input type="button" class="button" id="btnUpload" value="Upload" tabindex="403" style="width: 150px;">
			<input type="button" class="button" id="btnPrintUpload" value="Print" tabindex="404" style="width: 150px;">
			<input type="button" class="button" id="btnCancelFile" value="Cancel File" tabindex="405" style="width: 150px;">
		</div>
	</div>
</div>
<div id="otherModuleDiv">
</div>
<script type="text/javascript">
	setModuleId("GIACS608");
	setDocumentTitle("Uploading of Inward RI Premium Payments");
	
	//nieko Accounting Uploading GIACS608, modify exit toolbar
	/*$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		objACGlobal.callingForm = "";
		$("process").innerHTML = "";
		$("process").hide();
		
		setModuleId("GIACS601");
		$("convertFileMainDiv").show();
		$("acExit").show();
		$("acExit").stopObserving();
		$("acExit").observe("click", function() {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
	});*/
	
	legend = JSON.parse('${giacs608Legend}');
	guf = JSON.parse('${guf}');
	giupTotal = JSON.parse('${giupTotal}');
	parameters = JSON.parse('${jsonParameters}');
	setFieldValues(null);
	overrideSw = "N";
	
	//populate
	$("txtFileNo").value = guf.fileNo;
	$("txtFileName").value = guf.fileName;
	$("txtNbtSourceCd").value = guf.sourceCd;
	$("txtNbtSourceName").value = guf.dspSourceName;
	$("txtRiCd").value = guf.riCd;
	$("txtDspRi").value = guf.dspRi;
	$("txtTranDate").value = guf.tranDate;
	$("txtOrDate").value = guf.tranDate == null ? dateFormat(guf.dspOrDate, "mm-dd-yyyy") : guf.tranDate;
	//$("txtOrReqJVNo").value = guf.;
	
	var legendString = "";
	for ( var i = 0; i < legend.rows.length; i++) {
		if (i == 0){
			legendString = legend.rows[i].legend;
		} else {
			legendString = legendString + "\n" +legend.rows[i].legend;
		}
	}
	
	$("txtLegend").value = legendString;
	
	if(guf.dspTranClass == "D"){
		$("rdoDV").checked = true;
		$("lblOrDate").hide();
		//$("txtOrDate").hide();
		$("OrDateDiv").hide();
	} else if(guf.dspTranClass == "J"){
		$("rdoJV").checked = true;
		$("lblOrDate").hide();
		//$("txtOrDate").hide();
		$("OrDateDiv").hide();
	} else {
		$("rdoOR").checked = true;
		$("lblOrDate").show();
		//$("txtOrDate").show();
		$("OrDateDiv").show();
	} 

	objGIUP = null;
	objGIACS608 = {};
	objGIACS608.gupcList = JSON.parse('${giup}');
	var rowIndex = -1;
	
	objGIACS608.tranClass = guf.tranClass;
	objGIACS608.fileStatus = guf.fileStatus;
	
	try{
		var gupcTableModel = {
				url : contextPath + "/GIACUploadingController?action=showGiacs608RecList&refresh=1&sourceCd="+guf.sourceCd+"&fileNo="+guf.fileNo,
				options : {
					width : '888px',
					hideColumnChildTitle: true,
					pager : {},
					onCellFocus : function(element, value, x, y, id){
						rowIndex = y;
						objGIUP = tbgGUPC.geniisysRows[y];
						setFieldValues(objGIUP);
						tbgGUPC.keys.removeFocus(tbgGUPC.keys._nCurrentFocus, true);
						tbgGUPC.keys.releaseKeys();
					},
					onRemoveRowFocus : function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGUPC.keys.removeFocus(tbgGUPC.keys._nCurrentFocus, true);
						tbgGUPC.keys.releaseKeys();
					},					
					toolbar : {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter: function(){
							rowIndex = -1;
							setFieldValues(null);
							tbgGUPC.keys.removeFocus(tbgGUPC.keys._nCurrentFocus, true);
							tbgGUPC.keys.releaseKeys();
						}
					},
					onSort: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGUPC.keys.removeFocus(tbgGUPC.keys._nCurrentFocus, true);
						tbgGUPC.keys.releaseKeys();
					},
					onRefresh: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGUPC.keys.removeFocus(tbgGUPC.keys._nCurrentFocus, true);
						tbgGUPC.keys.releaseKeys();
					},	
				},
				columnModel : [
					{ 								// this column will only use for deletion
					    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
					    width: '0',				    
					    visible : false			
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{
						id : 'premChkFlag',
						title : '&#160;&#160;P',
						altTitle: 'Premium Check Flag',
						titleAlign: 'center',
						width : '25px'				
					},
					{
						id : 'policyNo',
						filterOption : true,
						title : 'Policy No.',
						width : '150px'				
					},
					{
						id : "lPremAmt",
						title : "Premium",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "lTaxAmt",
						title : "Tax",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},	
					{
						id : "lCommAmt",
						title : "Commission",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},	
					{
						id : "lCommVat",
						title : "Commission VAT",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},	
					{
						id : "lCollectionAmt",
						title : "Collection Amount",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},	
					{
						id : "dspDiffPrem",
						title : "Premium Difference",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},	
					{
						id : "dspPremVat",
						title : "Prem VAT Difference",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},	
					{
						id : "dspCommDiff",
						title : "Commission Diff",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},	
					{
						id : "dspCommVat",
						title : "Commission VAT Diff",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},	
				],
				rows : objGIACS608.gupcList.rows
			};

			tbgGUPC = new MyTableGrid(gupcTableModel);
			tbgGUPC.pager = objGIACS608.gupcList;
			tbgGUPC.render("giacUploadInwfaculPrem");
			tbgGUPC.afterRender = function(){
				$("txtPremTotal").value = formatCurrency(nvl(giupTotal.dspTotPrem, 0));
				$("txtCommVatTotal").value = formatCurrency(nvl(giupTotal.dspTotVat, 0));
				$("txtCommVatDiffTotal").value = formatCurrency(nvl(giupTotal.dspDiffCommVatDiffTot, 0));
				$("txtTaxTotal").value = formatCurrency(nvl(giupTotal.dspTotTax, 0));
				$("txtCollectionAmtTotal").value = formatCurrency(nvl(giupTotal.dspTotCollection, 0));
				$("txtPremVatDiffTotal").value = formatCurrency(nvl(giupTotal.totGPremDiff, 0));
				$("txtCommTotal").value = formatCurrency(nvl(giupTotal.dspTotComm, 0));
				$("txtPremDiffTotal").value = formatCurrency(nvl(giupTotal.dspDiffPremTot, 0));
				$("txtCommDiffTotal").value = formatCurrency(nvl(giupTotal.totInputVATDiff, 0));
				
				for (var i=0; i<tbgGUPC.geniisysRows.length; i++){
					if (nvl(tbgGUPC.geniisysRows[i].premChkFlag, "OK") != "OK"){
						$('mtgRow'+tbgGUPC._mtgId+'_'+i).style.color = "#FF6633";
					}
				}
			};
			
	}catch(e){
		showErrorMessage("GUPC tablegrid error", e);
	}
	
	$("btnForeignCurrency").observe("click", showForeignCurrency);
	
	function showForeignCurrency() {
		try {
			overlayFCurr = Overlay.show(contextPath
					+ "/GIACUploadingController", {
				urlContent : true,
				urlParameters : {
					action : "giacs608ForeignCurrency",
					ajax : "1",
					},
				title : "Foreign Currency",
				height: 310,
			 	width: 420,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	function setFieldValues(row){
		$("txtCheckingResults").value = (row == null ? "" : unescapeHTML2(row.chkRemarks));
		$("txtAssured").value = (row == null ? "" : unescapeHTML2(row.assured));
		row == null ? disableButton("btnForeignCurrency") : enableButton("btnForeignCurrency");
		
		if (row != null && (nvl(row.premChkFlag, "OK") != "OK")){
			$("txtCheckingResults").style.color = "#FF6633";
			$("txtAssured").style.color = "#FF6633";
		}else{
			$("txtCheckingResults").style.color = "black";
			$("txtAssured").style.color = "black";
		}
		
		toggleButtons();
	}
	
	function toggleButtons(){
		if (guf.fileStatus == "C"){
			disableButton("btnCancelFile");
			disableButton("btnUpload");
			disableButton("btnPrintUpload");
			disableButton("btnPrintReport");
			
			disableDate("btnOrDate");
		}else if (guf.fileStatus != 1){
			disableButton("btnCancelFile");
			disableButton("btnUpload");
			disableButton("btnCheckData");
			
			disableButton("rdoOR");
			disableButton("rdoDV");
			disableButton("rdoJV");
			
			disableDate("btnOrDate");
		}else{
			enableButton("btnCancelFile");
			enableButton("btnUpload");
			enableButton("btnPrintUpload");
			enableButton("btnPrintReport");
			enableButton("btnCheckData");
			
			enableButton("rdoOR");
			enableButton("rdoDV");
			enableButton("rdoJV");
			
			enableDate("btnOrDate");
		}
	}
	
	$("btnPayments").observe("click", function(){
		if ($("rdoOR").checked){
			showCollnDtl();
		}else if ($("rdoDV").checked){
			showPaymentDetails("giacs608ShowPaymentDetailsDV");
		} else {
			showPaymentDetails("giacs608ShowPaymentDetailsJV");
		}
	});
	
	function showCollnDtl(){
		try {
			overlayCollnDtl = Overlay.show(contextPath
					+ "/GIACUploadingController", {
				urlContent : true,
				urlParameters : {
					action : "showGIACS608CollnDtlOverlay",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo,
					branchCd: parameters.branchCd,
					ajax : "1",
					},
				title : "Payment Details",
				 height: 485,
				 width: 900,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	function showPaymentDetails(action) {
		try {
			overlayPaymentDetails = Overlay.show(contextPath
					+ "/GIACUploadingController", {
				urlContent : true,
				urlParameters : {
					action : action,
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo,
					ajax : "1",
					},
				title : "Payment Details",
				 height: action == "giacs608ShowPaymentDetailsDV" ? 350 : 270,
				 width: 855,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}
	
	$("btnCheckData").observe("click", checkData);
	
	function checkData(){
		if(guf.tranClass != null){
			showMessageBox("This file has already been uploaded.", imgMessage.ERROR);
		} else {
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "checkDataGiacs608",
							sourceCd : guf.sourceCd,
							fileNo : guf.fileNo,
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							showGiacs608();
						});
					}
				}
			});
		}
	}
	
	function showGiacs608(){ //john 9.21.2015 : conversion of GIACS608
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGIACS608",
				sourceCd: $("txtNbtSourceCd").value,//sourceCd, 
				fileNo: $("txtFileNo").value//fileNo
			},
			asynchronous: false,
			evalScripts: true, 
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("convertFileMainDiv").hide();
					//$("process").show();
				}	
			}
		});
	}
	
	$("btnPrintReport").observe("click", showPrintDialog);
	
	function showPrintDialog(){
		overlayGenericPrintDialog = Overlay.show(contextPath+"/GIISController", {
			urlContent : true,
			urlParameters: {action : "showGenericPrintDialog",
							showFileOption : true},
		    title: "Print Report",
		    height: 220,
		    width: 380,
		    draggable: true
		});
		
		overlayGenericPrintDialog.onPrint = printReport;
		overlayGenericPrintDialog.onLoad  = nvl(addPrintForm,null);
		overlayGenericPrintDialog.onCancel = function(){
			false;
		};
	}
	
	function printReport(){
		try {
			if (!$("convertDate").checked && !$("uploadDate").checked){
				showMessageBox("Please select type of report.", "I");
				return false;
			}
			var content = contextPath+"/UploadingReportPrintController?action=printReport&sourceCd="+guf.sourceCd+
									"&fileName="+guf.fileNo+"&transactionCd=1&printerName="+$F("selPrinter");							
			var repDateParam = "";
			var reports = [];
			
			if ($("convertDate").checked){
				repDateParam = guf.convertDate == "" || guf.convertDate == null ? "" : dateFormat(Date.parse(guf.convertDate), "mm-dd-yyyy");
				reportId = "GIACR601";
				reports.push({reportUrl : content+"&reportId="+reportId+"&fromDate="+repDateParam+"&toDate="+repDateParam,
							  reportTitle : reportId});
			}
			if ($("uploadDate").checked){
				repDateParam = guf.uploadDate == "" || guf.uploadDate == null ? "" : dateFormat(Date.parse(guf.uploadDate), "mm-dd-yyyy");
				reportId = "GIACR602";
				reports.push({reportUrl : content+"&reportId="+reportId+"&fromDate="+repDateParam+"&toDate="+repDateParam,
					  reportTitle : reportId});
			}

			if("screen" == $F("selDestination")){
				showMultiPdfReport(reports);
				reports = [];
			}else if($F("selDestination") == "printer"){
				for(var i=0; i<reports.length; i++){
					new Ajax.Request(reports[i].reportUrl, {
						asynchronous : false,
						parameters : {noOfCopies : $F("txtNoOfCopies")},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response){
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
								if (i == reports.length-1){
									overlayGenericPrintDialog.close();
								}					
							}
						}
					});
				}
			}else if("file" == $F("selDestination")){
				for(var i=0; i<reports.length; i++){
					new Ajax.Request(reports[i].reportUrl, {
						parameters : {destination : "FILE"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
								copyFileToLocal(response);
								if (i == reports.length-1){
									overlayGenericPrintDialog.close();
								}
							}
						}
					});
				}
			}else if("local" == $F("selDestination")){
				for(var i=0; i<reports.length; i++){
					new Ajax.Request(reports[i].reportUrl, {
						asynchronous : false,
						parameters : {destination : "LOCAL"},
						onComplete: function(response){
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
								var result = printToLocalPrinter(response.responseText);
								if(result){
									if (i == reports.length-1){
										overlayGenericPrintDialog.close();
									}
								}
							}
						}
					});
				}
			}
			
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	function addPrintForm(){
		try{ 
			var content = "<table border='0' style='margin: auto; margin-top: 10px; margin-bottom: 10px;'>" +
							"<tr><td><input type='checkbox' id='convertDate' name='convertDate' style='float: left; margin-bottom: 3px;'><label style='margin: 2px 60px 0 4px;' for='convertDate'>Convert Date</label></td>"+
						  	"<td><input type='checkbox' id='uploadDate' name='uploadDate' style='float: left; padding-bottom: 3px; margin: 0 4px 3px 0;'><label for='uploadDate'>Upload Date</label></td></tr>";
			$("printDialogFormDiv3").update(content); 
			$("printDialogFormDiv3").show();
			enableButton("btnPrint");
			
			$("convertDate").checked = true;
			
			$("uploadDate").observe("click", function(){
				if (this.checked && nvl(guf.uploadDate, "*") == "*"){
					showMessageBox("This file has not been uploaded yet.", "E");
					$("uploadDate").checked = false;
				}
			});
		}catch(e){
			showErrorMessage("addPrintForm", e);	
		}
	}	
	
	$("btnPrintUpload").observe("click", function(){
		if(guf.tranClass == "" || guf.tranClass == null){
			showMessageBox("This file has not been uploaded yet.", "E");
		} else {
			tbgGUPC.onRemoveRowFocus();
			if($("rdoOR").checked){
				validatePrintOr();
			} else if($("rdoDV").checked){
				validatePrintDv();
			} else if($("rdoJV").checked){
				validatePrintJv();
			}
		}
	});
	
	function validatePrintOr(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			asynchronous: true,
			parameters : {action : "giacs608ValidatePrintOr",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					objACGlobal.callingForm = "GIACS608";
					objACGlobal.callingForm2 = "GIACS608";
					objGIACS608.fundCd = unescapeHTML2(obj.vFundCd);
					objGIACS608.fundDesc = unescapeHTML2(obj.vFundDesc);
					objGIACS608.branchCd = unescapeHTML2(obj.vBranchCd);
					objGIACS608.branchName = unescapeHTML2(obj.vBranchName);
					objGIACS608.gaccTranId = obj.vTranId;
					
					objGIACS608.sourceCd = guf.sourceCd;
					objGIACS608.fileNo = guf.fileNo;
					
					//nieko Accounting Uploading GIACS608
					objGIACS608.uploadQuery = unescapeHTML2(obj.vUploadQuery);
					
					new Ajax.Request(contextPath+"/GIACOrderOfPaymentController",{
						parameters: {
							action : "showBatchORPrinting"
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function (){
							showNotice("Loading, please wait...");
						},
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								//$("otherModuleDiv").update(response.responseText);
								//$("otherModuleDiv").show();
								$("mainContents").update(response.responseText);
								$("processInwardRIPremDiv").hide();
							}
						}
					});
				}
			}
		});
	}
	
	function validatePrintDv(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			asynchronous: true,
			parameters : {action : "validatePrintDv",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					var disbursement = "";
					if (obj.docCd == "BCSR" || obj.docCd == "CSR" || obj.docCd == "SCSR") {
						disbursement = "CPR";
					}else if (obj.docCd == "OFPPR") {
						disbursement = "FPP";
					}else if (obj.docCd == "CPR") {
						disbursement = "CP";
					}else{
						disbursement = "OP";
					}
					
					objGIACS608.sourceCd = guf.sourceCd;
					objGIACS608.fileNo = guf.fileNo;
					
					new Ajax.Request(contextPath+"/GIACPaytRequestsController",{
						parameters: {
							action: "showMainDisbursementPage",
							disbursement: disbursement,
							refId: obj.gprqRefId,
							newRec: "N",
							branch: obj.branchCd
						},
						asynchronous : false,
						evalScripts : true,
						onCreate : function() {
							showNotice("Getting Disbursement Page, please wait...");
						},
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								objACGlobal.callingForm = "GIACS608";
								objACGlobal.callingForm2 = "GIACS608";
								//$("otherModuleDiv").update(response.responseText);
								//$("otherModuleDiv").show();
								$("mainContents").update(response.responseText);
								$("processInwardRIPremDiv").hide();
							}
						}
					});
				}
			}
		});
	}
	
	function validatePrintJv(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			asynchronous: true,
			parameters : {action : "validatePrintJv",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					
					objGIACS608.sourceCd = guf.sourceCd;
					objGIACS608.fileNo = guf.fileNo;
					
					new Ajax.Request(contextPath + "/GIACJournalEntryController?action=showJournalEntries", {
						parameters : {
							action2 : "getJournalEntries",
							moduleId : "GIACS003",
							fundCd : obj.fundCd,
							branchCd : obj.branchCd,
							tranId : obj.tranId,
							pageStatus : ""
						},
						asynchronous : true,
						evalScripts : true,
						onCreate : showNotice("Loading, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								objACGlobal.callingForm = "GIACS608";
								objACGlobal.callingForm2 = "GIACS608";
								//$("otherModuleDiv").update(response.responseText);
								//$("otherModuleDiv").show();
								$("mainContents").update(response.responseText);
								$("processInwardRIPremDiv").hide();
							}
						}
					});
				}
			}
		});
	}
	
	/*$("btnUpload").observe("click", function(){
		if (parameters.fundCd == null || parameters.fundCd == ""){
			showMessageBox("Parameter FUND_CD is not defined in table GIAC_PARAMETERS.", imgMessage.ERROR);
			return false;
		}
		
		if (parameters.taxAllocation == "N"){
			showMessageBox("This module was designed to upload data only if the parameter: TAX_ALLOCATION = Y.", imgMessage.ERROR);
			return false;
		}
		
		if (guf.tranClass != null){
			showMessageBox("This file has already been uploaded.", imgMessage.ERROR);
			return false;
		}
		
		if (guf.fileStatus == "C"){
			showMessageBox("This is a cancelled file.", imgMessage.ERROR);
			return false;
		}
		
		if (unformatCurrency("txtCollectionAmtTotal") <= 0){
			showMessageBox("Total Collection Amount must be greater than zero.", imgMessage.ERROR);
			return false;
		}
		
		if (guf.dspTranClass == "O"){
			checkDetails();
		} else if (guf.dspTranClass == "J" || guf.dspTranClass == "D"){
			checkPaymentDetails();
		}
	});*/
	
	//nieko Accounting Uploading GIACS608, copy process from GIACS604
	$("btnUpload").observe("click", function(){
		function validateUpload(){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "validateUploadGiacs603",
							sourceCd : guf.sourceCd,
							fileNo : guf.fileNo
						 	  },
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						afterValidateUpload();
						
					}
				}
			});
		}
		
		function afterValidateUpload(){
			if($("rdoOR").checked){
				showConfirmBox("Confirmation", "O.R. transactions will be created for "
				           + parameters.branchCd +" branch. The indicated O.R. Date will be used for the transactions. Do you wish to proceed?"
				           , "Yes", "No",
						function(){
				        	   objGIACS608.branchCd = unescapeHTML2(parameters.branchCd); 
				        	   checkDcbNo();
						}, null
				);
			} else if ($("rdoDV").checked){
				if(checkUserPerIssCdAcctg(parameters.branchCd, "GIACS016")){
					showConfirmBox("Confirmation", "A Disbursement Request will be created for "
					           + parameters.branchCd +" branch. The indicated date in the Payment Request Details will be used for the transaction. Do you wish to proceed?"
					           , "Yes", "No",
							function(){
					        	checkPaymentDetails();
							}, null
					);
				} else {
					showMessageBox("You are not allowed to create a JV transaction for " + parameters.branchCd + " branch.", imgMessage.ERROR);
				}
			} else if ($("rdoJV").checked){
				if(checkUserPerIssCdAcctg(parameters.branchCd, "GIACS003")){
					showConfirmBox("Confirmation", "A JV transaction will be created for "
					           + parameters.branchCd +" branch. The indicated date in the JV Details will be used for the transaction. Do you wish to proceed?"
					           , "Yes", "No",
							function(){
					        	checkPaymentDetails();
							}, null
					);
				} else {
					showMessageBox("You are not allowed to create a Disbursement Request for " + parameters.branchCd + " branch.", imgMessage.ERROR);
				}
			}
		}
		
		validateUpload();
	});
	
	
	function checkDetails(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			asynchronous: true,
			parameters : {action : "checkDetailsGiacs608",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
						tranClass : "OR"
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					if (response.responseText.include("tranId")){
						proceedUpload();
					} else {
						var message = "An O.R. transaction will be created for " + parameters.branchCd + " branch. The indicated O.R. Date will be used for the transaction. Do you wish to proceed?";
						showConfirmBox2("Confirmation", message , "Yes", "No", function(){
							proceedUpload();
						}, null);	
					}
				}
			}
		});
	}
	
	function checkDcbNo() {
		try {
			new Ajax.Request(
					contextPath + "/GIACUploadingController",
					{
						method : "POST",
						parameters : {
							action : "checkDcbNoGiacs608",
							branchCd : objGIACS608.branchCd,
							orDate : $F("txtOrDate")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response)
									&& checkErrorOnResponse(response)) {
								if (response.responseText != "SUCCESS") {
									var arrMessage = response.responseText.split("#");
									var createDcb = "N";
									message = arrMessage[1] + " Create one?";
									showConfirmBox2("Create DCB No.", message, "Yes", "No",
											function() {
												message = arrMessage[1].replace("There is no open",
																"Before continuing, please make sure no one else is creating a")
														+ " Continue?";
												showConfirmBox2("Create DCB No.", message, "Yes", "No",
														function() {
															checkPaymentDetails();
														},
														function() {
															showMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO);
														});
											},
											function() {
												showMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO);
											});
								} else {
									checkPaymentDetails();
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("checkDcbNo", e);
		}
	}
	
	function checkPaymentDetails(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			asynchronous: true,
			parameters : {action : "checkPaymentDetailsGiacs608",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
						//tranClass : $("rdoDV").checked ? "DV" : "JV"
						tranClass : $("rdoDV").checked ? "DV" : ($("rdoJV").checked ?  "JV" : "OR")		
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					if (response.responseText.include("tranId")){
						checkOverride();
					} else {
						/*var message = "";
						if ($("rdoJV").checked){
							message = "A JV transaction will be created for " + parameters.params.branchCd + " branch. The indicated date in the JV Details will be used for the transaction. Do you wish to proceed?";
						} else if( $("rdoDV").checked){
							message = "A Disbursement Request will be created for " + parameters.params.branchCd + " branch. The indicated date in the Payment Request Details will be used for the transaction. Do you wish to proceed?";
						}
						showConfirmBox2("Confirmation", message , "Yes", "No", function(){
							proceedUpload();
						}, null);
						*/
						//nieko Accounting Uploading GIACS608, copy process from GIACS604
						checkOverride();
					}
				}
			}
		});
	}
	
	//nieko Accounting Uploading GIACS608, copy process from GIACS604
	function checkOverride(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "checkForOverride",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
						moduleId : "GIACS608"
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					 if (response.responseText.include("Geniisys Exception")){
						var message = response.responseText.split("#");
						showConfirmBox2("Confirmation",message[2], "Yes", "No",
							function(){
								showGenericOverride("GIACS608", "UA",
									function(ovr, userId, res){
										if(res == "FALSE"){
											showMessageBox(userId + " does not have an overriding function for this module.", imgMessage.ERROR);
											$("txtOverrideUserName").clear();
											$("txtOverridePassword").clear();
											return false;
										} else if(res == "TRUE"){
											overrideSw = "Y";
											uploadPayments();
											ovr.close();
											delete ovr;
										}
									},
									null
								);
							},
							""
						);
					 } else {
						 uploadPayments();
					 }
				}
			}
		});
	}
	
	function uploadPayments(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			asynchronous: true,
			parameters : {action : "proceedUploadGiacs608",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
						//tranClass : $("rdoDV").checked ? "DV" : "JV",
						tranClass : $("rdoDV").checked ? "DV" : ($("rdoJV").checked ?  "JV" : "OR"),		
						override : overrideSw ,
						orDate	: $("txtOrDate").value
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					showGiacs608();
				}
			}	
		});
	}

	function proceedUpload(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			asynchronous: true,
			parameters : {action : "proceedUploadGiacs608",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
						tranClass : $("rdoDV").checked ? "DV" : "JV",
						override : overrideSw 
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					if (response.responseText.include("override")){
						showConfirmBox2("Confirmation",message[2], "Yes", "No",
								function(){
									showGenericOverride("GIACS608", "UA",
										function(ovr, userId, res){
											if(res == "FALSE"){
												showMessageBox(userId + " does not have an overriding function for this module.", imgMessage.ERROR);
												$("txtOverrideUserName").clear();
												$("txtOverridePassword").clear();
												return false;
											} else if(res == "TRUE"){
												overrideSw = "Y";
												proceedUpload();
												ovr.close();
												delete ovr;
											}
										},
										null
									);
								},
								""
							);
					}
				}
			}
		});
	}
	
	$("btnCancelFile").observe("click", function(){
		if(guf.fileStatus != 1){
			showMessageBox("This file cannot be cancelled.", imgMessage.ERROR);
		} else {
			showConfirmBox("Confirmation", "Are you sure you want to cancel this file?", "Yes", "No",
					function(){
						cancelFile();
					}, null
			);
		}
	});
	
	function cancelFile(){
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "cancelFileGiacs603",
							sourceCd : guf.sourceCd,
							fileNo : guf.fileNo
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						disableButton("btnUpload");
						disableButton("btnPrintUpload");
						disableButton("btnCancelFile");
						disableButton("btnPaymentDetails");
					});
				}
			}
		});
	}
	
	
	//nieko Accounting Uploading GIACS608
	$("reloadFormGIACS608").observe("click", showGiacs608);
	
	$("uploadingExit").observe("click", function() {
		exitGiacs608();
	});
	
	function exitGiacs608() {
		try {
			$("processInwardRIPremDiv").hide();
			objACGlobal.callingForm = "GIACS608";
			objACGlobal.callingForm2 = "GIACS608";
			if (objACGlobal.prevForm == "GIACS601") {
				objGIACS608.convertDate = guf.convertDate;
				objGIACS608.sourceCd = guf.sourceCd;
				objGIACS608.sourceName = guf.dspSourceName;
				objGIACS608.remarks = guf.remarks;
				objGIACS608.noOfRecords = guf.noOfRecords;
				objGIACS608.totRecs = objUploading.totRecs;
				objGIACS608.fileNo = guf.fileNo;
				$("mainNav").show();
				showConvertFile();
			} else {
				showGiacs602();
			}
			objACGlobal.prevForm = "";
		} catch (e){
			showErrorMessage("exitGiacs608", e);
		}
	}
	
	function showGiacs602(){
		try {
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters:{
					action: "showProcessDataListing",
					sourceCd : $("txtNbtSourceCd").value 
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						objGIACS608.sourceCd = guf.sourceCd;
						objGIACS608.sourceName = guf.dspSourceName;
						hideAccountingMainMenus();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} catch (e){
			showErrorMessage("showGiacs602", e);
		}
	}
	
	$("btnOrDate").observe("click", function() { 
		scwNextAction = validateOrDate.runsAfterSCW(this, null); 
		scwShow($("txtOrDate"),this, null); 
	});
	
	function validateOrDate(){
		changeTag = 1;
	}
	
	$("rdoOR").observe("click", function(){
		$("lblOrDate").show();
		$("OrDateDiv").show();
	});
	
	$("rdoDV").observe("click", function(){
		$("lblOrDate").hide();
		$("OrDateDiv").hide();
	});
	
	$("rdoJV").observe("click", function(){
		$("lblOrDate").hide();
		$("OrDateDiv").hide();	
	});
</script>