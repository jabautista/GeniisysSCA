<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div style="height: 50px; padding:50px; margin-left: 10px;" align="center">
	<div id="message" style="display:none;">${message}</div>
	<input type="hidden" name="parId" value="${parId}">
	
		<label>Existing Groups:</label>
		<select style="width: 50px;" id="existingItemGroups">
			<c:forEach var="item" items="${items}">
				<option value="<c:if test="${empty item.itemGrp}">1</c:if>
						${fn:escapeXml(item.itemGrp)}">
						<c:if test="${empty item.itemGrp}">1</c:if>
						${fn:escapeXml(item.itemGrp)}</option>
			</c:forEach>
		</select>
	
	<div align="center" style="margin-top: 10px;">
		<input type="button" class="button" id="btnOk" value="Ok">
		<input type="button" class="button" id="btnCancelModal" value="Cancel">
	</div>
</div>
<script type="text/javascript">

	setExistingGroupsLOV();
	
	$("btnCancelModal").observe("click", function(){
		hideExistingGroupsOverlay();
	});

	$("btnOk").observe("click", function(){
		joinGroup();
		hideExistingGroupsOverlay();
	});

	function hideExistingGroupsOverlay(){
		hideOverlay();
		$$("div[name='itemBillGrouping']").each(function(itemGroup){
        	var itemNo= itemGroup.down("label", 1).innerHTML;

    		if($("checkGroup"+itemNo).checked){
        		$("checkGroup"+itemNo).checked = false;
    		}
        });
		$("btnNewGroup").disable();
    	$("btnNewGroup").setAttribute("class", "disabledButton");
    	$("btnJoinGroup").disable();
    	$("btnJoinGroup").setAttribute("class", "disabledButton");
		
	}

	function getLastItemGrpNo(){
    	var lastItemGrpNo = 0;

    	$$("div[name='itemBillGrouping']").each(function(itemGroup){
    		if(parseInt(itemGroup.down("label", 0).innerHTML) > parseInt(lastItemGrpNo)){
        		lastItemGrpNo = parseInt(itemGroup.down("label", 0).innerHTML); 
    		}	
        });
        return lastItemGrpNo;
    };

	function setExistingGroupsLOV(){
		var opt="";
		var lastItemGrpNo = parseInt(getLastItemGrpNo());
		
		$("existingItemGroups").update("");

		for(var i=1; i<=lastItemGrpNo ; i++){
			opt += '<option value="'+i+'">'+i+'</option>';
		}
		
		$("existingItemGroups").insert({bottom : opt});
		$("existingItemGroups").selectedIndex = 0;
	}

	function checkIfSameCurrency(){
		var isSameCurrency = true;
		var selectedGroup = $("existingItemGroups").options[$("existingItemGroups").selectedIndex].value;
		var currencyCd="";
		var currencyRate="";
		
		$$("div[name='itemBillGrouping']").each(function(itemGroup){
			if(selectedGroup == parseInt(itemGroup.down("label", 0).innerHTML)){
				currencyCd = itemGroup.down("label", 5).innerHTML;
				currencyRate = itemGroup.down("label", 6).innerHTML;
			}        	
        });

        $$("div[name='itemBillGrouping']").each(function(item){
        	var itemNo= item.down("label", 1).innerHTML;

    		if($("checkGroup"+itemNo).checked){
        		if(currencyCd != item.down("label", 5).innerHTML){
        			isSameCurrency = false;
        		}else if(currencyRate != item.down("label", 6).innerHTML){
        			isSameCurrency = false;
        		}
    		}
    	});

    	return isSameCurrency;
	}

	function checkIfSamePackLineCd(){
		var isSamePackLineCd = true;
		var selectedGroup = $("existingItemGroups").options[$("existingItemGroups").selectedIndex].value;
		var packLineCd = "";

		$$("div[name='itemBillGrouping']").each(function(itemGroup){
			if(selectedGroup == parseInt(itemGroup.down("label", 0).innerHTML)){
				packLineCd = itemGroup.down("label", 7).innerHTML;
			}        	
        });

        $$("div[name='itemBillGrouping']").each(function(item){
        	var itemNo= item.down("label", 1).innerHTML;

    		if($("checkGroup"+itemNo).checked){
        		if(packLineCd != item.down("label", 7).innerHTML){
        			isSamePackLineCd = false;
        		}
    		}
    	});
        return isSamePackLineCd;
	}

	function countItemsPerItemGroup(itemGroupNo){
    	var ctr = 0;
    	
    	$$("div[name='itemBillGrouping']").each(function(itemGroup){
			if(itemGroupNo == itemGroup.down("label", 0).innerHTML){
				ctr++;
			}        	
        });
        return ctr;
    };

    function checkIfToJoinGroups(){
    	var joinSw = true;
    	var lastItemGrpNo = parseInt(getLastItemGrpNo());
    	
    	$$("div[name='itemBillGrouping']").each(function(itemGroup){
        	var itemNo= itemGroup.down("label", 1).innerHTML;
        	var selectedGroup = $("existingItemGroups").options[$("existingItemGroups").selectedIndex].value;
        	var itemGrpNo = parseInt(itemGroup.down("label", 0).innerHTML);
	
        	if($("checkGroup"+itemNo).checked){
	   			if(countItemsPerItemGroup(itemGroup.down("label", 0).innerHTML) == 1 
	   		   		&& itemGrpNo != lastItemGrpNo && selectedGroup != itemGrpNo){
	       			joinSw = false;
	       			return false;
	   			}
			}

			if(!checkIfSameCurrency()){
				showMessageBox("Only items of the same currency and currency rate"
								+ " may be grouped together as one.");
				joinSw = false;
       			return false;
			}else if(!checkIfSamePackLineCd()){
				showMessageBox("Only items of the same currency , currency rate, "
								+ "package line and package subline may be grouped together as one.");
				joinSw = false;
				return false;
			}
    		
        });
    	return joinSw;
    };

    function joinGroup(){
    	if(checkIfToJoinGroups()){
    		$$("div[name='itemBillGrouping']").each(function(itemGroup){
            	var itemNo= itemGroup.down("label", 1).innerHTML;
            	var selectedGroup = $("existingItemGroups").options[$("existingItemGroups").selectedIndex].value;
            	var origGrpNo = itemGroup.down("label", 0).innerHTML;

        		if($("checkGroup"+itemNo).checked){
            		if(parseInt(origGrpNo) != selectedGroup){
                		var updateGroupItem ='<input type="hidden" name="itemNo" value="'+itemNo+'">' +
						 					 '<input type="hidden" name="itemGrp" value="'+selectedGroup+'">';
						$("hidItems").insert({bottom: updateGroupItem});
						itemGroup.down("label", 0).update(selectedGroup);
						$("saveSw").value = 1;
					}
        		}
            });
                	
     	}else{
    		showMessageBox( "The selected record(s) cannot be added to the specified group " +
    	    				"as such will violate the sequential ordering of the group numbers. " +
    	    				"Please try another set of records.", imgMessage.ERROR);

    		$$("div[name='itemBillGrouping']").each(function(itemGroup){
            	var itemNo= itemGroup.down("label", 1).innerHTML;

        		if($("checkGroup"+itemNo).checked){
            		$("checkGroup"+itemNo).checked = false;
        		}
            });
		}
    };

</script>