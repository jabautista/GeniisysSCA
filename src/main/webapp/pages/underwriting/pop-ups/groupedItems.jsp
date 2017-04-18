<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/subPages/groupedItemsListing.jsp"></jsp:include>
	<table align="center" width="520px;" border="0">
		<tr>
			<td class="rightAligned" style="width:120px;">Grouped Item Title </td>
			<td class="leftAligned" >
				<input id="groupedItemNo" name="groupedItemNo" type="hidden" style="width: 220px;" maxlength="6" readonly="readonly"/>
				<input id="groupedItemTitle" name="groupedItemTitle" type="text" style="width: 220px;" maxlength="50" class="required"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" >Amount Covered </td>
			<td class="leftAligned" >
				<input id="amountCovered" name="amountCovered" type="text" style="width: 220px;" maxlength="18" class="money"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Group</td>
			<td class="leftAligned">
				<select id="groupItemCd" name="groupItemCd" style="width: 228px;">
					<option value=""></option>
					<c:forEach var="groupCdList" items="${groupListing}">
						<option value="${groupCdList.groupCd}">${groupCdList.groupDesc}</option>				
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks </td>
			<td class="leftAligned" >
				<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" rows="2" cols="1" style="width: 357px;" id="remarks" name="remarks"></textarea>
			</td>
		</tr>	
		<tr>
			<td>
				<input id="includeTag" name="includeTag" type="hidden" style="width: 220px;" value="Y" maxlength="1" readonly="readonly"/>
				<input id="nextItemNo" name="nextItemNo" type="hidden" style="width: 220px;" value="" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<table align="center">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddGroupedItems" 	name="btnAddGroupedItems" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeleteGroupedItems" 	name="btnDeleteGroupedItems" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
	
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	$("amountCovered").observe("blur", function() {
		if (parseFloat($F('amountCovered').replace(/,/g, "")) < -99999999999999.99) {
			showMessageBox("Entered Amount Covered is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR);
			$("amountCovered").focus();
			$("amountCovered").value = "";
		} else if (parseFloat($F('amountCovered').replace(/,/g, "")) >  99999999999999.99){
			showMessageBox("Entered Amount Covered is invalid. Valid value is from -99,999,999,999,999.99 to 99,999,999,999,999.99.", imgMessage.ERROR);
			$("amountCovered").focus();
			$("amountCovered").value = "";
		}		
	});

	$("btnAddGroupedItems").observe("click", function() {
		if(checkIfItemExists($F("itemNo"))){
			addGroupedItems();
		} else{
			return false;
		}		
	});
	
	$$("div[name='grpItem']").each(
			function (acc)	{
				acc.observe("mouseover", function ()	{
					acc.addClassName("lightblue");
				});
				
				acc.observe("mouseout", function ()	{
					acc.removeClassName("lightblue");
				});

				acc.observe("click", function ()	{
					acc.toggleClassName("selectedRow");
					if (acc.hasClassName("selectedRow"))	{
						$$("div[name='grpItem']").each(function (li)	{
							if (acc.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});
						var groupedItemNo = acc.down("input",2).value;	
						var groupedItemTitle = acc.down("input",3).value;	
						var amountCovered = acc.down("input",4).value;	
						var groupItemCd = acc.down("input",5).value;		
						var remarks = acc.down("input",6).value;	
						var includeTag = acc.down("input",7).value;	
						$("groupedItemNo").value = groupedItemNo;
						$("groupedItemTitle").value = groupedItemTitle;
						$("amountCovered").value = amountCovered == "" ? "" :formatCurrency(amountCovered);
						$("groupItemCd").value = groupItemCd;
						$("remarks").value = remarks;
						$("includeTag").value = includeTag;
						getDefaults();
					} else {
						clearForm();
					}
				}); 
				
			}	
	);	

	function addGroupedItems() {	
		try	{
			var gParId = $F("globalParId");
			var gItemNo = $F("itemNo");
			var gGroupedItemNo = $("groupedItemNo").value;
			var gGroupedItemTitle = changeSingleAndDoubleQuotes2($("groupedItemTitle").value);
			var gAmountCovered = $("amountCovered").value == "" ? "" :$("amountCovered").value;
			var gGroupItemCd = $("groupItemCd").value;
			var gRemarks = changeSingleAndDoubleQuotes2($("remarks").value);
			var gIncludeTag = $("includeTag").value;
			var gGroupDesc = changeSingleAndDoubleQuotes2((gGroupItemCd =="" ? "" :$("groupItemCd").options[$("groupItemCd").selectedIndex].text));
			var exists = false;
			
			if (gGroupedItemNo == "" || gGroupedItemTitle == "") {
				showMessageBox("Please complete fields.", imgMessage.ERROR);
				exists = true;
			}
			
			$$("div[name='grpItem']").each( function(a)	{
				if (a.getAttribute("groupedItemNo") == gGroupedItemNo && a.getAttribute("item") == gItemNo && $F("btnAddGroupedItems") != "Update")	{
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
				} else if (a.getAttribute("groupedItemTitle") == gGroupedItemTitle && $F("btnAddGroupedItems") != "Update"){
					exists = true;
					showMessageBox("Grouped Item Title must be unique.", imgMessage.ERROR);
				}	
			});

			hideNotice("");

			if (!exists)	{
				var content = '<input type="hidden" id="gParIds" 		     name="gParIds" 	        value="'+gParId+'" />'+
			 	  			  '<input type="hidden" id="gItemNos" 		     name="gItemNos" 	        value="'+gItemNo+'" />'+ 
							  '<input type="hidden" id="gGroupedItemNos"     name="gGroupedItemNos"     value="'+gGroupedItemNo+'" />'+ 
						 	  '<input type="hidden" id="gGroupedItemTitles"  name="gGroupedItemTitles"  value="'+gGroupedItemTitle+'" />'+  
						 	  '<input type="hidden" id="gAmountCovereds" 	 name="gAmountCovereds" 	value="'+gAmountCovered+'" class="money" />'+ 
						 	  '<input type="hidden" id="gGroupItemCds" 		 name="gGroupItemCds" 		value="'+gGroupItemCd+'" />'+ 
						 	  '<input type="hidden" id="gRemarkss" 			 name="gRemarkss" 			value="'+gRemarks+'" />'+ 
						 	  '<input type="hidden" id="gIncludeTags"   	 name="gIncludeTags"  		value="'+gIncludeTag+'" />'+
						 	  '<input type="hidden" id="gGroupDescs"  		 name="gGroupDescs" 		value="'+gGroupDesc+'" />'+
						 	  '<label name="textGroupItem" style="width: 25%; margin-right: 10px;" for="grp'+gGroupedItemTitle+'">'+gGroupedItemTitle.truncate(22, "...")+'</label>'+
						 	  '<label name="textGroupItem" style="width: 20%; margin-right: 10px;" for="grp'+gGroupDesc+'">'+(gGroupDesc == "" ? "---" :gGroupDesc.truncate(22, "..."))+'</label>'+
							  '<label name="textGroupItem" style="width: 25%; margin-right: 7px;" for="grp'+gRemarks+'">'+(gRemarks == "" ? "---" :gRemarks.truncate(22, "..."))+'</label>'+
							  '<label name="textGroupItem" style="width: 26%; text-align: right; " class="money" for="grp'+gAmountCovered+'">'+(gAmountCovered == "" ? "---" :gAmountCovered.truncate(22, "..."))+'</label>'; 
							  			   
				if ($F("btnAddGroupedItems") == "Update") {	 				 
					$("rowGroupedItems"+gItemNo+gGroupedItemNo).update(content);					
					updateTempGroupItemsItemNos();
				} else {
					var newDiv = new Element('div');
					newDiv.setAttribute("name","grpItem");
					newDiv.setAttribute("id","rowGroupedItems"+gItemNo+gGroupedItemNo);
					newDiv.setAttribute("item",gItemNo);
					newDiv.setAttribute("groupedItemNo",gGroupedItemNo); 
					newDiv.setAttribute("groupedItemTitle",gGroupedItemTitle); 
					newDiv.addClassName("tableRow");
  
					newDiv.update(content);
					$('groupedItemsListing').insert({bottom: newDiv});
							 
					newDiv.observe("mouseover", function ()	{
						newDiv.addClassName("lightblue");
					});
					
					newDiv.observe("mouseout", function ()	{
						newDiv.removeClassName("lightblue");
					});
					
					newDiv.observe("click", function ()	{	
						newDiv.toggleClassName("selectedRow");
						if (newDiv.hasClassName("selectedRow"))	{
							$$("div[name='grpItem']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});
							var groupedItemNo = newDiv.down("input",2).value;	
							var groupedItemTitle = newDiv.down("input",3).value;	
							var amountCovered = newDiv.down("input",4).value;	
							var groupItemCds = newDiv.down("input",5).value;		
							var remarks = newDiv.down("input",6).value;	
							var includeTag = newDiv.down("input",7).value;	
							$("groupedItemNo").value = groupedItemNo;
							$("groupedItemTitle").value = groupedItemTitle;
							$("amountCovered").value = amountCovered== "" ? "" :formatCurrency(amountCovered);
							$("groupItemCd").value = groupItemCds;
							$("remarks").value = remarks;
							$("includeTag").value = includeTag;
							getDefaults();
						} else {
							clearForm();
						} 
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditional("groupedItemsTable","groupedItemsListing","grpItem","item",$F("itemNo"));
						}
					});
					updateTempGroupItemsItemNos();
				}
				clearForm();
			}
		} catch (e)	{
			showErrorMessage("addGroupedItems", e);
		}
	}

	$("btnDeleteGroupedItems").observe("click", function() {
		if(checkIfItemExists($F("itemNo"))){
			deleteGroupedItems();
		} else{
			return false;
		}			
	});

	function deleteGroupedItems(){
		$$("div[name='grpItem']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{
						var itemNo		    = $F("itemNo");
						var gGroupedItemNo	= $F("groupedItemNo");
						var listingDiv 	    = $("groupedItemsListing");
						var newDiv 		    = new Element("div");
						newDiv.setAttribute("id", "row"+itemNo+gGroupedItemNo); 
						newDiv.setAttribute("name", "rowDelete"); 
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display : none");
						newDiv.update(										
							'<input type="hidden" name="delGroupItemsItemNos" 	value="'+itemNo+'" />' +
							'<input type="hidden" name="delGroupedItemNos" 	value="'+gGroupedItemNo+'" />');
						listingDiv.insert({bottom : newDiv});
						updateTempGroupItemsItemNos();
						acc.remove();
						clearForm();
						checkTableItemInfoAdditional("groupedItemsTable","groupedItemsListing","grpItem","item",$F("itemNo"));
					} 
				});
			}
		});
	}	
	
	function getDefaults()	{
		$("btnAddGroupedItems").value = "Update";
		enableButton("btnDeleteGroupedItems");
	}

	function clearForm()	{
		generateSequenceItemInfo("grpItem","groupedItemNo","item",$F("itemNo"),"nextItemNo");
		$("groupedItemTitle").value = "";
		$("groupItemCd").selectedIndex = 0;
		$("amountCovered").value = "";
		$("remarks").value = "";
		$("includeTag").value = "Y";
		
		$("btnAddGroupedItems").value = "Add";
		disableButton("btnDeleteGroupedItems");
		$$("div[name='grpItem']").each(function (div) {
			div.removeClassName("selectedRow");
		});
		checkTableItemInfoAdditional("groupedItemsTable","groupedItemsListing","grpItem","item",$F("itemNo"));
		computeTotalAmountInTable("groupedItemsTable","grpItem",4,"item",$F("itemNo"),"groupedItemsTotalAmtDiv");
	}

	function updateTempGroupItemsItemNos(){
		var temp = $F("tempGroupItemsItemNos").blank() ? "" : $F("tempGroupItemsItemNos");
		$("tempGroupItemsItemNos").value = temp + $F("itemNo") + " ";
	}
	
	generateSequenceItemInfo("grpItem","groupedItemNo","item",$F("itemNo"),"nextItemNo");
	checkTableItemInfoAdditional("groupedItemsTable","groupedItemsListing","grpItem","item",$F("itemNo"));
</script>	