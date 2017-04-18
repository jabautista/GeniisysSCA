<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="contentsDiv">
	<div id="attachmentListMainDiv" style="padding: 5px; margin-top: 10px; margin-bottom: 10px; float: left; width: 98%;" class="sectionDiv">
		<div id="attachmentListDiv">
			<div id="attachmentListTableDiv" style="text-align: center;">
				<div id="attachMediaTableGrid" style="height: 175px; width: 587px;"></div>
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
						<td class="leftAligned"><input type="text" id="txtFileName" name="txtFileName" style="width: 335px;" class="required"></td>
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
					<tr></tr>
					<tr>
						<td class="rightAligned">Sketch Tag</td>
						<td class="leftAligned"><input type="checkbox" id="sketchTag" name="sketchTag"></td>
					</tr>	
				</table>
			</form>
			<iframe id="uploadTarget" name="uploadTarget" height="0" width="0" frameborder="0" scrolling="no" style="display: none;"></iframe>
			<div id="updaterDiv" name="updaterDiv" style="visibility: hidden; display: none; height: 0; width: 0"></div>
			<div style="float: left; width: 100%;">
				<table align="center">
					<tr>
						<td>
							<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" enValue="Add"/>
							<input type="button" class="button" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
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
					<input type="button" class="button" style="width: 90px;" id="btnAttach" name="btnAttach" value="Attach" />
					<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	var supportedFiles = new Array(".gif", ".png", ".jpg", ".jpeg", ".bmp", ".mpeg", ".mpg", ".mp4", ".avi", ".3gp", ".3gpp", ".wmv",".flv", ".pdf");
	var invalidChars = new Array("<", ">", "'", "*", "?", "\"", "\\", "/", "|", ":");
	var directory = "";
	var attachmentChangeTag = 0;
	$("overlayTitleDiv").hide();
	try{
		var attachMediaArray = [];
		var objAttachMedia = new Object();
		var objParameters = new Object();
		objAttachMedia.objAttachMediaTableGrid = JSON.parse('${objAttachMedia}');  //.replace(/\\/g, '\\\\')
		objAttachMedia.attachMedia = objAttachMedia.objAttachMediaTableGrid.rows || [];
		
		var attachMediaTableModel = {
			url : contextPath+"/GIPIInspectionReportAttachedMediaController?action=showAttachMedia&genericId=" + objUW.hidObjGIPIS197.id + "&itemNo=" + objUW.hidObjGIPIS197.itemNo,
			options: {
				height: '150px',
				width: '587px',
				onCellFocus: function(element, value, x, y, id){
					var obj = attachMediaTableGrid.geniisysRows[y];
					selectedIndex=y;
					formatAppearance("show",obj);
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					formatAppearance();
				},
				onSort: function() {
					formatAppearance();
				},
				beforeSort: function(){
// 					if(changeTag == 1){
// 						showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
// 								function(){
// 									pAction = pageActions.reload;
// 									saveGIPIWPolWC();
// 								}, function(){
// 									showWPolicyWarrantyAndClausePage();
// 									changeTag = 0;
// 								}, "");
// 						return false;
// 					}else{
// 						return true;
// 					}
				},
				postPager: function () {
					formatAppearance();
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
					width: '250px',
					align: 'left'
				},
				{
					id: 'remarks',
					title: 'Remarks',
					width: '290px',
					align: 'left'
				},
				{
					id: 'tbgSketchTag',
					title: 'S',
					width: '30px',
					tooltip: 'S',
					align: 'center',
					titleAlign: 'center',
					editable: false,
					editor:	 'checkbox',
					sortable:false
				}
			],
			rows: objAttachMedia.attachMedia
		};
		
		attachMediaTableGrid = new MyTableGrid(attachMediaTableModel);
		attachMediaTableGrid.pager = objAttachMedia.objAttachMediaTableGrid;
		attachMediaTableGrid.render('attachMediaTableGrid');
		attachMediaTableGrid.afterRender = function(){
														attachMediaArray=attachMediaTableGrid.geniisysRows;
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
			$("btnAdd").value="Update";
			populateDetails(obj);
		}else{
			$("txtFile").enable();
			$("txtFileName").enable();
			disableButton("btnView");
			$("btnAdd").value="Add";
			populateDetails(null);
			selectedIndex = null;
		}
	}
	
	function populateDetails(obj) {
		$("txtFileName").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.fileName2,""));
		$("txtRemarks").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.remarks,""));
		$("sketchTag").checked 			= obj			== null ? "" : nvl(obj.tbgSketchTag,"");
	}
	
	function checkIfFileExtensionValid(){
		var isValid = false;
		var fileExt = $F("txtFileName").substr($F("txtFileName").indexOf("."), $F("txtFileName").length - 1);
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
			if ($F("txtFileName").indexOf(invalidChars[i]) > -1) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}
	
	
	function setObj() {
		var obj = new Object();
		obj.fileName2 = $F("txtFileName");
		obj.remarks = $F("txtRemarks");
		obj.sketchTag = $("sketchTag").checked ? "Y": "N";
		obj.tbgSketchTag=$("sketchTag").checked ? true : false;
		obj.id = objUW.hidObjGIPIS197.id;
		obj.itemNo = removeLeadingZero(objUW.hidObjGIPIS197.itemNo);
		return obj;
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
					newObj.url = contextPath+"/"+result.uploadPath.replace(/\\/g, "/") + "/"+ result.fileName;
					newObj.fileName = result.filePath + "/"+ result.fileName;
					newObj.recordStatus = 0;
					attachMediaArray.push(newObj);
					attachMediaTableGrid.addBottomRow(newObj);
				}
				directory = newObj.fileName;
				attachmentChangeTag = 1;
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
			formatAppearance();	
		} else {
			showMessageBox("Please select a record to delete.", imgMessage.INFO);
		}
	}	
	
	function uploadFile(){
		try {
			$("uploadTarget").contentWindow.document.body.innerHTML = "";
			$("progressBar").style.width = "0%";
			$("uploadForm").action= "GIPIInspectionReportAttachedMediaController?action=uploadFile&genericId="+objUW.hidObjGIPIS197.id+"&itemNo="+objUW.hidObjGIPIS197.itemNo+"&uploadMode=inspection&"+ fixTildeProblem(Form.serialize("uploadForm"));
	    	$("uploadForm").submit();
			
	    	 updater = new Ajax.PeriodicalUpdater('updaterDiv','GIPIInspectionReportAttachedMediaController', {
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
		new Ajax.Request(contextPath+"/GIPIInspectionReportAttachedMediaController", {
			method: "POST",
			parameters : {action : "deleteFileDirectoryFromServer",
						  directory : directory},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					
				}
			}
		});
	}	
	
	function saveAttachments(){
		try{
			new Ajax.Request(contextPath + "/GIPIInspectionReportAttachedMediaController", {
				method : "POST",
				parameters : {action : "saveInspectionAttachments",
							  param: JSON.stringify(objParameters)},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						attachmentChangeTag=0;
						showWaitingMessageBox("Attachment finished.", imgMessage.INFO, objUW.hidFuncGIPIS197.reloadInspectionReport);
					}
				}
			});
		}catch(e){
			showErrorMessage("saveAttachments",e);
		}
	}
	
	function writeFilesToServer(){
		try{
			new Ajax.Request(contextPath+"/GIPIInspectionReportAttachedMediaController", {
				method: "POST",
				parameters : {action : "writeFilesToServer",
							  files : prepareJsonAsParameter(attachMediaTableGrid.geniisysRows)},
			  onCreate:function(){
					showNotice("Saving Attached Media, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						objAttachment = {};
						objAttachment.onAttach = function(files){
							objParameters.setAttachRows = getAddedAndModifiedJSONObjects(files);
							objParameters.delAttachRows = getDeletedJSONObjects(files);
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
			var fileName = attachMediaArray[selectedIndex].fileName;
			url = contextPath + fileName.substr(fileName.indexOf("/", 3), fileName.length);
		} else {
			url = attachMediaArray[selectedIndex].url;
		} 
		window.open(url);
	}
	
	/* observe */
	$("btnAdd").observe("click", function(){
		if($("btnAdd").value==="Add") {
			if(checkAllRequiredFieldsInDiv("attachmentFormDiv")) {
				if (!checkIfFileExtensionValid()){
					showMessageBox("The file you are trying to upload is not supported. Please attach video or picture files only.", imgMessage.ERROR);
				}else if (!checkFileNameCharValid()){
					showMessageBox("A filename cannot contain any of the following characters: \ / : * ? | \" \' .", imgMessage.ERROR);
				}else{
					$("txtFile").hide();
	 				$("uploadStatusDiv").show();
	 				uploadFile();
				}
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
		$("txtFileName").value = this.value;
	});
	
	$("txtRemarks").observe("keyup", function(){
		limitText(this, 4000);
	});
	
	$("editRemarks").observe("click", function(){
		if ($("approvedTag").checked){
			showOverlayEditor("txtRemarks", 4000,"true"); //Lara - 10-01-2013 for Mantis 802
		}else{
			showOverlayEditor("txtRemarks", 4000,"false");
		}
	});	
	
	$("btnCancel").observe("click",function(){
		if(attachmentChangeTag == 1){
			showConfirmBox4("Confirmation", "Would you like to apply changes to attachment records?", "Yes", "No", "Cancel", 
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
		changeTag = 0; //added by robert 01.22.2014
		deleteFileDirectoryFromSever();
	});
	
	$("btnAttach").observe("click", function(){
		var setRows = attachMediaArray;
		
		if(setRows.length == 0){
			showConfirmBox("Confirmation", "No files to attach, would you like to continue?", "Yes", "No", 
				function() {
				overlayAttachedMedia.close();
				},
				""
			);
		} else {
			if(objAttachment.onAttach){
				objAttachment.onAttach(setRows);
			}
			overlayAttachedMedia.close();
		}
		attachMediaTableGrid.keys.releaseKeys();
		deleteFileDirectoryFromSever();
	});
	
	try{ //added by steven 9/3/2012
		if ($("approvedTag").checked){
			$("txtFile").disable();
			$("sketchTag").disable();
			$("txtFileName").readOnly = true;
			$("txtRemarks").readOnly = true;
			disableButton("btnAdd");
			disableButton("btnDelete");
			disableButton("btnAttach");
		} 
	}catch (e) {
		showErrorMessage("Disable Fields",e);
	}
	
</script>