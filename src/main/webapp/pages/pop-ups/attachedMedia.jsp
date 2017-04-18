<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<span class="notice" id="noticePopup" name="noticePopup" style="display: none;"></span>
<span id="closer" name="closer" style="display: none; cursor: pointer; position: absolute; right: 10px; top: -5px; padding: 3px; border: 1px solid #c0c0c0; background-color: #c0c0c0; font-size: 9px; z-index: 100; margin: 5px; -moz-border-radius-topright: 5px; -moz-border-radius-bottomright: 5px;" onclick="hideVideo();">X</span>
<div id="videoHolder" name="videoHolder" style="display: none; width: 480px; height: 270px; position: absolute; top: 0px; left: 30px; border: 5px solid #c0c0c0; z-index: 50;"></div>

<div name="mediaMainDiv" id="mediaMainDiv" style="margin-top: 1px;" class="sectionDiv">	
	<form name="filesForm" id="filesForm">
		<input type="hidden" id="uploadMode" name="uploadMode" value="${mode}">
		
		<div id="fileTable" name="fileTable" style="margin: 10px;" ">
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; margin-left: 5px;">Files</label>
			</div>
			<div id="forDeletionDiv" name="forDeletionDiv" style="display: none; visibility: hidden;">
			</div>
			<div id="newUploadDiv" name="newUploadDiv" style="display: none; visibility: hidden;">
			</div>
			<div class="tableContainer" id="fileListing" name="fileListing" style="display: block;">
				<c:forEach var="m" items="${media}" varStatus="ctr"> 
					<div id="rowMedia${ctr.count}" name="rowMedia" style="margin-left: 2px; height: 65px; border-bottom: 1px solid #c0c0c0; display: block;"> <%-- from rowMedia${m.fileName} to rowMedia${ctr.count} Halley 10.25.13 --%>
						<input type="hidden" id="hidFileName" 		 name="hidFileName" 	value="${m.fileName}" />
						<input type="hidden" id="hidFileType" 		 name="hidFileType" 	value="${m.fileType}" />
						<input type="hidden" id="hidFileExt" 		 name="hidFileExt" 		value="${m.fileExt}" />
						<input type="hidden" id="hidRemarks" 		 name="hidRemarks" 		value="${m.remarks}" />
						<input type="hidden" id="hidFilePath" 		 name="hidFilePath"		value="${mediaPath[ctr.count]}" />
						<input type="hidden" id="hidMediaLink" 		 name="hidMediaLink"	value="${mediaLinks[ctr.count]}" />
						<input type="hidden" id="hidFileSize" 		 name="hidFileSize"		value="${mediaSizes[ctr.count]}" />  
						<c:if test="${'policy' eq mode or 'extract' eq mode}">
							<input type="hidden" id="hidPolFileName" name="hidPolFileName" 	value="${m.polFileName}" />
						</c:if>
						<c:if test="${'policy' eq mode}">
							<input type="hidden" id="hidArcExtData"  name="hidArcExtData" 	value="${m.arcExtData}" />
						</c:if>
						<c:choose>
							<c:when test="${m.fileType eq 'P'}">
								<img src="${mediaLinks[ctr.count]}" width="55" height="55" border="0" alt="" style="margin: 5px 0px 2px 5px; float: left; display: block;" />
							</c:when>
							<c:when test="${m.fileType eq 'D'}">
								<img src="${pageContext.request.contextPath}/images/misc/document.png" width="55" height="55" border="0" alt="" style="margin: 5px 0px 2px 5px; float: left; display: block;" />
							</c:when>
							<c:when test="${m.fileType eq 'V'}">
								<img src="${pageContext.request.contextPath}/images/misc/video.png" width="55" height="55" border="0" alt="" style="margin: 5px 0px 2px 5px; float: left; display: block;" onclick="showVideo('${mediaLinks[ctr.count]}');" />
							</c:when>
						</c:choose>
						<span style="float: left; position: relative; width: 85%; line-height: 1.5em; margin: 5px 0px 0px 5px; display: block;">
							<span id="deleteSpan" name="deleteSpan" style="float: right; margin-right: 2px; display: none; color: #fff; border: 1px solid transparent;">
								<label id="delete" name="delete" style="text-align: center; width: 46px;">Delete</label>
							</span>
							<%-- <label><strong title=" ">File Name: </strong><a href="${mediaLinks[ctr.count]}" target="blank" title="Right click then save as." style="text-decoration: none; color: black;">${m.fileName}</a></label> <br /> --%>
							<label><strong title=" ">File Name: </strong><a id="linkFile" href="" target="blank" title="Right click then save as." style="text-decoration: none; color: black;">${m.fileName}</a></label> <br />
							<label><strong title=" ">Size: </strong></label><label id="size${m.fileName}" name="size" style="margin-left: 5px;" title=" ">${mediaSizes[ctr.count]}</label> <br />
							<div name="mediaRemarks" id="mediaRemarks" style="display: block; float: left; margin: 2px; width: 90%;">
								<label><strong title=" ">Remarks: </strong></label>
								<div id="withRemarks" name="withRemarks">
									<label id="lblRemarks${m.fileName}" name="lblRemarks" style="border: 1px solid transparent; cursor: text; padding-left: 3px; float: left; width: 79%; margin-left: 5px; color: black;">${m.remarks}</label>
								</div>
								<div id="editRemarks" name="editRemarks">
				 				 	<input type="text" id="inputRemarks${m.fileName}" name="inputRemarks" maxlength="4000" style="float: left; padding-left: 3px; width: 79%; margin-left: 5px;"/>
								</div>
							</div>						 
						</span>
					</div>
				</c:forEach>
			</div>
		</div>
	</form>

	<iframe id="uploadTarget" name="uploadTarget" height="0" width="0" frameborder="0" scrolling="yes"></iframe>
	
	<div id="attachedMediaForm" style="margin: 5px;" align="center">
		<form id="uploadForm" name="uploadForm" enctype="multipart/form-data" method="POST" action="" target="uploadTarget">
			<div id="inputsDiv" name="inputsDiv" style="float: left; width: 100%;" align="center">
				<table align="center">
					<tr>
						<td class="rightAligned">Browse</td>
						<td class="leftAligned"><input type="file" name="file" id="file" class="required" style="margin-bottom: 5px; margin-left: 5px;" size="34" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Save as</td>
						<td class="leftAligned"><input type="text" value="" id="saveAs" class="required" name="saveAs" maxlength="30" style="width: 298px; margin-bottom: 5px; margin-left: 5px;" /></td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned"><input type="text" value="" id="remarks" name="remarks" maxlength="4000" style="width: 298px; margin-bottom: 5px; margin-left: 5px;" /></td>
					</tr>
					<tr>
						<td class="rightAligned"></td>
						<td class="leftAligned">
							<input type="button" class="button" id="btnUpload" name="btnUpload" value="Upload" style="width: 60px; margin-left: 5px;"/>
							<input type="button" class="button" id="btnReset" name="btnReset" value="Reset" style="width: 60px;"/>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</div>

<div class="buttonsDivPopup">
	<input id="btnCancel" class="button" type="button" value="Cancel" style="width: 90px;" />
	<input id="btnSave" class="button" type="button" value="Save" style="width: 90px;" />
</div>
	
<script type="text/javascript">	

	var picExtArray = new Array(".gif", ".png", ".jpg", ".jpeg", ".bmp", ".ani");
	var docExtArray = new Array(".doc", ".xls", ".pdf", ".txt", ".ods", ".odt", ".docx", ".ppt");
	var vidExtArray = new Array(".mpeg", ".mpg", ".mp4", ".avi", ".3gp", ".3gpp", ".wmv");
	var invalidChars = new Array("<", ">", "'", "*", "?", "\"", "\\", "/", "|", ":");  //Halley 10.18.13
	var mode		= $F("uploadMode");
	//var allowUpload = false;  //moved to checkFile() - Halley 10.18.13
	var editMode 	= false;

	$("btnSave").observe("click", saveFiles);

	$("btnCancel").observe("click", function () {
		Modalbox.hide();
	});
	
	$("btnUpload").observe("click", function () {
		if ($F("uploadMode") == "inspection"){ //block for inspection report attach media
			if ($F("approvedTag") == "A"){
				showMessageBox("You cannot make attachments.", imgMessage.ERROR);
				return false;
			} else {
				checkFile();
			}
		} else {
			checkFile();
		}
	});

	$("btnReset").observe("click", function () {
		resetForm();
	});	

	$$("label[name='size']").each(function (lbl){
		var id = lbl.getAttribute("id");
		$(id).update(convertByteSize($(id).innerHTML));
	});
	
	function initializeObservers(){	
		try {
			
			$$("label[name='lblRemarks']").each(function(lbl) {
				var id = lbl.getAttribute("id");
				$(id).update($(id).innerHTML.truncate(40, "..."));
			});
			
			
			$$("div[name='mediaRemarks']").each(function(div) {
				var label = div.down("div", 0).down("label");
				
				div.down("div", 1).hide();
		
				div.observe("mouseover", function() {
					if(false == editMode){
						var remarks = label.innerHTML;
			            if ("" == remarks.trim()){
			            	label.innerHTML = "Write Remarks...";
			            	label.setStyle({backgroundColor: "white"});
			            }
			            label.setStyle({border: "1px solid #c0c0c0",
				            			color: "#666666"});
					}
				});
		
				div.observe("mouseout", function() {
					if(false == editMode){
						var remarks = label.innerHTML;
						if ("Write Remarks..." == remarks.trim()){
							label.innerHTML = "";
						}
			        	label.setStyle({border: "1px solid transparent",
										color: "black",
										backgroundColor: ""});			
					}
				});
								
				div.observe("click", function(){
					editMode = true;
					div.down("div", 0).hide();
					div.down("div", 1).show();
					div.down("div", 1).down("input").focus();
				});
			});
			
			$$("div[name='rowMedia']").each(function (row) {
				var rowInputRemarks = row.down("input", 3);
				var labelDelete 	= row.down("span").down("span").down("label");
				var inputRemarks 	= row.down("span").down("div").down("div", 1).down("input");
				var fileIcon		= row.down("img"); 
				var fileType  		= row.down("input", 1).value;
				var mediaLink 		= row.down("input", 5).value;
				
				//added by Halley 10.31.2013
				var imgPath 		= "";   
				if ("V" == fileType) {
	            	imgPath = contextPath+"/images/misc/video.png";
	            } else if ("D" == fileType) {
	        		imgPath = contextPath+"/images/misc/document.png";  
	           	} else if ("P" == fileType){
	               	imgPath = mediaLink;
	           	}
				row.down("a", 0).setAttribute("href", escape(mediaLink));
				row.down("img", 0).setAttribute("src", escape(imgPath));
				//end 10.31.2013
							
				row.observe("mouseover", function () {
					if(false == editMode){
			            row.addClassName("lightblue");
			            row.down("span").down("span").show();
					}
		        });
		
		        row.observe("mouseout", function () {
		        	if(false == editMode){
		            	row.removeClassName("lightblue");
		               	row.down("span").down("span").hide();
		        	}
		        });
	
				fileIcon.observe("click", function() {	
					if("P" == fileType){
						showMedia(fileIcon);
					} else if ("V" == fileType) {
						showVideo(mediaLink);
					} 
				});
				
				labelDelete.observe("click", function () {
					var rowFileName = row.down("input", 0).value; 
					//rowId = "rowMedia"+rowFileName; 	//removed - Halley 10.25.13
					rowId = row.id; 					//replacement - Halley 10.25.13
					
					$$("div[name='rowMedia']").each(function (row){
						if (row.getAttribute("id") == rowId) {
							Effect.Fade(row, {
								duration: .5,
								afterFinish: function () {
									row.remove();
									addFileForDeletion(rowFileName);
									checkIfToResizeFileTable("fileListing", "rowMedia");
									//checkTableIfEmptyinModalbox("row", "fileTable");
								}
							});
						}	
					});
				});
	
				inputRemarks.observe("blur", function(){
					leaveInputRemarks(inputRemarks, rowInputRemarks);
					editMode = false;
				});
		
				inputRemarks.observe("keypress", function(e){
					if(13 == e.keyCode){
						leaveInputRemarks(inputRemarks, rowInputRemarks);
						editMode = false;
					}
				});
				
				inputRemarks.observe("focus", function(){
					var rowRemarks	= row.down("input", 3).value;
					inputRemarks.value = rowRemarks;
					inputRemarks.select();
				});
			});
		
			$$("span[name='deleteSpan']").each(function (del) {
				del.observe("mouseover", function () {
		            del.setStyle({border: "solid 1px #c0c0c0",
		                		  backgroundColor: "gray"});
		        });
		
		        del.observe("mouseout", function () {
		            del.setStyle({border: "1px solid transparent",
		      		  		      backgroundColor: ""});
		        });
			});
		} catch(e) {
			showErrorMessage("initializeObservers", e);
		}
	}  
	
	function checkFile(){	
		if ($F("file").blank()) {
			showNoticeInPopup("Select a file first.");
			return false;
		} else if ($F("saveAs").blank()) { //added condition - Halley 10.18.13
			showNoticeInPopup("Required fields must be entered.");
			$("saveAs").focus();
			return false;
		} else if ($F("saveAs").include("\u00F1") || $F("saveAs").include("\u00D1")) {
			showNoticeInPopup("\u00D1 or \u00F1 not allowed for file name.");
			return false;
		} else if (!checkFileNameCharValid()) {  //added condition - Halley 10.18.13
			showNoticeInPopup("A filename cannot contain any of the following characters: \ / : * ? | \" \' .");
			return false;
		}

		var fileTemp = $("file");  
		var file     = fileTemp.files[0];
		var saveAs 	 = $F("saveAs");
		//var filePath = $F("file");  //removed 
		var filePath = $F("saveAs");  //replacement - Halley 10.18.13
		//var ext 	 = filePath.slice(filePath.lastIndexOf(".")).toLowerCase();  	//removed
		var ext 	 = filePath.substr(filePath.lastIndexOf("."), filePath.length - 1).toLowerCase(); //replacement - Halley 10.18.13 toLowerCase Gzelle 12112014
		var fileType = "";
		var allowUpload = false;

		var exists = false;
		
		//Halley 10.25.13 - to not use fileName as the div id of rowMedia since it's having problems in 
		//initializeObservers() when fileName has special characters
		var count = 1;
		var rowId = null;
		$$("div[name='rowMedia']").each(function (row){
			rowId = count++;
		});
		rowId = rowId + 1;
		//end
		
		$$("input[name='hidFileName']").each(function (h){
			if (h.value == (saveAs == "" ? file.fileName : saveAs)){
				exists = true;
			}  
		});

		var totalSize = 0;
		$$("input[name='hidFileSize']").each(function(size){
			totalSize += parseFloat(size.value);
		});
					
		for(var i = 0; i < picExtArray.length; i++){
			if(ext == picExtArray[i]){
				allowUpload = true;
				fileType = "P";
				break;
			}
		}

		if (allowUpload == false){
			for(var i = 0; i < docExtArray.length; i++){
				if(ext == docExtArray[i]){
					allowUpload = true;
					fileType = "D";
					break;
				}
			}		
		}

		if (allowUpload == false){
			for(var i = 0; i < vidExtArray.length; i++){
				if(ext == vidExtArray[i]){
					allowUpload = true;
					fileType = "V";
					break;
				}
			}
		}
				
		if(!allowUpload){
			showNoticeInPopup("The type of file you are trying to upload is not supported.");
			$("file").focus();
			return;
		} else if (file.fileSize == 1048576) {
			showNoticeInPopup("File size is too large. The maximum file size you can upload is 1 MB.");
			$("file").focus();
			return;
		} else if ((totalSize + file.fileSize) > 3145728){
			showNoticeInPopup("You've exceeded your maximum allowable uploads of 3MB.");
			$("file").focus();
			return;
		} else if (exists){
			showNoticeInPopup("A file with the same name already exists. Specify a different file name.");
			$("saveAs").focus();
			return;			
		} else {
			uploadFile(saveAs, ext, file.size, fileType, rowId);  //modified by Halley 10.25.13
			hideNoticeInPopup();
		}
	} 

	function convertByteSize(fileSize){
		var megaByte = 1048576; 
		var kiloByte = 1024;
		var fileSizeUnit = "";
		
		if(fileSize > megaByte){
			fileSize = Math.round(fileSize/megaByte);
			fileSizeUnit = " MB";
		} else if(fileSize > kiloByte){
			fileSize = Math.round(fileSize/kiloByte);
			fileSizeUnit = " KB";
		} else {
			fileSizeUnit = " bytes";
		}
		return fileSize + fileSizeUnit;
	}
	
	function leaveInputRemarks(inputRemarks, rowInputRemarks){
		$(rowInputRemarks).value = $F(inputRemarks);
		inputRemarks.up("div").previous("div").show();
		inputRemarks.up("div").previous("div").down("label").update($F(inputRemarks).truncate(40, "..."));
		inputRemarks.up("div").hide();
		
		var label = inputRemarks.up("div").previous("div").down("label");
		var row = inputRemarks.up("div").up("div").up("span").up("div"); 
		var remarks = label.innerHTML;
		
		if ("Write Remarks..." == remarks.trim()){
			label.innerHTML = "";
		}

    	row.removeClassName("lightblue");
       	row.down("span").down("span").hide();
		
    	label.setStyle({border: "1px solid transparent",
						color: "black",
						backgroundColor: ""});
	}
	
	function resetForm(){
		$("file").value    = "";
		$("saveAs").value  = "";
		$("remarks").value = "";
    	$("uploadForm").enable();
    	$("filesForm").enable();
    	/*$("btnUpload").removeClassName("disabledButton");
    	$("btnReset").removeClassName("disabledButton");
    	$("btnUpload").addClassName("button");
    	$("btnReset").addClassName("button");*/
    	enableButton("btnUpload");
    	enableButton("btnReset");
        $("uploadTarget").contentWindow.document.body.innerHTML = "";
        //$("innerDiv").down("label", 0).update(content[0] + " - " + content[1]);
        editMode = false;
        //new Effect.Highlight("innerDiv");
	}

	function addFileForDeletion(fileName){
		var forDeletionDiv  = $("forDeletionDiv");
		var forDeletion 	= new Element("input");
		
		forDeletion.setAttribute("id", "delFileName"+fileName);
		forDeletion.setAttribute("name", "delFileName");
		forDeletion.setAttribute("type", "hidden");
		forDeletion.setAttribute("value", fileName);

		forDeletionDiv.insert({bottom: forDeletion});
	}

	function addNewUpload(fileName){
		var newUploadDiv = $("newUploadDiv");
		var newUpload 	 = new Element("input");
		
		newUpload.setAttribute("id", "delFileName"+fileName);
		newUpload.setAttribute("name", "delFileName");
		newUpload.setAttribute("type", "hidden");
		newUpload.setAttribute("value", fileName); 

		newUploadDiv.insert({bottom: newUpload});
	}
	
	function uploadFile(saveAs, fileExt, fileSize, fileType, rowId){
		try{
			var fileName = saveAs; //modified by Halley 10.25.13
			var remarks = $F("remarks");
			var mediaDiv = $("fileListing");
			var uploadContent = '<label>'+fileName+'</label>'+  
								'<label style="margin-left: 5px;">'+convertByteSize(fileSize)+'</label>'+ 
						  		'<div id="uploadStatusDiv" style="padding: 2px; margin-left: 5px; width: 100px; height: 12px; border: 1px solid gray; float: left; background-color: white;">'+
						  		'<span id="progressBar" style="background-color: #66FF33; height: 12px; float: left;"></span>'+
								'</div>'+
								'<div id="updaterDiv" name="updaterDiv" style="margin-left: 2px; visibility: hidden;"></div>';
			var uploadDiv = new Element("div");
			uploadDiv.setAttribute("id", "uploadDiv");
			uploadDiv.setAttribute("name", "row");
			uploadDiv.setStyle("margin-top: 10px;");
			uploadDiv.update(uploadContent);
			
			mediaDiv.insert({bottom: uploadDiv});
			var height = mediaDiv.offsetHeight + 25;
			mediaDiv.setStyle("height: " + height + "px;");
			Modalbox.resizeToContent();
			mediaDiv.scrollTop = mediaDiv.scrollHeight;

			var id = getGenericId($F("uploadMode"));
			var itemNo = $("itemNo") ? $F("itemNo") :$F("txtItemNo");
			//$("uploadForm").action = "FileController?action=uploadFile&genericId="+id+"&itemNo="+itemNo+"&uploadMode="+$F("uploadMode")+"&"+ fixTildeProblem(Form.serialize("uploadForm")); //removed
			$("uploadForm").action = "FileController?action=uploadFile&genericId="+id+"&itemNo="+itemNo+"&uploadMode="+$F("uploadMode")+"&saveAs="+escape($F("saveAs"))+"&remarks="+$F("remarks");    //replacement - Halley 10.21.13
	    	$("uploadForm").submit();
	    	$("uploadForm").disable();
	    	$("filesForm").disable();

	    	disableButton("btnUpload");
	    	disableButton("btnReset");
	    	
	    	/*$("btnUpload").removeClassName("button");
	    	$("btnReset").removeClassName("button");
	    	$("btnUpload").addClassName("disabledButton");
	    	$("btnReset").addClassName("disabledButton");*/
	    	editMode = true;
	    	
            updater = new Ajax.PeriodicalUpdater('updaterDiv','FileController', {
                asynchronous: true, 
                frequency: 0.1, 
                method: "GET",
                onSuccess: function(response) {
                    if (parseInt(response.responseText) > 1) {
                        $("progressBar").style.width = response.responseText + "%";
                    }

                    var content = $("uploadTarget").contentWindow.document.body.innerHTML.stripTags().strip().split("----");
                    if (content[6] == "SUCCESS") {
                    	updater.stop();
                    	$("progressBar").style.width = "100%";
						
                    	Effect.Fade($("uploadDiv"), {
							duration: .5,
							afterFinish: function () {
                    			$("uploadDiv").remove();
						
								fileName = content[1];
								var filePath = content[0];
								var polFileName = "";
								var arcExtData = "";
		                    	var imgPath = "";
		                    	var mediaLink = content[5]+"/"+content[1];  //Halley 10.31.13
		
		                        if ("V" == fileType) {
		                        	imgPath = contextPath+"/images/misc/video.png";
		                        } else if ("D" == fileType) {
		                    		imgPath = contextPath+"/images/misc/document.png";  
			                   	} else if ("P" == fileType){
			                       	imgPath = content[5]+"/"+content[1];
			                   	}
		                        
								var divContent = '<input type="hidden" id="hidFileName" 	name="hidFileName" 		value="'+fileName+'" />'+  
												'<input type="hidden" id="hidFileType" 		name="hidFileType" 		value="'+fileType+'" />'+
												'<input type="hidden" id="hidFileExt" 		name="hidFileExt" 		value="'+fileExt+'" />'+
												'<input type="hidden" id="hidRemarks" 		name="hidRemarks" 		value="'+escapeHTML2(remarks)+'" />'+   /* added escapeHTML2 - Halley 10.21.13 */
												'<input type="hidden" id="hidFilePath" 		name="hidFilePath"		value="'+filePath+'" />'+
												'<input type="hidden" id="hidMediaLink"		name="hidMediaLink"		value="'+mediaLink+'" />'+  /* imgPath halley test*/
												'<input type="hidden" id="hidFileSize"		name="hidFileSize"		value="'+fileSize+'" />'+
												'<input type="hidden" id="hidPolFileName" 	name="hidPolFileName" 	value="'+polFileName+'" />'+
												'<input type="hidden" id="hidArcExtData"  	name="hidArcExtData" 	value="'+arcExtData+'" />';
												if ("P" == fileType) {
													divContent += '<img src="'+escape(imgPath.replace(/&amp;/g, '&'))+'" width="55" height="55" border="0" alt="" style="margin: 5px 0px 2px 5px; float: left; display: block;" />';  /* modified - Halley 10.31.13 */
												} else if("D" == fileType) {
													divContent += '<img src="'+imgPath+'" width="55" height="55" border="0" alt="" style="margin: 5px 0px 2px 5px; float: left; display: block;" />';
												} else if ("V" == fileType) {
													divContent += '<img src="'+imgPath+'" width="55" height="55" border="0" alt="" style="margin: 5px 0px 2px 5px; float: left; display: block;" />';
												} 
												
								  divContent += '<span style="float: left; position: relative; width: 85%; line-height: 1.5em; margin: 5px 0px 0px 5px; display: block;">'+
												'<span id="deleteSpan" name="deleteSpan" style="float: right; margin-right: 2px; display: none; color: #fff;">'+
												'<label id="delete" name="delete" style="text-align: center; width: 46px;">Delete</label>'+
												'</span>'+
												'<label><strong title=" ">File Name: </strong><a id="linkFile" href="'+escape(mediaLink.replace(/&amp;/g, '&'))+'" target="blank" title="Right click then save as." style="text-decoration: none; color: black;">'+fileName+'</a></label><br />'+  /* modified - Halley 10.31.13 */
												'<label><strong title=" ">Size: </strong></label><label id="size'+fileName+'" name="size" style="margin-left: 5px;" title=" ">'+convertByteSize(fileSize)+'</label><br />'+ 
												'<div name="mediaRemarks" id="mediaRemarks" style="display: block; float: left; margin: 2px; width: 90%;">'+
												'<label><strong title=" ">Remarks: </strong></label>'+
												'<div id="withRemarks" name="withRemarks">'+
												'<label id="lblRemarks'+fileName+'" name="lblRemarks" style="border: 1px solid transparent; cursor: text; padding-left: 3px; float: left; width: 79%; margin-left: 5px; color: black;">'+remarks+'</label>'+ 
												'</div>'+
												'<div id="editRemarks" name="editRemarks">'+
						 				 		'<input type="text" id="inputRemarks'+fileName+'" name="inputRemarks" maxlength="4000" style="float: left; padding-left: 3px; width: 79%; margin-left: 5px;"/>'+
												'</div>'+
												'</div>'+						 
												'</span>';			
				
								var newDiv = new Element("div");
								newDiv.setAttribute("id", "rowMedia"+rowId); //replaced "rowMedia"+fileName - Halley 10.25.13  
								newDiv.setAttribute("name", "rowMedia");
								newDiv.setStyle({marginBottom: "2px",
												 height: "65px",
												 borderBottom: "1px solid #c0c0c0",
												 display: "block"});
								newDiv.update(divContent);
							
								mediaDiv.insert({bottom: newDiv});
								checkIfToResizeFileTable("fileListing", "rowMedia");
								mediaDiv.scrollTop = mediaDiv.scrollHeight;
		
								//this is to delete the new file if the user cancels the upload.
								addNewUpload(fileName);
								
								initializeObservers();
		                        resetForm();
							}
						});
                    } else if ("SUCCESS" != content[6] && "" != content[0]) {
                    	updater.stop();
						resetForm();
                    }
	        	} 
            });	    	
		} catch (e){
			showErrorMessage("uploadFile", e);
		}
		initializeObservers();
	}

	function saveFiles(){
		var id = getGenericId($F("uploadMode"));
		var itemNo = $("itemNo") ? $F("itemNo") :$F("txtItemNo");
		new Ajax.Request("FileController?action=saveFiles&genericId="+id+"&itemNo="+itemNo,{
			method: "POST",
			postBody: fixTildeProblem(Form.serialize("filesForm").replace(/"/g, "\"")),
			onComplete: function(response){
				if("SUCCESS" == response.responseText) {
					$("newUploadDiv").update("");
					
					new Ajax.Request("FileController?action=deleteUpload&genericId="+id+"&itemNo="+itemNo,{
						method: "POST",
						postBody: fixTildeProblem(Form.serialize("filesForm").replace(/"/g, "\"")),
						onComplete: function(){
							Modalbox.hide();
							showMessageBox(objCommonMessage.SUCCESS, "S"); //Modified by Apollo Cruz 09.09.2014
						}
					});
				} else {
					showNoticeInPopup(response.responseText);
				}
			}
		});
	}
	
	function checkIfToResizeFileTable(tableId, rowName) {
	    if ($$("div[name='"+rowName+"']").size() >= 3) {
	     	$(tableId).setStyle("height: 200px; overflow-y: auto;"); 
	    } else {
	    	$(tableId).setStyle("height: "+($$("div[name='"+rowName+"']").size()*70)+"px; overflow: hidden;"); 
		}
	    Modalbox.resizeToContent();
	}
	
	//Halley 10.18.13
	$("file").observe("change", function(){
		$("saveAs").value = $("file").value;
	});
	
	function checkFileNameCharValid(){
		var isValid = true;
		for (var i=0; i<invalidChars.length; i++){
			if ($F("saveAs").indexOf(invalidChars[i]) > -1) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}//end

	checkIfToResizeFileTable("fileListing", "rowMedia");
	//checkTableIfEmptyinModalbox("row", "fileTable");
	addStyleToInputs();
	initializeAll();
	initializeObservers();  
	initializeTable("tableContainer", "rowMedia", "", "");
</script>