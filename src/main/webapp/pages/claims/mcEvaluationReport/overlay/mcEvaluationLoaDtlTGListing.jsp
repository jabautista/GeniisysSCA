<div style=" " align="center">
	<div id="loaDtlTG" style=" width: 480px; height: 180px;"  align="center"></div>
	<div style="margin-top: 0px; width: 400px;" align="center">
		<table>
			<tr>
				<td class="rightAligned" >Total Parts Amount: </td>
				<td class="leftAligned">
					<input type="text" id="totalPartAmt" name="totalPartAmt" value="" style="width: 200px; text-align: right; margin-left: 3px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	try{
		var objLoaDtlTg = JSON.parse('${mcEvalLoaDtlTg}'.replace(/\\/g, '\\\\'));
		$("totalPartAmt").value = formatCurrency(objLoaDtlTg.totalPartAmt);
		var loaDtlTable = {
			id:3,
			url: contextPath+"/GICLEvalLoaController?action=getMcEvalLoaDtlTGList&refresh=1&evalId="+$F("evalId")+
			"&payeeTypeCd="+$F("payeeTypeCd")+"&payeeCd="+$F("payeeCd"),
			options: {
				height: '150px',
				width: '503px',
				onCellFocus: function(element, value, x, y, id) {
					loaDtlGrid.keys.removeFocus(loaDtlGrid.keys._nCurrentFocus, true);
					loaDtlGrid.releaseKeys();
				},onRemoveRowFocus : function(){
					loaDtlGrid.keys.removeFocus(loaDtlGrid.keys._nCurrentFocus, true);
					loaDtlGrid.releaseKeys();
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
					id: 'lossExpDesc',
					width: '200',
					title: 'Parts/Labor/Materials',
				  	filterOption: true
				},
				{	
					id: 'partAmt',
					width: '260',
					title: 'Amount',
					geniisysClass : 'money',
					align: 'right',
				  	filterOption: true
				},
				{	
					id: 'lossExpCd',
					width: '190',
					width: '0',
					visible: false
				},
				{	
					id: 'payeeCd',
					width: '0',
					visible: false
				},
				{	
					id: 'payeeTypeCd',
					width: '0',
					visible: false
				},
				{	
					id: 'evalId',
					width: '0',
					visible: false
				}               
			],
			rows: objLoaDtlTg.rows
		};
		
		loaDtlGrid = new MyTableGrid(loaDtlTable);
		loaDtlGrid.pager = objLoaDtlTg;
		loaDtlGrid.render('loaDtlTG');
		
		
	}catch(e){
		showErrorMessage("LOA DTL TG",e);
	}
</script>