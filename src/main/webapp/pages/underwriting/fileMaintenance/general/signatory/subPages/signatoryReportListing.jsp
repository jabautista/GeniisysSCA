<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Report Listing</label>
		<span class="refreshers" style="margin-top: 0;">
			<label name="gro" style="margin-left: 5px;">Hide</label>
			<label id="reloadForm" name="reloadForm">Reload Form</label> 
		</span>
	</div>
</div>
<div id="tableGridSectionDiv" class="sectionDiv" style="height: 422px;">
	<div id="reportTableGridDiv" style= "padding: 10px; padding-left: 20px; height: 265px;">
		
	</div>
	<div id="reportInfoDiv" name="reportInfoDiv" style="margin: 2px;">
		<table align="center" border="0">
			<tr>
				<td class="rightAligned" >Report</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 120px; margin-right: 0px;">
						<input id="txtReportId" type="text" class="required allCaps" ignoreDelKey="true" style="width: 95px; border: none; height: 14px; margin: 0;" tabindex="101" lastValidValue="" maxlength="12"/>						
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="hrefReportId" alt="Go" style="float: right;"/>
					</span>
					<input id="txtReportTitle" type="text" style="width: 320px; margin: 0; margin-left: 4px;" lastValidValue="" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Issue Source</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 120px; margin-right: 0px;">
						<input id="txtIssCd" type="text" class="required allCaps" ignoreDelKey="true" style="width: 95px; border: none; height: 14px; margin: 0;" tabindex="102" lastValidValue="" maxlength="2"/>						
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="hrefIssCd" alt="Go" style="float: right;"/>
					</span>
					<input id="txtIssName" type="text" style="width: 320px; margin: 0; margin-left: 4px;" lastValidValue="" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Line</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 120px; margin-right: 0px;">
						<input id="txtLineCd" type="text" class="required allCaps" ignoreDelKey="true" style="width: 95px; border: none; height: 14px; margin: 0;" tabindex="102" lastValidValue="" maxlength="2"/>						
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="hrefLineCd" alt="Go" style="float: right;"/>
					</span>
					<input id="txtLineName" type="text" style="width: 320px; margin: 0; margin-left: 4px;" lastValidValue="" readonly="readonly">
				</td>
			</tr>
		</table>
	</div>
	<div class="buttonsDiv" style="float:left; width: 100%; height: 1px;">
		<input type="button" class="button" id="btnAddReport" name="btnAddReport" value="Add" tabindex=104/>
	</div>
</div>

<script>
try {
	var reportDetails = new Object();
	
	var objSignatoryMain = [];
	var objSignatory = new Object();
	objSignatory.objSignatoryListing = JSON.parse('${signatoryMaintenance}'.replace(/\\/g, '\\\\'));
	objSignatory.objSignatoryMaintenance = objSignatory.objSignatoryListing.rows || [];
	
	reportRowIndex = -2;
	
	var signatoryTable = {
			url: contextPath+"/GIISSignatoryController?action=getReportSignatory&ajax=2",
			options: {
				id: 1,
				title: '',
				height: 240,
				width: 880,
				onCellFocus : function(element, value, x, y, id){
					reportRowIndex = y;
					setReportFields(signatoryGrid.geniisysRows[y]);
					signatoryGrid.keys.removeFocus(signatoryGrid.keys._nCurrentFocus, true);
					signatoryGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					reportRowIndex = -1;
					setReportFields(null);
					signatoryGrid.keys.removeFocus(signatoryGrid.keys._nCurrentFocus, true);
					signatoryGrid.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						reportRowIndex = -1;
						setReportFields(null);
						signatoryGrid.keys.removeFocus(signatoryGrid.keys._nCurrentFocus, true);
						signatoryGrid.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				beforeClick : function() {
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;	
					}
				},
				onSort: function(){
					reportRowIndex = -1;
					setReportFields(null);
					signatoryGrid.keys.removeFocus(signatoryGrid.keys._nCurrentFocus, true);
					signatoryGrid.keys.releaseKeys();
				},
				onRefresh: function(){
					reportRowIndex = -1;
					setReportFields(null);
					signatoryGrid.keys.removeFocus(signatoryGrid.keys._nCurrentFocus, true);
					signatoryGrid.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
					reportRowIndex = -1;
					setReportFields(null);
					signatoryGrid.keys.removeFocus(signatoryGrid.keys._nCurrentFocus, true);
					signatoryGrid.keys.releaseKeys();
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
			columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'reportId',
					title: 'Report ID',
					width: '120px',
					titleAlign: 'left',
					editable: false,
					filterOption: true
				},
				{
					id: 'reportTitle',
					title: 'Report Name',
					width: '250px',
					titleAlign: 'left',
					editable: false,
					filterOption: true
				},
				{
					id: 'issCd',
					title: 'Issue Code',
					width: '90px',
					titleAlign: 'left',
					editable: false,
					filterOption: true
				},
				{
					id: 'issName',
					title: 'Issue Name',
					width: '110px',
					titleAlign: 'left',
					editable: false,
					filterOption: true
				},
				{
					id: 'lineCd',
					title: 'Line Code',
					width: '90px',
					titleAlign: 'left',
					editable: false,
					filterOption: true
				},
				{
					id: 'lineName',
					title: 'Line Name',
					width: '185px',
					titleAlign: 'left',
					editable: false,
					filterOption: true
				}
			],
			rows: objSignatory.objSignatoryListing.rows
			
	};
	
	signatoryGrid = new MyTableGrid(signatoryTable);
	signatoryGrid.pager = objSignatory.objSignatoryListing;
	signatoryGrid.render('reportTableGridDiv');
	signatoryGrid.afterRender = function(){		
		changeTag = 0;
		setReportFields(null);
	};
	
	function setReportFields(obj){
		try {
			$("txtReportId").value = obj == null ? "" : unescapeHTML2(obj.reportId);
			$("txtReportTitle").value = obj == null ? "" : unescapeHTML2(obj.reportTitle);
			$("txtIssCd").value = obj == null ? "" : unescapeHTML2(obj.issCd);
			$("txtIssName").value = obj == null ? "" : unescapeHTML2(obj.issName);
			$("txtLineCd").value = obj == null ? "" : unescapeHTML2(obj.lineCd);
			$("txtLineName").value = obj == null ? "" : unescapeHTML2(obj.lineName);
			
			$("txtReportId").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.reportId)));
			$("txtIssCd").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.issCd)));
			$("txtLineCd").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.lineCd)));
			
			$("txtReportTitle").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.reportTitle)));
			$("txtIssName").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.issName)));
			$("txtLineName").setAttribute("lastValidValue", (obj == null ? "" : unescapeHTML2(obj.lineName)));
			
			obj == null ? enableInputField("txtReportId") : disableInputField("txtReportId");
			obj == null ? enableInputField("txtIssCd") : disableInputField("txtIssCd");
			obj == null ? enableInputField("txtLineCd") : disableInputField("txtLineCd");
			
			obj == null ? enableSearch("hrefReportId") : disableSearch("hrefReportId");
			obj == null ? enableSearch("hrefIssCd") : disableSearch("hrefIssCd");
			obj == null ? enableSearch("hrefLineCd") : disableSearch("hrefLineCd");
			
			obj == null ? enableButton("btnAddReport") : disableButton("btnAddReport");
			
			if(obj == null) {
				signatoryDetailGrid.url = contextPath+"/GIISSignatoryController?action=getReportSignatoryDetails";
			} else {
				signatoryDetailGrid.url = contextPath+"/GIISSignatoryController?action=getReportSignatoryDetails&reportId=" + encodeURIComponent($F("txtReportId")) +
					"&issCd=" + encodeURIComponent($F("txtIssCd")) + "&lineCd=" + encodeURIComponent($F("txtLineCd"));
			}
			
			if(reportRowIndex > -2)
				signatoryDetailGrid._refreshList();
			
			if(obj != null)
				getUsedSignatories();
			else
				usedSignatories = [];
			
		} catch (e) {
			showErrorMessage("setReportFields", e);
		}
	}
	
	usedSignatories = [];
	
	function getUsedSignatories(){
		try{
			new Ajax.Request(contextPath+"/GIISSignatoryController", {
				method: "POST",
				parameters : {
					action : "getGIISS116UsedSignatories",
					reportId : $F("txtReportId"),
					issCd : $F("txtIssCd"),
					lineCd : $F("txtLineCd")
				},
				onCreate:function(){
					showNotice("Getting used Signatories, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var temp = response.responseText.trim();						
						usedSignatories = temp.split(",");
					}
				}
			});
		}catch(e){
			showErrorMessage("getUsedSignatories",e);
		}
	}
	
	function addReport(){
		try{			
			if(checkAllRequiredFieldsInDiv("reportInfoDiv"))
				validateSignatoryReport();
		}catch(e){
			showErrorMessage("addReport", e);
		}
	}
	
	function validateSignatoryReport(){
		try{
			new Ajax.Request(
					contextPath + "/GIISSignatoryController",
					{
						method : "GET",
						parameters : {
							action : "validateSignatoryReport",
							reportId : $F("txtReportId"),
							issCd : $F("txtIssCd"),
							lineCd : $F("txtLineCd")
						},
						asynchronous : false,
						evalScripts : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								var res = JSON.parse(response.responseText);
								if (res.result == 1){
									showMessageBox("Record already exists with the same report_id, iss_cd and line_cd.", "E");
									
								}else{
									addReportDetail();
									
									signatoryGrid.selectRow(signatoryGrid.geniisysRows.length - 1);
									reportRowIndex = signatoryGrid.geniisysRows.length - 1;
									setReportFields(signatoryGrid.geniisysRows[signatoryGrid.geniisysRows.length - 1]);
								}
							}
						}
					});
		}catch (e){
			showErrorMessage("validateSignatoryReport", e);
		}
	}	
	
	$("btnAddReport").observe("click", function () {
		addReport();
	});
	
	function createReport(){
		try{
			var report = new Object();
			report.reportId 	=	escapeHTML2($F("txtReportId")); 
			report.reportTitle	=	escapeHTML2($F("txtReportTitle"));
			report.issCd		=	escapeHTML2($F("txtIssCd"));
			report.issName		=	escapeHTML2($F("txtIssName"));
			report.lineCd		=	escapeHTML2($F("txtLineCd"));
			report.lineName		=	escapeHTML2($F("txtLineName"));
			return report;
		}catch (e){
			showErrorMessage("createReport", e);
		}
	}
	
	function addReportDetail(){
		try{
			var reportDetail = createReport();
			if(createReport.rows == undefined){
				createReport.rows = [];
			} 
			createReport.rows.push(reportDetail);
			signatoryGrid.addBottomRow(reportDetail);
			changeTag = 1;
		}catch (e){
			showErrorMessage("addReportDetail", e);
		}
	}
	
	function showGIISS116ReportLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS116ReportLOV",
					filterText : ($F("txtReportId") == $("txtReportId").readAttribute("lastValidValue") ? "" : $F("txtReportId")),
				},
				title: "List of Reports",
				width : 450,
				height : 386,
				columnModel : [
	               {
	            	   id : "reportId",
	            	   title : "Report ID",
	            	   width : 90
	               },
	               {
	            	   id : "reportTitle",
	            	   title : "Report Title",
	            	   width : 345
	               }
				              ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($F("txtReportId") == $("txtReportId").readAttribute("lastValidValue") ? "" : $F("txtReportId")),
				onSelect: function(row){
					$("txtReportId").value = unescapeHTML2(row.reportId);
					$("txtReportTitle").value = unescapeHTML2(row.reportTitle);
					$("txtReportId").setAttribute("lastValidValue", $F("txtReportId"));
					$("txtReportTitle").setAttribute("lastValidValue", $F("txtReportTitle"));
				},
				onCancel : function () {
					$("txtReportId").value = $("txtReportId").readAttribute("lastValidValue");
					$("txtReportTitle").value = $("txtReportTitle").readAttribute("lastValidValue");
					$("txtReportId").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtReportId");
					$("txtReportId").value = $("txtReportId").readAttribute("lastValidValue");
					$("txtReportTitle").value = $("txtReportTitle").readAttribute("lastValidValue");
					$("txtReportId").focus();		
				}
			});
		}catch(e){
			showErrorMessage("showGIISS116ReportLOV", e);
		}
	}
	
	$("hrefReportId").observe("click", function () {
		showGIISS116ReportLOV();
	});
	
	$("txtReportId").observe("change", function(){
		if(this.value.trim() == "") {
			$("txtReportId").clear();
			$("txtReportTitle").clear();
			$("txtReportId").setAttribute("lastValidValue", "");
			$("txtReportTitle").setAttribute("lastValidValue", "");
			return;
		}
		showGIISS116ReportLOV();
	});
	
	function showGIISS116IssourceLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS116IssourceLOV",
					lineCd : escapeHTML2($F("txtLineCd")),
					filterText : ($F("txtIssCd") == $("txtIssCd").readAttribute("lastValidValue") ? "" : $F("txtIssCd")),
				},
				title: "List of Issue Sources",
				width : 450,
				height : 386,
				columnModel : [
	               {
	            	   id : "issCd",
	            	   title : "Issue Code",
	            	   width : 90
	               },
	               {
	            	   id : "issName",
	            	   title : "Issue Name",
	            	   width : 345
	               }
				              ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($F("txtIssCd") == $("txtIssCd").readAttribute("lastValidValue") ? "" : $F("txtIssCd")),
				onSelect: function(row){
					$("txtIssCd").value = unescapeHTML2(row.issCd);
					$("txtIssName").value = unescapeHTML2(row.issName);
					$("txtIssCd").setAttribute("lastValidValue", $F("txtIssCd"));
					$("txtIssName").setAttribute("lastValidValue", $F("txtIssName"));
				},
				onCancel : function () {
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					$("txtIssCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					$("txtIssCd").focus();		
				}
			});
		}catch(e){
			showErrorMessage("showGIISS116IssourceLOV", e);
		}
	}
	
	$("hrefIssCd").observe("click", function () {
		showGIISS116IssourceLOV();
	});
	
	$("txtIssCd").observe("change", function(){
		if(this.value.trim() == "") {
			$("txtIssCd").clear();
			$("txtIssName").clear();
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").setAttribute("lastValidValue", "");
			return;
		}
		showGIISS116IssourceLOV();
	});
	
	function showGIISS116LineLOV(){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS116LineLOV",
					issCd : escapeHTML2($F("txtIssCd")),
					filterText : ($F("txtLineCd") == $("txtLineCd").readAttribute("lastValidValue") ? "" : $F("txtLineCd")),
				},
				title: "List of Lines",
				width : 450,
				height : 386,
				columnModel : [
	               {
	            	   id : "lineCd",
	            	   title : "Line Code",
	            	   width : 90
	               },
	               {
	            	   id : "lineName",
	            	   title : "Line Name",
	            	   width : 345
	               }
				              ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($F("txtLineCd") == $("txtLineCd").readAttribute("lastValidValue") ? "" : $F("txtLineCd")),
				onSelect: function(row){
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
					$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
				},
				onCancel : function () {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
					$("txtLineCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
					$("txtLineCd").focus();		
				}
			});
		}catch(e){
			showErrorMessage("showGIISS116LineLOV", e);
		}
	}
	
	$("hrefLineCd").observe("click", function () {
		showGIISS116LineLOV();
	});
	
	$("txtLineCd").observe("change", function(){
		if(this.value.trim() == "") {
			$("txtLineCd").clear();
			$("txtLineName").clear();
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").setAttribute("lastValidValue", "");
			return;
		}
		showGIISS116LineLOV();
	});
	
} catch(e) {
	showErrorMessage("prepareSignatoryTG", e);
}
</script>