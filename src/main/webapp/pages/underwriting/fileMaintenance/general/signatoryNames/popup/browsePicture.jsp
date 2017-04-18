<div class="sectionDiv" style="padding: 5px; margin-top: 10px; margin-bottom: 10px; float: left; width: 340px;">
	<div id="browsePictureDiv" style="width: 100%; padding-top: 10px;">
		<form id="uploadForm" name="uploadForm" enctype="multipart/form-data" method="POST" action="" target="uploadTarget">	
			<label class="rightAligned" style="width: 25px;">File</label> 
			<input id="file" name="file" type="file" style="margin-bottom: 5px; margin-left: 5px;" size="34" /> <br />
			<input type="hidden" id="hidSignatoryId" name = "hidSignatoryId" value="${signatoryId}">
			<div id="uploadStatusDiv" style="display: none; padding: 2px; width: 336px; height: 18px; border: 1px solid gray; float: left; background-color: white;">
				<span id="progressBar" style="background-color: #66FF33; height: 18px; float: left;"></span>
			</div>
		</form>
	</div>
	<iframe id="uploadTarget" name="uploadTarget" height="0" width="0" frameborder="0" scrolling="no" style="display: none;"></iframe>
	<div id="updaterDiv" name="updaterDiv" style="visibility: hidden; display: none; height: 0; width: 0"></div>
	<div class="buttonsDivPopup">
		<input type="button" class="button" style="width: 80px;" id="btnUpload" name="btnUpload" value="Upload" /> 
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel"/>
	</div>
</div>
<script>
	var supportedFiles = new Array(".gif", ".png", ".jpg", ".jpeg", ".bmp", ".ico");
	var invalidChars = new Array("<", ">", "'", "*", "?", "\"", "\\", "/", "|", ":");
	
	$("file").observe("change", function(){
		if (!checkIfFileExtensionValid()){
			showWaitingMessageBox("The file you are trying to upload is not supported.", imgMessage.ERROR, function(){
				$("file").value = "";
			});
		}
	});
	
	$("btnCancel").observe("click", function () {
		overlayBrowsePicture.close();
	});
	
	$("btnUpload").observe("click", function () {
		if($F("file") == ''){
			showMessageBox("Please select a file to be uploaded.", imgMessage.ERROR);
		}else{
			if (!checkIfFileExtensionValid()){
				showMessageBox("The file you are trying to upload is not supported.", imgMessage.ERROR);
			}else if (!checkFileNameCharValid()){
				showMessageBox("A filename cannot contain any of the following characters: \ / : * ? | \" \' .", imgMessage.ERROR);
			}else{
			    $("file").hide();
				$("uploadStatusDiv").show();
				uploadFile();
				//showMessageBox("Signature was succesfully attached."); //marco - 05.24.2013 - moved to uploadFile function
			}
		}
	});
	
	function checkIfFileExtensionValid(){
		var isValid = false;
		var fileExt = $F("file").substr($F("file").indexOf("."), $F("file").length - 1);
		for (var i=0; i<supportedFiles.length; i++){
			if (supportedFiles[i].toUpperCase() == fileExt.toUpperCase()) {
				isValid = true;
				break;
			}
		}
		return isValid;
	}
	
	function checkFileNameCharValid(){
		var isValid = true;
		for (var i=0; i<invalidChars.length; i++){
			if ($F("file").indexOf(invalidChars[i]) > -1) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}
	
	function uploadFile(){
		try{
			$("uploadTarget").contentWindow.document.body.innerHTML = "";
			$("progressBar").style.width = "0%";
			$("uploadForm").action = "GIISSignatoryNamesController?action=uploadFile&"+ fixTildeProblem(Form.serialize("uploadForm")+"&signatoryId="+removeLeadingZero($F("txtSignatoryId"))+"&signatory="+$F("txtSignatory"));
			$("uploadForm").submit();
			
			
		    updater = new Ajax.PeriodicalUpdater('updaterDiv','GIISSignatoryNamesController', {
		        frequency: 0.1,
		        method: "GET",
		        onSuccess: function(response) {
		            if (parseInt(response.responseText) > 1) {
		                $("progressBar").style.width = response.responseText + "%";
		            }
		
					var result = JSON.parse($("uploadTarget").contentWindow.document.body.innerHTML.stripTags().strip());
					if (result.message == "SUCCESS") {
		            	updater.stop();	            	
		            	$("progressBar").style.width = "100%";
		            	Effect.Fade($("uploadStatusDiv"),
		            			{duration: 0.5,
		            			 afterFinish: function(){
		            				$("file").clear();
		            				$("file").show();
		            				$("uploadStatusDiv").hide();	
		            				overlayBrowsePicture.close();
		            				showWaitingMessageBox("Signature was succesfully attached.", "I", function(){
		            					tbgSignatoryNames._refreshList();
		            				});
		            				//setAttachment(result);
		            			 }
		            			});
		            } else {
		            	showMessage(response.responseText, imgMessage.ERROR);
		            	updater.stop();
		            }
		    	}
		    });
		}catch (e){
			showErrorMessage("0", e);
		}
	}
</script>