<div class="sectionDiv" style="width: 420px;">
	<div id="datedCheckDetailsTableDiv" style="padding-top: 10px; padding-bottom: 10px">
		<div id="datedCheckDetailsTable" style="height: 141px; padding-left: 10px;"></div>
	</div>
	<div align="" id="aircraftTypeFormDiv">
		<table style="margin-left: 15px; margin-bottom: 15px;">
			<tr>
				<td colspan="4">Assured</td>
			</tr>
			<tr>
				<td class="leftAligned" colspan="4">
					<input id="txtAssured" type="text" class="" style="width: 382px;" tabindex="101" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td colspan="4">Policy/Endorsement Number</td>
			</tr>
			<tr>
				<td class="leftAligned" colspan="4">
					<input id="txtPolNo" type="text" class="" style="width: 382px;" tabindex="102" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td align="center" style="width: 44px;">User ID</td>
				<td><input id="txtUserId" type="text" class="" style="width: 122px;" readonly="readonly" tabindex="103"></td>
				<td align="center" style="width: 80px;">Last Update</td>
				<td><input id="txtLastUpdate" type="text" class="" style="width: 122px;" readonly="readonly" tabindex="104"></td>
			</tr>
		</table>
	</div>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnForeignCurrency2" value="Foreign Currency" tabindex="201">
		<input type="button" class="button" id="btnBreakDown" value="Breakdown" tabindex="202">
	</div>
</div>
<div align="center">
	<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 10px; width: 100px;" tabindex="203"/>
</div>
<script type="text/javascript">	
	disableButton("btnForeignCurrency2");
	disableButton("btnBreakDown"); 
	
	$("btnReturn").observe("click", function(){
		overlayDetails.close();
		delete overlayDetails;
	});
	
	var jsonRecDetails = JSON.parse('${jsonRecListDetails}');
	var objCurrRecordDetails = null;
	
	datedChecksDetails = {
			url : contextPath+"/GIACApdcPaytDtlController?action=showDetails&refresh=1&pdcId="+'${pdcId}',
			options: {
				width: '400px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					objCurrRecordDetails = tbgDatedChecksDetails.geniisysRows[y];
					setDetailsFieldValue(objCurrRecordDetails);
					tbgDatedChecksDetails.keys.removeFocus(tbgDatedChecksDetails.keys._nCurrentFocus, true);
					tbgDatedChecksDetails.keys.releaseKeys();
				},
				prePager: function(){
					tbgDatedChecksDetails.keys.removeFocus(tbgDatedChecksDetails.keys._nCurrentFocus, true);
					tbgDatedChecksDetails.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					setDetailsFieldValue(null);
					tbgDatedChecksDetails.keys.removeFocus(tbgDatedChecksDetails.keys._nCurrentFocus, true);
					tbgDatedChecksDetails.keys.releaseKeys();
				},
				onSort : function(){
					setDetailsFieldValue(null);
					tbgDatedChecksDetails.keys.removeFocus(tbgDatedChecksDetails.keys._nCurrentFocus, true);
					tbgDatedChecksDetails.keys.releaseKeys();	
				},
				onRefresh : function(){
					setDetailsFieldValue(null);
					tbgDatedChecksDetails.keys.removeFocus(tbgDatedChecksDetails.keys._nCurrentFocus, true);
					tbgDatedChecksDetails.keys.releaseKeys();
				}				
				
			},									
			columnModel: [
				{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},				
					{
						id : "transactionType",
						title: "Tran Type",
						width: '60px',
						align : "right",
						titleAlign : "right",
						filterOptionType: 'number',
					},
					{
						id : "issCd",
						title: "Iss Cd",
						width: '60px',
					},
					{
						id : "premSeqNo",
						title: "Bill/CM No.",
						width: '70px',
						align : "right",
						titleAlign : "right",
						filterOptionType: 'number',
						renderer : function(value) {
							return lpad(value,0,12);
						}
					},
					{
						id : "instNo",
						title: "Inst #",
						width: '60px',
						align : "right",
						titleAlign : "right",
						filterOptionType: 'number',
						renderer : function(value) {
							return lpad(value,0,2);
						}
					},
					{
						id : "collectionAmt",
						title: "Collection Amount",
						width: '120px',
						align : "right",
						titleAlign : "right",
						filterOptionType: 'number',
						renderer : function(value) {
							return formatCurrency(value);
						}
					},
			],
			rows: jsonRecDetails.rows
		};
	
	tbgDatedChecksDetails = new MyTableGrid(datedChecksDetails);
	tbgDatedChecksDetails.pager = jsonRecDetails;
	tbgDatedChecksDetails.render('datedCheckDetailsTable');
	
	function setDetailsFieldValue(rec){
		$("txtAssured").value = (rec == null ? "" : (rec.dspAssured));
		$("txtPolNo").value = (rec == null ? "" : (rec.dspPolicyNo));
		$("txtUserId").value = (rec == null ? "" : (rec.userId));
		$("txtLastUpdate").value = (rec == null ? "" : (rec.lastUpdate));
		
		rec == null ? disableButton("btnForeignCurrency2") : enableButton("btnForeignCurrency2");
		rec == null ? disableButton("btnBreakDown") : enableButton("btnBreakDown");
		
		objCurrRecordDetails = rec;
	}
	
	$("btnForeignCurrency2").observe("click",function(){
		try {
			overlayForeignCurrency = Overlay.show(contextPath
					+ "/GIACApdcPaytDtlController", {
				urlContent : true,
				urlParameters : {
					action : "showForeignCurrency",
					ajax : "1",
					currDesc : objCurrRecordDetails.dspCurrencyDesc,
					convertRt: objCurrRecordDetails.currencyRt,
					fcurrencyAmt : objCurrRecordDetails.fcurrencyAmt
					},
				title : "Foreign Currency",
				 height: 160, //modified by jdiago 08.19.2014 from 150 - 160
				 width: 402,
				draggable : true
			});   
		} catch (e) {
			showErrorMessage("showForeignCurrency", e);
		}
	});
	
	$("btnBreakDown").observe("click",function(){
		try {
			overlayBreakdown = Overlay.show(contextPath
					+ "/GIACApdcPaytDtlController", {
				urlContent : true,
				urlParameters : {
					action : "showBreakdown",
					ajax : "1",
					taxAmt : objCurrRecordDetails.taxAmt,
					premiumAmt: objCurrRecordDetails.premiumAmt,
					},
				title : "Breakdown",
				 height: 130,
				 width: 402,
				draggable : true
			});   
		} catch (e) {
			showErrorMessage("showBreakdown", e);
		} 
	});
</script>