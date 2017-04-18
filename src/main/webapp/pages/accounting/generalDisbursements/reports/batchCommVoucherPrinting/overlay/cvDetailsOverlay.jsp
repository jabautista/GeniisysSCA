<div id="cvDetailsMainDiv" style="width: 99.5%; margin-top: 5px;">
    <div class="sectionDiv">
   		<div align="center">
			<table style="margin: 10px;">
				<tr>
					<td class="rightAligned">Intermediary</td>
					<td class="leftAligned">
						<input id="txtIntmNo" name="txtIntmNo" readonly="readonly" type="text" style="width: 80px; float: left; height: 13px; margin-left: 3px;"tabindex="201"/>
					</td>
					<td class="leftAligned">
						<input id="txtIntmName" name="txtIntmName" type="text" style="width: 450px; height: 13px;" value="" readonly="readonly" tabindex="202"/>
					</td>
				</tr>
			</table>
		</div>
    </div>
    
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 335px; width: 98.78%">
		<div id="cvDetailsTGDiv" style="height: 285px;"></div>
		<div>
			<table style="margin-left: 40px;">
				<tr>
					<td class="rightAligned">Total</td>
					<td><input id="dtlPremAmt" name="totalField" type="text" readonly="readonly" style="width: 100px; margin: 0px 3px 0px 3px; text-align: right;" tabindex="203"/></td>
					<td><input id="dtlActualComm" name="totalField" type="text" readonly="readonly" style="width: 100px; margin-right: 3px; text-align: right;" tabindex="204"/></td>
					<td><input id="dtlCommPayable" name="totalField" type="text" readonly="readonly" style="width: 100px; margin-right: 3px; text-align: right;" tabindex="205"/></td>
					<td><input id="dtlCommAmt" name="totalField" type="text" readonly="readonly" style="width: 100px; margin-right: 3px; text-align: right;" tabindex="206"/></td>
					<td><input id="dtlWtaxAmt" name="totalField" type="text" readonly="readonly" style="width: 107px; margin-right: 3px; text-align: right;" tabindex="207"/></td>
					<td><input id="dtlInputVat" name="totalField" class="money" type="text" readonly="readonly" style="width: 94px; text-align: right;" tabindex="208"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Policy Number</td>
					<td colspan="6"><input id="dtlPolicyNo" name="dtlPolicyNo" type="text" readonly="readonly" style="width: 213px; margin-left: 3px;" tabindex="209"/></td>
				</tr>
			</table>
		</div>
	</div>
	
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 8px; width: 100px;" tabindex="210"/></center>
</div>


<script type="text/javascript">
	var objDetails = {};
	objDetails.cvDetails = JSON.parse('${cvDetailsJSON}');
	
	var cvDetailsTableModel = {
		url: contextPath + "/GIACCommissionVoucherController?action=showCvDetailsOverlay&refresh=1"+
							"&intmNo="+$F("intmNo")+"&cvPref=${cvPref}&cvNo=${cvNo}",
		options : {
			width : '850px',
			height: '256px',
			hideColumnChildTitle: true,
			onCellFocus : function(element, value, x, y, id){
				cvDetailgTG.keys.releaseKeys();
				$("dtlPolicyNo").value = cvDetailgTG.geniisysRows[y].policyNo;
			},
			onRemoveRowFocus : function(){
				cvDetailgTG.keys.releaseKeys();
				$("dtlPolicyNo").value = "";
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					cvDetailgTG.onRemoveRowFocus();
				}
			}
		},
		columnModel : [
			{
			    id: 'recordStatus',
			    width: '0',				    
			    visible : false			
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},
			{	id: 'issCd premSeqNo',
				title: 'Bill Number',
				width: '120px',
				children: [
					{	id: 'issCd',
						width: 45,							
						sortable: false
					},
					{	id: 'premSeqNo',
						title: 'Bill Number',
						width: 70,
						align: 'right',
						sortable: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					}
				]
			},
			{	id: 'premAmt',
				title: 'Premium Amt',
				titleAlign: 'right',
				align: 'right',
				width: '110px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'actualComm',
				title: 'Actual Comm',
				titleAlign: 'right',
				align: 'right',
				width: '110px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'commPayable',
				title: 'Comm Payable',
				titleAlign: 'right',
				align: 'right',
				width: '110px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'commAmt',
				title: 'Commission',
				titleAlign: 'right',
				align: 'right',
				width: '110px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'wtaxAmt',
				title: 'Withholding tax',
				titleAlign: 'right',
				align: 'right',
				width: '120px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'inputVat',
				title: 'Input Vat',
				titleAlign: 'right',
				align: 'right',
				width: '102px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'polStatus',
				title: 'Policy Status',
				width: '90px',
				filterOption: true
			}
		],
		rows: objDetails.cvDetails.rows
	};
	cvDetailgTG = new MyTableGrid(cvDetailsTableModel);
	cvDetailgTG.pager = objDetails.cvDetails;
	cvDetailgTG.render("cvDetailsTGDiv");
	cvDetailgTG.afterRender = function(){
		cvDetailgTG.onRemoveRowFocus();
		if(cvDetailgTG.geniisysRows.length > 0){
			var row = cvDetailgTG.geniisysRows[0];
			$("dtlPremAmt").value = formatCurrency(row.totalPremAmt);
			$("dtlActualComm").value = formatCurrency(row.totalActualComm);
			$("dtlCommPayable").value = formatCurrency(row.totalCommPayable);
			$("dtlCommAmt").value = formatCurrency(row.totalCommAmt);
			$("dtlWtaxAmt").value = formatCurrency(row.totalWtaxAmt);
			$("dtlInputVat").value = formatCurrency(row.totalInputVatAmt);
		}else{
			$$("input[name='totalField']").each(function(i){
				i.value = "0.00";
			});
		}
	};

	$("btnReturn").observe("click", function(){
		cvDetailsOverlay.close();
		delete cvDetailsOverlay;
	});

	$("txtIntmNo").focus();
	$("txtIntmNo").value = $F("intmNo");
	$("txtIntmName").value = $F("intmName");
</script>