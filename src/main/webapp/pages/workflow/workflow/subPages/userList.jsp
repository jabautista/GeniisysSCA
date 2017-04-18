<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="userListMainDiv" style="margin-top: 10px; margin-bottom: 10px; float: left; width: 99%;">
	<div id="userListDiv">
		<div id="userListTableDiv" style="">
			<div id="userListTable" style="height: 295px"></div>
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
	var mode = "${mode}";
	objSelectedUsers = new Array();
	objGUEAttach = new Array();
	
	function getSelectedUsers(){
		var tempRows = tbgWorkflowUserList.getModifiedRows();
		var selectedRows = new Array();
		
		for(var i=0; i<tempRows.length; i++){
			if(tempRows[i].include == "Y"){
				tempRows[i].createUser = tempRows[i].userId;				
				selectedRows.push(tempRows[i]);
			}
		}
		return selectedRows;
	}	

	function validatePassingUser(){
		tbgWorkflowUserList.keys.releaseKeys();		
		objSelectedUsers = getSelectedUsers();
		if(objSelectedUsers.length == 0){
			showMessageBox("Please select a user.", imgMessage.INFO);
			return;
		}
				
		if(mode == 1){
			if(checkMultipleAssignSw(mode)){
				if(objSelectedUsers.length == 0){
					objCurrEventDtl.selected = "N";
					tbgUserEventDetail.setValueAt(false, tbgUserEventDetail.getColumnIndex('selected'), objCurrEventDtl.rowIndex, true);
				} else {
					objCurrEventDtl.selectedUsers = objSelectedUsers;
					tbgUserEventDetail.setValueAt(objSelectedUsers, tbgUserEventDetail.getColumnIndex("selectedUsers"), objCurrEventDtl.rowIndex, true);
				}
				overlayWorkflowUserList.close();
			}
		} else {
			new Ajax.Request(contextPath + "/GIISEventModUserController", {
				method : "GET",
				parameters : {action : "validatePassingUser",
							  eventCd : objCurrGIISEvent.eventCd,
							  eventType : objCurrGIISEvent.eventType},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == "N"){
							showMessageBox("Access denied. ${PARAMETERS['USER'].userId} is not allowed to transfer transaction.");
						} else {
							if(checkMultipleAssignSw(mode)){
								showRemarks(mode);
							}
						}
					}
				}
			});	
		}			
	}
	
	$("btnCancel").observe("click", function(){
		tbgWorkflowUserList.keys.releaseKeys();
		overlayWorkflowUserList.close();
		if(mode == 1 && objCurrEventDtl.viewSw != true){			
			objCurrEventDtl.selected = "N";
			tbgUserEventDetail.setValueAt("N", tbgUserEventDetail.getColumnIndex('selected'), objCurrEventDtl.rowIndex, true);
		}
	});

	$("btnOk").observe("click", function(){
		validatePassingUser();
	});
	
	var objTGWorkflowUserList = JSON.parse('${userListTableGrid}'.replace(/\\/g, "\\\\"));	
	var workflowUserListTable = {
			options: {
				width: '380px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {

				},
				onRemoveRowFocus : function(element, value, x, y, id){	
				},
				prePager: function (){

				},
				afterRender : function(){
					checkSelectedUsers();
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
					id : "userId",
					title: "User Id",
					width: '120px'
				},
				{
					id : "username",
					title: "Username",
					width: '190px'
				},
				{
					id : "emailAdd",
					title: "",
					width: '0',
					visible: false
				}],
			rows: objTGWorkflowUserList.rows
		};

	tbgWorkflowUserList = new MyTableGrid(workflowUserListTable);
	tbgWorkflowUserList.pager = objTGWorkflowUserList;
	tbgWorkflowUserList.render('userListTable');
	
	function checkSelectedUsers(){
		if(mode == 1){
			var users = objCurrEventDtl.selectedUsers || [];
			var rows = tbgWorkflowUserList.geniisysRows;
			for(var i=0; i<users.length; i++){
				for(var j=0; j<rows.length; j++){
					if(users[i].userId == rows[j].userId){
						tbgWorkflowUserList.setValueAt("Y", tbgWorkflowUserList.getColumnIndex("include"), j, true);
					}
				}
			}
		}
	}	
</script>