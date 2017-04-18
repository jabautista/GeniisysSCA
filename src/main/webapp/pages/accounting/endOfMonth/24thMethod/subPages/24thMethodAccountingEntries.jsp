<div id="24thMethodAcctEntriesMainDiv" name="24thMethodAcctEntriesMainDiv" style="margin-top: 10px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;">
	<div id="acctEntriesHeaderDiv" class="sectionDiv">
		<div id="headerDiv" style="margin-bottom: 10px; margin-top: 10px;">
			<table align="center">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Tran Date</td>
					<td class="leftAligned" style="width: 320px;"><input type="text" id="txtTranDate" name="txtTranDate" readonly="readonly" style="width: 160px;" tabindex="101"/></td>
					<td class="rightAligned" style="padding-right: 5px;">Period</td>
					<td class="leftAligned"><input type="text" id="txtMmGen" name="txtMmGen" readonly="readonly" style="width: 130px;" tabindex="102"/></td>
					<td class="leftAligned"><input type="text" id="txtYearGen" name="txtYearGen" readonly="readonly" style="width: 100px;" tabindex="103"/></td>										
				</tr>
			</table>
		</div>
	</div>
	<div id="TableDiv" class="sectionDiv">
		<div id="acctEntriesListTableGridDiv" name="acctEntriesListTableGridDiv" style="margin-top: 10px; margin-left: 10px; height: 220px;">
			<div id="acctEntriesListTableGrid" style="height: 190px;"></div>
		</div>

		<div id="acctEntriesDetailDiv" name="acctEntriesDetailDiv" style="margin-bottom: 10px;">
			<table style="padding-left: 30px;">
				<tr>
				<td><input type="button" class="button" id="btnReturnAcctEntries" name="btnReturnAcctEntries" value="Return" style="width: 100px;" tabindex="201"/></td>
				<td style="width: 235px;"><input type="button" class="button" id="btnViewGlSummary" name="btnViewGlSummary" value="View GL Summary" style="width: 150px;" tabindex="202"/></td>
				<td style="padding-right: 5px;">Totals</td>
				<td><input type="text" id="txtDebitAmtTotal" name="txtDebitAmtTotal" readonly="readonly" style="width: 165px;" class="money" tabindex="203"/></td>
				<td><input type="text" id="txtCreditAmtTotal" name="txtCreditAmtTotal" readonly="readonly" style="width: 165px;" class="money" tabindex="204"/></td>
				</tr>
			</table>
		</div>
	</div>	
	<div id="acctEntriesSubDetailDiv" name="acctEntriesSubDetailDiv"  class="sectionDiv">
		<table style="margin-top: 10px; margin-bottom: 10px; margin-left: 10px;">
			<tr>
				<td align="right">GL Account Name</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="3">
					<span id="acctNameSpan" style="border: 1px solid gray; width: 638px; height: 21px; float: left;"> 
						<input type="text" id="txtGlAcctName" name="txtGlAcctName" style="border: none; float: left; width: 95%; background: transparent;" readonly="readonly" tabindex="301"/> 
					</span>
				</td>
			</tr>
			<tr>
				<td align="right">SL Name</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="3">
					<span id="acctNameSpan" style="border: 1px solid gray; width: 638px; height: 21px; float: left;"> 
						<input type="text" id="txtSlName" name="txtSlName" style="border: none; float: left; width: 95%; background: transparent;" readonly="readonly" tabindex="302"/> 
					</span>
				</td>
			</tr>
			<tr>
				<td align="right">Remarks</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="3">
					<span id="remarks" style="border: 1px solid gray; width: 638px; height: 21px; float: left;"> 
						<input type="text" id="txtRemarks" name="txtRemarks" style="border: none; float: left; width: 95%; background: transparent;" readonly="readonly" tabindex="303"/> 
					</span>
				</td>
			</tr>
			<tr>
				<td align="right">User ID</td>
				<td class="leftAligned" style="padding-left: 5px; width:405px;">
					<input type="text" id="txtUserId" name="txtUserId" readonly="readonly" style="width: 150px;" tabindex="304"/></td>
				<td align="right">Last Update</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="1">
					<input type="text" id="txtLastUpdate" name="txtLastUpdate" readonly="readonly"style="width: 150px;" tabindex="305"/></td>
			</tr>
		</table>
	</div>
</div>
<script>
	try{
		var objAcctEntriesTG = JSON.parse('${acctEntries}');
		var acctEntriesModel = { 
			url: contextPath+"/GIACDeferredController?action=getDeferredAcctEntries&refresh=1&year="+objGiacs044.year
								+ "&mM=" + objGiacs044.mM + "&procedureId=" + objGiacs044.procedureId + "&table=" + objGiacs044.table,
			options:{
				width: '770px',
				title: '',
				onCellFocus: function(element, value, x, y, id){
					setDetails(acctEntriesTableGrid.geniisysRows[y]);
					acctEntriesTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					setDetails(null);
					acctEntriesTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					setDetails(null);
					acctEntriesTableGrid.keys.releaseKeys();
				},
				prePager: function () {
					setDetails(null);
					acctEntriesTableGrid.keys.releaseKeys();
				}
			},
			columnModel: [
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
				{	id: 'glAcctCode',
					title: 'GL Account Code',
					width: '247px',
					titleAlign: 'center'
				},
				{	id: 'slCode',
					title: 'SL Code',
					width: '150px',
					titleAlign: 'right',
					align: 'right'
				},
				{	id: 'debitAmt',
					title: 'Debit Amount',
					width: '170px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'creditAmt',
					title: 'Credit Amount',
					width: '170px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'
				}
			],
			rows: objAcctEntriesTG.rows
		};
		
		acctEntriesTableGrid = new MyTableGrid(acctEntriesModel);
		acctEntriesTableGrid.pager = objAcctEntriesTG;
		acctEntriesTableGrid.render('acctEntriesListTableGrid');
		acctEntriesTableGrid.afterRender = function(y) {
			$("txtTranDate").value = acctEntriesTableGrid.geniisysRows[0].tranDate;
			$("txtYearGen").value = acctEntriesTableGrid.geniisysRows[0].yearGen;
			$("txtMmGen").value = acctEntriesTableGrid.geniisysRows[0].mmGen;
			$("txtDebitAmtTotal").value  = formatCurrency(parseFloat(acctEntriesTableGrid.geniisysRows[0].debitAmtTotal));
			$("txtCreditAmtTotal").value = formatCurrency(parseFloat(acctEntriesTableGrid.geniisysRows[0].creditAmtTotal));
		};
	}catch(e){
		showErrorMessage("Accounting Entries table grid.",e);
	}
	
	function setDetails(obj){
		try {
			$("txtGlAcctName").value = obj == null ? "" : unescapeHTML2(obj.glAcctName);
			$("txtSlName").value	 = obj == null ? "" : unescapeHTML2(obj.slName);
			$("txtRemarks").value 	 = obj == null ? "" : unescapeHTML2(obj.remarks);
			$("txtUserId").value 	 = obj == null ? "" : unescapeHTML2(obj.userId);
			$("txtLastUpdate").value = obj == null ? "" : unescapeHTML2(obj.lastUpdate);
		} catch (e) {
			showErrorMessage("setDetails - 24thMethodAccountingEntries", e);
		}
	}
	
	function show24thMethodGLSummary() {	//shows Accounting Entries overlay
		overlayGLSummary = Overlay.show(contextPath + "/GIACDeferredController", {
			urlContent : true,
			urlParameters : {action : "getDeferredGLSummary",
				year: objGiacs044.year,
				mM: objGiacs044.mM,
				procedureId: objGiacs044.procedureId,
				table: objGiacs044.table},
			title : "GL Summary",
			height : '320px',
			width : '800px',
			draggable : true
		});	
	}
	
	$("btnReturnAcctEntries").observe("click", function(){
		overlayAccountingEntries.close();
	});
	$("btnViewGlSummary").observe("click", function(){
		show24thMethodGLSummary();
	});	
	
 	initializeAllMoneyFields();
</script>