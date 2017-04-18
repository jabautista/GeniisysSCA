<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="processOutwardRIPremDiv" name="processOutwardRIPremDiv" style="float: left; width: 100%;">
	<div id="toolbarExitGiacs609">
		<div id="toolbarDiv" name="toolbarDiv">	
			<div class="toolButton" style="float: right;">
				<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit2">Exit</span>
				<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Process Data for Outward Premium Payments</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormGiacs609" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="showDetails">
		<div id = "gufDiv" class="sectionDiv" style="padding: 15px 0 15px 0;">
			<table align="center">
				<tr>
					<td class="rightAligned">Batch No</td>
					<td class="leftAligned" style="padding-left: 4px">
						<input type="text" id="txtFileNo" style="width: 140px; text-align: left; margin-bottom: 0px;" readonly="readonly" tabindex="101"/>
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
					<td class="leftAligned" style="padding-left: 4px">
						<input type="text" id="txtRiCd" style="width: 140px; margin-bottom: 0px;" readonly="readonly" tabindex="105"/>
					</td>
					<td class="leftAligned" colspan="2" style="padding-left: 0">
						<input type="text" id="txtDspRi" style="width: 500px; margin-bottom: 0px;" readonly="readonly" tabindex="106"/>
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
	</div>
	<div id = "recordsDiv" class="sectionDiv" style="margin-bottom: 1px; padding: 2px 0 1px 0;">
			<div id="guopTableGrid" style="margin-left: 10px; height: 200px; margin-top: 10px;"></div>
			
			<fieldset class="sectionDiv" style="width:898px; margin:10px;">
				<legend style="font-weight: bold; font-size: 11px;">Totals</legend>
				<div id="totalsDiv" class="" style="padding:7px 10px 10px 7px;">
					<table align="center">
						<tr>
							<td class="rightAligned" style="width:120px;">Premium</td>
							<td class="leftAligned"><input type="text" id="txtTotPrem" style="width: 120px; text-align: right;" readonly="readonly" tabindex="111"/></td>
							<td class="rightAligned" style="width:120px;" alt="Premium VAT">P VAT</td>
							<td class="leftAligned"><input type="text" id="txtTotPvat" style="width: 120px; text-align: right;" readonly="readonly" tabindex="112"/></td>
							<td class="rightAligned" style="width:120px;">Comm</td>
							<td class="leftAligned"><input type="text" id="txtTotComm" style="width: 120px; text-align: right;" readonly="readonly" tabindex="113"/></td>
						</tr>
						<tr>
							<td class="rightAligned">C VAT</td>
							<td class="leftAligned"><input type="text" id="txtTotCvat" style="width: 120px; text-align: right;" readonly="readonly" tabindex="114"/></td>
							<td class="rightAligned">W VAT</td>
							<td class="leftAligned"><input type="text" id="txtTotWvat" style="width: 120px; text-align: right;" readonly="readonly" tabindex="115"/></td>
							<td class="rightAligned">Disb Amt</td>
							<td class="leftAligned"><input type="text" id="txtTotDisbAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="116"/></td>
						</tr>
						<tr>
							<td class="rightAligned">Prem Diff</td>
							<td class="leftAligned"><input type="text" id="txtTotPremDiff" style="width: 120px; text-align: right;" readonly="readonly" tabindex="117"/></td>
							<td class="rightAligned">Prem VAT Diff</td>
							<td class="leftAligned"><input type="text" id="txtTotPremVatDiff" style="width: 120px; text-align: right;" readonly="readonly" tabindex="118"/></td>	
							<td class="rightAligned" style="width:120px;">Comm Diff</td>
							<td class="leftAligned"><input type="text" id="txtTotCommDiff" style="width: 120px; text-align: right;" readonly="readonly" tabindex="119"/></td>				
						</tr>
						<tr>
							<td class="rightAligned">Comm VAT Diff</td>
							<td class="leftAligned"><input type="text" id="txtTotCommVatDiff" style="width: 120px; text-align: right;" readonly="readonly" tabindex="120"/></td>
							<td class="rightAligned">WVAT Diff</td>
							<td class="leftAligned"><input type="text" id="txtTotWvatDiff" style="width: 120px; text-align: right;" readonly="readonly" tabindex="121"/></td>	
						</tr>			
					</table>
				</div>
			</fieldset>
			
			<div id="resultDiv" style="float:left; width: 55%; height: 90px; margin: 5px 1px 5px 10px;">
				<table align="center">
					<tr>
						<td class="rightAligned" style="vertical-align: top; padding-top: 7px;">Checking Results</td>
						<td class="rightAligned" style="margin-left: 2px;">
							<textarea id="txtCheckingResults" style="resize: none; height: 75px; width: 360px;" readonly="readonly" tabindex="122"></textarea>
						</td>
					</tr>
				</table>
			</div>
			
			<fieldset class="sectionDiv" style="width:30%; margin:0 28px 0 3px; float: right;">
				<legend style="font-weight: bold; font-size: 11px;">Legend</legend>
				<div id="legendDiv" class="" style="padding:5px 7px 7px 7px;">
					<table>
						<tr>
							<td class="rightAligned" style="margin-left: 2px;">
								<textarea id="txtPremLegend" style="resize: none; height: 50px; width: 250px; background-color:#FFFF99;" readonly="readonly" tabindex="123"></textarea>
							</td>
						</tr>
					</table>
				</div>
			</fieldset>
			<div class="buttonsDiv" style="width: 100%; margin: 15px 0 15px 0;">
				<input type="button" class="button" id="btnForeignCurr" name="btnForeignCurr" value="Foreign Currency" style="width: 125px;" tabindex="124"/>
			</div>
		</div>
		
		<div id = "btnDiv" class="sectionDiv" style="padding-bottom: 10px;">
			<div style="width: 100%;">
				<fieldset class="sectionDiv" style="width: 240px; height: 50px; float:left; margin: 10px 0 0 70px;">
				<legend>Transaction</legend>
					<table style="margin-top: 8px;">
						<tr>
							<td width="8px"><input type="radio" id="rdoCOL" name="rdoTranClass" title="OR" value="COL" style="float: left; margin: 3px 2px 3px 30px;" tabindex="125"/></td>
							<td><label for="rdoCOL"> OR</label></td>
							<td width="8px"><input type="radio" id="rdoDV"  name="rdoTranClass" title="DV" value="DV" style="float: left; margin: 3px 2px 3px 30px;" tabindex="126"/></td>
							<td><label for="rdoDV"> DV</label></td>
							<td width="8px"><input type="radio" id="rdoJV"  name="rdoTranClass" title="JV" value="JV" style="float: left; margin: 3px 2px 3px 30px;" tabindex="127"/></td>
							<td><label for="rdoJV"> JV</label></td>
						</tr>
					</table>
				</fieldset>
				<table id="datesTable1" border="0" style="float:left; width:470px; margin: 25px 22px 0 40px;">
					<tr>
						<td class="leftAligned" style="width: 210px;">
						<label id="lblORDate" style="padding-top: 6px; width: 58px;">OR Date</label>
							<div style="float: left; width: 140px;" class="withIconDiv required"; id="oRDateDiv">
								<input type="text" id=txtNbtORDate class="withIcon date required" style="width: 115px;" readonly="readonly" ignoreDelKey="1" tabindex="128"/>
								<img id="btnORDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="OR Date" tabindex="129"/>
							</div>
						</td>
						<td class="rightAligned" style="padding-left: 15px;">Upload Date</td>
						<td class="leftAligned" style="padding-left: 4px">
							<input type="text" id="txtUploadDate" style="width: 140px;" readonly="readonly" tabindex="130"/>
						</td>					
					</tr>
				</table>
			</div>
		</div>
			
		<div class="buttonsDiv sectionDiv" align="center" style="width: 100%; margin-top: 0px; padding: 18px 0 18px 0;">
			<input type="button" class="button" id="btnCheckData" name="btnCheckData" value="Check Data" style="width: 125px;" tabindex="131"/>
			<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 125px;" tabindex="132"/>
			<input type="button" class="button" id="btnPrintReport" name="btnPrintReport" value="Print Report" style="width: 125px;" tabindex="133"/>
			<input type="button" class="button" id="btnUpload" name="btnUpload" value="Upload" style="width: 125px;" tabindex="134"/>
			<input type="button" class="button" id="btnCancelFile" name="btnCancelFile" value="Cancel File" style="width: 125px;" tabindex="135"/>
			<input type="hidden" id="guopCurrencyCd" />
			<input type="hidden" id="guopCurrencySname" />
			<input type="hidden" id="guopCurrencyDesc" />
			<input type="hidden" id="guopConvertRate" />
			<input type="hidden" id="guopTotLdisbAmt" />
		</div>
</div>
<script type="text/javascript">
	setModuleId("GIACS609");
	setDocumentTitle("Process Data for Outward Premium Payments");
	
	/* variables */
	objGIACS609 = {};
	parameters = JSON.parse('${jsonParameters}');
	
	guf = JSON.parse('${showGiacs609Head}');
	objGIACS609.recList = JSON.parse('${jsonGiacs609Table}');
	var legend = '${giacs609Legend}';
	var hasAccess = '${hasAccess}';
	var hasODFnc = '${hasODFnc}';
	var rowIndex = -1;
	var overridden = "N";
	
	/* observe elements */
	$("btnToolbarExit2").observe("click", function() {
		exitGiacs609();
	});
	
	$("reloadFormGiacs609").observe("click", function() {
		showGiacs609();
	});
	
	$("btnPayments").observe("click", function() {
		showPaytDtls();
	});
	
	$("btnForeignCurr").observe("click", function() {
		showFC();
	});
	
	$("rdoCOL").observe("click", function(){
		showORDate(true);
	});
	
	$("rdoDV").observe("click", function(){
		showORDate(false);
	});
	
	$("rdoJV").observe("click", function(){
		showORDate(false);
	});
	
	$("btnORDate").observe("click", function() {
		scwShow($("txtNbtORDate"),this, null);
	});
	
	$("btnCheckData").observe("click", function() {
		checkAccess();
	});
	
	$("btnPrint").observe("click", function(){
		if (nvl(guf.tranClass, "*") == "*"){
			showMessageBox("This file has not been uploaded yet.", "E");
		} else {
			tbgGUOP.onRemoveRowFocus();
			validatePrint();
		}
	});
	
	$("btnPrintReport").observe("click", showPrintDialog);
	
	$("btnUpload").observe("click", function() {
		checkUserFnc(true);
	});
	
	$("btnCancelFile").observe("click", function() {
		if (guf.fileStatus != 1) {
			showMessageBox("This file cannot be cancelled.", imgMessage.ERROR);
		} else {
			showConfirmBox("Confirmation", "Are you sure you want to cancel this file?",
					"Yes", "No", function() {
						cancelFile();
					}, null);
		}
	});
	
	/* funtions: populate details */
	function populateMainDetails() {
		try {
			$("txtFileNo").value = guf.fileNo;
			$("txtFileName").value = unescapeHTML2(guf.fileName);
			$("txtNbtSourceCd").value = unescapeHTML2(guf.sourceCd);
			$("txtNbtSourceName").value = unescapeHTML2(guf.dspSource);
			$("txtRiCd").value = unescapeHTML2(guf.riCd);
			$("txtDspRi").value = guf.dspRi;
			$("txtOrReqJVNo").value = unescapeHTML2(guf.dspOrRegJv);
			$("txtPremLegend").value = unescapeHTML2(legend);
			$("txtUploadDate").value = guf.uploadDate == null ? "" : dateFormat(guf.uploadDate, "mm-dd-yyyy");
			$("txtTranDate").value = guf.tranDate == null ? "" : dateFormat(guf.tranDate, "mm-dd-yyyy");

			$$("input[name='rdoTranClass']").each(function(rb) {
				if (rb.value == guf.tranClass) {
					rb.checked = true;
				}
			});
		} catch (e) {
			showErrorMessage("populateMainDetails", e);
		}
	}

	function populateTableGrid() {
		try {
			var guopTableModel = {
				url : contextPath
						+ "/GIACUploadingController?action=showGiacs609RecList&refresh=1&sourceCd="
						+ guf.sourceCd + "&fileNo=" + guf.fileNo,
				options : {
					width : '900px',
					hideColumnChildTitle : true,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						rowIndex = y;
						objGUOP = tbgGUOP.geniisysRows[y];
						setFieldValues(objGUOP);
						tbgGUOP.keys.removeFocus(tbgGUOP.keys._nCurrentFocus, true);
						tbgGUOP.keys.releaseKeys();
						$("txtCheckingResults").focus();
					},
					onRemoveRowFocus : function() {
						rowIndex = -1;
						setFieldValues(null);
						tbgGUOP.keys.removeFocus(tbgGUOP.keys._nCurrentFocus, true);
						tbgGUOP.keys.releaseKeys();
					},
					toolbar : {
						elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onFilter : function() {
							rowIndex = -1;
							setFieldValues(null);
							tbgGUOP.keys.removeFocus(tbgGUOP.keys._nCurrentFocus, true);
							tbgGUOP.keys.releaseKeys();
						}
					},
					onSort : function() {
						rowIndex = -1;
						setFieldValues(null);
						tbgGUOP.keys.removeFocus(tbgGUOP.keys._nCurrentFocus, true);
						tbgGUOP.keys.releaseKeys();
					},
					onRefresh : function() {
						rowIndex = -1;
						setFieldValues(null);
						tbgGUOP.keys.removeFocus(tbgGUOP.keys._nCurrentFocus, true);
						tbgGUOP.keys.releaseKeys();
					},
				},
				columnModel : [ {
					id : 'recordStatus',
					width : '0',
					visible : false
				}, {
					id : 'divCtrId',
					width : '0',
					visible : false
				}, {
					id : 'premChkFlag',
					title : 'P',
					altTitle : 'Premium Check Flag',
					titleAlign : 'center',
					width : '25px',
					filterOption : true
				}, {
					id : 'binderNo',
					filterOption : true,
					title : 'Binder No.',
					titleAlign : 'center',
					align : 'center',
					width : '100px'
				}, {
					id : 'lpremAmt',
					title : 'Prem',
					altTitle : 'Premium Amount',
					align : "right",
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'lpremVat',
					title : 'P Vat',
					altTitle : 'Premium VAT',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'lcommAmt',
					title : 'Comm',
					altTitle : 'Commission Amount',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'lcommVat',
					title : 'C Vat',
					altTitle : 'Commission VAT',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'lwholdingVat',
					title : 'W Vat',
					altTitle : 'Withholding VAT',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'ldisbAmt',
					title : 'Disb Amt',
					altTitle : 'Disbursement Amount',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'dspPremDiff',
					title : 'Prem Diff',
					altTitle : 'Premium Diff',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'dspPvatDiff',
					title : 'Prem VAT Diff',
					altTitle : 'Premium VAT Diff',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'dspCamtDiff',
					title : 'Comm Diff',
					altTitle : 'Commission Diff',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'dspCvatDiff',
					title : 'Comm VAT Diff',
					altTitle : 'Commission VAT Diff',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'dspWvatDiff',
					title : 'WVAT Diff',
					altTitle : 'Withholding VAT Diff',
					align : 'right',
					titleAlign : 'center',
					width : '100px',
					filterOptionType : 'number',
					filterOption : true,
					renderer : function(value) {
						return formatCurrency(value);
					}
				}, {
					id : 'chkRemarks',
					title : 'Checking Results',
					width : '0',
					visible : false,
					filterOption : true
				} ],
				rows : objGIACS609.recList.rows
			};

			tbgGUOP = new MyTableGrid(guopTableModel);
			tbgGUOP.pager = objGIACS609.recList;
			tbgGUOP.render("guopTableGrid");
			tbgGUOP.afterRender = function() {
				var row = tbgGUOP.geniisysRows.length > 0 ? tbgGUOP.geniisysRows[0] : [];

				$("txtTotPrem").value = formatCurrency(nvl(row.dspTotPrem, 0));
				$("txtTotPvat").value = formatCurrency(nvl(row.dspTotPvat, 0));
				$("txtTotComm").value = formatCurrency(nvl(row.dspTotComm, 0));
				$("txtTotCvat").value = formatCurrency(nvl(row.dspTotCvat, 0));
				$("txtTotWvat").value = formatCurrency(nvl(row.dspTotWvat, 0));
				$("txtTotDisbAmt").value = formatCurrency(nvl(row.dspTotDisb, 0));
				$("txtTotPremDiff").value = formatCurrency(nvl(row.dspTotPdiff, 0));
				$("txtTotPremVatDiff").value = formatCurrency(nvl(row.dspTotPvdiff, 0));
				$("txtTotCommDiff").value = formatCurrency(nvl(row.dspTotCdiff, 0));
				$("txtTotCommVatDiff").value = formatCurrency(nvl(row.dspTotCvdiff, 0));
				$("txtTotWvatDiff").value = formatCurrency(nvl(row.dspTotWvdiff, 0));
				$("guopCurrencyCd").value = row.currencyCd;
				$("guopCurrencySname").value = row.currencySname;
				$("guopCurrencyDesc").value = row.currencyDesc;
				$("guopConvertRate").value = row.convertRate;

				for (var i = 0; i < tbgGUOP.geniisysRows.length; i++) {
					if (nvl(tbgGUOP.geniisysRows[i].premChkFlag, "OK") != "OK") {
						$('mtgRow' + tbgGUOP._mtgId + '_' + i).style.color = "#FF6633";
					}
				}
			};

		} catch (e) {
			showErrorMessage("populateTableGrid", e);
		}
	}

	function setFieldValues(row) {
		$("txtCheckingResults").value = (row == null ? "" : unescapeHTML2(row.chkRemarks));
		
		if (row != null && (nvl(row.premChkFlag, "OK") != "OK")) {
			$("txtCheckingResults").style.color = "#FF6633";
		} else {
			$("txtCheckingResults").style.color = "black";
		}
		
		row == null ? disableButton("btnForeignCurr") : enableButton("btnForeignCurr");

		$$("input[name='rdoTranClass']").each(function(rb) {
			if (rb.value == guf.nbtTranClass) {
				rb.checked = true;
			}
		});
		toggleButtons();

		if (guf.fileStatus != 1) {
			$("txtNbtORDate").value = (row == null ? "" : (row.tranDate == null ? "" : dateFormat(row.tranDate, "mm-dd-yyyy")));
		}
	}

	/* functions: button */
	function toggleButtons() {
		if (guf.fileStatus == "C") {
			disableButton("btnCheckData");
			disableButton("btnUpload");
			disableButton("btnPrint");
			disableButton("btnCancelFile");
		} else if (guf.fileStatus != 1) {
			disableButton("btnCancelFile");
			disableButton("btnUpload");
			disableButton("btnCheckData");
		} else {
			enableButton("btnCancelFile");
			enableButton("btnUpload");
			enableButton("btnPrint");
			enableButton("btnCheckData");
		}
		if (guf.fileStatus != 1) {
			$("txtNbtORDate").removeClassName("required");
			$("oRDateDiv").removeClassName("required");
			disableDate("btnORDate");
			$("txtNbtORDate").disable();
			$("oRDateDiv").style.backgroundColor = "#d4d0c8";
		}
	}
	
	function showPaytDtls() {
		if ($("rdoCOL").checked) {
			showCollnDtl();
		} else if ($("rdoDV").checked) {
			showDVPaytDtl();
		} else if ($("rdoJV").checked) {
			showJVPaytDtl();
		} else {
			showMessageBox("Select transaction type the system will create.", imgMessage.ERROR);
		}
	}

	function showCollnDtl() {
		try {
			overlayCollnDtl = Overlay.show(contextPath + "/GIACUploadingController",
			{
				urlContent : true,
				urlParameters : {
					action : "showGiacs609CollnDtlOverlay",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo,
					ajax : "1",
				},
				title : "Collection Details",
				height : 500,
				width : 868,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showCollnDtl", e);
		}
	}

	function showDVPaytDtl() {
		try {
			overlayDVPaytDtl = Overlay.show(contextPath + "/GIACUploadingController",
				{
					urlContent : true,
					urlParameters : {
						action : "showGiacs609DVPaytDtl",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
						ajax : "1",
					},
					title : "Payment Request Details",
					height : 305,
					width : 805,
					draggable : true
				});
		} catch (e) {
			showErrorMessage("showDVPaytDtl", e);
		}
	}

	function showJVPaytDtl() {
		try {		
			overlayJVPaytDtl = Overlay.show(contextPath + "/GIACUploadingController",
				{
					urlContent : true,
					urlParameters : {
						action : "showGiacs609JVPaytDtl",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
						ajax : "1",
					},
					title : "JV Details",
					height : 240,
					width : 745,
					draggable : true
				});
		} catch (e) {
			showErrorMessage("showJVPaytDtl", e);
		}
	}

	function initProp() {
		if (guf.tranClass != null) {
			$("rdoCOL").disable();
			$("rdoDV").disable();
			$("rdoJV").disable();
		}

		if (guf.tranClass == "DV" || guf.tranClass == "JV") {
			showORDate(false);
		} else {
			$("rdoCOL").checked = true;
			showORDate(true);
		}

		disableButton("btnForeignCurr");
		toggleButtons();

		if (guf.fileStatus == "1") {
			$("txtNbtORDate").value = dateFormat(new Date(), "mm-dd-yyyy");
		}
	}

	function showORDate(show) {
		if (show) {
			$("lblORDate").show();
			$("oRDateDiv").show();
			$("txtNbtORDate").show();
		} else {
			$("lblORDate").hide();
			$("oRDateDiv").hide();
			$("txtNbtORDate").hide();
		}
	}

	function exitGiacs609() {
		try {
			$("processOutwardRIPremDiv").hide();
			objACGlobal.callingForm = "GIACS609";
			if (objACGlobal.prevForm == "GIACS601") {
				objGIACS609.convertDate = guf.convertDate;
				objGIACS609.sourceCd = guf.sourceCd;
				objGIACS609.sourceName = escapeHTML2($F("txtNbtSourceName"));
				objGIACS609.remarks = guf.remarks;
				objGIACS609.noOfRecords = guf.noOfRecords;
				objGIACS609.totRecs = objUploading.totRecs;
				objGIACS609.fileNo = guf.fileNo;
				$("mainNav").show();
				showConvertFile();
			} else {
				showGiacs602();
			}
			objACGlobal.prevForm = "";
			objACGlobal.callingForm2 = "";
		} catch (e) {
			showErrorMessage("exitGiacs609", e);
		}
	}

	function showGiacs602() {
		try {
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				parameters : {
					action : "showProcessDataListing",
					sourceCd : $("txtNbtSourceCd").value
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						objGIACS609.sourceCd = guf.sourceCd;
						objGIACS609.sourceName = $F("txtNbtSourceName");
						hideAccountingMainMenus();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} catch (e) {
			showErrorMessage("showGiacs602", e);
		}
	}

	function showGiacs609() {
		try {
			new Ajax.Updater("process", contextPath + "/GIACUploadingController", {
				parameters : {
					action : "showGiacs609",
					sourceCd : $("txtNbtSourceCd").value,
					fileNo : $("txtFileNo").value
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("convertFileMainDiv").hide();
					}
				}
			});
		} catch (e) {
			showErrorMessage("showGiacs609", e);
		}
	}
	
	function showFC() {
		try {
			overlayFC = Overlay.show(contextPath + "/GIACUploadingController",
				{
					urlContent : true,
					urlParameters : {
						action : "showGiacs609FC",
						ajax : "1",
					},
					title : "Foreign Currency",
					height : 340,
					width : 500,
					draggable : true
				});
		} catch (e) {
			showErrorMessage("showFC", e);
		}
	}
	
	function checkData(upload) {
		try {
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				method : "POST",
				parameters : {
					action : "checkDataGiacs609",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo,
					overridden : overridden
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						if (upload) {
							uploadBegin();
						} else {
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
								tbgGUOP._refreshList();
							});
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("checkData", e);
		}
	}
	
	function checkAccess() {
		if (hasAccess != 0) {
			checkUserFnc(false);
		} else {
			showMessageBox("You are not allowed to override to disburse full RI premiums.", imgMessage.ERROR);
		}
	}
		
	function checkUserFnc(upload) {
		try {
			if (hasODFnc == "N") {
				showConfirmBox2("Confirmation", "You can only disburse premiums based on paid direct premiums. Would you like to override to disburse full RI premiums?",
						"Yes", "No",
						function() {
							callOverride("GIACS019", "OD", "Override Records", upload);
						},
						function() {
							overridden = "N";
							checkData(upload);
						});
			} else {
				overridden = "Y";
				checkData(upload);
			}
		} catch (e) {
			showErrorMessage("checkUserFnc", e);
		}
	}
	
	function callOverride(moduleId, functionCd, title, upload) {
		try {
			showGenericOverride(moduleId, functionCd,
					function(ovr, userId, res) {
						if (res == "FALSE") {
							showMessageBox(userId + " does not have an overriding function for this module.", imgMessage.INFO);
							$("txtOverrideUserName").clear();
							$("txtOverridePassword").clear();
							return false;
						} else if (res == "TRUE") {
							if (moduleId == "GIACS019") {
								overridden = "Y";
								checkData(upload);
							} else {
								uploadPayments(upload);
							}
							
							ovr.close();
							delete ovr;
						}
					}, function() {
						tbgGUOP._refreshList();
					}, title);
		} catch (e) {
			showErrorMessage("callOverride", e);
		}
	}
	
	function validatePrint(){
		try {
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				method: "POST",
				parameters: {
					action:	"validatePrintGiacs609",
					sourceCd: guf.sourceCd,
					fileNo:	guf.fileNo,
					tranClass:	guf.tranClass,
					tranId:	guf.tranId
				},
				onCreate: showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){		
						var obj = JSON.parse(response.responseText);
						tbgGUOP.onRemoveRowFocus();
						objACGlobal.callingForm2 = "GIACS609";
						
						if (guf.tranClass == "COL") {
							showBatchORPrinting(obj);
						} else if (guf.tranClass == "DV") {
							showPaymentRequest(obj);
						} else if (guf.tranClass == "JV") {
							showJournalEntry(obj);
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("validatePrint", e);
		}
	}
	
	function showBatchORPrinting(obj) {
		try {
			objACGlobal.callingForm = "GIACS609";
			objGIACS609.fundCd = obj.fundCd;
			objGIACS609.fundDesc = obj.fundDesc;
			objGIACS609.branchCd = obj.branchCd;
			objGIACS609.branchName = obj.branchName;
			objGIACS609.tranId = obj.tranId;
			objGIACS609.sourceCd = guf.sourceCd;
			objGIACS609.fileNo = guf.fileNo;
			
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
						$("mainContents").update(response.responseText);
						$("processOutwardRIPremDiv").hide();
					}
				}
			});
		} catch (e) {
			showErrorMessage("showBatchORPrinting", e);
		}
	}
	
	function showPaymentRequest(obj) {
		try {
			objGIACS609.sourceCd = guf.sourceCd;
			objGIACS609.fileNo = guf.fileNo;
			var documentCd = "";
			
			if (obj.documentCd == "BCSR" || obj.documentCd == "CSR" || obj.documentCd == "SCSR") {
				documentCd = "CPR";
			} else if (obj.documentCd == "OFPPR") {
				documentCd = "FPP";
			} else if (obj.documentCd == "CPR") {
				documentCd = "CP";
			} else {
				documentCd = "OP";
			}
			
			new Ajax.Request(contextPath+"/GIACPaytRequestsController",{
				parameters: {
					action: "showMainDisbursementPage",
					disbursement: documentCd,
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
					if (checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						$("processOutwardRIPremDiv").hide();
					}
				}
			});
		} catch (e) {
			showErrorMessage("showPaymentRequest", e);
		}
	}
	
	function showJournalEntry(obj) {
		try {
			objGIACS609.sourceCd = guf.sourceCd;
			objGIACS609.fileNo = guf.fileNo;
			
			new Ajax.Request(contextPath + "/GIACJournalEntryController?action=showJournalEntries", {
				parameters : {
					action2 : "getJournalEntries",
					moduleId : "GIACS003",
					fundCd : obj.fundCd,
					branchCd : obj.branchCd,
					tranId : guf.tranId,
					pageStatus : ""
				},
				asynchronous : true,
				evalScripts : true,
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						$("processOutwardRIPremDiv").hide();
					}
				}
			});
		} catch (e) {
			showErrorMessage("showJournalEntry", e);
		}
	}
	
	function showPrintDialog() {
		try {
			overlayGenericPrintDialog = Overlay.show(contextPath+"/GIISController", {
				urlContent : true,
				urlParameters: {
					action : "showGenericPrintDialog",
					showFileOption : true
				},
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
		} catch (e) {
			showErrorMessage("showPrintDialog", e);
		}
	}
	
	function printReport() {
		try {
			if (!$("converted").checked && !$("uploaded").checked) {
				showMessageBox("Please select type of report.", "I");
				return false;
			}
			var content = contextPath+"/UploadingReportPrintController?action=printReport&sourceCd="+guf.sourceCd+
									"&fileName="+guf.fileNo+"&transactionCd=4&printerName="+$F("selPrinter");							
			var repDateParam = "";
			var reports = [];
			
			if ($("converted").checked) {
				repDateParam = guf.convertDate == "" || guf.convertDate == null ? "" : dateFormat(Date.parse(guf.convertDate), "mm-dd-yyyy");
				reportId = "GIACR601";
				reports.push({reportUrl : content+"&reportId="+reportId+"&fromDate="+repDateParam+"&toDate="+repDateParam,
							  reportTitle : reportId});
			}
			
			if ($("uploaded").checked) {
				repDateParam = guf.uploadDate == "" || guf.uploadDate == null ? "" : dateFormat(Date.parse(guf.uploadDate), "mm-dd-yyyy");
				reportId = "GIACR602";
				reports.push({reportUrl : content+"&reportId="+reportId+"&fromDate="+repDateParam+"&toDate="+repDateParam,
					  reportTitle : reportId});
			}

			if ("screen" == $F("selDestination")) {
				showMultiPdfReport(reports);
				reports = [];
			} else if ($F("selDestination") == "printer") {
				for (var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						asynchronous : false,
						parameters : {
							noOfCopies : $F("txtNoOfCopies")
						},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
								if (response.responseText == "SUCCESS") {
									if (i == reports.length-1) {
										overlayGenericPrintDialog.close();
									}
								} else {
									showMessageBox(response.responseText, imgMessage.INFO)
								}			
							}
						}
					});
				}
			} else if ("file" == $F("selDestination")) {
				for (var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						parameters : {
							destination : "FILE"
						},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
								if (response.responseText == "SUCCESS") {
									copyFileToLocal(response);
									if (i == reports.length-1) {
										overlayGenericPrintDialog.close();
									}
								} else {
									showMessageBox(response.responseText, imgMessage.INFO)
								}
							}
						}
					});
				}
			} else if ("local" == $F("selDestination")) {
				for (var i = 0; i < reports.length; i++) {
					new Ajax.Request(reports[i].reportUrl, {
						asynchronous : false,
						parameters : {
							destination : "LOCAL"
						},
						onComplete: function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
								var result = printToLocalPrinter(response.responseText);
								if (result){
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
							"<tr><td><input type='checkbox' id='converted' name='converted' style='float: left; margin-bottom: 3px;'><label style='margin: 2px 60px 0 4px;' for='converted'>Converted</label></td>"+
						  	"<td><input type='checkbox' id='uploaded' name='uploaded' style='float: left; padding-bottom: 3px; margin: 0 4px 3px 0;'><label for='uploaded'>Uploaded</label></td></tr>";
			$("printDialogFormDiv3").update(content); 
			$("printDialogFormDiv3").show();
			enableButton("btnPrint");
			
			$("converted").checked = true;
			
			$("uploaded").observe("click", function(){
				if (this.checked && nvl(guf.uploadDate, "*") == "*"){
					showMessageBox("This file has not been uploaded yet.", "I");
					$("uploaded").checked = false;
				}
			});
		}catch(e){
			showErrorMessage("addPrintForm", e);	
		}
	}
	
	function uploadBegin() {
		try {
			var tranClass = "";
			
			$$("input[name='rdoTranClass']").each(function(rb) {
				if (rb.checked == true) {
					tranClass = rb.value;
				}
			});
			
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				method : "POST",
				parameters : {
					action : "uploadBeginGiacs609",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo,
					tranClass : tranClass,
					tranDate : escapeHTML2($F("txtNbtORDate"))
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						tbgGUOP.onRemoveRowFocus();
						var obj = JSON.parse(response.responseText);
						if (nvl(obj.msg, "*") != "*") {
							if (obj.msg == "hasInvalid") {
								showConfirmBox("Confirmation", "User is not allowed to process invalid records. Would you like to override?",
									"Yes", "No", function() {
										callOverride("GIACS609", "UA", "Override All uploaded records", obj);
									}, function() {
										tbgGUOP._refreshList();
									}
								);
							} else {
								showConfirmBox("Confirmation", obj.msg, "Yes", "No", function() {
										validateTranDate(obj);
									}, function() {
										tbgGUOP._refreshList();
									}
								);
							}
						} else {
							showWaitingMessageBox("Uploading completed successfully.", imgMessage.SUCCESS, function() {
								fireEvent($("reloadFormGiacs609"), "click");
							});
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("uploadBegin", e);
		}
	}
	
	function validateTranDate(obj) {
		try {
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				method : "POST",
				parameters : {
					action : "validateTranDateGiacs609",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo,
					tranClass : obj.tranClass,
					branchCd : obj.branchCd,
					tranDate : obj.tranDate
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText);
						if (nvl(res.msg, "*") != "*") {
							if (res.msg == "hasInvalid") {
								showConfirmBox("Confirmation", "User is not allowed to process invalid records. Would you like to override?",
									"Yes", "No", function() {
										callOverride("GIACS609", "UA", "Override All uploaded records", res);
									}, function() {
										tbgGUOP._refreshList();
									}
								);
							} else {
								showConfirmBox("Create DCB No.", res.msg + " Create one?", "Yes", "No",
									function() {
										var msg = res.msg.replace("There is no open",
														"Before continuing, please make sure no one else is creating a")
												+ " Continue?";
										showConfirmBox("Create DCB No.", msg, "Yes", "No",
												function() {
													checkUploadAll(res);
												},
												function() {
													showMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO);
													tbgGUOP._refreshList();
												});
									},
									function() {
										showMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO);
										tbgGUOP._refreshList();
									});
							} 
						} else {
							showWaitingMessageBox("Uploading completed successfully.", imgMessage.SUCCESS, function() {
								fireEvent($("reloadFormGiacs609"), "click");
							});
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("validateTranDate", e);
		}
	}
	
	function checkUploadAll(obj) {
		try {
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				method : "POST",
				parameters : {
					action : "checkUploadAllGiacs609",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo,
					tranClass : obj.tranClass,
					tranDate : obj.tranDate
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText);
						if (res.validSw == "N") {
							showConfirmBox("Confirmation", "User is not allowed to process invalid records. Would you like to override?",
								"Yes", "No", function() {
									callOverride("GIACS609", "UA", "Override All uploaded records", res);
								}, function() {
									tbgGUOP._refreshList();
								}
							);
						} else {
							showWaitingMessageBox("Uploading completed successfully.", imgMessage.SUCCESS, function() {
								fireEvent($("reloadFormGiacs609"), "click");
							});
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("checkUploadAll", e);
		}
	}
	
	function uploadPayments(obj) {
		try {
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				method : "POST",
				parameters : {
					action : "uploadPaymentsGiacs609",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo,
					tranClass : obj.tranClass,
					tranDate : obj.tranDate
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						showWaitingMessageBox("Uploading completed successfully.", imgMessage.SUCCESS, function() {
							fireEvent($("reloadFormGiacs609"), "click");
						});
					}
				}
			});
		} catch (e) {
			showErrorMessage("uploadPayments", e);
		}
	}
	
	function cancelFile() {
		try {
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				method : "POST",
				parameters : {
					action : "cancelFileGiacs609",
					sourceCd : guf.sourceCd,
					fileNo : guf.fileNo
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
							tbgGUOP._refreshList();
							guf.fileStatus = "C";
							$("txtNbtORDate").value = "";
							toggleButtons();
						});
					}
				}
			});
		} catch (e) {
			showErrorMessage("cancelFile", e);
		}
	}
	
	/* populate details */
	populateMainDetails();
	populateTableGrid();
	initProp();
	initializeAll();
</script>