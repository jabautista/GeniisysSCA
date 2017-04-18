<div id="deductibleInfoSectionDiv" name="deductibleInfoSectionDiv" class="sectionDiv" changeTagAttr="true" style="padding-bottom: 10px;">

	<div id="deductibleInfoTableGrid" style="height: 230px; margin: 10px;"></div>
	
	<div align="right" style="width: 100%; border: 0px; margin-bottom: 10px;" class="sectionDiv">
		<label style="float: left; margin-top: 6px; margin-left: 630px;">Total Deductible Amount:</label>
		<input type="text" id="totalDeductibleAmount" style="margin-left: 3px; width: 122px; float: left; text-align: right;" readonly="readonly" tabindex="501"/>
	</div>
	<table align="center" width="60%">
		<tr>
			<td class="rightAligned">Deductible Title</td>
			<td class="leftAligned" colspan="3">
				<input id="txtDeductibleTitle" type="text" style="float: left; width: 98.5%; height: 13px; margin: 0px;" value="" readonly="readonly" tabindex="502">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="13%">Rate</td>
			<td class="leftAligned" width="25%"><input type="text" id="txtDeductibleRate" readonly="readonly" style="width: 96%; text-align: right;" tabindex="504"/></td>
			<td class="rightAligned" width="13%">Amount</td>
			<td class="leftAligned" width="25%"><input type="text" id="txtDeductibleAmt" class="money" readonly="readonly" style="width: 96%;" tabindex="505"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Deductible Text</td>
			<td class="leftAligned" colspan="3">
				<textarea id="txtDeductibleText" style="width: 98.5%; resize:none;" maxlength="2000" rows="2" readonly="readonly" tabindex="506"></textarea>
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	try{
		try{
			objQuote.objDeductibleInfo = [];
			objQuote.selectedDeductibleIndex = -1;
			var objDeductibleInfo = new Object(); 
			
			objDeductibleInfo.objDeductibleInfoTableGrid = {};
			
			var deductibleInfoTableModel = {
				options: {
					id : 3,
					title: "",
					height: "206px",
					width: "900px",
					onCellFocus: function(element, value, x, y, id){
						objQuote.selectedDeductibleRow = deductibleInfoGrid.geniisysRows[y];
						objQuote.selectedDeductibleIndex = y;
						deductibleInfoGrid.keys.releaseKeys();
						setDeductibleInfoForm(objQuote.selectedDeductibleRow);
					},
					onRemoveRowFocus: function(){
						deductibleInfoGrid.keys.releaseKeys();
						objQuote.selectedDeductibleIndex = -1;
						objQuote.selectedDeductibleRow = "";
						setDeductibleInfoForm(null);
					},
					onSort: function(){
						deductibleInfoGrid.onRemoveRowFocus();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh : function(){
							deductibleInfoGrid.onRemoveRowFocus();
						},
						onFilter : function(){
							deductibleInfoGrid.onRemoveRowFocus();
						}
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
									id: 'quoteId',
									width: '0',
									visible: false
								},
								{										
									id: 'itemNo',
									width: '0',
									visible: false
								},
								{	
									id: 'perilCd',
									width: '0',
									visible: false
								},
								{	
									id : 'deductibleCd',
									title: 'Code',
									titleAlign: 'left',
									width: '65px',
									filterOption: true
								},
								{	
									id : 'deductibleTitle',
									title: 'Deductible Title',
									titleAlign: 'left',
									width: '180px',
									filterOption: true
								},
								{	
									id : 'deductibleText',
									title: 'Deductible Text',
									titleAlign: 'left',
									width: '390px',
									filterOption: true
								},
								{	
									id : 'deductibleRt',
									title: 'Rate',
									titleAlign: 'right',
									width: '115px',
									align: 'right',
									geniisysClass: 'rate',
									filterOption: true
								},
								{	
									id : 'deductibleAmt',
									title: 'Amount',
									titleAlign: 'right',
									align: 'right',
									width: '128px',
									geniisysClass: 'money',
									filterOption: true
								},	
							],
							rows: [],
							id: 26665
			};
			deductibleInfoGrid = new MyTableGrid(deductibleInfoTableModel);
			deductibleInfoGrid.pager = objDeductibleInfo.objDeductibleInfoTableGrid;
			deductibleInfoGrid.render("deductibleInfoTableGrid");
			deductibleInfoGrid.afterRender = function (){
				objQuote.objDeductibleInfo = deductibleInfoGrid.geniisysRows;
				computeTotalDeductibleAmount();
			};
		}catch(e){
			showErrorMessage("deductibleInformationTableGrid page", e);
		}
		
		function setDeductibleInfoForm(obj){
			$("txtDeductibleTitle").value = (obj == null ? "" : unescapeHTML2(obj.deductibleTitle));
			$("txtDeductibleRate").value = (obj == null ? "" : unescapeHTML2(formatToNineDecimal(obj.deductibleRt)));
			$("txtDeductibleAmt").value = (obj == null ? "" : unescapeHTML2(formatCurrency(obj.deductibleAmt)));
			$("txtDeductibleText").value = (obj == null ? "" : unescapeHTML2(obj.deductibleText));
			deductibleCd = (obj == null ? "" : obj.deductibleCd);
		}
		
		objQuoteGlobal.setDeductibleInfoForm = setDeductibleInfoForm;
		
		function computeTotalDeductibleAmount(){
			var deductibleTotalAmt = 0;
			var dedAmt = 0;
			for(var i = 0; i < objQuote.objDeductibleInfo.length; i++){
				if(objQuote.objDeductibleInfo[i].recordStatus != -1){
					if(objQuote.objDeductibleInfo[i].deductibleAmt == null){
						dedAmt = 0;	
					}else if(objQuote.objDeductibleInfo[i].deductibleAmt == 0){
						dedAmt = 0;
					}else{
						dedAmt = unformatCurrencyValue(objQuote.objDeductibleInfo[i].deductibleAmt);
					}
					deductibleTotalAmt = parseFloat(deductibleTotalAmt) + parseFloat(dedAmt);	
				}
			}
			$("totalDeductibleAmount").value = formatCurrency(deductibleTotalAmt);
		}
	}catch(e){
		showErrorMessage("deductibleInformation page", e);
	}
</script>
