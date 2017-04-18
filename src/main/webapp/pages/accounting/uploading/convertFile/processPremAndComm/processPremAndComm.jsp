<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="processPremAndCommDiv" name="processPremAndCommDiv" style="float: left; width: 100%;">
	<div id="toolbarExitGiacs607">
		<div id="toolbarDiv" name="toolbarDiv">	
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit2">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExitDisabled">Exit</span>
		</div>
	 </div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Process Data for Premiums and Collections</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormGIACS607" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showDetails">	
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
					<td class="rightAligned">Intermediary</td>
					<td class="leftAligned" style="padding-left: 4px">
						<input type="text" id="txtIntmType" style="width: 40px; float: left; margin-bottom: 0px;" readonly="readonly" tabindex="104"/>
						<input type="text" id="txtIntmNo" style="width: 90px; text-align: right; margin: 2px 0 0 3px; float: left;" readonly="readonly" tabindex="105"/>
					</td>				
					<td class="leftAligned" colspan="2" style="padding-left: 0">
						<input type="text" id="txtRefIntmCd" style="width: 60px; float: left; margin-bottom: 0px;" readonly="readonly" tabindex="106"/>
						<input type="text" id="txtIntmName" style="width: 430px; margin: 2px 0 0 3px; float: left;" readonly="readonly" tabindex="107"/>
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
			<div id="gupcTableGrid" style="margin-left: 10px; height: 200px; margin-top: 10px;"></div>
			
			<fieldset class="sectionDiv" style="width:900px; margin:10px;">
				<legend style="font-weight: bold; font-size: 11px;">Totals</legend>
				<div id="totalsDiv" class="" style="padding:7px 10px 10px 10px;">
					<table>
						<tr>
							<td class="rightAligned" style="width:120px;">Gross Premium</td>
							<td class="leftAligned"><input type="text" id="txtTotGrossPremAmt" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned" style="width:120px;">Commission</td>
							<td class="leftAligned"><input type="text" id="txtTotCommAmt" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned" style="width:120px;">Withholding Tax</td>
							<td class="leftAligned"><input type="text" id="txtTotWhtaxAmt" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned" style="width:120px;">Input VAT</td>
							<td class="leftAligned"><input type="text" id="txtTotInputVATAmt" style="width: 100px; text-align: right;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="rightAligned">Net Amount Due</td>
							<td class="leftAligned"><input type="text" id="txtTotNetAmtDue" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned">GPrem Difference</td>
							<td class="leftAligned"><input type="text" id="txtTotGPremDiff" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned">Comm Difference</td>
							<td class="leftAligned"><input type="text" id="txtTotCommDiff" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned">WHTax Difference</td>
							<td class="leftAligned"><input type="text" id="txtTotWhtaxDiff" style="width: 100px; text-align: right;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td class="rightAligned">Input VAT Difference</td>
							<td class="leftAligned"><input type="text" id="txtTotInputVATDiff" style="width: 100px; text-align: right;" readonly="readonly"/></td>
							<td class="rightAligned">Net Due Difference</td>
							<td class="leftAligned"><input type="text" id="txtTotNetDueDiff" style="width: 100px; text-align: right;" readonly="readonly"/></td>					
						</tr>		
					</table>
				</div>
			</fieldset>
			
			<div id="resultDiv" style="float:left; width: 55%; height: 115px; margin: 5px 1px 5px 10px;">
				<table align="center">
					<tr id="orNoTR">
						<td class="rightAligned">OR No.</td>
						<td class="rightAligned">
							<input type="text" id="txtORNo" style="width: 360px;" readonly="readonly" tabindex="112"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="vertical-align: top; padding-top: 3px;">Checking Results</td>
						<td class="rightAligned" style="margin-left: 2px;">
							<textarea id="txtCheckingResults" style="resize: none; height: 35px; width: 360px;" readonly="readonly" tabindex="113"></textarea>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Payor</td>
						<td class="rightAligned">
							<input type="text" id="txtPayor" style="width: 360px;" readonly="readonly" tabindex="114"/>
						</td>
					</tr>
				</table>
			</div>
			
			<fieldset class="sectionDiv" style="width:30%; margin:0 5px 0 3px; float: left;">
				<legend style="font-weight: bold; font-size: 11px;">Legend</legend>
				<div id="legendDiv" class="" style="padding:5px 7px 7px 7px;">
					<table>
						<tr>
							<td class="leftAligned" style="width:120px;">Premium</td>
							<td class="leftAligned" style="width:120px;">Commission</td>
						</tr>
						<tr>
							<td class="rightAligned" style="margin-left: 2px;">
								<textarea id="txtPremLegend" style="resize: none; height: 50px; width: 170px; background-color:#FFFF99;" readonly="readonly" tabindex="115"></textarea>
							</td>
							<td class="rightAligned" style="margin-left: 2px;">
								<textarea id="txtCommLegend" style="resize: none; height: 50px; width: 170px; background-color:#FFFF99;" readonly="readonly" tabindex="116"></textarea>
							</td>
						</tr>
					</table>
				</div>
			</fieldset>
			
			<div class="buttonsDiv" style="width: 100%; margin: 15px 0 15px 0;">
				<input type="button" class="button" id="btnForeignCurr" name="btnForeignCurr" value="Foreign Currency" style="width: 125px;" tabindex="117"/>
			</div>
		</div>			
		
		<div id = "btnDiv" class="sectionDiv" style="padding-bottom: 10px; margin-bottom: 10px;">
			<div style="width: 100%;">
				<table id="tranClassTable" border="0" style="float:left; width:270px; margin: 10px 0 0 70px;">
					<tr>
						<td colspan="6" class="leftAligned">Transaction</td>
					</tr>
						<td width="8px"><input type="radio" id="rdoCOL" name="rdoTranClass" title="OR" value="COL" style="float: left; margin-left: 13px;" /></td>
						<td><label for="rdoCOL"> OR</label></td>
						<td width="8px"><input type="radio" id="rdoDV"  name="rdoTranClass" title="DV" value="DV" style="float: left; margin-left: 13px;" /></td>
						<td><label for="rdoDV"> DV</label></td>
						<td width="8px"><input type="radio" id="rdoJV"  name="rdoTranClass" title="JV" value="JV" style="float: left; margin-left: 13px;" /></td>
						<td><label for="rdoJV"> JV</label></td>
					</tr>
				</table>
				<table id="datesTable1" border="0" style="float:left; width:470px; margin: 20px 0 0 55px;">
					<tr>
						<td class="rightAligned">OR Date</td>
						<td class="leftAligned" style="padding-left: 4px">
							<!-- <input type="text" id="txtNbtORDate" style="width: 140px;" readonly="readonly" tabindex="118"/>  -->
							<div id="OrDateDiv" style="float: left; width: 150px;" class="withIconDiv">
								<input type="text" id="txtNbtORDate" name="txtNbtORDate" class="withIcon date" readonly="readonly" style="width: 125px;" tabindex="1005"/>
								<img id="btnOrDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="OR Date" tabindex="107"/>
							</div>
						</td>
						<td class="rightAligned" style="padding-left: 15px;">Upload Date</td>
						<td class="leftAligned" style="padding-left: 4px">
							<input type="text" id="txtUploadDate" style="width: 140px;" readonly="readonly" tabindex="119"/>
						</td>					
					</tr>
				</table>
				<table id="datesTable2" border="0" style="float:left; width:470px; margin: 20px 0 0 0;">
					<tr>
						<td class="rightAligned" style="padding-left: 15px;">Upload Date</td>
						<td class="leftAligned" style="padding-left: 4px">
							<input type="text" id="txtUploadDate2" style="width: 140px;" readonly="readonly" tabindex="119"/>
						</td>					
					</tr>
				</table>
			</div>
		</div>
			
		<div class="buttonsDiv" align="center" style="width: 100%; margin-top: 5px;">
			<input type="button" class="button" id="btnCheckData" name="btnCheckData" value="Check Data" style="width: 125px;" tabindex="120"/>
			<input type="button" class="button" id="btnPrintBTN" name="btnPrintBTN" value="Print" style="width: 125px;" tabindex="121"/>
			<input type="button" class="button" id="btnPrintReport" name="btnPrintReport" value="Print Report" style="width: 125px;" tabindex="122"/>
			<input type="button" class="button" id="btnPrintCS" name="btnPrintCS" value="Print CS" style="width: 125px;" tabindex="123"/>
			<input type="button" class="button" id="btnUpload" name="btnUpload" value="Upload" style="width: 125px;" tabindex="124"/>
			<input type="button" class="button" id="btnCancelFile" name="btnCancelFile" value="Cancel File" style="width: 125px;" tabindex="125"/>
		</div>
	</div>
</div>	

<div id="otherModuleDiv"></div>

<script type="text/javascript">
try{
	setModuleId("GIACS607");
	setDocumentTitle("Process Data for Premiums and Commissions");
	
	//observeReloadForm("reloadFormGIACS607", objUploading.showGIACS607); //nieko Accounting Uploading GIACS607
	
	var rowIndex = -1;
	
	guf = JSON.parse('${jsonGUF}');
	var legend = JSON.parse('${jsonLegend}');
	parameters = JSON.parse('${jsonParameters}');
	
	nbtTranClass = guf.nbtTranClass;
	
	objGUPC = null;
	objGIACS607 = {};
	objGIACS607.gupcList = JSON.parse('${jsonGUPC}');
	/*objGIACS607.noPremPayt = '${noPremPayt}';
	objGIACS607.hasAUFunction = '${hasAUFunction}';*/ //Deo [01.31.2017]: comment out (SR-5906)
	
	try{
		var gupcTableModel = {
				url : contextPath + "/GIACUploadingController?action=getGUPCRecords&sourceCd="+guf.sourceCd+"&fileNo="+guf.fileNo,
				options : {
					width : '888px',
					hideColumnChildTitle: true,
					pager : {},
					onCellFocus : function(element, value, x, y, id){
						rowIndex = y;
						objGUPC = tbgGUPC.geniisysRows[y];
						setFieldValues(objGUPC);
						tbgGUPC.keys.removeFocus(tbgGUPC.keys._nCurrentFocus, true);
						tbgGUPC.keys.releaseKeys();
						$("txtCheckingResults").focus();
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
						id : 'commChkFlag',
						title : '&#160;&#160;C',
						altTitle: 'Commission Check Flag',
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
						id : 'endtNo',
						filterOption : true,
						title : 'Endorsement No.',
						width : '100px'				
					},
					{
						id : "grossPremAmt",
						title : "Gross Premium",
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
						id : "commAmt",
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
						id : "whtaxAmt",
						title : "Withholding Tax",
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
						id : "inputVATAmt",
						title : "Input VAT",
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
						id : "netAmtDue",
						title : "Net Amount Due",
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
						id : "nbtGpremDiff",
						title : "GPrem Difference",
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
						id : "nbtCommDiff",
						title : "Comm Difference",
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
						id : "nbtWhtaxDiff",
						title : "WHTax Difference",
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
						id : "nbtInputVATDiff",
						title : "Input VAT Difference",
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
						id : "nbtNetDueDiff",
						title : "Net Due Difference",
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
				rows : objGIACS607.gupcList.rows
			};

			tbgGUPC = new MyTableGrid(gupcTableModel);
			tbgGUPC.pager = objGIACS607.gupcList;
			tbgGUPC.render("gupcTableGrid");
			tbgGUPC.afterRender = function(){
				var row = tbgGUPC.geniisysRows.length > 0 ? tbgGUPC.geniisysRows[0] : [];
				
				$("txtTotGrossPremAmt").value = formatCurrency(nvl(row.totGrossPremAmt, 0));
				$("txtTotCommAmt").value = formatCurrency(nvl(row.totCommAmt, 0));
				$("txtTotWhtaxAmt").value = formatCurrency(nvl(row.totWhtaxAmt, 0));
				$("txtTotInputVATAmt").value = formatCurrency(nvl(row.totInputVATAmt, 0));
				$("txtTotNetAmtDue").value = formatCurrency(nvl(row.totNetAmtDue, 0));
				$("txtTotGPremDiff").value = formatCurrency(nvl(row.totGPremDiff, 0));
				$("txtTotCommDiff").value = formatCurrency(nvl(row.totCommDiff, 0));
				$("txtTotWhtaxDiff").value = formatCurrency(nvl(row.totWhtaxDiff, 0));
				$("txtTotInputVATDiff").value = formatCurrency(nvl(row.totInputVATDiff, 0));
				$("txtTotNetDueDiff").value = formatCurrency(nvl(row.totNetDueDiff, 0));
				
				for (var i=0; i<tbgGUPC.geniisysRows.length; i++){
					if (nvl(tbgGUPC.geniisysRows[i].premChkFlag, "OK") != "OK" || nvl(tbgGUPC.geniisysRows[i].commChkFlag, "OK") != "OK"){
						$('mtgRow'+tbgGUPC._mtgId+'_'+i).style.color = "#FF6633";
					}
				}
			};
			
	}catch(e){
		showErrorMessage("GUPC tablegrid error", e);
	}
	
	function initAll(){
		$("otherModuleDiv").hide();
		
		if(objACGlobal.callingForm == "GIACS601"){
			$("toolbarExitGiacs607").innerHTML = "";
		}
		
		toggleButtons();
		populateMainDetails();
		setFieldValues(null);
		observeTranClass(guf.nbtTranClass);
	}
	
	function toggleButtons(){
		(guf.tranClass == "COL" && guf.nbtOrTag == "I") ? $("orNoTR").show() : $("orNoTR").hide();
		
		if (guf.nbtTranClass == "DV" || guf.nbtTranClass == "JV"){
			 $("orNoTR").hide();
			 disableButton("btnPrintCS");
		}else{
			 $("orNoTR").show();
			 enableButton("btnPrintCS");
		}
		
		if (guf.fileStatus == "C"){
			disableButton("btnCancelFile");
			disableButton("btnUpload");
			disableButton("btnPrintBTN");
			disableButton("btnPrintCS");
			
			disableDate("btnOrDate");
		}else if (guf.fileStatus != 1){
			disableButton("btnCancelFile");
			disableButton("btnUpload");
			disableButton("btnCheckData");
			
			disableButton("rdoCOL");
			disableButton("rdoDV");
			disableButton("rdoJV");
			
			disableDate("btnOrDate");
		}else{
			enableButton("btnCancelFile");
			enableButton("btnUpload");
			enableButton("btnPrintBTN");
			enableButton("btnPrintCS");
			enableButton("btnCheckData");
			
			enableButton("rdoCOL");
			enableButton("rdoDV");
			enableButton("rdoJV");
			
			enableDate("btnOrDate");
		}
	}
	
	function populateMainDetails(){
		try{
			$("txtFileNo").value = guf.fileNo;
			$("txtFileName").value = unescapeHTML2(guf.fileName);
			$("txtNbtSourceCd").value = unescapeHTML2(guf.sourceCd);
			$("txtNbtSourceName").value = unescapeHTML2(guf.nbtSourceName);
			$("txtIntmType").value = unescapeHTML2(guf.nbtIntmType);
			$("txtIntmNo").value = guf.intmNo;
			$("txtRefIntmCd").value = unescapeHTML2(guf.nbtRefIntmCd);
			$("txtIntmName").value = unescapeHTML2(guf.nbtIntmName);
			$("txtOrReqJVNo").value = unescapeHTML2(guf.nbtOrReqJvNo);
			$("txtTranDate").value = guf.tranDate == null ? "" : dateFormat(guf.tranDate, "mm-dd-yyyy");
			$("txtNbtORDate").value = guf.nbtOrDate == null ? "" : dateFormat(guf.nbtOrDate, "mm-dd-yyyy");
			$("txtUploadDate").value = guf.uploadDate == null ? "" : dateFormat(guf.uploadDate, "mm-dd-yyyy");
			$("txtUploadDate2").value = guf.uploadDate == null ? "" : dateFormat(guf.uploadDate, "mm-dd-yyyy");
			
			$$("input[name='rdoTranClass']").each(function(rb){
				if (rb.value == guf.nbtTranClass){
					rb.checked = true;
				}
			});
			
			$("txtPremLegend").value = unescapeHTML2(legend.premLegend);
			$("txtCommLegend").value = unescapeHTML2(legend.commLegend);
		}catch(e){
			showErrorMessage("populateMainDetails", e);
		}
	}

	function setFieldValues(row){
		$("txtCheckingResults").value = (row == null ? "" : unescapeHTML2(row.chkRemarks));
		$("txtPayor").value = (row == null ? "" : unescapeHTML2(row.payor));
		row == null ? disableButton("btnForeignCurr") : enableButton("btnForeignCurr");
		row == null ? disableButton("btnPrintCS") : enableButton("btnPrintCS");
		
		if (row != null && (nvl(row.premChkFlag, "OK") != "OK" || nvl(row.commChkFlag, "OK") != "OK")){
			$("txtCheckingResults").style.color = "#FF6633";
			$("txtPayor").style.color = "#FF6633";
		}else{
			$("txtCheckingResults").style.color = "black";
			$("txtPayor").style.color = "black";
		}
		
		toggleButtons();
	}
	
	function observeTranClass(tranClass){
		if (tranClass == "COL"){
			$("datesTable1").show();
			$("datesTable2").hide();
		}else{
			$("datesTable1").hide();
			$("datesTable2").show();			
		}
	}
	
	function showCollnDtl(){
		overlayCollnDtl = Overlay.show(contextPath+"/GIACUploadingController?action=showGIACS607CollnDtlOverlay&sourceCd="+guf.sourceCd+
										"&fileNo="+guf.fileNo,  {
				urlContent: true,
			 	title: "Collection Details",
			 	height: 535,
			 	width: 900,
			 	draggable: true
			}
		);
	}
	
	function showDVPaytDtl(){
		overlayDVPaytDtl = Overlay.show(contextPath+"/GIACUploadingController?action=showGIACS607DVPaytDtlOverlay&sourceCd="+guf.sourceCd+
							"&fileNo="+guf.fileNo,  {
				urlContent: true,
				title: "Payment Request Details",
				height: 305,
				width: 805,
				draggable: true
			}
		);
	}
	
	function showJVPaytDtl(){
		overlayJVPaytDtl = Overlay.show(contextPath+"/GIACUploadingController?action=showGIACS607JVPaytDtlOverlay&sourceCd="+guf.sourceCd+
							"&fileNo="+guf.fileNo,  {
				urlContent: true,
				title: "JV Details",
				height: 225,
				width: 745,
				draggable: true
			}
		);
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

	function printReport(){
		try {
			if (!$("convertDate").checked && !$("uploadDate").checked){
				showMessageBox("Please select type of report.", "I");
				return false;
			}
			
			var content = contextPath+"/UploadingReportPrintController?action=printReport&sourceCd="+guf.sourceCd+
									"&fileName="+guf.fileName+"&transactionCd=2&printerName="+$F("selPrinter");							
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
	
	function validateOnPrintBtn(){
		try{
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				method: "POST",
				parameters:{
					action:		"validateOnPrintBtnGIACS607",
					sourceCd:	guf.sourceCd,
					fileNo:		guf.fileNo
				},
				onCreate: showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){		
						var res = JSON.parse(response.responseText);
						tbgGUPC.onRemoveRowFocus();
						
						objACGlobal.callingForm = "GIACS607";
						objACGlobal.callingForm2 = "GIACS607";
						
						if (guf.tranClass == "COL"){
							objGIACS607.fundCd = parameters.fundCd;
							objGIACS607.fundDesc = parameters.fundDesc;
							objGIACS607.branchCd = res.branchCd;
							objGIACS607.branchName = res.branchName;
							objGIACS607.gaccTranId = res.gaccTranId;
							
							//nieko Accounting Uploading GIACS607
							objGIACS607.sourceCd = guf.sourceCd;
							objGIACS607.fileNo = guf.fileNo;
							objGIACS607.uploadQuery = unescapeHTML2(res.vUploadQuery);
							
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
										$("processPremAndCommDiv").hide();
									}
								}
							});
						}else if(guf.tranClass == "DV"){	
							var disbursement = "";
							if (res.docCd == "BCSR" || res.docCd == "CSR" || res.docCd == "SCSR") {
								disbursement = "CPR";
							}else if (res.docCd == "OFPPR") {
								disbursement = "FPP";
							}else if (res.docCd == "CPR") {
								disbursement = "CP";
							}else{
								disbursement = "OP";
							}
							
							objGIACS607.sourceCd = guf.sourceCd;
							objGIACS607.fileNo = guf.fileNo;
							
							new Ajax.Request(contextPath+"/GIACPaytRequestsController",{
								parameters: {
									action: "showMainDisbursementPage",
									disbursement: disbursement,
									refId: res.gprqRefId,
									newRec: "N",
									branch: res.branchCd
								},
								asynchronous : false,
								evalScripts : true,
								onCreate : function() {
									showNotice("Getting Disbursement Page, please wait...");
								},
								onComplete : function(response) {
									if (checkErrorOnResponse(response)) {
										objACGlobal.callingForm = "GIACS607";
										objACGlobal.callingForm2 = "GIACS607";
										//$("otherModuleDiv").update(response.responseText);
										//$("otherModuleDiv").show();
										$("mainContents").update(response.responseText);
										$("processPremAndCommDiv").hide();
									}
								}
							});
							
						}else if(guf.tranClass == "JV"){
							
							objGIACS607.sourceCd = guf.sourceCd;
							objGIACS607.fileNo = guf.fileNo;
							
							new Ajax.Request(contextPath + "/GIACJournalEntryController?action=showJournalEntries", {
								parameters : {
									action2 : "getJournalEntries",
									moduleId : "GIACS003",
									fundCd : parameters.fundCd,
									branchCd : res.branchCd,
									tranId : guf.tranId,
									pageStatus : ""
								},
								asynchronous : true,
								evalScripts : true,
								onCreate : showNotice("Loading, please wait..."),
								onComplete : function(response) {
									hideNotice();
									if (checkErrorOnResponse(response)) {
										objACGlobal.callingForm = "GIACS607";
										objACGlobal.callingForm2 = "GIACS607";
										//$("otherModuleDiv").update(response.responseText);
										//$("otherModuleDiv").show();
										$("mainContents").update(response.responseText);
										$("processPremAndCommDiv").hide();
									}
								}
							});
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("validateOnPrintBtn",e);
		}
	}	
	
	function continueUpload(){		
		var msg = "";
		
		new Ajax.Request(contextPath + "/GIACUploadingController",{
			parameters: {
				action:		"getParentIntmNoGIACS607",
				intmNo:		guf.intmNo
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					guf.parentIntmNo = response.responseText;
					
					if (nbtTranClass == "COL"){
						if (guf.nbtOrTag == "G"){
							msg = "An O.R. transaction will be created for "
						           + unescapeHTML2(parameters.branchCd) +' branch. The indicated O.R. Date will be used for the transaction. '
						           + "Do you wish to proceed?";
						}else{
							msg = "O.R. transactions will be created for "
						           + unescapeHTML2(parameters.branchCd) +' branch. The indicated O.R. Date will be used for the transactions. '
						           + "Do you wish to proceed?";
						}
						
						objGIACS607.branchCd = unescapeHTML2(parameters.branchCd);
						
						showConfirmBox("CONFIRMATION", msg, "Yes", "No", 
								function(){
									//checkUpload("COL"); nieko Accounting Uploading
									checkDcbNo();
								},
								null
						);
					}else if (nbtTranClass == "JV"){
						checkUserBranchAccess("JV");
					}else if (nbtTranClass == "DV"){
						checkUserBranchAccess("DV");
					}else{
						showMessageBox("This button only supports OR, DV and JV transactions.", "E");
						return;
					}
				}
			}
		});		
	}
	
	
	function checkUserBranchAccess(tranClass){
		var moduleId = tranClass == "JV" ? "GIACS003" : "GIACS016";
		
		new Ajax.Request(contextPath + "/GIACUploadingController", {
			parameters:{
				action:		"checkUserBranchAccessGIACS607",
				sourceCd:	guf.sourceCd,
				fileNo:		guf.fileNo,
				moduleId:	moduleId
			},
			onCreate: showNotice("Checking branch access, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if (tranClass == "JV"){
						msg = 'A JV transaction will be created for '
					           + unescapeHTML2(response.responseText)+ ' branch. '
					           + 'The indicated date in the JV Details will be used for the transaction. '
					           + 'Do you wish to proceed?';
					}else{
						msg = 'A Disbursement Request will be created for '
					           + unescapeHTML2(response.responseText)+ ' branch. '				
					           + 'The indicated date in the Payment Request Details will be used for the transaction. '
					           + 'Do you wish to proceed?';
					}
					showConfirmBox("CONFIRMATION", msg, "Yes", "No", 
							function(){
								checkUpload(tranClass);
							},
							null
					);
				}
			}
		});
	}
	
	function validatePolicy(func){
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			method: "POST",
			parameters:{
				action:		"validatePolicyGIACS607",
				sourceCd:	guf.sourceCd,
				fileNo:		guf.fileNo
			},
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					tbgGUPC._refreshList();
					for (var i=0; i<tbgGUPC.geniisysRows.length; i++){
						if (nvl(tbgGUPC.geniisysRows[i].premChkFlag, "OK") != "OK" || nvl(tbgGUPC.geniisysRows[i].commChkFlag, "OK") != "OK"){
							$('mtgRow'+tbgGUPC._mtgId+'_'+i).style.color = "#FF6633";
						}
					}
					
					if (func != null){
						func();
					}
				}
			}
		});
	}
	
	function checkUpload(tranClass){
		try{
			new Ajax.Request(contextPath + "/GIACUploadingController", {
				parameters:{
					action:		"checkUploadGIACS607",
					dspTranClass:	tranClass,
					sourceCd:	guf.sourceCd,
					fileNo:		guf.fileNo
				},
				onCreate: showNotice("Checking payments, please wait.."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var result = JSON.parse(response.responseText);
						if (result.cOverride == "Y"){
							showConfirmBox("CONFIRMATION", "Data to be processed contains at least one policy with existing claim. Would you like to continue with the processing?",
											"Yes", "No",
											function(){
												if (result.accessCcGiacs007 == "TRUE"){
													checkForOverride(result);
												}else{
													showConfirmBox("CONFIRMATION", "User is not allowed to process collections for policies with claim. Would you like to override?",
																	"Yes", "No",
																	function(){
																		if (result.accessCcGiacs007 == "TRUE"){
																			checkForOverride(result);
																		}else{
																			showGenericOverride("GIACS007", "CC",
																					function(ovr, userId, res){
																						if(res == "FALSE"){
																							showMessageBox(userId + " is not allowed to process collections for policies with existing claim.", imgMessage.ERROR);
																							$("txtOverrideUserName").clear();
																							$("txtOverridePassword").clear();
																							return false;
																						} else if(res == "TRUE"){
																							checkForOverride(result);
																							ovr.close();
																							delete ovr;
																						}
																					},
																					null
																			); // end of showGenericOverride
																		}
																	},
																	null
													); // end of showConfirmBox override
												}
											},
											null
							); // end of showConfirmBox
						}else{
							checkForOverride(result);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkUpload", e);
		}
	}
	
	function checkForOverride(result){
		if (result.oOverride == "Y"){
			if (result.accessUaGiacs607 == "FALSE"){
				showConfirmBox("CONFIRMATION", "User is not allowed to process invalid records. Would you like to override?",
						"Yes", "No",
						function() {
							showGenericOverride("GIACS607", "UA",
									function(ovr, userId, res){
										if(res == "FALSE"){
											showMessageBox(userId + " does not have an overriding function for this module.", imgMessage.ERROR);
											$("txtOverrideUserName").clear();
											$("txtOverridePassword").clear();
											return false;
										} else if(res == "TRUE"){
											uploadPayments(result);
											ovr.close();
											delete ovr;
										}
									},
									null
							);	//end of showGenericOverride
						},
						null
				);
			}else{
				uploadPayments(result);
			}
		} else {
			uploadPayments(result);
		}
	}
	
	function uploadPayments(result){
		try{
			new Ajax.Request(contextPath + "/GIACUploadingController",{
				parameters: {
					action:			"uploadPaymentsGIACS607",
					sourceCd:		guf.sourceCd,
					fileNo:			guf.fileNo,
					nbtTranClass: 	nbtTranClass,
					dcbNo:			result.dcbNo,
					orDate: 		$F("txtNbtORDate"),
					parameters:		prepareJsonAsParameter(parameters)
				},
				onCreate: showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showWaitingMessageBox("Uploading completed successfully.", imgMessage.SUCCESS, function(){
							//objGIACS601.showGIACS607(); //nieko Accounting Uploading
							showGiacs607();
						});		
					}
				}
			});
		}catch(e){
			showErrorMessage("uploadPayments", e);
		}
	}
	
	function cancelFile(){
		try{
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				method: "POST",
				parameters:{
					action:		"cancelFileGIACS607",
					sourceCd:	guf.sourceCd,
					fileNo:		guf.fileNo
				},
				onCreate: showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						disableButton("btnUpload");
						disableButton("btnCancelFile");
						disableButton("btnPrintBTN");
						disableButton("btnPrintCS");
					}
				}
			});
		}catch(e){
			showErrorMessage("cancelFile",e);
		}
	}
	
	$("btnForeignCurr").observe("click", function(){
		overlayFCurr = Overlay.show(contextPath+"/GIACUploadingController?action=showGIACS607FCurrOverlay",  {
				urlContent: true,
			 	title: "",
			 	height: 310,
			 	width: 420,
			 	draggable: true
			}
		);
	});
	
	$("btnPayments").observe("click", function(){
		if ($("rdoCOL").checked){
			showCollnDtl();
		}else if ($("rdoDV").checked){
			showDVPaytDtl();
		}else if ($("rdoJV").checked){
			showJVPaytDtl();
		}
	});
	
	$("btnCheckData").observe("click", function(){
		if (guf.tranClass != "" && guf.tranClass != null){
			showMessageBox("This file has already been uploaded.", "E");
		}else{
			validatePolicy();
		}
	});
	
	$("btnPrintBTN").observe("click", function(){
		if (guf.tranClass == "" || guf.tranClass == null){
			showMessageBox("This file has not been uploaded yet.", "E");	
		}else{
			validateOnPrintBtn();
		}
	});
	
	$("btnPrintReport").observe("click", showPrintDialog);
	
	$("btnPrintCS").observe("click", function(){
		/*if (nbtTranClass == "COL" && guf.nbtOrTag == "I"){
			showMessageBox("Please select the payor first.", "I");	
		}else*/
		if (objGUPC == null){
			showMessageBox("Please select a record first.", "I");
		}else{
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				method: "POST",
				parameters:{
					action:		"checkOrPaytsGIACS607",
					tranId:	 	objGUPC.tranId
				},
				onCreate: showNotice("Checking, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if (response.responseText == "1"){
							objACGlobal.callingForm2 = "GIACS607";
							objACGlobal.gaccTranId = objGUPC.tranId;
							
							new Ajax.Updater("otherModuleDiv", contextPath+ "/GIACCommSlipController?action=showCommSlip", {
								parameters : {
									gaccTranId : objACGlobal.gaccTranId,
									page : 1
								},
								asynchronous : false,
								evalScripts : true,
								onCreate : function() {
									showNotice("Loading OR Preview...");
								},
								onComplete : function() {
									hideNotice("");
									$("otherModuleDiv").show();
									$("processPremAndCommDiv").hide();
								}
							});
						}else if (guf.nbtOrTag == "I"){
							showMessageBox("O.R. for the selected payor has not been printed yet.", "I");
						}else{
							showMessageBox("O.R. has not been printed yet.", "I");
						}
					}
				}
			});
		}
	});
	
	/*function checkAUOverride(){
		showConfirmBox("CONFIRMATION", "User cannot disburse commission for unpaid premium. Would you like to override?",
				"Yes", "No",
				function() {
					showGenericOverride("GIACS020", "AU",
							function(ovr, userId, res){
								if(res == "FALSE"){
									showMessageBox(userId + " is not allowed to process collections for policies with claim", imgMessage.ERROR);
									$("txtOverrideUserName").clear();
									$("txtOverridePassword").clear();
									return false;
								} else if(res == "TRUE"){
									startUpload();
									ovr.close();
									delete ovr;
								}
							},
							function() {
								$("txtOverrideUserName").clear();
								$("txtOverridePassword").clear();
							}
					);
				},
				function(){	// no for USER confirmation
					null;
				}
		);
	}*/ //Deo [01.31.2017]: comment out (SR-5906)
	
	$("btnUpload").observe("click", function(){
		/*if(objGIACS607.noPremPayt == "Y"){
			if(objGIACS607.hasAUFunction == "Y"){
				startUpload();
			} else {
				checkAUOverride();
			}
		} else if (objGIACS607.noPremPayt == "N"){*/ //Deo [01.31.2017]: comment out (SR-5906)
			startUpload();
		//} //Deo [01.31.2017]: comment out (SR-5906)
	});
	
	function startUpload(){
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			method: "POST",
			parameters:{
				action:		"validateBeforeUploadGIACS607",
				sourceCd:	guf.sourceCd,
				fileNo:		guf.fileNo,
				tranClass:  nbtTranClass
			},
			onCreate: showNotice("Validating, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					validatePolicy(continueUpload);
				}
			}
		});
	}
	
	$("btnCancelFile").observe("click", function(){
		if (guf.fileStatus != 1){
			showMessageBox("This file cannot be cancelled.", "E");
		}else{
			showConfirmBox("Confirmation", "Are you sure you want to cancel this file?",
								"Yes", "No", cancelFile, null
			);
		}
	});
	
	$$("input[name='rdoTranClass']").each(function(rb){
		rb.observe("click", function(){
			observeTranClass(rb.value);
			nbtTranClass = rb.value;
		});
	});
	
	$("acExit").stopObserving();
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
	});
	
	/*
	** nieko Accounting Uploading GIACS607
	$("btnToolbarExit2").observe("click", function() {
		objACGlobal.callingForm = "";
		$("process").innerHTML = "";
		$("process").hide();
		$("processDataListingDiv").show();
		$("acExit").stopObserving();
		$("acExit").observe("click", function() {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
	});*/
	
	initAll();
	
	function showGiacs607(){
		new Ajax.Updater("process", contextPath+"/GIACUploadingController",{
			parameters:{
				action: "showGIACS607",
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
	
	//nieko Accounting Uploading GIACS607
	$("reloadFormGIACS607").observe("click", showGiacs607);
	
	$("btnToolbarExit2").observe("click", function() {
		exitGiacs607();
	});
	
	function exitGiacs607() {
		try {
			$("processPremAndCommDiv").hide();
			objACGlobal.callingForm = "GIACS607";
			objACGlobal.callingForm2 = "GIACS607";
			if (objACGlobal.prevForm == "GIACS601") {
				objGIACS607.convertDate = guf.convertDate;
				objGIACS607.sourceCd = guf.sourceCd;
				objGIACS607.sourceName = guf.nbtSourceName;
				objGIACS607.remarks = guf.remarks;
				objGIACS607.noOfRecords = guf.noOfRecords;
				objGIACS607.totRecs = objUploading.totRecs;
				objGIACS607.fileNo = guf.fileNo;
				
				$("mainNav").show();
				showConvertFile();
			} else {
				showGiacs602();
			}
			objACGlobal.prevForm = "";
		} catch (e){
			showErrorMessage("exitGiacs607", e);
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
						objGIACS607.sourceCd = guf.sourceCd;
						objGIACS607.sourceName = guf.nbtSourceName;
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
		scwShow($("txtNbtORDate"),this, null); 
	});
	
	function validateOrDate(){
		changeTag = 1;
	}
	
	function checkDcbNo() {
		try {
			new Ajax.Request(
					contextPath + "/GIACUploadingController",
					{
						method : "POST",
						parameters : {
							action : "checkDcbNoGiacs607",
							branchCd : objGIACS607.branchCd,
							orDate : $F("txtNbtORDate")
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
															checkUpload("COL");
														},
														function() {
															showMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO);
														});
											},
											function() {
												showMessageBox("Cannot create an O.R. without a DCB No.", imgMessage.INFO);
											});
								} else {
									checkUpload("COL");
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("checkDcbNo", e);
		}
	}

	//nieko Accounting Uploading end
}catch(e){
	showErrorMessage("Page error", e);
}	
</script>