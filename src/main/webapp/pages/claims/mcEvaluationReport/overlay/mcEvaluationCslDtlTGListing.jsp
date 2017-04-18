<div align="center">
	<div id="cslDtlTG" style=" width: 480px; height: 180px;"  align="center"></div>
	<div style="margin-top: 30px; width: 400px;" align="center">
		<table>
			<tr>
				<td class="rightAligned" >Total Parts Amount: </td>
				<td class="leftAligned">
					<input type="text" id="totalPartAmt" name="totalPartAmt" value="" style="width: 200px; text-align: right;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript" >
	
	try{
		var objCslDtlTg = JSON.parse('${mcEvalCslDtlTg}'.replace(/\\/g, '\\\\'));
		$("totalPartAmt").value = formatCurrency(objCslDtlTg.totalPartAmt);
		var cslDtlTable = {
			id:3,
			height: '150px',
			url: contextPath+"/GICLEvalCslController?action=getMcEvalCslDtlTGList&refresh=1&evalId="+$F("evalId")+
			"&payeeTypeCd="+$F("payeeTypeCd")+"&payeeCd="+$F("payeeCd"),
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
			rows: objCslDtlTg.rows
		};
		
		cslDtlGrid = new MyTableGrid(cslDtlTable);
		cslDtlGrid.pager = objCslDtlTg;
		cslDtlGrid.render('cslDtlTG');
	}catch(e){
		showErrorMessage("CSL DTL Error",e);
	}
</script>