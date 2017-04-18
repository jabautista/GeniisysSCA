<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="amlaCoveredTransactionMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="amlaCoveredTransactionExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>AMLA - Covered Transaction Report</label>
			<span class="refreshers"style="margin-top: 0;">
				<label id="lblReloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="outerAmlaDiv" class="sectionDiv" style="width: 920px; height: 420px;">
		<div id="innerAmlaDiv" class="sectionDiv" style="width: 600px; height: 200px; margin-top: 90px; margin-left: 165px;">
			<div id="formAmlaDiv" class="sectionDiv" style="width: 575px; height: 135px; margin-top: 10px; margin-left: 10px;">
				<table style="margin-top: 10px;">
					<tr>
						<td class="leftAligned" style="padding-right: 10px; padding-left: 99px;">From</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
								<input id="txtFromDate" name="fromTo" readonly="readonly" type="text" class="required leftAligned date" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="303"/>
								<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" tabindex="304"/>
							</div>
						</td>
						<td class="leftAligned" style="padding-right: 10px; padding-left: 94px;">To</td>
						<td>
							<div id="T" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
								<input id="txtToDate" name="fromTo" readonly="readonly" type="text" class="required leftAligned date" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="305"/>
								<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);"  tabindex="306"/>
							</div>
						</td>
					</tr>
				</table>
				<table align="left">
					<tr>
						<td class="rightAligned" style="padding-right: 10px; padding-left: 15px;">Supervising Agency</td>
						<td>
							<select id="selSupervisingAgency" name="dropDown" style="width: 417px; text-align: left;">
								<option value="3">IC</option> <!--rearranged by Mark C. 07062015 - default value IC-->
								<option value="2">SEC</option>
								<option value="1">BSP</option>
							</select>				
						</td>	
					</tr>
					<tr>
						<td class="rightAligned" style="padding-right: 10px;">Submission Type</td>
						<td>
							<select id="selSubmissionType" name="dropDown" style="width: 417px; text-align: left;">
							<!--	<option value="1">NEW</option>
								<option value="2">CORRECTION</option>
								<option value="3">NIL</option>
								<option value="4">ERASE</option>
								<option value="5">RESEND</option>
								<option value="6">TEST</option> -->
								
								<option value="A">A - Add</option>
								<option value="E">E - Edit/Correction</option>
								<option value="D">D - Delete</option>
								<option value="T">T - Test</option>  <!--replaced by Mark C. 07062015-->
							</select>				
						</td>
					</tr>
					<!--<tr>
						<td class="rightAligned" style="padding-right: 10px;">Transaction Type</td>
						<td>
							<select id="selTransactionType" name="dropDown" style="width: 417px; text-align: left;">
								<option value="CM">CREDIT MEMO</option>
								<option value="COL">COLLECTION</option>
								<option value="DM">DEBIT MEMO</option>
								<option value="DV">DISBURSEMENT</option>
								<option value="">ALL TRANSACTIONS</option>
							</select>				
						</td>
					</tr>			commented out by Mark C. 0702015-->			
				</table>
			</div>
			<div id="buttonsDiv" class="buttonsDiv" align="center" style="margin-top: 13px;">
				<input id="btnGenerateCsv" type="button" class="button" value="Generate File" style="width: 100px;"/>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	setModuleId("GIACS116");
	setDocumentTitle("AMLA - Covered Transaction Report");
	//$("selTransactionType").options[$("selTransactionType").selectedIndex].text = "ALL TRANSACTIONS";
	//$("selTransactionType").value = "";   // commented out by Mark C. 07062015
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	message = "";
	fileToChange = "";
	fileName = "";
	
	$("amlaCoveredTransactionExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});

	$$("input[name='fromTo']").each(function(field) {
		field.observe("focus", function() {
			checkInputDates(field.id, "txtFromDate", "txtToDate");
			return;
		});
	});
	/*
	$("btnGenerateCsv").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("formAmlaDiv")) {
			if(message != ""){
				checkIfOpen(message.substring(9));
			}else{
				deleteAmlaRecord();
			}
		}
	});*/
	
	$("btnGenerateCsv").observe("click", function() {	
		if ($F("selSupervisingAgency") == 3) {				//replaced by Mark C. 07062015
			if (checkAllRequiredFieldsInDiv("formAmlaDiv")) {
				if(message != ""){
					checkIfOpen(message.substring(9));
				}else{
					deleteAmlaRecord();
				}
			}
		}else{
			showMessageBox("Report is not available for this agency.", "I");			
		}
	});
	
	function checkIfOpen(url) {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
			parameters : {
				action : "checkIfOpen",
				url : url
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					var unable = response.responseText;
					if(unable.contains("Unable to delete file")){
						showMessageBox(message.substring(9) + fileName + " is still open. Kindly close the file first.", "I");
					}else{
						deleteAmlaRecord();
					}
				}
			}
		});
	}
	
	function deleteAmlaRecord() {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
			parameters : {
				action : "deleteAmlaRecord"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Deleting AMLA Ext records, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					insertAmlaRecord();
				}
			}
		});
	}

	function insertAmlaRecord() {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
			parameters : {
				action : "insertAmlaRecord",
				fromDate : $F("txtFromDate"),
				toDate : $F("txtToDate")
				//tranType : $F("selTransactionType")  //commented out by Mark C. 07062015, only collection transactions are reportable for covered persons report
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Generating CSV, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					var res = JSON.parse(response.responseText);
					if (res.cnt != null) {
						getAmlaBranch(res.totDetailAmt, res.cnt);
					} else {
						showMessageBox("No record to be generated.", "I");
					}
				}
			}
		});
	}

	function getAmlaBranch(totDetailAmt, cnt) {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
			parameters : {
				action : "getAmlaBranch",
				agency : $F("selSupervisingAgency"),
				submission : $F("selSubmissionType"),
				totDetailAmt : totDetailAmt,
				cnt : cnt

			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Inserting record to AMLA Ext, please wait...");
			},
			/* onSuccess : function(response){
				if (checkErrorOnResponse(response)) {
					var url = response.responseText;
					deleteCSVPath("deletePreForm", $("geniisysAppletUtil").copyFileToLocal(url, "csv/amla").substring(9));
				}
			}, */
			onComplete : function(response) {
				hideNotice("");
				var deleteUrl = "";
				if (checkErrorOnResponse(response)) {
					var url = response.responseText;
					deleteUrl = url;
					if ($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined) {
						showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
					} else {
						try {
							//deleteCSVPath("deletePreForm", $("geniisysAppletUtil").copyFileToLocal(url, "csv/amla").substring(9));
							message = $("geniisysAppletUtil").copyFileToLocal(url, "csv/amla");
							if (message.include("SUCCESS")) {
								//createFinalCsv(totDetailAmt, cnt);
								showMessageBox("CSV file generated to " + message.substring(9), "I");
							} else {
								showMessageBox(message, "E");
							}
						} catch (e) {
							showMessageBox(message, e);
						}
					}
				}
				//deleteCSVFile("deleteCSVFile", deleteUrl, message.substring(9)); //commented out by gab 04.28.2016 SR 21922
				
			}
		});
	}

	function deleteCSVFile(action, url, previous) {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
			parameters : {
				action : action,
				url : url,
				previous : previous
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					var url = response.responseText;
					fileToChange = url;
					renameFile(message.substring(9), fileToChange);
				}
			}
		});
	}
	
	function deleteCSVPath(action, url) {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
			parameters : {
				action : action,
				url : url
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					//var out = response.responseText;
				}
			}
		});
	}
	
	function createFinalCsv(totDetailAmt, cnt) {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
			parameters : {
				action : "getAmlaBranch",
				agency : $F("selSupervisingAgency"),
				submission : $F("selSubmissionType"),
				totDetailAmt : totDetailAmt,
				cnt : cnt

			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					var url = response.responseText;
					$("geniisysAppletUtil").copyFileToLocal(url, "csv/amla");
					deleteCSVFile("deleteCSVFile", url, "");
					renameFile(message.substring(9), fileToChange);
				}
			}
		});
	}
		
	function renameFile(url, name) {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
			parameters : {
				action : "renameFile",
				url : url,
				name : name
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					var finalCsvName = response.responseText;
					fileName = finalCsvName;
				}
			}
		});
	}
	
	$("lblReloadForm").observe("click", function() {
		$("txtFromDate").value = "";
		$("txtToDate").value = "";
		
	 /* $("selSupervisingAgency").options[$("selSupervisingAgency").selectedIndex].text = "SEC";
		$("selSupervisingAgency").value = 2;
		$("selSubmissionType").options[$("selSubmissionType").selectedIndex].text = "NEW";
		$("selSubmissionType").value = 1;	*/
		$("selSupervisingAgency").value = 3;
		$("selSubmissionType").value = "A";						//replaced by Mark C. 07062015, default values
		
		//$("selTransactionType").options[$("selTransactionType").selectedIndex].text = "ALL TRANSACTIONS";
		//$("selTransactionType").value = "";    //commented out by Mark C. 07062015
	});
	
</script>