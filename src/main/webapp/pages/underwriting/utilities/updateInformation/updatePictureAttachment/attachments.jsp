<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="contentsDiv">
	<div id="attachmentListMainDiv" style="padding: 5px; margin-top: 10px; margin-bottom: 10px; float: left; width: 98%;" class="sectionDiv">
		<div id="attachmentListDiv">
			<div id="attachmentListTableDiv" style="text-align: center;">
				<div id="attachMediaTableGrid" style="height: 200px; width: 587px;"></div>
			</div>
		</div>	
		<div id="attachmentFormDiv" style="float: left; width: 100%; margin-top: 5px;">
			<form id="uploadForm" name="uploadForm" enctype="multipart/form-data" method="POST" action="" target="uploadTarget">	
				<table align="center">
					<tr>
						<td class="rightAligned">Browse </td>
						<td class="leftAligned">	
							<input type="file" id="txtFile" name="txtFile" readonly="readonly" size="40" class="required">
							<div id="uploadStatusDiv" style="display: none; padding: 2px; width: 336px; height: 18px; border: 1px solid gray; float: left; background-color: white;">
								<span id="progressBar" style="background-color: #66FF33; height: 18px; float: left;"></span>
							</div>
						</td>
					</tr>		
					<tr>
						<td class="rightAligned">File Name </td>
						<td class="leftAligned">
							<input type="hidden" id="hidFileExt" name="hidFileExt">
							<input type="text" id="txtFileName" name="txtFileName" style="width: 335px;" class="required" lastValidValue="" maxlength="200">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks </td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 340px;">
								<textarea id="txtRemarks" name="txtRemarks" style="width: 316px; border: none; height: 13px; resize: none;"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 2px; float: right;" alt="Edit" id="editRemarks" />
							</div>
						</td>
					</tr>
<!-- 					<tr></tr>
					<tr>
						<td class="rightAligned">Sketch Tag</td>
						<td class="leftAligned"><input type="checkbox" id="sketchTag" name="sketchTag"></td>
					</tr>	 -->
				</table>
			</form>
			<iframe id="uploadTarget" name="uploadTarget" height="0" width="0" frameborder="0" scrolling="no" style="display: none;"></iframe>
			<div id="updaterDiv" name="updaterDiv" style="visibility: hidden; display: none; height: 0; width: 0"></div>
			<div style="float: left; width: 100%;">
				<table align="center">
					<tr>
						<td>
							<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" enValue="Add"/>
							<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
							<input type="button" class="disabledButton" style="width: 60px;" id="btnView" name="btnView" value="View"/>
						</td>
					</tr>
				</table>
			</div>
		</div>	
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%;">
		<table align="center">
			<tr>
				<td>					
					<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
					<input type="button" class="button" style="width: 90px;" id="btnAttach" name="btnAttach" value="Save" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	var invalidChars = new Array("<", ">", '"', "*", "?", "\\", "/", "|", ":");
	var directory = "";
	var attachmentChangeTag = 0;
	changeTag = 0;
	
	try{
		var attachMediaArray = [];
		var objAttachMedia = new Object();
		var objParameters = new Object();
		objAttachMedia.objAttachMediaTableGrid = JSON.parse('${jsonGiuts029Attachments}');  //.replace(/\\/g, '\\\\')
		objAttachMedia.attachMedia = objAttachMedia.objAttachMediaTableGrid.rows || [];
		
		var attachMediaTableModel = {
			url : contextPath + "/UpdateUtilitiesController?action=showGIUTS029ItemAttachments&refresh=1&policyId="+objGIUTS029.policyId+"&itemNo="+objGIUTS029.selectedItemNo,
			options: {
				height: '170px',
				width: '635px',
				onCellFocus: function(element, value, x, y, id){
					var obj = attachMediaTableGrid.geniisysRows[y];
					selectedIndex=y;
					formatAppearance("show",obj);
					attachMediaTableGrid.keys.removeFocus(attachMediaTableGrid.keys._nCurrentFocus, true);
					attachMediaTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					formatAppearance();
					attachMediaTableGrid.keys.removeFocus(attachMediaTableGrid.keys._nCurrentFocus, true);
					attachMediaTableGrid.keys.releaseKeys();
				},
				onSort: function() {
					formatAppearance();
					attachMediaTableGrid.keys.removeFocus(attachMediaTableGrid.keys._nCurrentFocus, true);
					attachMediaTableGrid.keys.releaseKeys();
				},
				beforeSort: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnAttach").focus();
						});
						return false;
					}
				},
				prePager : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnAttach").focus();
						});
						return false;
					}
				},
				postPager: function () {
					formatAppearance();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0',
					visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'fileName',
					width: '0',
					visible: false
				},
				{
					id: 'fileName2',
					title:'File Name',
					width: '310px',
				},
				{
					id: 'remarks',
					title: 'Remarks',
					width: '290px',
				}
			],
			rows: objAttachMedia.attachMedia
		};
		
		attachMediaTableGrid = new MyTableGrid(attachMediaTableModel);
		attachMediaTableGrid.pager = objAttachMedia.objAttachMediaTableGrid;
		attachMediaTableGrid.render('attachMediaTableGrid');
		attachMediaTableGrid.afterRender = function(){
														attachMediaArray=attachMediaTableGrid.geniisysRows;
														if (attachMediaArray.length > 0) {
															directory = attachMediaArray[0].fileName;
														}
													};
	} catch(e){
		showErrorMessage("attachMediaTableGrid", e);
	}
	
	writeFilesToServer();
	
	function formatAppearance(param,obj) {
		if(param==="show"){
			$("txtFile").disable();
			$("txtFileName").disable();
			enableButton("btnView");
			enableButton("btnDelete");
			$("btnAdd").value="Update";
			populateDetails(obj);
		}else{
			$("txtFile").enable();
			$("txtFileName").enable();
			disableButton("btnView");
			disableButton("btnDelete");
			$("btnAdd").value="Add";
			populateDetails(null);
			selectedIndex = null;
		}
	}
	
	function populateDetails(obj) {
		$("hidFileExt").value = obj == null ? "" : obj.fileName2.substr(obj.fileName2.lastIndexOf("."));
		$("txtFileName").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.fileName2.substr(0, obj.fileName2.lastIndexOf(".")),""));
		$("txtFileName").writeAttribute("lastValidValue", $F("txtFileName"));
		$("txtRemarks").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.remarks,""));
	}
	
	function checkIfFileExtensionValid(){
		var isValid = false;
		var fileExt = $F("txtFile").substr($F("txtFile").lastIndexOf("."), $F("txtFile").length - 1);
		for (var i=0; i<objGIUTS029.allowedMediaTypes.length; i++){
			if (objGIUTS029.allowedMediaTypes[i].trim().toUpperCase() == fileExt.toUpperCase()) {
				isValid = true;
				break;
			}
		}
		return isValid;
	}

	function checkFileNameCharValid(character){
		var isValid = true;
		for (var i=0; i<invalidChars.length; i++){
			if (character == invalidChars[i]) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}
	
	
	function setObj() {
		var obj = new Object();
		obj.fileName2 = escapeHTML2($F("txtFileName")+$F("hidFileExt"));
		obj.remarks = escapeHTML2($F("txtRemarks"));
		obj.policyId = objGIUTS029.policyId;
		obj.itemNo = removeLeadingZero(objGIUTS029.selectedItemNo);
		return obj;
	}
	
	function valAddGiuts029(){
		try{
			var addedSameExists = false;
			var deletedSameExists = false;					
			
			for(var i=0; i<attachMediaTableGrid.geniisysRows.length; i++){
				if(attachMediaTableGrid.geniisysRows[i].recordStatus == 0 || attachMediaTableGrid.geniisysRows[i].recordStatus == 1){	
					if(unescapeHTML2(attachMediaTableGrid.geniisysRows[i].fileName2) == ($F("txtFileName")+$F("hidFileExt"))){
						addedSameExists = true;								
					}							
				} else if(attachMediaTableGrid.geniisysRows[i].recordStatus == -1){
					if(unescapeHTML2(attachMediaTableGrid.geniisysRows[i].fileName2) == ($F("txtFileName")+$F("hidFileExt"))){
						deletedSameExists = true;
					}
				}
			}
			
			if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
				showMessageBox("Record already exists with the same file_name.", "E");
				return;
			} else if(deletedSameExists && !addedSameExists){
				$("txtFile").hide();
 				$("uploadStatusDiv").show();
				uploadFile();
				return;
			}
			new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
				parameters : {action : "valAddGiuts029",
							  policyId : $F("hidPolicyId"),
							  itemNo: objGIUTS029.selectedItemNo, 
							  fileName: $F("txtFileName")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						$("txtFile").hide();
		 				$("uploadStatusDiv").show();
						uploadFile();
					}
				}
			});
		} catch(e){
			showErrorMessage("valAddGiuts029", e);
		}
	}
	
	function addAttachedMedia(result) {
		try {
			var newObj  = setObj();
				if ($F("btnAdd") == "Update"){
					//on UPDATE records
					newObj.url = attachMediaArray[selectedIndex].url;
					newObj.fileName = attachMediaArray[selectedIndex].fileName;
					newObj.recordStatus = 1;
					attachMediaArray.splice(selectedIndex, 1, newObj);
					attachMediaTableGrid.updateVisibleRowOnly(newObj, attachMediaTableGrid.getCurrentPosition()[1]);
				}else{
					//on ADD records
					newObj.url = contextPath+"/"+result.uploadPath.replace(/\\/g, "/") + "/"+ newObj.fileName2;
					newObj.fileName = result.filePath + "/"+ newObj.fileName2;
					newObj.recordStatus = 0;
					attachMediaArray.push(newObj);
					attachMediaTableGrid.addBottomRow(newObj);
				}			
				attachmentChangeTag = 1;
				changeTag = 1;
				formatAppearance();	
		} catch (e){
			showErrorMessage("addAttachedMedia", e);
		}
	}
	
	function deleteAttachment(){
		if(selectedIndex != null) {
			attachMediaArray[selectedIndex].recordStatus = -1;
			attachMediaTableGrid.deleteRow(selectedIndex);
			attachmentChangeTag = 1;
			changeTag = 1;
			formatAppearance();	
		} else {
			showMessageBox("Please select a record to delete.", imgMessage.INFO);
		}
	}	
	
	function uploadFile(){
		try {
			$("uploadTarget").contentWindow.document.body.innerHTML = "";
			$("progressBar").style.width = "0%";
			//$("uploadForm").action= "UploadController?action=uploadFile&module=underwriting&recordId="+$F("hidPolicyId")+"&itemNo="+objGIUTS029.selectedItemNo+"&"+fixTildeProblem(Form.serialize("uploadForm"));
			$("uploadForm").action= "UploadController?action=uploadFile&module=underwriting&recordId="+$F("hidPolicyId")+"&itemNo="+objGIUTS029.selectedItemNo+"&hidFileExt="+encodeURIComponent($F("hidFileExt"))+"&txtFileName="+encodeURIComponent($F("txtFileName")); //added by steven 07.14.2014
	    	$("uploadForm").submit();
			
	    	updater = new Ajax.PeriodicalUpdater('updaterDiv','UploadController', {
	             asynchronous: true, 
	             frequency: 0.1, 
	             method: "GET",
	             onSuccess: function(response) {
	 	            if (parseInt(response.responseText) > 1) {
	 	                $("progressBar").style.width = response.responseText + "%";
	 	            }
		             if (response.responseText === "0 byte") {
		            	 showMessageBox("The file has "+ response.responseText+".", imgMessage.ERROR);
		            	 updater.stop();
		            	 $("txtFile").clear();
          				$("txtFile").show();
          				$("uploadStatusDiv").hide();
          				formatAppearance();	
		             }
	 				var result = JSON.parse($("uploadTarget").contentWindow.document.body.innerHTML.stripTags().strip());
	 	            if (result.message == "SUCCESS") {
	 	            	updater.stop();
	 	            	$("progressBar").style.width = "100%";
	 	            	Effect.Fade($("uploadStatusDiv"),
	 	            			{duration: 0.5,
	 	            			 afterFinish: function(){
	 	            				$("txtFile").clear();
	 	            				$("txtFile").show();
	 	            				$("uploadStatusDiv").hide();	            				
	 	            				addAttachedMedia(result);
	 	            			 }
	 	            			});
	 	            }else{
	 	            	showMessageBox(response.responseText, imgMessage.ERROR);
	 	            	updater.stop();
	 	            }
	 	    	}
		    });	    
		} catch (e){
			showErrorMessage("uploadFile", e);
		}
	}
	
	function deleteFileDirectoryFromSever(){		
		try{
			new Ajax.Request(contextPath+"/UpdateUtilitiesController", {
				method: "POST",
				parameters : {action : "giuts029DeleteFilesFromServer",
							  files : prepareJsonAsParameter(attachMediaTableGrid.geniisysRows)},
			  onCreate:function(){
					showNotice("Processing, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
								
					}
				}
			});
		}catch(e){
			showErrorMessage("deleteFileDirectoryFromSever",e);
		}
	}	
	
	function saveAttachments(){
		try{
			new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
				method : "POST",
				parameters : {action : "giuts029SaveChanges",
							  param: JSON.stringify(objParameters)},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						attachmentChangeTag=0;
						changeTag = 0;
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							attachMediaTableGrid.keys.releaseKeys();
							deleteFileDirectoryFromSever();
							overlayAttachedMedia.close();
						});
					}
				}
			});
		}catch(e){
			showErrorMessage("saveAttachments",e);
		}
	}
	
	function writeFilesToServer(){
		try{
			new Ajax.Request(contextPath+"/UpdateUtilitiesController", {
				method: "POST",
				parameters : {action : "giuts029WriteFilesToServer",
							  files : prepareJsonAsParameter(attachMediaTableGrid.geniisysRows)},
			  onCreate:function(){
					showNotice("Processing, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						objAttachment = {};
						objAttachment.onAttach = function(files){
							objParameters.setRows = getAddedAndModifiedJSONObjects(files);
							objParameters.delRows = getDeletedJSONObjects(files);
							saveAttachments();
						};							
					}else{
						overlayAttachedMedia.close();
					}
				}
			});
		}catch(e){
			showErrorMessage("writeFilesToServer",e);
		}
	}
	
	function viewAttachment(){
		var url = "";
		if(attachMediaArray[selectedIndex].url == undefined || attachMediaArray[selectedIndex].url == null){
			var fileName = unescapeHTML2(attachMediaArray[selectedIndex].fileName);
			url = contextPath + fileName.substr(fileName.indexOf("/", 3), fileName.length);
		} else {
			url = unescapeHTML2(attachMediaArray[selectedIndex].url);
		} 
		window.open(url);
	}
	
	/* observe */
	$("btnAdd").observe("click", function(){
		if($("btnAdd").value==="Add") {
			if(checkAllRequiredFieldsInDiv("attachmentFormDiv")) {
 				valAddGiuts029();
			}
		} else {
			addAttachedMedia();
		}
	});
	
	$("btnDelete").observe("click", deleteAttachment);
	
	$("btnView").observe("click", function(){
		viewAttachment();
	});
	
	$("txtFile").observe("change", function(){
		if(this.files[0].size > 1048576) {
			showMessageBox("Upload limit is only 1 MB per file.", "I");
			this.clear();
			formatAppearance();
		} else {
			$("hidFileExt").value = this.value.substr(this.value.lastIndexOf("."));
			$("txtFileName").value = (this.value.substr(0, this.value.lastIndexOf("."))).replace(/\s/g,"_");
			$("txtFileName").writeAttribute("lastValidValue", $F("txtFileName"));
		}
	});
	
	$("txtRemarks").observe("keyup", function(){
		limitText(this, 4000);
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000);
	});	
	
	$("btnCancel").observe("click",function(){
		if(attachmentChangeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					fireEvent($("btnAttach"), "click");
				},				
				function(){					
					attachMediaTableGrid.keys.removeFocus(attachMediaTableGrid.keys._nCurrentFocus, true);
					attachMediaTableGrid.keys.releaseKeys();
					overlayAttachedMedia.close();
				},
				""
			);
		} else {
			attachMediaTableGrid.keys.removeFocus(attachMediaTableGrid.keys._nCurrentFocus, true);
			attachMediaTableGrid.keys.releaseKeys();
			overlayAttachedMedia.close();
		}
		deleteFileDirectoryFromSever();
	});
	
	$("btnAttach").observe("click", function(){
		if(attachmentChangeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return false;	
		}
		
		var setRows = attachMediaArray;
		
		if(setRows.length == 0){
			showConfirmBox("Confirmation", "No files to attach, would you like to continue?", "Yes", "No", 
				function() {
					attachMediaTableGrid.keys.releaseKeys();
					deleteFileDirectoryFromSever();
					overlayAttachedMedia.close();
				},
				""
			);
		} else {
			if(objAttachment.onAttach){
				objAttachment.onAttach(setRows);
			}
		}		
	});
	
	$("txtFileName").observe("change", function(){
		if($F("txtFileName").trim() != "" && "#com1##com2##com3##com4##com5##com6##com7##com8##com9##lpt1##lpt2##lpt3##lpt4##lpt5##lpt6##lpt7##lpt8##lpt9##con##nul##prn#".contains("#"+this.value.toLowerCase()+"#")){
			showWaitingMessageBox("The file name you are trying to enter is a reserved word, please enter another filename.", "I", function(){
				$("txtFileName").value = $("txtFileName").getAttribute("lastValidValue");
				$("txtFileName").focus();
			});
		}else if($F("txtFileName").trim() != "" && ($F("txtFileName").indexOf("\\") > -1 ||
												   $F("txtFileName").indexOf("/") > -1 ||
												   $F("txtFileName").indexOf(":") > -1 ||
												   $F("txtFileName").indexOf("*") > -1 ||
												   $F("txtFileName").indexOf("?") > -1 ||
												   $F("txtFileName").indexOf("\"") > -1 ||
												   $F("txtFileName").indexOf("<") > -1 ||
												   $F("txtFileName").indexOf(">") > -1 ||
												   $F("txtFileName").indexOf("|") > -1 )){
			showWaitingMessageBox("A filename cannot contain any of the following characters: \\ / : * ? \" < > |", "I", function(){
				$("txtFileName").value = nvl($("txtFileName").readAttribute("lastValidValue"), "");
				$("txtFileName").focus();
			});
		}else{
			$("txtFileName").writeAttribute("lastValidValue", $F("txtFileName"));
		}
			
	});
	
// 	function fileNameKeyPress(e){
// 		var evtobj = window.event ? event : e;
// 		if(evtobj.keyCode == 220 // for \  
// 				|| evtobj.keyCode == 191 // for / 
// 				|| (evtobj.shiftKey && evtobj.keyCode == 56) // for *
// 				|| (evtobj.shiftKey && evtobj.keyCode == 220) // for |
// 				|| (evtobj.shiftKey && evtobj.keyCode == 188) // for <				
// 				|| (evtobj.shiftKey && evtobj.keyCode == 190) // for >
// 				|| (evtobj.shiftKey && evtobj.keyCode == 191) // for ?
// 				|| (evtobj.shiftKey && evtobj.keyCode == 222) // for "
// 				|| (evtobj.shiftKey && evtobj.keyCode == 59) // for :
// 				){
// 			showWaitingMessageBox("A filename cannot contain any of the following characters: \\ / : * ? \" < > |", "I", function(){
// 				$("txtFileName").value = nvl($("txtFileName").readAttribute("lastValidValue"), "");
// 				$("txtFileName").focus();
// 			});
// 		} else {
// 			this.writeAttribute("lastValidValue", this.value);
// 		}
// 	}
	
// 	$("txtFileName").onkeydown = fileNameKeyPress; 

	$("txtFile").observe("change", function(){
		if (!checkIfFileExtensionValid()){
			showWaitingMessageBox("The file you are trying to upload is not supported.", "I", function(){
				$("txtFileName").value = "";
				$("txtFile").clear();
				$("txtFile").focus();
			});
		}
	});
	
</script>