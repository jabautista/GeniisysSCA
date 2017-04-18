<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="pkgLineSublineCvrgMaintenance" name="pkgLineSublineCvrgMaintenance" style="float: left; width: 100%;">
	<div id="pkgLineSublineCvrgMaintenanceExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="underwritingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Package Line/Subline Coverage Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">				
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="showBody">	
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="pkgLineCvrgTableGrid" style="height: 230px;margin-left:200px;width:700px;"></div>
			</div>	
		</div>
		<div class="sectionDiv">
			<div style="padding:10px;">
				<div id="pkgLineSublineCvrgTableGrid" style="height: 331px;width:900px;"></div>
			</div>	
			<div>	
				<div id="packageLineSublineDiv" style="margin-left: 150px">
					<table>
						<tr>
							<td></td>
							<td><input style="float:left;margin-top: 6px;" type="checkbox"
								id="chkRequired" tabindex="201"/>
								<label for="chkRequired" style="float:left;margin-top: 6px;">Required</label>
							</td>
						</tr>					
						<tr>
							<td align="right">Line</td>							
							<td style="width:100px"><span class="required lovSpan" style="width: 100px; margin-top:2px">
									<input class="required" id="txtLineCd" maxlength="2" type="text" style="width:74px;margin: 0;height: 14px;border: 0" tabindex="202"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchLineCd" alt="Go" style="float: right; margin-top: 2px;" class="required"/>
								</span>	
							</td>
							<td colspan="3">
								<input id="txtLineName" readonly="readonly" type="text" style="width:446px;" tabindex="203">
							</td>
						</tr>	
						<tr>
							<td align="right">Subline</td>
							<td style="width:100px"><span class="required lovSpan" style="width: 100px; margin-top:2px">
									<input class="required" id="txtSublineCd" maxlength="7" type="text" style="width:74px;margin: 0;height: 14px;border: 0" tabindex="204"><img
									src="${pageContext.request.contextPath}/images/misc/searchIcon.png"
									id="imgSearchSublineCd" alt="Go" style="float: right; margin-top: 2px;" class="required"/>
								</span>	
							</td>
							<td colspan="3">			
								<input style="width:446px;" type="text" id="txtSublineName" readonly="readonly" tabindex="205"/> 
							</td>				
						</tr>	
						<tr>
							<td align="right">Remarks</td>
							<td colspan="4">
								<span class="lovSpan" style="width: 558px; margin: 0">
										<input maxlength="4000"
										style="width: 532px; float: left; height: 14px; border: none; margin:0"
										type="text" id="txtRemarks" tabindex="206"/> 
										<img
										src="${pageContext.request.contextPath}/images/misc/edit.png"
										id="imgEditRemarks" alt="Go" style="float: right; margin-top: 2px;" />
								</span>
							</td>
						</tr>	
						<tr>
							<td align="right">User ID</td>
							<td colspan="2"><input id="txtUserId" type="text" style="width:150px" readonly="readonly" tabindex="207"></td>
							<td align="right" style="width: 187px;">Last Update</td>
							<td><input id="txtLastUpdate" type="text"  style="width:200px" readonly="readonly" tabindex="208"></td>
						</tr>																		
					</table>				
				</div>
				<div align="center" style="margin: 15px">
					<div>
						<input type="button" id="btnAddUpdate" value="Add" tabindex="209"/>
						<input type="button" id="btnDelete" value="Delete" tabindex="210"/>
					</div>
				</div>
			</div>
		</div>		
	</div>	
	<div class="sectionDiv" style="border: 0; margin-bottom: 50px;margin-top: 15px" align="center">
		<div>
			<input type="button" id="btnCancel" value="Cancel" tabindex="211"/>
			<input type="button" id="btnSave" value="Save" tabindex="212"/>
		</div>
	</div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting.js">
try {
	setModuleId("GIISS096");
	setDocumentTitle("Package Line/Subline Coverage Maintenance");
	var row;
	var objPkgLineSublineCvrgMain = [];
	var jsonPkgLineCvrg = JSON.parse('${jsonPkgLineCvrg}');
	
	pkgLineCvrgTableModel = {
		url : contextPath
				+ "/GIISLineSublineCoveragesController?action=showPackageLineCoverage&refresh=1",
		options : {
			width : '500px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						disableButton("btnAddUpdate");
						setTbgPkgLineSublineCvrg(null);	
						disableFields();		
						tbgPkgLineCvrg.keys.removeFocus(
								tbgPkgLineCvrg.keys._nCurrentFocus, true);
						tbgPkgLineCvrg.keys.releaseKeys();																	
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}					
				}					
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
			},		
			prePager : function(element, value, x, y, id) {
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgPkgLineSublineCvrg(null);	
					disableFields();		
					tbgPkgLineCvrg.keys.removeFocus(
							tbgPkgLineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineCvrg.keys.releaseKeys();						
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			beforeClick : function(element, value, x, y, id){				
				if(changeTag == 1){
					showMessageBox("Please save changes first.", imgMessage.INFO);
					return false;						
				}			
			},
			onCellFocus : function(element, value, x, y, id) {	
				if(changeTag==0){
					setTbgPkgLineSublineCvrg(tbgPkgLineCvrg.geniisysRows[y]);							
					enableFields();	
					enableButton("btnAddUpdate");
					$("txtLineCd").focus();	
					tbgPkgLineCvrg.keys.removeFocus(
							tbgPkgLineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineCvrg.keys.releaseKeys();	
					setTbgPkgLineSublineCvrg(tbgPkgLineCvrg.geniisysRows[y]);						
	
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);				
					return false;
				}					
			},
			onRemoveRowFocus : function(element, value, x, y, id) {	
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgPkgLineSublineCvrg(null);	
					disableFields();					
					tbgPkgLineCvrg.keys.removeFocus(
							tbgPkgLineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineCvrg.keys.releaseKeys();														
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			beforeSort : function() {			
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgPkgLineSublineCvrg(null);	
					disableFields();		
					tbgPkgLineCvrg.keys.removeFocus(
							tbgPkgLineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineCvrg.keys.releaseKeys();													
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgPkgLineSublineCvrg(null);	
					disableFields();		
					tbgPkgLineCvrg.keys.removeFocus(
							tbgPkgLineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineCvrg.keys.releaseKeys();												
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}				
			},
			onRefresh : function() {				
				if(changeTag==0){
					disableButton("btnAddUpdate");
					setTbgPkgLineSublineCvrg(null);	
					disableFields();		
					tbgPkgLineCvrg.keys.removeFocus(
							tbgPkgLineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineCvrg.keys.releaseKeys();									
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}	
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		},  {
			id : "lineCd",
			title : "Package Line Cd",
			width : '130px',
			align : "left",
			titleAlign : "left",
			filterOption : true		
		}, {
			id : "lineName",
			title : "Package Line Name",			
			width : '340px',
			align : "left",
			titleAlign : "left",
			filterOption : true,
		}],
		rows : jsonPkgLineCvrg.rows
	};

	tbgPkgLineCvrg = new MyTableGrid(pkgLineCvrgTableModel);
	tbgPkgLineCvrg.pager = jsonPkgLineCvrg;
	tbgPkgLineCvrg.render('pkgLineCvrgTableGrid');
	
	var jsonPkgLineSublineCvrg = JSON.parse('${jsonPkgLineSublineCvrg}');
	pkgLineSublineCvrgTableModel = {
		url : contextPath
				+ "/GIISLineSublineCoveragesController?action=showPackageLineSublineCoverage&refresh=1",
		options : {
			width : '900px',
			pager : {},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter: function(){	
					if(changeTag==0){
						tbgPkgLineSublineCvrg.keys.removeFocus(
								tbgPkgLineSublineCvrg.keys._nCurrentFocus, true);
						tbgPkgLineSublineCvrg.keys.releaseKeys();
						setBtnAndFields(null);	
						setPkgLineSublineCvrgDtls(null);	
						fieldFocus(null);	
						setObjPkgLineSublineCvrg(null);			
					}else{
						showMessageBox("Please save changes first.", imgMessage.INFO);	
						return false;
					}		
				}					
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
			},		
			prePager : function(element, value, x, y, id) {
				if(changeTag==0){
					tbgPkgLineSublineCvrg.keys.removeFocus(
							tbgPkgLineSublineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineSublineCvrg.keys.releaseKeys();
					setBtnAndFields(null);	
					setPkgLineSublineCvrgDtls(null);	
					fieldFocus(null);	
					setObjPkgLineSublineCvrg(null);					
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}								
			},
			onCellFocus : function(element, value, x, y, id) {						
				tbgPkgLineSublineCvrg.keys.removeFocus(
						tbgPkgLineSublineCvrg.keys._nCurrentFocus, true);
				tbgPkgLineSublineCvrg.keys.releaseKeys();	
				setPkgLineSublineCvrgDtls(tbgPkgLineSublineCvrg.geniisysRows[y]);
				setBtnAndFields(tbgPkgLineSublineCvrg.geniisysRows[y]);				
				fieldFocus(tbgPkgLineSublineCvrg.geniisysRows[y]);		
				setObjPkgLineSublineCvrg(tbgPkgLineSublineCvrg.geniisysRows[y]);					
				row = y;
			},
			onRemoveRowFocus : function(element, value, x, y, id) {				
				tbgPkgLineSublineCvrg.keys.removeFocus(
						tbgPkgLineSublineCvrg.keys._nCurrentFocus, true);
				tbgPkgLineSublineCvrg.keys.releaseKeys();
				setBtnAndFields(null);	
				setPkgLineSublineCvrgDtls(null);	
				fieldFocus(null);	
				setObjPkgLineSublineCvrg(null);					
			},
			beforeSort : function() {			
				if(changeTag==0){
					tbgPkgLineSublineCvrg.keys.removeFocus(
							tbgPkgLineSublineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineSublineCvrg.keys.releaseKeys();
					setBtnAndFields(null);	
					setPkgLineSublineCvrgDtls(null);	
					fieldFocus(null);		
					setObjPkgLineSublineCvrg(null);				
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}					
			},
			onSort : function() {				
				if(changeTag==0){
					tbgPkgLineSublineCvrg.keys.removeFocus(
							tbgPkgLineSublineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineSublineCvrg.keys.releaseKeys();
					setBtnAndFields(null);	
					setPkgLineSublineCvrgDtls(null);	
					fieldFocus(null);		
					setObjPkgLineSublineCvrg(null);				
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}			
			},
			onRefresh : function() {				
				if(changeTag==0){
					tbgPkgLineSublineCvrg.keys.removeFocus(
							tbgPkgLineSublineCvrg.keys._nCurrentFocus, true);
					tbgPkgLineSublineCvrg.keys.releaseKeys();
					setBtnAndFields(null);	
					setPkgLineSublineCvrgDtls(null);	
					fieldFocus(null);	
					setObjPkgLineSublineCvrg(null);					
				}else{
					showMessageBox("Please save changes first.", imgMessage.INFO);	
					return false;
				}			
			}
		},
		columnModel : [ {
			id : 'recordStatus',
			title : '',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : "requiredFlag",
			title : "R",
			width : '30px',
			align : "center",
			titleAlign : "right",
			filterOption : true,
			altTitle : 'Required?',
			editable : false,
			visible : true,
			defaultValue : false,
			otherValue : false,
			filterOption : true,
			filterOptionType : 'checkbox',
			editor : new MyTableGrid.CellCheckbox({
				getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
		}, {
			id : "packLineCd",
			title : "Line Code",
			width : '130px',
			align : "left",
			titleAlign : "left",
			filterOption : true		
		}, {
			id : "packLineName",
			title : "Line Name",			
			width : '287px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}, {
			id : "packSublineCd",
			title : "Subline Code",
			width : '130px',
			align : "left",
			titleAlign : "left",
			filterOption : true		
		}, {
			id : "packSublineName",
			title : "Subline Name",			
			width : '287px',
			align : "left",
			titleAlign : "left",
			filterOption : true
		}],
		rows : jsonPkgLineSublineCvrg.rows
	};

	tbgPkgLineSublineCvrg = new MyTableGrid(pkgLineSublineCvrgTableModel);
	tbgPkgLineSublineCvrg.pager = jsonPkgLineSublineCvrg;
	tbgPkgLineSublineCvrg.render('pkgLineSublineCvrgTableGrid');
	tbgPkgLineSublineCvrg.afterRender = function(){
		objPkgLineSublineCvrgMain = tbgPkgLineSublineCvrg.geniisysRows;
		changeTag = 0;
	};

	function getPkgLineCvrgLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPkgLineCvrgLOV",
				searchString : ($("txtLineCd").readAttribute("lastValidValue") != $F("txtLineCd") ? nvl($F("txtLineCd"),"%") : "%"),
				page : 1,				
			},
			title : "List of Lines",
			width : 416,
			height : 390,
			columnModel : [ {
				id : "packLineCd",
				title : "Code",
				width : '135px',
			},{
				id : "packLineName",
				title : "Line Name",
				width : '250px',
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtLineCd").readAttribute("lastValidValue") != $F("txtLineCd") ? nvl($F("txtLineCd"),"%") : "%"),
			onSelect : function(row) {
				$("txtLineCd").value = unescapeHTML2(row.packLineCd);	
				$("txtLineName").value = unescapeHTML2(row.packLineName);				
				$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.packLineCd));
				$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(row.packLineName));
				$("txtSublineCd").value ="";	
				$("txtSublineName").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineName").setAttribute("lastValidValue", "");
				$("txtSublineCd").focus();
			},
			onCancel : function() {
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value=$("txtLineName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtLineCd");		
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				$("txtLineName").value=$("txtLineName").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	

	function getPkgSublineCvrgLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getPkgSublineCvrgLOV",
				searchString : ($("txtSublineCd").readAttribute("lastValidValue") != $F("txtSublineCd") ? nvl($F("txtSublineCd"),"%") : "%"),
				packLineCd : $F("txtLineCd"),
				page : 1,				
			},
			title : "List of Sublines",
			width : 416,
			height : 390,
			columnModel : [ {
				id : "packSublineCd",
				title : "Code",
				width : '135px',
			},{
				id : "packSublineName",
				title : "Subline Name",
				width : '250px',
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :($("txtSublineCd").readAttribute("lastValidValue") != $F("txtSublineCd") ? nvl($F("txtSublineCd"),"%") : "%"),
			onSelect : function(row) {
				$("txtSublineCd").value = unescapeHTML2(row.packSublineCd);	
				$("txtSublineName").value = unescapeHTML2(row.packSublineName);				
				$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.packSublineCd));
				$("txtSublineName").setAttribute("lastValidValue", unescapeHTML2(row.packSublineName));
				$("txtRemarks").focus();
			},
			onCancel : function() {
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value=$("txtSublineName").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtSublineCd");		
				$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				$("txtSublineName").value=$("txtSublineName").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	

	function setTbgPkgLineSublineCvrg(obj) {
		objPkgLineSublineCvrg.lineCd = obj == null? "": (obj.lineCd==null? "":obj.lineCd);			
		tbgPkgLineSublineCvrg.url = contextPath
				+ "/GIISLineSublineCoveragesController?action=showPackageLineSublineCoverage&refresh=1&lineCd="
				+ encodeURIComponent(unescapeHTML2(objPkgLineSublineCvrg.lineCd));
		tbgPkgLineSublineCvrg._refreshList();				
	}

	function enableImg(imgId){
		try {		
			if($(imgId).next("img",0) != undefined){
				$(imgId).show();
				$(imgId).next("img",0).remove();
			}
		} catch(e){
			showErrorMessage("enableImg", e);
		}	
	}	

	function disableImg(imgId){
		try {
			if($(imgId).next("img",0) == undefined){
				var alt = new Element("img");
				alt.alt = 'Go';
				alt.src = contextPath + "/images/misc/edit.png";
				alt.setAttribute("style", "height:17px;width:18px;");							
				alt.setStyle({ 
					  float: 'right'
				});
				$(imgId).hide();
				$(imgId).insert({after : alt});	
			}
		}catch (e) {
			showErrorMessage("disableImg", e);			
		}
	};

	function enableFields(){
		$("chkRequired").disabled = false;
		$("txtLineCd").readOnly = false;
		$("txtSublineCd").readOnly = false;
		$("txtRemarks").readOnly = false;		
		enableSearch("imgSearchLineCd");	
		enableSearch("imgSearchSublineCd");
		enableImg("imgEditRemarks");		
	}
	function disableFields(){		
		$("chkRequired").disabled = true;
		$("txtLineCd").readOnly = true;
		$("txtSublineCd").readOnly = true;
		$("txtRemarks").readOnly = true;	
		disableSearch("imgSearchLineCd");
		disableSearch("imgSearchSublineCd");
		disableImg("imgEditRemarks");	
	}

	function setBtnAndFields(obj) {
		if (obj != null) {				
			enableButton("btnDelete");				
			$("btnAddUpdate").value = "Update";		
			$("txtLineCd").readOnly = "readonly"; 
			$("txtSublineCd").readOnly = "readonly";
			disableSearch("imgSearchLineCd");
			disableSearch("imgSearchSublineCd");
		}else{
			$("btnAddUpdate").value = "Add";	
			enableButton("btnCancel");
			enableButton("btnSave");
			disableButton("btnDelete");
			$("txtLineCd").readOnly = false; 
			$("txtSublineCd").readOnly = false;
			enableSearch("imgSearchLineCd");
			enableSearch("imgSearchSublineCd");
		}
	}

	function setPkgLineSublineCvrgDtls(obj) {		
		try {
			$("chkRequired").checked = obj == null ? false
					: (obj.requiredFlag == "Y" ? true : false);
			$("txtLineCd").value = obj == null ? "" : unescapeHTML2(obj.packLineCd);
			$("txtLineName").value = obj == null ? "" : unescapeHTML2(obj.packLineName);
			$("txtSublineCd").value = obj == null ? "" : unescapeHTML2(obj.packSublineCd);
			$("txtSublineName").value = obj == null ? "" : unescapeHTML2(obj.packSublineName);
			$("txtRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtUserId").value = obj == null ? "" : obj.userId;
			$("txtLastUpdate").value = obj == null ? "" : obj.lastUpdate;
			$("txtLineCd").setAttribute("lastValidValue", obj == null ? "": (obj.packLineCd==null? "":unescapeHTML2(obj.packLineCd)));
			$("txtLineName").setAttribute("lastValidValue", obj == null ? "": (obj.packLineName==null? "":unescapeHTML2(obj.packLineName)));
			$("txtSublineCd").setAttribute("lastValidValue", obj == null ? "": (obj.packSublineCd==null? "":unescapeHTML2(obj.packSublineCd)));
			$("txtSublineName").setAttribute("lastValidValue", obj == null ? "": (obj.packSublineName==null? "":unescapeHTML2(obj.packSublineName)));
		} catch (e) {
			showErrorMessage("setPkgLineSublineCvrgDtls", e);
		}
	}	

	function fieldFocus(obj){
		if(obj!=null){
			$("txtRemarks").focus();	
		}else{
			if(!($("btnAddUpdate").disabled)){
				$("txtLineCd").focus();	
			}			
		}
	}
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("packageLineSublineDiv")) {
				if ($F("btnAddUpdate") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgPkgLineSublineCvrg.geniisysRows.length; i++) {
						if (tbgPkgLineSublineCvrg.geniisysRows[i].recordStatus == 0
								|| tbgPkgLineSublineCvrg.geniisysRows[i].recordStatus == 1) {						
							if (tbgPkgLineSublineCvrg.geniisysRows[i].packLineCd == escapeHTML2($F("txtLineCd")) && 
									tbgPkgLineSublineCvrg.geniisysRows[i].packSublineCd == escapeHTML2($F("txtSublineCd"))) {
								addedSameExists = true;
							}
						} else if (tbgPkgLineSublineCvrg.geniisysRows[i].recordStatus == -1) {
							if (tbgPkgLineSublineCvrg.geniisysRows[i].packLineCd == escapeHTML2($F("txtLineCd")) &&
									tbgPkgLineSublineCvrg.geniisysRows[i].packSublineCd == escapeHTML2($F("txtSublineCd"))) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same pack_line_cd and pack_subline_cd.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISLineSublineCoveragesController", {
						parameters : {
							action : "valAddRec",
							lineCd: unescapeHTML2(objPkgLineSublineCvrg.lineCd),
							packLineCd: $("txtLineCd").value,
							packSublineCd: $("txtSublineCd").value
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response)
									&& checkErrorOnResponse(response)) {
								addRec();
							}
						}
					});
				} else {
					addRec();
				}	
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}
	
	function valDeleteRec() {
		try {		
			new Ajax.Request(contextPath + "/GIISLineSublineCoveragesController", {
				parameters : {
					action : "valDeleteRec",
					lineCd: objPkgLineSublineCvrg.lineCd,
					packLineCd: $("txtLineCd").value,
					packSublineCd: $("txtSublineCd").value
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response) &&
							checkErrorOnResponse(response)) {
						deleteRec();						
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}	

	function setObjPkgLineSublineCvrg(obj) {
		try {		
			objPkgLineSublineCvrg.requiredFlag = obj == null ? "" : (obj.requiredFlag==null?"":unescapeHTML2(obj.requiredFlag));
			objPkgLineSublineCvrg.packLineCd = obj == null ? "" : (obj.packLineCd==null?"":unescapeHTML2(obj.packLineCd));
			objPkgLineSublineCvrg.packLineName = obj == null ? "" : (obj.packLineName==null?"":unescapeHTML2(obj.packLineName));
			objPkgLineSublineCvrg.packSublineCd = obj == null ? "" : (obj.packSublineCd==null?"":unescapeHTML2(obj.packSublineCd));
			objPkgLineSublineCvrg.packSublineName = obj == null ? "" : (obj.packSublineName==null?"":unescapeHTML2(obj.packSublineName));	
			objPkgLineSublineCvrg.remarks = obj == null ? "" : (obj.remarks==null?"":unescapeHTML2(obj.remarks));
			objPkgLineSublineCvrg.userId = obj == null ? "" : (obj.userId==null?"":unescapeHTML2(obj.userId));
			objPkgLineSublineCvrg.lastUpdate = obj == null ? "" : (obj.lastUpdate==null?"":obj.lastUpdate);			
		} catch (e) {
			showErrorMessage("setObjPkgLineSublineCvrg", e);
		}
	}

	function setRowObjPkgLineSublineCvrg(func){
		try {					
			var rowObjPkgLineSublineCvrg = new Object();
			rowObjPkgLineSublineCvrg.lineCd = objPkgLineSublineCvrg.lineCd;
			rowObjPkgLineSublineCvrg.requiredFlag = $("chkRequired").checked ? "Y":"N";	
			rowObjPkgLineSublineCvrg.packLineCd = escapeHTML2($("txtLineCd").value);	
			rowObjPkgLineSublineCvrg.packLineName = escapeHTML2($("txtLineName").value);	
			rowObjPkgLineSublineCvrg.packSublineCd = escapeHTML2($("txtSublineCd").value);	
			rowObjPkgLineSublineCvrg.packSublineName = escapeHTML2($("txtSublineName").value);	
			rowObjPkgLineSublineCvrg.remarks = escapeHTML2($("txtRemarks").value);
			rowObjPkgLineSublineCvrg.userId = escapeHTML2(userId);
			var lastUpdate = new Date();		
			rowObjPkgLineSublineCvrg.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');	
			rowObjPkgLineSublineCvrg.recordStatus 	= func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return rowObjPkgLineSublineCvrg;
		} catch (e) {
			showErrorMessage("setRowObjPkgLineSublineCvrg", e);
		}
	}	

	function addRec(){
		rowObj  = setRowObjPkgLineSublineCvrg($("btnAddUpdate").value);
		if($("btnAddUpdate").value=="Update"){
			objPkgLineSublineCvrgMain.splice(row, 1, rowObj);
			tbgPkgLineSublineCvrg.updateVisibleRowOnly(rowObj, row);
			tbgPkgLineSublineCvrg.onRemoveRowFocus();		
		}else if ($("btnAddUpdate").value=="Add"){				
			objPkgLineSublineCvrgMain.push(rowObj);
			tbgPkgLineSublineCvrg.addBottomRow(rowObj);
			tbgPkgLineSublineCvrg.onRemoveRowFocus();		
		}
		changeTag=1;
		changeTagFunc = saveGiiss096; // for logout confirmation				
	}

	function deleteRec(){ 
		delObj = setRowObjPkgLineSublineCvrg($("btnDelete").value);
		objPkgLineSublineCvrgMain.splice(row, 1, delObj);
		tbgPkgLineSublineCvrg.deleteVisibleRowOnly(row);		
		setPkgLineSublineCvrgDtls(null);	
		setBtnAndFields(null);		
		changeTag = 1;
		changeTagFunc = saveGiiss096; // for logout confirmation
	}

	function saveGiiss096(){
		try{	
			var objParams = new Object(); 
			objParams.setRows = getAddedAndModifiedJSONObjects(objPkgLineSublineCvrgMain);
			objParams.delRows = getDeletedJSONObjects(objPkgLineSublineCvrgMain);
			new Ajax.Request(contextPath + "/GIISLineSublineCoveragesController", {
				method : "POST",
				parameters : {
					action : "saveGiiss096",
					parameters : JSON.stringify(objParams)				
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function(){
					showNotice("Saving Package Line, Subline Coverage Maintenance, please wait ...");
				},
				onComplete : function(response) {
					hideNotice();								
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objPkgLineSublineCvrg.exitPage != null) {
								objPkgLineSublineCvrg.exitPage();
							} else {
								tbgPkgLineSublineCvrg._refreshList();
							}
						});
						changeTag = 0;
					}		
				}
			});				
		}catch(e){
			showErrorMessage("saveGiiss096", e);
		}
	}
	
	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}
	
	function cancelGiiss096() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objPkgLineSublineCvrg.exitPage = exitPage;
						saveGiiss096();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToUnderwriting",
								"Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}
	}
			
	function initializeGIISS096(){
		setBtnAndFields(null);		
		objPkgLineSublineCvrg = new Object();
		objPkgLineSublineCvrg.exitPage = null;
		changeTag = 0;
		disableFields();
		disableButton("btnAddUpdate");	
	}	

	$("btnAddUpdate").observe("click", valAddRec);

	$("btnDelete").observe("click", valDeleteRec);

	observeSaveForm("btnSave", saveGiiss096);

	$("btnCancel").observe("click", cancelGiiss096);

	$("txtLineCd").observe("change", function() {
		if($("txtLineCd").value!=""&& $("txtLineCd").value != $("txtLineCd").readAttribute("lastValidValue")){
			getPkgLineCvrgLOV();
			return;
		}else if($F("txtLineCd").trim() == "") {
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").setAttribute("lastValidValue", "");
			$("txtLineName").value="";	
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").setAttribute("lastValidValue", "");
			$("txtSublineCd").value="";
			$("txtSublineName").value="";
		}
	});	

	$("txtSublineCd").observe("change", function() {
		if($("txtSublineCd").value!=""&& $("txtSublineCd").value != $("txtSublineCd").readAttribute("lastValidValue")){
			getPkgSublineCvrgLOV();
			return;
		}else if($F("txtSublineCd").trim() == "") {			
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").setAttribute("lastValidValue", "");
			$("txtSublineName").value="";	
		}
	});	

	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});

	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	
	$("imgSearchLineCd").observe("click", function() {
		getPkgLineCvrgLOV();
	});
	
	$("imgSearchSublineCd").observe("click", function() {
		getPkgSublineCvrgLOV();
	});

	$("imgEditRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000);
	});	
	
	observeReloadForm("reloadForm", function(){
		showPackageLineSublineCoverage();
		});
	
	$("underwritingExit").stopObserving("click");
	$("underwritingExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	
	initializeGIISS096();	
} catch (e) {
	showErrorMessage("Error : ", e.message);
}
	
</script>