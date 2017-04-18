<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="userGroupAccess" name="userGroupAccess">
	<div id="" class="sectionDiv" style="height: 40px; width: 99%; margin-top: 5px;">
		<label style="margin: 14px 5px 0 25px;">User Group </label>
		<input type="text" id="txtUserGrpAccessUserGrp" readonly="readonly" style="text-align: right; width: 60px; margin-top: 9px; border: solid 1px gray;" value=""></input>
		<input type="text" id="txtUserGrpAccessUserGrpDesc" readonly="readonly" style="width: 260px; margin-top: 9px; border: solid 1px gray;" value=""></input>
		<input type="text" id="txtUserGrpAccessGrpIssCd" readonly="readonly" style="text-align: left; width: 40px; margin-top: 9px; border: solid 1px gray;" value=""></input>
	</div>	
	<div id="userGrpTranTableDiv" style="float: left; height: 495px; padding-top: 10px; width: 99%;" class="sectionDiv">
		<div id="userGrpTranTable" style="height: 131px; margin-left: 10px;"></div>
		<div align="center">
			<input type="hidden" id="hidTranCd"/>
			<input type="button" class="button" id="btnModules" value="Modules" style="width: 120px; margin-top: 30px;">
		</div>
		<div id="userGrpDtlTable" style="height: 131px; margin-left: 10px; margin-top: 8px;"></div>
		<div id="userGrpLineTable" style="height: 106px; margin-left: 10px; margin-top: 30px;"></div>
	</div>
<!-- 	<div align="center">
		<input type="button" class="button" id="btnUserGroupAccessReturn" value="Return" style="width: 120px; margin-top: 10px;">
	</div> -->
</div>
<script>
try{
	disableButton("btnModules");
	$("txtUserGrpAccessUserGrp").value = $F("txtUserGrp");
	$("txtUserGrpAccessUserGrpDesc").value = $F("txtDspUserGrpDesc");
	$("txtUserGrpAccessGrpIssCd").value = $F("txtDspGrpIssCd");
	
	var userGrpLine = {
			id : 103,
			url: contextPath+"/GIISS040Controller?refresh=1&action=getUserGrpLine&userGrp="+$F("txtUserGrp")+"&tranCd=&issCd=",
			options: {
				width: '500px',
				hideColumnChildTitle: true,
				onCellFocus : function(element, value, x, y, id){
					tbgUserGrpLine.keys.removeFocus(tbgUserGrpLine.keys._nCurrentFocus, true);
					tbgUserGrpLine.keys.releaseKeys();
				},
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
				{
					id: 'lineCd',
					title: 'Line Code',
					width: '100',
					filterOption: true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id: 'lineName',
					title: 'Description',
					width: '350',
					renderer : function(value){
						return unescapeHTML2(value);
					}
				}
			],
			rows: []
		};

		tbgUserGrpLine = new MyTableGrid(userGrpLine);
		tbgUserGrpLine.pager = {};
		tbgUserGrpLine.render('userGrpLineTable');
	
	function selectUserGrpDtl(selected, y){
		try{
			tbgUserGrpLine.url = contextPath+"/GIISS040Controller?action=getUserGrpLine&userGrp="+$F("txtUserGrp")
											+"&tranCd="+$F("hidTranCd")
											+"&issCd="+(y != undefined ? unescapeHTML2(tbgUserGrpDtl.geniisysRows[y].issCd) : "");
			tbgUserGrpLine._refreshList();	
			tbgUserGrpDtl.keys.removeFocus(tbgUserGrpDtl.keys._nCurrentFocus, true);
			tbgUserGrpDtl.keys.releaseKeys();
		} catch(e){
			showErrorMessage("selectUserGrpTran", e);
		}
	}		
	
	// User Grp Dtl
	var userGrpDtlTable = {
			id : 102,
			url: contextPath+"/GIISS040Controller?refresh=1&action=getUserGrpDtl&userGrp="+$F("txtUserGrp")+"&tranCd=",
			options: {
				width: '500px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				onCellFocus : function(element, value, x, y, id){
					selectUserGrpDtl(true, y);
				},
				onRemoveRowFocus : function(){
					selectUserGrpDtl(false);
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						//selectUserGrpDtl(false);
					}
				},
				onSort: function(){
					//selectUserGrpDtl(false);
				},
				onRefresh: function(){
					//selectUserGrpDtl(false);
				},				
				prePager: function(){
					//selectUserGrpDtl(false);
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
				{
					id: 'issCd',
					title: 'Issue Cd',
					width: '100',
					filterOption: true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id: 'issName',
					title: 'Description',
					width: '350',
					filterOption : true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				}
			],
			rows: []
		};

		tbgUserGrpDtl = new MyTableGrid(userGrpDtlTable);
		tbgUserGrpDtl.pager = {};
		tbgUserGrpDtl.render('userGrpDtlTable');	
		tbgUserGrpDtl.afterRender = function(){
			if (tbgUserGrpDtl.geniisysRows.length > 0){
				tbgUserGrpDtl.selectRow('0');
				selectUserGrpDtl(true, 0);
			} else {
				selectUserGrpDtl(false);
			}
		};		
		
		// User Group Tran
		var objUserGrpTran = new Object();
		objUserGrpTran.userGrpTrans = JSON.parse('${jsonUserGrpTrans}');
		objUserGrpTran.selectedTranCd = null;

		function selectUserGrpTran(selected, y){
			try{
				$("hidTranCd").value = (y != undefined ? tbgUserGrpTran.geniisysRows[y].tranCd : "");
				tbgUserGrpDtl.url = contextPath+"/GIISS040Controller?action=getUserGrpDtl&userGrp="+$F("txtUserGrp")+"&tranCd="+(y != undefined ? tbgUserGrpTran.geniisysRows[y].tranCd : "");				
				tbgUserGrpDtl._refreshList();				
				tbgUserGrpTran.keys.removeFocus(tbgUserGrpTran.keys._nCurrentFocus, true);
				tbgUserGrpTran.keys.releaseKeys();
				(selected ? enableButton("btnModules") : disableButton("btnModules"));
			} catch(e){
				showErrorMessage("selectUserGrpTran", e);
			}
		}
		
		var userGrpTranTable = {
			id : 101,
			url: contextPath+"/GIISS040Controller?refresh=1&action=showUserGroupAccess&userGrp="+objUserGrpTran.userGrpTrans.userGrp,
			options: {
				width: '500px',
				hideColumnChildTitle: true,
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				onCellFocus : function(element, value, x, y, id){					
					selectUserGrpTran(true, y);
				},
				onRemoveRowFocus : function(){
					selectUserGrpTran(false);
					selectUserGrpDtl(false);
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						//selectUserGrpTran(false);
					}
				},
				onSort: function(){
					//selectUserGrpTran(false);
				},
				onRefresh: function(){
					//selectUserGrpTran(false);
				},				
				prePager: function(){
					//selectUserGrpTran(false);
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
				{
					id: 'tranCd',
					titleAlign : 'right',
					title: 'Tran Cd',
					width: '100',
					align: 'right',
					filterOption: true,
					filterOptionType : 'integerNoNegative'
				},
				{
					id: 'tranDesc',
					title: 'Description',
					width: '350',
					filterOption : true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				}
			],
			rows: objUserGrpTran.userGrpTrans.rows
		};

		tbgUserGrpTran = new MyTableGrid(userGrpTranTable);
		tbgUserGrpTran.pager = objUserGrpTran.userGrpTrans,
		tbgUserGrpTran.render('userGrpTranTable');
		tbgUserGrpTran.afterRender = function(){
			if (tbgUserGrpTran.geniisysRows.length > 0){
				tbgUserGrpTran.selectRow('0');
				selectUserGrpTran(true, 0);
			} else {
				selectUserGrpTran(false);
			}
		};

	function showUserGroupModules(){
		overlayGIIS040UserGroupModules = Overlay.show(contextPath
				+ "/GIISS040Controller", {
			urlContent : true,
			urlParameters : {
				action : "showUserGroupModules",
				userGrp : $F("txtUserGrp"),
				tranCd : $F("hidTranCd")
			},
			showNotice : true,
			title : "Accessible Modules",
			height : 450,
			width : 600,
			draggable : true
		});
	}	
	
	$("btnModules").observe("click", showUserGroupModules);
} catch (e){
	showErrorMessage("userGroupAccess.jsp", e);
}
</script>