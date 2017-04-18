<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="dcbBranchesDiv" style="margin: 20px;">
	<form id="selectBranchForm" name="selectBranchForm">
		<div id="branchListDiv"">
			<div id="branchTableHeader" class="tableHeader" align="center"">
				<label style="text-align: left; margin-left: 3px;">Company</label>
				<label style="text-align: left; margin-left: 48%;">Branch</label>
			</div>
			<div id="branchTableDiv" name="branchTableDiv" style="min-height: 200px; max-height: 240px;" class="tableContainer"></div>
		</div>
	</form>
	<div class="buttonsDiv" style="float:left; width: 100%; margin-bottom: 10px;">
		<input id="btnSelectBranch" name="btnSelectBranch" class="button" value="Ok" />
	</div>
</div>

<script type="text/javascript">
	var branchObjArr = JSON.parse('${branchList}'.replace(/\\/g, '\\\\'));
		
	for(var i=0; i<branchObjArr.length; i++) {
		var exists = false;
		$$("div[name='branchRow']").each(function(row) {
			if(row.down("input", 0).value == branchObjArr[i].gfunFundCd
					&& row.down("input", 1).value == branchObjArr[i].branchCd) {
				exists = true;
			}
		});	
		if(!exists) {
			
		}
		var content = prepareDCBBranchList(branchObjArr[i]);
		
		var newRow = new Element("div");
		newRow.setAttribute("id", "branchRow"+branchObjArr[i].gfunFundCd+branchObjArr[i].branchCd);
		newRow.setAttribute("name", "branchRow");
		newRow.addClassName("tableRow");
		newRow.setStyle({fontSize: '10px'});	

		newRow.update(content);
		$("branchTableDiv").insert({bottom : newRow});	

		checkIfToResizeTable("branchTableDiv", "branchRow");
		checkTableIfEmpty("branchRow", "branchListDiv");
	}

	function prepareDCBBranchList(obj) {
		try {
			var content = '<input type="hidden" id="hidFundCd'+obj.gfunFundCd+'" name="hidFundCd" value="'+obj.gfunFundCd+'" />'
						  +'<input type="hidden" id="hidBranchCd'+obj.branchCd+'" name="hidBranchcd" value="'+obj.branchCd+'" />'
						  +'<label style="text-align: left; margin-left: 3px;">'+obj.gfunFundCd+' - '+obj.fundDesc+'</label>'
						  +'<label style="text-align: left; margin-left: 20%;">'+obj.branchCd+' - '+obj.branchName+'</label>';
			return content;
		} catch(e) {
			showErrorMessage("prepareDCBBranchList", e);
		}
	}

	$$("div[name='branchRow']").each(function(row) {
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});
	
		row.observe("mouseout", function(){
			row.removeClassName("lightblue");
		});

		row.observe("dblclick", function() {
			loadSelectedBranch(row);
		});

		row.observe("click", function() {
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")) {
				$$("div[name='branchRow']").each(function(r) {
					if(row.getAttribute("id") != r.getAttribute("id")) {
						r.removeClassName("selectedRow");
					}
				});
			}
		});
		
	});

	function loadSelectedBranch(row) {
		try {
			if(row != null) {
				var dcbFlag = $F("curDCBFlag");
				var fundCd = row.down("input", 0).value;
				var  branchCd = row.down("input", 1).value;
				var txtCompany = row.down("label", 0).innerHTML;
				var txtBranch = row.down("label", 1).innerHTML;
				loadFilteredDCBNoMaintenance(fundCd, branchCd, dcbFlag, txtCompany, txtBranch, "Yes");
			}
			hideOverlay();
			
		} catch(e) {
			showErrorMessage("loadSelectedBranch", e);
		}
	}

	$("btnSelectBranch").observe("click", function() {
		var exist = false;
		var tempRow = "";
		$$("div[name='branchRow']").each(function(row) {
			if(row.hasClassName("selectedRow")) {
				exist = true;
				tempRow = row;
			}
		});
		if(exist) {
			loadSelectedBranch(tempRow);
		} else {
			hideOverlay();
		}
	});
</script>