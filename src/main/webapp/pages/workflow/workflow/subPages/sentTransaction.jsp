<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="sentTransactionsMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Sent Transactions</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="lblShowSentTransactions" name="gro" style="margin-left: 5px;">Hide</label>
	   			<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div id="containerDiv" style="margin-bottom: 100px; float: left;">		
		<div class="sectionDiv">
			<fieldset style="-moz-border-radius: 4px; margin: 10px 0 10px 138px; padding: 0; width: 650px;">
				<legend style="margin-left: 10px;">Search By</legend>
				<table style="margin: 10px 0 10px 50px;">
					<tr>
						<td><label><input type="radio" id="rdoDateSent" name="rdoDate" value="0" style="margin: 0 5px 0 5px;">Date Sent</label></td>
						<td class="leftAligned" colspan="2">
							<div id="dateSentDiv" name="dateSentDiv" style="float:right; border: solid 1px gray; width: 160px; height: 20px; margin-right:3px;">
						    	<input style="width: 132px; border: none; height: 11px; margin: 0;" id="txtDateSent" name="txtDateSent" type="text" value="" readonly="readonly" />
						    	<img id="hrefDateSent" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="Date Sent" onClick="scwShow($('txtDateSent'),this, null);" class="hover"/>				    			    
							</div>
						</td>			
						<td><img id="queryByDateSent" title="Query" style="margin-bottom: 3px;" alt="Go" name="queryByDateSent" src="/Geniisys/images/misc/searchIcon.png"></td>		
					</tr>
					<tr>					
						<td><label><input type="radio" id="rdoByDate" name="rdoDate" value="1" style="margin: 0 5px 0 5px;">By Date</label></td>
						<td class="rightAligned" width="50px">From</td>
						<td class="leftAligned">
							<div id="byDateFromDiv" name="byDateFromDiv" style="float:left; border: solid 1px gray; width: 160px; height: 20px; margin-right:3px;">
						    	<input style="width: 132px; border: none; height: 11px; margin: 0;" id="txtFrom" name="txtFrom" type="text" value="" readonly="readonly" />
						    	<img id="hrefByDateFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="From" onClick="scwShow($('txtFrom'),this, null);" class="hover"/>				    			    
							</div>
						</td>
						<td width="20px"></td>
						<td class="rightAligned" width="8px">To</td>
						<td class="leftAligned">
							<div id="byDateToDiv" name="dateDueDiv" style="float:left; border: solid 1px gray; width: 160px; height: 20px; margin-right:3px;">
						    	<input style="width: 132px; border: none; height: 11px; margin: 0;" id="txtTo" name="txtTo" type="text" value="" readonly="readonly" />
						    	<img id="hrefByDateTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="Date Due" onClick="scwShow($('txtTo'),this, null);" class="hover"/>				    			    
							</div>
						</td>
						<td width="20px"><img id="queryByDateRange" title="Query" style="margin-bottom: 3px;" alt="Go" name="queryByDateRange" src="/Geniisys/images/misc/searchIcon.png"></td>
					</tr>
				</table>
			</fieldset>								
		</div>
		<div class="sectionDiv">
			<div id="userEventsTableDiv" style="padding: 10px 0 10px 20px; margin-left: 120px;">
				<div id="userEventsTable" style="width: 670px; height: 250px"></div>
			</div>						
		</div>
		<div id="sentTransactionsDiv" class="sectionDiv">
			<div id="sentTransactionTableDiv" style="padding: 10px 0 10px 20px; float: left;">
				<div id="sentTransactionTable" style="width: 900px; height: 300px"></div>
			</div>
		</div>
	</div>	
</div>
<script type="text/javascript">
	releaseWorkflowTableGridKeys();
	var mode = null;
	objCurrEventDtl = {};
	/**
	 * mode : 0 - Query By Date Sent
	 * 		  1 - Query By Date Range
	 */
	function toggleRadioButton(){
		if(parseInt(mode) == 0){
			$("dateSentDiv").style.backgroundColor = "";
			$("txtDateSent").value = dateFormat(new Date(), "mm-dd-yyyy");
			$("txtDateSent").show();
			$("hrefDateSent").show();
			
			$("byDateFromDiv").style.backgroundColor = "lightgray";
			$("txtFrom").value = "";
			$("txtFrom").hide();
			$("hrefByDateFrom").hide();
			
			$("byDateToDiv").style.backgroundColor = "lightgray";
			$("txtTo").value = "";
			$("txtTo").hide();
			$("hrefByDateTo").hide();
			
			$("queryByDateSent").show();			
			$("queryByDateRange").hide();
			
			$("txtDateSent").focus();
		} else {
			$("byDateFromDiv").style.backgroundColor = "";
			$("txtFrom").value = "";
			$("txtFrom").show();
			$("hrefByDateFrom").show();
			
			$("byDateToDiv").style.backgroundColor = "";
			$("txtTo").value = "";
			$("txtTo").show();
			$("hrefByDateTo").show();
			
			$("dateSentDiv").style.backgroundColor = "lightgray";
			$("txtDateSent").value = "";
			$("txtDateSent").hide();
			$("hrefDateSent").hide();
			
			$("queryByDateSent").hide();
			$("queryByDateRange").show();
			
			$("txtFrom").focus();
		}
		tbgUserEvent.clear();
		tbgUserEvent.empty();
		tbgUserEventHistDetail.clear();
		tbgUserEventHistDetail.empty();		
	}

	function getEventsByDateSent(){
		if($F("txtDateSent") == ""){
			showMessageBox("As of Date should not be null.", imgMessage.ERROR);
		} else {
			tbgUserEvent.url = contextPath+"/GIPIUserEventController?action=getEventsByDateSent&refresh=1&date="+$F("txtDateSent");
			tbgUserEvent._refreshList();
			tbgUserEventHistDetail.clear();
			tbgUserEventHistDetail.empty();		
		}
	}

	function getEventsByDateRange(){
		if($F("txtFrom").trim() == "" || $F("txtTo").trim() == ""){
			showMessageBox("From Date/To Date should not be null.", imgMessage.ERROR);
		} else {
			tbgUserEvent.url = contextPath+"/GIPIUserEventController?action=getEventsByDateRange&dateFrom="+$F("txtFrom")+"&dateTo="+$F("txtTo");
			tbgUserEvent._refreshList();	
			tbgUserEventHistDetail.clear();
			tbgUserEventHistDetail.empty();
		}
	}
	
	$("rdoDateSent").observe("click", function(){
		mode = 0;
		toggleRadioButton();
	});

	$("rdoByDate").observe("click", function(){
		mode = 1;
		toggleRadioButton();
	});
	
	$("queryByDateSent").observe("click", function(){
		getEventsByDateSent();
	});	
	
	$("queryByDateRange").observe("click", function(){
		getEventsByDateRange();
	});	
	
	$("rdoDateSent").checked = true;
	fireEvent($("rdoDateSent"), "click");
		
	var objTGUserEvent = JSON.parse('${eventListTableGrid}'.replace(/\\/g, "\\\\"));
	var workflowEventTable = null;
	function initializeWorkflowEventTable(objTGUserEvent){
		try {
			workflowEventTable = {
					options: {
						width: '650px',
						pager: {
						},
						toolbar: {
							elements: [MyTableGrid.FILTER_BTN]
						},					
						onCellFocus : function(element, value, x, y, id) {
							var mtgId = tbgUserEvent._mtgId;							
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
								var rowEvent = tbgUserEvent.geniisysRows[y];
								var eventCd = rowEvent.eventCd;
								if(mode == 0){
									tbgUserEventHistDetail.url = contextPath+"/GIPIUserEventHistController?action=getEventHistByDateSent&date="+$F("txtDateSent")+"&eventCd="+eventCd;
								} else {
									tbgUserEventHistDetail.url = contextPath+"/GIPIUserEventHistController?action=getEventHistByDateRange&dateFrom="+$F("txtFrom")+"&dateTo="+$F("txtTo")+"&eventCd="+eventCd;
								}
								tbgUserEventHistDetail._refreshList();
							}
						},
						prePager: function(){
							
						},
						onRemoveRowFocus : function(element, value, x, y, id){						
							
						},
						afterRender : function (){
							//fireEvent($('mtgIC'+tbgUserEvent._mtgId+'_3,0'), "click");
						},
						onSort : function(){
							tbgUserEventHistDetail.clear();
							tbgUserEventHistDetail.empty();
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
							width: '620px',
							filterOption: true
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
	
	var objTGUserEventHistDetail = {};
	var userEventHistDetailTable = {
			options: {
				title: '',
				width: '885px',
				pager: {
				},
				toolbar: {
					elements: [MyTableGrid.HISTORY_BTN, MyTableGrid.FILTER_BTN],
					onHistory: function(){
						if(objCurrEventDtl != null){
							showHistory(objCurrEventDtl.tranId);
						} else {
							showMessageBox("Please select a record first.", imgMessage.INFO);
						}						
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgUserEventHistDetail._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						objCurrEventDtl = tbgUserEventHistDetail.geniisysRows[y];
						objCurrEventDtl.rowIndex = y;
					}
				},
				onRemoveRowFocus : function(element, value, x, y, id){	
					objCurrEventDtl = null;
				},
				beforeRefresh : function(){
					
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
					id : "tranDtl",
					title: "Transaction Details",
					type: "string",
					width: '250px'
				},				
				{	
					id : "newUserId",
					title: "Recipient",
					width: '120px',
					filterOption: true
				},
				{	
					id : "dateReceived",
					title: "Date Sent",
					width: '140px',
					filterOption: true
				},				
				{	
					id : "remarks",
					title: "Remarks",
					width: '250px',
					filterOption: true								
				},
				{	
					id : "tranId",
					title: "Tran ID",
					width: '80px',
					type: 'number',
					filterOption: true
				}
			],
			rows: []//objTGUserEventDetail.rows
		};
	
	tbgUserEventHistDetail = new MyTableGrid(userEventHistDetailTable);
	tbgUserEventHistDetail.pager = objTGUserEventHistDetail;
	tbgUserEventHistDetail.render('sentTransactionTable');
	
	initializeWorkflowEventTable(objTGUserEvent);
	initializeAccordion();
	
	$("reloadForm").observe("click", function() {
		showSentTransactions();
	});
</script>
