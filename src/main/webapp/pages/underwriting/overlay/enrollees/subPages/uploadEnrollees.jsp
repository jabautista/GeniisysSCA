<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<iframe id="trgID" name="uploadTrg" height="0" width="0" frameborder="0" scrolling="yes"></iframe>
<div id="validateEnrolleUploadDiv" name="validateEnrolleUploadDiv" style="display:none;">
</div>
<div id="errors" style="display: none; float: left; width:100%; margin:auto; margin-top:0px; margin-bottom:2px;">
	<!-- <label id="hideErrorLog" name="closer" style="margin-right: 0; width: 100%;">Hide</label> -->	
	<!-- <div class="sectionDiv" style="height: 200px; overflow-y: auto;">
	</div> -->	
	
	<div id="errorLogTableGridSectionDiv" class="">
		<div id="errorLogTableGridDiv" style="padding: 10px;">
			<div id="errorLogTableGrid" style="height: 0px; width: 100%;"></div>
		</div>
	</div>
</div>
<div class="sectionDiv" style="display:block; width:100%; margin:auto; margin-top:0px;">
	<div style="margin: 10px;">
		<div id="uploadMessage" style="font-size: 11px; margin:10px;"></div>
		<div id="progressBar" style="background-color: blue; height: 15px; font-size: 11px; width: 0%; display: none;"></div>
		<div id="pct" style="margin:10px; color: #000; font-size: 11px;"></div>
		
		<form id="uploadEnrolleesPolicyForm" name="uploadEnrolleesPolicyForm" enctype="multipart/form-data" method="POST" action="" target="uploadTrg">
			<input type="hidden" value="uploadFile" id="action" name="action" />
			<input type="hidden" id="parId" name="parId" value="${gipiParlist.parId }" />
			<input type="hidden" id="itemNo" name="itemNo" value="${itemNo }" />
			<input type="hidden" id="uploadMode" name="uploadMode" value="par" />
			<table align="center" border="0">
				<tr>
					<td class="rightAligned">Browse </td>
					<td class="leftAligned">
						<input type="file" name="file" id="file" style="margin-bottom: 5px; margin-left: 5px;" size="50"/>
					</td>
				</tr>
			</table>			
			<div class="buttonsDivPopup">
				<input type="button" class="button" id="btnStart" style="width: 60px;" value="Start" />
				<input type="button" class="button" id="btnErrorLog" value="Show Error Log" />
				<input type="button" class="button" id="btnCancelUpload" style="width: 60px;" value="Cancel" />
			</div>
		</form>
	</div>
</div>
<div id="uploadStatusDiv" style="width: 0px; height: 0px; visibility: hidden;"></div>
<script type="text/javascript">
try{
	$("btnStart").observe("click", function () {
		if ($F("file").blank()) {
			showMessageBox("No file selected.", imgMessage.ERROR);
		}else{
			disableButton("btnStart");
			disableButton("btnErrorLog");
			disableButton("btnCancelUpload");
			
			function onOkFunc(){
				Effect.Fade("errors", {duration: .3});
				$("notice").hide();
		    	$("uploadEnrolleesPolicyForm").action = "UploadEnrolleesController?" + fixTildeProblem(Form.serialize("uploadEnrolleesPolicyForm"));
		    	$("uploadEnrolleesPolicyForm").setAttribute("action", "UploadEnrolleesController?" + fixTildeProblem(Form.serialize("uploadEnrolleesPolicyForm"))); //marco - 08.14.2014 - added
		    	$("uploadEnrolleesPolicyForm").submit();
		    	$("uploadEnrolleesPolicyForm").disable(); 
		    	//$("uploadMessage").update();
		    	//$("pct").update("<div style='margin:10px; background-color: #fff; width: 98%; height: 15px; padding-left: 5px;'>Initializing...</div>");
				$("progressBar").show();
				window.scrollTo(0,0); 
				try {
		            // get upload status
		            updater = new Ajax.PeriodicalUpdater("uploadStatusDiv", "UploadEnrolleesController", {
		                asynchronous:true, 
		                frequency: 2, 
		                method: "GET",
		                onSuccess: function(request) {
		                    if (request.responseText.length > 1) {
		                        $("progressBar").style.width = request.responseText + "%";
		                        $("progressBar").show();
		                        //$("uploadMessage").show();
		                        //$("pct").update(request.responseText + "%");
		                    }
							var content = $("trgID").contentWindow.document.body.innerHTML.stripTags().strip();
							if (content.include("SUCCESS")) {
								var uploadedSize = content.split("-")[1];
								var totalSize = content.split("-")[2];
								
								$("progressBar").style.width = "100%";
								$("uploadEnrolleesSaved").value = $("uploadEnrolleesSaved").value =="Y"?"UY":"U";
		                    	updater.stop();
		                    	$("uploadEnrolleesPolicyForm").enable();
		                    	disableButton("btnStart");
		        				enableButton("btnErrorLog");
		        				enableButton("btnCancelUpload");
		                    	$("file").disable();
		                        //$("progressBar").style.width = "0%";
		                        //$("uploadMessage").update("Grouped Accident uploading is successful!");
		                        //$("pct").update();
		                        //Effect.Fade("uploadMessage", {duration: 3});
		                    	
		                    	showWaitingMessageBox(uploadedSize + " out of " + totalSize + " enrollee record/s successfully uploaded.", imgMessage.SUCCESS, function(){
		                    		$("progressBar").style.width = "0%";
		                    		$("progressBar").hide();
		                    		tbgUploadEnrollees._refreshList();
		                    	});
		                    } else if (content.include("ERROR")) {
		                    	updater.stop();
		                     	$("pct").update();
		                    	$("uploadEnrolleesPolicyForm").enable();
		                        //$("progressBar").style.width = "0%";
		                        $("trgID").contentWindow.document.body.innerHTML = "";
		                        showWaitingMessageBox((content.split("-")[1]).trim(), "I", function(){
		                        	$("file").enable();
		                        	$("progressBar").style.width = "0%";
		                        	$("progressBar").hide();
		                        });
		                        enableButton("btnStart");
		        				enableButton("btnErrorLog");
		        				enableButton("btnCancelUpload");
		                    }
		                    //$("progressBar").hide();
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
		}	
	});
	
	$("btnErrorLog").observe("click", function () {
		if ($F("file").blank()) {
			showMessageBox("No file selected.", imgMessage.ERROR);
		}else{
			if($F("btnErrorLog") == "Show Error Log"){
				new Ajax.Updater($("errors").down("div", 0), contextPath+"/UploadEnrolleesController?action=viewErrorLogTG&fileName="+$F("file"), {
					asynchronous: true,
					evalScripts: true,
					onCreate: function () {
						Effect.Appear("errors", {duration: .2});
						showLoading($("errors").down("div", 0), "Getting log, please wait...", "75px");
						$("btnErrorLog").value = "Hide Error Log";
					}
				});	
			}else{
				Effect.Fade("errors", {duration: .3});
				$("btnErrorLog").value = "Show Error Log";
			}			
		}	
	});
	
	/*
	$("hideErrorLog").observe("click", function() {
		Effect.Fade("errors", {duration: .3});
	});
	*/
	
	$("btnCancelUpload").observe("click", function(){
		$("uploadEnrolleesFileDiv").hide();
	});
}catch(e){
	showErrorMessage("Upload Enrollee Page", e);
}
</script>