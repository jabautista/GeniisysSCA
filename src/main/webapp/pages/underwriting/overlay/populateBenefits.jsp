<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="popPopulateBenefits" class="sectionDiv" style="display: block;  background-color:white; width: 597px; height: 265px;">
	<div style="width: 370px; float: left;">
		<div id="populateBenefitsTable" name="populateBenefitsTable" style="width : 350px;">
			<div id="populateBenefitsTableGridSectionDiv" class="">
				<div id="populateBenefitsTableGridDiv" style="padding: 10px;">
					<div id="populateBenefitsTableGrid" style="height: 198px; width: 350px;"></div>
				</div>
			</div>	
		</div>
	</div>
	
	<div id="subButtonDiv" style="display: block; border : 1px solid gray; width: 200px; float: left; margin : 15px 10px 10px 10px;">
		<input type="hidden" id="command" name="command" value="${command}" />
		<input type="hidden" id="selectedGroupedItemNo"	name="selectedGroupedItemNo" value="${selectedGroupedItemNo}" />
		<input type="hidden" id="popChecker" name="popChecker" value="${popChecker}" />
		
		<table border="0" style="float : left; margin-top: 5px;">
			<tr>
				<td style="padding : 5px;">
					<input type="radio" id="radioSelectGroupedItems" name="radioGroupedItems" value="1" style="margin-left: 5px;" />
				</td>
				<td class="leftAligned">Selected Grouped Items</td>
			</tr>
			<tr>
				<td style="padding : 5px;">
					<input type="radio" id="radioAllGroupedItems" name="radioGroupedItems" value="2" style="margin-left: 5px;" />
				</td>
				<td class="leftAligned">All Grouped Items</td>
			</tr>			
		</table>
		
		<div style="width: 100%; float : left;">
			<table align="center" style="margin-top:10px; margin-bottom:10px;">
				<tr>
					<td>
						<input type="button" class="button"	id="btnOkPopBenefits" 	    name="btnOkPopBenefits"		value="OK"		style="width: 70px" />
						<input type="button" class="button"	id="btnCancelPopBenefits" 	name="btnCancelPopBenefits" value="Cancel" 	style="width: 70px" />
					</td>
				</tr>
			</table>
		</div>			
	 </div>
	
</div>

<script type="text/javascript">
try{
	var objPopBenGrpItems = [];
	var objPopulateBenefits = JSON.parse('${groupedItems}');
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
	
	var tbPopulateBenefits = {
		url : contextPath + "/GIPIWAccidentItemController?action=showPopulateBenefits&parId="+parId+"&itemNo="+$F("itemNo")+
				"&command=Copy&selectedGroupedItemNo="+$F("groupedItemNo")+
				"&notIn=(" + $F("groupedItemNo") + ")&popChecker=N&refresh=1", //marco - 05.23.2013 - added value for URL
		options : {
			width : '360px',
			pager : {}			
		},
		columnModel : [
			{
				id : 'recordStatus',
				width : '23px',
				editor : 'checkbox',
				align : 'center',				
				editable : true,
				visible : true,
				editor: new MyTableGrid.CellCheckbox({					  	
					getValueOf: function(value){		            		
						return value ? "Y" : "N";						
	            	},
	            	onClick : function(value, checked){
	            		var allCheck = true;
	            		
	            		for(var i=0, length=tbgPopulateBenefits.rows.length; i < length; i++){	            			
	        				if(tbgPopulateBenefits.getValueAt(0, i) != "Y"){
	        					allCheck = false;
	        					break;
	        				}
	        			}
	            		
	            		if(allCheck){
	            			$("radioAllGroupedItems").checked = true;
	            		}else{
	            			$("radioSelectGroupedItems").checked = true;
	            		}
	            	}})
			},
			{
				id : 'divCtrId',
				width : '0px',
				visible : false
			},
			{
				id : 'parId',
				width : '0px',
				visible : false
			},
			{
				id : 'itemNo',
				width : '0px',
				visible : false
			},
			{
				id : 'lineCd',
				width : '0px',
				visible : false
			},
			{
				id : 'packBenCd',
				width : '0px',
				visible : false
			},
			{
				id : 'groupedItemNo',
				width : '50px',
				visible : true,
				sortable : true,
				filterOption : true
			},
			{
				id : 'groupedItemTitle',
				width : '258px',				
				sortable : true,
				filterOption : true
			}
		               ],
		rows : objPopulateBenefits.rows,
		id : 21
	};
	
	tbgPopulateBenefits = new MyTableGrid(tbPopulateBenefits);
	tbgPopulateBenefits.pager = objPopulateBenefits;
	tbgPopulateBenefits._mtgId = 21;
	tbgPopulateBenefits.render('populateBenefitsTableGrid');
	tbgPopulateBenefits.afterRender = function(){		
		objPopBenGrpItems = objPopulateBenefits.gipiWGroupedItems.slice(0);		
		
		for(var i=0, length=tbgPopulateBenefits.rows.length; i < length; i++){			
			tbgPopulateBenefits.setValueAt("Y", tbgPopulateBenefits.getColumnIndex("recordStatus"), i, true);			
		}
	};
	
	$("radioSelectGroupedItems").observe("click", function(){
		for(var i=0, length=tbgPopulateBenefits.rows.length; i < length; i++){
			tbgPopulateBenefits.setValueAt("N", 0, i, true); 
		}
	});
	
	$("radioAllGroupedItems").observe("click", function(){
		for(var i=0, length=tbgPopulateBenefits.rows.length; i < length; i++){
			tbgPopulateBenefits.setValueAt("Y", 0, i, true); 
		}
	});
	
	$("btnCancelPopBenefits").observe("click", function(){
		overlayAccidentPopulateBenefits.close();
	});
	
	$("btnOkPopBenefits").observe("click", function(){		
		var groupedItemList = [];		
		var groupedItemNo;
		var lineCd;
		var packBenCd;		
		
		if($("radioAllGroupedItems").checked){
			for(var i=0, length=objPopBenGrpItems.length; i<length; i++){
				groupedItemNo = objPopBenGrpItems[i].groupedItemNo;
				lineCd = objPopBenGrpItems[i].lineCd;
				packBenCd = objPopBenGrpItems[i].packBenCd;
				
				groupedItemList.push({"parId" : parId, "itemNo" : $F("itemNo"), "groupedItemNo" : groupedItemNo,
					"lineCd" : nvl(lineCd, objUWParList.lineCd), "packBenCd" : packBenCd});
			}			
		}else{
			for(var i=0, length=tbgPopulateBenefits.rows.length; i < length; i++){
				groupedItemNo = tbgPopulateBenefits.getValueAt(tbgPopulateBenefits.getColumnIndex("groupedItemNo"), i);
				lineCd = tbgPopulateBenefits.getValueAt(tbgPopulateBenefits.getColumnIndex("lineCd"), i);
				packBenCd = tbgPopulateBenefits.getValueAt(tbgPopulateBenefits.getColumnIndex("packBenCd"), i);
				
				if(tbgPopulateBenefits.getValueAt(tbgPopulateBenefits.getColumnIndex("recordStatus"), i) == "Y"){
					groupedItemList.push({"parId" : parId, "itemNo" : $F("itemNo"), "groupedItemNo" : groupedItemNo,
						"lineCd" : nvl(lineCd, objUWParList.lineCd), "packBenCd" : packBenCd});	
				}								
			}
		}		
		
		if(groupedItemList.length < 1){
			showWaitingMessageBox("Benefits successfully " + ($F("command").toUpperCase() == "COPY" ? "copied" : "deleted") + ".", imgMessage.INFO, function(){
				overlayAccidentPopulateBenefits.close();
			});
		}else{
		
			var setItemRows = getAddedAndModifiedJSONObjects(objGIPIWItem);
				
			new Ajax.Request(contextPath + "/GIPIWAccidentItemController?action=populateBenefits",{
				method : "POST",
				parameters : {
					parameters : prepareJsonAsParameter(groupedItemList),
					parId : parId,
					selectedGroupedItemNo : $F("selectedGroupedItemNo"),
					popChecker : $F("popChecker"),
					delBenSw : ($F("command").toUpperCase() == "COPY" ? "N" : "Y"),
					lineCd:  objUWParList.lineCd,
					issCd: objUWParList.issCd,
					setItemRows : prepareJsonAsParameter(setItemRows)
				},
				evalScripts : true,
				asynchronous : false,
				onCreate : function(){
					showNotice("Populating benefits, please wait...");
				},
				onComplete : function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						showWaitingMessageBox("Benefits successfully " + ($F("command").toUpperCase() == "COPY" ? "copied" : "deleted") + ".", imgMessage.INFO, 
							function(){
								overlayAccidentPopulateBenefits.close();
								overlayGroupedItems.close();
								showItemInfo();
						});
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});				
		}		
	});
	
	$("radioAllGroupedItems").checked = true;	
}catch(e){
	showErrorMessage("Populate Benefits Page", e);
}
</script>