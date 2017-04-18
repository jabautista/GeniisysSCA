<div id="commDueDetailsMainDiv" style="width: 99.5%; margin-top: 5px;">
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
		<div id="commDueDetailsTGDiv" style="height: 285px;"></div>
		<div>
			<table style="margin-left: 70px;">
				<tr>
					<td class="rightAligned">Total</td>
					<td><input id="sumPremPaid" name="totalField" type="text" readonly="readonly" style="width: 120px; margin: 0px 3px 0px 3px; text-align: right;" tabindex="203"/></td>
					<td><input id="sumCommDue" name="totalField" type="text" readonly="readonly" style="width: 120px; margin-right: 3px; text-align: right;" tabindex="204"/></td>
					<td><input id="sumWhtaxDue" name="totalField" type="text" readonly="readonly" style="width: 120px; margin-right: 3px; text-align: right;" tabindex="205"/></td>
					<td><input id="sumInputVatDue" name="totalField" type="text" readonly="readonly" style="width: 120px; margin-right: 3px; text-align: right;" tabindex="206"/></td>
					<td><input id="sumNetCommDue" name="totalField" type="text" readonly="readonly" style="width: 120px; margin-right: 3px; text-align: right;" tabindex="207"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Policy Number</td>
					<td colspan="6"><input id="dtlPolicyNo" name="dtlPolicyNo" type="text" readonly="readonly" style="width: 213px; margin-left: 3px;" tabindex="207"/></td>
				</tr>
			</table>
		</div>
	</div>
	
	<center><input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 8px; width: 100px;" tabindex="210"/></center>
</div>


<script type="text/javascript">
	var objDetails = {};
	objDetails.commDueDetails = JSON.parse('${commDueDetailsJSON}');

	$("txtIntmNo").focus();
	$("txtIntmNo").value = '${intmNo}';
	$("txtIntmName").value = unescapeHTML2('${intmName}');
	
	var commDueDetailsTableModel = {
		url: contextPath + "/GIACCommissionVoucherController?action=showCommDueDetailsOverlay&refresh=1"+
							"&intmNo=${intmNo}",
		options : {
			width : '850px',
			height: '256px',
			hideColumnChildTitle: true,
			onCellFocus : function(element, value, x, y, id){
				commDueDetailgTG.keys.releaseKeys();
				$("dtlPolicyNo").value = commDueDetailgTG.geniisysRows[y].policyNo;
			},
			onRemoveRowFocus : function(){
				commDueDetailgTG.keys.releaseKeys();
				$("dtlPolicyNo").value = "";
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					commDueDetailgTG.onRemoveRowFocus();
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
						title: 'Issue Code',
						width: 45,							
						sortable: false,
						filterOption: true,
					},
					{	id: 'premSeqNo',
						title: 'Prem Seq No',
						width: 110,
						align: 'right',
						sortable: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					}
				]
			},
			{	id: 'premiumPaid',
				title: 'Premium Amt',
				titleAlign: 'right',
				align: 'right',
				width: '130px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'commissionDue',
				title: 'Commission',
				titleAlign: 'right',
				align: 'right',
				width: '130px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'whtaxDue',
				title: 'Withholding Tax',
				titleAlign: 'right',
				align: 'right',
				width: '130px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'inputVatDue',
				title: 'Input Vat',
				titleAlign: 'right',
				align: 'right',
				width: '130px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			},
			{	id: 'netCommDue',
				title: 'Net Comm Due',
				titleAlign: 'right',
				align: 'right',
				width: '130px',
				geniisysClass: 'money',
				filterOption: true,
				filterOptionType: 'numberNoNegative'
			}
		],
		rows: objDetails.commDueDetails.rows
	};
	commDueDetailgTG = new MyTableGrid(commDueDetailsTableModel);
	commDueDetailgTG.pager = objDetails.commDueDetails;
	commDueDetailgTG.render("commDueDetailsTGDiv");
	commDueDetailgTG.afterRender = function(){
		commDueDetailgTG.onRemoveRowFocus();
		getCommDueDetailsTotals();
	};
	
	function getCommDueDetailsTotals(){
		new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
			parameters: {
				action:		"getCommDueDtlTotals",
				intmNo:		$F("intmNo") == "" ? '${intmNo}' : $F("intmNo"),
				filter:		JSON.stringify(commDueDetailgTG.objFilter)
			},
			asynchronous: false,
			onCreate: showNotice("Computing totals, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					
					$("sumPremPaid").value = formatCurrency(res.SUMPREMPAID);
					$("sumCommDue").value = formatCurrency(res.SUMCOMMDUE);
					$("sumWhtaxDue").value = formatCurrency(res.SUMWHTAXDUE);
					$("sumInputVatDue").value = formatCurrency(res.SUMINPUTVATDUE);
					$("sumNetCommDue").value = formatCurrency(res.SUMNETCOMMDUE);
				}
				
			}
		});
	}

	$("btnReturn").observe("click", function(){
		commDueDetailsOverlay.close();
		delete commDueDetailsOverlay;
	});
</script>