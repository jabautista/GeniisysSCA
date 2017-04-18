<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
	request.setAttribute("path", request.getContextPath());
%>

<div id=lineSublineMainDiv name="lineSublineMainDiv" style="margin-top: 1px; display: none;" >
	<form id="lineSublineForm" name="lineSublineForm">
		<jsp:include page="/pages/underwriting/packPar/subPages/packParInformation.jsp"></jsp:include>

		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Line and Subline Coverages</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		
		<div id="lineSublineFormDiv" name="lineSublineFormDiv" class="sectionDiv"  align="center" >
			<div id="lineSublineInfoDiv" name=lineSublineInfoDiv style="margin: 10px; width: 700px;" changeTagAttr="true">
				<div class="tableHeader" id="lineSublineInfoTable" name="lineSublineInfoTable">
					<label style="width: 160px; text-align: left; margin-left: 10px;">Line</label>
					<label style="width: 230px; text-align: left; margin-left: 5px;">Subline</label>
					<label style="width: 130px; text-align: left; margin-left: 5px;">Remarks</label>
				</div>
				<input type="hidden" id="selectedRow" value=""/>
				<div class="tableContainer" id="lineSublineList" name="lineSublineList">
				</div>
			</div>
			
			<div id="lineSublineInfoFormDiv" name="lineSublineInfoFormDiv" style="width: 100%; margin: 10px 0px 5px 0px" changeTagAttr="true">
				<table align="center" width="50%">
					<tr>
						<td class="rightAligned" width="20%">Line</td>
						<td class="leftAligned" width="80%">
							<input type="text" id="displayLine" readonly="readonly" class="required" style="width: 68%; display: none;" />
							<select id="packLineCdOpt" name="packLineCdOpt" style="width: 70%;" class="required">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="20%">Subline</td>
						<td class="leftAligned" width="80%">
							<input type="text" id="displaySubline" readonly="readonly" class="required" style="width: 68%; display: none;" />
							<select id="packSublineCdOpt" name="packSublineCdOpt" style="width: 70%;" class="required">
								<option value=""></option>
								
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 69.3%;" changeTagAttr="true">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="remarks" name="remarks" style="width: 70%; border: none; height: 13px;" ></textarea>
							<img class="hover" src="${path}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
						</td>
					</tr>
				</table>				
			</div>		
			<div style="margin-bottom: 10px;" changeTagAttr="true">
				<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
				<input type="button" class="button" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
			</div>	
		</div>
		
		<div class="buttonsDiv" id="infoButtonsDiv">
			<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
			<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
		</div>
	</form>
</div>

<script>
/*
 * Create By Irwin Tabisora.
 */	

 
	objLineSubline =  JSON.parse('${objLineSubline}'.replace(/\\/g, '\\\\'));
	var objLineSublineItems = JSON.parse('${objLineSublineItems}'.replace(/\\/g, '\\\\'));
	var objprocess;
	setCursor("wait");
    changeTag = 0;
	setPackLineCd(objLineSubline);
	showLineSublineItems();
	disableButton("btnDelete");
	
	var objGIPIWPackLineSublineTemp = {};
	/* $("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox("No changes to save.", imgMessage.INFO);	
		}else{
			saveLineSubline();
		}
	});  */
	
	//Rey Jadlocon 11-21-2011
	$("packLineCdOpt").observe("change", function(){
		setPackSublineCd(objLineSubline);		
		if ("" == $F("packLineCdOpt")){
			$("remarks").value ="";
		}
	});
	
	$("packLineCdOpt").observe("blur", function(){
		if ("" == $F("packLineCdOpt")){
			($$("div#lineSublineInfoFormDiv [changed=changed]")).invoke("removeAttribute", "changed");
			changeTag = 0;
		}
	});
	
	function saveLineSubline(){ 
			try{
				if(checkPendingRecordChanges()){		
					if($$("div#lineSublineInfoFormDiv [changed=changed]").length > 0){
						fireEvent($("btnAdd"), "click");			
					}	 			
					var modRows = getModifiedJSONObjects(objLineSublineItems);
					var addRows = getAddedJSONObjects(objLineSublineItems);
					var delRows = getDeletedJSONObjects(objLineSublineItems);
					var objParameters = new Object();
			
					objParameters.addRows = addRows;
					objParameters.modRows = modRows;
					objParameters.delRows = delRows;
					var strParameters = JSON.stringify(objParameters);
			
					new Ajax.Request(contextPath+"/GIPIWPackLineSublineController?action=saveLineSubline&packParId="+objUWGlobal.packParId, {
						method: "POST",
						evalScripts: true,
						asynchronous: true,
						parameters: {
							lineCd: objUWGlobal.lineCd,
							issCd: objUWGlobal.issCd,
							parameter: strParameters
						},
						onCreate: function(){
							showNotice("Saving changes...");
							$("lineSublineForm").disable();
						},
						onComplete: function (response)	{
							hideNotice();
							if (checkErrorOnResponse(response)) {
								//hideNotice(response.responseText);
								if(response.responseText == "SUCCESS"){
									changeTag = 0;
									updatePackParParameters();
									showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, //showLineSublineCoverages);
												function(){
													showLineSublineCoverages();
														if(objGIPIWPackLineSublineTemp.confirmation){
														    objGIPIWPackLineSublineTemp.confirmation();
														}
										}
									);		
									clearObjectRecordStatus(objLineSublineItems);
									$("lineSublineForm").enable();
									if($$("div[name='rowLineSubline']").size() > 0){
										objTempUWGlobal.withPackLineSublineTag = true;
									}
								}else{
									showMessageBox(response.responseText, imgMessage.ERROR);
								}
							}
						}
					});
				}
			}catch(e){
				showErrorMessage("saveLineSubline", e);
			}
	}

	$$("div[name='rowLineSubline']").each(function (row){
		row.observe("click", function(){
			if (row.hasClassName("selectedRow")){
				displayLineSublineItemInfo(false, null);
			} else {
				displayLineSublineItemInfo(true, row);
			} 
		});
	});
	$("btnDelete").observe("click",deleteLineSubline);

	function deleteLineSubline(){
		$$("div[name='rowLineSubline']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
				var packLineCd = row.down("input", 0).value;
				var packSublineCd = row.down("input", 2).value;
				var parId = row.down("input", 5).value;
				var dspTag =  row.down("input", 6).value;
				var newRec = row.down("input", 7).value;
				var items = 0;
				var perils = 0;
				var hasItems = 'N'; 
				var hasPerils = 'N';
				// START of KEYDELREC of forms. 
				if(dspTag !='Y'){
					if(newRec == "N"){
						//checks if the existing line/subline has items and perils. If so, additional functions will be executed in the DAOImpl of this module. - irwin
						new Ajax.Request(contextPath+"/GIPIWPackLineSublineController?action=checkIfExistGIPIWPackItemPeril", {
							parameters: {
								packLineCd: packLineCd,
								packSublineCd: packSublineCd,
								parId: parId
							},onCreate: function(){
								//showNotice("Checking Items...");
								$("lineSublineForm").disable();
							},onComplete: function(response){
								//hideNotice2();
								var message = response.responseText.split(','); // 0= item count, 1 = peril count
								var items = message[0];
								var perils = message[1]; 
								var alertMessage = "There are existing item(s) for this line/subline coverage. Deleting it will delete the corresponding item record(s) and might affect the invoice and distribution."; 
								if(items> 0 && perils >0){
									showConfirmBox("Delete Items", alertMessage, "Ok","Cancel",function(){
										var hasItems = 'Y';
										var hasPerils = 'Y';
										continueDelete(row,packLineCd, packSublineCd, parId, hasItems, hasPerils);
									}, function(){
										return false;						
									});
								}else if(items> 0 && perils == 0){
									showConfirmBox("Delete Items", alertMessage, "Ok","Cancel",function(){
										var hasItems = 'Y';
										continueDelete(row,packLineCd, packSublineCd, parId, hasItems, hasPerils);
									}, function(){
										return false;						
									});
								}else{
									continueDelete(row,packLineCd, packSublineCd, parId, hasItems, hasPerils);
								}
								//showMessageBox(response.responseText, imgMessage.SUCCESS);
								$("lineSublineForm").enable();
							}
						});
					}else{
						continueDelete(row,packLineCd, packSublineCd, parId, hasItems, hasPerils);
					}
				}else{
					showMessageBox("Cannot delete this record.", imgMessage.INFO);
					return false;
				}
			}
		});
	}
	
	function continueDelete(row,packLineCd, packSublineCd, parId, hasItems, hasPerils){
		try{
			//updating JSON
			for (var i=0; i<objLineSublineItems.length; i++){
				if (objLineSublineItems[i].packLineCd == packLineCd && objLineSublineItems[i].packSublineCd == packSublineCd && objLineSublineItems[i].parId == parId){
					 if(objLineSublineItems[i].recordStatus == 0){
						 objLineSublineItems.splice(i, 1); //added second condition for newly-added record so no need to send object to database 
					}else{
						objLineSublineItems[i].recordStatus = -1;
						objLineSublineItems[i].hasItems = hasItems;
						objLineSublineItems[i].hasPerils = hasPerils;
					}	
				}
			}
			
			Effect.Fade(row, {
				duration: .2,
				afterFinish: function ()	{
					row.remove();
					resetFields();
					checkTableIfEmpty("rowLineSubline", "lineSublineInfoDiv");
					checkIfToResizeTable("lineSublineList", "rowLineSubline");
					$("btnAdd").value = "Add";
				}
			});
			enableButton("btnAdd") ;
			disableButton("btnDelete");
		}catch(e){
			showErrorMessage("continueDelete", e);
		}
	}
	function addLineSubline(){
		try{
			if ($F("btnAdd") == "Update"){
				//update json object
				
				for (var i=0; i<objLineSublineItems.length; i++){
					var lineSubline = objLineSublineItems[i].packLineCd+objLineSublineItems[i].packSublineCd+objLineSublineItems[i].parId;
					if (lineSubline == $F("selectedRow")){
						var newRemarks = unescapeHTML2($F("remarks"));
						$("remarks"+lineSubline).value = newRemarks;
						$("remarksText"+lineSubline).innerHTML = newRemarks.substr(0,7); //nvl(newRemarks, '---');
						
						objLineSublineItems[i].remarks	 = newRemarks;
						objLineSublineItems[i].recordStatus = objLineSublineItems[i].recordStatus == 0 ? 0 :1;
					}
				}
				$("btnAdd").value = "Add";
				disableButton("btnDelete");
				//resetFields();
				displayLineSublineItemInfo(false, null);
				$$("div[name='rowLineSubline']").each(function (r)	{
					if (r.hasClassName("selectedRow")){
						r.removeClassName("selectedRow");
					} 
				});
			}else{//add
				var packLineCd = $F("packLineCdOpt");
				var packLineName = $("packLineCdOpt").options[$("packLineCdOpt").selectedIndex].getAttribute("lineName");
				var packSublineCd = $F("packSublineCdOpt");
				var packSublineName = $("packSublineCdOpt").options[$("packSublineCdOpt").selectedIndex].text;
				var remarks 		= $F("remarks");
				var lineExist = false;
				var sublineExist = false;
				$$("input[name='packLineCd']").any(function(v){
					if(v.value == packLineCd){
						lineExist = true;
					}
				});
				$$("input[name='packSublineCd']").any(function(v){
					if(v.value == packSublineCd){
						sublineExist = true;
					}
				});
				if(lineExist && sublineExist){
					showMessageBox("Cannot create same record.");
					return false;
				}	
				var objLineSublineItem = new Object();
				objLineSublineItem.packLineCd = packLineCd;
				objLineSublineItem.packLineName= packLineName;
				objLineSublineItem.packSublineCd = packSublineCd;
				objLineSublineItem.packSublineName = packSublineName;
				objLineSublineItem.remarks = remarks;
				objLineSublineItem.parId = '';
				objLineSublineItem.recordStatus	 = 0;
				objLineSublineItems.push(objLineSublineItem); // main item list
				//dsp tag here
				
				//
				var parId = '';			
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "lineSublineItem"+packLineCd+packSublineCd+parId);
				newDiv.setAttribute("name", "rowLineSubline");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				var content = '<input type="hidden" id="packLineCd'+packLineCd+packSublineCd+parId+'" name="packLineCd" value="'+packLineCd+'"/>'
					+'<input type="hidden" id="packLineName'+packLineCd+packSublineCd+parId+'" name="packLineName" value="'+packLineName+'"/>'
					+'<input type="hidden" id="packSublineCd'+packLineCd+packSublineCd+parId+'" name="packSublineCd" value="'+packSublineCd+'"/>'
					+'<input type="hidden" id="packSublineName'+packLineCd+packSublineCd+parId+'" name="packSublineName" value="'+packSublineName+'"/>'
					+'<input type="hidden" id="remarks'+packLineCd+packSublineCd+parId+'" name="remarks" value="'+escapeHTML2(remarks)+'"/>'
					+'<input type="hidden" id="parId'+packLineCd+packSublineCd+parId+'" name="parId" value=""/>'
					+'<input type="hidden" id="dspTag'+packLineCd+packSublineCd+parId+'" name="dspTag" value=""/>'
					+'<input type="hidden" id="newRec'+packLineCd+packSublineCd+parId+'" value="Y"/>'
					+'<label style="width: 155px; text-align: left; margin-left: 10px;" name="lineName" id="lineName">'+packLineCd+' - '+packLineName+'</label>'
					+'<label style="width: 225px; text-align: left; margin-left: 10px;" name="sublineText" >'+packSublineCd+' - '+packSublineName+'</label>'
					+'<label style="width: 225px; text-align: left; margin-left: 10px;" name="remarksText" id="remarksText'+packLineCd+packSublineCd+parId+'">'+escapeHTML2(remarks)+'</label>';
				newDiv.update(content);
				$("lineSublineList").insert({bottom: newDiv});
				
		
				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});
		
				newDiv.observe("click", function(){
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow")){
						$$("div[name='rowLineSubline']").each(function (r)	{
							if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});
						displayLineSublineItemInfo(true, newDiv);
					} else {
						displayLineSublineItemInfo(false, null);
					} 
				});
		
				Effect.Appear("lineSublineItem"+packLineCd+packSublineCd, {
					duration: .2,
					afterFinish: function () {
						checkTableIfEmpty("rowLineSubline", "lineSublineInfoDiv");
						checkIfToResizeTable("lineSublineList", "rowLineSubline");
						trimLabelTexts();
					}
				});
				resetFields();
			}
		}catch(e){
			showErrorMessage("addLineSubline", e);
		}	

	}

	$("btnAdd").observe("click", validateLineSubline);

	function resetFields(){
		$("packLineCdOpt").selectedIndex = 0;
		$("displayLine").clear();
		$("displayLine").hide();
		$("packSublineCdOpt").selectedIndex = 0;
		$("displaySubline").clear();
		$("displaySubline").hide();
		$("packLineCdOpt").show();
		$("packSublineCdOpt").show();
		$("packSublineCdOpt").update("");
		$("remarks").value = "";
		//changeTag = 0;
		clearChangeAttribute("lineSublineInfoFormDiv");
	}
	
	function displayLineSublineItemInfo(bool, row){
		try {
			if(!bool){
				resetFields();
				$("btnAdd").value = "Add";
				$("selectedRow").value = "";
			} else {
				var packLineCdOpt = $("packLineCdOpt");
				var packSublineCdOpt = $("packSublineCdOpt");
				var lineDisplay = row.down("input", 0).value+' - '+row.down("input", 1).value;
				var sublineDisplay = row.down("input", 2).value+' - '+row.down("input", 3).value;
				
				packLineCdOpt.hide();
				packSublineCdOpt.hide();
				$("displayLine").value = lineDisplay;
				$("displayLine").show();
				$("displaySubline").value = sublineDisplay;
				$("displaySubline").show();
				$("remarks").value = row.down("input",4).value;
				$("btnAdd").value = "Update";
				$("selectedRow").value = row.down("input", 0).value+row.down("input", 2).value+row.down("input", 5).value;// sets the selected row
			}
			//(row == null ? enableButton("btnAdd") : disableButton("btnAdd"));
			(row == null ? disableButton("btnDelete") : enableButton("btnDelete"));
		} catch(e){
			showErrorMessage("displayLineSublineItemInfo", e);
		}
	}
	
	function showLineSublineItems(){
		try{
			for(var i =0;i<objLineSublineItems.length ; i++){
				var parId = objLineSublineItems[i].parId;
				var packParId = objLineSublineItems[i].packParId;
				var packLineCd = objLineSublineItems[i].packLineCd;
				var packLineName = objLineSublineItems[i].packLineName;
				var packSublineCd = objLineSublineItems[i].packSublineCd;
				var packSublineName = objLineSublineItems[i].packSublineName;
				var remarks 		= objLineSublineItems[i].remarks == null ? "" : changeSingleAndDoubleQuotes2(objLineSublineItems[i].remarks);
				var dspTag = objLineSublineItems[i].dspTag;
				var newDiv 			= new Element("div");
				newDiv.setAttribute("id", "lineSublineItem"+packLineCd+packSublineCd);
				newDiv.setAttribute("name", "rowLineSubline");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				var content = '<input type="hidden" id="packLineCd'+packLineCd+packSublineCd+parId+'" name="packLineCd" value="'+packLineCd+'"/>'
					+'<input type="hidden" id="packLineName'+packLineCd+packSublineCd+parId+'" name="packLineName" value="'+packLineName+'"/>'
					+'<input type="hidden" id="packSublineCd'+packLineCd+packSublineCd+parId+'" name="packSublineCd" value="'+packSublineCd+'"/>'
					+'<input type="hidden" id="packSublineName'+packLineCd+packSublineCd+parId+'" name="packSublineName" value="'+packSublineName+'"/>'
					+'<input type="hidden" id="remarks'+packLineCd+packSublineCd+parId+'" name="remarks" value="'+remarks+'"/>'
					+'<input type="hidden" id="parId'+packLineCd+packSublineCd+parId+'" value="'+parId+'"/>'
					+'<input type="hidden" id="dspTag'+packLineCd+packSublineCd+parId+'" value="'+dspTag+'"/>'
					+'<input type="hidden" id="newRec'+packLineCd+packSublineCd+parId+'" value="N"/>'
					+'<label style="width: 155px; text-align: left; margin-left: 10px;" name="lineName" id="lineName">'+packLineCd+' - '+packLineName+'</label>'
					+'<label style="width: 225px; text-align: left; margin-left: 10px;" name="sublineText" >'+packSublineCd+' - '+packSublineName+'</label>'
					+'<label style="width: 225px; text-align: left; margin-left: 10px;" name="remarksText" id="remarksText'+packLineCd+packSublineCd+parId+'" >'+remarks+'</label>';
				newDiv.update(content);
				$("lineSublineList").insert({bottom: newDiv});
				Effect.Appear("lineSublineItem"+packLineCd+packSublineCd, {
					duration: .2,
					afterFinish: function () {
						checkTableIfEmpty("rowLineSubline", "lineSublineInfoDiv");
						checkIfToResizeTable("lineSublineList", "rowLineSubline");
					}
				});
			}
		}catch(e){
			showErrorMessage("showLineSublineItems. ",e);
		}	
	}

	


/*
	$("remarks").observe("keyup", function () {
		limitText(this, 4000);
	});*/

	$("editRemarks").observe("click", function () {
		showEditor("remarks", 4000);
	});

	/* function validateLineSubline(){
		if ($F("btnAdd") == "Add"){
			if($F("packLineCdOpt") == ""){
				showMessageBox("Line is required.", imgMessage.ERROR);
				return false;
			}else if($F("packSublineCdOpt") == ""){
				showMessageBox("Subline is required.", imgMessage.ERROR);
				return false;
			}else{
				addLineSubline();
			}
		}else{
			addLineSubline();
		}	
	} */
	
	
	// Rey 11-21-2011 to handle the saving bug
	function validateLineSubline(){
		var packLineCd = $F("packLineCdOpt");
		var packLineName = $("packLineCdOpt").options[$("packLineCdOpt").selectedIndex].getAttribute("lineName");
		var packSublineCd = $F("packSublineCdOpt");
		var lineExist = false;
		var sublineExist = false;
		$$("input[name='packLineCd']").any(function(v){
			if(v.value == packLineCd){
				lineExist = true;
			}
		});
		$$("input[name='packSublineCd']").any(function(v){
			if(v.value == packSublineCd){
				sublineExist = true;
			}
		});
		if ($F("btnAdd") == "Add"){
			if($F("packLineCdOpt") == ""){
				showMessageBox("Line is required.", imgMessage.ERROR);
				return false;
			}else if($F("packSublineCdOpt") == ""){
				showMessageBox("Subline is required.", imgMessage.ERROR);
				return false;
			}else if(lineExist && sublineExist){
					showMessageBox("Cannot create same record.");
					return false;
			}else{
				addLineSubline();
			}
		}else{
			addLineSubline();	
		}	
	}

	addStyleToInputs();
	initializeAll();	
	initializeAccordion();
	initializeTable("tableContainer", "rowLineSubline", "", "");
	checkTableIfEmpty("rowLineSubline", "lineSublineInfoDiv");
	checkIfToResizeTable("lineSublineList", "rowLineSubline");
	observeReloadForm("reloadForm", showLineSublineCoverages);
	setDocumentTitle("Line and Subline Coverages");
	setModuleId("GIPIS093");
	trimLabelTexts();
	initializeChangeTagBehavior(saveLineSubline);
	observeCancelForm("btnCancel", saveLineSubline, function(){
		fireEvent($("parExit"), "click");
	});
	
	//Rey 11-18-2011 for saving validation for not yet updated items
	setCursor("default");
	//changeTag = 0;
	observeSaveForm("btnSave", saveLineSubline);
	initializeChangeAttribute();
	//hideNotice("");
</script>
