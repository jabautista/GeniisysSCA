<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="float: left; width: 100%;">
	<div style="float: left; width: 100%;">
		<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
	</div>
	<iframe id="trgID" name="uploadTrg" height="0" width="0" frameborder="0" scrolling="yes"></iframe>
	<div id="errors" style="display: none; float: left; width: 96%; margin: 10px;">
		<label id="hideErrorLog" name="closer" style="margin-right: 0;">Hide</label>
		<div class="sectionDiv" style="height: 200px; overflow-y: auto;">
		</div>
	</div>
	<div class="sectionDiv" style="margin: 10px; float: left; width: 96%; margin-top: 0;">
		<div style="margin: 10px;">
			<div id="uploadMessage" style="font-size: 11px;"></div>
			<div id="progressBar" style="background-color: #e8e8e8; height: 15px; font-size: 11px; width: 0%; display: none;"></div>
			<div id="pct" style="color: #000; font-size: 11px;"></div>
			<div id="outerDiv" name="outerDiv" style="margin-bottom: 10px;">
				<div id="innerDiv" name="innerDiv">
					<label id="message">Files to be uploaded should be in proper format.</label>
				</div>
			</div>
			<form id="uploadFleetPolicyForm" name="uploadFleetPolicyForm" enctype="multipart/form-data" method="POST" action="" target="uploadTrg">
				<input type="hidden" value="uploadFile" id="action" name="action" />
				<input type="hidden" id="parId" name="parId" value="${parId}" />
				<input type="hidden" id="itemNo" name="itemNo" value="0" />
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
</div>
<script type="text/JavaScript">
	$("btnCancelUpload").observe("click", hideOverlay);

	$("btnStart").observe("click", function () {
		if ($F("file").blank()) {
			showMessageBox("No file selected.", imgMessage.ERROR);
		} else {
			$("notice").hide();
	    	$("uploadFleetPolicyForm").action = "FleetUploadController?" + fixTildeProblem(Form.serialize("uploadFleetPolicyForm"));
	    	$("uploadFleetPolicyForm").submit();
	    	$("uploadFleetPolicyForm").disable();
	    	$("uploadMessage").update();
	    	$("pct").update("<div style='background-color: #fff; width: 98%; height: 15px; padding-left: 5px;'>Initializing...</div>");
			$("progressBar").show();
	    	try {
	            // get upload status
	            updater = new Ajax.PeriodicalUpdater("uploadStatusDiv", "FleetUploadController", {
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
	                    	updater.stop();
	                    	$("uploadFleetPolicyForm").enable();
	                    	disableButton("btnStart");
	                    	/*$("btnStart").disable();
	                    	$("btnStart").removeClassName("button");
	                    	$("btnStart").addClassName("disabledButton");*/
	                    	$("file").disable();
	                        $("progressBar").style.width = "0%";
	                        $("uploadMessage").update("Fleet data uploading is successful!");
	                        $("pct").update();
	                        Effect.Fade("uploadMessage", {duration: 3});
	                    	showMessageBox("Fleet data uploading successful.", imgMessage.SUCCESS);
	                    } else if (content.include("ERROR")) {
	                    	updater.stop();
	                     	$("pct").update();
	                    	$("uploadFleetPolicyForm").enable();
	                        $("progressBar").style.width = "0%";
	                        $("trgID").contentWindow.document.body.innerHTML = "";
	                        $("uploadMessage").update(content);
	                    }
	                    $("progressBar").hide();
	                }
	            });
	        } catch (e) {
	        	showErrorMessage("uploadFleetPolicy.jsp - btnStart", e);
	        }
		}
	});

	$("btnErrorLog").observe("click", function () {
		if ($F("file").blank()) {
			showMessageBox("No file selected.", imgMessage.ERROR);
		} else {
			new Ajax.Updater($("errors").down("div", 0), contextPath+"/FleetUploadController?action=viewErrorLog&fileName="+$F("file"), {
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