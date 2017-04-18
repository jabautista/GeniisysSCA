<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss090MainDiv" name="giiss090MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="reportMaintenance">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Report Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss090" name="giiss090">		
		<div class="sectionDiv">
			<div id="reportsTableDiv" style="padding-top: 10px;">
				<div id="reportsTable" style="height: 340px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="reportsFormDiv">
				<div id="reportsFormTextDiv" style="float: left; margin-left: 20px; width: 580px;">
					<table style="margin-top: 5px;">
						<tr>
							<td width="" class="rightAligned">Report ID</td>
							<td class="leftAligned" colspan="3">
								<input id="txtReportId" type="text" class="required" style="width: 150px;" tabindex="201" maxlength="12" />
							</td>				
						</tr>	
						<tr>
							<td width="" class="rightAligned">Report Title</td>
							<td class="leftAligned" colspan="3">
								<input id="txtReportTitle" type="text" class="required" style="width: 434px;" tabindex="202" maxlength="100" />
							</td>
						</tr>
						<tr>
							<td width="" class="rightAligned">Line Code</td>
							<td  class="leftAligned">
								<!-- <input id="txtLineCd" type="text" style="width: 150px;" tabindex="205" maxlength="2" /> -->
								<span class="lovSpan" style="float: left; width: 155px; margin-right: 5px; margin-top: 2px; height: 21px;">
									<input class="" type="text" id="txtLineCd" name="txtLineCd" style="width: 125px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="203" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineCd" name="imgSearchLineCd" alt="Go" style="float: right;" />
								</span>
								<input id="txtLineName" name="txtLineName" type="hidden" />
							</td>
							<td width="" class="rightAligned">Subline Code</td>
							<td  class="leftAligned">
								<!-- <input id="txtSublineCd" type="text" style="width: 150px;" tabindex="206" maxlength="7"/> -->
								<span class="lovSpan" style="float: left; width: 155px; margin-right: 5px; margin-top: 2px; height: 21px;">
									<input class="" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 125px; float: left; border: none; height: 15px; margin: 0;" maxlength="7" tabindex="204" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSublineCd" name="imgSearchSublineCd" alt="Go" style="float: right;" />
								</span>
								<input id="txtSublineName" name="txtSublineName" type="hidden" />
							</td>	
						</tr>
						<tr>
							<td width="" class="rightAligned">Description</td>
							<td class="leftAligned">
								<input id="txtReportDesc" type="text" style="width: 150px;" tabindex="205" maxlength="30" />
							</td>
							<td width="" class="rightAligned">Report Type</td>
							<td class="leftAligned">
								<input id="txtReportType" type="text" style="width: 150px;" tabindex="206" maxlength="3"/>								
							</td>
						</tr>
						<tr>
							<td width="" class="rightAligned">Destination Name</td>
							<td class="leftAligned" colspan="3">
								<input id="txtDesname" type="text" style="width: 434px;" tabindex="207" maxlength="100" />
							</td>
						</tr>
						<tr>
							<td width="" class="rightAligned">Destination Format</td>
							<td class="leftAligned">
								<input id="txtDesformat" type="text" style="width: 150px;" tabindex="208" maxlength="15" />
							</td>
							<td width="" class="rightAligned">Copies</td>
							<td class="leftAligned">
								<input id="txtCopies" class="integerNoNegativeUnformatted" type="text" style="width: 150px; text-align: right;" tabindex="209" maxlength="4" />
							</td>
						</tr>
						<tr>
							<td width="150px;" class="rightAligned">Generation Freq.</td>
							<td class="leftAligned" >
								<select id="selGenerationFrequency" tabindex="210" style="width: 158px;">
									<option value="" selected="selected"></option>
									<option value="D">Daily</option>
									<option value="W">Weekly</option>
									<option value="M">Monthly</option>
									<option value="Q">Quarterly</option>
									<option value="Y">Yearly</option>
									<option value="A">Any Time</option>
								</select>
							</td> 
							<td width="" class="rightAligned">Version</td>
							<td class="leftAligned">
								<input id="txtVersion" type="text" style="width: 150px;" tabindex="211" maxlength="20" />
							</td>
						</tr>
						<tr>
							<td width="" class="rightAligned">Remarks</td>
							<td class="leftAligned" colspan="3">
								<div id="remarksDiv" name="remarksDiv" style="float: left; width: 440px; border: 1px solid gray; height: 22px;" />
									<textarea style="float: left; height: 16px; width: 410px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="212"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 150px;" readonly="readonly" tabindex="213" /></td>
							<td width="110px" class="rightAligned">Last Update</td>
							<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 150px;" readonly="readonly" tabindex="214" /></td>
						</tr>			
					</table>
				</div>
				
				<div id="reportsFormRdoDiv" class="sectionDiv" style="float: left; width: 280px; margin: 15px 5px 5px 5px;">
					<table style="width: 280px; margin: 5px 5px 5px 5px;" cellpadding="2" cellspacing="2">
						<tr>
							<td>
								<input type="checkbox" id="chkParamform" style="float: left;" tabindex="301" />
								<label id="lblChkParamform" for="chkParamform"  style="float: left; margin-left: 5px;" >Parameter Form</label>
							</td>	
							<td>
								<input type="checkbox" id="chkDisableFileSw" style="float: left;" tabindex="302" />
								<label id="lblChkDisableFileSw" for="chkDisableFileSw"  style="float: left; margin-left: 5px;" >Disable File</label>
							</td>					
						</tr>
						<tr>
							<td>
								<input type="checkbox" id="chkBackgroundPrint" style="float: left;" tabindex="303" />
								<label id="lblChkBackgroundPrint" for="chkBackgroundPrint"  style="float: left; margin-left: 5px;" >Background Print</label>
							</td>
							<td>
								<input type="checkbox" id="chkCsvFileSw" style="float: left;" tabindex="304" />
								<label id="lblChkCsvFileSw" for="chkCsvFileSw"  style="float: left; margin-left: 5px;" >CSV File</label>
							</td>
						</tr>
					</table>
					<table style="float:left; width:120px; margin-left: 5px;">
						<tr>
							<td>
								<fieldset>
									<legend>Orientation</legend>
									<table>
										<tr>
											<td>
												<input type="radio" id="rdoPortrait" name="rgOrientation" style="float: left;" tabindex="305" />
												<label id="lblRdoPortrait" for="rdoPortrait" style="margin-top: 3px;">Portrait</label>
											</td>											
										</tr>
										<tr>
											<td>
												<input type="radio" id="rdoLandscape" name="rgOrientation" style="float: left;" tabindex="306" />
												<label id="lblRdoLandscape" for="rdoLandscape" style="margin-top: 3px;">Landscape</label>
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
					</table>
					<table style="float:left; width:150px;">
						<tr>
							<td>
								<fieldset>
									<legend>Address Source</legend>
									<table>
										<tr>
											<td>
												<input type="radio" id="rdoIssSource" name="rgAddSource" style="float: left;" tabindex="307" />
												<label id="lblRdoIssSource" for="rdoIssSource" style="margin-top: 3px;">Iss Source</label>
											</td>
										</tr>
										<tr>
											<td>
												<input type="radio" id="rdoHeadOffice" name="rgAddSource" style="float: left;" tabindex="308" />
												<label id="lblRdoHeadOffice" for="rdoHeadOffice" style="margin-top: 3px;">Head Office</label>
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
					</table>
					<table style="float:left; width:120px; margin-left: 5px;">	
						<tr>
							<td>
								<fieldset>
									<legend>Report Mode</legend>
									<table>
										<tr>
											<td>
												<input type="radio" id="rdoCharacter" name="rgReportMode" style="float: left;" tabindex="309" />
												<label id="lblRdoCharacter" for="rdoCharacter" style="margin-top: 3px;">Character</label>
											</td>
										</tr>
										<tr>
											<td>
												<input type="radio" id="rdoBitmap" name="rgReportMode" style="float: left;" tabindex="310" />
												<label id="lblRdoBitmap" for="rdoBitmap" style="margin-top: 3px;">Bitmap</label>
											</td>
										</tr>
										<tr>
											<td>
												<input type="radio" id="rdoDefault" name="rgReportMode" style="float: left;" tabindex="311" />
												<label id="lblRdoDefault" for="rdoDefault" style="margin-top: 3px;">Default</label>
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
					</table>
					<table style="float:left; width:150px;">	
						<tr>
							<td>
								<fieldset>
									<legend>Destination Type</legend>
									<table>
										<tr>
											<td>
												<input type="radio" id="rdoFile" name="rgDestype" style="float: left;" tabindex="312" />
												<label id="lblRdoFile" for="rdoFile" style="margin-top: 3px;">File</label>
											</td>
										</tr>
										<tr>
											<td>
												<input type="radio" id="rdoPrinter" name="rgDestype" style="float: left;" tabindex="313" />
												<label id="lblRdoPrinter" for="rdoPrinter" style="margin-top: 3px;">Printer</label>
											</td>
										</tr>
										<tr>
											<td>
												<input type="radio" id="rdoScreen" name="rgDestype" style="float: left;" tabindex="314" />
												<label id="lblRdoScreen" for="rdoScreen" style="margin-top: 3px;">Screen</label>
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
						<table style="margin: 10px 5px 5px 5px;">
							<tr>
								<td><input type="button" class="button" id="btnReportAging" value="Aging" style="width:90px;" /></td>
							</tr>
						</table>
					</table>					
				</div>
			</div>
			<div class="buttonsDiv" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="401">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="402">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin-left:10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="501">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="502">
</div>
<script type="text/javascript">	
	setModuleId("GIISS090");
	setDocumentTitle("Report Maintenance");
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss090(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgReports.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgReports.geniisysRows);
		new Ajax.Request(contextPath+"/GIISReportsController", {
			method: "POST",
			parameters : {action : "saveGiiss090",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					if(objGIISS090.parentChangeTag == 0){ //added condition
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIISS090.exitPage != null) {
								objGIISS090.exitPage();
							} else {
								tbgReports._refreshList();
							}
						});
					} else {
						//display as is
						objGIISS090.parentChangeTag = 0;
					}
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss090);
	
	//var objGIISS090 = {};
	var objCurrReport = null;
	objGIISS090.reportsList = JSON.parse('${jsonReportsList}');
	objGIISS090.exitPage = null;
	objGIISS090.parentChangeTag = 0;
	var reportsTable = {
			url : contextPath + "/GIISReportsController?action=showGiiss090&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrReport = tbgReports.geniisysRows[y];
					setFieldValues(objCurrReport);
					tbgReports.keys.removeFocus(tbgReports.keys._nCurrentFocus, true);
					tbgReports.keys.releaseKeys();
					$("txtReportTitle").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReports.keys.removeFocus(tbgReports.keys._nCurrentFocus, true);
					tbgReports.keys.releaseKeys();
					$("txtReportId").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgReports.keys.removeFocus(tbgReports.keys._nCurrentFocus, true);
						tbgReports.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReports.keys.removeFocus(tbgReports.keys._nCurrentFocus, true);
					tbgReports.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReports.keys.removeFocus(tbgReports.keys._nCurrentFocus, true);
					tbgReports.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgReports.keys.removeFocus(tbgReports.keys._nCurrentFocus, true);
					tbgReports.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "reportId",
					title : "Report ID",
					filterOption : true,
					width : '150px'
				},
				{
					id : 'reportTitle',
					filterOption : true,
					title : 'Report Title',
					width : '530px'
				},{
					id : 'reportDesc',
					width : '0',
					visible: false				
				},{
					id : 'lineCd',
					title: 'Line Code',
					width : '60px',
					filterOption: true		
				},{
					id : 'prevLineCd', //added by John Daniel 04.07.2016; for updating line_cd
					width : '0',
					visible: false		
				},{
					id : 'sublineCd',
					title: 'Subline Code',
					width : '80px',
					filterOption: true				
				},		
				{
					id : 'reportType',
					width : '0',
					visible: false				
				},{
					id : 'desname',
					width : '0',
					visible: false				
				},{
					id : 'desformat',
					width : '0',
					visible: false				
				},{
					id : 'generationFrequency',
					width : '0',
					visible: false				
				},{
					id : 'copies',
					width : '0',
					visible: false				
				},{
					id : 'version',
					width : '0',
					visible: false				
				},{
					id : 'paramform',
					width : '0',
					visible: false				
				},{
					id : 'background',
					width : '0',
					visible: false				
				},{
					id : 'orientation',
					width : '0',
					visible: false				
				},{
					id : 'addSource',
					width : '0',
					visible: false				
				},{
					id : 'disableFileSw',
					width : '0',
					visible: false				
				},{
					id : 'scvFileSw',
					width : '0',
					visible: false				
				},{
					id : 'reportMode',
					width : '0',
					visible: false				
				},{
					id : 'remarks',
					width : '0',
					visible: false				
				},{
					id : 'destype',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS090.reportsList.rows || []
		};

		tbgReports = new MyTableGrid(reportsTable);
		tbgReports.pager = objGIISS090.reportsList;
		tbgReports.render("reportsTable");
	
	function setFieldValues(rec){
		try{
			$("txtReportId").value = (rec == null ? "" : unescapeHTML2(rec.reportId));
		//	$("txtReportId").setAttribute("lastValidValue", (rec == null ? "" : rec.reportId));
			$("txtReportTitle").value = (rec == null ? "" : unescapeHTML2(rec.reportTitle));
			$("txtReportDesc").value = (rec == null ? "" : unescapeHTML2(rec.reportDesc));
			$("txtReportType").value = (rec == null ? "" : unescapeHTML2(rec.reportType));
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lineCd)));
			$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("txtSublineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.sublineCd)));
			$("txtDesname").value = (rec == null ? "" : unescapeHTML2(rec.desname));
			$("txtDesformat").value = (rec == null ? "" : unescapeHTML2(rec.desformat));
			$("txtCopies").value = (rec == null ? "" : rec.copies);
			$("txtVersion").value = (rec == null ? "" : unescapeHTML2(rec.version));
			$("selGenerationFrequency").value = (rec == null ? "" : unescapeHTML2(rec.generationFrequency));
			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			$("chkParamform").checked = (rec == null ? false : (nvl(rec.paramform, "NO").toUpperCase() == "NO" ? false : true));
			$("chkBackgroundPrint").checked = (rec == null ? false : (nvl(rec.background, "NO").toUpperCase() == "NO" ? false : true));
			$("chkDisableFileSw").checked = (rec == null ? false : (nvl(rec.disableFileSw, "N").toUpperCase() == "N" ? false : true));
			$("chkCsvFileSw").checked = (rec == null ? false : (nvl(rec.csvFileSw, "N").toUpperCase() == "N" ? false : true));
			
			$("rdoPortrait").checked = (rec == null ? true : (nvl(rec.orientation, "DEFAULT").toUpperCase() == "LANDSCAPE" ? false : true));
			$("rdoLandscape").checked = (rec == null ? false : (nvl(rec.orientation, "DEFAULT").toUpperCase() == "LANDSCAPE" ? true : false));
			
			$("rdoIssSource").checked = (rec == null ? false : (nvl(rec.addSource, "P").toUpperCase() == "P" ? false : true));
			$("rdoHeadOffice").checked = (rec == null ? true : (nvl(rec.addSource, "P").toUpperCase() == "P" ? true : false));
			
			if (rec != null && rec.reportMode != null){
				if(rec.reportMode.toUpperCase() == "CHARACTER"){
					$("rdoCharacter").checked  = true;
				} else if(rec.reportMode.toUpperCase() == "BITMAP"){
					$("rdoBitmap").checked = true;
				} else if(rec.reportMode.toUpperCase() == "DEFAULT"){
					$("rdoDefault").checked = true;
				}
			} else if(rec == null || rec.reportMode == null){
				$("rdoCharacter").checked  = true;
			}
								
			if (rec != null && rec.destype != null){
				if(rec.destype.toUpperCase() == "FILE"){
					$("rdoFile").checked  = true;
				} else if(rec.destype.toUpperCase() == "PRINTER"){
					$("rdoPrinter").checked = true;
				} else if(rec.destype.toUpperCase() == "SCREEN"){
					$("rdoScreen").checked = true;
				}
			} else if(rec == null || rec.destype == null){
				$("rdoFile").checked  = true;
			}
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtReportId").readOnly = false : $("txtReportId").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnReportAging") : enableButton("btnReportAging");
			objCurrReport = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.reportId = escapeHTML2($F("txtReportId"));
			obj.reportTitle = escapeHTML2($F("txtReportTitle"));
			obj.reportDesc = escapeHTML2($F("txtReportDesc"));
			
			obj.reportType = escapeHTML2($F("txtReportType"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.sublineCd = escapeHTML2($F("txtSublineCd"));
			obj.desname = escapeHTML2($F("txtDesname"));
			obj.desformat = escapeHTML2($F("txtDesformat"));
			obj.copies = escapeHTML2($F("txtCopies"));
			obj.version = escapeHTML2($F("txtVersion"));
			obj.generationFrequency = escapeHTML2($F("selGenerationFrequency"));			
			
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			obj.paramform = $("chkParamform").checked ? "YES" : "NO";
			obj.background = $("chkBackgroundPrint").checked ? "YES" : "NO";
			obj.disableFileSw = $("chkDisableFileSw").checked ? "Y" : "N";
			obj.csvFileSw = $("chkCsvFileSw").checked ? "Y" : "N";
			
			obj.orientation = $("rdoLandscape").checked ? "LANDSCAPE" : "PORTRAIT";
			obj.addSource = $("rdoIssSource").checked ? "M" : "P";
			
			obj.reportMode = $("rdoBitmap").checked ? "BITMAP" : ($("rdoDefault").checked ? "DEFAULT" : "CHARACTER");
			obj.destype = $("rdoPrinter").checked ? "PRINTER" : ($("rdoScreen").checked ? "SCREEN" : "FILE");
			
			if ($F("btnAdd") == "Add") {
				obj.prevLineCd = obj.lineCd;
			}
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss090;
			var dept = setRec(objCurrReport);
			if($F("btnAdd") == "Add"){
				tbgReports.addBottomRow(dept);
			} else {
				tbgReports.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgReports.keys.removeFocus(tbgReports.keys._nCurrentFocus, true);
			tbgReports.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("reportsFormDiv")){
				if($F("btnAdd") == "Add" || $F("btnAdd") == "Update") { //added by John Daniel 04.14.2016; to handle validation when updating to a record that already exists
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<tbgReports.geniisysRows.length; i++){
						if(tbgReports.geniisysRows[i].recordStatus == 0 || tbgReports.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgReports.geniisysRows[i].reportId) == $F("txtReportId")&&
							   unescapeHTML2(tbgReports.geniisysRows[i].lineCd) == $F("txtLineCd") ){ // added validation; John Daniel SR-21868
								if (objCurrReport != null &&
									objCurrReport.lineCd == tbgReports.geniisysRows[i].lineCd) { 
									break;
								}
								addedSameExists = true;
							}
						} else if(tbgReports.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgReports.geniisysRows[i].reportId) == $F("txtReportId")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same report id and line code.", "E"); //edited by John Daniel 04.14.2016
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISReportsController", {
						parameters : {action : "valAddRec",
									  reportId : $F("txtReportId"),
									  reportTitle: $F("txtReportTitle")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} /* else {
					addRec();
				} */ // removed by John Daniel 04.14.2016;
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss090;
		objCurrReport.recordStatus = -1;
		tbgReports.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		//showMessageBox("You cannot delete this record.", "I");
		
		// in CS, deleting of records is not allowed. Display information message instead.
		try{
			new Ajax.Request(contextPath + "/GIISReportsController", {
				parameters : {action : "valDeleteRec",
							  reportId : $F("txtReportId")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss090(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS090.exitPage = exitPage;
						saveGiiss090();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function showLineCdLOV(){
		LOV.show({
			controller: "ClaimsLOVController", //"AccountingLOVController",
			urlParameters: {action : "getGicls051CdLOV", //"getGiisLineLOV",
							moduleId :  "GIISS090",
							searchString : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "%"),
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "%"),
							page : 1},
			title: "List of Lines",
			width: 440,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "lineName",
								title: "Line Name",
								width: '325px'
							}
						],
				autoSelectOneRecord: true,
				searchString : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "%"),
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "%"),
				onSelect: function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineName").value = row.lineName;
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);								
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showSublineCdLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getSublineByLineCdLOV",
							lineCd: $F("txtLineCd"),
							moduleId :  "GIISS090",
							searchString : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : "%"),
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : "%"),
							page : 1},
			title: "List of Sublines",
			width: 440,
			height: 400,
			columnModel : [
							{
								id : "sublineCd",
								title: "Subline Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "sublineName",
								title: "Subline Name",
								width: '325px'
							}
						],
				autoSelectOneRecord: true,
				searchString : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : "%"),
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : "%"),
				onSelect: function(row) {
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineName").value = row.sublineName;
					$("txtSublineCd").setAttribute("lastValidValue", row.sublineCd);								
				},
				onCancel: function (){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd").trim() != ""){
			$("txtSublineCd").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
			showLineCdLOV();
		} else {
			$("txtSublineCd").clear();
		}
	});
	
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	$("txtSublineCd").observe("change", function(){
		if($F("txtSublineCd").trim() != ""){
			showSublineCdLOV();
		} else {
			$("txtSublineCd").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("txtReportId").observe("keyup", function(){
		$("txtReportId").value = $F("txtReportId").toUpperCase();
	});
	
	$("imgSearchLineCd").observe("click", showLineCdLOV);
	$("imgSearchSublineCd").observe("click", showSublineCdLOV);
	
	disableButton("btnDelete");
	disableButton("btnReportAging");
	$("selGenerationFrequency").value = "D";
	$("txtCopies").value = "1";
	$("rdoPortrait").checked = true;
	$("rdoHeadOffice").checked = true;
	$("rdoCharacter").checked = true;
	$("rdoFile").checked = true;
	
	observeSaveForm("btnSave", saveGiiss090);
	$("btnCancel").observe("click", cancelGiiss090);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnReportAging").observe("click", function(){
		objGIISS090.reportId = objCurrReport.reportId;
		objGIISS090.reportTitle = objCurrReport.reportTitle;
		objGIISS090.parentChangeTag = changeTag;
		objGIISS090.parentSaveFunc = saveGiiss090;
		
		reportAgingOverlay = Overlay.show(contextPath+"/GIISReportsAgingController", {
			urlContent: true,
			urlParameters: {action : "showReportAging",																
							reportId : $F("txtReportId")							
			},
		    title: "Aging",
		    height: 510,
		    width: 720,
		    draggable: true
		});
	});

	$("reportMaintenance").stopObserving("click");
	$("reportMaintenance").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtReportId").focus();	
</script>