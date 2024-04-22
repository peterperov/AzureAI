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
				
				file:///
				<xsl:copy-of select="ArrayOfFileItem" />
-->
				<h1>Landing Page</h1>

				<hr />

				

				<hr />
				<h2>Video</h2>
				<hr />
				
				<xsl:apply-templates select="//FileItem[Type='video']" mode="video">
				</xsl:apply-templates>
				
				<hr />
				<h2>Audio</h2>
				<hr />
				<xsl:apply-templates select="//FileItem[Type='audio']" mode="audio">
				</xsl:apply-templates>
				
				<hr />
				<h2>Text</h2>
				<hr />
				<xsl:apply-templates select="//FileItem[Type='text']" mode="text">
				</xsl:apply-templates>
			
			</body>

		</html>

	</xsl:template>

	
	<xsl:template match="FileItem" mode="text">
		<b><xsl:value-of select="Name"/></b>
		<br />
		
		<textarea rows="10" cols="50">
			
			<xsl:value-of select="Content"/>
		</textarea>
	
	</xsl:template>

	<xsl:template match="FileItem" mode="audio">
		<b><xsl:value-of select="Name"/></b>
		<br />
		<audio controls="true">
			<source type="audio/wav">
				<xsl:attribute name="src">
					file:///<xsl:value-of select="FileName/text()"/>
				</xsl:attribute>
			</source> 
		</audio>		
	
	</xsl:template>

	<xsl:template match="FileItem" mode="video">
		<b><xsl:value-of select="Name"/></b>
		<br />		
		<xsl:value-of select="FileName"/>
		<video controls="true" width="600">
			<source type="audio/wav">
				<xsl:attribute name="src">
					file:///<xsl:value-of select="FileName/text()"/>
				</xsl:attribute>
			</source> 
		</video>			
	
	</xsl:template>	


</xsl:stylesheet>
