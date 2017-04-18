<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="gipis208MainDiv" name="gipis208MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div class="sectionDiv" id="gipis208HeaderDiv" style="padding-top: 8px; padding-bottom: 10px;">
		<fieldset style="width: 450px;height:62px; margin-left: 13px;float: left;" >	
			<legend>Search By</legend>	
			<div style="margin: 23px 0 0 20px">	
				<table border="0">
					<tr>
						<td>
							<input type="radio" id="rdoDateCreated" name="rdoSearchBy" tabindex="101" checked="checked"/>
						</td>
						<td>
							<label for="rdoDateCreated" style="width: 105px;">Date Created</label>
						</td>
						<td>
							<input type="radio" id="rdoDateAcknowledged" name="rdoSearchBy" tabindex="102" />
						</td>
						<td>
							<label for="rdoDateAcknowledged" style="width: 150px;">Date Acknowledged</label>
						</td>
						<td>
							<input type="radio" id="rdoAlarmDate" name="rdoSearchBy" tabindex="103" />
						</td>
						<td>
							<label for="rdoAlarmDate" style="width: 100px;">Alarm Date</label>
						</td>
					</tr>
				</table>
			</div>	
		</fieldset>
		<div style="float: right;margin: 6px 10px 0 0">	
			<fieldset style="width: 385px">				
				<div>				
					<table style="float: left;">
						<tr>
							<td class="rightAligned"><input type="radio" name="rdoSearchByDate" id="rdoAsOf" style="float: left;" tabindex="104" checked="checked"/><label for="rdoAsOf" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
							<td class="leftAligned">
								<div style="float: left; width: 140px;" class="withIconDiv" id="divAsOf">
									<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="105"/>
									<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" />
								</div>
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td class="rightAligned"><input type="radio" name="rdoSearchByDate" id="rdoFrom" style="float: left;" tabindex="106"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
							<td class="leftAligned">
								<div style="float: left; width: 140px;" class="withIconDiv" id="divFrom">
									<input type="text" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="107"/>
									<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" />
								</div>
							</td>
							<td class="rightAligned"><label style="float: right; height: 20px; padding-top: 3px; margin-right: 2px;">To</label></td>
							<td class="leftAligned">
								<div style="float: left; width: 140px;" class="withIconDiv" id="divTo">
									<input type="text" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="108"/>
									<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" />
								</div>
							</td>
						</tr>					
					</table>
				</div>
			</fieldset>		
		</div>		
	</div>
	<div class="sectionDiv" style="padding-bottom: 10px;">
		<div style="width: 600px; float: left; padding-left: 15px; padding-top: 10px;">
			<div id="reminderDiv">
				<div id=reminderTable style="height: 280px;"></div>
			</div>
		</div>		
		<div style="width: 180px; float: right; padding:10px 10px 0 0px;">
			<fieldset style="height: 263px">	
				<div style="margin-top: 5px">	
					<strong>Type</strong>			
					<table style="margin: 10px 0 15px 15px;">						
						<tr>
							<td><input type="radio" name="rdoType" id="rdoTypeAll" checked="checked" tabindex="109" /></td>
							<td><label for="rdoTypeAll" >All</label></td>
						</tr>
						<tr>
							<td><input type="radio" name="rdoType" id="rdoTypeReminder" tabindex="110"></td>
							<td><label for="rdoTypeReminder" >Reminder</label></td>
						</tr>
						<tr>
							<td><input type="radio" name="rdoType" id="rdoTypeNote" tabindex="111"/></td>
							<td><label for="rdoTypeNote" >Note</label></td>
						</tr>
					</table>
					<br/>
					<strong>Status</strong>	
					<table style="margin: 10px 0 15px 15px;">
						<tr>
							<td><input type="radio" name="rdoStatus" id="rdoStatusAll" checked="checked" tabindex="112"/></td>
							<td><label for="rdoStatusAll" >All</label></td>
						</tr>
						<tr>
							<td><input type="radio" name="rdoStatus" id="rdoStatusNew" tabindex="113"/></td>
							<td><label for="rdoStatusNew" >New</label></td>
						</tr>
						<tr>
							<td><input type="radio" name="rdoStatus" id="rdoStatusOk" tabindex="114"/></td>
							<td><label for="rdoStatusOk" >OK/Acknowledge</label></td>
						</tr>
					</table>	
				</div>				
			</fieldset>	
		</div>	
		<div style="padding:20px 10px 10px 13px; margin-top: 285px">		
			<fieldset style="height: 60px;padding-top: 10px ;padding-bottom: 10px">
				<div>
					<table border="0">
						<tbody>						
							<tr>
								<td class="rightAligned" style="width: 20%;">Alarm User / Date</td>
								<td class="leftAligned" style="width: 20%;" >
									<input id="txtAlarmUser" type="text" name="txtAlarmUser" style="width: 190px;" readonly="readonly"/>
								</td>
								<td class="rightAligned">/</td>
								<td class="leftAligned" style="width: 17%;" >
									<input id="txtAlarmDate" type="text" name="txtAlarmDate" style="width: 190px;" readonly="readonly"/>
								</td>
								<td class="rightAligned" style="width: 15%;">Ack. Date</td>
								<td class="leftAligned" style="width: 25%;" >
									<input id="txtAckDate" type="text" name="txtAckDate" style="width: 190px;" readonly="readonly"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 20%;">User ID</td>
								<td class="leftAligned" style="width: 20%;" colspan="3" >
									<input id="txtUserId" type="text" name="txtUserId" style="width: 190px;" readonly="readonly"/>
								</td>								
								<td class="rightAligned" style="width: 15%;">Last Update</td>
								<td class="leftAligned" style="width: 25%;" >
									<input id="txtLastUpdate" type="text" name="txtLastUpdate" style="width: 190px;" readonly="readonly"/>
								</td>
							</tr>						
						</tbody>
					</table>
				</div>
			</fieldset>
		</div>	
		<div style="text-align:center;margin:10px auto 50px auto">
			<input type="button" class="button" id="btnSummarizedInfo" name="btnSummarizedInfo" value="Summarized Information" tabindex="115"/>
		</div>				
	</div>		
</div>
<script>
try {
	setModuleId("GIPIS208");
	setDocumentTitle("Reminder Inquiry");
	initializeAll();
	initializeAccordion();
	var notesSelectedIndex;
	var objCurrReminder = null;
	var objGIPIS208 = {};
	objGIPIS208.reminderList = JSON.parse('${jsonReminderList}');
	reminderTable = {
			url : contextPath + "/GIPIReminderController?action=showGipis208&refresh=1&dateOpt="+'${dateOpt}'+"&dateAsOf="+'${dateAsOf}'+"&parId="+'${parId}',
			options : {
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						tbgReminder.keys.removeFocus(tbgReminder.keys._nCurrentFocus, true);
						tbgReminder.keys.releaseKeys();
						setFieldValues(null);
					}
				},
				width : '700px',
				height : '280px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgReminder.keys.removeFocus(tbgReminder.keys._nCurrentFocus, true);
					tbgReminder.keys.releaseKeys();			
					objCurrReminder = tbgReminder.geniisysRows[y];
					setFieldValues(objCurrReminder);
					
					var mtgId = tbgReminder._mtgId;
					notesSelectedIndex = -1;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						notesSelectedIndex = y;
					}
				},
				prePager : function() {
					tbgReminder.keys.removeFocus(tbgReminder.keys._nCurrentFocus, true);
					tbgReminder.keys.releaseKeys();	
					setFieldValues(null);
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgReminder.keys.removeFocus(tbgReminder.keys._nCurrentFocus, true);
					tbgReminder.keys.releaseKeys();	
					setFieldValues(null);
					notesSelectedIndex = -1;
				},
				afterRender : function() {;
					tbgReminder.keys.removeFocus(tbgReminder.keys._nCurrentFocus, true);
					tbgReminder.keys.releaseKeys();		
					setFieldValues(null);
				},
				onSort : function() {
					tbgReminder.keys.removeFocus(tbgReminder.keys._nCurrentFocus, true);
					tbgReminder.keys.releaseKeys();	
					setFieldValues(null);
				},onRowDoubleClick: function(y){
					var row = tbgReminder.geniisysRows[y];
					getPolicyEndtSeq0(row.policyId);
				},
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "noteSubject",
				title : "Subject",
				width : '300px',
				titleAlign : 'leftAligned',
				align : 'left',
				filterOption : true
			}, {
				id : "dspTypeStatus",
				title : "Type/Status",
				width : '180px',
				titleAlign : 'leftAligned',
				align : 'left',
				filterOption : true
				
			}, {
				id : "policyNo",
				title : "Policy No.",
				width : '180px',
				titleAlign : 'leftAligned',
				align : 'left',
				filterOption : true
			}
			],
			rows : objGIPIS208.reminderList.rows
	};
		
	tbgReminder = new MyTableGrid(reminderTable);
	tbgReminder.pager = objGIPIS208.reminderList;
	tbgReminder.render('reminderTable');
	
	function setFieldValues(rec){
		try{
			$("txtAlarmUser").value = (rec == null ? "" : unescapeHTML2(rec.alarmUser));
			$("txtAlarmDate").value = (rec == null ? "" : unescapeHTML2(rec.alarmDate));	
			$("txtAckDate").value = (rec == null ? "" : unescapeHTML2(rec.ackDate));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);		
			objCurrReminder = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
		
	function disableFromToFields(){
		$("txtAsOf").disabled = false;
		$("imgAsOf").disabled = false;
		$("txtFrom").disabled = true;
		$("txtTo").disabled = true;
		$("imgFrom").disabled = true;
		$("imgTo").disabled = true;
		$("txtFrom").value = "";
		$("txtTo").value = "";
		$("rdoAsOf").checked = true;
		$("txtAsOf").value = getCurrentDate();
		disableDate("imgFrom");
		disableDate("imgTo");
		enableDate("imgAsOf");
		$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
		$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
		$("divTo").setStyle({backgroundColor: '#F0F0F0'});
		$("txtAsOf").setStyle({backgroundColor: 'white'});
		$("divAsOf").setStyle({backgroundColor: 'white'});
	}
	
	function disableAsOfFields() {
		$("txtFrom").disabled = false;
		$("imgFrom").disabled = false;
		$("imgTo").disabled = false;
		$("txtTo").disabled = false;
		$("txtAsOf").disabled = true;
		$("imgAsOf").disabled = true;
		$("txtAsOf").value = "";
		$("rdoFrom").checked = true;
		disableDate("imgAsOf");
		enableDate("imgFrom");
		enableDate("imgTo");
		$("txtFrom").setStyle({backgroundColor: 'white'});
		$("divFrom").setStyle({backgroundColor: 'white'});
		$("txtTo").setStyle({backgroundColor: 'white'});
		$("divTo").setStyle({backgroundColor: 'white'});
		$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
		$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
	}
			
	function getDateOpt(){		
		var dateOpt = "&dateOpt=";
		if($("rdoDateCreated").checked){
			dateOpt = dateOpt + "dateCreated";			
		} else if ($("rdoDateAcknowledged").checked){
			dateOpt = dateOpt + "dateAcknowledged";
		} else {
			dateOpt = dateOpt + "alarmDate";			
		}
		return dateOpt;
	}
	
	function getDateParams(){
		var dateParams = "&dateAsOf=" + $("txtAsOf").value +
		 				 "&dateFrom=" + $("txtFrom").value +
						 "&dateTo=" + $("txtTo").value;
		return dateParams;
	}
	
	function getNoteType(){
		var noteType = "&noteType=";
		if($("rdoTypeReminder").checked){
			return noteType + "R";
		} else if($("rdoTypeNote").checked) {
			return noteType + "N";		
		} else {
			return noteType + "";
		}			
	}
	
	function getAlarmFlag(){
		var alarmFlag = "&alarmFlag=";
		if($("rdoStatusNew").checked){
			return alarmFlag + "N";
		} else if($("rdoStatusOk").checked) {
			return alarmFlag + "Y";		
		} else {
			return alarmFlag + "";
		}			
	}
	
	function printGIPIR208() {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var content = contextPath+"/PolicyInquiryPrintController?action=printGIPIR208"
			+"&noOfCopies="+$F("txtNoOfCopies")
			+"&printerName="+$F("selPrinter")
			+"&destination="+$F("selDestination")
			+"&reportId=GIPIR208"
			+"&fileType="+fileType
			+getDateOpt()
			+getDateParams()
			+getNoteType()
			+getAlarmFlag()
			+"&parId="+'${parId}';
			printGenericReport(content, "REMINDER SUMMARY PER POLICY",function(){
				if($F("selDestination") == "printer"){
					showWaitingMessageBox("Printing complete.", imgMessage.SUCCESS, function(){
						overlayGenericPrintDialog.close();
					});
				}
			});
		} catch (e) {
			showErrorMessage("printGIPIR208",e);
		}
	}
	
	function execute(){
		tbgReminder.url = contextPath + "/GIPIReminderController?action=showGipis208&refresh=1"+getDateOpt()+getDateParams()+getNoteType()+getAlarmFlag()+"&parId="+'${parId}';
		tbgReminder._refreshList();
	}	
		
	$("txtFrom").observe("focus", function(){
		if ($("imgFrom").disabled == true) return;
		var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";	
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFrom");
			$("txtFrom").clear();
			execute();
			return false;
		}
		if ((toDate != "") && (fromDate != "")){
			execute();
		}	
	});
	
	$("txtTo").observe("focus", function(){
		if ($("imgTo").disabled == true) return;
		var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
		var sysdate = new Date();		
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtTo");
			$("txtTo").clear();
			execute();
			return false;
		}		
		if ((toDate != "") && (fromDate != "")){
			execute();
		}	
	});
	
	$("txtAsOf").observe("focus", function(){	
		execute();
	});	
	
	$("imgAsOf").observe("click", function() {
		if ($("imgAsOf").disabled == true)
			return;
		scwShow($('txtAsOf'), this, null);
	});
	
	$("imgFrom").observe("click", function() {
		if ($("imgFrom").disabled == true)
			return;
		scwShow($('txtFrom'), this, null);
	});
	
	$("imgTo").observe("click", function() {
		if ($("imgTo").disabled == true)
			return;
		scwShow($('txtTo'), this, null);
	});
	
	$("rdoAsOf").observe("click", function(){
		disableFromToFields();
		execute();
	});

	$("rdoFrom").observe("click", function(){ 
		disableAsOfFields();
		execute();
	});					
	$("txtAsOf").value = getCurrentDate();
	
	$("rdoDateCreated").observe("click", function(){
		execute();
		
	});
	$("rdoDateAcknowledged").observe("click", function(){
		execute();
	});
	$("rdoAlarmDate").observe("click", function(){
		execute();		
	});
	
	$("rdoTypeAll").observe("click", function(){
		execute();
	});
	
	$("rdoTypeReminder").observe("click", function(){
		execute();
	});
	
	$("rdoTypeNote").observe("click", function(){
		execute();
	});
	
	$("rdoStatusAll").observe("click", function(){
		execute();
	});
	
	$("rdoStatusNew").observe("click", function(){
		execute();
	});
	
	$("rdoStatusOk").observe("click", function(){
		execute();

	});	

	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Reminder Summary Per Policy", printGIPIR208, null, true);
	});	
	$("btnToolbarExit").observe("click", showViewPolicyInformationPage);
	$("btnSummarizedInfo").observe("click", function () {		
		try{
			var row = tbgReminder.geniisysRows[notesSelectedIndex];
			getPolicyEndtSeq0(row.policyId);
		}catch(e){}
	});
	$("btnToolbarEnterQuery").hide();
	$("btnToolbarExecuteQuery").hide();
	$("btnToolbarEnterQuerySep").hide();
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
</script>
