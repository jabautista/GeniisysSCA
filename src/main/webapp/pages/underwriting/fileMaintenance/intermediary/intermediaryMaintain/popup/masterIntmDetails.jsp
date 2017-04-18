<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="masterIntmMainDiv" style="width: 538px;">
	<div class="sectionDiv" style="margin-top: 5px; padding: 8px 0 8px 0;">
		<table align="center">
			<tr>
				<td style="padding-right: 7px;">Master Intermediary No.</td>
				<td><input id="txtMasterIntmNo" type="text" value="${masterIntmNo }" class="rightAligned" readonly="readonly" style="width: 100px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="height: 410px; margin-bottom: 10px;">	
		<div id="masterIntmTable" style="height: 327px; margin: 10px 0 10px 10px;"></div>
		
		<div style="margin: 30px 0 0 8px;">
			<table>
				<tr>
					<td class="rightAligned" style="padding: 0 5px 0 8px;">User ID</td>
					<td class="leftAligned" colspan="2"><input id="txtUserId" type="text" class="" style="width: 160px;" readonly="readonly" ></td>
					<td width="" class="rightAligned" style="padding: 0 5px 0 36px;">Last Update</td>
					<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 160px;" readonly="readonly" ></td>
				</tr>
			</table>
		</div>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnReturn" value="Return"  style="width: 80px;">
	</div>
</div>

<script type="text/javascript">
try{	
	$("txtMasterIntmNo").value = $("txtMasterIntmNo").value == "" ? "" : formatNumberDigits($F("txtMasterIntmNo"), 12);
	
	var objMasterIntm = {};
	objMasterIntm.masterIntmList = JSON.parse('${jsonMasterIntm}');
	
	var masterIntmTableModel = {
		url: contextPath + "/GIISIntermediaryController?action=showGiiss076MasterIntmDetails&refresh&masterIntmNo="+$F("txtMasterIntmNo"),
		options: {
			width: '515px',
			onCellFocus: function(element, value, x, y, id){
				tbgMasterIntm.keys.releaseKeys();
				setFieldValues(tbgMasterIntm.geniisysRows[y]);
			},
			onRemoveRowFocus: function(){
				tbgMasterIntm.keys.releaseKeys();
				setFieldValues(null);
			},
			onSort: function(){
				tbgMasterIntm.onRemoveRowFocus();
			},
			onRefresh: function(){
				tbgMasterIntm.onRemoveRowFocus();
			},
			toolbar:{
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					tbgMasterIntm.onRemoveRowFocus();
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
				id : 'intmNo',
				filterOption : true,
				filterOptionType: 'integerNoNegative',
				title : 'Intm No.',
				titleAlign: 'right',
				align: 'right',
				width : '120px'				
			},
			{
				id : 'intmName',
				filterOption : true,
				title : 'Intermediary Name',
				width : '259px',
				renderer : function(value){ 
					return escapeHTML2(value);
				}				
			},	
			{
				id : 'oldIntmNo',
				filterOption : true,
				filterOptionType: 'integerNoNegative',
				title : 'Old Intm No.',
				titleAlign: 'right',
				align: 'right',
				width : '120px'				
			},
			{
				id : 'userId',
				width : '0',
				visible: false
			},
			{
				id : 'lastUpdate',
				width : '0',
				visible: false				
			}
		],
		rows: objMasterIntm.masterIntmList.rows
	};
	
	tbgMasterIntm = new MyTableGrid(masterIntmTableModel);
	tbgMasterIntm.pager = objMasterIntm.masterIntmList;
	tbgMasterIntm.render("masterIntmTable");
	
	function setFieldValues(rec){
		try{
			$("txtUserId").value = (rec == null ? "" :rec.userId);
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);			
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	
	$("btnReturn").observe("click", function(){
		miOverlay.close();
	});
}catch(e){
	showErrorMessage("Page error", e);
}
</script> 