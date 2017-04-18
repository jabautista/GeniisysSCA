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
			<div class="tableContainer" id="fileListing" name="fileListing" style="display: block;">
				<c:forEach var="m" items="${media}" varStatus="ctr">
					<div id="rowMedia${m.fileName}" name="rowMedia" style="margin-left: 2px; height: 65px; border-bottom: 1px solid #c0c0c0; display: block;">
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
							<label><strong title=" ">File Name: </strong><a href="${mediaLinks[ctr.count]}" target="blank" title="Click to view file." style="text-decoration: none; color: black;">${m.fileName}</a></label> <br />
							<label><strong title=" ">Size: </strong></label><label id="size${m.fileName}" name="size" style="margin-left: 5px;" title=" ">${mediaSizes[ctr.count]}</label> <br />
							<div name="mediaRemarks" id="mediaRemarks" style="display: block; float: left; margin: 2px; width: 90%;">
								<label><strong title=" ">Remarks: </strong></label>
								<div id="withRemarks" name="withRemarks">
									<label id="lblRemarks${m.fileName}" name="lblRemarks" style="border: 1px solid transparent; cursor: text; padding-left: 3px; float: left; width: 79%; margin-left: 5px; color: black;">${m.remarks}</label>
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
						<td class="rightAligned">File Name</td>
						<td class="leftAligned">
							<input type="text" value="" id="fileName" name="fileName" maxlength="30" style="width: 298px; margin-bottom: 5px; margin-left: 5px;" readonly="readonly"/>
							<input type="hidden" value="" id="fileType"  name="fileType" />
							<input type="hidden" value="" id="fileExt" 	 name="fileExt" />
							<input type="hidden" value="" id="filePath"  name="filePath" />
							<input type="hidden" value="" id="fileSize"  name="fileSize" />
							<input type="hidden" value="" id="mediaLink" name="mediaLink" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned"><input type="text" value="" id="remarks" name="remarks" maxlength="4000" style="width: 298px; margin-bottom: 5px; margin-left: 5px;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</form>
	</div>
</div>

<div class="buttonsDivPopup">
	<input id="btnView" class="button" type="button" value="View" style="width: 90px;" />
	<input id="btnReturn" class="button" type="button" value="Return" style="width: 90px;" />
</div>
	
<script type="text/javascript">	
	try{
		var selectedRow = null;
		
		$("btnReturn").observe("click", function () {
			Modalbox.hide();
		});
		
		function viewFile(row){
			var fileType  = row.down("input", 1).value;
			var mediaLink = row.down("input", 5).value;
			var fileIcon		= row.down("img");

			if("P" == fileType){
				showMedia(fileIcon);
			} else if ("V" == fileType) {
				showVideo(mediaLink);
			}else{
				window.open(mediaLink);
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
		
		$$("label[name='lblRemarks']").each(function(lbl) {
			var id = lbl.getAttribute("id");
			$(id).update($(id).innerHTML.truncate(40, "..."));
		});

		$$("label[name='size']").each(function (lbl){
			var id = lbl.getAttribute("id");
			$(id).update(convertByteSize($(id).innerHTML));
		});
		
		function initializeObservers(){	
			try {
				
				$$("div[name='rowMedia']").each(function (row) {
					var fileIcon		= row.down("img");
				
					row.observe("mouseover", function () {
				        row.addClassName("lightblue");
			        });
			
			        row.observe("mouseout", function () {
			            row.removeClassName("lightblue");
			        });
		
					fileIcon.observe("click", function() {
						viewFile(row);
					});
				});
			
			} catch(e) {
				showErrorMessage("initializeObservers", e);
			}
		}
		
		$("btnView").observe("click", function(){
			if(nvl(selectedRow, null) == null){
				showMessageBox("Please select a file first.", "I");
				return false;
			}
			viewFile(selectedRow);
		});
		
		function checkIfToResizeFileTable(tableId, rowName) {
		    if ($$("div[name='"+rowName+"']").size() >= 3) {
		     	$(tableId).setStyle("height: 200px; overflow-y: auto;");
		    } else {
		    	$(tableId).setStyle("height: "+($$("div[name='"+rowName+"']").size()*70)+"px; overflow: hidden;"); 
			}
		    Modalbox.resizeToContent();
		}
		
		checkIfToResizeFileTable("fileListing", "rowMedia");
		addStyleToInputs();
		initializeAll();
		initializeObservers();
		initializeTable("tableContainer", "rowMedia", "fileName,fileName,fileType,fileExt,remarks,filePath,mediaLink,fileSize", 
						 function(){selectedRow = getSelectedRow("rowMedia");});
	}catch(e){
		showErrorMessage("View Attached Media", e);
	}
	
</script>