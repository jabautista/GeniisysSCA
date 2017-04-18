<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/reInsurance/menu.jsp"/>
<div id="riAcceptanceMainDiv" style="margin-top: 5px;" changeTagAttr="true">
	<form id="enterRiAcceptanceForm" name="enterRiAcceptanceForm">
		
		<div id="frpsDetailsMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>FRPS Details</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div class="sectionDiv" id="frpsDetailsDiv">
				
				<table align="center">
					<tr>
						<td class="rightAligned" width="100px">FRPS No.</td>
						<td class="leftAligned" colspan="2" width="200px">
							<!--<input type="text" id="frpsNo" name="frpsNo" style="width: 120px;" readonly="readonly" />
								<input type="button" id="searchWFrpsRi" name="searchWFrpsRi" class="button" value="Search" style="width: 100px; display: none;" />
								-->
							<div style="width: 186px; float: left;" class="withIconDiv">
								<input type="text" id="frpsNo" name="frpsNo" value="" style="width: 155px;" class="withIcon" readonly="readonly">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchWFrpsRi" name="searchWFrpsRi" alt="Go" />
							</div>			
							<input type="hidden" id="loadFromUWMenu" name="loadFromUWMenu" value="${fromUWMenu}" />					
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">PAR No.</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="riParNo" name="riParNo" style="width: 180px;" readonly="readonly" />
						</td>
						<td class="rightAligned" width="180px">Endorsement No.</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="riEndtNo" name="riEndtNo" style="width: 180px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">Policy No.</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="riPolicyNo" name="riPolicyNo" style="width: 180px;" readonly="readonly" />
						</td>
						<td class="rightAligned" width="180px">Currency</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="riCurrency" name="riCurrency" style="width: 180px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">Total Premium</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="totalPremium" name="totalPremium" style="width: 180px;" readonly="readonly" class="money2" />
						</td>
						<td class="rightAligned" width="180px">Facultative TSI</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="facultativeTSI" name="facultativeTSI" style="width: 180px;" readonly="readonly" class="money2" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="100px">Total TSI</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="totalTsi" name="totalTsi" style="width: 180px;" readonly="readonly" class="money2" />
						</td>
						<td class="rightAligned" width="180px">Facultative Premium</td>
						<td class="leftAligned" width="200px">
							<input type="text" id="facultativePrem" name="facultativePrem" style="width: 180px;" readonly="readonly" class="money2" />
						</td>
					</tr>
				</table>
				
			</div>
		</div>
		
		<div id="reinsurersListMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>List of Reinsurers</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
					</span>
				</div>
			</div>
			<div id="reinsurerListDiv" class="sectionDiv">
				<input type="hidden" id="sumRiCommAmt" name="sumRiCommAmt" value="0" />
				<input type="hidden" id="sumRiPremAmt" name="sumRiPremAmt" value="0" />
				<input type="hidden" id="sumRiTsiAmt" name="sumRiTsiAmt" value="0" />
				<input type="hidden" id="sumRiPremVat" name="sumRiPremVat" value="0" />
				<input type="hidden" id="inputVatRate" name="inputVatRate" value="${inputVatRate}" />
				<input type="hidden" id="adjustPremVat" name="adjustPremVat" value="" />
				<input type="hidden" id="vStatus" name="vStatus" value="" />
				<input type="hidden" id="selectedFrpsRi" value="" />
				<div id="wfrpsRITableGrid" style="position:relative; height: 180px; margin: 10px; margin-top: 5px; margin-bottom: 10px;"></div>
				<div class="buttonsDiv" style="padding: 2px; margin-bottom: 10px; margin-top: 0px;">
					<input type="button" class="disabledButton" id="btnRecompute" name="btnRecompute" value="Recompute RI Premium VAT" />
				</div>
			</div>
		</div>	
		
		<div id="riAddtlInfoDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Additional Information</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
					</span>
				</div>
			</div>
			<jsp:include page="/pages/underwriting/reInsurance/enterRIAcceptance/subPages/enterRiAcceptAddtlInfo.jsp"></jsp:include>
		</div>
		
		<div id="riPerilListMainDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>RI Peril List</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
					</span>
				</div>
			</div>
			<div id="riPerilListDiv" class="sectionDiv">
				<div id="frPerilTableGrid" style="position:relative; height: 180px; margin: 10px; margin-top: 5px; margin-bottom: 5px; "></div>
				<table border="0" align="center" style="margin-bottom: 5px;">
					<tr>
						<td class="rightAligned">Peril</td>
						<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtPerilName" name="" value="" readonly="readonly"/></td>
					</tr>
					<tr>
						<td class="rightAligned">RI Share %</td>
						<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiShrPct" name="txtRiShrPct" value="" maxlength="12" class="nthDecimal" nthDecimal="8" errorMsg="Field must be form of 990.99999999"/></td>
					</tr>
					<tr>
						<td class="rightAligned">RI TSI Amount</td>
						<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiTsiAmt" name="txtRiTsiAmt" value=""  maxlength="22" class="money" errorMsg="Entered ri tsi amount is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99."/></td>
					</tr>
					<tr>
						<td class="rightAligned">RI Premium Amt</td>
						<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiPremAmt" name="txtRiPremAmt" value="" maxlength="17" class="money" errorMsg="Entered ri premium amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99."/></td>
					</tr>
					<tr>
						<td class="rightAligned">RI Commission %</td>
						<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiCommRt" name="txtRiCommRt" value="" maxlength="14" class="nthDecimal" nthDecimal="9" errorMsg="Field must be form of 990.999999999"/></td>
					</tr>
					<tr>
						<td class="rightAligned">RI Prem VAT</td>
						<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtRiPremVat" name="txtRiPremVat" value="" maxlength="14" class="money" errorMsg="Entered ri prem vat is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99."/></td>
					</tr>
					<tr>
						<td class="rightAligned">RI Prem Tax</td>
						<td class="leftAligned" ><input style="width: 260px;" type="text" id="txtPremTax" name="txtPremTax" value="" maxlength="14" class="money" errorMsg="Entered ri prem tax is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99."/></td>
					</tr>
					<tr>
						<td colspan="2" align="center"><input type="button" id="btnUpdatePeril" name="btnUpdatePeril" class="disabledButton" value="Update" style="width: 100px;"/></td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="buttonsDiv">
			<input type="button" id="btnPost"			name="btnPost"				class="button" value="Post" style="width: 100px;"/>
			<input type="button" id="btnPrint"			name="btnPrint"				class="button" value="Print Binder" style="width: 100px;">
			<input type="button" id="btnCancel"			name="btnCancel" 			class="button" value="Cancel" style="width: 100px;" />
			<input type="button" id="btnSave" 			name="btnSave" 				class="button" value="Save" style="width: 100px;" />			
		</div>
	</form>
</div>

<script type="text/javascript">
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setDocumentTitle("Enter RI Acceptance");
	window.scrollTo(0,0); 	
	hideNotice("");

	if($F("loadFromUWMenu") == "Y") {
		$("searchWFrpsRi").show();
	} else {
		$("searchWFrpsRi").hide();
	}
	
	var objWFrpsRi = new Object(); 
	var objWFrperil = new Object();

	var selectedFrpsRi = null;
	var selectedFrperil = null;

	var selectedFrpsRiRow = new Object();
	var selectedFrperilRow = new Object();
	var perilUpdated = false;
	var riPremVatOld = 0;
	var editedPerilRow = null;
	var fnlBinderId = null;
	var modified = "";

	var frPerilTableURL = contextPath+"/GIRIWFrpsRiController?action=loadWFrperilGrid&frpsYy="+selectedFrpsRiRow.frpsYy
						+"&lineCd="+selectedFrpsRiRow.lineCd+"&frpsSeqNo="+selectedFrpsRiRow.frpsSeqNo+
						"&riSeqNo="+selectedFrpsRiRow.riSeqNo+"&riCd="+selectedFrpsRiRow.riCd+
						"&distNo="+objRiFrps.distNo+"&distSeqNo="+objRiFrps.distSeqNo;
	
	objWFrpsRi.wFrpsRiTableGrid = JSON.parse('${wFrpsRiGrid}'.replace(/\\/g, '\\\\'));
	objWFrpsRi.wFrpsRi = objWFrpsRi.wFrpsRiTableGrid.rows || [];
	
	objWFrperil.frPerilTableGrid = JSON.parse('${wFrperilGrid}'.replace(/\\/g, '\\\\'));
	objWFrperil.frPeril = objWFrperil.frPerilTableGrid.rows || [];
	
	setFrpsMainInfo(objRiFrps);
	
	var sumRiCommAmt = 0;
	var sumRiPremAmt = 0;
	var sumRiTsiAmt = 0;
	var sumRiPremVat = 0;
	
	var sveRiCommAmt = 0;
	var sveRiPremAmt = 0;
	var sveRiTsiAmt = 0;
	var sveRiCommRt = 0;
	var sveRiPremVat = 0;
	var sveRiShrPct = 0;
	
	var riPremVatN = 0;
	var riPremVatO = 0;
	
	function setWFrpsRiAddtlInfo(obj) {
		try {
			if(obj == null) {
				$("txtAddress1").value		=	"";
				$("txtAddress2").value		=	"";
				$("txtAddress3").value		=	"";
				$("txtRemarks").value		=	"";
				$("txtBinder1").value		=	"";
				$("txtBinder2").value		=	"";
				$("txtBinder3").value		=	"";
				$("txtAcceptedBy").value	=	"";
				$("txtASNo").value			=	"";
				$("txtAcceptDate").value	=	"";

				disableButton("btnUpdate");
			} else {
				$("txtAddress1").value		=	unescapeHTML2(obj.address1);
				$("txtAddress2").value		=	unescapeHTML2(obj.address2);
				$("txtAddress3").value		=	unescapeHTML2(obj.address3);
				$("txtRemarks").value		=	unescapeHTML2(obj.remarks);
				$("txtBinder1").value		=	unescapeHTML2(obj.bndrRemarks1);
				$("txtBinder2").value		=	unescapeHTML2(obj.bndrRemarks2);
				$("txtBinder3").value		=	unescapeHTML2(obj.bndrRemarks3);
				$("txtAcceptedBy").value	=	unescapeHTML2(nvl(obj.riAcceptBy, ""));
				$("txtASNo").value			=	nvl(obj.riAsNo, "");
				$("txtAcceptDate").value	=	nvl(obj.riAcceptDate, "") == "" ? "" : 
												dateFormat(obj.riAcceptDate, "mm-dd-yyyy");
				enableButton("btnUpdate");
			}
		} catch(e) {
			showErrorMessage("setWFrpsRiAddtlInfo", e);
		}
	}
	
	try {
		var wFrpsRiTable = {
			url: contextPath+"/GIRIWFrpsRiController?action=refreshWFrpsRiGrid&frpsYy="+objRiFrps.frpsYy
					+"&lineCd="+objRiFrps.lineCd+"&frpsSeqNo="+ objRiFrps.frpsSeqNo,
			options: {
				title: '',
				//width: '800px',
				height: '150px',
				//align: 'center'
				onCellFocus: function(element, value, x, y, id) {
					var mtgId = frpsRiGrid._mtgId;
					selectedFrpsRi = y;
					enableButton("btnRecompute");
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedFrpsRiRow = frpsRiGrid.geniisysRows[y];
						fnlBinderId = selectedFrpsRiRow.dspFnlBinderId;
						setWFrpsRiAddtlInfo(selectedFrpsRiRow);
						wFrperilTable.url = contextPath+"/GIRIWFrpsRiController?action=loadWFrperilGrid&frpsYy="+selectedFrpsRiRow.frpsYy
											+"&lineCd="+selectedFrpsRiRow.lineCd+"&frpsSeqNo="+selectedFrpsRiRow.frpsSeqNo+
											"&riSeqNo="+selectedFrpsRiRow.riSeqNo+"&riCd="+selectedFrpsRiRow.riCd+
											"&distNo="+objRiFrps.distNo+"&distSeqNo="+objRiFrps.distSeqNo;
						frPerilGrid.refreshURL(wFrperilTable);
						frPerilGrid.refresh();
						
						sumRiCommAmt = frPerilGrid.pager.sumRiCommAmt;
						sumRiPremAmt = frPerilGrid.pager.sumRiPremAmt;
						sumRiTsiAmt = frPerilGrid.pager.sumRiTsiAmt;
						sumRiPremVat = frPerilGrid.pager.sumRiPremVat;
					}
					getAdjustPremVatParam(selectedFrpsRi.riCd);
				},
				onRemoveRowFocus: function() {
					wFrperilTable.url = contextPath+"/GIRIWFrpsRiController?action=loadWFrperilGrid&frpsYy="+0
								+"&lineCd="+""+"&frpsSeqNo="+0+"&riSeqNo="+0+"&riCd="+0+"&distNo="+0+"&distSeqNo="+0;
					
					frPerilGrid.refreshURL(wFrperilTable);
					frPerilGrid.refresh();
					supplyPeril(null);//niknok
					setWFrpsRiAddtlInfo(null);

					sumRiCommAmt = 0;
					sumRiPremAmt = 0;
					sumRiTsiAmt = 0;
					sumRiPremVat = 0;
					disableButton("btnRecompute");
					selectedFrpsRi = null;
					fnlBinderId = null;
				}	
			},
			columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	
					id: 'lineCd',
					width: '0',
					visible: false
				},
				{
					id: 'frpsYy',
					width: '0',
					visible: false
				},
				{
					id: 'frpsSeqNo',
					width: '0',
					visible: false
				},
				{
					id: 'riSeqNo',
					width: '0',
					visible: false
				},
				{
					id: 'riCd',
					width: '0',
					visible: false
				},
				{
					id: 'preBinderId',
					width: '0',
					visible: false
				},

				{
					id: 'riSname',
					title: 'Reinsurer',
					width: '100px',
					titleAlign: 'center',
					editable: false
				},
				{
					id: 'riShrPct',
					title: 'RI Share %',
					width: '100px',
					titleAlign: 'center',
					editable: false,
					geniisysClass: 'rate'
				},
				{
					id: 'riTsiAmt',
					title: 'RI TSI Amt',
					width: '100px',
					titleAlign: 'center',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'riPremAmt',
					title: 'RI Prem Amt',
					width: '100px',
					titleAlign: 'center',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'riPremVat',
					title: 'RI Prem Vat',
					width: '100px',
					titleAlign: 'center',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'riCommRt',
					title: 'RI Comm %',
					width: '100px',
					titleAlign: 'center',
					align: 'right',
					editable: false,
					geniisysClass: 'rate'
				},
				{
					id: 'riCommAmt',
					title: 'RI Comm Amt',
					width: '100px',
					titleAlign: 'center',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'riCommVat',
					title: 'RI Comm Vat',
					width: '100px',
					titleAlign: 'center',
					align: 'right',
					geniisysClass: 'money'
				},
				{
					id: 'premTax',
					title: 'Premium Tax',
					width: '100px',
					titleAlign: 'center',
					align: 'right',
					editable: false,
					geniisysClass: 'money'
				},
				{
					id: 'netDue',
					title: 'Net Due',
					width: '100px',
					titleAlign: 'center',
					align: 'right',
					editable: false,
					geniisysClass: 'money'	
				}, 
				{
					id: 'address1',
					width: '0',
					visible: false
				},
				{
					id: 'address2',
					width: '0',
					visible: false
				},
				{
					id: 'address3',
					width: '0',
					visible: false
				},
				{
					id: 'remarks',
					width: '0',
					visible: false
				},
				{
					id: 'bndrRemarks1',
					width: '0',
					visible: false
				},
				{
					id: 'bndrRemarks2',
					width: '0',
					visible: false
				},
				{
					id: 'bndrRemarks3',
					width: '0',
					visible: false
				},
				{
					id: 'riAcceptBy',
					width: '0',
					visible: false
				},
				{
					id: 'riAsNo',
					width: '0',
					visible: false
				},
				{
					id: 'riAcceptDate',
					width: '0',
					visible: false
				}
			],
			resetChangeTag: true,
			rows: objWFrpsRi.wFrpsRi
		};

		frpsRiGrid = new MyTableGrid(wFrpsRiTable);
		frpsRiGrid.pager = objWFrpsRi.wFrpsRiTableGrid;
		frpsRiGrid.render('wfrpsRITableGrid');

	}catch(e) {
		showErrorMessage("frpsRiGrid", e);
	}

	function setFrpsMainInfo(row) {
		try {
			if(row != null) {
				$("frpsNo").value			=	row.frpsNo == null ? "" : row.frpsNo;
				$("riParNo").value			=	row.parNo	== null ? "" : row.parNo;
				$("riEndtNo").value			=	row.endtNo == null ? "" : row.endtNo;
				$("riPolicyNo").value		=	row.policyNo == null ? "" : row.policyNo;
				$("riCurrency").value		=	row.currDesc == null ? "" : row.currDesc;
				$("totalPremium").value		=	isNaN(row.premAmt) ? "" : formatCurrency(row.premAmt);
				$("facultativeTSI").value	=	isNaN(row.totFacTsi) ? "" : formatCurrency(row.totFacTsi);
				$("totalTsi").value			=	isNaN(row.tsiAmt) ? "" : formatCurrency(row.tsiAmt);
				$("facultativePrem").value  = 	isNaN(row.totFacPrem) ? "" : formatCurrency(row.totFacPrem);
			}
		} catch(e) {
			showErrorMessage("setFrpsMainInfo", e);
		}
	}
	
	try {
		var wFrperilTable = {
			url: frPerilTableURL,
			options: {
				title: '',
				//width: '800px',
				height: '150px',
				//align: 'center',
				onCellFocus: function(element, value, x, y, id) {
					selectedFrperil = Number(y);
					//selectedFrperilRow = frPerilGrid.geniisysRows[y];
					selectedFrperilRow = frPerilGrid.getRow(y);
					
					sveRiShrPct = parseFloat(frPerilGrid.getRow(y).riShrPct);
					sveRiPremAmt = unformatCurrencyValue(frPerilGrid.getRow(y).riPremAmt);
					sveRiCommAmt = unformatCurrencyValue(frPerilGrid.getRow(y).riCommAmt);
					sveRiTsiAmt = unformatCurrencyValue(frPerilGrid.getRow(y).riTsiAmt);
					perilIdOnFocus = id;
					supplyPeril(selectedFrperilRow);//niknok
				}, 
				onCellBlur: function(element, value, x, y, id){
					observeChangeTagInTableGrid(frPerilGrid);
				},
				onRemoveRowFocus: function() {
					selectedFrperil = null;
					supplyPeril(null);//niknok
				}	
			},
			columnModel : [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	
					id: 'lineCd',
					width: '0',
					visible: false
				},
				{
					id: 'frpsYy',
					width: '0',
					visible: false
				},
				{
					id: 'frpsSeqNo',
					width: '0',
					visible: false
				},
				{
					id: 'riSeqNo',
					width: '0',
					visible: false
				},
				{
					id: 'riCd',
					width: '0',
					visible: false
				},
				{
					id: 'perilCd',
					width: '0',
					visible: false
				},
				{
					id: 'perilSname',
					width: '0',
					visible: false
				},
				{
					id: 'perilName',
					width: '138px',
					title: 'Peril',
					align: 'left',
					titleAlign: 'center',
					editable: false
				},
				{
					id: 'riShrPct',
					width: '120px',
					title: 'RI Share %',
					align: 'right',
					titleAlign: 'center',
					editable: false
				},
				{
					id: 'riTsiAmt',
					width: '120px',
					title: 'RI TSI Amount',
					align: 'right',
					titleAlign: 'center',
					geniisysClass: 'money',
					editable: false,//niknok (fnlBinderId == null ? true : false),
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							var result = true;
							if(parseFloat(value*1) < 0 ) {
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('riPremAmt')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
							}
							if(result) {
								var coords = frPerilGrid.getCurrentPosition();
								var y = coords[1]*1;
								editedPerilRow = frPerilGrid.getRow(y);
								
								calcPerilRiShrPct(editedPerilRow, y);
								calcPerilRiPremAmt(editedPerilRow, y);
								calcPerilRiCommAmt(editedPerilRow, y);
								calcSumRiPremAmt(editedPerilRow);	
								calcSumRiTsiAmt(editedPerilRow);
								calcSumRiCommAmt(editedPerilRow, y);
								calcFrpsRiPremAmt();
								calcFrpsRiTsiAmt();
								calcFrpsRiShrPct();
								calcFrpsRiCommAmt(editedPerilRow, y);
								calcFrpsRiCommRt(editedPerilRow); 
								computeNetDue(frpsRiGrid.getRow(y));
							}
							return result;
						}
					})
				},
				{
					id: 'riPremAmt',
					width: '120px',
					title: 'RI Premium Amt',
					align: 'right',
					titleAlign: 'center',
					geniisysClass: 'money',
					editable: false,//niknok (fnlBinderId == null ? true : false), 
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							var result = true;
							if(parseFloat(value*1) < 0 ) {
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('riPremAmt')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
							}
							if(result) {
								var coords = frPerilGrid.getCurrentPosition();
								var y = coords[1]*1;
								editedPerilRow = frPerilGrid.getRow(y);
								
								if(parseFloat(sveRiPremAmt) != parseFloat(value)) {
									getInputVatRate(editedPerilRow.riCd);
									var tempVat = unformatCurrencyValue(value)*parseFloat($F("inputVatRate"))/100;
									frPerilGrid.setValueAt(adjustPremVat(tempVat), 
											frPerilGrid.getColumnIndex('riPremVat'),y, true);
									
								}
																		
								calcPerilRiShrPct2(editedPerilRow, y);	
								calcPerilRiTsiAmt(editedPerilRow, y);	
								calcPerilRiCommAmt(editedPerilRow, y);
								calcSumRiPremAmt(editedPerilRow);	
								calcSumRiTsiAmt(editedPerilRow);
								calcSumRiCommAmt(editedPerilRow, y);
								calcFrpsRiPremAmt();
								calcFrpsRiTsiAmt();
								calcFrpsRiShrPct();
								calcFrpsRiCommAmt(editedPerilRow, y);
								calcFrpsRiCommRt(editedPerilRow); 
								computeNetDue(editedPerilRow);
							}
							return result;
						}
					})
				},
				{	
					id: 'riCommRt',
					width: '120px',
					title: 'RI Commission %',
					align: 'right',
					titleAlign: 'center',
					geniisysClass: 'rate',
					geniisysMinValue: '0.00',
					geniisysMaxValue: '100.00',
					geniisysErrorMsg: 'Entered comm rate is invalid. Valid value is from 0.00 to 100.',
					editable: false,
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							var result = true;
							if(parseFloat(value*1) < 0 || parseFloat(value) >= 100) {
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('riCommRt')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
							} 
							if(result) {
								var coords = frPerilGrid.getCurrentPosition();
								var y = coords[1]*1;
								editedPerilRow = frPerilGrid.getRow(y);
								
								calcPerilRiCommAmt(editedPerilRow, y);
								calcSumRiCommAmt(editedPerilRow, y);
								calcFrpsRiCommAmt2(y);
								calcFrpsRiCommRt(editedPerilRow); 
								computeNetDue(editedPerilRow);
							}
							return result;
						}
					}) 
				},
				{
					id: 'riPremVat',
					width: '120px',
					title: 'RI Prem VAT',
					align: 'right',
					titleAlign: 'center',
					geniisysClass: 'money',
					editable: false,
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							var result = true;
							if(parseFloat(value*1) < 0) {
								showMessageBox(tableGrid.columnModel[tableGrid.getColumnIndex('riPremVat')].geniisysErrorMsg, imgMessage.ERROR);
								result = false;
							} 		
							if(result) {
								var coords = frPerilGrid.getCurrentPosition();
								var y = coords[1]*1;
								editedPerilRow = frPerilGrid.getRow(y);
								
								calcSumRiPremVat(editedPerilRow);
								calcFrpsRiPremVat();
							}
							return result;
						}
					})
				},
				{
					id: 'premTax',
					width: '120px',
					title: 'RI Prem Tax',
					align: 'right',
					titleAlign: 'center',
					geniisysClass: 'money',
					editable: false,
					defaultValue: "0.00"
				},
				{
					id: 'riCommVat',
					width: '0',
					visible: false,
					geniisysClass: 'money'
				},
				{
					id: 'riCommAmt',
					width: '0',
					visible: false
				},
				{
					id: 'distTsi',
					width: '0',
					visible: false
				},
				{
					id: 'distPrem',
					width: '0',
					visible: false
				}
			],
			resetChangeTag: true,
			rows: objWFrperil.frPeril
		};

		frPerilGrid = new MyTableGrid(wFrperilTable);
		frPerilGrid.pager = objWFrperil.frPerilTableGrid;
		frPerilGrid.render('frPerilTableGrid');
	} catch(e) {
		showErrorMessage("setFrperilGrid", e);
	}

	observeReloadForm("reloadForm", 
			function() {
				if($F("loadFromUWMenu") == "Y") objRiFrps = new Object();
				showEnterRIAcceptancePage($F("loadFromUWMenu"));
			});

	$("searchWFrpsRi").observe("click", function() {
		showDistFrpsLOV("getGIRIDistFrpsLOV", "GIRIS002");
	});

	$("btnUpdate").observe("click", function() {
		selectedFrpsRiRow.address1			=	escapeHTML2($F("txtAddress1"));
		selectedFrpsRiRow.address2			=	escapeHTML2($F("txtAddress1"));
		selectedFrpsRiRow.address3			=	escapeHTML2($F("txtAddress1"));
		selectedFrpsRiRow.remarks			=	escapeHTML2($F("txtRemarks"));
		selectedFrpsRiRow.bndrRemarks1		=	escapeHTML2($F("txtBinder1"));
		selectedFrpsRiRow.bndrRemarks2		=	escapeHTML2($F("txtBinder2"));
		selectedFrpsRiRow.bndrRemarks3		=	escapeHTML2($F("txtBinder3"));
		selectedFrpsRiRow.riAcceptBy		=	escapeHTML2($F("txtAcceptedBy"));
		selectedFrpsRiRow.riAsNo			=	$F("txtASNo");
		selectedFrpsRiRow.riAcceptDate		=	$F("txtAcceptDate");

		frpsRiGrid.updateRowAt(selectedFrpsRiRow, selectedFrpsRi);
		setWFrpsRiAddtlInfo(null);
		changeTag = 1;
		//frpsRiGrid.modifiedRows.push(selectedFrpsRiRow);
	});

	$("btnCancel").observe("click", function () {
		if($F("loadFromUWMenu") == "Y") objRiFrps = new Object();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	function saveRiAcceptance() {
 		try {
 			var objParameters = new Object();
 			objParameters.setFrpsRi = frpsRiGrid.getModifiedRows();
 			objParameters.setFrperil = frPerilGrid.getModifiedRows();
 			var param = JSON.stringify(objParameters);
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {
				method: "POST",
				parameters: {
					action : "saveRIAcceptace",
					parameters: param
				},
				asychronous: false,
				evalScripts: true,
				onCreate: function() {
					showNotice("Saving RI Acceptance");
				},
				onComplete: function(response) {
					hideNotice("");
					changeTag = 0;
					if(checkErrorOnResponse(response)) {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					} else {
						showMessageBox(response, "e");
					}
				}
			});
 		} catch(e) {
			showErrorMessage("saveRiAcceptance", e);
 		}
	}

	$("btnSave").observe("click", function() {
		saveRiAcceptance();
	});

	function computeNetDue() {
		try {
			var premAmt = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riPremAmt"), selectedFrpsRi));
			var premTax = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("premTax"), selectedFrpsRi));
			var commAmt = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riCommAmt"), selectedFrpsRi));
			var premVat = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riPremVat"), selectedFrpsRi));
			var commVat = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riCommVat"), selectedFrpsRi));
			
			var netDue = premAmt - premTax - commAmt + premVat - commVat;
			frpsRiGrid.setValueAt(netDue, frpsRiGrid.getColumnIndex('netDue'), selectedFrpsRi, true);
		} catch(e) {
			showErrorMessage("computeNetDue", e);
		}
	}

	//compute_sum_d110_ri_comm_amt
	function calcSumRiCommAmt(row, index) {
		sumRiCommAmt = parseFloat(sumRiCommAmt) - sveRiCommAmt + parseFloat(row.riCommAmt);
		$("sumRiCommAmt").value = sumRiCommAmt;
	}

	function calcSumRiPremAmt(row) {
		sumRiPremAmt = parseFloat(sumRiPremAmt) - sveRiPremAmt + parseFloat(row.riPremAmt);
		$("sumRiPremAmt").value = sumRiPremAmt;
	}

	function calcSumRiTsiAmt(row) {
		sumRiTsiAmt = parseFloat(sumRiTsiAmt) - sveRiTsiAmt + parseFloat(row.riTsiAmt);
		$("sumRiTsiAmt").value = sumRiTsiAmt;
	}
	

	function calcSumRiPremVat(row) {
		sumRiPremVat = parseFloat(sumRiPremVat) - sveRiPremVat + parseFloat(row.riPremVat);
		$("sumRiPremVat").value = sumRiPremVat;
	}

	function calcFrpsRiCommAmt2(index) {
		var temp = Math.round(parseFloat(sumRiCommAmt), 2);
		frpsRiGrid.setValueAt(temp, frpsRiGrid.getColumnIndex('riCommAmt'), index, true);
		if($F("inputVatRate") == "" || $F("inputVatRate") == "0") {
			getInputVatRate(selectedFrpsRiRow.riCd);
		}
		var obj = frpsRiGrid.getRow(index);
		frpsRiGrid.setValueAt(unformatCurrencyValue(obj.riCommAmt)*parseFloat($F("inputVatRate"))/100,
				frpsRiGrid.getColumnIndex('riCommVat'), index, true);
		//frpsRiGrid.setValueAt(($F("sumRiCommAmt")*()));
	}

	function calcFrpsRiCommAmt(row, index) {
		if($F("inputVatRate") == "" || $F("inputVatRate") == "0") {
			getInputVatRate(selectedFrpsRiRow.riCd);
		}
		frpsRiGrid.setValueAt(sumRiCommAmt, frpsRiGrid.getColumnIndex('riCommAmt'), selectedFrpsRi, true);
		//		parseFloat($F("inputVatRate"))/100);
		frpsRiGrid.setValueAt(parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex('riCommAmt'), selectedFrpsRi)) * 
				parseFloat($F("inputVatRate"))/100,
				frpsRiGrid.getColumnIndex('riCommVat'), selectedFrpsRi, true); 
	}

	function calcFrpsRiCommRt(row) {
		var temp = 0;
		if(row.riPremAmt != null || row.riPremAmt != 0) {
			temp = (row.riCommAmt / row.riPremAmt) * 100;
		}
		frpsRiGrid.setValueAt(temp, frpsRiGrid.getColumnIndex('riCommRt'), selectedFrpsRi, true);
	}

	function calcFrpsRiPremAmt() {
		if($F("inputVatRate") == "" || $F("inputVatRate") == "0") {
			getInputVatRate(selectedFrpsRiRow.riCd);
		}
			//		+$F("inputVatRate")+"; "+selectedFrpsRi);
		frpsRiGrid.setValueAt(sumRiPremAmt, frpsRiGrid.getColumnIndex('riPremAmt'), selectedFrpsRi, true);
		var riPremVat = (parseFloat(sumRiPremAmt) * parseFloat($F("inputVatRate"))/100);
		riPremVat = adjustPremVat(riPremVat);
		frpsRiGrid.setValueAt(riPremVat, frpsRiGrid.getColumnIndex('riPremVat'), selectedFrpsRi, true);
	}

	function calcFrpsRiPremVat() {
		frpsRiGrid.setValueAt(sumRiPremVat, frpsRiGrid.getColumnIndex('riPremVat'), selectedFrpsRi, true);
		riPremVatN = frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex('riPremVat'), selectedFrpsRi);
		//variable.v_ri_prem_vat_n := NVL(:d120.nbt_ri_prem_vat,0);
	}

	function calcFrpsRiShrPct() {
		var temp = 0;//
		if($F("totalTsi") != "" && parseFloat($F("totalTsi")) != 0) {
			temp = parseFloat(frpsRiGrid.getValueAt(frpsRiGrid.getColumnIndex("riTsiAmt"), selectedFrpsRi)) / (unformatCurrencyValue($F("totalTsi")));
		}
		frpsRiGrid.setValueAt(temp*100, frpsRiGrid.getColumnIndex("riShrPct"), selectedFrpsRi, true);
	}

	function calcFrpsRiTsiAmt() {
		frpsRiGrid.setValueAt(sumRiTsiAmt, frpsRiGrid.getColumnIndex("riTsiAmt"), selectedFrpsRi, true);
	}

	function calcPerilRiCommAmt(row, index) {
		var temp = (row.riCommRt/100)*row.riPremAmt;
		//frPerilGrid.setValueAt(temp, frPerilGrid.getColumnIndex('riCommAmt'), index, true);
		selectedFrperilRow.riCommAmt = temp;
	}

	function calcPerilRiShrPct2(row, index) {
		var temp = 0;
		if(row.distPrem == null || row.distPrem == 0) {
			temp = 0;
		} else {
			temp = (row.riPremAmt / row.distPrem) * 100;	
		}
		//frPerilGrid.setValueAt(temp, frPerilGrid.getColumnIndex('riShrPct'), index, true);
		selectedFrperilRow.riShrPct = temp;
		$("txtRiShrPct").value = formatToNthDecimal(temp,8);
	}

	function calcPerilRiShrPct(row, index) {
		var temp = 0;
		if(row.distTsi != null || row.distTsi != 0) {
			temp = (parseFloat(row.riTsiAmt)/parseFloat(row.distTsi))*100;
		}
		//frPerilGrid.setValueAt(temp, frPerilGrid.getColumnIndex('riShrPct'), index, true);
		selectedFrperilRow.riShrPct = temp;
		$("txtRiShrPct").value = formatToNthDecimal(temp,8);
	}

	function calcPerilRiPremAmt(row, index) {
		/*frPerilGrid.setValueAt((parseFloat(row.riShrPct)/100)*row.distPrem, 
				frPerilGrid.getColumnIndex('riPremAmt'), index, true);*/
		//frPerilGrid.setValueAt(row.distPrem, frPerilGrid.getColumnIndex('riPremAmt'), index, true);
		selectedFrperilRow.riPremAmt = row.distPrem;
		$("txtRiPremAmt").value = formatCurrency(row.distPrem);		
	}

	function calcPerilRiTsiAmt(row, index) {
		if(row.distTsi != null || row.distTsi != 0) {
			frPerilGrid.setValueAt((row.riShrPct/100)*row.distTsi, 
					frPerilGrid.getColumnIndex('riTsiAmt'), index, true);
		}
	}

	function getInputVatRate(riCd) {
		var vatRate = $F("inputVatRate");
		if($F("inputVatRate") == "" && riCd != null) {
			new Ajax.Request(contextPath+"/GIISReinsurerController", {
				method: "GET",
				parameters:{
					action: "getReinsurerVatRt",
					riCd: riCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					vatRate = response.responseText;
					$("inputVatRate").value = vatRate;
				}
			});
		} else if(riCd == null) {
			vatRate = 0;
			$("inputVatRate").value = 0;
		}
		//return vatRate;
	}
	
	function adjustPremVat(riPremVat) {
		try {
			var riCd = selectedFrpsRiRow.riCd;
			var pPremVat = 0;
			if($F("adjustPremVat") == "" && riCd != null) {
				getAdjustPremVatParam(riCd);
			}
			
			var adjustPremVat = $F("adjustPremVat");
			if(adjustPremVat == "0") {
				pPremVat = 0;
			} else if (adjustPremVat == "1") {
				if($F("vStatus") == "c") {
					pPremVat = riPremVatN;
				} else {
					pPremVat = riPremVatO; 
				}
			} else if (adjustPremVat == "2") {
				if($F("vStatus") == "c") {
					pPremVat = riPremVatN;
				} else if (pPremVat != riPremVatO) {
					pPremVat = riPremVatO;
				} else {
					pPremVat = riPremVat;
				}
			} else {
				//
			}
			return pPremVat;
		} catch(e) {
			showErrorMessage("adjustPremVat", e);
		}
	}
	
	function getAdjustPremVatParam(riCd) {
		try {
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {
				method: "POST",
				parameters: {
					action: "getAdjustPremVatParam",
					riCd: riCd,
					lineCd: objRiFrps.lineCd,
					issCd: objRiFrps.issCd,
					parYy: objRiFrps.parYy,
					parSeqNo: objRiFrps.parSeqNo,
					sublineCd: objRiFrps.sublineCd,
					renewNo: objRiFrps.renewNo,
					polSeqNo: objRiFrps.polSeqNo,
					issueYy: objRiFrps.issueYy,
					riPremVat: 0
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					var premVatParam = JSON.parse(response.responseText);
					$("adjustPremVat").value = premVatParam.riPremVat;
				}
			});
		} catch(e) {
			showErrorMessage("getAdjustPremVatParam", e);
		}
	}

	$("btnRecompute").observe("click", function() {
		if($F("frpsNo") != "" && selectedFrpsRi != null) {
			$("selectedFrpsRi").value = selectedFrpsRi;
			overlayPolicyNumber = Overlay.show(contextPath+"/GIRIWFrpsRiController", {
				urlContent: true,
				urlParameters: {
					action: "loadRecomputeVatPage",
					vat: ""
				},
				title: "VAT Rate",
				height: 120,
				width: 300,
				draggable: true
			});
		} else if (selectedFrpsRi == null){
			showMessageBox();
		}
	});

	$("btnPost").observe("click", function() {
		try {
			new Ajax.Request(contextPath+"/GIRIWFrpsRiController", {
					method: "POST",
					parameters: {
						action : "createBinders",
						lineCd: objRiFrps.lineCd,
						frpsYy: objRiFrps.frpsYy,
						frpsSeqNo: objRiFrps.frpsSeqNo
					},
					asychronous: false,
					evalScripts: true,
					onCreate: function() {
						showNotice("Creating binders...");
					},
					onComplete: function(response) {
						hideNotice("");
						riPremVatOld = response.responseText;
						//call function for POST
						showPostingRi();
					}
				});
		} catch(e) {
			showErrorMessage("giris002Posting", e);
		} 
	});
	
	$("btnPrint").observe("click", function() {
		showMessageBox("Sorry, the report GIRIR002 is currently unavailable...");
	});
	
	//start ni niknok oh my gulay..feb 2012
	function supplyPeril(obj){
		try{
			$("txtPerilName").value = nvl(obj,null) == null ? null :unescapeHTML2(obj.perilName);
			$("txtRiShrPct").value 	= nvl(obj,null) == null ? null :formatToNthDecimal(obj.riShrPct,8);
			$("txtRiTsiAmt").value 	= nvl(obj,null) == null ? null :formatCurrency(obj.riTsiAmt);
			$("txtRiPremAmt").value = nvl(obj,null) == null ? null :formatCurrency(obj.riPremAmt);
			$("txtRiCommRt").value 	= nvl(obj,null) == null ? null :formatToNthDecimal(obj.riCommRt,9);
			$("txtRiPremVat").value = nvl(obj,null) == null ? null :formatCurrency(obj.riPremVat);
			$("txtPremTax").value 	= nvl(obj,null) == null ? null :formatCurrency(nvl(obj.premTax,"0.00"));
			if(nvl(obj,null) == null){
				disableButton("btnUpdatePeril");
				$("txtRiShrPct").readOnly = true;
				$("txtRiTsiAmt").readOnly = true;
				$("txtRiPremAmt").readOnly = true;
				$("txtRiCommRt").readOnly = true;
				$("txtRiPremVat").readOnly = true;
				$("txtPremTax").readOnly = true;
			}else{
				if (fnlBinderId == null){
					enableButton("btnUpdatePeril");
				}else{
					disableButton("btnUpdatePeril");
				}	
				$("txtRiShrPct").readOnly = fnlBinderId == null ? false :true;
				$("txtRiTsiAmt").readOnly = fnlBinderId == null ? false :true;
				$("txtRiPremAmt").readOnly = fnlBinderId == null ? false :true;
				$("txtRiCommRt").readOnly = fnlBinderId == null ? false :true;
				$("txtRiPremVat").readOnly = fnlBinderId == null ? false :true;
				$("txtPremTax").readOnly = fnlBinderId == null ? false :true; 
			}	
		}catch(e){
			showErrorMessage("supplyPeril",e);	
		}	
	}
	
	$("txtRiShrPct").observe("blur", function(){
		if (selectedFrperil == null) return;
		selectedFrperilRow.riShrPct = $F("txtRiShrPct");
	});	
	
	$("txtRiTsiAmt").observe("blur", function(){
		if (selectedFrperil == null) return;
		var value = unformatCurrency("txtRiTsiAmt");
		var y = String(selectedFrperil);
		selectedFrperilRow.riTsiAmt = value;
		
		calcPerilRiShrPct(selectedFrperilRow, y);
		calcPerilRiPremAmt(selectedFrperilRow, y);
		calcPerilRiCommAmt(selectedFrperilRow, y);
	});
	
	$("txtRiPremAmt").observe("blur", function(){
		if (selectedFrperil == null) return;
		var value = unformatCurrency("txtRiPremAmt");
		var y = String(selectedFrperil);
		selectedFrperilRow.riPremAmt = value;
		
		if(parseFloat(sveRiPremAmt) != parseFloat(value)) {
			getInputVatRate(editedPerilRow.riCd);
			var tempVat = unformatCurrencyValue(value)*parseFloat($F("inputVatRate"))/100;
			//frPerilGrid.setValueAt(adjustPremVat(tempVat), frPerilGrid.getColumnIndex('riPremVat'),y, true);
			selectedFrperilRow.riPremVat = adjustPremVat(tempVat);
			$("txtRiPremVat").value = formatCurrency(selectedFrperilRow.riPremVat);
		}
												
		calcPerilRiShrPct2(selectedFrperilRow, y);	
		calcPerilRiTsiAmt(selectedFrperilRow, y);	
		calcPerilRiCommAmt(selectedFrperilRow, y);
	});	
	
	$("txtRiCommRt").observe("blur", function(){
		if (selectedFrperil == null) return;
		var y = String(selectedFrperil);
		sveRiCommAmt = selectedFrperilRow.riCommAmt;
		sveRiCommRt = selectedFrperilRow.riCommRt;
		selectedFrperilRow.riCommRt = $F("txtRiCommRt");
		calcPerilRiCommAmt(selectedFrperilRow, y);
		modified = "txtRiCommRt";
		/* calcSumRiCommAmt(selectedFrperilRow, y);
		calcFrpsRiCommAmt2(y);
		calcFrpsRiCommRt(selectedFrperilRow); 
		computeNetDue(frpsRiGrid.getRow(y)); */
	});	
	
	$("txtRiPremVat").observe("blur", function(){
		if (selectedFrperil == null) return;
		selectedFrperilRow.riPremVat = unformatCurrency("txtRiPremVat");
	});	
	
	$("txtPremTax").observe("blur", function(){
		if (selectedFrperil == null) return;
		selectedFrperilRow.premTax = unformatCurrency("txtPremTax");
	});	
	
	$("btnUpdatePeril").observe("click", function(){ 
		try {
			if (selectedFrperil == null) return;
			var y = String(selectedFrperil);
			
			if(modified == "txtRiCommRt") {
				calcSumRiCommAmt(selectedFrperilRow, y);
				calcSumRiPremVat(selectedFrperilRow);
				calcFrpsRiCommAmt2(selectedFrpsRi);
				calcFrpsRiCommRt(frpsRiGrid.getRow(selectedFrpsRi)); 
				computeNetDue(frpsRiGrid.getRow(selectedFrpsRi));
			} else {
				calcSumRiPremAmt(selectedFrperilRow);	
				calcSumRiTsiAmt(selectedFrperilRow);
				calcSumRiCommAmt(selectedFrperilRow, y);
				calcSumRiPremVat(selectedFrperilRow);
				calcFrpsRiPremAmt();
				calcFrpsRiTsiAmt();
				calcFrpsRiShrPct();
				calcFrpsRiCommAmt(selectedFrperilRow, selectedFrpsRi);
				calcFrpsRiCommAmt2(selectedFrpsRi);
				calcFrpsRiCommRt(frpsRiGrid.getRow(selectedFrpsRi)); 
				calcFrpsRiPremVat();
				computeNetDue(frpsRiGrid.getRow(selectedFrpsRi));
			}
			//frPerilGrid.updateVisibleRowOnly(selectedFrperilRow, y, false);
			frPerilGrid.setValueAt(selectedFrperilRow.riShrPct, frPerilGrid.getColumnIndex('riShrPct'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riTsiAmt, frPerilGrid.getColumnIndex('riTsiAmt'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riPremAmt, frPerilGrid.getColumnIndex('riPremAmt'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riCommRt, frPerilGrid.getColumnIndex('riCommRt'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.riPremVat, frPerilGrid.getColumnIndex('riPremVat'), y, true);
			frPerilGrid.setValueAt(selectedFrperilRow.premTax, frPerilGrid.getColumnIndex('premTax'), y, true);
			frPerilGrid.unselectRows();
			supplyPeril(null);
			changeTag = 1;
		} catch(e) {
			showErrorMessage("btnUpdatePeril", e);
		}
	});	
	
	supplyPeril(null);
	//end ni niknok
	
	changeTag = 0;
	initializeChangeTagBehavior(saveRiAcceptance); 
	initializeChangeAttribute();
</script>