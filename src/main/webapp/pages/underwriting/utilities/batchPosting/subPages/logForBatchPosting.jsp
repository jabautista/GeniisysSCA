<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="height: 380px; margin-left: 10px;">
	<div id="tabComponentsDiv1" class="tabComponents1" style="width: 820px; float: left; height: 38px;" >
		<ul>
			<li class="tab1 selectedTab1" style="width:22%;"><a id="postedTab">Posted</a></li>
			<li class="tab1" style="width:23%;"><a id="notPostedTab">Not Posted</a></li>
		</ul>		
	</div>
	<div class="tabBorderBottom1"></div>
	<div class="sectionDiv" style="height: 345px; width: 820px; margin-top: -1px; border-color: #B0B0B0; z-index: -1;">
		<div id="tabPageContents" name="tabPageContents" style="width: 100%; float: left;">	
			<div id="postedTabContents" name="postedTabContents" style="width: 100%; float: left;">
				<div id="postedLogDiv" style="height: 320px; margin: 10px; width: 800px;"></div>
			</div>
			<div id="notPostedTabContents" name="notPostedTabContents" style="float: left; margin-left: 10px; margin-top: 10px;">
				<div id="notPostedLogDiv" style="height: 320px; width: 800px;"></div>
			</div>
		</div>	
	</div>
</div>
<div style="margin-top: 10px;">
	<table align="center">
		<td>
			<input type="button" class="button" style="width: 100px;" id="btnReturn" name="btnReturn" value="Return" tabindex="101"/>
		</td>
	</table>
</div>
<script>

try {
	initializeTabs();
	initializeAll();
	$("notPostedTabContents").hide();
	
	var objPostedLogForBatchPosting = new Object();
	objPostedLogForBatchPosting.jsonPostedLogs = JSON.parse('${jsonPostedLog}'.replace(/\\/g, '\\\\'));
	objPostedLogForBatchPosting.postedLogs = objPostedLogForBatchPosting.jsonPostedLogs.rows || [];
	
	var postedListTG = {
		url : contextPath + "/BatchPostingController?action=showLogForBatchPosting&refresh=1",
		options : {
			width : '800px',
			height : '300px',
			onCellFocus : function(element, value, x, y, id) {
				postedLogTableGrid.keys.removeFocus(postedLogTableGrid.keys._nCurrentFocus, true);
				postedLogTableGrid.keys.releaseKeys();
			},
			onSort : function() {
				postedLogTableGrid.keys.removeFocus(postedLogTableGrid.keys._nCurrentFocus, true);
				postedLogTableGrid.keys.releaseKeys();
			},
			prePager : function() {
				postedLogTableGrid.keys.removeFocus(postedLogTableGrid.keys._nCurrentFocus, true);
				postedLogTableGrid.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter : function(){
					postedLogTableGrid.keys.removeFocus(postedLogTableGrid.keys._nCurrentFocus, true);
					postedLogTableGrid.keys.releaseKeys();
				}
			}
		},
		columnModel : [
				{
					id : 'recordStatus',
					width : '0',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},{
					id : 'parNo',
					title : 'PAR No.',
					filterOption : true,
					sortable : true,
					width : '160'
				}, {
					id : 'policyNo',
					title : 'Policy No.',
					filterOption : true,
					sortable : true,
					width : '200'
				}, {
					id : 'remarks',
					title : 'Remarks',
					filterOption : true,
					sortable : true,
					width : '300'
				}, {
					id : 'userId',
					title : 'Underwriter',
					filterOption : true,
					sortable : true,
					width : '110'
				}],
		rows : objPostedLogForBatchPosting.postedLogs
	};
		postedLogTableGrid = new MyTableGrid(postedListTG);
		postedLogTableGrid.pager = objPostedLogForBatchPosting.jsonPostedLogs;
		postedLogTableGrid.render('postedLogDiv');
	
	var objErrorLogForBatchPosting = new Object();
	objErrorLogForBatchPosting.jsonErrorLogs = JSON.parse('${jsonErrorLog}'.replace(/\\/g, '\\\\'));
	objErrorLogForBatchPosting.errorLogs = objErrorLogForBatchPosting.jsonErrorLogs.rows || [];
	
	var parListTG = {
		url : contextPath + "/BatchPostingController?action=showErroLogForBatchPosting",
		options : {
			width : '800px',
			height : '300px',
			onCellFocus : function(element, value, x, y, id) {
				erroLogTableGrid.keys.removeFocus(erroLogTableGrid.keys._nCurrentFocus, true);
				erroLogTableGrid.keys.releaseKeys();
			},
			onSort : function() {
				erroLogTableGrid.keys.removeFocus(erroLogTableGrid.keys._nCurrentFocus, true);
				erroLogTableGrid.keys.releaseKeys();
			},
			prePager : function() {
				erroLogTableGrid.keys.removeFocus(erroLogTableGrid.keys._nCurrentFocus, true);
				erroLogTableGrid.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter : function(){
					erroLogTableGrid.keys.removeFocus(erroLogTableGrid.keys._nCurrentFocus, true);
					erroLogTableGrid.keys.releaseKeys();
				}
			}
		},
		columnModel : [
				{
					id : 'recordStatus',
					width : '0',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},{
					id : 'parNo',
					title : 'PAR No.',
					filterOption : true,
					sortable : true,
					width : '160'
				}, {
					id : 'remarks',
					title : 'Remarks',
					filterOption : true,
					sortable : true,
					width : '515'
				}, {
					id : 'userId',
					title : 'User ID',
					filterOption : true,
					sortable : true,
					width : '90'
				}],
		rows : objErrorLogForBatchPosting.errorLogs
	};
		erroLogTableGrid = new MyTableGrid(parListTG);
		erroLogTableGrid.pager = objErrorLogForBatchPosting.jsonErrorLogs;
		erroLogTableGrid.render('notPostedLogDiv');
	} catch (e) {
		showErrorMessage("Error LOG", e);
	}
	
	$("postedTab").observe("click", function () {
		$("postedTabContents").show();
		$("notPostedTabContents").hide();
	});
	
	$("notPostedTab").observe("click", function () {
		$("postedTabContents").hide();
		$("notPostedTabContents").show();
	});

	$("btnReturn").observe("click", function(){
		errorLogOverlay.close();
	});
	
</script>