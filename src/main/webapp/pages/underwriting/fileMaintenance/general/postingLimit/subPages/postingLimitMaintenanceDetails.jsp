<div id="postingLimitTable">
	<jsp:include page="/pages/underwriting/fileMaintenance/general/postingLimit/subPages/postingLimitMaintenanceTableGrid.jsp"></jsp:include>
</div>
<div id="postingLimitTableMaintenanceFormDiv" style="margin-top: 10px; margin-bottom: 10px;">
	<table align="center">
		<tr>
			<td class="rightAligned">Line</td>
			<td class="leftAligned" colspan="3">
				<div class="required" style="border: 1px solid gray; width: 405px; height: 21px; float: left; margin-right: 3px;">
					<input class="required" id="txtLineName" type="text" value="" style="width: 370px; height: 13px; float: left; border: none; margin-top: 0px;" readonly="readonly" name="txtLineName" tabindex="201"/>
					<img id="btnSearchLine" alt="Go" name="btnSearchLine" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;" tabindex="202">
				</div>
				<input id="hidLineName" name="hidLineName" type="hidden" /> 
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Posting Limit</td>
			<td class="leftAligned"><input type="text" id="txtPostingLimit" name="txtPostingLimit" class="applyDecimalRegExp" hasOwnKeyUp="Y" hasOwnBlur="Y" hasOwnChange="Y" customLabel="Posting Limit" max="999999999.99" min="0.00" regexppatt="pDeci0902" style="width: 145px;" maxlength="12" readonly="readonly" tabindex="203"/></td>
			<td colspan="1" class="leftAligned">
				<td class="leftAligned">
					<!-- for insert/update display -->
					<input type="checkbox" id="chkAllAmount" name="chkAllAmount" style="float: left; margin: 0pt; width: 13px; height: 13px;" disabled="disabled" tabindex="204"/> 
					<label for="chkAllAmount" style="float: left; margin-left: 3px;" title="All Amount"> All Amount </label>
				</td>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Endt. Posting Limit</td>
			<td class="leftAligned"><input type="text" id="txtEndtPostingLimit" name="txtEndtPostingLimit" class="applyDecimalRegExp" hasOwnKeyUp="Y" hasOwnBlur="Y" hasOwnChange="Y" customLabel="Endt. Posting Limit" max="999999999.99" min="0.00" regexppatt="pDeci0902" style="width: 145px;" maxlength="12" readonly="readonly" tabindex="205"/></td>
			<td colspan="1" class="leftAligned">
				<td class="leftAligned">
					<!-- for insert/update display -->
					<input type="checkbox" id="chkEndtAllAmount" name="chkEndtAllAmount" style="float: left; margin: 0pt; width: 13px; height: 13px;" disabled="disabled" tabindex="206"/>
					<label for="chkEndtAllAmount" style="float: left; margin-left: 3px;" title="All Amount"> Endt. All Amount </label>	<!--Gzelle 03212014 changed to chkEndtAllAmount-->
				</td>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">User ID</td>
			<td class="leftAligned"><input type="text" id="txtUserId" name="txtUserId" style="width: 145px;" readonly="readonly" tabindex="207"/></td>
			<td class="rightAligned" style="width:88px;">Last Update</td>
			<td class="leftAligned"><input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 145px;" readonly="readonly" tabindex="208"/></td>
		</tr>
		<tr hidden="hidden">
			<td class="rightAligned">Other Params</td>
			<td>
				<input type="hidden" id="hidPostingUser" name="hidPostingUser"/>
				<input type="hidden" id="hidIssCd" name="hidIssCd"/>
				<input type="hidden" id="hidLineCd" name="hidLineCd"/>
				<input type="hidden" id="hidLastValidPostingLimit" name="hidLastValidPostingLimit"/>
				<input type="hidden" id="hidLastValidEndtPostingLimit" name="hidLastValidEndtPostingLimit"/>
				<!-- stores the value retrieved from tablegrid --> 
				<input type="checkbox" id="chkAllAmountSw" name="chkAllAmountSw" customLabel="endorsement" style="visibility: hidden;" />
				<!-- previous status of checkbox, used to determine if confirmation message box will be shown -->
				<input type="checkbox" id="prevAllAmount" name="prevAllAmount" style="visibility: hidden;"> 
				<!-- stores the value retrieved from tablegrid --> 
				<input type="checkbox" id="chkEndtAllAmountSw" name="chkEndtAllAmountSw" style="visibility: hidden;" />
				<!-- previous status of checkbox, used to determine if confirmation message box will be shown -->
				<input type="checkbox" id="prevEndtAllAmount" name="prevEndtAllAmount" style="visibility: hidden;" />
			</td>
		</tr>
	</table>
	<div style="float:left; width: 100%; margin-bottom: 10px; margin-top: 10px;" align="center">
		<input type="button" class="disabledButton" id="btnAddPostingLimit" name="btnAddPostingLimit" value="Add" disabled="disabled" tabindex="301"/>
		<input type="button" class="disabledButton" id="btnDeletePostingLimit" name="btnDeletePostingLimit" value="Delete" disabled="disabled" tabindex="302"/>
	</div>
	<div class="sectionDiv" style="float:left; padding-top:9px; margin-left:50px; width:820px; margin-bottom:10px; border-bottom: none; border-left: none; border-right: none; border-top-width: thin;" align="center">
		<input type="button" class="disabledButton" id="btnCopyToAnotherUserPostingLimit" name="btnCopyToAnotherUserPostingLimit" value="Copy to Another User" disabled="disabled" tabindex="303"/>
	</div>
</div>
<script type="text/javascript">
	try {
		objGiiss207.lineResponse = "";
		//add or update posting limit record in table grid
		function addUpdatePostingLimit(){ 
	 		postLimitObj = objGiiss207.createPostLimitObj($("btnAddPostingLimit").value);
	 		if (checkAllRequiredFieldsInDiv("postingLimitTableMaintenanceFormDiv")) {
	 	 		if ($("btnAddPostingLimit").value != "Add") {
	 	 			objPostingLimitMain.splice(objGiiss207.selectedIndex, 1, postLimitObj);
	 	 		 	postingLimitTableGrid.updateVisibleRowOnly(postLimitObj, objGiiss207.selectedIndex);
	 	 		 	postingLimitTableGrid.onRemoveRowFocus();
	 	 		 	changeTag = 1;
	 	 		 	changeCounter++;
	 			} else {
	 				unsavedStatus = 1;
	 				objPostingLimitMain.push(postLimitObj);
	 		 	 	postingLimitTableGrid.addBottomRow(postLimitObj);
	 		 		postingLimitTableGrid.onRemoveRowFocus();
	 		 		changeTag = 1;
	 		 		changeCounter++;
	 			}
			}
	 	}
	 	
		//delete posting limit record in table grid
	 	function deletePostingLimit(){
	 		delObj = objGiiss207.createPostLimitObj($("btnDeletePostingLimit").value);
	 		if (objGiiss207.selectedIndex != null){
	 			objPostingLimitMain.splice(objGiiss207.selectedIndex, 1, delObj);
	 			postingLimitTableGrid.deleteVisibleRowOnly(objGiiss207.selectedIndex);
	 			postingLimitTableGrid.onRemoveRowFocus();
				if(changeCounter == 1 && delObj.unsavedStatus == 1){
					changeTag = 0;
					changeCounter = 0;
				}else{
					changeCounter++;
					changeTag=1;
				}
	 		}
	 	}
		
	   	/*Search for:
		* line name doesn't exist in giis_line
		* - responseText = 'X'
		* line name exists in giis_line and in giis_posting_limit
		* - responseText = '0'
		* line name exists in giis_line but not in giis_posting_limit
		* - responseText = '1'
		* line name returned more than 1 row
		* - responseText = 'SQL Exception' set to 'Y'
		*/
		function validateLineName(lineName, callingElement) {
			new Ajax.Request(contextPath + "/GIISPostingLimitController", {
				method: "POST",
				parameters: {
					action : "validateLineName",
					lineName : lineName,
					userId : userListingRowValue.userId,
					issCd : issueSourceListingRowValue.issCd
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(callingElement == "btnAddPostingLimit"){
						if (response.responseText == '0') {
							customShowMessageBox("Line must be unique.", imgMessage.INFO, "txtLineName");
						} else {
							addUpdatePostingLimit();	
						}
					}else{
						if (response.responseText == 'X') {
							objGiiss207.lineResponse = response.responseText;
							showLineLOV(" ", " ", lineName);
						} else if (response.responseText == '0') {
							objGiiss207.lineResponse = response.responseText;
							customShowMessageBox("Line must be unique.", imgMessage.INFO, "txtLineName");
							if (isRecordSelected == true) {
								customShowMessageBox("Line must be unique.", imgMessage.INFO, "txtLineName");
								$("txtLineName").value = $("hidLineName").value;
							}
						} else if(response.responseText == '1') {
							objGiiss207.lineResponse = response.responseText;
							showLineLOV(userListingRowValue.userId, issueSourceListingRowValue.issCd, lineName);
							isRecordSelected == true;
							$("hidLineName").value = $("txtLineName").value;
						} else if (response.responseText.include("Sql Exception")) {
							objGiiss207.lineResponse = 'Y';
							showLineLOV(userListingRowValue.userId, issueSourceListingRowValue.issCd, lineName);
						}
					}
				}
			});			
		}
		
		//show copy user overlay
		$("btnCopyToAnotherUserPostingLimit").observe("click", function() {
	 	overlayCopyToAnotherUser = Overlay.show(contextPath+"/GIISPostingLimitController", {
	 		urlContent: true,
	 		urlParameters: {action : "showCopyToAnotherUser"},
	 		title: "Copy To Another User",
	 		height: 240,
	 		width: 295,
	 		draggable: true
	 		});
		});
		
		
		//search observer
	 	$("btnSearchLine").observe("click", function(){
	 		showLineLOV(userListingRowValue.userId, issueSourceListingRowValue.issCd, $("txtLineName").value);
	 	});		
		
	 	$("txtLineName").observe("change", function(){
	 		if ($("txtLineName").value != "") {
				validateLineName($("txtLineName").value, "txtLineName");
			}
	 	});
		
		//add and delete button observers
		$("btnAddPostingLimit").observe("click", function() {
			if ($("btnAddPostingLimit").value != "Add") {
				addUpdatePostingLimit();
			}else {
				validateLineName($("txtLineName").value, "btnAddPostingLimit");
	 			/*if (objGiiss207.lineResponse == 0) {
					customShowMessageBox("Line must be unique.", imgMessage.INFO, "txtLineName");
				} else {
					addUpdatePostingLimit();
				}*/ //commented by: Nica 05.27.2013 already include these codes in validateLineName function
			}
			changeTagFunc = objGiiss207.savePostingLimits;
		});
		
		$("btnDeletePostingLimit").observe("click", function() {
			changeTagFunc = objGiiss207.savePostingLimits;
			deletePostingLimit();
		});
		initializeAll();
	} catch (e) {
		showErrorMessage("Posting Limit Details", e);
	}

</script>