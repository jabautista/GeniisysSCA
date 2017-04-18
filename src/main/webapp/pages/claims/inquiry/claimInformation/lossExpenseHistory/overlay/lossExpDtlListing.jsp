<div id="lossExpDtlMainDiv" name="lossExpDtlMainDiv">
	<div id="lossExpDtlTableGridDiv" style="margin: 10px 12px">
		<div id="lossExpDtlGridDiv" style="height: 225px; margin-top: 5px;">
			<div id="lossExpDtlTableGrid" style="height: 225px; width: 890px;"></div>
		</div>
		<div style="float: left; margin-top: 7px;">
			<table>
				<tr>
					<td class="leftAligned" style="width: 120px;">Loss/Expense Class</td>
					<td class="rightAligned">
						<select id="selLossExpClass" style="width: 150px;; height: 22px;" disabled="disabled">
							<option value=""></option>
							<option value="P">Parts</option>
							<option value="L">Labor</option>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: right; margin-top: 5px;">
			<table>
				<tr>
					<td class="leftAligned" style="width: 40px;"><b>Total</b></td>
					<td><input type="text" id="totalLossAmt" name="totalLossAmt" class="money" value="0.00" style="width: 155px;" readonly="readonly"/></td>
					<td><input type="text" id="totalAmtLessDed" name="totalAmtLessDed" class="money" value="0.00" style="width: 155px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="hidden" id="hidClmLossId"  name="hidClmLossId"  value="${clmLossId}">
			<input type="hidden" id="hidPayeeType"  name="hidPayeeType" value="${payeeType}">
			<input type="button" id="btnLEDeductibles" name="btnLEDeductibles" style="width: 120px;" class="button hover"  value="Deductibles" />
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try{
		var objLossExpDtl = JSON.parse('${jsonGiclLossExpDtl}');
		objLossExpDtl.lossExpDtlListing = objLossExpDtl.rows || []; 
		
		var lossExpDtlTableModel = {
			url : contextPath + "/GICLLossExpDtlController?action=showGICLS260LossExpDtls&action1=getGiclLossExpDtlList"+
				  "&claimId="+ nvl(objCLMGlobal.claimId, 0)+"&clmLossId="+$("hidClmLossId").value+"&payeeType="+$("hidPayeeType").value+"&lineCd="+objCLMGlobal.lineCode,
			options:{
				title: '',
				pager: { },
				width: '890px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function(){
						$("selLossExpClass").value = "";
						lossExpDtlTableGrid.keys.removeFocus(lossExpDtlTableGrid.keys._nCurrentFocus, true);
						lossExpDtlTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					var lossExpDtl = lossExpDtlTableGrid.geniisysRows[y];
					$("selLossExpClass").value = unescapeHTML2(lossExpDtl.lossExpClass);
					lossExpDtlTableGrid.keys.removeFocus(lossExpDtlTableGrid.keys._nCurrentFocus, true);
					lossExpDtlTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function() {
					$("selLossExpClass").value = "";
					lossExpDtlTableGrid.keys.removeFocus(lossExpDtlTableGrid.keys._nCurrentFocus, true);
					lossExpDtlTableGrid.keys.releaseKeys();
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
				{
					id: 'originalSw',
					title: '&#160;&#160;O',
					altTitle: 'Tag for Orig. Amount',
					width: '24px',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					sortable: false,
					defaultValue: false,
					otherValue: false,
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
		            	}
		            })
				},
				{
					id: 'withTax',
					title: 'WT',
					altTitle: 'With Tax',
					width: '24px',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					sortable: false,
					defaultValue: false,
					otherValue: false,
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}
		            	}
		            })
				},
				{	id: 'lossExpCd',
					width: '0',
					visible: false
				},
				{	id: 'dspExpDesc',
					align: 'left',
				  	title: 'Loss',
				  	titleAlign: 'center',
				  	width: '250px',
				  	editable: false,
				  	filterOption: true
				},
				{	id: 'nbtNoOfUnits',
					align: 'right',
				  	title: 'Unit(s)',
				  	titleAlign: 'center',
				  	width: '90px',
				  	editable: false,
				  	sortable: true,
				  	filterOption: true
				},
				{
				   	id: 'dedBaseAmt',
				   	title: 'Base Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '160px',
				  	geniisysClass : 'money',
				  	filterOption: true
				},
				{
				   	id: 'dtlAmt',
				   	title: 'Loss Amount',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '160px',
				  	geniisysClass : 'money',
				  	filterOption: true
				},
				{
				   	id: 'nbtNetAmt',
				   	title: 'Amount Less Deductibles',
				   	titleAlign: 'center',
				   	type : 'number',
				  	width: '160px',
				  	geniisysClass : 'money',
				  	filterOption: true
				}
				
			],
			rows : objLossExpDtl.lossExpDtlListing,
			requiredColumns: ''
		};
		
		lossExpDtlTableGrid = new MyTableGrid(lossExpDtlTableModel);
		lossExpDtlTableGrid.pager = objLossExpDtl;
		lossExpDtlTableGrid.render('lossExpDtlTableGrid');
		lossExpDtlTableGrid.afterRender = function(){
			$("selLossExpClass").value = "";
			lossExpDtlTableGrid.keys.removeFocus(lossExpDtlTableGrid.keys._nCurrentFocus, true);
			lossExpDtlTableGrid.keys.releaseKeys();
			
			var totalLossAmt = 0;
			var totalAmtLessDed = 0;
			var list = objLossExpDtl.lossExpDtlListing;
			for(var i=0; i<list.length; i++){
				if(list[i].recordStatus != -1){
					totalAmtLessDed = parseFloat(nvl(totalAmtLessDed,0)) + parseFloat(nvl(list[i].nbtNetAmt,0));
					totalLossAmt = parseFloat(nvl(totalLossAmt,0)) + parseFloat(nvl(list[i].dtlAmt, 0));
				}
			}
			
			$("totalLossAmt").value    = formatCurrency(totalLossAmt);
			$("totalAmtLessDed").value = formatCurrency(totalAmtLessDed);
		};
		
		$("btnOk").observe("click", function(){
			Windows.close("modal_dialog_lov");
		});
		
		$("btnLEDeductibles").observe("click", function(){
			overlayDeductible = Overlay.show(contextPath + "/GICLLossExpDtlController", {
				urlContent: true,
				urlParameters: {action : "showGICLS260LossExpDeductibles",
								claimId : objCLMGlobal.claimId,
								lineCd: objCLMGlobal.lineCode,
								payeeType: $("hidPayeeType").value,
								clmLossId: $("hidClmLossId").value,
								ajax: 1
				},
				title: "Deductibles",	
				id: "deductible_canvas",
				width: 795, 
				height: 325,
			    draggable: false,
			    closable: true
			});
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Expense Hist - giclLossExpDtl", e);
	}
</script>