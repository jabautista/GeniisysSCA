<div id="24thMethodGLSummaryMainDiv" name="24thMethodGLSummaryMainDiv" style="margin-top: 10px;  margin-left: 5px;">
	<div id="TableDiv" class="">
		<div id="glSummaryTableGridDiv" name="glSummaryTableGridDiv" style="margin-top: 10px; height: 220px;">
			<div id="glSummaryTableGrid" style="height: 190px;"></div>
		</div>
	</div>	
	<div id="glSummarySubDetailDiv" name="glSummarySubDetailDiv" style=" width:790px;" class="sectionDiv">
		<table style="margin-top: 10px; margin-bottom: 10px; margin-left: 10px;">
			<tr>
				<td align="right">GL Account Name</td>
				<td class="leftAligned" style="padding-left: 5px;" colspan="3">
					<span id="acctNameSpan" style="border: 1px solid gray; width: 650px; height: 21px; float: left;"> 
						<input type="text" id="txtGlAcctName" name="txtGlAcctName" style="border: none; float: left; width: 95%; background: transparent;" readonly="readonly" tabindex="101"/> 
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" align="center" style="margin-top: 10px; float: left; padding-left: 360px;">
		<input type="button" class="button" id="btnReturnGL" name="btnReturnGL" value="Return" style="width: 100px;" tabindex="201"/>
	</div>
</div>
<script>
	try{	
		var objGLSummaryTG = JSON.parse('${jsonGLSummary}');
		var glSummaryModel = { 
			url: contextPath+"/GIACDeferredController?action=getDeferredGLSummary&refresh=1&year="+objGiacs044.year
								+ "&mM=" + objGiacs044.mM + "&procedureId=" + objGiacs044.procedureId + "&table=" + objGiacs044.table,
			options:{
				width: '790px',
				title: '',
				onCellFocus: function(element, value, x, y, id){
					$("txtGlAcctName").value = unescapeHTML2(glSummaryTableGrid.geniisysRows[y].glAcctName);
					glSummaryTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					$("txtGlAcctName").value = "";
					glSummaryTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					$("txtGlAcctName").value = "";
					glSummaryTableGrid.keys.releaseKeys();
				},
				prePager: function () {
					$("txtGlAcctName").value = "";
					glSummaryTableGrid.keys.releaseKeys();
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
					width: '250px',
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
					width: '178px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'
				},
				{	id: 'creditAmt',
					title: 'Credit Amount',
					width: '178px',
					geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right'
				}
			],
			rows: objGLSummaryTG.rows
		};
		
		glSummaryTableGrid = new MyTableGrid(glSummaryModel);
		glSummaryTableGrid.pager = objGLSummaryTG;
		glSummaryTableGrid.render('glSummaryTableGrid');
	}catch(e){
		showErrorMessage("GL Summary table grid.",e);
	}
	
	$("btnReturnGL").observe("click", function(){
		overlayGLSummary.close();
	});
	initializeAllMoneyFields();
</script>