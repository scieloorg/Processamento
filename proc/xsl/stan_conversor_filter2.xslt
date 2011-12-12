<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>
	
	<xsl:template match="/">
		<recordset>
			<xsl:apply-templates select="//record"/>
		</recordset>
	</xsl:template>
	
	<xsl:template match="record">
		<xsl:copy>
			<xsl:attribute name="dir"/>
			<xsl:apply-templates select="*" mode="content">
				<xsl:sort select="name()"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*" mode="content">
		<xsl:copy-of select="."/>
	</xsl:template>
</xsl:stylesheet>
