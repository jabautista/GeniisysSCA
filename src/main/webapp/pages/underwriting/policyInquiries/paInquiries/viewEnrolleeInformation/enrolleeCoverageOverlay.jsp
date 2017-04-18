<div id="gipis212CoverageMainDiv" style="width: 99.5%; margin-top: 5px; height: 340px; margin-bottom: 20px;" class="sectionDiv">
	<div>
		<div style="padding:10px;">
			<div id="coverageDtlTable" style="height: 270px; width: 98%;" align="center">
				
			</div>
			<div align="center" id="coverageDtlFormDiv">
				<table style="margin-top: 20px;">
					<tr>
						<td class="rightAligned" style="padding-right: 5px;">Base Amount</td>
						<td class="leftAligned">
							<input id="txtBaseAmt" type="text" readonly="readonly" style="width: 150px; text-align: right;">
						</td>
						<td class="rightAligned" style="padding-left: 30px; padding-right: 5px;">No. of days</td>
						<td class="leftAligned">
							<input id="txtNoOfDays" type="text" readonly="readonly" style="width: 150px; text-align: right;">
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
<div align="center">
	<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px;" tabindex="504">
</div>
<input id="policyId" type="hidden"  value="${policyId}"/>
<input id="groupedItemNo" type="hidden"  value="${groupedItemNo}"/>
<input id="itemNo" type="hidden"  value="${itemNo}"/>
<input id="lineCd" type="hidden"  value="${lineCd}"/>
<script type="text/javascript">
	initializeAll();
	
	var rowIndex = -1;
	var objCoverageDtl = {};
	var objCurrCoverageDtl = null;
	objCoverageDtl.coverageList = JSON.parse('${jsonCoverageDtls}');
	
	var coverageDtlTableModel = {
			url : contextPath + "/GIPIGroupedItemsController?action=showCoveragesOverlay&refresh=1" 
					+ "&policyId=" + $F("policyId") 
					+ "&groupedItemNo=" + $F("groupedItemNo")
					+ "&itemNo=" + $F("itemNo")
					+ "&lineCd=" + $F("lineCd"),
			options : {
				width : '675px',
				height : '280px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					setFieldValues(tbgCoverageDtl.geniisysRows[y]);
					tbgCoverageDtl.keys.removeFocus(tbgCoverageDtl.keys._nCurrentFocus, true);
					tbgCoverageDtl.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					setFieldValues(null);
					tbgCoverageDtl.keys.removeFocus(tbgCoverageDtl.keys._nCurrentFocus, true);
					tbgCoverageDtl.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						setFieldValues(null);
						tbgCoverageDtl.keys.removeFocus(tbgCoverageDtl.keys._nCurrentFocus, true);
						tbgCoverageDtl.keys.releaseKeys();
					}
				}
			},
			columnModel : [
				{
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false
				}, 
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{	id:'aggregateSw',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;A',
					altTitle: 'Aggregate Switch', // 'Delete Switch', changed by robert SR 5157 12.22.15
					width:		'25px',
					editable:  false,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}	
		            	}
		            })
				},
				{
					id : 'perilName',
					filterOption : true,
					title : 'Peril Name',
					width : '280px'
				},
				{
					id : "premRt",
					title : "Prem Rate",
					titleAlign : 'right',
					width : '120px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : "tsiAmt",
					title : "TSI Amount",
					titleAlign : 'right',
					width : '120px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : "premAmt",
					title : "Premium Amount",
					titleAlign : 'right',
					width : '120px',
					geniisysClass: 'money',
					align : 'right',
				}
			], rows : objCoverageDtl.coverageList.rows
	};
	tbgCoverageDtl = new MyTableGrid(coverageDtlTableModel);
	tbgCoverageDtl.pager = objCoverageDtl.coverageList;
	tbgCoverageDtl.render("coverageDtlTable");
	
	function setFieldValues(rec){
		try{
			$("txtBaseAmt").value = rec == null ? "" : formatCurrency(rec.baseAmt);
			$("txtNoOfDays").value = rec == null ? "" : rec.noOfDays;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("btnReturn").observe("click", function(){
		coveragesOverlay.close();
		delete coveragesOverlay;
	});
</script>