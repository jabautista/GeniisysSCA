<div id="signatoryMainDiv">
	<div id="signatoryMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="signatoryExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<jsp:include page="/pages/underwriting/fileMaintenance/general/signatory/subPages/signatoryReportListing.jsp"/>
	<jsp:include page="/pages/underwriting/fileMaintenance/general/signatory/subPages/signatoryDetailListing.jsp"/>
	
	<div class="buttonsDiv" style="float:left; width: 100%;">
		<input type="button" class="button" id="btnCancelSignatory" name="btnCancelSignatory" value="Cancel" tabindex=301 />
		<input type="button" class="button" id="btnSaveSignatory" name="btnSaveSignatory" value="Save" tabindex=302/>
	</div>
	
</div>
<script>
	
	function exitSignatory(){
		deleteFilesFromServer();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	}

	//observeCancelForm("signatoryExit", function(){changeTag = 0;}, exitSignatory);
	//observeCancelForm("btnCancelSignatory", function(){changeTag = 0; }, exitSignatory);
	observeReloadForm("reloadForm", showSignatoryMaintenance);
	
	/* $("btnSaveSignatory").observe("click", function () {
		saveSignatory();
	}); */
	
	objGIISS116Func = new Object();
	
	objGIISS116Func = {
		saveSignatory : function(exit){
			try{
				var reportRows = getAddedAndModifiedJSONObjects(signatoryGrid.geniisysRows);
				var setRows = getAddedAndModifiedJSONObjects(signatoryDetailGrid.geniisysRows);				
				var delRows = getDeletedJSONObjects(signatoryDetailGrid.geniisysRows);
				
				//marco - 06.13.2013
				if(reportRows.length > 0 && setRows.length < 1){
					showMessageBox("Please add signatory first.", "I");
					return false;
				}
				
				new Ajax.Request(contextPath+"/GIISSignatoryController", {
					method : "POST",
					parameters : {action : "saveGIISSignatory",
								  setRows : prepareJsonAsParameter(setRows),
								  delRows : prepareJsonAsParameter(delRows)},
					onCreate: function(){
						showNotice("Saving, please wait...");
					},
					onComplete : function (response){
						hideNotice("");
						if(checkErrorOnResponse(response)){
							if("SUCCESS" == response.responseText){								
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
									$("txtReportId").setAttribute("lastValidValue", "");
									$("txtIssCd").setAttribute("lastValidValue", "");
									$("txtLineCd").setAttribute("lastValidValue", "");
									$("txtSignatoryId").setAttribute("lastValidValue", "");
									
									$("txtReportTitle").setAttribute("lastValidValue", "");
									$("txtIssName").setAttribute("lastValidValue", "");
									$("txtLineName").setAttribute("lastValidValue", "");
									$("txtSignatory").setAttribute("lastValidValue", "");
									if(exit) {
										changeTag = 0;
										signatoryChangeTag = 0;
										signatoryDetailGrid.refresh();
										signatoryGrid.refresh();
										exitSignatory();
									} else {
										changeTag = 0;
										signatoryChangeTag = 0;
										signatoryDetailGrid.refresh();
										signatoryGrid.refresh();
									}
								});
							}
						}
					}
				});
			}catch (e){
				showErrorMessage("saveSignatory", e);
			}
		}	
	};
	
	observeSaveForm("btnSaveSignatory", objGIISS116Func.saveSignatory); //marco - 05.29.2013
	
	$("signatoryExit").observe("click", function(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS116Func.saveSignatory("exit");
					}, function(){
						exitSignatory();
					}, "");
		} else {
			exitSignatory();
		}
	});
	
	$("btnCancelSignatory").observe("click", function(){
		$("signatoryExit").click();
	});
	
	/* function saveSignatory(){
		try{
			var reportRows = getAddedAndModifiedJSONObjects(signatoryGrid.geniisysRows);
			var setRows = getAddedAndModifiedJSONObjects(signatoryDetailGrid.geniisysRows);
			var delRows = signatoryDetailGrid.getDeletedRows();
			
			//marco - 06.13.2013
			if(reportRows.length > 0 && setRows.length < 1){
				showMessageBox("Please add signatory first.", "I");
				return false;
			}
			
			new Ajax.Request(contextPath+"/GIISSignatoryController", {
				method : "POST",
				parameters : {action : "saveGIISSignatory",
							  setRows : prepareJsonAsParameter(setRows),
							  delRows : prepareJsonAsParameter(delRows)},
				onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete : function (response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						if("SUCCESS" == response.responseText){
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								changeTag = 0;
								signatoryDetailGrid.refresh();
								signatoryGrid.refresh();
							});
						}
					}
				}
			});
		}catch (e){
			showErrorMessage("saveSignatory", e);
		}
	} */
	
	//pol cruz, 10.23.2013
	//for deleting of images in the server
	function deleteFilesFromServer(){
		try{
			new Ajax.Request(contextPath+"/GIISSignatoryController", {
				method: "POST",
				parameters : {
				action : "GIISS116DeleteFilesFromServer"
							  },
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
			showErrorMessage("deleteFilesFromServer",e);
		}
	}
	
	
	changeTag = 0;
	signatoryChangeTag = 0;
	changeTagFunc = objGIISS116Func.saveSignatory;
	setDocumentTitle("Signatory Maintenance");
	setModuleId("GIISS116");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	deleteFilesFromServer();
	$("txtReportId").focus();
</script>