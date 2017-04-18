<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<div id="attachedMediaMainDiv" style="height: 350px; width: 100%; text-align: center; margin: 8px 0 0 0">
	<div id="attachedMediaDiv" style="height: 320px">
		<div id="attachedMediaTGDiv" style="height: 200px; width: 100%">
			<div id="attachedMediaTG">Attached Media Table Grid Container</div>
		</div>
		<div id="attachedMediaUploadFormDiv" class="sectionDiv" style="height: 135px; width: 99%">
			<form id="uploadForm" name="uploadForm" action="" method="POST" enctype="multipart/form-data" target="uploadTarget">
			<table style="align: center; table-layout: fixed; width: 100%">
				<tr>
					<td class="rightAligned">Browse</td>
					<td class="leftAligned" colspan="2">
						<input type="file" id="txtFile" name="txtFile" class="required" size="40" style="width: 200px" />
						<div id="uploadStatusDiv" style="display: none; padding: 2px; width: 200px; height: 18px; border: 1px solid gray; float: left; background-color: white">
							<span id="progressBar" style="background-color: #66FF33; height: 18px; float: left"></span>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">File Name</td>
					<td class="leftAligned" colspan="2"><input type="text" id="txtFileName" name="txtFileName" class="required" style="width: 200px" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="2">
						<textarea id="txtRemarks" name="txtRemarks" maxlength="4000" style="height: 15px; width: 200px; border: 1px solid gray; resize: none"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="height: 14px; width: 14px; margin: 2px; margin-left: -20px" alt="Edit" id="editRemarks" />
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" style="width: 60px" />
						<input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete" style="width: 60px" disabled="disabled" />
						<input type="button" class="button" id="btnView" name="btnView" value="View" style="width: 60px" disabled="disabled" />
					</td> 
				</tr>
				<c:choose>
					<c:when test="${uploadMode == 'inspection'}">
						<tr>
							<td style="text-align: left; padding-left: 5px">
								<input type="checkbox" id="chkSketchTag" name="chkSketchTag" /> Sketch Tag
							</td>
						</tr>
					</c:when>
				</c:choose>
			</table>
			</form>
			<iframe id="uploadTarget" name="uploadTarget" height="0" width="0" frameborder="0" scrolling="no" style="display: none"></iframe>
			<div id="updaterDiv" name="updaterDiv" style="visibility: hidden; display: none; height: 0; width: 0"></div>
		</div>
	</div>
	<br>
	<input type="button" class="button" id="btnAttach" name="btnAttach" value="Save" style="width: 60px" /> <!-- JET : changed button display name for clarity -->
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 60px" />
</div>

<script type="text/javascript">
	var allowedFileExt = new Array();
	var invalidChars = new Array("<", ">", "'", "*", "?", "\"", "\\", "/", "|", ":", "\u00F1", "\u00D1");
	var objCurrAttachment = null;
	var selectedIndex = null;
	var maxFileSizeInMB = parseInt('${maxFileSizeInMB}');
	var maxFileSizeInBytes = (maxFileSizeInMB * 1024) * 1024;
	var maxPathSizeInMB = parseInt('${maxPathSizeInMB}');
	var maxPathSizeInBytes = (maxPathSizeInMB * 1024) * 1024;
	var attachmentTotalSize = parseInt('${attachmentTotalSize}');
	var curFileSize = 0;
	var totalFilesSize = 0;
	var lineCd = null;
	var genericNo = null;
	var changedTag = false;
	var tempAttachments = [];
	var allowUpload = true;
	
	/** upload mode **/
	if ('${uploadMode}' == "par") {
		lineCd = objUWGlobal.lineCd;
		genericNo = objUWParList.parNo;
	} else if ('${uploadMode}' == "policy") {
		lineCd = objPolicy.lineCd;
		genericNo = objPolicy.parNo;
	} else if ('${uploadMode}' == "clmItemInfo") {
		lineCd = objCLMGlobal.lineCd;
		genericNo = objCLMGlobal.claimNo;
	} else if ('${uploadMode}' == "quotation") {
		lineCd = objGIPIQuote.lineCd;
		genericNo = objGIPIQuote.dspQuotationNo;
	} else if ('${uploadMode}' == "packQuotation") {
		lineCd = objGIPIPackQuote.lineCd;
		genericNo = objCurrPackQuote.quoteNo;
	} else if ('${uploadMode}' == "inspection") {
		lineCd = "";
		genericNo = "";
		if ($("approvedTag").checked) {
			allowUpload = false;
		}
	}
	
	/** functions **/
	
	function resetForm() {
		$("txtFile").enabled = true;
		disableInputField("txtFileName");
		disableInputField("txtRemarks");
		enableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnView");
		enableButton("btnAttach");
		
		if ('${uploadMode}' == "inspection") {
			if (!allowUpload) {
				$("txtFile").disabled = true;
				disableButton("btnAdd");
				disableButton("btnAttach");
				$("chkSketchTag").disabled = true;
			}
			$("chkSketchTag").checked = false;
		}
		
		$("btnAdd").setAttribute("enValue", "add");
		$("btnAdd").value = "Add";
		
		$("editRemarks").hide();
		$("uploadStatusDiv").hide();
		$("txtFile").show();
		
		$("txtFile").clear();
		$("txtFileName").clear();
		$("txtRemarks").clear();
		
		changeTag = 0;
	} resetForm();
	
	function checkInvalidChars(fileName) {
		for (var i = 0; i < invalidChars.length; i++) {
			if (fileName.includes(invalidChars[i])) {
				return invalidChars[i];
			}
		}
	}
	
	function uploadFile() {
		$("uploadTarget").contentWindow.document.body.innerHTML = "";
		$("progressBar").style.width = "0%";
		$("txtFile").hide()
		$("uploadStatusDiv").show();
		
		/* upload file to server */
		$("uploadForm").action = "FileController?action=uploadFile" 
				+ "&uploadMode=" + '${uploadMode}' 
				+ "&genericId=" + '${genericId}' 
				+ "&itemNo=" + '${itemNo}' 
				+ "&saveAs=" + escape($F("txtFileName")) 
				+ "&remarks=" + escape($F("txtRemarks")) 
				+ "&lineCd=" + lineCd
				+ "&genericNo=" + genericNo.replace(/\s+/g, '');
		$("uploadForm").submit()
		
		/* progress */
		updater = new Ajax.PeriodicalUpdater('updaterDiv', 'FileController', {
			asynchronous: true,
			frequency: 0.1,
			method: "GET",
			onSuccess: function(response) {
				if (parseInt(response.responseText) > 1) {
	                $("progressBar").style.width = response.responseText + "%";
	            }
				
				var responseInfo = $("uploadTarget").contentWindow.document.body.innerHTML.stripTags().strip().split("----");
				
				var fileFullPath = responseInfo[0];
				var fileName = responseInfo[1];
				var fileExt = responseInfo[2].toLowerCase();
				var fileSize = responseInfo[3];
				var isSuccess = responseInfo[6];
				
				if (isSuccess == "SUCCESS") {
					updater.stop();
					$("progressBar").style.width = "100%";
					Effect.Fade($("uploadStatusDiv"), {
						duration: 0.5,
						afterFinish: function() {
							$("uploadStatusDiv").hide();
							$("txtFile").show()
							addAttachment(fileFullPath, fileName, fileExt, fileSize);
						}
					});
				} else {
					showMessage(response.responseText, imgMessage.ERROR);
					updater.stop();
				}
			}
		});
	}
	
	function saveAttachments() {
		var setRows = getAddedAndModifiedJSONObjects(attachedMediaTG.geniisysRows);
		var delRows = getDeletedJSONObjects(attachedMediaTG.geniisysRows);
		
		new Ajax.Request(contextPath + "/FileController", {
			method: "POST",
			parameters: {
				action: "saveAttachments",
				uploadMode: '${uploadMode}',
				setRows: prepareJsonAsParameter2(setRows),
				delRows: prepareJsonAsParameter2(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						//attachedMediaTG._refreshList();
						resetForm();
						changedTag = false;
						closeAttachMediaOverlay();
					});
				}
			}
		});
	}
	
	function addAttachment(fileFullPath, fileName, fileExt, fileSize) {		
		var objAttachment = new Object();
		
		objAttachment.id = '${genericId}';
		objAttachment.itemNo = '${itemNo}';
		objAttachment.fileName = fileFullPath;
		objAttachment.realFileName = fileName;
		objAttachment.fileExt = "." + fileExt;
		objAttachment.fileType = ""; // file type is blank since SR-5931
		objAttachment.remarks = escapeHTML2($F("txtRemarks"));
		
		if ('${uploadMode}' == "inspection") {
			objAttachment.sketchTag = $("chkSketchTag").checked ? 'Y' : 'N';
		}
		
		attachedMediaTG.addBottomRow(objAttachment);
		attachmentTotalSize += parseInt(fileSize);
		
		// get added attachments
		var objTempAttachment = {};
		objTempAttachment.path = objAttachment.fileName;
		tempAttachments.push(objTempAttachment);
		
		changedTag = true;
		resetForm();
	}
	
	function updateAttachment() {
		var objAttachment = new Object();
	
		objAttachment = attachedMediaTG.geniisysRows[selectedIndex];
		objAttachment.remarks = escapeHTML2($F("txtRemarks"));
		
		if ('${uploadMode}' == "inspection") {
			objAttachment.sketchTag = $("chkSketchTag").checked ? "Y" : "N";
		}
		
		attachedMediaTG.updateRowAt(objAttachment, selectedIndex);
		changedTag = true;
		resetForm();
	}
	
	function deleteAttachment() {
		if (selectedIndex != null) {
			attachedMediaTG.geniisysRows[selectedIndex].recordStatus = -1;
			attachedMediaTG.deleteRow(selectedIndex);
			
			new Ajax.Request(contextPath + "/FileController", {
				parameters: {
					action: "getFileSize",
					fileFullPath: attachedMediaTG.geniisysRows[selectedIndex].fileName
				},
				onComplete: function(response) {
					var results = JSON.parse(response.responseText);
					attachmentTotalSize -= parseInt(JSON.stringify(results.fileSizeInBytes));
				}
			});
			
			changedTag = true;
			resetForm();
		}
	}
	
	function viewAttachment() {
		var url = "";
		var filePath = unescapeHTML2(attachedMediaTG.geniisysRows[selectedIndex].fileName);
		
		writeFileToServer(filePath);
		
		url = contextPath + filePath.substr(filePath.indexOf("/", 3), filePath.length);
		window.open(escape(unescapeHTML2(url)));
	}
	
	function writeFileToServer(filePath) {
		try {
			new Ajax.Request(contextPath + "/FileController", {
				method: "POST",
				parameters: {
					action: "writeFileToServer",
					filePath: filePath
				}
			});
		} catch(e) {
			showErrorMessage("writeFileToServer", e);
		}
	}
	
	function setAttachmentForm(obj) {
		try {
			resetForm();
			
			$("txtFileName").value = (obj == null ? "" : unescapeHTML2(obj.realFileName));
			$("txtRemarks").value = (obj == null ? "" : unescapeHTML2(obj.remarks));
			$("btnAdd").value = obj == null ? "Add" : "Update";
			$("btnAdd").setAttribute("enValue", obj == null ? "add" : "update");
			
			if ('${uploadMode}' == "inspection") {
				if (obj && obj.sketchTag && obj.sketchTag == 'Y') {
					$("chkSketchTag").checked = true;
				} else {
					$("chkSketchTag").checked = false;
				}
				
				if (obj != null) {
					if (allowUpload) {
						enableInputField("txtRemarks");
						$("editRemarks").show();
						enableButton("btnDelete");
					}
					enableButton("btnView");
				}
			} else {
				if (obj != null) {
					enableInputField("txtRemarks");
					$("editRemarks").show();
					enableButton("btnDelete");
					enableButton("btnView");
				}
			}
		} catch(e) {
			showErrorMessage("setAttachmentForm", e);
		}
	}
	
	function closeAttachMediaOverlay() {
		/* new Ajax.Request(contextPath + "/FileController", {
			parameters: {
				action: "deleteFilesFromServer",
				uploadMode: '${uploadMode}',
				genericId: '${genericId}'
			},
			asynchronous: true,
			evalScripts: true
		}); */
		
		attachMediaOverlay.close();
	}
	
	function cancelAttachments() {
		if (tempAttachments.size() > 0) {
			new Ajax.Request(contextPath + "/FileController", {
				parameters: {
					action: "cancelAttachments",
					tempAttachments: prepareJsonAsParameter2(tempAttachments)
				}
			});
		}
	}
	
	function getAllowedFileExt() {
		new Ajax.Request(contextPath + "/FileController", {
			parameters : {
				action : "getAllowedFileExt"
			},
			onComplete : function(response) {
				parseAllowedFileExt(response.responseText);
			}
		});
	}; getAllowedFileExt();
	
	function parseAllowedFileExt(param) {
		allowedFileExt = param.split(',');
	}
	
	function checkAllowedFileExt(param) {
		var fileExt = param.replace(/\./g, '').toUpperCase();
		for (var i=0; i < allowedFileExt.length; i++) {
			if (fileExt == allowedFileExt[i]) {
				return true;
			}
		}
		return false;
	}
	
	/** events **/
	
	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000);
	});
	
	$("txtFile").observe("change", function() {
		var curFileName = $("txtFile").files[0].name;
		var curFileExt = curFileName.replace(/.*\./, '.').toLowerCase();
		var curFileSize = $("txtFile").files[0].size;
		var isFileExtAllowed = checkAllowedFileExt(curFileExt);
		
		if (checkInvalidChars(curFileName) != null) {
			resetForm();
			showMessageBox("The file name must not contain any of the following characters:  <  >  \'  \"  *  ?  \\  /  |  :  \u00F1  \u00D1", "I");
		} else if (isFileExtAllowed == false) {
			resetForm();
			showMessageBox("The file type you are trying to upload is not supported.", "I");
		} else if (curFileSize > maxFileSizeInBytes) {
			resetForm();
			showMessageBox("The upload limit is only " + maxFileSizeInMB + " MB per file.", "I");
		} else if ((attachmentTotalSize + curFileSize) > maxPathSizeInBytes) {
			resetForm();
			showMessageBox("You have exceeded your maximum allowable upload of " + maxPathSizeInMB + " MB.", "I");
		} else {
			attachedMediaTG.keys.removeFocus(attachedMediaTG.keys._nCurrentFocus);
			$("txtFileName").value = this.value;
			enableInputField("txtRemarks");
			$("txtRemarks").clear();
			$("editRemarks").show();
			disableButton("btnDelete");
			disableButton("btnView");
			$("btnAdd").setAttribute("enValue", "add");
			$("btnAdd").value = "Add";
		}
		enableInputField("txtFileName");
	});
	
	$("btnAdd").observe("click", function() {
		var curFileName = $F("txtFileName");
		var curFileExt = curFileName.replace(/.*\./, '.').toLowerCase();
		var isFileExtAllowed = checkAllowedFileExt(curFileExt);
		
		if ($("btnAdd").getAttribute("enValue") == "add") {
			if ($F("txtFile") == "") {
				showMessageBox("Please select a file.", "I");
			} else if (checkInvalidChars(curFileName) != null) {
				resetForm();
				showMessageBox("The file name must not contain any of the following characters:  <  >  \'  \"  *  ?  \\  /  |  :  \u00F1  \u00D1", "I");
			} else if (isFileExtAllowed == false) {
				resetForm();
				showMessageBox("The file type you are trying to upload is not supported.", "I");
			} else {
				var curFileName = $F("txtFileName");
				var fileExists = false;
				
				for (var i = 0; i < attachedMediaTG.geniisysRows.length; i++) {
					if (attachedMediaTG.geniisysRows[i].recordStatus != -1) {
						if (curFileName == attachedMediaTG.geniisysRows[i].realFileName) {
							fileExists = true;
							break;
						}
					}
				}
				
				if (fileExists) {
					showMessageBox("A file with the same name already exists. Specify a different file name.", "I");
					enableInputField("txtFileName");
					$("txtFileName").focus();
				} else {
					disableButton("btnAdd");
					disableInputField("txtRemarks");
					$("editRemarks").hide();
					uploadFile();
				}
			}
		} else if ($("btnAdd").getAttribute("enValue") == "update") {
			updateAttachment();
		}
	});
	
	$("btnDelete").observe("click", function() {
		if (selectedIndex != null) {
			deleteAttachment();
		}
	});
	
	$("btnView").observe("click", function() {
		if (selectedIndex != null) {
			new Ajax.Request(contextPath + "/FileController", {
				parameters: {
					action: "isFileExists",
					fileFullPath: attachedMediaTG.geniisysRows[selectedIndex].fileName
				},
				asynchronous: true,
				onComplete: function(response) {
					if (JSON.stringify(JSON.parse(response.responseText).isFileExists) == "true") {
						viewAttachment();
					} else {
						showMessageBox("Unable to retrieve attachment, file may have been moved or deleted from the server.", imgMessage.WARNING);
					}
				}
			});
		}
	});
	
	$("btnAttach").observe("click", function() {
		if (changedTag) {
			saveAttachments();
		} else {
			showConfirmBox("Confirmation", "No changes to save, would you like to continue?", "Yes", "No", 
					function() {
						closeAttachMediaOverlay();
					},
					""
				);
		}
	});
	
	$("btnCancel").observe("click", function() {
		if (changedTag) {
			showConfirmBox4("Confirmation", "Would you like to apply changes to attachment records?", "Yes", "No", "Cancel", 
					function(){
						fireEvent($("btnAttach"), "click");
					},
					function(){
						cancelAttachments();
						closeAttachMediaOverlay();
					},
					""
				);
		} else {
			closeAttachMediaOverlay();
		}
	});
	
	// observe escape key
	$(document).observe("keypress", function(e) {
		if (e.keyCode == 27) {
		     cancelAttachments();
		}
	});
	
	/* attached media table grid */
	var objAttachedMedia = JSON.parse('${attachmentsJSON}');
	
	var attachedMediaTGModel = {
			url: contextPath + "/FileController?action=showAttachMediaPage2&refresh=1"
					+ "&uploadMode=" + '${uploadMode}' 
					+ "&genericId=" + '${genericId}' 
					+ "&itemNo=" + '${itemNo}',
			options: {
				title: '',
				height: '200px',
				width: '615px',
				pager: {},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN]
				},
				onRefresh: function() {
					cancelAttachments();
					changedTag = false;
				},
				onCellFocus: function(element, value, x, y, id) {
					selectedIndex = y;
					objCurrAttachment = attachedMediaTG.geniisysRows[selectedIndex];
					setAttachmentForm(objCurrAttachment);
				},
				onRemoveRowFocus: function() {
					selectedIndex = null;
					objCurrAttachment = null;
					setAttachmentForm(null);
				}
			},
			columnModel: [{
					id: 'recordStatus',
					width: '0',
					visible: false
				}, {
					id: 'divCtrId',
					width: '0',
					visible: false
				}, {
					id: 'id',
					width: '0',
					visible: false
				}, {
					id: 'itemNo',
					width: '0',
					visible: false
				}, {
					id: 'fileName',
					width: '0',
					visible: false
				}, {
					id: 'realFileName',
					title: 'File Name',
					width: '178px',
					sortable: false
				}, {
					id: 'fileExt',
					width: '0',
					visible: false
				}, {
					id: 'fileType',
					width: '0',
					visible: false
				}, {
					id: 'remarks',
					title: 'Remarks',
					width: '378px',
					sortable: false
				}, {
					id: 'sketchTag',
					title: 'S',
					width: '20px',
					sortable: false,
					visible: ('${uploadMode}' == "inspection") ? true : false
				}],
			rows: objAttachedMedia.rows
	};
	
	attachedMediaTG = new MyTableGrid(attachedMediaTGModel);
	attachedMediaTG.pager = objAttachedMedia;
	attachedMediaTG.render('attachedMediaTG');
</script>