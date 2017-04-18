<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="attachedMediaTopDiv" name="attachedMediaTopDiv" style="">
	    <div style="width: 100%;" align="center">
	    <span id="closer" name="closer"	style="display: none; cursor: pointer; position: absolute; right: 10px; top: 5px; padding: 3px; border: 1px solid #c0c0c0; background-color: #c0c0c0; font-size: 16px; z-index: 100; margin: 5px; -moz-border-radius-topright: 5px; -moz-border-radius-bottomright: 5px;"
		onclick="hideVideo();">X</span>
		<div id="videoHolder" name="videoHolder"
			style="display: none; width: 480px; height: 270px; position: absolute; top: 0px; left: 30px; border: 5px solid #c0c0c0; z-index: 50; margin: 400px;">
		</div>
		</div>
		
		<div class="sectionDiv" id="attachedMediaSectionDiv${mediaItemNo}" name="attachedMediaSectionDiv" style="">
			<div id="mediaUploaded" name="mediaUploaded" style="font-size: 11px; width: 98%; margin-bottom: 5px; margin-left: 1%;">
				<c:forEach var="m" items="${media}" varStatus="ctr">
					<div id="rowMedia${mediaItemNo}${fn:replace(m.fileName, ' ', '_')}"  name="rowMedia" style="margin-bottom: 2px; height: 65px; border-bottom: 1px solid #c0c0c0; display: block;" itemNo="${m.itemNo}" fileName="${m.fileName}" mediaPath="${mediaPath[ctr.count]}" > <!-- ${m.fileName} -->
						<c:choose>
							<c:when test="${m.fileType eq 'P'}">
								<img src="${mediaLinks[ctr.count]}" width="80" height="60" border="0" alt="" style="margin-bottom: 2px; float: left;" onclick="showMedia(this);" />
							</c:when>
							<c:when test="${m.fileType eq 'D'}">
								<img src="${pageContext.request.contextPath}/images/misc/document.png" width="80" height="60" border="0" alt="" style="margin-bottom: 2px; float: left;" />
							</c:when>
							<c:when test="${m.fileType eq 'V'}">
								<img src="${pageContext.request.contextPath}/images/misc/video.png" width="80" height="60" border="0" alt="" style="margin-bottom: 2px; float: left;" onclick="showVideo('${mediaLinks[ctr.count]}');" />
							</c:when>
						</c:choose> 
						<span style="float: left; position: relative; padding-left: 15px; width: 79%; line-height: 1.5em;">
							<input type="hidden" value="${mediaPath[ctr.count]}" /> 
							<label><strong>File	Name: </strong> 
								<a href="${mediaLinks[ctr.count]}" target="blank" title="Right click then save as." style="text-decoration: none; color: black;">${m.fileName}</a>
							</label> <br />
							<label style="display: none;" id="lblSize">${mediaSizes[ctr.count]}</label>
							<label><strong>Size: </strong> ${mediaSizes[ctr.count]}kb</label> <br />
							<div name="mediaRemarks" id="mediaRemarks" title="Edit remarks here." style="display: block; float: left; margin: 2px; width: 90%;">
								<label><strong title=" ">Remarks: </strong></label>
								<div id="withRemarks" name="withRemarks">
									<label id="lblRemarks${fn:replace(m.fileName, ' ', '_')}" name="lblRemarks" title="Edit remarks here." style="border: 1px solid transparent; cursor: text; padding-left: 3px; float: left; width: 85%; margin-left: 5px; color: black;">${m.remarks}</label>
								</div>
								<div id="editRemarks" name="editRemarks">
				 				 	<input type="text" id="inputRemarks${fn:replace(m.fileName, ' ', '_')}" name="inputRemarks" style="float: left; padding-left: 3px; width: 85%; margin-left: 5px;" maxlength="4000"/>
				 				 	<input type="hidden" id="remarks${fn:replace(m.fileName, ' ', '_')}" value="${m.remarks}">
								</div>
							</div>
							<input type="hidden" id="filename${fn:replace(m.fileName, ' ', '_')}" name="filename" value="${m.fileName}" /> 
						</span>
					</div>
				</c:forEach> 
				
				<input type="hidden" id="selectedFileName${mediaItemNo}" name="selectedFileName"	value="" /> 
				<input type="hidden" id="selectedFileShortName${mediaItemNo}" name="selectedFileShortName" value="" />
				<input type="hidden" id="mediaItemNo${mediaItemNo}" name="mediaItemNo${mediaItemNo}" value="${mediaItemNo}"/>
				<input type="hidden" id="itemNo" name="itemNo" value=""/>
				
			</div>
			
			<div id="uploadDivDummy"></div>
			
			<iframe id="trgID${mediaItemNo}" name="uploadTrg${mediaItemNo}" height="0" width="0" frameborder="0" scrolling="yes">
			
			</iframe>
			
			
			<div class="sectionDiv" style="border: none;">
				<div style="float: left; display: block; width: 50%; margin-top: 50px; margin-left: 226px;">
					<div id="attachedMediaForm${mediaItemNo}" style="margin: 5px; width: 98%;">
						<form	id="uploadForm${mediaItemNo}" 		name="uploadForm" enctype="multipart/form-data" method="POST" action="" target="uploadTrg${mediaItemNo}">
							<input id="action${mediaItemNo}" 		name="action"		type="hidden" 	value="saveMedia"  /> 
							<input id="quoteId${mediaItemNo}" 		name="quoteId" 		type="hidden"  	value="${quoteId}" /> 
							<input id="mediaItemNo" 	name="mediaItemNo"	type="hidden"  	value="${mediaItemNo}" /> 
							<label class="rightAligned" style="width: 97px;">Browse</label> 
							<input id="file${mediaItemNo}" 			name="file" 		type="file"   style="margin-bottom: 5px; margin-left: 5px;" size="34" /> <br />
							<label class="rightAligned" style="width: 100px; float: left;">Save as</label> 
							<input id="saveAs${mediaItemNo}" 		name="saveAs" 		type="text" 	value=""  maxlength="100" 	style="width: 298px; margin-bottom: 5px; margin-left: 5px;" /> <br />
							<label class="rightAligned" style="width: 100px; float: left;">Remarks</label>
							<input id="remarks${mediaItemNo}" 		name="remarks" 		type="text" 	value=""  maxlength="4000" 	style="width: 298px; margin-bottom: 5px; margin-left: 5px;" /> <br />
						</form>
						<div id="uploadStatusDiv${mediaItemNo}" style="width: 0px; height: 0px; visibility: hidden;">	</div>
					</div>
					<div class="buttonsDivPopup" align="center">
						<input type="button" class="button" id="btnUploadMedia" name="btnUploadMedia" value="Upload" /> 
						<input type="button" class="disabledButton" id="btnDeleteMedia" name="btnDeleteMedia" value="Delete" style="margin-right: 92px;" />
					</div>
				</div>
			</div>
		</div>
</div>

<!-- end of sectionDiv -->
<script>
	var supportedFiles = new Array(".gif", ".png", ".jpg", ".jpeg", ".bmp", ".ani", ".doc", ".xls", ".pdf", ".txt", ".ods", ".odt", ".docx", ".ppt", ".mpeg", ".mpg", ".mp4", ".avi", ".3gp", ".3gpp", ".wmv");
	var invalidChars = new Array("<", ">", "'", "*", "?", "\"", "\\", "/", "|", ":");
	var editMode 	= false;

	if (isMakeQuotationInformationFormsHidden == 1) {
		$("attachedMediaForm${mediaItemNo}").hide();
	}

	addStyleToInputs();
	initializeAll();

	function initializeRowMedia(){
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
			            			color: "black"});
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
	
		$$("div[name='rowMedia']").each(function(row) {
			var inputRemarks 	= row.down("span").down("div").down("div", 1).down("input");
			
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
					
					$("selectedFileName${mediaItemNo}").value 		= row.getAttribute("mediaPath"); // Nica 05.11.2011
					$("selectedFileShortName${mediaItemNo}").value 	= row.getAttribute("fileName"); // Nica 05.11.2011
					$("saveAs${mediaItemNo}").value 	= "";
					$("remarks${mediaItemNo}").value 	= "";
					disableButton("btnUploadMedia");	
					enableButton("btnDeleteMedia");
				}
			});

			inputRemarks.observe("blur", function(){
				var fileName = row.getAttribute("mediaPath");
				var itemNo = row.getAttribute("itemNo");
				updateRemarks(fileName, itemNo, $F(inputRemarks));
				leaveInputRemarks(inputRemarks);
				editMode = false;
			});

			inputRemarks.observe("keypress", function(e){		
				if(13 == e.keyCode){
					var fileName = row.getAttribute("mediaPath");
					var itemNo = row.getAttribute("itemNo");
					updateRemarks(fileName, itemNo, $F(inputRemarks));
					leaveInputRemarks(inputRemarks);
					editMode = false;
				}
			});

			inputRemarks.observe("focus", function(){
				var rowRemarks	= row.down("span").down("div").down("div", 1).down("input", 1).value;
				inputRemarks.value = rowRemarks;
				inputRemarks.select();
			});
		});
	}

	function leaveInputRemarks(inputRemarks){
		inputRemarks.up("div").down("input", 1).value = $F(inputRemarks);
		inputRemarks.up("div").previous("div").show();
		inputRemarks.up("div").previous("div").down("label").update($F(inputRemarks).truncate(80, "..."));
		inputRemarks.up("div").hide();
		
		var label = inputRemarks.up("div").previous("div").down("label");
		var row = inputRemarks.up("div").up("div").up("span").up("div"); 
		var remarks = label.innerHTML;
		
		if ("Write Remarks..." == remarks.trim()){
			label.innerHTML = "";
		}

    	row.removeClassName("lightblue");
		
    	label.setStyle({border: "1px solid transparent",
						color: "black",
						backgroundColor: ""});
	}
	
	$("file${mediaItemNo}").observe("blur", function() {
		var wFileExt = $F("file${mediaItemNo}");
		deselectRow();
		$("saveAs${mediaItemNo}").value = wFileExt.substring(0, wFileExt.length - 4);
	});

	$("saveAs${mediaItemNo}").observe("blur", function() {
		getTotalFileSizeInList();
	});

	function deselectRow() {
		$("saveAs${mediaItemNo}").value 	= "";
		$("remarks${mediaItemNo}").value 	= "";
		
		enableButton("btnUploadMedia"); 		
		disableButton("btnDeleteMedia");	
		
		$("selectedFileName${mediaItemNo}").value = "";
		$("selectedFileShortName${mediaItemNo}").value = "";
	}

	$("btnDeleteMedia").observe("click", function() {
		var shortName = $F("selectedFileShortName${mediaItemNo}");
		var longName = $F("selectedFileName${mediaItemNo}");
		
		new Ajax.Request(contextPath + "/FileUploadController?action=deleteMedia&fileName=" + longName + "&shortFileName=" + shortName, {
			method : "POST",
			postBody : Form.serialize("uploadForm${mediaItemNo}"),
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
			hideNotice();
				if ("SUCCESS" == response.responseText) {
					Effect.Fade($("rowMedia${mediaItemNo}" + shortName.replace(/ /g, "_")), {
						duration : .2,
						afterFinish : function() {
							showMessageBox("Attachment has been deleted.", imgMessage.INFO);
							$("rowMedia${mediaItemNo}" + shortName.replace(/ /g, "_")).remove();
							deselectRow();
							checkMediaUploadedSize();
						}
					});
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	});

	$("btnUploadMedia").observe("click",function() {
		if($F("file${mediaItemNo}").blank()){
			showMessageBox("Please select a file.", imgMessage.INFO);
			return false;
		} else if ($F("saveAs${mediaItemNo}").blank()) {
			showMessageBox("Please enter a filename.", imgMessage.INFO);
			return false;
		}
		else if ($F("saveAs${mediaItemNo}").include("\u00F1") || $F("saveAs${mediaItemNo}").include("\u00D1")) {
			showMessageBox("\u00D1 or \u00F1 not allowed for file name.", imgMessage.ERROR);
			return false;
		}else if (!checkIfExistInList()){
			showMessageBox("File already exists!", imgMessage.ERROR);
		}else if (!checkIfFileExtensionValid()){
			showMessageBox("The file you are trying to upload is not supported.", imgMessage.ERROR);
			resetUploadForm();
		}else if (!checkFileNameCharValid()){
			showMessageBox("A filename cannot contain any of the following characters: \ / : * ? | \" \' .", imgMessage.ERROR);
		}else if (checkFileSizeOfUpload() > 1048576){
			showMessageBox("Upload limit is only 1 MB per file.", imgMessage.ERROR);
		}else if ((parseFloat(checkFileSizeOfUpload()) + parseFloat(getTotalFileSizeInList())) > 3145728){
			showMessageBox("You've exceeded your maximum allowable upload of 3MB.", imgMessage.ERROR);
			resetUploadForm();
		}
		else{
			$("uploadForm${mediaItemNo}").action = "FileUploadController?" + fixTildeProblem(Form.serialize("uploadForm${mediaItemNo}"));
			$("uploadForm${mediaItemNo}").submit();
			$("uploadForm${mediaItemNo}").disable();
			
			try {

				var uploadDivDummy = $("uploadDivDummy");
				var uploadContent = '<div id="uploadStatusDiv" style="padding: 2px; margin: 0 25%; width: 50%; height: 12px; border: 1px solid gray; float: left; background-color: white;">'+
							  		'<span id="progressBar" style="background-color: #66FF33; height: 12px; float: left;"></span>'+
									'</div>'+
									'<span id="pct" style="color: #000;"></span>'+
									'<div id="updaterDiv" name="updaterDiv" style="margin-left: 2px; visibility: hidden;"></div>';
				var uploadDiv = new Element("div");
				uploadDiv.setAttribute("id", "uploadDiv");
				uploadDiv.setAttribute("name", "row");
				uploadDiv.setStyle("margin-top: 10px;");
				uploadDiv.update(uploadContent);
				uploadDivDummy.insert({bottom: uploadDiv});
				disableButton("btnUploadMedia");
				$("pct").update("<span style='background-color: #fff; width: 98%; height: 15px; float: left; padding-left: 5px;'>Initializing upload...</span>");
				
				// get upload status
				updater = new Ajax.PeriodicalUpdater( 'uploadStatusDiv${mediaItemNo}', 'FileUploadController',{	
					asynchronous : 	true,
					frequency : 	5,
					method : 		"GET",
					onCreate: 		function(){
					},
					onSuccess : function(request) {
						if (request.responseText.length > 1) {
							$("progressBar").style.width = request.responseText	+ "%";
							$("pct").update("<span style='background-color: #fff; width: 98%; height: 15px; float: left; padding-left: 5px;'>" + request.responseText + "% completed...</span>");
						}
						var content = $("trgID${mediaItemNo}").contentWindow.document.body.innerHTML.stripTags().strip().split("----");
						
						if (content[6] == "SUCCESS") {
							updater.stop();
							$("progressBar").style.width = "100%";
							Effect.Fade("uploadDiv",{
							duration : .5,
							afterFinish : function() {
								$("uploadDiv").remove();
							}
							});
													
							var row = new Element("div"); //, {id: content[4]}
							row.writeAttribute("id", "rowMedia${mediaItemNo}" + content[1].replace(/ /g, '_'));
							row.writeAttribute("name","rowMedia");
							row.writeAttribute("itemNo", getSelectedRowId("itemRow"));
							row.writeAttribute("fileName", content[1]);
							row.writeAttribute("mediaPath", content[0]);
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
							img.writeAttribute( "alt",	  "");
							img.setStyle("margin-bottom: 2px; float: left; display: block;");

							var top = $$("div#mediaUploaded div").size();
							var details = new Element("span");

							details.setStyle("float: left; position: relative; padding-left: 15px; width: 79%; line-height: 1.5em;");

							var noOfMediaRows = $$("span[name='mediaRemarks']").size();
							var remarksItemNo = getSelectedRowId("itemRow");
							var remarksLong = content[4];
							if (content[4].length > 80) {
								content[4] = content[4].truncate(80,"...");
							}
							
							details.insert( {
								bottom : '<input type="hidden" value="'	+ content[0]  + '"/>'
										+'<label><strong>File Name: </strong>' 
										+	'<a href="' + contextPath + "/" + content[5]  + "/" + content[1]  + '" target="blank" title="Right click then save as." style="text-decoration: none; color: black;">'+ content[1] + '</a>'
										+'</label> <br />' 
										+'<label><strong>Size: </strong>' + Math.floor(content[3] / 1024)	+ 'kb</label> <br />'
										+'<div name="mediaRemarks" id="mediaRemarks" title="Edit remarks here." style="display: block; float: left; margin: 2px; width: 90%;">'
										+	'<label><strong title=" ">Remarks: </strong></label>'
										+	'<div id="withRemarks" name="withRemarks">'
										+		'<label id="lblRemarks'+content[1].replace(/ /g, "_")+'" name="lblRemarks" style="border: 1px solid transparent; cursor: text; padding-left: 3px; float: left; width: 85%; margin-left: 5px; color: black;">'+content[4]+'</label>'
										+	'</div>'
										+	'<div id="editRemarks" name="editRemarks">'
				 				 		+		'<input type="text" id="inputRemarks'+content[1].replace(/ /g, '_')+'" name="inputRemarks" maxlength="4000" style="float: left; padding-left: 3px; width: 79%; margin-left: 5px;"/>'
					 				 	+		'<input type="hidden" id="remarks'+content[1].replace(/ /g, '_')+'" value="'+remarksLong+'"/>'
										+	'</div>'
										+'</div>'
										+ '<input id="filename' + content[1] + '" name="filename" type="hidden" value="' + content[1] + '"/>'
										
							});
							
							row.appendChild(img);
							row.appendChild(details);
							loadRowMouseOverMouseOutObserver(row);
							row.observe("click", function() {
								$("itemNo").value = row.getAttribute("itemNo");
								if(row.hasClassName("selectedRow")) { // remove selection
										row.removeClassName("selectedRow");
										deselectRow();
								} else { // select
									$$("div[name='rowMedia']").each(function(allrows) {
										allrows.removeClassName("selectedRow");
									});
									row.addClassName("selectedRow");
									$("selectedFileName${mediaItemNo}").value 		= row.getAttribute("mediaPath"); // Nica 05.11.2011
									$("selectedFileShortName${mediaItemNo}").value 	= row.getAttribute("fileName"); // Nica 05.11.2011
									$("saveAs${mediaItemNo}").value 	= "";
									$("remarks${mediaItemNo}").value 	= "";
									disableButton("btnUploadMedia");	
									enableButton("btnDeleteMedia");
								}
							});

							var mediaRemarksDiv = row.down("span").down("div");
							var inputRemarks 	= row.down("span").down("div").down("div", 1).down("input");

							var label = mediaRemarksDiv.down("div", 0).down("label");
							
							mediaRemarksDiv.down("div", 1).hide();
					
							mediaRemarksDiv.observe("mouseover", function() {
								if(false == editMode){
									var remarks = label.innerHTML;
						            if ("" == remarks.trim()){
						            	label.innerHTML = "Write Remarks...";
						            	label.setStyle({backgroundColor: "white"});
						            }
						            label.setStyle({border: "1px solid #c0c0c0",
							            			color: "black"});
								}
							});
					
							mediaRemarksDiv.observe("mouseout", function() {
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
											
							mediaRemarksDiv.observe("click", function(){
								editMode = true;
								mediaRemarksDiv.down("div", 0).hide();
								mediaRemarksDiv.down("div", 1).show();
								mediaRemarksDiv.down("div", 1).down("input").focus();
							});
							
							inputRemarks.observe("blur", function(){
								var fileName = row.getAttribute("mediaPath");
								var itemNo = row.getAttribute("itemNo");
								updateRemarks(fileName, itemNo, $F(inputRemarks));
								leaveInputRemarks(inputRemarks);
								editMode = false;
							});

							inputRemarks.observe("keypress", function(e){		
								if(13 == e.keyCode){
									var fileName = row.getAttribute("mediaPath");
									var itemNo = row.getAttribute("itemNo");
									updateRemarks(fileName, itemNo, $F(inputRemarks));
									leaveInputRemarks(inputRemarks);
									editMode = false;
								}
							});

							inputRemarks.observe("focus", function(){
								var rowRemarks	= row.down("span").down("div").down("div", 1).down("input", 1).value;
								inputRemarks.value = rowRemarks;
								inputRemarks.select();
							});				
							
							$("mediaUploaded").insert({ bottom : row });
							Effect.Appear(
								row,{
									duration : .5,
									afterFinish : function() {
										updater.stop();
										showMessageBox("Attachment Finished.", imgMessage.INFO);
										$("uploadForm${mediaItemNo}").reset();
										$("uploadForm${mediaItemNo}").enable();
										enableButton("btnUploadMedia");
										$("trgID${mediaItemNo}").contentWindow.document.body.innerHTML = "";
										checkMediaUploadedSize();
										initializeAll();
										fireEvent(row, "click");
										row.scrollIntoView();
									}
								});
							
						} else if (content[0] == "ERROR") {
							updater.stop();
							showMessageBox(content[1], imgMessage.ERROR);
							$("uploadDiv").remove();
							enableButton("btnUploadMedia");
							$("uploadForm${mediaItemNo}").enable();
							$("progressBar").style.width = 0;
							$("trgID${mediaItemNo}").contentWindow.document.body.innerHTML = "";
							new Effect.Highlight("innerLabelDiv");
						}
					}
				});
			} catch (e) {
				showErrorMessage("Upload media in quote information", e);
			} finally {
				initializeAll();
			}
		}
	});

	if (navigator.appName != "Netscape") {
		$("file${mediaItemNo}").setStyle("width: 306px;");
		$("btnUploadMedia").setStyle("margin-right: 44px;");
	}

	//var updaters = new Array();
	/*function createEditableFields() {
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
						+ Form.serialize("uploadForm${mediaItemNo}") 
						+ "&itemNo=" + 	remarks.getAttribute("itemNo")//getSelectedRowId("itemRow")	
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
						remarks.writeAttribute("title", remarks.innerHTML));
						remarks.update(remarks.innerHTML.truncate(95, "..."));
					}
		});
	}*/

	function updateRemarks(fileName, itemNo, remarks){
		new Ajax.Request(contextPath
				+ "/FileUploadController?action=updateRemarks&"
				+ Form.serialize("uploadForm${mediaItemNo}")
				+ "&value="+remarks 
				+ "&itemNo=" + itemNo
				+ "&fileName="
				+ fileName,{
			onCreate: function(){
				showNotice("Updating remarks...");
			},
			onComplete: function(response){
				hideNotice();
			}
		});
	}

	function checkIfExistInList(){
		var exist = true;
		$$("div[name='rowMedia']").each(function(row) {
			var existingFileName = row.getAttribute("fileName").substring(0, row.getAttribute("fileName").length - 4);
			if (existingFileName == $F("saveAs${mediaItemNo}")){
				exist = false;
			}
		});
		return exist;
	}

	function checkIfFileExtensionValid(){
		var isValid = false;
		var fileExt = $F("file${mediaItemNo}").substr($F("file${mediaItemNo}").indexOf("."), $F("file${mediaItemNo}").length - 1);
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
			if ($F("saveAs${mediaItemNo}").indexOf(invalidChars[i]) > -1) {
				isValid = false;
				break;
			}
		}
		return isValid;
	}

	function checkFileSizeOfUpload(){
		var fileTemp = $("file${mediaItemNo}");
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

	function resetUploadForm(){
		$("file${mediaItemNo}").value    = "";
		$("saveAs${mediaItemNo}").value  = "";
		$("remarks${mediaItemNo}").value = "";
    	$("uploadForm${mediaItemNo}").enable();
    	enableButton("btnUploadMedia"); 				
		disableButton("btnDeleteMedia");
        $("trgID${mediaItemNo}").contentWindow.document.body.innerHTML = "";
        editMode = false;
	}
	
	
	$$("label[name='lblRemarks']").each(function(lbl) {
		var id = lbl.getAttribute("id");
		$(id).update($(id).innerHTML.truncate(80, "..."));
	});
	
	$("file${mediaItemNo}").focus();
	initializeAll();
	initializeRowMedia();
	showAttachedMediaPerItem();
	initializeAccordion();
</script>