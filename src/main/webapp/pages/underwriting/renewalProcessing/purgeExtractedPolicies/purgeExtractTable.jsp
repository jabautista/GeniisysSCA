<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="purgeExtractTableMainDiv" name="purgeExtractTableMainDiv" style="margin-top: 1px; display: none;">
	<div id="purgeExtractTableMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit" name="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Purge Extract Table</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="groDiv" name="groDiv">
		<div id="purgeExtractTableSectionDiv" name="purgeExtractTableSectionDiv" class="sectionDiv" style="height: 430px; padding: 5px 15px 15px 15px; width: 891px; margin-bottom: 18px;">
			<div id="purgeExtractTableGridMain" name="purgeExtractTableGridMain" style="padding: 10px 0 10px 20px; margin-left: 120px;">
				<div id="purgeExtractTableGridDiv" name="purgeExtractTableGridDiv" style="width: 670px; height: 340px;"></div>
			</div>
			<div id="controlDiv" name="controlDiv" style="height: 70px; width: 500px; float: left; margin-left: 105px;" align="right">
				<table align="right">
					<tr>
						<td width="125px;"><input type="button" class="button" style="width: 120px;" id="btnCancel" name="btnCancel" value="Cancel"></td>
						<td><input type="checkbox" id="allExpiredProcessed" name="allExpiredProcessed"></td>
						<td width="175px;"><label for="allExpiredProcessed">All Expired and Processed</label></td>
						<td><input type="checkbox" id="basedOnParam" name="basedOnParam" disabled="disabled"></td>
						<td><label for="basedOnParam">Based On Parameter</label></td>
					</tr>	
					<tr>
						<td><input type="button" class="button" style="width: 120px;" id="btnPurge" name="btnPurge" value="Purge"></td>
						<td><input type="checkbox" id="allUnprocessed" name="allUnprocessed"></td>
						<td><label for="allUnprocessed">All Unprocessed</label></td>
						<td colspan="2"><input type="button" class="button" style="width: 100%;" id="btnBasedOnParam" name="btnBasedOnParam" value="Parameter"></td>
					</tr>
				</table>
			</div>
			<div id="legendDiv" name="legendDiv" class="sectionDiv" style="width: 145px; height: 70px; float: left; margin-left: 20px;">
				<table>
					<tr>
						<td><label style="padding-top: 2px; padding-left: 3px; font-weight: bold;">Legend:</label>
					</tr>
					<tr style="height: 5px;"></tr>
					<tr>
						<td><label style="padding-left: 15px;">X - Expired Policy</label></td>
					</tr>
					<tr>
						<td><label style="padding-left: 15px;">P - Processed Policy</label></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	
	<div id="hiddenParamsDiv" name="hiddenParamsDiv">
		<input type="hidden" id="notTime" name="notTime">
		<input type="hidden" id="rangeType" name="rangeType">
		<input type="hidden" id="range" name="range">
		<input type="hidden" id="rangeParam" name="rangeParam" value="exactMonth">
		<input type="hidden" id="fromMonthParam" name="fromMonthParam">
		<input type="hidden" id="fromYearParam" name="fromYearParam">
		<input type="hidden" id="toMonthParam" name="toMonthParam">
		<input type="hidden" id="toYearParam" name="toYearParam">
		<input type="hidden" id="fromDateParam" name="fromDateParam">
		<input type="hidden" id="toDateParam" name="toDateParam">
		<input type="hidden" id="lineCdParam" name="lineCdParam">
		<input type="hidden" id="sublineCdParam" name="sublineCdParam">
		<input type="hidden" id="issCdParam" name="issCdParam">
		<input type="hidden" id="issueYyParam" name="issueYyParam">
		<input type="hidden" id="polSeqNoParam" name="polSeqNoParam">
		<input type="hidden" id="renewNoParam" name="renewNoParam">
		<input type="hidden" id="intmNoParam" name="intmNoParam">
		<input type="hidden" id="lineNameParam" name="lineNameParam">
		<input type="hidden" id="sublineNameParam" name="sublineNameParam">
		<input type="hidden" id="issNameParam" name="issNameParam">
		<input type="hidden" id="intmNameParam" name="intmNameParam">
		<input type="hidden" id="individualParam" name="individualParam">
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	setDocumentTitle("Purge Extract Table");
	setModuleId("GIEXS003");
	var selectedIndex = -1;
	var arrGIEXS003Buttons = [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN];
	
	var cntProc;
	var cntProcAll;
	var cntUnproc;
	
	var objPurgeExtract = new Object();
	objPurgeExtract.objPurgeExtractTableGrid = JSON.parse('${giexPurgeExtractTableGrid}');
	objPurgeExtract.objPurgeExtractRows = objPurgeExtract.objPurgeExtractTableGrid.rows || [];
	try{
		var purgeExtractTableModel = {
			url: contextPath+"/GIEXExpiriesVController?action=getPurgeExtractTable&refresh=1",
			options: {
				title: '',
              	height: '306px',
	          	width: '620px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = purgeExtractTableGrid._mtgId;
                	selectedIndex = -1;
                	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
                		selectedIndex = y;
                	}
                	purgeExtractTableGrid.keys.removeFocus(purgeExtractTableGrid.keys._nCurrentFocus, true); // andrew - 02.08.2013 - to release keys
                	purgeExtractTableGrid.keys.releaseKeys();
                },
                onRemoveRowFocus: function(){
                	purgeExtractTableGrid.keys.removeFocus(purgeExtractTableGrid.keys._nCurrentFocus, true);
                	purgeExtractTableGrid.keys.releaseKeys();
                	selectedIndex = -1;
                },
                toolbar: {
                	elements: (arrGIEXS003Buttons)
                }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'lineCd',
							title: 'Line Code',
			            	width: '0px',
			            	visible: false,
			            	filterOption: false
						},
						{	id: 'sublineCd',
							title: 'Subline Code',
			            	width: '0px',
			            	visible: false,
			            	filterOption: false
						},
						{	id: 'issCd',
							title: 'Issue Code',
			            	width: '0px',
			            	visible: false,
			            	filterOption: false
						},
						{	id: 'issueYy',
							title: 'Issue Year',
			            	width: '0px',
			            	visible: false,
			            	filterOption: false,
			            	filterOptionType: 'integerNoNegative'
						},
						{	id: 'polSeqNo',
							title: 'PolSeqNo',
			            	width: '0px',
			            	visible: false,
			            	filterOption: false,
			            	filterOptionType: 'integerNoNegative'
						},
						{	id: 'renewNo',
							title: 'Renew No.',
			            	width: '0px',
			            	visible: false,
			            	filterOption: false,
			            	filterOptionType: 'integerNoNegative'
						},
						{	id: 'policyNo',
							title: 'Policy Number',
			            	width: '200px',
			            	titleAlign: 'center',
			            	filterOption: true
						},
						{	id: 'tsiAmt',
							title: 'Ren TSI Amount',
			            	width: '125px',
			            	titleAlign: 'right',
			            	align: 'right',
			            	geniisysClass: 'money',
			            	filterOption: true,
			            	filterOptionType: 'number'
						},
						{	id: 'premAmt',
							title: 'Ren Prem Amount',
			            	width: '125px',
			            	titleAlign: 'right',
			            	align: 'right',
			            	geniisysClass: 'money',
			            	filterOption: true,
			            	filterOptionType: 'number'
						},
						{	id: 'expiryDate',
							title: 'Expiry Date',
			            	width: '94px',
			            	titleAlign: 'center',
			            	align: 'center',
			            	type: 'date',
							format: 'mm-dd-yyyy',
							filterOption: true,
							filterOptionType: 'formattedDate'
						},
						{	id: 'postFlag',
							title: 'P',
			            	width: '23px',
			            	altTitle: 'Processed Policy',
			            	titleAlign: 'center',
			            	sortable: false,
			            	editable: false,
			            	editor: 'checkbox'
						},
						{	id: 'expiryFlag',
							title: 'X',
			            	width: '23px',
			            	altTitle: 'Expired Policy',
			            	titleAlign: 'center',
			            	sortable: false,
			            	editable: false,
			            	editor: 'checkbox'
						},
  					],
  				rows: objPurgeExtract.objPurgeExtractRows
		};
		purgeExtractTableGrid = new MyTableGrid(purgeExtractTableModel);
		purgeExtractTableGrid.pager = objPurgeExtract.objPurgeExtractTableGrid;
		purgeExtractTableGrid.render('purgeExtractTableGridDiv');
	}catch(e){
		showMessageBox("Error in Purge Extract Table: " + e, imgMessage.ERROR);
	}
	
	$("btnExit").observe("click", function(){
		purgeExtractTableGrid.keys.removeFocus(purgeExtractTableGrid.keys._nCurrentFocus, true);
    	purgeExtractTableGrid.keys.releaseKeys();
    	if(objUWGlobal.module == "GIEXS004"){	//Kenneth L. 10.21.2013
    		showProcessExpiringPoliciesPage();
    	}else{
    		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
    	}
	});
	
	$("btnBasedOnParam").observe("click", function(){
		purgeExtractTableGrid.keys.removeFocus(purgeExtractTableGrid.keys._nCurrentFocus, true);
    	purgeExtractTableGrid.keys.releaseKeys();
		purgeExTableParams = Overlay.show(contextPath+"/GIEXExpiriesVController", {
			urlContent : true,
			draggable: true,
			urlParameters: {action: "showPurgeExTableParams",
							lineCd      : $("lineCdParam").value,
							sublineCd   : $("sublineCdParam").value,
							issCd       : $("issCdParam").value,
							intmNo      : $("intmNoParam").value,
							lineName	: $("lineNameParam").value,
							sublineName : $("sublineNameParam").value,
							issName		: $("issNameParam").value,
							intmName	: $("intmNameParam").value,
							fromMonth	: $("fromMonthParam").value,
							fromYear	: $("fromYearParam").value,
							fromDate	: $("fromDateParam").value,
							toMonth		: $("toMonthParam").value,
							toYear		: $("toYearParam").value,
							toDate		: $("toDateParam").value,
							range		: $("rangeParam").value
			},
		    title: "Purge Parameters",
		    height: 303,
		    width: 610
		});
	});
	
	$("btnCancel").observe("click", function(){
		purgeExtractTableGrid.keys.removeFocus(purgeExtractTableGrid.keys._nCurrentFocus, true);
    	purgeExtractTableGrid.keys.releaseKeys();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	$("btnPurge").observe("click", function(){
		if($("allExpiredProcessed").checked == false && $("allUnprocessed").checked == false){
			showMessageBox('Please choose data to purge, "All Unprocessed", or "All Expired and Processed"', imgMessage.INFO);
		}else{
			checkNoOfRecordsToPurge();
		}
	});
	
	function continuePurge(){
		if($("basedOnParam").checked){
			if($("notTime").value == "notTime"){
				purgeBasedNotTime();
			}else{
				if($("rangeType").value == "onOrBefore"){
					if($("range").value == "byMonthYear"){
						purgeBasedOnBeforeMonth();
					}else{
						purgeBasedOnBeforeDate();
					}
				}else{
					if($("range").value == "byMonthYear"){
						purgeBasedExactMonth();
					}else{
						purgeBasedExactDate();
					}
				}
			}
		}else{
			purgeBasedNotParam();
		}
	}
	
	function checkNoOfRecordsToPurge(){
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?action=checkNoOfRecordsToPurge",{
			parameters : {
				basedOnParam : $("basedOnParam").checked ? "Y" : "N",
				allExpProc	 : $("allExpiredProcessed").checked ? "Y" : "N",
				allUnproc	 : $("allUnprocessed").checked ? "Y" : "N",
				lineCd	  	 : $("lineCdParam").value,
				sublineCd 	 : $("sublineCdParam").value,
				issCd	  	 : $("issCdParam").value,
				issueYy   	 : $("issueYyParam").value,
				polSeqNo  	 : $("polSeqNoParam").value,
				renewNo   	 : $("renewNoParam").value,
				intmNo    	 : $("intmNoParam").value,
				fromMonth 	 : $("fromMonthParam").value,
				fromYear  	 : $("fromYearParam").value,
				toMonth 	 : $("toMonthParam").value,
				toYear  	 : $("toYearParam").value,
				fromDate 	 : $("fromDateParam").value,
				toDate  	 : $("toDateParam").value,
				rangeType 	 : $("rangeType").value,
				range 		 : $("range").value
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					cntProc = obj.cntProc;
					cntUnproc = obj.cntUnproc;
					cntProcAll = obj.cntProcAll;
					if(cntProc == 0 && cntUnproc == 0 && cntProcAll == 0){
						showMessageBox("No records found to purge.");
					}else{
						showConfirmBox("", "A total of " + cntUnproc + " unprocessed policy(s) " + cntProcAll + " processed policy(s) and " +
								cntProc + " processed/expired policy(s) will be purged. Do you want to continue?", "Ok", "Cancel", continuePurge, "", "");
					}
				}
			}
		});
	}
	
	function purgeBasedNotParam(){
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?action=purgeBasedNotParam",{
			method : "GET",
			parameters : {
				allExpProc	 : $("allExpiredProcessed").checked ? "Y" : "N",
				allUnproc	 : $("allUnprocessed").checked ? "Y" : "N"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				showMessageBox("Finished purging " + cntUnproc + " unprocessed and " + cntProc + " processed/expired records.", imgMessage.INFO);
				purgeExtractTableGrid._refreshList();
				$("basedOnParam").checked = false;
			}
		});
	}
	
	function purgeBasedNotTime(){
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?action=purge&purgeRange=basedNotTime",{
			method : "GET",
			parameters : {
				allExpProc	 : $("allExpiredProcessed").checked ? "Y" : "N",
				allUnproc	 : $("allUnprocessed").checked ? "Y" : "N",
				lineCd	  : $("lineCdParam").value,
				sublineCd : $("sublineCdParam").value,
				issCd	  : $("issCdParam").value,
				issueYy   : $("issueYyParam").value,
				polSeqNo  : $("polSeqNoParam").value,
				renewNo   : $("renewNoParam").value,
				intmNo    : $("intmNoParam").value
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				showMessageBox("Finished purging " + cntUnproc + " unprocessed and " + cntProc + " processed/expired records.", imgMessage.INFO);
				purgeExtractTableGrid.url = contextPath+"/GIEXExpiriesVController?action=getPurgeExtractTable&refresh=1",
				purgeExtractTableGrid._refreshList();
				$("basedOnParam").checked = false;
			}
		});
	}
	
	function purgeBasedOnBeforeMonth(){
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?action=purge&purgeRange=basedOnBeforeMonth",{
			method : "GET",
			parameters : {
				allExpProc	 : $("allExpiredProcessed").checked ? "Y" : "N",
				allUnproc	 : $("allUnprocessed").checked ? "Y" : "N",
				lineCd	  : $("lineCdParam").value,
				sublineCd : $("sublineCdParam").value,
				issCd	  : $("issCdParam").value,
				issueYy   : $("issueYyParam").value,
				polSeqNo  : $("polSeqNoParam").value,
				renewNo   : $("renewNoParam").value,
				intmNo    : $("intmNoParam").value,
				fromMonth : $("fromMonthParam").value,
				fromYear  :	$("fromYearParam").value
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				showMessageBox("Finished purging " + cntUnproc + " unprocessed and " + cntProc + " processed/expired records.", imgMessage.INFO);
				purgeExtractTableGrid.url = contextPath+"/GIEXExpiriesVController?action=getPurgeExtractTable&refresh=1",
				purgeExtractTableGrid._refreshList();
				$("basedOnParam").checked = false;
			}
		});
	}
	
	function purgeBasedOnBeforeDate(){
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?action=purge&purgeRange=basedOnBeforeDate",{
			method : "GET",
			parameters : {
				allExpProc	 : $("allExpiredProcessed").checked ? "Y" : "N",
				allUnproc	 : $("allUnprocessed").checked ? "Y" : "N",
				lineCd	  : $("lineCdParam").value,
				sublineCd : $("sublineCdParam").value,
				issCd	  : $("issCdParam").value,
				issueYy   : $("issueYyParam").value,
				polSeqNo  : $("polSeqNoParam").value,
				renewNo   : $("renewNoParam").value,
				intmNo    : $("intmNoParam").value,
				fromDate  : $("fromDateParam").value
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				showMessageBox("Finished purging " + cntUnproc + " unprocessed and " + cntProc + " processed/expired records.", imgMessage.INFO);
				purgeExtractTableGrid.url = contextPath+"/GIEXExpiriesVController?action=getPurgeExtractTable&refresh=1",
				purgeExtractTableGrid._refreshList();
				$("basedOnParam").checked = false;
			}
		});
	}
	
	function purgeBasedExactMonth(){
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?action=purge&purgeRange=basedExactMonth",{
			method : "GET",
			parameters : {
				allExpProc	 : $("allExpiredProcessed").checked ? "Y" : "N",
				allUnproc	 : $("allUnprocessed").checked ? "Y" : "N",
				lineCd	  : $("lineCdParam").value,
				sublineCd : $("sublineCdParam").value,
				issCd	  : $("issCdParam").value,
				issueYy   : $("issueYyParam").value,
				polSeqNo  : $("polSeqNoParam").value,
				renewNo   : $("renewNoParam").value,
				intmNo    : $("intmNoParam").value,
				fromMonth : $("fromMonthParam").value,
				fromYear  :	$("fromYearParam").value,
				toMonth	  : $("toMonthParam").value,
				toYear    : $("toYearParam").value
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				showMessageBox("Finished purging " + cntUnproc + " unprocessed and " + cntProc + " processed/expired records.", imgMessage.INFO);
				purgeExtractTableGrid.url = contextPath+"/GIEXExpiriesVController?action=getPurgeExtractTable&refresh=1",
				purgeExtractTableGrid._refreshList();
				$("basedOnParam").checked = false;
			}
		});
	}
	
	function purgeBasedExactDate(){
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?action=purge&purgeRange=basedExactDate",{
			method : "GET",
			parameters : {
				allExpProc	 : $("allExpiredProcessed").checked ? "Y" : "N",
				allUnproc	 : $("allUnprocessed").checked ? "Y" : "N",
				lineCd	  : $("lineCdParam").value,
				sublineCd : $("sublineCdParam").value,
				issCd	  : $("issCdParam").value,
				issueYy   : $("issueYyParam").value,
				polSeqNo  : $("polSeqNoParam").value,
				renewNo   : $("renewNoParam").value,
				intmNo    : $("intmNoParam").value,
				fromDate  : $("fromDateParam").value,
				toDate    : $("toDateParam").value
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function(){
				showNotice("Processing, please wait...");
			},
			onComplete : function(response){
				hideNotice("");
				showMessageBox("Finished purging " + cntUnproc + " unprocessed and " + cntProc + " processed/expired records.", imgMessage.INFO);
				purgeExtractTableGrid.url = contextPath+"/GIEXExpiriesVController?action=getPurgeExtractTable&refresh=1",
				purgeExtractTableGrid._refreshList();
				$("basedOnParam").checked = false;
			}
		});
	}
	
	observeReloadForm("reloadForm", showPurgeExtractTablePage);
</script>