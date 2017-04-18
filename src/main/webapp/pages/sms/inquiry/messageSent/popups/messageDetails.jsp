<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="messageDetailsMainDiv" name="messageDetailsMainDiv">
	<div class="sectionDiv" style="width: 732px; margin: 10px 0 12px 0;">
		<div id="messageDetailsTGDiv" name="messageDetailsTGDiv" style="height: 295px; width: 720px; margin: 12px 0 20px 16px; float: left;"></div>
	</div>
	<div align="center">
		<input id="btnOk" name="btnOk" type="button" class="button" value="Ok" style="width: 90px;" tabindex="202"/>
	</div>
</div>

<script type="text/javascript">
	messageDetailsOverlay.tableGrid = JSON.parse('${messageDetailsJSON}');
	messageDetailsOverlay.rows = messageDetailsOverlay.tableGrid.rows || [];

	try{
		messageDetailsModel = {
			url: contextPath+"/GISMMessagesSentController?action=showMessageDetails"+
								"&refresh=1&messageId="+objMessagesSent.selectedMessage,
			options: {
	          	height: '280px',
	          	width: '700px',
	          	onCellFocus: function(element, value, x, y, id){
	          		messageDetailsTG.keys.removeFocus(messageDetailsTG.keys._nCurrentFocus, true);
	          		messageDetailsTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	messageDetailsTG.keys.removeFocus(messageDetailsTG.keys._nCurrentFocus, true);
	          		messageDetailsTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	messageDetailsTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		messageDetailsTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		messageDetailsTG.onRemoveRowFocus();
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
						{	id: 'userGroup',
							title: 'User Group',
							width: '100px',
							filterOption: true
						},
						{	id: 'recipientName',
							title: 'Name',
							width: '390px',
							filterOption: true
						},
						{	id: 'cellphoneNo',
							title: 'Cellphone No',
							width: '120px',
							filterOption: true
						},
						{	id: 'statusDesc',
							title: 'Sent',
							width: '75px',
							filterOption: true
						}
						],
			rows: messageDetailsOverlay.rows
		};
		messageDetailsTG = new MyTableGrid(messageDetailsModel);
		messageDetailsTG.pager = messageDetailsOverlay.tableGrid;
		messageDetailsTG.render('messageDetailsTGDiv');
	}catch(e){
		showMessageBox("Error in Message Details Table Grid: " + e, imgMessage.ERROR);
	}
	
	$("btnOk").observe("click", function(){
		messageDetailsOverlay.close();
		delete messageDetailsOverlay;
	});
</script>