<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="float: left; width: 100%; margin-top: 10px;">
	<iframe id="trgID" name="uploadTrg" height="0" width="0" frameborder="0" scrolling="yes"></iframe>
	<div id="errors" style="display: none; float: left; width: 96%; margin: 0 0 10px 10px;">
		<div class="sectionDiv" style="height: 200px; overflow-y: auto;"></div>
		
		<div id="logDiv" name="logDiv" align="center" style="width: 100%; float: left; margin-top: 5px;">
			<table align="center">
				<tr>
					<td>Remarks:&nbsp</td>
					<td colspan="3">
						<input id="errorRemarks" name="errorRemarks" type="text" readonly="readonly" style="width: 98%"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID:&nbsp</td>
					<td class="leftAligned">
						<input type="text" id="errorUserId" name="errorUserId" readonly="readonly" style="margin-right: 10px;"/>
					</td>
					<td class="rightAligned">Date Uploaded:&nbsp</td>
					<td class="leftAligned">
						<input type="text" id="errorLastUpdate" name="errorLastUpdate" readonly="readonly" style="width: 160px;"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="sectionDiv" style="margin: 10px; float: left; width: 96%; margin-top: 0;">
		<div style="margin: 10px;">
			<div id="pct" style="color: #000; font-size: 11px;"></div>
			<div id="outerDiv" name="outerDiv" style="margin-bottom: 10px;">
				<div id="innerDiv" name="innerDiv">
					<label id="message">Files to be uploaded should be in proper format.</label>
				</div>
			</div>
			<form id="uploadPropertyFloaterForm" name="uploadPropertyFloaterForm" style="margin-left: 0;" enctype="multipart/form-data" method="POST" action="" target="uploadTrg">
				<input type="hidden" value="uploadPropertyFloater" id="action" name="action" />
				<input type="hidden" id="uploadMode" name="uploadMode" value="par" />
				<input type="hidden" id="parId" name="parId" value="" />
				<input type="hidden" id="sublineCd" name="sublineCd" value="" />
				
				<input type="hidden" id="excelPath" name="excelPath" value="${excelPath}" />
				<input type="hidden" id="vCsvPath" name="vCsvPath" value="${vCsvPath}" />
				<input type="hidden" id="vCsvDirName" name="vCsvDirName" value="${vCsvDirName}" />
				
				<table style="clear: both; margin: 0; padding: 0;">
					<tr>
						<td><label style="float: right; margin-right: 5px;">Filename</label></td>
						<td><input type="file" name="file" id="file" accept="application/xls" style="" size="50" /></td>
					</tr>
				</table>
				
				<table align="center" style="margin: 10px auto;" border="0">
					<tr>
						<td><label for="recordsUploaded" style="float: right; margin-right: 5px;">Records Uploaded </label></td>
						<td><input type="text" id="recordsUploaded" name="recordsUploaded" style="width: 200px;" readonly="readonly"/></td>
					</tr>
					<tr>
						<td><label for="totalRecords" style="float: right; margin-right: 5px;">Total Records </label></td>
						<td><input type="text" id="totalRecords" name="totalRecords" style="width: 200px;" readonly="readonly"/></td>
					</tr>
				</table>
				
				<div id="progressBarDiv" name="progressBaDiv" style="margin: 0; width: 100%; float: left">
					<table align="center" border="0" style="margin: 4px auto;">
						<tr>
							<td><label style="float: right; margin-top: 2px; margin-right: 5px;">Status</label></td>
							<td>
								<div id="uploadStatusDiv" style="padding: 2px; width: 320px; height: 15px; border: 1px solid gray; float: left; background-color: white;">
									<span id="progressBar" style="background-color: blue; height: 15px; float: left; width: 0%;"></span>
								</div>
							</td>
							<td>
								<label style="float: left; margin-top: 3px; margin-left: 5px;">%</label>
							</td>
						</tr>
					</table>
				</div>
				
				<input type="hidden" id="lineCd" name="lineCd" value="" />
				<input type="hidden" id="packPolFlag" name="packPolFlag" value="" />
				
				<div id="userTransDiv" class="sectionDiv" style="float: left; width: 100%; margin-top: 10px;" >
					<table align="center" style="margin: 10px auto;">
						<tr>
							<td><label for="dspUserId" style="float: right; margin-right: 5px;">User ID</label></td>
							<td>
								<input type="text" id="dspUserId" name="dspUserId" readonly="readonly" style="margin-right: 10px;"/>
							</td>
							<td><label for="dspUploadDate" style="float: right; margin-right: 5px;">Date Uploaded</label></td>
							<td>
								<input type="text" id="dspUploadDate" name="dspUploadDate" readonly="readonly"/>
							</td>
						</tr>
					</table>
				</div>
				
				<div class="buttonsDivPopup" align="center">
					<input type="button" class="button" id="btnStart" style="width: 60px;" value="Start" />
					<input type="button" class="button" id="btnErrorLog" value="Error Log" />
					<input type="button" class="button" id="btnExitUpload" style="width: 60px;" value="Exit" />
				</div>
			</form>
		</div>
		<div id="uploadStatusDiv2" style="width: 0px; height: 0px; visibility: hidden;"></div>
	</div>
</div>
<script type="text/JavaScript">
	$("parId").value = (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
	$("sublineCd").value = nvl((objUWGlobal.packParId != null ? objCurrPackPar.sublineCd : $F("globalSublineCd")), null);
	$("lineCd").value = nvl((objUWGlobal.packParId != null ? objCurrPackPar.lineCd :  $F("globalLineCd")), null);
	$("packPolFlag").value = nvl((objUWGlobal.packParId != null ? 'Y':  'N'), null);
	$("dspUserId").value = '${userId}';
	$("dspUploadDate").value = dateFormat(new Date(), "mm-dd-yyyy");
		
	$("btnStart").observe("click", function () {
		if ($F("file").blank()) {
			showMessageBox("There's no excel file to be uploaded.", imgMessage.ERROR);
		} else {
			disableButton("btnStart");
			disableButton("btnErrorLog");
			disableButton("btnExitUpload");
			new Ajax.Request(contextPath+"/PropertyFloaterUploadController?action=validateUploadPropertyFloater&fileName="+$F("file"), {
				asynchronous: true,
				evalScripts: true,
				onSuccess: function(response) {
					if(checkErrorOnResponse(response)) {
						if(response.responseText != "") {
							showConfirmBox("Message", "This file was already uploaded. Do you want to continue?", "Yes", "No", onOkFunc, onCancelFunc);
						} else {
							onOkFunc();
						}
					}
				}
			});
			
			function onOkFunc() {
				var params = "";
				Effect.Fade("errors", {duration: .3});
				$("notice").hide();
				$("uploadPropertyFloaterForm").action = "PropertyFloaterUploadController?" + fixTildeProblem(Form.serialize("uploadPropertyFloaterForm"));
		    	$("uploadPropertyFloaterForm").submit();
		    	$("uploadPropertyFloaterForm").disable(); 
		    	$("progressBar").style.width = "0%";
		    	window.scrollTo(0,0);
				try {
					updater = new Ajax.PeriodicalUpdater("uploadStatusDiv2", "PropertyFloaterUploadController", {
						asynchronous:true, 
						frequency: 2, 
						method: "GET",
						onSuccess: function(request) {
							 if (parseInt(request.responseText) > 1) {
			                        $("progressBar").style.width = request.responseText + "%";
			                 }
							 var content = $("trgID").contentWindow.document.body.innerHTML.stripTags().strip();
							 params = $("trgID").contentWindow.document.body.innerHTML.split("-");
							 if ($("trgID").contentWindow.document.body.innerHTML.include("SUCCESS")) {
		                    	updater.stop();
		                    	$("progressBar").style.width = "100%";
		                    	$("uploadPropertyFloaterForm").enable();
		                    	disableButton("btnStart");
		                    	$("file").disable();
		                        $("file").clear();
		                    	showWaitingMessageBox("Property floater uploading successful.", imgMessage.SUCCESS, function(){
		                    		$("recordsUploaded").value = params[1];
		            				$("totalRecords").value = params[2];
		            				$("trgID").contentWindow.document.body.innerHTML = "";
		                    	});
		                    } else if ($("trgID").contentWindow.document.body.innerHTML.include("not uploaded")) {
		                    	updater.stop();
		                    	$("uploadPropertyFloaterForm").enable();
		                    	$("progressBar").style.width = "100%";
		                    	if (params[0].trim()=="ERROR") {
		                    		showWaitingMessageBox("There was an error in the file you're trying to upload, please check the file.", "E", function(){ 
			                    		$("recordsUploaded").value = params[1];
			            				$("totalRecords").value = params[2];
			            				$("trgID").contentWindow.document.body.innerHTML = "";
			                    	});
								} else {
									showWaitingMessageBox(params[0], "I", function(){
			                    		$("recordsUploaded").value = params[1];
			            				$("totalRecords").value = params[2];
			            				$("trgID").contentWindow.document.body.innerHTML = "";
			                    	});
								}
		                    } else if ($("trgID").contentWindow.document.body.innerHTML != "" || !$("trgID").contentWindow.document.body.innerHTML.blank()){
		                    	updater.stop();
		                    	$("progressBar").style.width = "100%";
		                    	$("uploadPropertyFloaterForm").enable();
		                    	if (params[0].trim()=="ERROR") {
		                    		showWaitingMessageBox("There was an error in the file you're trying to upload, please check the file.", "E", function(){ 
		                    			$("recordsUploaded").value = params[1];
			            				$("totalRecords").value = params[2];
			            				$("trgID").contentWindow.document.body.innerHTML = "";
			                    	});
								} else {
									showWaitingMessageBox(params[0], "I", function(){
			                    		$("recordsUploaded").value = params[1];
			            				$("totalRecords").value = params[2];
			            				$("trgID").contentWindow.document.body.innerHTML = "";
			                    	});
								}
		                    }
							$("file").enable();
							enableButton("btnStart");
	        				enableButton("btnErrorLog");
	        				enableButton("btnExitUpload");
						}
					});
				} catch(e) {
					showErrorMessage("uploadPropertyFloater OnOkFunc", e);
				}
			}
			
			function onCancelFunc() {
				$("file").clear();
				enableButton("btnStart");
				enableButton("btnErrorLog");
				enableButton("btnExitUpload");
			}
		}			
	});
	
	function showErrorLog() {
		try {
		overlayErrorLog = 
			Overlay.show(contextPath+"/PropertyFloaterUploadController", {
				urlContent: true,
				urlParameters: {
					action : "showCaErrorLog"
				},
			    title: "Error Log",
			    height: 370,
			    width: 720,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("showErrorLog" , e);
		}
	}
	
	$("btnErrorLog").observe("click", showErrorLog);
		
	$("btnExitUpload").observe("click", function() {
		overlayUploadPropertyFloater.close();
		showItemInfo();
	});
	
	initializeAll();
</script>