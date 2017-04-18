<div id="mortgageeInformationMainDiv">
	<div id="mortgageeInformationMain" class="sectionDiv" style="border: none;">
		<div id="mortgageeInformation" style="padding: 0px;" class="sectionDiv">
			<div id="mortgageeInformationDetails" name="policyBillInvoiceDetails" class="sectionDiv" style="border: none; margin-top: 10px; margin-left: 10px;">
				<div id="mortgageeTableGrid" class="sectionDiv" style="border: none; height: 200px; width: 900px; margin: auto; margin-bottom: 15px;">
				
				</div>
				<div id="mortgageeInformationTextDiv" name="mortgageeInformationTextDiv" style="margin-top: 20px; float: left; width: 900px; padding-bottom: 10px;" align="center">
					<table align="center">
						<tr>
							<td class="rightAligned" style="width: 120px;">Mortgagee Name</td>
							<td class="leftAligned" colspan="5">								
								<input type="text" id="txtMortgCd" name="txtMortgCd" value="" style="width: 355px;" readonly="readonly" tabindex="601">
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Amount</td>
							<td>
								<input id="mortgAmount" name="mortgAmount" class="money numeric" type="text" align="right" style="width: 354px; margin-left: 5px;" tabindex="603" readonly="readonly">
							</td>
						</tr> 
						<tr>
							<td class="rightAligned">Remarks</td>
							<td colspan="3">
								<div id="remarksDiv" style="border: 1px solid gray; height: 20px; width: 360px; margin-left: 5px;">
									<textarea id="mortgRemarks" name="mortgRemarks" style="width: 330px; border: none; height: 13px; resize: none;" maxlength="50" tabindex="604" readonly="readonly"/></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="mortgEditRemarks" tabindex="605"/>
								</div>
							</td>
						</tr>
					</table>
					<input id="hidMorgCd" name="hidMorgCd" type="hidden">
					<input id="hidMorgId" name="hidMorgId" type="hidden">
					<input id="hidMorgName" name="hidMorgName" type="hidden">
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	try {
		var mortgageeItems = {};

		initializeAll();
		initializeAccordion();
		initializeAllMoneyFields();
		
		objQuote.objMortgagee = [];
		objQuote.selectedMortgageeIndex = -1;
		
		var mortgageeListMain = new Object();
		mortgageeListMain.mortgageeListMainTableGrid = JSON.parse('${mortgageeList}');
		mortgageeListMain.mortgageeListMain = mortgageeListMain.mortgageeListMainTableGrid || [];
		var mortgageeListTableModel = {
			url : contextPath
					+ "/GIPIQuoteItmMortgageeController?action=getMortgageeList&refresh=1&quoteId="
					+ objGIPIQuote.quoteId + "&itemNo=" + $("itemNoHid").value
					+ "&issCd=" + objGIPIQuote.issCd,
			options : {
				title : '',
				height : '206px',
				width : '900px',
				onCellFocus : function(element, value, x, y, id) {
					mortgageeTableGrid.keys.releaseKeys();
					mortgageeListMain.selectedMortgageeIndex = y;
					objQuote.selectedMortgageeInfoRow = mortgageeTableGrid.geniisysRows[y];
					mortgDetails(mortgageeTableGrid.geniisysRows[y]);
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					mortgageeTableGrid.keys.releaseKeys();
					objQuote.selectedMortgageeIndex = -1;
					objQuote.selectedMortgageeInfoRow = "";
					clearDetails();
				},
				onSort : function() {
					objQuote.selectedMortgageeIndex = -1;
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN ],
					onRefresh : function() {
						objQuote.selectedMortgageeIndex = -1;
						objQuote.selectedMortgageeInfoRow = "";
					} 
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				width : '0px',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0px',
				visible : false
			},  {
				id : 'itemNo',
				title : 'Item No',
				titleAlign : 'right',
				width : '52px',
				align : 'right',
				renderer : function(value) {
					return lpad(value.toString(), 5, "0");
				}
			}, {
				id : 'mortgCd',
				title : 'Code',
				titleAlign: 'left',
				align: 'left',
				width : '100px',
				filterOption : true
			}, {
				id : 'mortgName',
				title : 'Mortagee',
				titleAlign: 'left',
				align: 'left',
				width : '330px',
				filterOption : true
			}, {
				id : 'amount',
				title : 'Amount',
				width : '150px',
				geniisysClass : 'money',
				titleAlign : 'right',
				align : 'right'
			},{
				id : 'remarks',
				title: 'Remarks',
				titleAlign: 'left',
				align: 'left',
				sortable: false,
				width: '250px'
			}, {
				id : 'mortgageeId',
				width : '0px',
				visible: false
			} ],
			rows : mortgageeListMain.mortgageeListMainTableGrid.rows,
			id: 25
		};
		mortgageeTableGrid = new MyTableGrid(mortgageeListTableModel);
		mortgageeTableGrid.pager = mortgageeListMain.mortgageeListMainTableGrid;
		mortgageeTableGrid.render('mortgageeTableGrid');
		mortgageeTableGrid.afterRender = function(){
			objQuote.objMortgagee = mortgageeTableGrid.geniisysRows;
		};
	} catch (e) {
		showErrorMessage("mortgagee.jsp", e);
	}

	$("mortgEditRemarks").observe("click", function() {
		if (objQuote.selectedItemInfoRow == null || objQuote.selectedItemInfoRow == "") {
			showMessageBox("Please select an item first.", "I");
		} else {
			showEditor("mortgRemarks", 50, "true");
		}
	});
	
	$("mortgEditRemarks").observe("keypress", function (event) {
		if (event.keyCode == 13){
			if (objQuote.selectedItemInfoRow == null || objQuote.selectedItemInfoRow == "") {
				showMessageBox("Please select an item first.", "I");
			} else {
				showEditor("mortgRemarks", 50, "true");
			}
		}
	});
	
	function mortgDetails(obj) {
		try {
			$("txtMortgCd").value = nvl(unescapeHTML2(obj.mortgCd), "") + " - " + nvl(unescapeHTML2(obj.mortgName), "");
			$("mortgAmount").value = formatCurrency(nvl(obj.amount, "0.00"));
			$("mortgRemarks").value = nvl(unescapeHTML2(obj.remarks), "");
			$("hidMorgId").value = obj.mortgageeId;
			$("hidMorgCd").value = nvl(unescapeHTML2(obj.mortgCd),"");
			$("hidMorgName").value = nvl(unescapeHTML2(obj.mortgName),"");
		} catch (e) {
			showErrorMessage("mortgDetails", e);
		}
	}

	function clearDetails() {
		try {
			$("txtMortgCd").value = "";
			$("mortgAmount").value = "0.00";
			$("mortgRemarks").value = "";
		} catch (e) {
			showErrorMessage("clearDetails", e);
		}
	}
	objQuoteGlobal.clearMortgageeDtls = clearDetails;
	
	$("mortgRemarks").observe("change",function(){
		if (objQuote.selectedItemInfoRow == null || objQuote.selectedItemInfoRow == "") {
			showMessageBox("Please select an item first.", "I");
			$("mortgRemarks").clear();
		} else {
		}
	});
</script>