<div style="width: 100%">
	<table border="0" style="margin-top: 10px; margin-bottom: 10px;" align="center">
		<tr>
			<td class="rightAligned">Peril</td>
			<td class="leftAligned">
				<div style="width: 280px;" class="required withIconDiv" >
					<input type="text" id="perilName" name="perilName" value="" style="width: 230px;" class="required withIcon" readonly="readonly">
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="availPeril" name="availPeril" alt="Go" />
				</div>
			</td>
			<td class="rightAligned">Allowable TSI/No. of Days<td>
			<td class="leftAligned">
				<input type="text" id="dspAllow" name="dspAllow" style="width: 240px; text-align: right;" readOnly="readOnly">
			</td>
		</tr>
	</table>
</div>
<div id="availInfoTBGrid" style="position: relative; height: 200px; margin: auto; margin-top: 10px; margin-bottom: 50px; width: 800px;"> </div>
<script type="text/javascript">
	try{
		objCLMItem.objAvailmentsTBG = JSON.parse('${giclAvailmentsGrid}'.replace(/\\/g, '\\\\'));
		var availmentsModel = {
			url: contextPath+"/GICLAccidentDtlController?action=getItemClaimAvailments&refresh=1&claimId="+objCLMGlobal.claimId+"&itemNo="
								+$F("txtItemNo")+"&groupedItemNo=" +$F("txtGrpItemNo"),  
			columnModel : [
				{
					id : 'recordStatus',
					width : '0',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0px',
					visible : false
				},
				{
					id : 'dspClaimNo',
					width : '180px',
					title : 'Claim No.',
					sortable : true
				},
				{
					id : 'dspLossDate',
					width : '100px',
					title : 'Loss Date',
					sortable : true
				},
				{
					id : 'dspClaimStat',
					width : '100px',
					title : 'Status',
					sortable : true
				},
				{
					id : 'lossReserve',
					width : '150px',
					title : 'Reserve Amount',
					sortable : true
				},
				{
					id: 'paidAmt',
					width : '150px',
					title : 'Paid Amount',
					sortable : true
				},
				{
					id: 'dspNoOfDays',
					width : '100px',
					title : 'Days Used',
					sortable : true
				},
			],
			resetChangeTag: true,
			rows : objCLMItem.objAvailmentsTBG.rows || [],
			id : 40
		};
			availmentsGrid = new MyTableGrid(availmentsModel);
			availmentsGrid.pager = objCLMItem.objAvailmentsTBG;
			availmentsGrid._mtgId = 40;
			availmentsGrid.render('availInfoTBGrid');
		
		$("availPeril").observe("click", function(){
			showClmAvailPerilLOV();	
		});
	}catch (e){
		showErrorMessage("list of availments", e);
	}
</script>	