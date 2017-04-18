<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="attachedMediaTopDiv" name="attachedMediaTopDiv" style="">
	<span id="closer" name="closer"	style="display: none; cursor: pointer; position: absolute; right: 10px; top: -5px; padding: 3px; border: 1px solid #c0c0c0; background-color: #c0c0c0; font-size: 9px; z-index: 100; margin: 5px; -moz-border-radius-topright: 5px; -moz-border-radius-bottomright: 5px;"
		onclick="hideVideo();">X</span>
		<div id="videoHolder" name="videoHolder"
			style="display: none; width: 480px; height: 270px; position: absolute; top: 0px; left: 30px; border: 5px solid #c0c0c0; z-index: 50;">
		</div>
		<div class="sectionDiv" id="attachedMediaSectionDiv" name="attachedMediaSectionDiv" style="">
			<div id="mediaUploaded" name="mediaUploaded" style="font-size: 11px; width: 98%; margin-bottom: 5px; margin-left: 1%;">
				<c:forEach var="m" items="${media}" varStatus="ctr">
					<div name="rowMedia" style="margin-bottom: 2px; height: 65px; border-bottom: 1px solid #c0c0c0; display: block;" id="rowMedia${ctr.count}" itemNo="${ctr.count}" fileName="${m.fileName}"> <!-- ${m.fileName} -->
						<c:choose>
							<c:when test="${m.fileType eq 'P'}">
								<img src="${mediaLinks[ctr.count]}" width="80" height="60" border="0" alt="" style="margin-bottom: 2px; float: left;" onclick="showMedia(this);" />
							</c:when>
							<c:when test="${m.fileType eq 'D'}">
								<img src="${pageContext.request.contextPath}/images/misc/document.png" width="80" height="60" border="0" alt="" style="margin-bottom: 2px; float: left;" />
							</c:when>
							<c:when test="${m.fileType eq 'V'}">
								<img src="${pageContext.request.contextPath}/images/misc/video.png" width="80" height="60" border="0" alt="" 				style="margin-bottom: 2px; float: left;" onclick="showVideo('${mediaLinks[ctr.count]}');" />
							</c:when>
						</c:choose> 
						<span style="float: left; position: relative; padding-left: 15px; width: 79%; line-height: 1.5em;">
							<input type="hidden" value="${mediaPath[ctr.count]}" /> 
							<label><strong>File	Name: </strong> 
								<a href="${mediaLinks[ctr.count]}" target="blank" title="Right click then save as." style="text-decoration: none; color: black;">${m.fileName}</a>
							</label> <br />
							<label style="display: none;" id="lblSize">${mediaSizes[ctr.count]}</label>
							<label><strong>Size: </strong> ${mediaSizes[ctr.count]}kb</label> <br />
							<label><strong>Remarks: </strong> <span name="mediaRemarks" id="mediaRemarks${ctr.count}">${m.remarks}</span></label> 
							<input type="hidden" id="filename${m.fileName}" name="filename" value="${m.fileName}" /> 
						</span>
					</div>
				</c:forEach> 
				
				<input type="hidden" id="selectedFileName" name="selectedFileName"	value="" /> 
				<input type="hidden" id="selectedFileShortName" name="selectedFileShortName" value="" />
				<input type="hidden" id="mediaItemNo" name="mediaItemNo" value=""/>
				<input type="hidden" id="itemNo" name="itemNo" value=""/>
				
			</div>
			
			<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">
				<span id="progressBar" style="background-color: #fff; height: 15px; float: left;"></span>
				<span id="pct" style="color: #000;"></span>
			</span> 
			<iframe id="trgID" name="uploadTrg" height="0" width="0" frameborder="0" scrolling="yes">
			
			</iframe>
		</div>
</div>
<div class="sectionDiv" style="border-top: none;">
	<div style="float: left; display: block; width: 50%; margin-top: 50px; margin-left: 226px;">
		<div id="attachedMediaForm" style="margin: 5px; width: 98%;">
			<form id="uploadForm" name="uploadForm" enctype="multipart/form-data" method="POST" action="" target="uploadTrg">
				<input id="action" name="action" type="hidden" value="saveMedia"/> 
				<input id="quoteId" name="quoteId" type="hidden" value="${quoteId}" /> 
				<input id="mediaItemNo" name="mediaItemNo" type="hidden" value="" /> 
				<label class="rightAligned" style="width: 97px;">Browse</label> 
				<input id="file" name="file" type="file" style="margin-bottom: 5px; margin-left: 5px;" size="34" /> <br />
				<label class="rightAligned" style="width: 100px; float: left;">Save as</label> 
				<input id="saveAs" name="saveAs" type="text" value="" maxlength="100" style="width: 298px; margin-bottom: 5px; margin-left: 5px;" /> <br />
				<label class="rightAligned" style="width: 100px; float: left;">Remarks</label>
				<input id="remarks" name="remarks" type="text" value="" maxlength="4000" style="width: 298px; margin-bottom: 5px; margin-left: 5px;" /> <br />
			</form>
			<div id="uploadStatusDiv" style="width: 0px; height: 0px; visibility: hidden;">	</div>
		</div>
		<div class="buttonsDivPopup">
			<input type="button" class="button" id="btnUpload" name="btnUpload" value="Upload" /> 
			<input type="button" class="disabledButton" id="btnDeleteMedia" name="btnDeleteMedia" value="Delete"/>
		</div>
	</div>
</div>
<!-- end of sectionDiv -->
<script>
var supportedFiles = new Array(".gif", ".png", ".jpg", ".jpeg", ".bmp", ".ani", ".doc", ".xls", ".pdf", ".txt", ".ods", ".odt", ".docx", ".ppt", ".mpeg", ".mpg", ".mp4", ".avi", ".3gp", ".3gpp", ".wmv");
var invalidChars = new Array("<", ">", "'", "*", "?", "\"", "\\", "/", "|", ":");

//var mediaListDtls[] = '${mediaSizes}';

//for (var i=0; i< mediaListDtls.length; i++) {
//	mediaListDtls[i] ='${mediaSizes}'
//}

	if (isMakeQuotationInformationFormsHidden == 1) {
		$("attachedMediaForm").hide();
	}

	addStyleToInputs();
	initializeAll();

	function initializeRowMedia(){
	$$("div[name='rowMedia']").each(
		function(row) {
			row.observe("mouseover", function() {
				row.addClassName("lightblue");
			});

			row.observe("mouseout", function() {
				row.removeClassName("lightblue");
			});
			
			row.observe("click", function() {
				hideNotice();
				$("itemNo").value = row.getAttribute("itemNo");
				if(row.hasClassName("selectedRow")) { // remove selection
					row.removeClassName("selectedRow");
					deselectRow();
				} else { // select
					$$("div[name='rowMedia']").each(function(allrows) {
						allrows.removeClassName("selectedRow");
					});
					row.addClassName("selectedRow");
					if(row.down("span",0) == "undefined" ){			
						$("selectedFileName").value 		= row.down("span", 0).down("input", 0).value;	//**
						$("selectedFileShortName").value 	= row.down("span", 0).down("input", 1).value;  	//** 
					}else{
						var children = row.childElements();
						var parent = null;
						var ctr1 = 0;
						children.each(function(aChild){
							if(ctr1 == 1){
								parent = aChild;
							}
							ctr1++;
						});
						if(parent!=null){
							var grandChildren = parent.childElements();
							var ctr2 = 0;
							grandChildren.each(function(aGrand){
								if(ctr2 == 0){
									$("selectedFileName").value = aGrand.value;
								}
								if(ctr2 == 6){
									$("selectedFileShortName").value = aGrand.value;
								}
								ctr2++;
							});
						}
					}
					$("saveAs").value 	= "";
					$("remarks").value 	= "";
					disableButton("btnUpload");	
					enableButton("btnDeleteMedia");
				}
			});
		});
	}
	
	$("file").observe("blur", function() {
		var wFileExt = $F("file");
		deselectRow();
		$("saveAs").value = wFileExt.substring(0, wFileExt.length - 4);
	});

	$("saveAs").observe("blur", function() {
		//checkFileNameCharValid();
		//showMessageBox("here");
		getTotalFileSizeInList();
	});

	function deselectRow() {
		$("saveAs").value 	= "";
		$("remarks").value 	= "";
		
		enableButton("btnUpload"); 			/*	$("btnUpload").removeClassName("disabledButton");	$("btnUpload").addClassName("button");		*/
		disableButton("btnDeleteMedia");	/*	$("btnDeleteMedia").removeClassName("button");	$("btnDeleteMedia").addClassName("disabledButton");*/

		$("selectedFileName").value = "";
		$("selectedFileShortName").value = "";
	}

	$("btnDeleteMedia").observe("click", function() {
		var shortName = $F("selectedFileShortName");
		var longName = $F("selectedFileName");

		new Ajax.Request(contextPath + "/FileUploadController?action=deleteMedia&fileName=" + longName + "&shortFileName=" + shortName, {
			method : "POST",
			postBody : Form.serialize("uploadForm"),
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
			hideNotice();
				if ("SUCCESS" == response.responseText) {
					Effect.Fade($("rowMedia" + $F("itemNo")), {
						duration : .2,
						afterFinish : function() {
							showMessageBox(response.responseText, imgMessage.SUCCESS);
							Effect.Fade("noticePopup",{	duration : 5 });
							$("rowMedia" + $F("itemNo")).remove();
							deselectRow();
							checkMediaUploadedSize();
						}
					});
				}
			}
		});
	});

	$("btnUpload").observe("click",function() {
		if($F("file").blank()){
			showMessageBox("Please select a file.", imgMessage.INFO);
			/*new Effect.Highlight("outerDiv", {
				startcolor : '#ff0000',
				duration : .5
			});*/
			return false;
		} else if ($F("saveAs").blank()) {
			showMessageBox("Please enter a filename.", imgMessage.INFO);
			return false;
		}
		else if ($F("saveAs").include("\u00F1") || $F("saveAs").include("\u00D1")) {
			showMessageBox("\u00D1 or \u00F1 not allowed for file name.", imgMessage.ERROR);
			return false;
		}else if (!checkIfExistInList()){
			showMessageBox("File already exists!", imgMessage.ERROR);
		}else if (!checkIfFileExtensionValid()){
			showMessageBox("The file you are trying to upload is not supported.", imgMessage.ERROR);
		}else if (!checkFileNameCharValid()){
			showMessageBox("A filename cannot contain any of the following characters: \ / : * ? | \" \' .", imgMessage.ERROR);
		}else if (checkFileSizeOfUpload() > 1048576){
			showMessageBox("Upload limit is only 1 MB per file.", imgMessage.ERROR);
		}else if ((parseFloat(checkFileSizeOfUpload()) + parseFloat(getTotalFileSizeInList())) > 3145728){
			showMessageBox("You've exceeded your maximum allowable upload of 3MB.", imgMessage.ERROR);
		}
		else{
			//$("notice").hide();
			//hideNotice();
			$("uploadForm").action = "FileUploadController?" + fixTildeProblem(Form.serialize("uploadForm"));
			$("uploadForm").submit();
			$("uploadForm").disable();
			$("pct").update("<span style='background-color: #fff; width: 98%; height: 15px; float: left; padding-left: 5px;'>Initializing upload...</span>");
			try {
				Effect.Appear("noticePopup", {
					duration : .2
				});
				// get upload status
				updater = new Ajax.PeriodicalUpdater( 'uploadStatusDiv', 'FileUploadController',{	
					asynchronous : 	true,
					frequency : 	5,
					method : 		"GET",
					onCreate: 		function(){
					},
					onSuccess : function(request) {
						if (request.responseText.length > 1) {
							$("progressBar").style.width = request.responseText	+ "%";
							$("pct").update(request.responseText + "% completed...");
						}
						var content = $("trgID").contentWindow.document.body.innerHTML.stripTags().strip().split("----");
						if (content[6] == "SUCCESS") {						
							var row = new Element("div"); //, {id: content[4]}
							row.writeAttribute("id", "rowMedia" + content[1]);
							row.writeAttribute("name","rowMedia");
							row.writeAttribute("itemNo", $F("itemNo"));
							row.writeAttribute("fileName", $F("file"));
							row.setStyle("margin-bottom: 2px; border-bottom: 1px solid #c0c0c0; display: none; float: left; width: 100%;");
							// create thumbnail
							var img = new Element("img");
							if (content[2] == "video") {
								img.writeAttribute(	"src", contextPath	+ "/images/misc/video.png");
								img.observe("click",function(){
									showVideo(contextPath + "/"	+ content[5] + "/" + content[1] );
								});
							} else if (content[2] == "document") {
								img.writeAttribute(	"src", contextPath + "/images/misc/document.png");
							} else {
								img.writeAttribute(	"src", contextPath + "/" + content[5]  + "/" + content[1]);
								img.observe("click",function() {
									showMedia(img);
								});
							}

							img.writeAttribute(	"height", "60");
							img.writeAttribute( "width" , "80");
							img.writeAttribute(	"border", "0");
							img.writeAttribute( "alt", "");
							img.setStyle("margin-bottom: 2px; float: left; display: block;");

							var top = $$("div#mediaUploaded div").size();
							var details = new Element("span");
							
							details.setStyle("float: left; position: relative; padding-left: 15px; width: 79%; line-height: 1.5em;");
							
							var noOfMediaRows = $$("span[name='mediaRemarks']").size();
							var remarksLong = content[4];
							if (content[4].length > 95) {
								content[4] = content[4].truncate(95,"...");
							}

							details.insert( {
								bottom : '<input type="hidden" value="'	+ content[0]  + '"/>'
										+ '<label><strong>File Name: </strong> <a href="' + contextPath + "/"
										+ content[5]  + "/" + content[1]  + '" target="blank" title="Right click then save as." style="text-decoration: none; color: black;">'
										+ content[1] + '</a></label> <br />' + '<label><strong>Size: </strong> '
										+ Math.floor(content[3] / 1024)	+ 'kb</label> <br />'
										+ '<label title="' + remarksLong + '"><strong>Remarks: </strong> <span name="mediaRemarks" id="mediaRemarks'
										+ noOfMediaRows	+ '">' + content[4] + '</span></label>'
										+ '<input id="filename' + content[1] + '" name="filename" type="hidden" value="' + content[1] + '"/>'
							});
							
							row.appendChild(img);
							row.appendChild(details);

							$("mediaUploaded").insert({ bottom : row });
							Effect.Appear(
								row,{
									duration : .5,
									afterFinish : function() {
										// $("innerLabelDiv").down("label",	0).update("Please complete fields.");
										// add observers
										updater.stop();
										$("pct").update("<span style='background-color: #fff; width: 100%; height: 15px; float: left;'>Upload sucessful!</span>");
										Effect.Fade("noticePopup",{	duration : 3 });
										$("uploadForm").reset();
										$("uploadForm").enable();
										$("progressBar").style.width = 0;
										$("trgID").contentWindow.document.body.innerHTML = "";
										checkMediaUploadedSize();
										initializeAll();
										//createEditableField("mediaRemarks"+noOfMediaRows, content[0]);
										createEditableFields();
										initializeRowMedia();
									}
								});
							initializeAll();
							initializeRowMedia();
						} else if (content[0] == "ERROR") {
							updater.stop();
							
							Effect.Fade("noticePopup",{
								duration : 10,
								afterFinish : function() {
									$("pct").update("");
								}
							});
							
							$("uploadForm").enable();
							$("progressBar").style.width = 0;
							$("trgID").contentWindow.document.body.innerHTML = "";
							//$("innerLabelDiv").down("label", 0).update(	content[0]	+ " - "	+ content[1] );
							new Effect.Highlight("innerLabelDiv");
						}
						initializeRowMedia();
					}
				});
			} catch (e) {
				showErrorMessage("attachedMedia.jsp - btnUpload", e);
			} finally {
				initializeAll();
			}
		}
	});

	if (navigator.appName != "Netscape") {
		$("file").setStyle("width: 306px;");
		$("btnUpload").setStyle("margin-right: 44px;");
	}

	function checkMediaUploadedSize() {
		if ($$("div#mediaUploaded div").size() > 3) {
			$("mediaUploaded").setStyle("height: 210px; overflow-y: auto;");
		} else {
			$("mediaUploaded").setStyle("height: " + ($$("div#mediaUploaded div").size() * 68) + "px;");
		}
	}

	checkMediaUploadedSize();

	var updaters = new Array();
	function createEditableFields() {
		if (updaters.length > 0) {
			updaters.each(function(u) {
				u.dispose();
			});
		}
		var ctr = 0;
		$$("span[name='mediaRemarks']").each(
			function(remarks) {
				var updater = 
					new Ajax.InPlaceEditor(remarks, contextPath
						+ "/FileUploadController?action=updateRemarks&"
						+ Form.serialize("uploadForm") 
						+ "&itemNo=" + 	$("itemNo").value	
						+ "&fileName="
						+ remarks.up("span", 0).down("input", 0).value, {
							okControl : 	false,
							cancelControl : false,
							cols : 			50,
							submitOnBlur : 	true,
							savingText : 	"Updating, please wait..."
						});
					updaters.push(updater);
					ctr++;
					if (remarks.innerHTML.length > 95) {
						remarks.writeAttribute("title", remarks.innerHTML);
						remarks.update(remarks.innerHTML.truncate(95, "..."));
					}
		});
	}

	function checkIfExistInList(){
		var exist = true;
		$$("div[name='rowMedia']").each(function(row) {
			var existingFileName = row.getAttribute("fileName").substring(0, row.getAttribute("fileName").length - 4);
			if (existingFileName == $F("saveAs")){
				exist = false;
			}
		});
		return exist;
	}

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
			if ($F("saveAs").indexOf(invalidChars[i]) > -1) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}

	function checkFileSizeOfUpload(){
		var fileTemp = $("file");
		var file     = fileTemp.files[0];
		return file.fileSize;
	}

	function getTotalFileSizeInList(){
		var totalFileSize = 0;
		$$("label[id='lblSize']").each(function (lbl)	{
			totalFileSize += parseFloat(lbl.innerHTML);
		});
		return Math.round(parseFloat(totalFileSize)*1024*100000)/100000;
	}
	
	createEditableFields();
	$("file").focus();
	initializeAll();
	initializeRowMedia();
	//initializeAccordion();
</script>