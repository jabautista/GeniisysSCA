<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="tableHeader" style="width: 100%;">
	<label style="text-align: left; width: 100px; margin-left: 30px;">Subline Cd</label>
	<label style="text-align: left; width: 100px; margin-left: 10px;">Iss Cd</label>
	<label style="text-align: left; width: 100px; margin-left: 10px;">Issue YY</label>
	<label style="text-align: left; width: 100px; margin-left: 10px;">Pol Seq No</label>
	<label style="text-align: left; width: 100px; margin-left: 10px;">Renew No</label>
</div>
<div id="policyNoTable" name="policyNoTable" class="tableContainer">
	<c:forEach var="policy" items="${policies}">
		<div id="polRow${policy.policyId}" name="polRow" style="width: 99%; height: 18px;" class="tableRow">
<!-- 					<input type="hidden" id="polId${policy.policyId}" name="polId" value="${policy.policyId}" />  -->
			<input type="hidden" id="subline${policy.policyId}" name="subline" value="${policy.sublineCd}" />
			<input type="hidden" id="issCd${policy.policyId}" name="issCd" value="${policy.issCd}" />
			<input type="hidden" id="issueYY${policy.policyId}" name="issueYY" value="${policy.issueYy}" />
			<input type="hidden" id="polSeq${policy.policyId}" name="polSeq" value="${policy.polSeqNo}" />
			<input type="hidden" id="renew${policy.policyId}" name="renew" value="${policy.renewNo}" />
			
			<label style="text-align: left; width: 100px; margin-left: 30px;" title="">${policy.sublineCd}</label>
			<label style="text-align: left; width: 100px; margin-left: 10px;" title="">${policy.issCd}</label>
			<label style="text-align: left; width: 100px; margin-left: 10px;" title=""><fmt:formatNumber value='${policy.issueYy}' pattern='00' /></label>
			<label style="text-align: left; width: 100px; margin-left: 10px;" title=""><fmt:formatNumber value='${policy.polSeqNo}' pattern='0000000' /></label>
			<label style="text-align: left; width: 100px; margin-left: 10px;" title=""><fmt:formatNumber value='${policy.renewNo}' pattern='00' /></label>
		</div>
	</c:forEach>
</div>

<div style="display: block; border: none; height: 20px;">
	<div class="polPager" id="polPager">
		<c:if test="${noOfPolPages gt 1}">
			<div align="right">
			Page:
				<select id="polPage" name="polPage">
					<c:forEach var="j" begin="1" end="${noOfPolPages}" varStatus="status">
						<option value="${j}"
							<c:if test="${polPageNo eq j}">
								selected="selected"
							</c:if>
						>${j}</option>
					</c:forEach>
				</select> of ${noOfPolPages}
			</div>
			<script>
				//positionPageDiv();
				var size = $$("div[name='row']").size();
				$$("div[name='row']").each(function (row) {
					if (!row.visible()) {
						size--;
					}
				});
				var margin = 310 - (size*30);
				$("polPager").setStyle("margin-top: "+margin+"px;");
			</script>
		</c:if>
	</div>
</div>	

<script type="text/javascript">
	$("searchEntry").observe("click", function() {
		$("keywordPol").value = $("keywordPol").value;
		if ($("isPack") == null) {
			controller = "GIPIPolbasicController";
			action = "filterPolicyForEndt";
		} else if ($F("isPack") == "Y") {
			controller = "GIPIPackPolbasicController";
			action = "filterPolicyForPackEndt";
		} else {
			controller = "GIPIPolbasicController";
			action = "filterPolicyForEndt";
		}
		
		goToPolicyPageNo("policyNoListingDiv","/"+controller+"?"+Form.serialize("selectPolicyForm"),action, 1);	
	});
	
	$("keywordPol").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			$("keywordPol").value = $("keywordPol").value;
	
			if ($("isPack") == null) {
				controller = "GIPIPolbasicController";
				action = "filterPolicyForEndt";
			} else if ($F("isPack") == "Y") {
				controller = "GIPIPackPolbasicController";
				action = "filterPolicyForPackEndt";
			} else {
				controller = "GIPIPolbasicController";
				action = "filterPolicyForEndt";
			}
			
			goToPolicyPageNo("policyNoListingDiv","/"+controller+"?"+Form.serialize("selectPolicyForm"),action, 1);
		}
	});
	
	if (!$("polPager").innerHTML.blank()) {
		try {
			if ($("isPack") == null) {
				controller = "GIPIPolbasicController";
				action = "filterPolicyForEndt";
			} else if ($F("isPack") == "Y") {
				controller = "GIPIPackPolbasicController";
				action = "filterPolicyForPackEndt";
			} else {
				controller = "GIPIPolbasicController";
				action = "filterPolicyForEndt";
			}
			
			initializePolPagination("policyNoListingDiv","/"+controller+"?"+Form.serialize("selectPolicyForm"),action);
		} catch (e) {
			showErrorMessage("selectPolicyNoTable.jsp - polPager", e);
			//showMessageBox(e.message);
		}
	}
	
	$$("div[name=polRow]").each(function(row) {
		 loadRowMouseOverMouseOutObserver(row);
	
		row.observe("click", function() {
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")) {
				try {
					($$("div#policyNoTable div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
					
					$("selectedSubline").value = row.down("input", 0).value;
					$("selectedIssCd").value = row.down("input", 1).value;
					$("selectedIssueYy").value = row.down("input", 2).value;
					$("selectedPolSeq").value = row.down("input", 3).value;
					$("selectedRenewNo").value = row.down("input", 4).value;
					valPolicy=1;
				} catch(e) {
					showErrorMessage("selectPolicyNoTable.jsp - row.observe(click, function()", e);
				}
			}
		});
	
	});
	
	function initializePolPagination(tableId, url, action) {
		try {
		$("polPager").down("select", 0).observe("change", function () {
			var polPageNo = $("polPager").down("select", 0).value;
			goToPolicyPageNo(tableId, url, action, polPageNo);
		});
		} catch (e) {
			showErrorMessage("initializePolPagination", e);
			//showMessageBox("initializePolPagination: " + e.message);
		}
	}
	
	$("polPager").setStyle("margin-top: 10px;");
	
	function goToPolicyPageNo(listingTableId, url, action, pageNo) {
		try {
			new Ajax.Updater(listingTableId, contextPath+url, {
				method: "GET",
				evalScripts: true,
				asynchronous: true,
				parameters: {
					polPageNo: pageNo,
					keywordPol: $F("keywordPol"),
					action: action,
					ajax: 1
				},
				onCreate: function () {
					if (!(Object.isUndefined($("searchPolSpan")))) {
						fadeElement("searchPolSpan", .3, null);
						//showMessageBox($F("keywordPol"));
					}
					Effect.Fade($(listingTableId).down("div", 0), {
						duration: .001,
						afterFinish: function () {
							showLoading(listingTableId, "Getting list, please wait...", "10px");
						}
					});
				},
				onComplete: function (response) {
					//hideNotice();
					if (checkErrorOnResponse(response)) {
						Effect.Appear($(listingTableId).down("div", 0), {
							duration: .001,
							afterFinish: function () {
								var marRight = parseInt((screen.width - mainContainerWidth)/2);
								$("searchPolSpan").setStyle("right: " + marRight + "px; top: 105px;");
							}
						});
					} else {
						$(listingTableId).update("<div style='align: center; margin-top: 100px;'>Failed to load records. Please contact your adminstrator.</div>");
					}
				}
			});
		} catch (e) {
			showErrorMessage("goToPolicyPageNo", e);
			//showMessageBox("goToPolicyPageNo: " + e.message, "info");
		}
	}	
	
	$$("div[name=polRow]").each(function(row) {
		row.observe("dblclick", function() {
			loadSelected();
		});
	});

</script>
