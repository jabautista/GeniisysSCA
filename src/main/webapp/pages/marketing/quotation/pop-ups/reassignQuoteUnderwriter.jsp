<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="lovReassignUnderwriter" style="float: left; width: 450px; margin-top: 5px;">
	<table style="margin-bottom: 2px;">
		<tr>
			<td class="rightAlinged">Keyword</td>
			<td class="leftAligned"><input type="text" id="txtUnderwriterKeyword" name="txtUnderwriterKeyword"/></td>
			<td class="leftAligned"><input type="button" class="button" id="btnSearchUnderwriter" value="Search" style="margin-left: 5px;"/></td>
		</tr>
	</table>
	<div id="lovUnderwriterDiv" style="float: left; width: 100%;">
		<div id="lovUnderwriterTableDiv">
			<div id="lovUnderwriterTable" style="width: 450px; height: 220px;"></div>
		</div>
	</div>
	<div style="margin-top: 10px; width: 100%; float: left; align: center;">
		<input type="button" class="button" id="btnOk" value="Ok" />
		<input type="button" class="button" id="btnCancel" value="Cancel" />
	</div>
</div>
<script type="text/javascript">
	var underwriterSelectedIndex = 0;
	
	function updateListByReassign(){
		try{
			var row = tbgUnderwriter.geniisysRows[underwriterSelectedIndex];
			
			quotationTableGrid.setValueAt(row.userId, quotationTableGrid.getColumnIndex("userId"), selectedQuoteListingIndex, true);		
			quotationTableGrid.geniisysRows[selectedQuoteListingIndex].userId = row.userId;
			
			if((objGIPIQuoteArr.filter(function(obj){ return obj.quoteId == quotationTableGrid.geniisysRows[selectedQuoteListingIndex].quoteId;	})).length > 0){
				for(var i=0, length=objGIPIQuoteArr.length; i < length; i++){
					if(objGIPIQuoteArr[i].quoteId == quotationTableGrid.geniisysRows[selectedQuoteListingIndex].quoteId){
						objGIPIQuoteArr.splice(i, 1, quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);
					}
				}
			}else{
				objGIPIQuoteArr.push(quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);
			}
			changeTag = 1;
			quotationTableGrid.modifiedRows.push(quotationTableGrid.geniisysRows[selectedQuoteListingIndex]);			
		}catch(e){
			showErrorMessage("updateListByReassign", e);
		}
	}
	
	$("btnCancel").observe("click", function(){
		lovUnderwriter.close();
	});
	
	$("btnOk").observe("click", function(){
		updateListByReassign();
		lovUnderwriter.close();
	});
	
	$("txtUnderwriterKeyword").observe("keypress", function(event){
		if(event.keyCode == 13){
			tbgUnderwriter.request.keyword = $F("txtUnderwriterKeyword");
			tbgUnderwriter._retrieveDataFromUrl.call(tbgUnderwriter, 1);
		}
	});
	
	$("btnSearchUnderwriter").observe("click", function(){
		tbgUnderwriter.request.keyword = $F("txtUnderwriterKeyword");
		tbgUnderwriter._retrieveDataFromUrl.call(tbgUnderwriter, 1);
	});
	
	var objUnderwriters = JSON.parse('${underwriters}'.replace(/\\/g, "\\\\"));
	
	var underwriterTable = {
		url : contextPath + "/GIISUserController?action=showUnderwriterForReassignQuote&refresh=1",
		options : {
			width : '458px',
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var mtgId = tbgUnderwriter._mtgId;
				underwriterSelectedIndex = -1;
				if($('mtgRow' + mtgId + '_' + y).hasClassName("selectedRow")){
					underwriterSelectedIndex = y;
				}
			},
			onRowDoubleClick : function(y){
				var row = tbgUnderwriter.geniisysRows[y];
				updateListByReassign();
				lovUnderwriter.close();
			}
		},
		columnModel : [
           	{
           		id : 'recordStatus',
           		title : '',
           		width : '0',
           		visible : false
           	},
           	{
           		id : 'divCtrId',
           		width : '0',
           		visible : false
           	},
           	{
           		id : 'userId',
           		title : 'Underwriter',
           		width : '150px',
           		filterOption : true
           	},
           	{
           		id : 'userGrp',
           		title : 'User Group',
           		width : '150px'
           	},
           	{
           		id : 'username',
           		title : 'User Name',
           		width : '150px'
           	}],
          rows : objUnderwriters.rows
	};
	
	tbgUnderwriter = new MyTableGrid(underwriterTable);
	tbgUnderwriter.pager = objUnderwriters;
	tbgUnderwriter.render("lovUnderwriterTable");
</script>
