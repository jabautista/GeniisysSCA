<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    
<div id="glAcctTranTGDiv" style="padding: 20px 20px 25px 10px; height: 250px; width: 85%;"></div>

<div id="glAmtTotalsDiv" style="padding-bottom: 40px;">
	<table align="right" style="padding-right: 10px;">
		<tr>
			<td style="margin: 0 5px 0 0px;"> Total Debit Amount </td>
			<td><input id="txtTotalDebitAmt" type="text" readonly="readonly" class="money" value="0.00" style="width: 120px; "></td> 
			<td style="margin: 0 5px 0 25px;"> Total Credit Amount </td>
			<td><input id="txtTotalCreditAmt" type="text" readonly="readonly" class="money" value="0.00" style="width: 120px;"></td> 
		</tr>
	</table>
</div>

<div align="center" class="buttonsDiv" style="margin-bottom: 30px;">
	<input id="btnMultiSort" type="button" class="button" value="Multi-sort" style="margin-right: 10px; width: 120px; ">
	<input id="btnShowSl" type="button" class="button" value="Show SL Summary" style="width: 120px; ">
</div>

<div style="margin: 5px 15px 5px 15px; width: 97%;" class="sectionDiv">
	<table align="center">
		<tr>
			<td class="rightAligned" style="padding-right: 7px">Remarks</td>
			<td colspan="3">
				<div style="width: 600px; height: 20px; border: solid gray 1px; float: left;">
					<textarea id="txtRemarks" readonly="readonly" draggable="false" style="width: 575px; height: 13px; border : none; float: left;"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 15px; height: 15px; margin: 2px; float: left;" alt="EditRemarks" id="imgRemarks" class="hover" />
				</div>
			</td>							
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 7px">User Id</td>
			<td style="margin-right: 500px"><input id="txtUserId" type="text" readonly="readonly" style="width: 150px"/> </td>	
			<td class="rightAligned" style="padding: 0 7px 0 155px">Last Update</td>
			<td><input id="txtLastUpdate" type="text" readonly="readonly" style="width: 200px"/> </td>	
		</tr>
	</table>
</div>

<script type="text/javascript">
try{
	var selectedIndex = -1;	//holds the selected index
	var selectedRowInfo = null;	//holds the selected row info
	
	var objGlTrans = new Object();
	objGlTrans.glTransTG = JSON.parse('${glAcctTransTableGrid}'.replace(/\\/g, '\\\\'));
	objGlTrans.glTransObjRows = objGlTrans.glTransTG.rows || [];
	objGlTrans.glTransList = [];	// holds all the geniisys rows
	
	try{
		var glTransTableModel = {
			url: contextPath+"/GIACInquiryController?action=showGLAccountTransaction&refresh=1"+objGIACS230.glTransURL,
			options: {
				width:	'900px',
				height: '250px',
				onCellFocus: function(element, value, x, y, id){
					selectedIndex = y;
					selectedRowInfo = glTransTG.geniisysRows[y];
					setFieldValues(selectedRowInfo);
				},
				onRemoveRowFocus: function(){
					glTransTG.keys.releaseKeys();
					selectedIndex = -1;
					selectedRowInfo = "";
					setFieldValues(null);
				},
				onRowDoubleClick: function(y){
					onTGRowDoubleClick(y);
				},
				onRefresh: function(){
					glTransTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						glTransTG.onRemoveRowFocus();
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
					id: 'gaccTranId',
					width: '0px',
					visible: false
				},
				{
					id: 'fundCd',
					width: '0px',
					visible: false
				},

				{
					id: 'branchCd',
					width: '0px',
					visible: false
				},
				{
					id: 'tranNo',
					title: 'Transaction No.',
					width: '150px',
					filterOption: true
				},
				{
					id: 'tranClass',
					title: 'Class',
					titleAlign: 'center',
					width: '60px',
					filterOption: true
				},
				{
					id: 'refNo',
					title: 'Reference No.',
					width: '150px',
					filterOption: true
				},
				{
					id: 'tranFlag',
					title: 'Status',
					titleAlign: 'center',
					width: '60px',
					filterOption: true
				},
				{
					id: 'tranDate',
					title: 'Tran Date',
					align: 'center',
					titleAlign: 'center',
					width: '95px',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true,
					filterOptionType: 'formattedDate'
				},
				{
					id: 'dtPosted',
					title: 'Post Date',
					align: 'center',
					titleAlign: 'center',
					width: '95px',
					type: 'date',
					format: 'mm-dd-yyyy',
					filterOption: true
				},
				{
					id: 'debitAmt',
					title: 'Debit Amount',
					titleAlign: 'center',
					align: 'right',
					width: '130px',
					geniisysClass: 'money',
					geniisysMaxValue: '999,999,999,999.99'
				},
				{
					id: 'creditAmt',
					title: 'Credit Amount',
					titleAlign: 'center',
					align: 'right',
					width: '130px',
					geniisysClass: 'money',
					geniisysMaxValue: '999,999,999,999.99'
				},
				{
					id: 'slCd',
					title: 'SL Code',
					width: '80px',
					filterOption: true
				},
				{
					id: 'slName',
					title: 'SL Name',
					width: '280px',
					filterOption: true
				},
				
			],
			rows: objGlTrans.glTransObjRows
		};

		glTransTG = new MyTableGrid(glTransTableModel);
		glTransTG.pager = objGlTrans.glTransTG;
		glTransTG.render('glAcctTranTGDiv');
		glTransTG.afterRender = function(){		
			objGlTrans.glTransList = glTransTG.geniisysRows;
			
			var totalDebitAmt = 0;
			var totalCreditAmt = 0;
			var list = objGlTrans.glTransList; 
			
			for (var i=0; i<list.length; i++){
				totalDebitAmt = parseFloat(nvl(totalDebitAmt, 0)) + parseFloat(nvl(list[i].debitAmt, 0));
				totalCreditAmt = parseFloat(nvl(totalCreditAmt, 0)) + parseFloat(nvl(list[i].creditAmt, 0));
				
				if(list[i].slCd == null || list[i].slCd == ""){
					disableButton("btnShowSl");
				}else{
					enableButton("btnShowSl");
					if (objGIACS230.sl_exists == 0){
						objGIACS230.sl_exists = objGIACS230.sl_exists + 1;
					}
				}
			}
			
			$("txtTotalDebitAmt").value = formatCurrency(totalDebitAmt);
			$("txtTotalCreditAmt").value = formatCurrency(totalCreditAmt);
		};
		
	}catch (e) {
		showMessageBox("Error in GL Account Transaction TableGrid: " + e, imgMessage.ERROR);
	}

	
	function setFieldValues(row){
		$("txtRemarks").value = row == null ? "" : unescapeHTML2(row.remarks);
		$("txtUserId").value = row == null ? "" : row.userId;
		$("txtLastUpdate").value = row == null ? "" : row.lastUpdate;	
	}
	
	
	function onTGRowDoubleClick(y){
		try{
			// referenced by GIACS001, GIACS002, GIACS003.
			objACGlobal.queryOnly = "Y";
			objACGlobal.gaccTranId = glTransTG.getValueAt(glTransTG.getColumnIndex('gaccTranId'), y);
			objACGlobal.fundCd = glTransTG.getValueAt(glTransTG.getColumnIndex('fundCd'), y);
			objACGlobal.branchCd = glTransTG.getValueAt(glTransTG.getColumnIndex('branchCd'), y);
			
			tranClass = glTransTG.getValueAt(glTransTG.getColumnIndex("tranClass"), y);
			
			glTransTG.keys.releaseKeys();
			
			if (tranClass == "COL"){
				//GIACS001
				objACGlobal.tranSource = 'OR';
				objACGlobal.opReqTag  = 'N';
				objACGlobal.orTag = 'I';   // 'I' is a dummy value.
			    objAC.fromMenu = "cancelOR";
			    objAC.showOrDetailsTag = "showOrDetails";
			    objACGlobal.orTag = 'I'; 
			    objACGlobal.callingForm = "";
			    objAC.butLabel = "Spoil OR"; 
				editORInformation();
			}else if (tranClass == "DV"){
				//GIACS002 				
				objGIACS002.dvTag = "I";   // 'I' is a dummy value.
			    objACGlobal.tranSource = "DV";
			    showDisbursementVoucherPage("N", "getDisbVoucherInfo");
			}else{
				//GIACS003
				objACGlobal.giacs003PageStatus = null;
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003", objACGlobal.fundCd, objACGlobal.branchCd, objACGlobal.gaccTranId, null);
			}
			
		}catch(e){
			showErrorMessage("onTGRowDoubleClick", e);
		}
	}
	

	$("imgRemarks").observe("click", function(){
		showEditor("txtRemarks", 4000, "true");
	});
	$("btnShowSl").observe("click", function(){
		if (objGIACS230.sl_exists > 0){
			if (selectedRowInfo == null || selectedRowInfo == ""){
				showMessageBox("Please select a record first.", "I");
			}else{
				objGIACS230.slSummaryURL = contextPath+"/GIACInquiryController?action=getSLSummaryGIACS230"+"&fundCd="+
						  				selectedRowInfo.fundCd+"&branchCd="+selectedRowInfo.branchCd+"&slCd="+selectedRowInfo.slCd
						  				+"&slName="+selectedRowInfo.slName+"&debitAmt="+selectedRowInfo.debitAmt
						  				+"&creditAmt="+parseFloat(selectedRowInfo.creditAmt)+"&gaccTranId="+selectedRowInfo.gaccTranId;
				glTransTG.keys.releaseKeys();
				
				try{
					new Ajax.Updater("glTransactionDiv", contextPath+"/GIACInquiryController",{
						parameters: {
							action:		"getSLSummaryGIACS230",
							fundCd:		selectedRowInfo.fundCd,
							branchCd:	selectedRowInfo.branchCd,
							slCd:		selectedRowInfo.slCd,
							slName:		selectedRowInfo.slName,
							debitAmt:	selectedRowInfo.debitAmt,
							creditAmt:	selectedRowInfo.creditAmt,
							gaccTranId:	selectedRowInfo.gaccTranId
						},
						method: "POST",
						evalScripts: true,
						asynchronous: true,
						onComplete: function(response){
							disableToolbarButton("btnToolbarEnterQuery");
						}
					});
				}catch(e){
					showErrorMessage("btnShowSl", e);
				}
			}
		}else{
			showMessageBox("There are no SL Codes for this GL Account Code.", "I");
			return false;
		}
	});
	
	$("btnMultiSort").observe("click", function(){
		glTransTG.keys.releaseKeys();
		objOverlay = Overlay.show(contextPath+"/GIACInquiryController",{
			urlContent: true,
			urlParameters: {
				action: "showMultiSortGIACS230"
			},
			title: "Sorting",
			height: 280,
			width: 400,
			draggable: true
		});
	});
	
}catch(e){
	showErrorMessage("glAcctTranTableGrid page: ", e);
}	
	
</script>