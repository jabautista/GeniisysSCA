<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="userGroupModulesDiv" name="userGroupModulesDiv">
	<div id="" class="sectionDiv" style="height: 40px; width: 99%; margin-top: 5px;">
		<label style="margin: 14px 5px 0 65px;">User Group </label>
		<input type="text" id="txtUGMUserGrp" readonly="readonly" style="text-align: right; width: 60px; margin-top: 9px; border: solid 1px gray;" value=""></input>
		<input type="text" id="txtUGMUserGrpDesc" readonly="readonly" style="width: 260px; margin-top: 9px; border: solid 1px gray;" value=""></input>
		<input type="text" id="txtUGMGrpIssCd" readonly="readonly" style="text-align: right; width: 40px; margin-top: 9px; border: solid 1px gray;" value=""></input>
	</div>
	<div id="userGroupModulesTableDiv" style="height: 345px; padding-top: 10px; width: 99%;" class="sectionDiv">
		<div id="userGroupModulesTable" style="float: left; height: 310px; margin-left: 10px;"></div>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnUGMReturn" value="Return" style="width: 80px; margin-top: 10px;">
	</div>
</div>
<script>
try{
	$("txtUGMUserGrp").value = $F("txtUserGrp");
	$("txtUGMUserGrpDesc").value = $F("txtDspUserGrpDesc");
	$("txtUGMGrpIssCd").value = $F("txtDspGrpIssCd");
	
	$("btnUGMReturn").observe("click", function(){
		overlayGIIS040UserGroupModules.close();
		delete overlayGIIS040UserGroupModules;
	});
	
	var objUserGroupModules = new Object();
	objUserGroupModules.recList = JSON.parse('${jsonUserGroupModules}');
	
	var tableModel = {
		url: contextPath+"/GIISS040Controller?refresh=1&action=showUserGroupModules&userGrp="+$F("txtUserGrp")+"&tranCd="+$F("hidTranCd"),
		options: {
			width: '575px',
			hideColumnChildTitle: true,
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
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
				filterOption: true,
				renderer : function(value){
					return unescapeHTML2(value);
				}
			},
			{
				id: 'moduleDesc',
				title: 'Module Desc',
				width: '330px'
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
				filterOption: true,
				renderer : function(value){
					return unescapeHTML2(value);
				}
			}
		],
		rows: objUserGroupModules.recList.rows
	};

	tbgUserGroupModules = new MyTableGrid(tableModel);
	tbgUserGroupModules.pager = objUserGroupModules.recList,
	tbgUserGroupModules.render('userGroupModulesTable');
} catch (e){
	showErrorMessage("userGroupModules.jsp", e);
}
</script>