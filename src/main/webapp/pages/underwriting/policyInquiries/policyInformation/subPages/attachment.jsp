<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="attachmentListMainDiv" style="padding: 5px; margin-top: 10px; margin-bottom: 10px; float: left; width: 98%;" class="sectionDiv">
	<div id="attachmentListDiv">
		<div id="attachmentListTableDiv" style="">
			<div id="attachmentListTable" style="height: 220px; width: 580px;"></div>
		</div>
	</div>	
	<div id="attachmentFormDiv" style="float: left; width: 100%; margin-top: 5px;">
		<form id="uploadForm" name="uploadForm" enctype="multipart/form-data" method="POST" action="" target="uploadTarget">	
			<table align="center">
				<!-- <tr>
					<td class="rightAligned">Browse </td>
					<td class="leftAligned">				
						<input type="file" id="txtFile" name="txtFile" readonly="readonly" size="40" readonly="readonly">
						<div id="uploadStatusDiv" style="display: none; padding: 2px; width: 336px; height: 18px; border: 1px solid gray; float: left; background-color: white;">
							<span id="progressBar" style="background-color: #66FF33; height: 18px; float: left;"></span>
						</div>
					</td>
				</tr>	 -->	
				<tr>
					<td class="rightAligned">File Name </td>
					<td class="leftAligned"><input type="text" id="txtFileName" name="txtFileName" style="width: 335px;" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks </td>
					<td class="leftAligned">
						<div style="border: 1px solid gray; height: 20px; width: 340px;">
							<textarea id="txtRemarks" name="txtRemarks" style="width: 316px; border: none; height: 13px; resize: none;" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 2px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>	
			</table>
		</form>
		<iframe id="uploadTarget" name="uploadTarget" height="0" width="0" frameborder="0" scrolling="no" style="display: none;"></iframe>
		<div id="updaterDiv" name="updaterDiv" style="visibility: hidden; display: none; height: 0; width: 0"></div>		
	</div>	
</div>
<div id="buttonsDiv" style="float: left; width: 100%;">
	<table align="center">
		<tr>
			<td>
				<input type="button" class="button" style="width: 90px;" id="btnReturn" name="btnReturn" value="Return" />
				<input type="button" class="disabledButton" style="width: 90px;" id="btnView" name="btnView" value="View"/>
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	var attachmentChangeTag = 0;
	var selectedIndex;
	objCurrAttachment = null;
	var directory = "";
	
	function setAttachmentForm(obj){
		try {
			$("txtFileName").value = (obj == null ? "" : unescapeHTML2(obj.fileName));	//marco - 05.21.2015 - GENQA SR 4444
			$("txtRemarks").value = (obj == null ? "" : unescapeHTML2(obj.remarks));	//
			(obj == null ? disableButton("btnView") : enableButton("btnView"));
			(obj == null ? $("txtFileName").removeAttribute("readonly") : $("txtFileName").writeAttribute("readonly"));
		} catch(e){
			showErrorMessage("setAttachmentForm", e);
		}
	}
	
	function setAttachment(result){
		try {
			var attachment = createAttachment(objCurrAttachment);
			if($("btnAdd").getAttribute("enValue") == "Add"){
				attachment.url = contextPath+"/"+result.uploadPath.replace(/\\/g, "/") + "/"+ result.fileName;
				attachment.filePath = result.filePath;
				tbgAttachmentList.addRow(attachment);
			} else {
				tbgAttachmentList.updateRowAt(attachment, selectedIndex);
			}
			directory = attachment.filePath;
			setAttachmentForm(null);						
		} catch (e){
			showErrorMessage("setAttachment", e);
		}
	}		
	
	function viewAttachment(){
		/* var url = "";
		if(objCurrAttachment.url == undefined || objCurrAttachment.url == null){
			var filePath = unescapeHTML2(objCurrAttachment.filePath); //added by steven 07.30.2014
			//url = contextPath + filePath.substr(filePath.indexOf("/", 3), filePath.length); //Dren 02.26.2016 SR-21630
			//url = contextPath + filePath.substr(filePath.indexOf("/", 3), filePath.length).replace(/#/g, "%23"); //Dren 02.26.2016 SR-21630
			url = contextPath + filePath.substr(filePath.indexOf("/", 3), filePath.length);
		} else {
			url = objCurrAttachment.url;
		} 
		//window.open(url);
		window.open(escape(unescapeHTML2(url))); */ // SR-24028,23982 JET MAR-24-2017
		
		var url = "";
		var filePath = unescapeHTML2(tbgAttachmentList.geniisysRows[selectedIndex].filePath);

		writeFileToServer(filePath);

		url = contextPath + filePath.substr(filePath.indexOf("/", 3), filePath.length);
		window.open(escape(unescapeHTML2(url)));
	}
	
	function writeFileToServer(filePath) { // SR-24028,23982 JET MAR-24-2017
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
	
	function deleteFileDirectoryFromSever(){
		new Ajax.Request(contextPath+"/GUEAttachController", {
			method: "POST",
			parameters : {action : "deleteFileDirectoryFromServer",
						  directory : directory},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					
				}
			}
		});
	}	
	
	$("btnReturn").observe("click", function(){
		tbgAttachmentList.keys.removeFocus(tbgAttachmentList.keys._nCurrentFocus, true);
		tbgAttachmentList.keys.releaseKeys();
		overlayAttachmentList.close();
		delete overlayAttachmentList;
		deleteFileDirectoryFromSever();
	});

	$("btnView").observe("click", function(){
		/* SR-5494 JET SEPT-26-2016 */
		new Ajax.Request(contextPath + "/FileController", {
			parameters: {
				action: "isFileExists",
				fileFullPath: tbgAttachmentList.geniisysRows[selectedIndex].filePath
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
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	
	
	var objTGAttachment = JSON.parse('${picturesTableGrid}');
	if(objTGAttachment.rows.length > 0) {
		for(var i=0; i<objTGAttachment.rows.length; i++){
			var fileName = objTGAttachment.rows[i].fileName;
			objTGAttachment.rows[i].filePath = fileName;
			objTGAttachment.rows[i].fileName = fileName.substr(fileName.lastIndexOf("/")+1, fileName.length);
		}
	}
	var attachmentListTable = {
			options: {
				width: '608px',
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgAttachmentList._mtgId;				
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						selectedIndex = y;
						objCurrAttachment = tbgAttachmentList.geniisysRows[y];
						setAttachmentForm(objCurrAttachment);
					}
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgAttachmentList.keys.removeFocus(tbgAttachmentList.keys._nCurrentFocus, true);
					tbgAttachmentList.keys.releaseKeys();
					selectedIndex = null;
					setAttachmentForm(null);
				},
				prePager: function (){

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
					id: 'policyId',
					width: '0',
					visible: false 
				},				
				{
					id: 'itemNo',
					width: '0',
					visible: false 
				},				
				{
					id : "fileName",
					title: "File Name",
					width: '250px',
					sortable: false
				},
				{
					id : "remarks",
					title: "Remarks",
					width: '320px',
					sortable: false
				},
				{
					id : "filePath",
					title: "",
					width: '0',
					visible: false
				}
				],
			rows: objTGAttachment.rows
		};

/* 	if(objGUEAttach.length > 0){
		var filePath = objGUEAttach[0].filePath;
		var fileName = objGUEAttach[0].fileName;
		directory = filePath.replace(fileName, ""); 
	} */
	tbgAttachmentList = new MyTableGrid(attachmentListTable);
	tbgAttachmentList.render('attachmentListTable');
</script>