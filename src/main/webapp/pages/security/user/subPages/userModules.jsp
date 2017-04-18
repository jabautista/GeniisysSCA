<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="userModulesDiv" name="userModulesDiv">
	<div id="" class="sectionDiv" align="center" style="width:99%; margin-top: 5px;">
		<table style="margin: 5px 0 5px 0;">
			<tr>
				<td class="rightAligned">User ID</td>
				<td class="leftAligned"><input type="text" id="txtUMUserId" readonly="readonly" style="width: 200px;" value="" tabindex="500"></input></td>
			</tr>
		</table>
	</div>	
	<div class="sectionDiv" style="width: 99%;">
		<div id="userModulesTableDiv" style="height: 270px; padding-top: 10px; width: 99%;">
			<div id="userModulesTable" style="float: left; height: 245px; margin-left: 10px;"></div>		
		</div>
		<div id="userModuleFormDiv" style="margin: 2px 0 10px 10px; width: 99%;">
			<table>
				<tr>
					<td class="rightAligned"></td>
					<td class="leftAligned">
						<input id="chkUMIncTag" type="checkbox" class="" style="margin-left: 0px; float:left;" tabindex="501"><label style="margin-left: 5px; float: left;" for="chkUMIncTag">Include Tag</label>
					</td>
					<td width="111px" class="rightAligned">Access Tag</td>
					<td class="leftAligned">
						<select id="selUMAccessTag" style="width: 207px; height: 22px;" class="" tabindex="502">
							<option value=""></option>
							<c:forEach var="accessTag" items="${accessTags}">
								<option value="${accessTag.rvLowValue}">${accessTag.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
				</tr>		
				<tr>
					<td class="rightAligned">Module ID</td>
					<td class="leftAligned" colspan="3">
						<input id="txtUMModuleId" type="text" class="" style="width: 111px; float: left;" readonly="readonly" tabindex="503">
						<label style="height: 20px; float: left; margin-left: 11px; padding-top: 6px; margin-right: 3px;">Module Desc</label>
						<input id="txtUMModuleDesc" type="text" class="" style="width: 319px;" readonly="readonly" tabindex="504">
					</td>
				</tr>
				<tr>
					<td width="" class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" name="remarksDiv" style="float: left; width: 530px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 500px; margin-top: 0; border: none;" id="txtUMRemarks" name="txtUMRemarks" maxlength="500"  onkeyup="limitText(this,500);" tabindex="505"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="506"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned"><input id="txtUMUser" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="507"></td>
					<td width="111px" class="rightAligned">Last Update</td>
					<td class="leftAligned"><input id="txtUMLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="508"></td>
				</tr>
			</table>			
		</div>	
		<div style="margin: 8px;" align="center">
			<input type="button" class="button" id="btnUMUpdate" value="Update" tabindex="509">
		</div>
	</div>	
	<div align="center">
		<input type="button" class="button" id="btnUMCheckAll" value="Check All" style="width: 80px; margin-top: 10px;" tabindex="510">
		<input type="button" class="button" id="btnUMUncheckAll" value="Uncheck All" style="width: 80px; margin-top: 10px;" tabindex="511">
		<input type="button" class="button" id="btnUMReturn" value="Return" style="width: 80px; margin-top: 10px;" tabindex="512">
		<input type="button" class="button" id="btnUMSave" value="Save" style="width: 80px; margin-top: 10px;" tabindex="513">
	</div>
</div>
<script>
try{
	initializeAll();
	$("txtUMUserId").value = $F("txtUserTranUserId");
	
	$("btnUMReturn").observe("click", function(){
		cancelGiiss040UserModules();
		tbgUserTran._refreshList();
	});
	
	function saveGiiss040UserModules(){
		if(objUserModules.changeTag == 0 || objUserModules.changeTag == null) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var setRows = getAddedAndModifiedJSONObjects(tbgUserModules.geniisysRows);
		new Ajax.Request(contextPath+"/GIISS040Controller", {
			method: "POST",
			parameters : {action : "saveGiiss040UserModules",
					 	  setRows : prepareJsonAsParameter(setRows)
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objUserModules.exitPage != null) {
							objUserModules.exitPage();
						} else {
							tbgUserModules._refreshList();
						}
					});
					objUserModules.changeTag = 0;					
				}
			}
		});
	}	
	
	var objUserModules = new Object();
	objUserModules.recList = JSON.parse('${jsonUserModules}');
	var objUserModule = null;
	var rowIndex = -1;
	
	var tableModel = {
		url: contextPath+"/GIISS040Controller?refresh=1&action=showUserModules&userId="+encodeURIComponent($F("txtUMUserId"))+"&tranCd="+$F("txtTranCd"),
		options: {
			width: '590px',
			hideColumnChildTitle: true,
			onCellFocus : function(element, value, x, y, id){
				rowIndex = y;
				objUserModule = tbgUserModules.geniisysRows[y];
				setFieldValues(objUserModule);
				setForm(true);
				tbgUserModules.keys.removeFocus(tbgUserModules.keys._nCurrentFocus, true);
				tbgUserModules.keys.releaseKeys();
				$("txtUMModuleId").focus();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				setFieldValues(null);
				setForm(false);
				tbgUserModules.keys.removeFocus(tbgUserModules.keys._nCurrentFocus, true);
				tbgUserModules.keys.releaseKeys();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					setForm(false);
					tbgUserModules.keys.removeFocus(tbgUserModules.keys._nCurrentFocus, true);
					tbgUserModules.keys.releaseKeys();
				}
			},
			beforeSort : function(){
				if(objUserModules.changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnUMSave").focus();
					});
					return false;
				}
			},
			onSort: function(){
				rowIndex = -1;
				setFieldValues(null);
				setForm(false);
				tbgUserModules.keys.removeFocus(tbgUserModules.keys._nCurrentFocus, true);
				tbgUserModules.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				setForm(false);
				tbgUserModules.keys.removeFocus(tbgUserModules.keys._nCurrentFocus, true);
				tbgUserModules.keys.releaseKeys();
			},				
			prePager: function(){
				if(objUserModules.changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnUMSave").focus();
					});
					return false;
				}
				rowIndex = -1;
				setFieldValues(null);
				setForm(false);
				tbgUserModules.keys.removeFocus(tbgUserModules.keys._nCurrentFocus, true);
				tbgUserModules.keys.releaseKeys();
			},
			checkChanges: function(){
				return (objUserModules.changeTag == 1 ? true : false);
			},
			masterDetailRequireSaving: function(){
				return (objUserModules.changeTag == 1 ? true : false);
			},
			masterDetailValidation: function(){
				return (objUserModules.changeTag == 1 ? true : false);
			},
			masterDetail: function(){
				return (objUserModules.changeTag == 1 ? true : false);
			},
			masterDetailSaveFunc: function() {
				return (objUserModules.changeTag == 1 ? true : false);
			},
			masterDetailNoFunc: function(){
				return (objUserModules.changeTag == 1 ? true : false);
			}
		},
		columnModel: [
			{
			    id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false 			
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{ 	id:			'incTag',
				align:		'center',
				title:		'',
				titleAlign:	'center',
				width:		'23px',
		   		editable: false,
			    editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";
	            		}
	            	}
			    })
			},
			{
				id: 'moduleId',
				title: 'Module ID',
				width: '80px',
				filterOption: true
			},
			{
				id: 'moduleDesc',
				title: 'Module Desc',
				width: '330px',
				filterOption: true
			},
			{
				id: 'dspAccessTag',
				title: '',
				visible : false,
				width: '0'
			},			
			{
				id: 'dspAccessTagDesc',
				title: 'Access Tag',
				width: '100px',
				filterOption: true
			},			
			{
				id: 'remarks',
				title: '',
				visible: false,
				width: '0'
			}
		],
		rows: objUserModules.recList.rows
	};

	tbgUserModules = new MyTableGrid(tableModel);
	tbgUserModules.pager = objUserModules.recList,
	tbgUserModules.render('userModulesTable');
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.umUserId = escapeHTML2($F("txtUMUserId"));
			obj.tranCd = $F("txtTranCd");
			obj.moduleId = escapeHTML2($F("txtUMModuleId"));
			obj.moduleDesc = escapeHTML2($F("txtUMModuleDesc"));
			obj.dspAccessTag = $F("selUMAccessTag");
			obj.dspAccessTagDesc = $("selUMAccessTag").options[$("selUMAccessTag").selectedIndex].text;
			obj.remarks = escapeHTML2($F("txtUMRemarks"));
			obj.incTag = ($("chkUMIncTag").checked ? 'Y' : 'N');
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}	
	
	function updateRec(){
		try {
			if(checkAllRequiredFieldsInDiv("userModuleFormDiv")){
				var rec = setRec(objUserModule);
				tbgUserModules.updateVisibleRowOnly(rec, rowIndex, false);
				objUserModules.changeTag = 1;
				setFieldValues(null);
				setForm(false);
				tbgUserModules.keys.removeFocus(tbgUserModules.keys._nCurrentFocus, true);
				tbgUserModules.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("updateRec", e);
		}
	}		
	
	function setForm(enable){
		if(enable){
			$("selUMAccessTag").disabled = false;
			$("txtRemarks").readOnly = false;
			$("chkUMIncTag").disabled = false;
			enableButton("btnUMUpdate");
			
			if($("chkUMIncTag").checked){
				$("selUMAccessTag").addClassName("required");
			} else {
				$("selUMAccessTag").removeClassName("required");
			}
		} else {
			$("selUMAccessTag").disabled = true;
			$("txtRemarks").readOnly = true;
			$("chkUMIncTag").disabled = true;
			disableButton("btnUMUpdate");
			$("selUMAccessTag").removeClassName("required");
		}
	}	
	
	function setFieldValues(rec){
		try{
			$("txtUMModuleId").value = (rec == null ? "" : rec.moduleId);
			$("txtUMModuleDesc").value = (rec == null ? "" : unescapeHTML2(rec.moduleDesc));
			$("txtUMUser").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtUMLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtUMRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("selUMAccessTag").value = (rec == null ? "" : rec.dspAccessTag);
			
			rec != null && rec.incTag == "Y" ? $("chkUMIncTag").checked = true : $("chkUMIncTag").checked = false;
			objUserModule = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function exitPage(){
		overlayGIISS040UserModules.close();
		delete overlayGIISS040UserModules;
	}	
	
	function cancelGiiss040UserModules(){
		if(objUserModules.changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objUserModules.exitPage = exitPage;
						saveGiiss040UserModules();						
					}, function(){
						overlayGIISS040UserModules.close();
						delete overlayGIISS040UserModules;
					}, "");
		} else {
			overlayGIISS040UserModules.close();
			delete overlayGIISS040UserModules;
		}
	}	
	
	function checkAll(){
		new Ajax.Request(contextPath+"/GIISS040Controller", {
			method: "POST",
			parameters: {action: "checkAllUserModule",
						 tranCd : $F("txtTranCd"),
				         umUserId: $F("txtUMUserId")
						},
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					tbgUserModules._refreshList();
				}
			}
		});
	}
	
	function uncheckAll(){
		new Ajax.Request(contextPath+"/GIISS040Controller", {
			method: "POST",
			parameters: {action: "uncheckAllUserModule",
						 tranCd : $F("txtTranCd"),
				         umUserId: $F("txtUMUserId")
						},
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					tbgUserModules._refreshList();
				}
			}
		});
	}	
	
	$("chkUMIncTag").observe("change", function(){
		if(this.checked){
			$("selUMAccessTag").addClassName("required");
		} else {
			$("selUMAccessTag").removeClassName("required");
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtUMRemarks", 500, $("txtUMRemarks").hasAttribute("readonly"));
	});
	
	$("btnUMCheckAll").observe("click", checkAll);
	$("btnUMUncheckAll").observe("click", uncheckAll);
	$("btnUMUpdate").observe("click", updateRec);
	$("btnUMSave").observe("click", saveGiiss040UserModules);
	setForm(false);
} catch (e){
	showErrorMessage("userModules.jsp", e);
}
</script>