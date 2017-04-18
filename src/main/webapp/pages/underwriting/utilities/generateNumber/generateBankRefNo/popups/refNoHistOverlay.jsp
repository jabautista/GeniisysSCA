<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="refNoHistOverlayMainDiv" name="refNoHistOverlayMainDiv" class="sectionDiv" style="width: 99.5%; height: 305px; margin-top: 10px;">
	<div id="refNoHistOverlayDiv">
		<div id="refNoHistTGDiv" style="padding: 10px 0 0 10px; height: 260px;"></div>
	</div>
	
	<div id="refNoHistOverlayButtonsDiv" align="center">
		<input id="btnReturn" type="button" class="button" value="Return" style="width: 110px;" tabindex="501">
	</div>
</div>

<script type="text/javascript">
	objRefNoHist = new Object();
	objRefNoHist.refNoHistTableGrid = JSON.parse('${refNoHistJSON}');
	objRefNoHist.refNoHistRows = objRefNoHist.refNoHistTableGrid.rows || [];

	try{
		refNoHistModel = {
			url: contextPath+"/GIPIRefNoHistController?action=showRefNoHistOverlay&refresh=1",
			options: {
	          	height: '225px',
	          	width: '750px',
	          	onCellFocus: function(element, value, x, y, id){
	          		refNoHistTG.keys.removeFocus(refNoHistTG.keys._nCurrentFocus, true);
	          		refNoHistTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	refNoHistTG.keys.removeFocus(refNoHistTG.keys._nCurrentFocus, true);
	            	refNoHistTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	refNoHistTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		refNoHistTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		refNoHistTG.onRemoveRowFocus();
	            	}
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'acctIssCd',
							title: 'Acct. Iss Cd',
							width: '80px',
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'branchCd',
							title: 'Branch Cd',
							width: '75px',
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'refNo',
							title: 'Reference No.',
							width: '95px',
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'modNo',
							title: 'Mod10',
							width: '50px',
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'remarks',
							title: 'Remarks',
							width: '250px',
							align: 'right',
							filterOption: true
						},
						{	id: 'dspUserId',
							title: 'User Id',
							width: '70px'
						},
						{	id: 'lastUpdate',
							title: 'Last Update',
							width: '90px',
							align: 'center',
							filterOption: true,
							filterOptionType: 'formattedDate'
						}
						],
			rows: objRefNoHist.refNoHistRows
		};
		refNoHistTG = new MyTableGrid(refNoHistModel);
		refNoHistTG.pager = objRefNoHist.refNoHistTableGrid;
		refNoHistTG.render('refNoHistTGDiv');
	}catch(e){
		showMessageBox("Error in Reference Number History Table Grid: " + e, imgMessage.ERROR);
	}
	
	$("btnReturn").observe("click", function(){
		refNoHistOverlay.close();
		delete refNoHistOverlay;
	});
</script>