<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="batchAcctEntryExit">Exit</a></li>
		</ul>
	</div>
</div>
<div id="batchAccountingEntryMainDiv" name="batchAccountingEntryMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Batch Processing</label>
	   		<span class="refreshers" style="margin-top: 0;">
		   		<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div class="sectionDiv" id="batchAccountingEntryDiv" name="batchAccountingEntryDiv" style="height: 350px;">
		<div class="sectionDiv" id="batchAccountingEntryBody" name="batchAccountingEntryBody" style="height: 80%; width: 85%; margin-top: 30px; margin-left: 7.5%;">
			<div id="batchAccountingEntryLeft">
				<table style="height: 95%; width: 95%; margin-top: 2.5%; margin-left: 2.5%;">
					<tr>
						<td class="leftAligned" width="14%">Production Date</td>
						<td class="leftAligned"  width="35%">
							<div style="float: left; width: 180px;" class="withIconDiv required">
								<input type="text" id="txtProdDate" name="txtProdDate" class="withIcon required" readonly="readonly" style="width: 156px;"/>
								<img id="hrefProdDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Production Date"/>
							</div>
						</td>
						<td class="rightAligned" rowspan="6">
							<textarea id="txtReport" name="txtReport" style="width: 85%; height: 150px; color: #999999; font-size: 9px; font-family: Arial;"></textarea>
						</td>
						
					</tr>
					<tr>
						<td colspan="2" class="leftAligned">Production Procedures:</td>
					</tr>
					<tr height="20px">
						<td class="rightAligned"><input class="giacbProcess" type="checkbox" id="prodAcctEntries" name="prodAcctEntries" title="Production Accounting Entries"/></td>
						<td class="leftAligned"><label id="prodAcctEntriesLabel" for="prodAcctEntries"  title="Production Accounting Entries">Production Accounting Entries</label></td>
					</tr>
					<tr height="20px">
						<td class="rightAligned"><input class="giacbProcess" type="checkbox" id="inwFaculBusiness" name=""inwFaculBusiness"" title="Inward Facultative Business"/></td>
						<td class="leftAligned"><label id="inwFaculBusinessLabel" for="inwFaculBusiness"  title="Inward Facultative Business">Inward Facultative Business</label></td>
					</tr>
					<tr height="20px">
						<td class="rightAligned"><input class="giacbProcess" type="checkbox" id="treatyDistAcctEntries" name="prodAcctEntries" title="Treaty Distribution Accounting Entries"/></td>
						<td class="leftAligned"><label id="distAcctEntriesLabel" for="treatyDistAcctEntries"  title="Treaty Distribution Accounting Entries">Treaty Distribution Accounting Entries</label></td>
					</tr>
					<tr height="20px">
						<td class="rightAligned"><input class="giacbProcess" type="checkbox" id="outFaculPlaceBatch" name="outFaculPlaceBatch" title="Outward Facultative Placement Batch"/></td>
						<td class="leftAligned"><label id="outFaculPlaceBatchLabel" for="outFaculPlaceBatch"  title="Outward Facultative Placement Batch">Outward Facultative Placement Batch</label></td>
					</tr>
					<tr height="20px">
						<td class="rightAligned"><input class="giacbProcess" type="checkbox" id="advPremPaytReversal" name="advPremPaytReversal" title="Advanced Premium Payment Reversal"/></td>
						<td class="leftAligned"><label id="advPremPaytReversalLabel" for="advPremPaytReversal"  title="Advanced Premium Payment Reversal">Advanced Premium Payment Reversal</label></td>
						<td class="rightAligned" rowspan="2" style="padding-right: 30px;">
							<input type="button" class="button" id="btnGenerate" name="btnGenerate" value="Generate" style="width: 130px;"/>
							<input type="button" class="button" id="btnDataCheckReport" name="btnDataCheckReport" value="Data Check Report" style="width: 130px;"/>
						</td>
					</tr>
					<tr height="20px">
						<td class="rightAligned"><input class="giacbProcess" type="checkbox" id="prepaidComReversal" name="prepaidComReversal" title="Prepaid Commission Reversal"/></td>
						<td class="leftAligned"><label id="prepaidComReversalLabel" for="prepaidComReversal"  title="Prepaid Commission Reversal">Prepaid Commission Reversal</label></td>
					</tr>
					<tr height="20px"> <!-- benjo 10.13.2016 SR-5512 -->
						<td class="rightAligned"><input class="giacbProcess" type="checkbox" id="inwardTreatyBusiness" name="inwardTreatyBusiness" title="Inward Treaty Business"/></td>
						<td class="leftAligned"><label id="inwardTreatyBusinessLabel" for="inwardTreatyBusiness"  title="Inward Treaty Business">Inward Treaty Business</label></td>
					</tr>
				</table>
			</div>
			<div id="batchAccountingEntryRight">
			</div>
		</div>
	</div>
</div>
<script>
	setModuleId("GIACB000");
	initializeAll();
	setDocumentTitle("Batch Processing");
	var enterAdvPayt = nvl('${enterAdvPayt}','N');
	var enterPrepaidComm = nvl('${enterPrepaidComm}','N');
	var excludeSpecial = '${excludeSpecial}';
	objACGlobal.monthendBaeExcSpecial = nvl(excludeSpecial,'Y');
	var checkboxCnt = 0;
	var oldTranDate = null;
	giacb000FormInstance();
	function giacb000FormInstance() {
		try {
			var disableArray = ["prodAcctEntries","treatyDistAcctEntries","outFaculPlaceBatch","inwFaculBusiness","inwardTreatyBusiness"]; //benjo 10.13.2016 SR-5512
			var checkBoxArray = ["prodAcctEntries","treatyDistAcctEntries","outFaculPlaceBatch","inwFaculBusiness","advPremPaytReversal","prepaidComReversal","inwardTreatyBusiness"]; //benjo 10.13.2016 SR-5512
			$("txtReport").readOnly = true;
			$("txtReport").value = "REPORT SUMMARY";
			for ( var i = 0; i < disableArray.length; i++) {
				$(disableArray[i]).disabled = true;
			}
			for ( var i = 0; i < checkBoxArray.length; i++) {
				$(checkBoxArray[i]).checked = true;
			}
			if (excludeSpecial == null || excludeSpecial == "") {
				showMessageBox("No parameter found for 'EXCLUDE_SPECIAL' in giac_parameters.","I");
			}
			if(enterAdvPayt == "N"){
				$("advPremPaytReversal").hide();
				$("advPremPaytReversalLabel").hide();
			}else{
				$("advPremPaytReversal").disabled = true;
			}
			if(enterPrepaidComm == "N"){
				$("prepaidComReversal").hide();
				$("prepaidComReversalLabel").hide();
			}else{
				$("prepaidComReversal").disabled = true;
			}
			if(!validateUserFunc2("ME","GIACB000")){
				disableButton("btnGenerate");
				disableButton("btnDataCheckReport");
				disableDate("hrefProdDate");
				showMessageBox("User not allowed to process month end transaction.","I");
			}
			
		} catch (e) {
			showErrorMessage("giacb000FormInstance",e);
		}
	}
	function validateProdDate(prodDate) {
		try {
			new Ajax.Request(contextPath+"/GIACBatchAcctEntryController?action=validateProdDate",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					prodDate: prodDate
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) ){
						var obj = eval(response.responseText);
						var checkBoxArray = ["prodAcctEntries","treatyDistAcctEntries","outFaculPlaceBatch","inwFaculBusiness","inwardTreatyBusiness"]; //benjo 10.13.2016 SR-5512
						objACGlobal.batchDate = $F("txtProdDate");
						if (setCheckBox(obj[0])) {
							enableButton("btnGenerate");
						}
						if (obj[0].cnt == "0") {
							for ( var i = 0; i < checkBoxArray.length; i++) {
								$(checkBoxArray[i]).disabled = true;
							}
							if (obj[0].enterAdvancedPayt == "Y") {
								$("advPremPaytReversal").disabled = true;
							}
							if (obj[0].enterPrepaidComm == "Y") {
								$("prepaidComReversal").disabled = true;
							}
						} else {
							for ( var i = 0; i < checkBoxArray.length; i++) {
								$(checkBoxArray[i]).disabled = false;
							}
							if (obj[0].enterAdvancedPayt == "Y") {
								$("advPremPaytReversal").disabled = false;
							}
							if (obj[0].enterPrepaidComm == "Y") {
								$("prepaidComReversal").disabled = false;
							}
						} 
					}	
				}
			});
		} catch (e) {
			showErrorMessage("validateProdDate",e);
		}
	}
	function setCheckBox(obj) {
		$("prodAcctEntries").checked 		= obj.giacb001 != "0" ? true : false;
		$("inwFaculBusiness").checked 		= obj.giacb004 != "0" ? true : false;
		$("treatyDistAcctEntries").checked 	= obj.giacb002 != "0" ? true : false;
		$("outFaculPlaceBatch").checked 	= obj.giacb003 != "0" ? true : false;
		$("advPremPaytReversal").checked 	= obj.giacb005 != "0" ? true : false;
		$("prepaidComReversal").checked 	= obj.giacb006 != "0" ? true : false;
		$("inwardTreatyBusiness").checked 	= obj.giacb007 != "0" ? true : false; //benjo 10.13.2016 SR-5512
		if (obj.giacb001 != "0") return true;
		if (obj.giacb004 != "0") return true;
		if (obj.giacb002 != "0") return true;
		if (obj.giacb003 != "0") return true;
		if (obj.giacb005 != "0") return true;
		if (obj.giacb006 != "0") return true;
		if (obj.giacb007 != "0") return true; //benjo 10.13.2016 SR-5512
		return false;
	}
	function generateDataCheck(cond) {
		try {
			patchRecords($F("txtProdDate"), "N", "ALL", "GIACB000"); //mikel 07.25.2016; GENQA 5544
			var result = null;
			new Ajax.Request(contextPath+"/GIACBatchAcctEntryController?action=generateDataCheck",{
				parameters:{
							prodDate : $F("txtProdDate"),
							cond : cond
						   },
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Checking, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						result=eval(response.responseText);
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("generateDataCheck",e);
		}
	}
	
	//mikel 07.25.2016; GENQA 5544
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
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
				}
			}
		});
	}
	
	function validateWhenExit() {
		try {
			objACGlobal.monthendBaeExcSpecial = null;
			new Ajax.Request(contextPath+"/GIACBatchAcctEntryController?action=validateWhenExit",{
				asynchronous: false,
				evalScripts: true,
				onComplete: function (response){
					if (checkErrorOnResponse(response)){
						result=eval(response.responseText);
					}
				}
			});
		} catch (e) {
			showErrorMessage("validateWhenExit",e);
		}
	}
	function printSummary() {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var content = contextPath+"/EndOfMonthPrintReportController?action=printReport"
			+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
			+"&reportId=GIACR355"	
			+"&fileType="+fileType;
			printGenericReport(content, "SUMMARY OF ERRORS"); 
		} catch (e) {
			showErrorMessage("printGICLR259",e);
		}
	}
	function giacb000Proc(giacbNum,/* moduleId, */prodDate) {
		try{
			var moduleId = null;
			if (giacbNum == 1) {
				moduleId = "GIACB001";
			} else if(giacbNum == 2){
				moduleId = "GIACB002";
			} else if(giacbNum == 3){
				moduleId = "GIACB003";
			} else if(giacbNum == 4){
				moduleId = "GIACB004";
			} else if(giacbNum == 6){
				moduleId = "GIACB005";
			} else if(giacbNum == 7){
				moduleId = "GIACB006";
			} else if(giacbNum == 8){ //benjo 10.13.2016 SR-5512
				moduleId = "GIACB007";
			}
			new Ajax.Request(contextPath+"/GIACBatchAcctEntryController?action=giacb000Proc",{
				parameters:{
							action2 : moduleId,
 							prodDate : prodDate,
							giacbNum : giacbNum
						   },
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Working Accounting Entry Generation - "+moduleId.toUpperCase()+", please wait...");
				},
				onComplete: function (response){
					hideNotice();
					msgArray = getCustomErrorOnResponseForGIACB000(response);
					if (checkErrorOnResponse(response) && msgArray.length == 0){
						var result = eval(response.responseText);
						var msg = result[0].msg;
						msgArray = msg.split("#");
					}
				}
			});
			return msgArray;
		} catch (e) {
			showErrorMessage("giacb000Proc",e);
		}
	}
	function getCustomErrorOnResponseForGIACB000(response) {
		if (response.responseText.include("Geniisys Exception") || response.responseText.include("Geniisys Information")){
			var message = response.responseText.split("#"); 
			return message;
		} else {
			return [];
		}
	}
	function showLoopingMessage(array,index,giacbNumArray) {
	     var msgIcon = "I";
	     for ( var i = index; i < array.length; i++) {
	    	 if (array[i] == "Geniisys Exception") {
	 	    	msgIcon = "E";
	 		}else if (array[i] == "Geniisys Information") {
	 			msgIcon = "I";
			}
	    	 if (array[i].trim() == "" || array[i] == null || array[i] == "Geniisys Exception" || array[i].trim() == "ORA-20001:" || array[i] == "Geniisys Information") {
	 			index++;
	 		}else{
	 			break;
	 		}
			
		}
		if(index == array.length - 1){
			showWaitingMessageBox(array[index],msgIcon, function(){
				if (giacbNumArray.length == 0) {
		 			prodSumRepAndPerilExt($F("txtProdDate"));
				} else {
					loopGIACB000Proc(giacbNumArray);
				}
			});
		}else if (index < array.length) {
			showWaitingMessageBox(array[index],msgIcon, function(){
				showLoopingMessage(array,index+1,giacbNumArray);
			});
		}
	}
	/* function showLoopingMessage2(array,index,giacbNumArray) {
		showLoopingMessage(array,index,giacbNumArray);
	} */ 
	function loopGIACB000Proc(array) {
		var msgArray = [];
		for ( var i = 0; i < array.length; i++) {
			msgArray = giacb000Proc(array[i],$F("txtProdDate"));
			if(msgArray.length > 0) {
				array.splice(0,i+1);
				showLoopingMessage(msgArray,0,array);
				break;
			}
			if(i == array.length - 1){
	 			prodSumRepAndPerilExt($F("txtProdDate"));
			}
		}
	}
	
	function prodSumRepAndPerilExt(prodDate) {
		try{
			new Ajax.Request(contextPath+"/GIACBatchAcctEntryController?action=prodSumRepAndPerilExt",{
				parameters:{
							prodDate : prodDate
						   },
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Checking Additional procedures, please wait...");
				},
				onComplete: function (response){
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showMessageBox('Batch Accounting Entry Generation Procedure has finished.',"S");
					}
				}
			});
		} catch (e) {
			showErrorMessage("prodSumRepAndPerilExt",e);
		}
	}
	try {
		$("hrefProdDate").observe("click", function(){
			scwShow($('txtProdDate'),this, null);
		});
		$("batchAcctEntryExit").observe("click", function(){
			validateWhenExit();
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});	
		$("reloadForm").observe("click",function(){
			showBatchAccountingEntry();
		});
		$("hrefProdDate").observe("click", function(){
			oldTranDate = $("txtProdDate").value;
		});
		$("txtProdDate").observe("focus", function(){
			if (this.value.trim() != "" && oldTranDate != null &&  oldTranDate != this.value) {
				oldTranDate = this.value;
				validateProdDate(this.value);
			}
		});
		$("btnGenerate").observe("click", function(){
			if ($F("txtProdDate") != "") {
				var dataCheckObj = generateDataCheck(false);
				if (dataCheckObj[0].errorMsg == "" || dataCheckObj[0].errorMsg == null) {
					showConfirmBox("Confirmation", "Do you really want to generate accounting entries for this date?", "Yes", "No",
							function() {
								$("txtReport").value = dataCheckObj[0].report;
								$("txtReport").selectionEnd = $("txtReport").value.length;//to scroll the textArea at the end
								dataCheckObj = generateDataCheck(true);
								var giacbNumArray = [];
								if ($("prodAcctEntries").checked) {
									objACGlobal.batchDate = nvl(objACGlobal.batchDate,'07/31/2003');
									objACGlobal.fundCd = nvl(objACGlobal.fundCd,'FGI');
									giacbNumArray.push(1);
								}
								if (enterAdvPayt =="Y" && $("advPremPaytReversal").checked) {
									objACGlobal.batchDate = nvl(objACGlobal.batchDate,'08/31/2000');
									giacbNumArray.push(6);
								}
								if ($("inwFaculBusiness").checked) {
									objACGlobal.batchDate = nvl(objACGlobal.batchDate,'08/31/2000');
									giacbNumArray.push(4);
								}
								if ($("treatyDistAcctEntries").checked) {
									objACGlobal.batchDate = nvl(objACGlobal.batchDate,'08/31/2000');
									giacbNumArray.push(2);
								}
								if ($("outFaculPlaceBatch").checked) {
									objACGlobal.batchDate = nvl(objACGlobal.batchDate,'10/31/2002');
									giacbNumArray.push(3);
								}
								if (enterPrepaidComm == "Y" && $("prepaidComReversal").checked) {
									objACGlobal.batchDate = nvl(objACGlobal.batchDate,'08/31/2000');
									giacbNumArray.push(7);
								}
								if ($("inwardTreatyBusiness").checked) { //benjo 10.13.2016 SR-5512
									objACGlobal.batchDate = nvl(objACGlobal.batchDate,'08/31/2000');
									giacbNumArray.push(8);
								}
								if(giacbNumArray.length == 0){
									prodSumRepAndPerilExt($F("txtProdDate"));
								}else{
									loopGIACB000Proc(giacbNumArray);
								}
							}, 
							function() {
								$("txtReport").value = dataCheckObj[0].report;
								$("txtReport").selectionEnd = $("txtReport").value.length;//to scroll the textArea at the end
							});
				} else {
					showMessageBox(dataCheckObj[0].errorMsg,"I");
					$("txtReport").value = dataCheckObj[0].report;
					$("txtReport").selectionEnd = $("txtReport").value.length;//to scroll the textArea at the end
				}
			} else {
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtProdDate");
			}
		});
		$("btnDataCheckReport").observe("click", function(){
			if ($F("txtProdDate") != "") {
				showGenericPrintDialog("Report Summary", printSummary, null, true); 
			}else {
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtProdDate");
			}
		});
		$$("input[type='checkbox'].giacbProcess").each(function (m) {
			m.observe("change", function ()	{
				checkboxCnt = 0;
				$$("input[type='checkbox'].giacbProcess").each(function (m) {
					if (m.checked){
						checkboxCnt = checkboxCnt + 1;
					}
				});
				if (checkboxCnt > 0){
					enableButton("btnGenerate");
				}else{
					disableButton("btnGenerate");
				}
			});
		});
	} catch (e) {
		showErrorMessage("batchAccountingEntry.jsp observe",e);
	}
</script>