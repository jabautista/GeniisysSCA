<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

	<iframe id="trgID" name="uploadTrg" height="0" width="0" frameborder="0" scrolling="yes"></iframe>
	<div id="validateEnrolleUploadDiv" name="validateEnrolleUploadDiv" style="display:none;">
	</div>
	<div id="errors" style="display: none; float: left; width:100%; margin:auto; margin-top:0px; margin-bottom:2px;">
		<label id="hideErrorLog" name="closer" style="margin-right: 0;">Hide</label>
		<div class="sectionDiv" style="height: 200px; overflow-y: auto;">
		</div>
	</div>
	<div class="sectionDiv" style="display:block; width:100%; margin:auto; margin-top:0px;">
		<div style="margin: 10px;">
			<div id="uploadMessage" style="font-size: 11px; margin:10px;"></div>
			<div id="progressBar" style="background-color: #e8e8e8; height: 15px; font-size: 11px; width: 0%; display: none;"></div>
			<div id="pct" style="margin:10px; color: #000; font-size: 11px;"></div>
			
			<form id="uploadEnrolleesPolicyForm" name="uploadEnrolleesPolicyForm" enctype="multipart/form-data" method="POST" action="" target="uploadTrg">
				<input type="hidden" value="uploadFile" id="action" name="action" />
				<input type="hidden" id="parId" name="parId" value="${gipiParlist.parId }" />
				<input type="hidden" id="itemNo" name="itemNo" value="${itemNo }" />
				<input type="hidden" id="uploadMode" name="uploadMode" value="par" />
				<label class="rightAligned" style="width: 60px;">Browse</label> <input type="file" name="file" id="file" style="margin-bottom: 5px; margin-left: 5px;" size="50" /> <br />
				<div class="buttonsDivPopup">
					<input type="button" class="button" id="btnStart" style="width: 60px;" value="Start" />
					<input type="button" class="button" id="btnErrorLog" value="Error Log" />
					<input type="button" class="button" id="btnCancelUpload" style="width: 60px;" value="Cancel" />
				</div>
			</form>
		</div>
	</div>
	<div id="uploadStatusDiv" style="width: 0px; height: 0px; visibility: hidden;"></div>
	
<script type="text/JavaScript">
	$("btnStart").observe("click", function () {
		if ($F("file").blank()) {
			showMessageBox("No file selected.", imgMessage.ERROR);
		}else{
			disableButton("btnStart");
			disableButton("btnErrorLog");
			disableButton("btnCancelUpload");
			new Ajax.Updater($("validateEnrolleUploadDiv"), contextPath+"/UploadEnrolleesController?action=validateUploadFile&fileName="+$F("file"), {
				asynchronous: true,
				evalScripts: true,
				onCreate: function (){},
				onSuccess: function(response) {
					if (checkErrorOnResponse(response)) {
						if (response.responseText != ""){		
							showConfirmBox("Message", "This file was already uploaded. Do you want to continue?",  
									"Yes", "No", onOkFunc, onCancelFunc);
						}else{
							onOkFunc();
						}	
					}	
				}	
			});
			
			function onOkFunc(){
				Effect.Fade("errors", {duration: .3});
				$("notice").hide();
		    	$("uploadEnrolleesPolicyForm").action = "UploadEnrolleesController?" + fixTildeProblem(Form.serialize("uploadEnrolleesPolicyForm"));
		    	$("uploadEnrolleesPolicyForm").submit();
		    	$("uploadEnrolleesPolicyForm").disable(); 
		    	$("uploadMessage").update();
		    	$("pct").update("<div style='margin:10px; background-color: #fff; width: 98%; height: 15px; padding-left: 5px;'>Initializing...</div>");
				$("progressBar").show();
				window.scrollTo(0,0); 
				try {
		            // get upload status
		            updater = new Ajax.PeriodicalUpdater("uploadStatusDiv", "UploadEnrolleesController", {
		                asynchronous:true, 
		                frequency: 1, 
		                method: "GET",
		                onSuccess: function(request) {
		                    if (request.responseText.length > 1) {
		                        $("progressBar").style.width = request.responseText + "%";
		                        $("uploadMessage").show();
		                        $("pct").update(request.responseText + "%");
		                    }
							var content = $("trgID").contentWindow.document.body.innerHTML.stripTags().strip();
							if (content == "SUCCESS") {
								$("uploadEnrolleesSaved").value = $("uploadEnrolleesSaved").value =="Y"?"UY":"U";
		                    	updater.stop();
		                    	$("uploadEnrolleesPolicyForm").enable();
		                    	disableButton("btnStart");
		        				enableButton("btnErrorLog");
		        				enableButton("btnCancelUpload");
		                    	$("file").disable();
		                        $("progressBar").style.width = "0%";
		                        $("uploadMessage").update("Grouped Accident uploading is successful!");
		                        $("pct").update();
		                        Effect.Fade("uploadMessage", {duration: 3});
		                    	showMessageBox("Enrollee uploading successful.", imgMessage.SUCCESS);
		                    	showUploadEnrolleesOverlay($("parId").value,$("itemNo").value,$("uploadEnrolleesSaved").value);
		                    } else if (content.include("ERROR")) {
		                    	updater.stop();
		                     	$("pct").update();
		                    	$("uploadEnrolleesPolicyForm").enable();
		                        $("progressBar").style.width = "0%";
		                        $("trgID").contentWindow.document.body.innerHTML = "";
		                        $("uploadMessage").update(content);
		                        enableButton("btnStart");
		        				enableButton("btnErrorLog");
		        				enableButton("btnCancelUpload");
		                    }
		                    $("progressBar").hide();
		                }
		            });
		        } catch (e) {
		        	showErrorMessage("onOkFunc", e);
		        }
			}	
			function onCancelFunc(){
				$("file").clear();
				$("pct").update();
				$("progressBar").style.width = "0%";
				$("uploadMessage").update();
				$("uploadEnrolleesPolicyForm").enable();
				$("trgID").contentWindow.document.body.innerHTML = "";
				$("progressBar").hide();
				enableButton("btnStart");
				enableButton("btnErrorLog");
				enableButton("btnCancelUpload");
			}	
		}	
	});

	$("btnErrorLog").observe("click", function () {
		if ($F("file").blank()) {
			showMessageBox("No file selected.", imgMessage.ERROR);
		}else{
			new Ajax.Updater($("errors").down("div", 0), contextPath+"/UploadEnrolleesController?action=viewErrorLog&fileName="+$F("file"), {
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					Effect.Appear("errors", {duration: .2});
					showLoading($("errors").down("div", 0), "Getting log, please wait...", "75px");
				}
			});
		}	
	});

	$("hideErrorLog").observe("click", function() {
		Effect.Fade("errors", {duration: .3});
	});		
</script>		