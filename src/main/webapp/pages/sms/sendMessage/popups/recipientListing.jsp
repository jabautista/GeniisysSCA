<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="recipientListingMainDiv" class="sectionDiv" style="margin: 5px 0 0 0; width: 682px;">
	<div id="recipientListingTGDiv" style="height: 330px; margin: 10px;">
	
	</div>
	
	<div id="controlDiv" style="float: left; margin: 0 0 10px 17px;">
		<input id="checkAll" name="checkAll" type="checkbox" tabindex="106" style="float: left; margin: 4px 3px 0 0;" tabindex="201">
		<label for="checkAll" style="float: left; padding-top: 4px; margin-right: 170px;">Check All</label>
		
		<input id="btnOverlayOk" type="button" class="button" value="Ok" style="width: 80px;" tabindex="202">
		<input id="btnOverlayCancel" type="button" class="button" value="Cancel" style="width: 80px;" tabindex="203">
	</div>
</div>

<script type="text/javascript">
	recipientOverlay.recipientTG = JSON.parse('${recipientJSON}');
	recipientOverlay.recipientRows = recipientOverlay.recipientTG.rows || [];
	
	try{
		var bdaySw = $("bdayMsg").checked ? "Y" : "N";
		var chkDefault = $("chkDefault").checked ? "Y" : "N";
		var chkGlobe = $("chkGlobe").checked ? "Y" : "N";
		var chkSmart = $("chkSmart").checked ? "Y" : "N";
		var chkSun = $("chkSun").checked ? "Y" : "N";
		
		var recipientTGModel = {
			url: contextPath+"/GISMMessagesSentController?action=showRecipientOverlay&refresh=1"+
					"&groupCd="+$F("groupCd")+
					"&bdaySw="+bdaySw+
					"&fromDate="+$F("fromDate")+
					"&toDate="+$F("toDate")+
					"&chkDefault="+chkDefault+
					"&chkGlobe="+chkGlobe+
					"&chkSmart="+chkSmart+
					"&chkSun="+chkSun,
			options: {
				id : 3,
	          	height: '306px',
	          	width: '661px',
	          	onCellFocus: function(element, value, x, y, id){
	          		recipientTG.keys.removeFocus(recipientTG.keys._nCurrentFocus, true);
	          		recipientTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	recipientTG.keys.removeFocus(recipientTG.keys._nCurrentFocus, true);
	            	recipientTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	recipientTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		recipientTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		recipientTG.onRemoveRowFocus();
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
						{	id: 'include',
							title: '',
			            	width: '23px',
			            	altTitle: 'Include',
			            	titleAlign: 'center',
			            	sortable: false,
			            	editable: true,
			            	hideSelectAllBox: true,
			            	editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
				            		return value ? "Y" : "N";
				            	}
			            	})
						},
						{	id: 'recipientName',
							title: 'Recipient Name',
							width: '501px',
							filterOption: true
						},
						{	id: 'cellphoneNo',
							title: 'Cellphone No.',
							width: '125px',
							filterOption: true
						}
						],
			rows: recipientOverlay.recipientRows
		};
		recipientTG = new MyTableGrid(recipientTGModel);
		recipientTG.pager = recipientOverlay.recipientTG;
		recipientTG._mtgId = 3;
		recipientTG.render('recipientListingTGDiv');
	}catch(e){
		showMessageBox("Error in Recipient Table Grid: " + e, imgMessage.ERROR);
	}
	
	function checkAll(){
		for(var i = 0; i < recipientTG.geniisysRows.length; i++){
			$("mtgInput"+recipientTG._mtgId+"_"+recipientTG.getColumnIndex("include")+","+i).checked = true;
		}
	}
	
	function countChecked(){
		var count = 0;
		for(var i = 0; i < recipientTG.geniisysRows.length; i++){
			if($("mtgInput"+recipientTG._mtgId+"_"+recipientTG.getColumnIndex("include")+","+i).checked){
				count++;
			}
		}
		return count;
	}
	
	function getSelectedRecords(){
		var selectedRecords = [];
		for(var i = 0; i < recipientTG.geniisysRows.length; i++){
			if($("mtgInput"+recipientTG._mtgId+"_"+recipientTG.getColumnIndex("include")+","+i).checked){
				var record = {};
				record.msgId = nvl(objMsg.selectedRow.msgId, "");
				record.dtlId = "";
				record.statusSw = 'Q';
				record.pkColumnValue = recipientTG.geniisysRows[i].pkColumnValue;
				record.groupCd = $F("groupCd");
				record.groupName = $F("groupName");
				record.recipientName = recipientTG.geniisysRows[i].recipientName;
				record.cellphoneNo = '+639' + (recipientTG.geniisysRows[i].cellphoneNo).substr((recipientTG.geniisysRows[i].cellphoneNo.length)-9,
												(recipientTG.geniisysRows[i].cellphoneNo.length));
				record.recordStatus = 0;
				selectedRecords.push(record);
			}
		}
		return selectedRecords;
	}
	
	function selectRecords(){
		var selectedRecords = getSelectedRecords();
		if(countChecked() == 1){
			$("pkColumnValue").value = selectedRecords[0].pkColumnValue;
			$("recipientName").value = unescapeHTML2(selectedRecords[0].recipientName);
			$("cellphoneNo").value = selectedRecords[0].cellphoneNo;			
		}else if(countChecked() > 1){
			for(var i = 0; i < selectedRecords.length; i++){
				if(nvl(objMsg.messages[objMsg.selectedIndex].details, null) == null){
					objMsg.messages[objMsg.selectedIndex].details = [];
				}
				objMsg.messages[objMsg.selectedIndex].details.push(selectedRecords[i]);
				msgDetailTG.addBottomRow(selectedRecords[i]);
			}
			objMsg.messages[objMsg.selectedIndex].recordStatus = 1;
			msgDetailTG.onRemoveRowFocus();
			changeTag = 1;
		}
	}
	
	$("checkAll").observe("change", function(){
		checkAll();
	});
	
	$("btnOverlayOk").observe("click", function(){
		selectRecords();
		recipientOverlay.close();
		delete recipientOverlay;
	});
	
	$("btnOverlayCancel").observe("click", function(){
		recipientOverlay.close();
		delete recipientOverlay;
	});
</script>