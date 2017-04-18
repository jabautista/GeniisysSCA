<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="workflowEventMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Workflow Events</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="lblShowWorkflowEvents" name="gro" style="margin-left: 5px;">Hide</label>
	   			<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div id="userEventsDiv" class="sectionDiv">
		<div id="userEventsTableDiv" style="padding: 10px 0 10px 20px; margin-left: 120px;">
			<div id="userEventsTable" style="width: 670px; height: 250px"></div>
		</div>
		<div style="margin: 0 0 10px 0;">
			<input type="button" class="button" id="btnCreate" value="Create" style="width: 70px;">
		</div>		
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label id="lblEventList">Event List</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="lblShowEventList" name="gro" style="margin-left: 5px;">Hide</label>
	   		</span>
	   	</div>
	</div>	
	<div id="userEventsDetailsDiv">
	
	</div>
</div>
<script type="text/javascript">
	releaseWorkflowTableGridKeys();
	var objTGUserEvent = JSON.parse('${userEventTableGrid}');
	objCurrEvent = new Object();
	tbgUserEventDetail = null;
	objWorkflowForm = new Object();	
	objWorkflowForm.variables = new Object();
	
	function clearUserEventDetails(){
		tbgUserEventDetail.clear();
		tbgUserEventDetail.empty();
		objCurrEvent = null;
		tbgUserEventDetail.url = contextPath+"/GIPIUserEventController?action=refreshUserEventDetails&eventCd=";
	}
	
	/**
	 * @author andrew
	 * @date January 12, 2011
	 * @description Initializes the workflow events table
	 * @param objTGUserEvent - array of user events json
	 */
	function initializeWorkflowEventTable(objTGUserEvent){
		try {
			var workflowEventTable = {
					url: contextPath+"/GIPIUserEventController?action=refreshUserEvents",
					options: {
						width: '650px',
						pager: {
						},
						toolbar: {
							elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
							onRefresh : function(){
								clearUserEventDetails();
							},
							onFilter : function(){
								clearUserEventDetails();
							}
						},					
						onCellFocus : function(element, value, x, y, id) {
							doEventCellFocus(element, y);					
						},
	/*					afterRender : function(){
							if(tbgUserEventDetail){					
								tbgUserEventDetail.clear();
							}
						},*/
						prePager: function(){
							
						},
						postPager: function(){
							clearUserEventDetails();
						},
						onRemoveRowFocus : function(element, value, x, y, id){
							objCurrEvent = null;		
							$("lblEventList").innerHTML = "Event List";
							setEventDetailButtons();
							if(tbgUserEventDetail){
								tbgUserEventDetail.url = contextPath+"/GIPIUserEventController?action=getGIPIUserEventDetailListing&refresh=1&eventCd";
								tbgUserEventDetail.clear();
								tbgUserEventDetail.empty();
							}
						},
						onSort : function(){
							clearUserEventDetails();
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
							id : "eventCd",
							title: "",
							width: '0',
							visible: false
						},
						{
							id : "eventDesc",
							title: "Event",
							type: "string",
							width: '460px',
							filterOption: true
						},
						{
							id : "eventType",
							title: "",
							width: '0',
							visible: false
						},
						{
							id : "multipleAssignSw",
							title: "",
							width: '0',
							visible: false
						},
						{
							id : "receiverTag",
							title: "",
							width: '0',
							visible: false
						},
						{	
							id : "tranCountDisplay",
							title: "Transaction Count",
							width: '150px',
							align: "left",
							type: "number"
						}
					],
					rows: objTGUserEvent.rows
				};
		
			tbgUserEvent = new MyTableGrid(workflowEventTable);
			tbgUserEvent.pager = objTGUserEvent;
			tbgUserEvent.render('userEventsTable');
		} catch(e){
			showErrorMessage("initializeWorkflowEventTable", e);
		}
	}
	
	initializeWorkflowEventTable(objTGUserEvent);
	
	$("btnCreate").observe("click", function(){
		objWorkflowForm.variables.createTag = "Y";
		showEventLOV();
	});
	
	showEventDetailListing(objCurrEvent);
	$("reloadForm").observe("click", function() {
		if (changeTag == 1){
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", showWorkflow, "");
		} else {
			showWorkflow();
		}
	});		
</script>