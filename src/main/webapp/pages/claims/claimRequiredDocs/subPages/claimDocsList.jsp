<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>

<!-- <div id="docsListMainDiv" style="margin: 5px;">
	<div style="margin-top: 10px; width: 100%;" id="docsListingTable" name="docsListingTable">
		<div class="tableHeader" style="width: 100%;">
			<label style="width: 25%; text-align: center; margin-left: 56px;">Quotation No.</label>
			<label style="width: 15%; text-align: center;">Assured No.</label>
			<label style="text-align: center;">Assured Name</label>
		</div>
	</div>	overlay_modal
</div> -->
<div id="docsListMainDiv" class="sectionDiv">
	<div style="float: left; margin-top: 10px; margin-left: 10px">
		<label style="margin-right: 5px; margin-top: 5px;">Find</label>
		<input type="text" id="findTextInput" name="findTextInput" value="%" style="width: 200px;  readonly="readonly">
	</div>
	<div id="clmDocListTGDiv" >
		<jsp:include page="/pages/claims/claimRequiredDocs/subPages/claimDocsTg.jsp"></jsp:include>
	</div>
	<div class="buttonsDiv" style="margin-bottom: 0px;">
		<input type="button" id="btnSelectAll"	name="btnSelectAll" class="button hover"	value="Select All"/>
		<input type="button" id="btnClear"	name="btnClear" class="button hover"	value="Clear"/>
	</div> 
	<div class="buttonsDiv">
		<input type="button" id="btnSave"	name="btnSave" class="button hover"	value="Save"/>
		<input type="button" id="btnCancel" name="btnCancel" style="width: 90px;" class="button hover"   value="Cancel" />
	</div> 
</div>

<script>
	var idx = new Array();
	$("overlayTitleDiv").remove();
	$("findTextInput").observe("keypress", function(event){
		if(event.keyCode == 13){
			idx = null;
			if(docsListTableGrid.rows != ""){ //added by robert to prevent js error that causes filter not to function 04.02.2013 sr 12720
				idx = docsListTableGrid._getSelectedRowsIdx();
			}else{
				idx = [];
			}
			if(idx.length > 0){
				showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
				return false;
			} else {
				$("findText").value = $F("findTextInput");		
				docsListTableGrid.url = contextPath+"/GICLReqdDocsController?action=getDocsList&refresh=1&lineCd="+objCLMGlobal.lineCd
				+"&sublineCd="+objCLMGlobal.sublineCd+"&findText="+encodeURIComponent($F("findText"))+"&claimId="+ objCLMGlobal.claimId+"&refresh=1";
				docsListTableGrid._refreshList();
			}
			
			
			/* new Ajax.Updater("clmDocListTGDiv",  contextPath+"/GICLReqdDocsController?action=getDocsList&refresh=1&lineCd="+objCLMGlobal.lineCd
					+"&sublineCd="+objCLMGlobal.sublineCd+"&findText="+encodeURIComponent($F("findText"))+"&claimId="+ objCLMGlobal.claimId, 
					{method: "POST",
					evalScripts: true,
					asynchronous: false}
			); */
		}
	});
	
	$("btnCancel").observe("click", function(){
		try{
			idx = null;
			idx = docsListTableGrid._getSelectedRowsIdx();
			if(idx.length == 0){
				docsListTableGrid.keys.removeFocus(docsListTableGrid.keys._nCurrentFocus, true);
				docsListTableGrid.keys.releaseKeys();
				//Windows.close("modal_dialog_docsList1");
				docsPostSave();
				/* winWorkflow.close();
				delete winWorkflow; */
			}else{
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
						"Yes", "No", "Cancel", function() {
							//objExit.exit = true;
							fireEvent($("btnSave"), "click");
						}, function() {
							docsListTableGrid.keys.removeFocus(docsListTableGrid.keys._nCurrentFocus, true);
							docsListTableGrid.keys.releaseKeys(); 
							//Windows.close("modal_dialog_docsList1"); 
							docsPostSave();
							/* winWorkflow.close();
							delete winWorkflow; */
						}, "");
			}
		}catch(e){
				showErrorMessage("addDocuments",e);
		}
	});
	
	$("btnSelectAll").observe("click", function(){
		for ( var i = 0; i <docsListTableGrid.rows.length; i++) {
			docsListTableGrid.setValueAt(true,docsListTableGrid.getColumnIndex('recordStatus'),i, true);
			$("mtgIC"+docsListTableGrid._mtgId+"_"+docsListTableGrid.getColumnIndex('recordStatus')+","+i).removeClassName('modifiedCell');
		}  
		//docsListTableGrid.setValueAt(true,docsListTableGrid.getColumnIndex('recordStatus'),1, true);
	});
	
	$("btnClear").observe("click",function(){
		for ( var i = 0; i <docsListTableGrid.rows.length; i++) {
			docsListTableGrid.setValueAt(false,docsListTableGrid.getColumnIndex('recordStatus'),i, true);
			$("mtgIC"+docsListTableGrid._mtgId+"_"+docsListTableGrid.getColumnIndex('recordStatus')+","+i).removeClassName('modifiedCell');
		}  
	});
	
	
	$("btnSave").observe("click",function(){
		try{
		idx = null;
		idx = docsListTableGrid._getSelectedRowsIdx();
		if(idx.length == 0){
			showMessageBox("No document selected.", imgMessage.INFO);
		}else{
			showConfirmBox("Confirmation", "All checked documents will be added to the list in the main screen. Are you sure you want to continue?", "Yes", "No", addDocuments, "");
		}
		}catch(e){
			showErrorMessage("addDocuments",e);
		}
	});
	function addDocuments(){
		try{
			var docsArray = new Array();
			for ( var i = 0; i < idx.length; i++) {
				var doc = new Object();
				doc.clmDocCd = docsListTableGrid.getValueAt(docsListTableGrid.getColumnIndex('clmDocCd'), idx[i]);
				doc.clmDocDesc = escapeHTML2(docsListTableGrid.getValueAt(docsListTableGrid.getColumnIndex('clmDocDesc'), idx[i])); //added by steven 04.06.2013 to handle the " character.
				docsArray.push(doc);
			}
			var objParameters = new Object();
			objParameters.addDocs = docsArray;
			objParameters.claimId = objCLMGlobal.claimId;
			objParameters.lineCd = objCLMGlobal.lineCd; 
			objParameters.sublineCd = objCLMGlobal.sublineCd;
			objParameters.issCd = objCLMGlobal.issCd;
			var strParameters = JSON.stringify(objParameters);
			new Ajax.Request(contextPath+"/GICLReqdDocsController",{
				method: "POST",
				evalScripts: true,
				asynchronous: false,
				parameters:{
					action: "saveClaimDocs",
					strParameters: strParameters,
					mode: "insert"
				},onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function (response) {	
					hideNotice();
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}else{
						docsListTableGrid.releaseKeys(); //added code to allow Enter Key in Remarks field after saving by MAC 11/12/2013.
						//separate display of message and hiding of required document list after saving as replacement for function showWaitingMessageBox by MAC 11/07/2013.
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						docsPostSave();
						//comment out by MAC 11/07/2013
						//showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, docsPostSave); //change by steven 11/13/2012 from: "response.responseText"  to: objCommonMessage.SUCCESS
					}
				}
			});
		}catch(e){
			showErrorMessage("addDocuments",e);
		}
	}
	
	function docsPostSave(){
		Windows.close("modal_dialog_docsList1");
		showClaimRequiredDocs();
	};
</script>
