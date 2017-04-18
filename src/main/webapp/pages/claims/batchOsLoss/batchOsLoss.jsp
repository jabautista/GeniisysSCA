<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="batchOsLossMainDiv" name="batchOsLossMainDiv">
	<div id="batchOsLossMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="batchOsLossForm" name="batchOsLossForm">
		<div id="batchOsLossFormDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Batch O/S Takeup</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label>
					</span>
				</div>
			</div>
			<div class="sectionDiv" id="certOf NoClaimDetailsDiv"changeTagAttr="true"  >
				<div style="height: auto; float: left; border: 1px solid #E0E0E0; width: 310px; height: 150px; margin: 100px 30%; padding: 10px; padding-bottom: 15px; -moz-border-radius: 5px;">
					<div style="margin-top: 40px;">
						<table align="center" style=" margin-bottom: 40px;">
							<tr>
								<td class="rightAligned" width="32px">As Of</td>
								<td class="leftAligned" width="150px">
									<div id="txtDateAsOfDiv" name="txtDateAsOfDiv" style="float: left; width: 150px;" class="withIconDiv required">
										<input style="width: 127px;" id="txtDateAsOf" name="txtDateAsOf" type="text" value="" class="withIcon required" readonly="readonly"/>
										<img id="hrefDateAsOf" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  alt="Date As Of"  onClick="$('txtDateAsOf').focus(); scwShow($('txtDateAsOf'),this, null);"  />
									</div>
								</td>
							</tr>
						</table>
						<div align="center">
							<input type="button" class="button" id="btnBook" name="btnBook" value="Book O/S" style=" width: 120px;"/>
							<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style=" width: 120px;"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

<script>
try{
	
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	
	var maxAcctDate = dateFormat('${maxAcctDate}', 'mm-dd-yyyy');
	
	var tranIds = "";
	objCLM.batchOS = {};
		
	function whenNewFormInstance(){
		disableButton("btnPrint");
		var dspDate = new Date.today().moveToLastDayOfMonth();
		$("txtDateAsOf").value = dateFormat(dspDate, 'mm-dd-yyyy');
     	if(dspDate < Date.parse(maxAcctDate)){
     		$("txtDateAsOf").value = null;
     	}
     	
     	//mikel 07.26.2016; GENQA 5544
     	var scriptType = "ALL";
		var moduleId = "GICLB001";
		var scriptType = "CL";
		var month = $("txtDateAsOf");
		var year = "N"
		patchRecords(month, year, scriptType, moduleId); 
	}
	
	//mikel 07.26.2016; GENQA 5544
	function patchRecords(month, year, scriptType, moduleId){
		new Ajax.Request(contextPath+"/GIACDataCheckController",{
			method: "POST",
			parameters: {
			     action : "patchRecords",
			     month : month,
			     year : year,
			     scriptType : scriptType,
			     moduleId : moduleId
			},
			evalScripts: false,
			asynchronous: false,
			onCreate: hideNotice(),
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					if (response.responseText.include("Geniisys Exception")){
						var message = response.responseText.split("#"); 
						showWaitingMessageBox(message[2], message[1], function(){
							showConfirmBox("Confirmation", "Would you like to go to the EOM Data Checking screen now? Pressing 'No' will transfer you back to the Main Screen.", "Yes", "No",
									function(){
										showDataChecking();
								},
									function(){if(objCLMGlobal.callingForm == "GIACS000"){
										goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");			
									} else {
										goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
									}
									objCLMGlobal.callingForm = null;
								})
						});
					} 
				}
			}
		});
	}
	
	function showDataChecking() {
		try {
			new Ajax.Request(contextPath
					+ "/GIACDataCheckController?action=showDataChecking", {
				asynchronous : true,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading, please wait...");
				},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						hideNotice();
						$("batchOsLossForm").update(response.responseText);
						//batchOsLossForm
						//hideAccountingMainMenus();
						$("acExit").show();
					}
				}
			});
		} catch (e) {
			showErrorMessage("showDataChecking", e);
		}
	}//end mikel 07.26.2016
	
	function bookOsGICLB001() {
		try{
			if ($F("txtDateAsOf") != ""){
				new Ajax.Request(contextPath+"/GICLTakeUpHistController?action=bookOsGICLB001", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
							moduleName: "GICLB001",
							dspDate		     : $F("txtDateAsOf")
					},
					onCreate: showNotice("Processing, please wait..."),
					onComplete: function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							if(response.responseText.include("ERROR")){
								var cause = response.responseText;
								var errorMsg = cause.substring(cause.indexOf(" "), cause.length);
								showMessageBox(errorMsg, imgMessage.ERROR);
							}else{
								var result = response.responseText.toQueryParams();
								tranIds = result.tranIds;
								if(result.message != ""){
									showWaitingMessageBox(result.message, result.messageType, function(){
										showWaitingMessageBox("Process Finished.", "S", function(){
											disableButton("btnBook");
											enableButton("btnPrint");
										});
									});
								}else{
									showWaitingMessageBox("Process Finished.", "S", function(){
										disableButton("btnBook");
										enableButton("btnPrint");
									});
								}
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			}
		}catch(e) {
			showErrorMessage("bookOsGICLB001", e);
		}
	}
	
	function validateTranDate() {
		try{
			if ($F("txtDateAsOf") != ""){
				new Ajax.Request(contextPath+"/GICLTakeUpHistController?action=validateTranDate", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {tranDate: $F("txtDateAsOf")},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							if(result.msg != ""){
								showWaitingMessageBox(result.msg, "I", function(){
									$("txtDateAsOf").value = "";
								});
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			}
		}catch(e) {
			showErrorMessage("validateTranDate", e);
		}
	}
	
	$("txtDateAsOf").observe("blur", function() {
		validateTranDate();
	});
	
	$("btnBook").observe("click", function(){
		var isComplete = checkAllRequiredFields();
		if (isComplete == true){
			bookOsGICLB001();
		}
	});
	
	$("btnPrint").observe("click", function(){
		objCLM.batchOS.tranIds = tranIds;
		objCLM.batchOS.tranDate = $F("txtDateAsOf");
		Modalbox.show(contextPath+"/GICLTakeUpHistController?action=showPrintBatchOS&ajaxModal=1",
				{title: "Print Batch O/S Accounting Entries",
				 width: 500});
	});

	$("btnExit").observe("click", function(){
		if(objCLMGlobal.callingForm == "GIACS000"){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");			
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		}
		objCLMGlobal.callingForm = null;
	});
	
	whenNewFormInstance();
	observeReloadForm("reloadForm", showBatchOsLoss);
	setModuleId("GICLB001");
	
}catch(e){
	showErrorMessage("GICLB001 page", e);
}
</script>