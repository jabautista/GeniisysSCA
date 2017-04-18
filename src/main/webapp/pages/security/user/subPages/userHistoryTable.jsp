<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>

<div id="userHistoryDiv" name="userHistoryDiv">
	<div id="userIdDiv" class="sectionDiv" style="height: 50px; width: 99%; margin-top: 10px;">
		<label style="margin: 17px 5px 0 240px;">User ID </label>
		<input type="text" id="userIdHist" name="userIdHist" readonly="readonly" style="width: 150px; margin-top: 12px; background-color: transparent;  border: solid 1px #ccc;" value=""></input>
	</div>	
	<div id="userHistoryTableDiv" style="height: 290px; padding-top: 10px; width: 99%;" class="sectionDiv">
		<div id="histTable" style="float: left; height: 255px; margin-left: 10px;"></div>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnUserHistReturn" value="Return" style="width: 80px; margin-top: 10px;">
	</div>
</div>
<script>
try{
	$("btnUserHistReturn").observe("click", function(){
		tableGrid.keys.removeFocus(tableGrid.keys._nCurrentFocus, true);
		tableGrid.keys.releaseKeys();
		overlayGIIS040UserHistory.close();
		delete overlayGIIS040UserHistory;
	});
	
	var objPagerParams = new Object();
	objPagerParams.objUserHistTableGrid = JSON.parse('${jsonUserHistory}');
	objPagerParams.objUserHist = objPagerParams.objUserHistTableGrid.rows || [];
	$("userIdHist").value = unescapeHTML2(objPagerParams.objUserHistTableGrid.userId);

	var tableModel = {
		url: contextPath+"/GIISS040Controller?refresh=1&action=showUserHistory&userId="+encodeURIComponent($F("userIdHist")),
		options: {
			width: '673px',
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
			{
				id: 'histId',
				titleAlign : 'right',
				title: 'Hist',
				width: '50',
				align: 'right',
				filterOptionType : 'integerNoNegative',
				filterOption: true
			},
			{
				id: 'oldUserGrp oldUserDesc',
				title: 'Old User Group',
				width: '220',
				children : [
							{
								id: 'oldUserGrp',
								title: 'Old User Group',
								width: '40',
								align: 'right',
								filterOptionType : 'integerNoNegative',
								filterOption: true
							},
							{
								id: 'oldUserDesc',
								title: '',
								width: '185',
								renderer : function(value){
									return unescapeHTML2(value);
								}
							}
				           ]
			},
			{
				id: 'newUserGrp newUserDesc',
				title: 'New User Group',
				width: '220',
				children : [
							{
								id: 'newUserGrp',
								title: 'New User Group',
								width: '40',
								align: 'right',
								filterOptionType : 'integerNoNegative',
								filterOption: true
							},
							{
								id: 'newUserDesc',
								title: '',
								width: '185',
								renderer : function(value){
									return unescapeHTML2(value);
								}
							}
				           ]
			},
			{
				id: 'lastUpdateChar',
				title: 'Last Update',
				width: '130'/* ,
				renderer: function (value){
					return dateFormat(value, "mm-dd-yyyy hh:MM:ss TT");
				} */
			}
		],
		rows: objPagerParams.objUserHist
	};

	tableGrid = new MyTableGrid(tableModel);
	tableGrid.pager = objPagerParams.objUserHistTableGrid,
	tableGrid.render('histTable');
} catch (e){
	showErrorMessage("userHistoryTable.jsp", e);
}
</script>