<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="attachmentListMainDiv" style="padding: 5px; margin-top: 10px; margin-bottom: 10px; float: left; width: 98%;" class="sectionDiv">
	<div id="attachmentListDiv">
		<div id="attachmentListTableDiv" style="">
			<div id="attachmentListTable" style="height: 170px; width: 587px;"></div>
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
<script type="text/javascript">
	var attachmentChangeTag = 0;
	var selectedIndex;
	objCurrAttachment = null;
	var directory = "";
	
	function setAttachmentForm(obj){
		try {
			$("txtFileName").value = (obj == null ? "" : obj.fileName);			
			$("txtRemarks").value = (obj == null ? "" : obj.remarks);
			$("btnAdd").setAttribute("enValue", obj == null ? "Add" : "Update");
			$("btnAdd").value = obj == null ? "Add" : "Update";
			(obj == null ? $("txtFile").enable() : $("txtFile").disable());			
			(obj == null ? disableButton("btnView") : enableButton("btnView"));
			(obj == null ? $("txtFileName").removeAttribute("readonly") : $("txtFileName").writeAttribute("readonly"));
		} catch(e){
			showErrorMessage("setAttachmentForm", e);
		}
	}
	
	function createAttachment(obj){
		try {
			var attachment = obj == null ? new Object() : obj;
			attachment.fileName = $F("txtFileName");
			attachment.remarks = $F("txtRemarks");
			return attachment;
		} catch (e){
			showErrorMessage("createAttachment", e);
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
	
	function uploadFile(){
		$("uploadTarget").contentWindow.document.body.innerHTML = "";
		$("progressBar").style.width = "0%";
		$("uploadForm").action = "GUEAttachController?action=uploadFile&"+ fixTildeProblem(Form.serialize("uploadForm"));
    	$("uploadForm").submit();
		
	    updater = new Ajax.PeriodicalUpdater('updaterDiv','GUEAttachController', {
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
	            				$("txtFile").clear();
	            				$("txtFile").show();
	            				$("uploadStatusDiv").hide();	            				
	            				setAttachment(result);
	            			 }
	            			});
	            } else {
	            	showMessage(response.responseText, imgMessage.ERROR);
	            	updater.stop();
	            }
	    	}
	    });	    
	}
	
	function deleteAttachment(){
		if(selectedIndex != null) {
			objCurrAttachment.recordStatus = -1;
			tbgAttachmentList.deleteRow(selectedIndex);
			setAttachmentForm(null);
			attachmentChangeTag = 1;
		} else {
			showMessageBox("Please select a record to delete.", imgMessage.INFO);
		}
	}	
	
	function viewAttachment(){
		var url = "";
		if(objCurrAttachment.url == undefined || objCurrAttachment.url == null){
			var filePath = objCurrAttachment.filePath;
			url = contextPath + filePath.substr(filePath.indexOf("/", 3), filePath.length);
		} else {
			url = objCurrAttachment.url;
		} 
		window.open(url);
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
	
	$("txtFile").observe("change", function(){
		$("txtFileName").value = $("txtFile").value;
	});
	
	$("btnAdd").observe("click", function(){
		if($("btnAdd").getAttribute("enValue") == "Add") {
			if(checkAllRequiredFieldsInDiv("attachmentFormDiv")) {
				$("txtFile").hide();
				$("uploadStatusDiv").show();
				uploadFile();
				attachmentChangeTag = 1;
			}
			/* if($F("txtFile") == ""){
				showWaitingMessageBox("Please select a file first.", imgMessage.ERROR, function(){
					$("txtFile").focus();
				});
			} else {
				$("txtFile").hide();
				$("uploadStatusDiv").show();
				uploadFile();
				attachmentChangeTag = 1; 
			} */
		} else {
			setAttachment();
		}
	});
	
	$("btnDelete").observe("click", deleteAttachment);
	
	$("btnCancel").observe("click", function(){
		if(attachmentChangeTag == 1){
			showConfirmBox4("Confirmation", "Would you like to apply changes to attachment records?", "Yes", "No", "Cancel", 
				function(){
					fireEvent($("btnAttach"), "click");
				},				
				function(){					
					tbgAttachmentList.keys.removeFocus(tbgAttachmentList.keys._nCurrentFocus, true);
					tbgAttachmentList.keys.releaseKeys();
					overlayAttachmentList.close();
				},
				""
			);
		} else {
			tbgAttachmentList.keys.removeFocus(tbgAttachmentList.keys._nCurrentFocus, true);
			tbgAttachmentList.keys.releaseKeys();
			overlayAttachmentList.close();
		}
		deleteFileDirectoryFromSever();
	});

	$("btnView").observe("click", function(){
		viewAttachment();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000);
	});	
	
	$("btnAttach").observe("click", function(){
		var setRows = tbgAttachmentList.geniisysRows;
		
		if(setRows.length == 0){
			showConfirmBox("Confirmation", "No files to attach, would you like to continue?", "Yes", "No", 
				function() {
					overlayAttachmentList.close();
				},
				""
			);
		} else {
			objGUEAttach = setRows;
			if(objAttachment.onAttach){
				objAttachment.onAttach(objGUEAttach);
			}
			overlayAttachmentList.close();
		}
		tbgAttachmentList.keys.releaseKeys();
		deleteFileDirectoryFromSever();
	});
	
	var objTGAttachmentList = JSON.parse(Object.toJSON(objGUEAttach));	
	var attachmentListTable = {
			options: {
				width: '587px',
				/* pager: {
				}, */
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgAttachmentList._mtgId;				
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						selectedIndex = y;
						if(y < 0){
							var length = tbgAttachmentList.geniisysRows.length;
							y = ((length - 1) + Math.abs(y)) - tbgAttachmentList.newRowsAdded.length;						
						}
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
					id: 'tranId',
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
					width: '300px',
					sortable: false
				},
				{
					id : "filePath",
					title: "",
					width: '0',
					visible: false
				}
				],
			rows: objTGAttachmentList
		};

	if(objGUEAttach.length > 0){
		var filePath = objGUEAttach[0].filePath;
		var fileName = objGUEAttach[0].fileName;
		directory = filePath.replace(fileName, ""); 
	}	
	tbgAttachmentList = new MyTableGrid(attachmentListTable);
	//tbgAttachmentList.pager = objTGAttachmentList;
	tbgAttachmentList.render('attachmentListTable');
</script>