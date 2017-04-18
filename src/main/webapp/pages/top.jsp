<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="siteBanner">	
	<div id="siteBanner1" style="width: 100.2%;">		
		<div id="siteBanner2">
			<c:if test="${maintenanceMode eq 'On'}">
				<div style="position: fixed; z-index: 100; margin: 57px 0 0 32px; color: white; font-weight: bold; font-size: 12px;">Maintenance Mode</div>
			</c:if>
			<img id="imgBanner" src="${pageContext.request.contextPath}/images/misc/geniisys-logo-banner.png" style="float: left; height: 70%; margin: 10px 0 20px 0; cursor: pointer;" alt=""/>
			<img src="${pageContext.request.contextPath}/images/banner/${clientBanner}" style="height: 60px; margin: 5px 0 0 35px; float: left;" alt=" "/>
		</div>
	</div>
	<span id="welcomeUserDiv">
		<jsp:include page="welcomeUser.jsp"></jsp:include>
	</span>
</div>
<script type="text/javascript">
	$("imgBanner").observe("click", showAbout);
</script>
<!-- <script>
	$("changeColorTheme").observe("click", function () {
		Effect.toggle("colorContainer", "blind", {duration: .2});
	});

	function changeColorTheme(color) {
		$("commonCss").href = contextPath+"/css/color_theme/common-"+color+".css";
		$("menuCss").href = contextPath+"/css/color_theme/ddsmoothmenu-"+color+".css";
		$("alphacube").href = contextPath+"/css/themes/alphacube-"+color+".css";
		checkImgSrc = contextPath+"/css/image_themes/check-"+color+".gif";

		changeCheckImageColor();

		$("imgBanner").src = contextPath+"/css/color_theme/images/backgrounds/"+color+"/geniisys.gif";
		
		Effect.BlindUp("colorContainer", {duration: .2});
	}

	$$(".color").each(function (c) {
		c.observe("click", function () {
			changeColorTheme(c.readAttribute("id"));
		});
	});
</script> -->