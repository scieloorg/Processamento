<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>
	
	<xsl:variable name="langs" select="document('../xml/stan_language_list.xml')/languages"/>
	<xsl:variable name="countryList" select="document('../xml/stan_country_list.xml')"/>
		
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="* | @* | text()"/>
			<xsl:apply-templates select="fA08[@dir='en']" mode="counter"/>
			<xsl:apply-templates select="fA08[@dir='es']" mode="counter"/>
			<xsl:apply-templates select="fA08[@dir='pt']" mode="counter"/>
			<xsl:apply-templates select="fA08[@dir='fr']" mode="counter"/>
			<xsl:apply-templates select="fA08[@dir='ge']" mode="counter"/>
			<xsl:apply-templates select="fA08[@dir='it']" mode="counter"/>
			<xsl:apply-templates select="fC01[@dir='en']" mode="counter"/>
			<xsl:apply-templates select="fC01[@dir='es']" mode="counter"/>
			<xsl:apply-templates select="fC01[@dir='pt']" mode="counter"/>
			<xsl:apply-templates select="fC01[@dir='fr']" mode="counter"/>
			<xsl:apply-templates select="fC01[@dir='ge']" mode="counter"/>
			<xsl:apply-templates select="fC01[@dir='it']" mode="counter"/>
			<xsl:apply-templates select="fC03[@dir='en']" mode="counter"/>
			<xsl:apply-templates select="fC03[@dir='es']" mode="counter"/>
			<xsl:apply-templates select="fC03[@dir='pt']" mode="counter"/>
			<xsl:apply-templates select="fC03[@dir='fr']" mode="counter"/>
			<xsl:apply-templates select="fC03[@dir='ge']" mode="counter"/>
			<xsl:apply-templates select="fC03[@dir='it']" mode="counter"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:attribute name="dir"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="fA08 | fC01 | fC03"/>
	
	<xsl:template match="fA08" mode="counter">
		<xsl:variable name="lang" select="@dir"/>
		<xsl:copy>
			<xsl:attribute name="dir"><xsl:value-of select="concat(format-number(position(),'00'),1,$langs//lang[@id=$lang])"/></xsl:attribute>
			<xsl:apply-templates select="* | text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="fC01" mode="counter">
		<xsl:variable name="lang" select="@dir"/>
		<xsl:copy>
			<xsl:attribute name="dir"><xsl:value-of select="concat(format-number(position(),'00'),0,$langs//lang[@id=$lang])"/></xsl:attribute>
			<xsl:apply-templates select="* | text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="fC03" mode="counter">
		<xsl:variable name="lang" select="@dir"/>
		<xsl:copy>
			<xsl:attribute name="dir"><xsl:value-of select="concat(format-number(position(),'00'),1,$langs//lang[@id=$lang])"/></xsl:attribute>
			<xsl:apply-templates select="* | text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="fA11">
		<xsl:copy>
			<xsl:attribute name="dir"><xsl:value-of select="@dir"/></xsl:attribute>
			<xsl:copy-of select="s1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="fA14">
		<xsl:variable name="country" select="s3"/>
		<xsl:variable name="afiliationCode" select="concat('A',substring(@dir,1,2))"/>
		<xsl:copy>
			<xsl:attribute name="dir"><xsl:value-of select="@dir"/></xsl:attribute>
			<xsl:copy-of select="s1"/>
			<xsl:copy-of select="s2"/>
			<s3><xsl:value-of select="$countryList//country[. = $country]/@code"/></s3>
			<xsl:apply-templates select="../fA11[afiliation = $afiliationCode]/s1" mode="authorAffiliated"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*" mode="authorAffiliated">
		<sz><xsl:value-of select="substring(../@dir,1,2)"/></sz>
	</xsl:template>
	
	<xsl:template match="fA23">
			<xsl:variable name="lang" select="s0"/>
			<xsl:copy>
				<xsl:attribute name="dir"><xsl:value-of select="@dir"/></xsl:attribute>			
				<xsl:element name="s01"><xsl:value-of select="$langs//lang[@id=$lang]"/></xsl:element>
			</xsl:copy>
	</xsl:template>
	
	<xsl:template match="fA66">
		<xsl:variable name="country" select="s0"/>
		<xsl:copy>
			<xsl:attribute name="dir"><xsl:value-of select="@dir"/></xsl:attribute>			
			<s0><xsl:value-of select="$countryList//country[. = $country]/@code"/></s0>
		</xsl:copy>
	</xsl:template>	
	
</xsl:stylesheet>
