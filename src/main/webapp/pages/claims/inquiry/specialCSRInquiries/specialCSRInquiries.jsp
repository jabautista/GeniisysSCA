<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="specialCSRDiv">
	<div id="specialCSRDiv2">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="specialCSRExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Special Claim Settlement Request Inquiries</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	
	<div id="giacs087" name="giacs087">
		<div class="sectionDiv">
			<div id="specialCSRTableDiv" style="padding-top: 10px;">
				<div id="specialCSRGridDiv" style="height: 331px; margin-left: 9px;"></div>
			</div>
			
			<div align="center" id="scsrFormDiv">
				<table style="margin-top: 10px;">
					<tr>
						<input type="hidden" id="hidBatchDvId"/>
						<td class="rightAligned">Paid Amount</td>
						<td class="leftAligned">
							<input id="txtFCurrAmt" type="text" style="width: 250px; text-align: right;" tabindex="201" maxlength="50" readonly="readonly">
						</td>						
						<td width="" class="rightAligned">Local Amount</td>
						<td class="leftAligned">
							<input id="txtPaidAmt" type="text" style="width: 250px; text-align: right;" tabindex="202" maxlength="50" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Currency Cd</td>
						<td class="leftAligned">
							<input id="txtCurrencyCd" type="text" style="width: 250px;" tabindex="203" maxlength="50" readonly="readonly">
						</td>						
						<td width="" class="rightAligned">Convert Rate</td>
						<td class="leftAligned">
							<input id="txtConvertRate" type="text" style="width: 250px; text-align: right;" tabindex="204" maxlength="50" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Particulars</td>
						<td class="leftAligned" colspan="3">
							<textarea id="txtParticulars" style="resize: none; width: 630px; border: 1px solid gray;" readonly="readonly" cols="80" rows="3" name="txtParticulars"></textarea>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"3><input id="txtUserId" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="207"></td>
						<td width="" class="rightAligned" style="padding-left: 45px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="208"></td>
					</tr>	
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px 0 30px 0;">
				<input type="button" class="button" id="btnBatchDetail" value="Batch Detail" tabindex="209">
				<input type="button" class="button" id="btnAcctEnt" value="Accounting Entries" tabindex="210">
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	setModuleId("GIACS087");
	setDocumentTitle("Special Claim Settlement Request Inquiries");
	
	var selectedIndex = -1;	//holds the selected index
	var selectedRow = null;	//holds the selected row info
	
	var objSCSR = new Object();
	objSCSR.scsrTG = JSON.parse('${specialCSRList}'.replace(/\\/g, '\\\\'));
	objSCSR.scsrObjRows = objSCSR.scsrTG.rows || [];
	objSCSR.scsrList = [];	// holds all the geniisys rows
	
	var objSCSRRow = null;
		
	try{
		var scsrTableModel = {
			url: contextPath+"/GIACBatchDVController?action=showGIACS087&refresh=1",
			options: {
				width:	'900px',
				height: '307px',
				hideColumnChildTitle : true,
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					selectedRowInfo = scsrTG.geniisysRows[y];
					setFieldValues(selectedRowInfo);
				},
				onRemoveRowFocus: function(){
					scsrTG.keys.releaseKeys();
					selectedIndex = -1;
					selectedRowInfo = "";
					setFieldValues(null);
				},
				onRefresh: function(){
					scsrTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						scsrTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{
					id: 'batchDivId',
					width: '0px',
					visible: false
				},
				{
					id: 'particulars',
					width: '0px',
					visible: false
				},
				{
					id: 'tranId',
					width: '0px',
					visible: false
				},
				{
					id: 'paidAmt',
					width: '0px',
					visible: false
				},
				{
					id: 'fCurrAmt',
					width: '0px',
					visible: false
				},
				{
					id: 'currencyCd',
					width: '0px',
					visible: false
				},
				{
					id: 'convertRate',
					width: '0px',
					visible: false
				},
				{
					id: 'userId',
					width: '0px',
					visible: false
				},
				{
					id: 'lastUpdate',
					width: '0px',
					visible: false
				},
				{
					id : 'batchFlag',
					title: 'C',
					altTitle: 'Cancelled',
					width : '25px',
					align : 'center',
					editable : false,
					filterOption: true,
					filterOptionType: 'checkbox',
					editor : new MyTableGrid.CellCheckbox({
						getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
					})
				},
				{
					id: 'dspRefNo',
					title: 'Claim Request No.',
					width: '150px',
					filterOption: true
				},
				{
					id : "fundCd branchCd batchYear batchMM batchSeqNo",
					title : "Batch Number",
					children : [
						{
							id: 'fundCd',
							title: 'Fund Cd',
							width: 40,
							filterOption: true
						},
						{
							id: 'branchCd',
							title: 'Branch Cd',
							width: 30,
							filterOption: true
						},
						{
							id: 'batchYear',
							title: 'Batch Year',
							align: 'right',
							width: 40,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: 'batchMM',
							title: 'Batch MM',
							align: 'right',
							width: 30,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: 'batchSeqNo',
							title: 'Batch Seq No',
							align: 'right',
							width: 60,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						}
					]
				},
				{
					id: 'batchDate',
					title: 'Batch Date',
					titleAlign: 'center',
					align: 'center',
					width: '70px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return value == "" ? "" : dateFormat(value,"mm-dd-yyyy");
					}
				},
				{
					id : "payeeCd payeeClassCd dspPayee payeeRemarks",
					title : "Payee",
					titleAlign: 'center',
					children : [
						{
							id: 'payeeCd',
							title: 'Payee Cd',
							width: 100,
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{
							id: 'payeeClassCd',
							title: 'Payee Class Cd',
							width: 30,
							filterOption: true
						},
						{
							id: 'dspPayee',
							title: 'Payee Name',
							width: 250,
							filterOption: true
						},
						{
							id: 'payeeRemarks',
							title: 'payeeRemarks',
							width: 250,
							filterOption: false
						}
					]
				},				
			],
			rows: objSCSR.scsrObjRows
		};

		scsrTG = new MyTableGrid(scsrTableModel);
		scsrTG.pager = objSCSR.scsrTG;
		scsrTG.render('specialCSRGridDiv');
	}catch(e){
		showErrorMessage("SCSR tablegrid", e);
	}
	
	function setFieldValues(rec){
		try{
			$("hidBatchDvId").value = (rec == null ? "" : rec.batchDvId);
			$("txtFCurrAmt").value = (rec == null ? "" : formatCurrency(rec.fcurrAmt));
			$("txtPaidAmt").value = (rec == null ? "" : formatCurrency(rec.paidAmt));
			$("txtCurrencyCd").value = (rec == null ? "" : unescapeHTML2(rec.currencyCd));
			$("txtConvertRate").value = (rec == null ? "" : formatToNineDecimal(rec.convertRate));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : dateFormat(rec.lastUpdate, "mm-dd-yyyy"));
			$("txtParticulars").value = (rec == null ? "" : unescapeHTML2(rec.particulars));
						
			rec == null ? disableButton("btnBatchDetail") : enableButton("btnBatchDetail");
			rec == null ? disableButton("btnAcctEnt") : enableButton("btnAcctEnt");
			objSCSRRow = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	observeReloadForm("reloadForm", function(){showGIACS087();});
	
	$("specialCSRExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	});
	
	$("btnBatchDetail").observe("click", function(){
		scsrTG.keys.releaseKeys();
		objOverlay = Overlay.show(contextPath+"/GIACBatchDVController",{
			urlContent: true,
			urlParameters: {
				action: "showGIACS087BatchDetails",
				batchDvId:	$F("hidBatchDvId")
			},
			title: "Batch Details",
			height: 405,
			width: 805,
			draggable: true
		});
	});
	
	$("btnAcctEnt").observe("click", function(){
		scsrTG.keys.releaseKeys();
		objOverlay = Overlay.show(contextPath+"/GIACBatchDVController",{
			urlContent: true,
			urlParameters: {
				action: "showGIACS087AcctEntries",
				batchDvId:	$F("hidBatchDvId")
			},
			title: "Accounting Entries",
			height: 460,
			width: 805,
			draggable: true
		});
	});
	
	setFieldValues(null);
}catch(e){
	showErrorMessage("Special CSR Inquiries Page: ", e);	
}
</script>
