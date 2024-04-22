<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>

	<xsl:output method = "html" encoding="UTF-8" />
	<xsl:param name="arg1"/>

	<xsl:template match="/">

		<html>
			<head>
				<title>Process Report</title>
				<meta charset="UTF-8"/>
				<script>
					function btnClickAction(name)
					{
						window.chrome.webview.postMessage(name);
					}
				</script>
			</head>
			<body>
				<!--
				<h2>arg1 : <xsl:value-of select="$arg1"/></h2>
-->
				<div>
					<xsl:apply-templates select="/ArrayOfFileItem/FileItem" />
				</div>
			</body>

		</html>

	</xsl:template>


	<xsl:template match="FileItem">
		<a href="#" onclick="btnClickAction('{ID/text()}');return false;">
		<img width="300">
			<xsl:attribute name="src">file:///<xsl:value-of select="FullName/text()"/></xsl:attribute>
		</img>
		</a>
	</xsl:template>

</xsl:stylesheet>
