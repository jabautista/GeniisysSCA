<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

 <div id="intmHistMainDiv" style="width: 703px;">
	<div class="sectionDiv" style="margin-top: 5px; padding: 8px 0 8px 0;">
		<table align="center">
			<tr>
				<td style="padding-right: 7px;">Intermediary</td>
				<td><input id="txtIntmNo" type="text" value="${intmNo }" class="rightAligned" readonly="readonly" style="width: 100px;"></td>
				<td><input id="txtIntmName" type="text" value="${intmName }" readonly="readonly" style="width: 300px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="height: 460px; margin-bottom: 10px;">	
		<div id="intmHistTable" style="height: 327px; margin: 10px 0 40px 10px;"></div>
		
		<div>
			<input type="button" class="button" id="btnReturn" value="Return" style="width: 80px; margin: 20px 0 0 300px;"> 
			
			<div class="sectionDiv" style="width: 250px; height: 65px; float: right; margin-right: 10px;">
				<table>
					<tr>
						<td colspan="2">Legend : </td>
					</tr>
					<tr>
						<td style="padding: 5px 0 5px 35px;">C - Corp Tag</td>
						<td style="padding-left: 15px;">L - License Tag</td>
					</tr>
					<tr>
						<td style="padding-left: 35px;">A - Active Tag</td>
						<td style="padding-left: 15px;">S - Special Rate</td>
					</tr>	
				</table>
			</div>
		</div>
	</div>	
	
</div>

<script type="text/javascript">
try{
	$("txtIntmNo").value = $("txtIntmNo").value == "" ? "" : formatNumberDigits($F("txtIntmNo"), 12);
	
	$("btnReturn").observe("click", function(){
		histOverlay.close();
	});
	

	var objIntmHist = {};
	objIntmHist.intmHistList = JSON.parse('${jsonIntmHist}');
	
	var intmHistTableModel = {
		url: contextPath + "/GIISIntermediaryController?action=showGiiss076IntmHist&refresh&intmNo="+$F("txtIntmNo"),
		options: {
			width: '680px',
			onCellFocus: function(element, value, x, y, id){
				tbgIntmHist.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				tbgIntmHist.keys.releaseKeys();
			},
			onSort: function(){
				tbgIntmHist.onRemoveRowFocus();
			},
			onRefresh: function(){
				tbgIntmHist.onRemoveRowFocus();
			},
			toolbar:{
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					tbgIntmHist.onRemoveRowFocus();
				}
			}
		},
		columnModel: [
			{ 								// this column will only use for deletion
			    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
			    width: '0',				    
			    visible : false			
			},
			{
				id : 'divCtrId',
				width : '0',
				visible : false
			},	
			{
				id : 'effDate',
				filterOption : true,
				filterOptionType: 'formattedDate',
				title : 'Effectivity Date',
				width : '96px'				
			},
			{
				id : 'expiryDate',
				filterOption : true,
				filterOptionType: 'formattedDate',
				title : 'Expiry Date',
				width : '96px'				
			},
			{
				id : 'oldIntmType',
				filterOption : true,
				title : 'Old Intm Type',
				width : '90px'				
			},
			{
				id : 'intmType',
				filterOption : true,
				title : 'New Intm Type',
				width : '90px'
			},	
			{
				id : 'oldWtaxRate',
				filterOption : true,
				filterOptionType: 'number',
				geniisysClass: 'rate',
				title : 'Old Tax',
				titleAlign: 'right',
				align: 'right',
				width : '90px',
				deciRate: 3
			},
			{
				id : 'wtaxRate',
				filterOption : true,
				filterOptionType: 'number',
				geniisysClass: 'rate',
				title : 'New Tax',
				titleAlign: 'right',
				align: 'right',
				width : '90px',
				deciRate: 3
			},
			{ 	id:			'corpTag',
				align:		'center',
				title:		'&#160;&#160;C',
				altTitle:   'Corp Tag',
				titleAlign:	'center',
				width:		'25px',
				filterOption : true
			},
			{ 	id:			'licTag',
				align:		'center',
				title:		'&#160;&#160;L',
				altTitle:   'Licence Tag',
				titleAlign:	'center',
				width:		'25px',
				filterOption : true
			},
			{ 	id:			'activeTag',
				align:		'center',
				title:		'&#160;&#160;A',
				altTitle:   'Active Tag',
				titleAlign:	'center',
				width:		'25px',
				filterOption : true
			},
			{ 	id:			'specialRate',
				align:		'center',
				title:		'&#160;&#160;S',
				altTitle:   'Special Rate',
				titleAlign:	'center',
				width:		'25px',
				filterOption : true
			},
			{
				id : 'intmNo',
				width : '0',
				visible: false
			}
		],
		rows: objIntmHist.intmHistList.rows
	};
	
	tbgIntmHist = new MyTableGrid(intmHistTableModel);
	tbgIntmHist.pager = objIntmHist.intmHistList;
	tbgIntmHist.render("intmHistTable");
	
	
}catch(e){
	showErrorMessage("Page error", e);
}
</script>