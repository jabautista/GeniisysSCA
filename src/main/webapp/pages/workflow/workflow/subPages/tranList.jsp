<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="tranListMainDiv" style="margin-top: 10px; margin-bottom: 10px; float: left; width: 99%;">
	<div id="tranListDiv">
		<div id="tranListTableDiv" style="">
			<div id="tranListTable" style="height: 295px"></div>
		</div>
	</div>
</div>
<div id="buttonsDiv" style="float: left; width: 100%;">
	<table align="center">
		<tr>
			<td>
				<input type="button" class="button" style="width: 90px;" id="btnOk" name="btnOk" value="Ok" />
				<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
			</td>
		</tr>
	</table>
</div>	
<script type="text/javascript"> 
	$("btnCancel").observe("click", function(){
		tbgWorkflowTranList.keys.releaseKeys();
		overlayWorkflowTranList.close();		
	});

	function getSelectedTransactions(){
		var tempRows = tbgWorkflowTranList.getModifiedRows();
		var selectedRows = new Array();
		
		for(var i=0; i<tempRows.length; i++){
			if(tempRows[i].include == "Y"){							
				selectedRows.push(tempRows[i]);
			}
		}
		return selectedRows;
	}	
	
	$("btnOk").observe("click", function(){
		tbgWorkflowTranList.keys.releaseKeys();
		objTranDtls = getSelectedTransactions();
		if(objTranDtls.length == 0){
			showMessageBox("Please select a record first.", imgMessage.INFO);
			return;
		}
		showWorkflowUserList(objCurrGIISEvent, 0, null);
		overlayWorkflowTranList.close();
	});
	
	var objTGWorkflowTranList = JSON.parse('${tranListTableGrid}'.replace(/\\/g, "\\\\"));	
	var workflowTranListTable = {
			options: {
				width: '645px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {

				},
				onRemoveRowFocus : function(element, value, x, y, id){	
				},
				prePager: function (){

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
					id : "include",
					title: "",					
					altTitle: "Include",
					width: 25,
			        maxlength: 1,
			        editable: true,
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
					id : "colValue",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "tranDtl",
					title: "Transaction Detail",
					width: '580px'
				}],
			rows: objTGWorkflowTranList.rows
		};

	tbgWorkflowTranList = new MyTableGrid(workflowTranListTable);
	tbgWorkflowTranList.pager = objTGWorkflowTranList;
	tbgWorkflowTranList.render('tranListTable');
</script>