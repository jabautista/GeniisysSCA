<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="reminderMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Mini - Reminder</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="lblShowReminder" name="gro" style="margin-left: 5px;">Hide</label>
	   			<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div id="containerDiv" style="margin-bottom: 100px; float: left;">		
		<div class="sectionDiv">
			<fieldset style="-moz-border-radius: 4px; margin: 10px 0 10px 160px; padding: 0; width: 600px;">				
				<legend style="margin-left: 10px;">Search By</legend>
				<table style="margin: 10px 0 10px 70px; padding: 0;">
					<tr>						
						<td colspan="6">
							<table style="margin: 0 0 10px 0; border-bottom: 1px solid lightgray; padding-left: 0;">
								<tr>
									<td style="padding-bottom: 5px; padding-left: 0;"><label><input type="radio" id="rdoDateCreated" name="rdoDate" value="0" style="margin: 0 5px 0 5px;">Date Created</label></td>
									<td style="padding-bottom: 5px; margin-left: 15px; margin-right: 225px; float: left;"><label><input type="radio" id="rdoAlarmDate" name="rdoDate" value="0" style="margin: 0 5px 0 5px;">Alarm Date</label></td>
								</tr>
							</table>
						</td>								
					</tr>
					<tr>												
						<td><label><input type="radio" id="rdoAsOf" name="rdoRange" value="0" style="margin: 0 5px 0 7px;">As of</label></td>
						<td class="leftAligned">
							<div id="asOfDateDiv" name="asOfDateDiv" style="float:right; border: solid 1px gray; width: 160px; height: 20px; margin-right:3px;">
						    	<input style="width: 132px; border: none; height: 11px; margin: 0;" id="txtAsOfDate" name="txtAsOfDate" type="text" value="" readonly="readonly" />
						    	<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"	alt="Date Sent" onClick="scwShow($('txtAsOfDate'),this, null);" class="hover"/>				    			    
							</div>
						</td>			
						<td><img id="queryByAsOfDate" title="Query" style="margin-bottom: 3px;" alt="Go" name="queryByAsOfDate" src="/Geniisys/images/misc/searchIcon.png"></td>
						<td colspan="3"></td>		
					</tr>
					<tr>					
						<td><label><input type="radio" id="rdoDateRange" name="rdoRange" style="margin: 0 5px 0 7px;">From</label></td>
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
			<div id="reminderTableDiv" style="padding: 10px 0 10px 20px;">
				<div id="reminderTable" style="width: 670px; height: 280px"></div>
			</div>
			<div style="margin: 0 0 10px 0;">
				<input type="button" class="button" id="btnCreate" value="View Policy Claim Information">
			</div>						
		</div>		
	</div>	
</div>
<script type="text/javascript">
	releaseWorkflowTableGridKeys();
	var dateMode = null;
	/**
	 * dateMode : 0 - Date Created
	 * 		  	  1 - Alarm Date
	 */
	var rangeMode = null;
	/**
	 * rangeMode : 0 - As of
	 * 		  	   1 - From To
	 */
		
	function toggleRadioButton(){
		if(parseInt(rangeMode) == 0){
			$("asOfDateDiv").style.backgroundColor = "";
			$("txtAsOfDate").value = dateFormat(new Date(), "mm-dd-yyyy");
			$("txtAsOfDate").show();
			$("hrefAsOfDate").show();
			
			$("byDateFromDiv").style.backgroundColor = "lightgray";
			$("txtFrom").value = "";
			$("txtFrom").hide();
			$("hrefByDateFrom").hide();
			
			$("byDateToDiv").style.backgroundColor = "lightgray";
			$("txtTo").value = "";
			$("txtTo").hide();
			$("hrefByDateTo").hide();
			
			$("queryByAsOfDate").show();			
			$("queryByDateRange").hide();
			
			$("txtAsOfDate").focus();
		} else {
			$("byDateFromDiv").style.backgroundColor = "";
			$("txtFrom").value = "";
			$("txtFrom").show();
			$("hrefByDateFrom").show();
			
			$("byDateToDiv").style.backgroundColor = "";
			$("txtTo").value = "";
			$("txtTo").show();
			$("hrefByDateTo").show();
			
			$("asOfDateDiv").style.backgroundColor = "lightgray";
			$("txtAsOfDate").value = "";
			$("txtAsOfDate").hide();
			$("hrefAsOfDate").hide();
			
			$("queryByAsOfDate").hide();
			$("queryByDateRange").show();
			
			$("txtFrom").focus();
		} 

		tbgReminder.clear();
		tbgReminder.empty();
	}

	function getRemindersByAsOfDate(){
		if($F("txtAsOfDate") == ""){
			showMessageBox("As of Date should not be null.", imgMessage.ERROR);
		} else {
			tbgReminder.url = contextPath+"/GIPIReminderController?action=getGIPIReminderListing&refresh=1&date="+$F("txtAsOfDate")+"&dateMode="+dateMode+"&rangeMode="+rangeMode;
			tbgReminder._refreshList();
		}
	}

	function getEventsByDateRange(){
		if($F("txtFrom").trim() == "" || $F("txtTo").trim() == ""){
			showMessageBox("From Date/To Date should not be null.", imgMessage.ERROR);
		} else {
			tbgReminder.url = contextPath+"/GIPIReminderController?action=getGIPIReminderListing&refresh=1&dateFrom="+$F("txtFrom")+"&dateTo="+$F("txtTo")+"&dateMode="+dateMode+"&rangeMode="+rangeMode;
			tbgReminder._refreshList();	
		}
	}
	
	$("rdoDateCreated").observe("click", function(){
		dateMode = 0;
	});

	$("rdoAlarmDate").observe("click", function(){
		dateMode = 1;
	});
	
	$("rdoAsOf").observe("click", function(){
		rangeMode = 0;
		toggleRadioButton();
	});

	$("rdoDateRange").observe("click", function(){
		rangeMode = 1;
		toggleRadioButton();
	});
	
	$("queryByAsOfDate").observe("click", function(){
		getRemindersByAsOfDate();
	});	
	
	$("queryByDateRange").observe("click", function(){
		getEventsByDateRange();
	});	
	
	$("rdoDateCreated").checked = true;
	fireEvent($("rdoDateCreated"), "click");
	$("rdoAsOf").checked = true;
	fireEvent($("rdoAsOf"), "click");
	
	function initializeReminderTable(reminderListing){
		try {
			var reminderTable = {
					options: {
						width: '880px',
						querySort: false,
						pager: {
							
						},
						toolbar: {
							elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
						}
					},
					columnModel: [
						{
							id : "ok",
							title: "Ok ?",
							width: '50px',
							align: "center",
							sortable: false,
							editor: new MyTableGrid.CellCheckbox({
								onClick: function(value, checked) {
									if (checked){
								   		showConfirmBox4("Confirmation", "Acknowledge reminder?", "Yes", "No", "Cancel", "", "", "");
									}
								}
							})
											
						},
						{	
							id : "noteSubject",
							title: "Subject",
							width: '450px'
						},
						{
							id : "userId",
							title: "User Created",
							width: "100px"
						},
						{
							id : "createDate",
							title: "Date Created",
							width: "120px"
						},
						{
							id : "alarmDate",
							title: "Alarm Date",
							width: "120px"
						}
					],
					rows: reminderListing.rows
				};

			tbgReminder = new MyTableGrid(reminderTable);
			tbgReminder.pager = reminderListing;
			tbgReminder.render('reminderTable');
		} catch (e) {
			showErrorMessage("initializeReminderTable", e);
		}
	}
	
	var reminderListing = JSON.parse('${reminderListing}'.replace(/\\/g, "\\\\"));	
	initializeReminderTable(reminderListing);	
	initializeAccordion();
	
	$("reloadForm").observe("click", function() {
		showReminder();
	});
</script>
