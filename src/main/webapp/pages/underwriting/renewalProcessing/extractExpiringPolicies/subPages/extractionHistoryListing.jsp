<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="extractionHistoryListingMainDiv" name="extractionHistoryListingMainDiv">
	<div id="extractionHistoryTableGridDiv" align="center">
		<div id="extractionHistoryGridDiv" style="height: 326px; margin-top: 5px;">
			<div id="extractionHistoryTableGrid" style="height: 306px; width: 460px;"></div>
		</div>
		<div class="buttonsDiv" align="center">
			<input type="button" id="btnClose" name="btnClose" style=" width: 140px;" class="button hover"   value="Close" />
		</div>
		<div id="user" style="position: absolute; right: 25px; margin-top: 35px;  width:100px; height:40px;  display: block; " class="sectionDiv leftAligned">
			<input type="radio" value="1" id="allUsers" name="rangeType" tabindex="1" /> <label for="allUsers" style="float: none;">All Users</label><br>
			<input type="radio" value="2" id="currentUser" name="rangeType" tabindex="2"  checked="checked"/> <label for="currentUser" style="float: none;">Current User</label>
		</div>
	</div>
</div>

<script type="text/javascript">

	try{
		var objExtHist = new Object();
		objExtHist.objExtHistListTableGrid = JSON.parse('${extractionHistoryTableGrid}'.replace(/\\/g, '\\\\'));
		objExtHist.objExtHistList = objExtHist.objExtHistListTableGrid.rows || [];
		var refreshAction = '${refreshAction}';

		var polDistTableModel = {
			url: contextPath+"/GIEXExpiryController?action="+refreshAction,
			options:{
				width: '460px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{ 	id: 'extractUser',
					title : 'User Id',
					width : '120px',
					filterOption: true
				},
				{	id:'strExtractDate',
					title: 'Date and Time',
					width: '330px',
					renderer : function(value){
						return dateFormat(value, "mm-dd-yyyy hh:MM:ss TT");
					}
				}
			],
			rows: objExtHist.objExtHistList
		};

		extractionHistoryTableGrid = new MyTableGrid(polDistTableModel);
		extractionHistoryTableGrid.pager = objExtHist.objExtHistListTableGrid;
		extractionHistoryTableGrid.render('extractionHistoryTableGrid');

	}catch(e){
		showErrorMessage("extractionHistoryListing", e);
	}

	$("btnClose").observe("click", function(){
		extractionHistoryTableGrid.keys.removeFocus(extractionHistoryTableGrid.keys._nCurrentFocus, true);
		extractionHistoryTableGrid.keys.releaseKeys();
		Windows.close("modal_dialog_extractionHistory");
	});
	
	$("allUsers").observe("click", function(){
			new Ajax.Updater("modal_content_extractionHistory", contextPath+"/GIEXExpiryController?action=getAllExtractionHistory", {
		    	evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {			
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
					$("allUsers").checked = true;
				}
			});
	});
	
	$("currentUser").observe("click", function(){
		new Ajax.Updater("modal_content_extractionHistory", contextPath+"/GIEXExpiryController?action=getExtractionHistory", {
	    	evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (!checkErrorOnResponse(response)) {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
				$("currentUser").checked = true;
			}
		});
	});
	
</script>