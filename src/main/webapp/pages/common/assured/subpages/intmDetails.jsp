<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="intmDetailsDiv" name="intmDetailsDiv">
	<div class="sectionDiv" style="width: 99%; margin-top: 5px;">
		<div id="intmDetailsTableDiv" style="height: 315px; padding-top: 10px; width: 99%;">
			<div id="intmDetailsTable" style="float: left; height: 290px; margin-left: 10px;"></div>		
		</div>
		<div align="center">
			<input type="hidden" id="hidIntmAssdNo" value="${intmAssdNo}">
			<input type="button" class="button" id="btnOk" value="Ok" style="width: 80px; margin-top: 10px; margin-bottom: 10px;">
		</div>
	</div>	
</div>
<script>
try{
	$("btnOk").observe("click", function(){
		overlayGiiss006IntmDetails.close();
		delete overlayGiiss006IntmDetails;
	});
	
	var objIntmDetails = new Object();
	objIntmDetails.recList = JSON.parse('${jsonIntmList}');
	var objUserModule = null;
	var rowIndex = -1;
	
	var tableModel = {
		url: contextPath+"/GIISAssuredController?refresh=1&action=showGiiss006IntmDetails&assdNo="+$F("hidIntmAssdNo"),
		options: {
			width: '625px',
			hideColumnChildTitle: true,
			onCellFocus : function(element, value, x, y, id){
				rowIndex = y;
				tbgIntmDetails.keys.removeFocus(tbgIntmDetails.keys._nCurrentFocus, true);
				tbgIntmDetails.keys.releaseKeys();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				tbgIntmDetails.keys.removeFocus(tbgIntmDetails.keys._nCurrentFocus, true);
				tbgIntmDetails.keys.releaseKeys();
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					tbgIntmDetails.keys.removeFocus(tbgIntmDetails.keys._nCurrentFocus, true);
					tbgIntmDetails.keys.releaseKeys();
				}
			},
			onSort: function(){
				rowIndex = -1;
				tbgIntmDetails.keys.removeFocus(tbgIntmDetails.keys._nCurrentFocus, true);
				tbgIntmDetails.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				tbgIntmDetails.keys.removeFocus(tbgIntmDetails.keys._nCurrentFocus, true);
				tbgIntmDetails.keys.releaseKeys();
			},				
			checkChanges: function(){
				return (objIntmDetails.changeTag == 1 ? true : false);
			},
			masterDetailRequireSaving: function(){
				return (objIntmDetails.changeTag == 1 ? true : false);
			},
			masterDetailValidation: function(){
				return (objIntmDetails.changeTag == 1 ? true : false);
			},
			masterDetail: function(){
				return (objIntmDetails.changeTag == 1 ? true : false);
			},
			masterDetailSaveFunc: function() {
				return (objIntmDetails.changeTag == 1 ? true : false);
			},
			masterDetailNoFunc: function(){
				return (objIntmDetails.changeTag == 1 ? true : false);
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
				id: 'lineCd',
				title: 'Line Cd',
				width: '60px',
				filterOption: true
			},
			{
				id: 'intmNo',
				title: 'Intm Code',
				width: '100px',
				titleAlign: 'right',
				align: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{
				id: 'intmName',
				title: 'Intermediary Name',
				width: '420px',
				filterOption: true
			}
		],
		rows: objIntmDetails.recList.rows
	};

	tbgIntmDetails = new MyTableGrid(tableModel);
	tbgIntmDetails.pager = objIntmDetails.recList,
	tbgIntmDetails.render('intmDetailsTable');
} catch (e){
	showErrorMessage("intmDetails.jsp", e);
}
</script>