<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
    Name: HTML To Markdown Text;
    Version: 1.1.1;
    Date: 2009-05-05;
    Author: Michael Eichelsdoerfer;
    Description: Converts XHTML source code to Markdown text (http://daringfireball.net/projects/markdown/) or plain text;
    Credits: Inspired by Stephen Bau;
    Usage: <xsl:apply-templates select="path/to/your/node" mode="markdown"/>
    URL: http://symphony21.com/downloads/xslt/file/20573/
    Further reading: http://symphony21.com/forum/discussions/750/

    All source code included in this file is, unless otherwise specified,
    released under the MIT licence as follows:

    ***** begin license block *****

    Copyright 2009 Michael Eichelsdoerfer

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

    ***** end license block *****


    Parameters :

    (All parameters are global. Missing values will trigger default behaviour.):

    - h-style (headline-style)
        - (default): atx style headlines for h1 and h2 elements;
        - 'setex'; setex style headlines for h1 and h2 elements;
    - a-style (link-style)
        - (default): keep HTML syntax if non-convertible attributes are found;
        - 'markdown': convert **any** link to Markdown (loosing non-convertible attributes);
    - img-style (image-style)
        - (default): keep HTML syntax if non-convertible attributes are found;
        - 'markdown': convert **any** image tag to Markdown (loosing non-convertible attributes);
    - table-style
        - (default): keep HTML syntax;
        - 'break': break tables into one text paragraph for each cell (useful for email text);
    - escape-npss (escape number-period-space-sequence; see http://daringfireball.net/projects/markdown/syntax#list)
        - (default): perform escapes;
        - 'no': don't do it (useful for email text);
    - escape-out (escape output)
        - (default): disable-output-escaping is not used for blockquotes and code blocks;
        - 'no': 'disable-otput-escaping="yes"' for blockquotes and code blocks (useful for email text);
    - unparseables (unparseable HTML elements)
        - (default): keep HTML syntax;
        - 'strip': nomen est omen (useful for email text);
-->

<!-- configuration -->

<xsl:param name="h-style" select="'setex'"/>
<xsl:param name="a-style" select="'markdown'"/>
<xsl:param name="img-style" select="'markdown'"/>
<xsl:param name="table-style" select="'break'"/>
<xsl:param name="escape-npss" select="'no'"/>
<xsl:param name="escape-out" select="'no'"/>
<xsl:param name="unparseables" select="'strip'"/>

<xsl:template match="/">
    <xsl:apply-templates select="html/body" mode="markdown"/>
</xsl:template>

<!-- Ninja HTML Technique (http://chaoticpattern.com/article/manipulating-html-in-xml/) -->

<xsl:template match="*" mode="html">
    <xsl:element name="{name()}">
        <xsl:apply-templates select="* | @* | text()" mode="html"/>
    </xsl:element>
</xsl:template>

<xsl:template match="@*" mode="html">
    <xsl:attribute name="{name(.)}">
        <xsl:value-of select="."/>
    </xsl:attribute>
</xsl:template>

<!-- here we go -->

<xsl:template match="*" mode="markdown">
    <xsl:apply-templates select="*" mode="markdown"/>
</xsl:template>

<!-- whitespace handling | escape number-period-space-sequences-->

<xsl:template match="text()" mode="markdown">
    <xsl:choose>
        <xsl:when test="translate(., '&#xA;&#xD;&#x9;&#x20;', '') = ''">
            <xsl:text>&#x20;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="text-w-spaces" select="translate(., '&#xA;&#xD;&#x9;&#x20;', '&#x20;&#x20;&#x20;&#x20;')"/>
            <xsl:variable name="leading-char">
                <xsl:if test="substring($text-w-spaces, 1, 1) = '&#x20;'">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="trailing-char">
                <xsl:if test="substring($text-w-spaces, string-length($text-w-spaces), 1) = '&#x20;'">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="string" select="concat($leading-char, normalize-space($text-w-spaces), $trailing-char)"/>
            <xsl:call-template name="escape-number-period-space-sequence">
                <xsl:with-param name="string" select="$string"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="text()[position() = 1 or
                            ((preceding-sibling::*)[last()][self::address    or
                                                            self::blockquote or
                                                            self::div        or
                                                            self::dl         or
                                                            self::fieldset   or
                                                            self::form       or
                                                            self::h1         or
                                                            self::h2         or
                                                            self::h3         or
                                                            self::h4         or
                                                            self::h5         or
                                                            self::h6         or
                                                            self::hr         or
                                                            self::noscript   or
                                                            self::ol         or
                                                            self::p          or
                                                            self::pre        or
                                                            self::table      or
                                                            self::ul         or
                                                            self::br         ])]" mode="markdown">
    <xsl:variable name="text-w-spaces" select="translate(., '&#xA;&#xD;&#x9;&#x20;', '&#x20;&#x20;&#x20;&#x20;')"/>
    <xsl:choose>
        <xsl:when test="translate(., '&#xA;&#xD;&#x9;&#x20;', '') = ''">
            <xsl:text></xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="trailing-char">
                <xsl:if test="substring($text-w-spaces, string-length($text-w-spaces), 1) = '&#x20;'">
                    <xsl:text>&#x20;</xsl:text>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="string" select="concat(normalize-space($text-w-spaces), $trailing-char)"/>
            <xsl:call-template name="escape-number-period-space-sequence">
                <xsl:with-param name="string">
                    <xsl:value-of select="$string"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- h1, h2 -->

<xsl:template match="h1" mode="markdown">
    <xsl:choose>
        <xsl:when test="$h-style = 'setex'">
            <xsl:text>&#xA;</xsl:text>
            <xsl:apply-templates select="* | text()" mode="markdown"/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:call-template name="underline-string">
                <xsl:with-param name="string">
                    <xsl:apply-templates select="* | text()" mode="markdown"/>
                </xsl:with-param>
                <xsl:with-param name="underline-char" select="'='"/>
            </xsl:call-template>
            <xsl:text>&#xA;&#xA;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text># </xsl:text>
            <xsl:apply-templates select="* | text()" mode="markdown"/>
            <xsl:text>&#xA;&#xA;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="h2" mode="markdown">
    <xsl:choose>
        <xsl:when test="$h-style = 'setex'">
            <xsl:text>&#xA;</xsl:text>
            <xsl:apply-templates select="* | text()" mode="markdown"/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:call-template name="underline-string">
                <xsl:with-param name="string">
                    <xsl:apply-templates select="* | text()" mode="markdown"/>
                </xsl:with-param>
                <xsl:with-param name="underline-char" select="'-'"/>
            </xsl:call-template>
            <xsl:text>&#xA;&#xA;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>## </xsl:text>
            <xsl:apply-templates select="* | text()" mode="markdown"/>
            <xsl:text>&#xA;&#xA;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- h3, h4, h5, h6 -->

<xsl:template match="h3" mode="markdown">
    <xsl:text>### </xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

<xsl:template match="h4" mode="markdown">
    <xsl:text>#### </xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

<xsl:template match="h5" mode="markdown">
    <xsl:text>##### </xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

<xsl:template match="h6" mode="markdown">
    <xsl:text>###### </xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

<!-- p, br, hr -->

<xsl:template match="p" mode="markdown">
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

<xsl:template match="br" mode="markdown">
    <xsl:text>&#x20;&#x20;</xsl:text>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="hr" mode="markdown">
    <xsl:text>---</xsl:text>
    <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

<!-- em, strong -->

<xsl:template match="em" mode="markdown">
    <xsl:text>_</xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>_</xsl:text>
</xsl:template>

<xsl:template match="strong" mode="markdown">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>**</xsl:text>
</xsl:template>

<!-- unordered lists -->

<xsl:template match="ul" mode="markdown">
    <xsl:apply-templates select="*" mode="markdown"/>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="ul/li" mode="markdown">
    <xsl:text>*&#x20;</xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="ul/li/ul" mode="markdown" priority="1">
    <xsl:text>&#xA;</xsl:text>
    <xsl:apply-templates select="*" mode="markdown"/>
</xsl:template>

<xsl:template match="ul/li/ul/li" mode="markdown" priority="1">
    <xsl:text>&#x20;&#x20;&#x20;&#x20;*&#x20;</xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:if test="position() != last()">
        <xsl:text>&#xA;</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="ul/li/ul/li/ul/li" mode="markdown" priority="2">
    <xsl:text>&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;*&#x20;</xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:if test="position() != last()">
        <xsl:text>&#xA;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- ordered lists -->

<xsl:template match="ol" mode="markdown">
    <xsl:apply-templates select="*" mode="markdown"/>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="ol/li" mode="markdown">
    <xsl:value-of select="position()"/>
    <xsl:text>.&#x20;</xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="ol/li/ol" mode="markdown" priority="1">
    <xsl:text>&#xA;</xsl:text>
    <xsl:apply-templates select="*" mode="markdown"/>
</xsl:template>

<xsl:template match="ol/li/ol/li" mode="markdown" priority="1">
    <xsl:text>&#x20;&#x20;&#x20;&#x20;</xsl:text>
    <xsl:value-of select="position()"/>
    <xsl:text>.&#x20;</xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:if test="position() != last()">
        <xsl:text>&#xA;</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="ol/li/ol/li/ol/li" mode="markdown" priority="2">
    <xsl:text>&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;&#x20;</xsl:text>
    <xsl:value-of select="position()"/>
    <xsl:text>. </xsl:text>
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:if test="position() != last()">
        <xsl:text>&#xA;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- links -->

<xsl:template match="a" mode="markdown">
    <xsl:choose>
        <xsl:when test="(@class or @id or @rel) and $a-style != 'markdown'">
            <xsl:apply-templates select="." mode="html"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>[</xsl:text>
            <xsl:apply-templates select="* | text()" mode="markdown"/>
            <xsl:text>](</xsl:text>
            <xsl:value-of select="@href"/>
            <xsl:if test="@title != ''">
                <xsl:text>&#x20;"</xsl:text>
                <xsl:value-of select="@title"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:text>)</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="parent::div">
        <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- images -->

<xsl:template match="img" mode="markdown">
    <xsl:choose>
        <xsl:when test="(@class or @id or @style) and $img-style != 'markdown'">
            <xsl:apply-templates select="." mode="html"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>![</xsl:text>
            <xsl:value-of select="@alt"/>
            <xsl:text>](</xsl:text>
            <xsl:value-of select="@src"/>
            <xsl:if test="@title != ''">
                <xsl:text>&#x20;"</xsl:text>
                <xsl:value-of select="@title"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:text>)</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="parent::div">
        <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- blockquotes -->

<xsl:template match="blockquote" mode="markdown">
    <xsl:variable name="content-stripped">
        <xsl:call-template name="strip-trailing-line-breaks">
            <xsl:with-param name="string">
                <xsl:apply-templates select="* | text()" mode="markdown"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:call-template name="markdown-blockquote">
        <xsl:with-param name="input" select="$content-stripped"/>
    </xsl:call-template>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="markdown-blockquote">
    <xsl:param name="input"/>
    <xsl:variable name="line">
        <xsl:choose>
            <xsl:when test="contains($input,'&#xA;')">
                <xsl:value-of select="substring-before($input,'&#xA;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="remaining-lines" select="substring-after($input,'&#xA;')"/>
    <xsl:choose>
        <xsl:when test="$escape-out = 'no'">
            <xsl:text disable-output-escaping="yes">&gt;&#x20;</xsl:text>
            <xsl:value-of select="$line" disable-output-escaping="yes"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>&gt;&#x20;</xsl:text>
            <xsl:value-of select="$line"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#xA;</xsl:text>
    <xsl:if test="$remaining-lines != ''">
        <xsl:call-template name="markdown-blockquote">
            <xsl:with-param name="input" select="$remaining-lines"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- pre, code -->

<xsl:template match="code" mode="markdown">
    <xsl:text>`</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text>`</xsl:text>
</xsl:template>

<xsl:template match="pre" mode="markdown">
    <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="pre/code" mode="markdown" priority="1">
    <xsl:apply-templates select="* | text()" mode="markdown"/>
</xsl:template>

<xsl:template match="pre/code/text()" mode="markdown" priority="1">
    <xsl:call-template name="markdown-code-block">
        <xsl:with-param name="input" select="."/>
    </xsl:call-template>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="markdown-code-block">
    <xsl:param name="input"/>
    <xsl:variable name="line">
        <xsl:choose>
            <xsl:when test="contains($input,'&#xA;')">
                <xsl:value-of select="substring-before($input,'&#xA;')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="remaining-lines" select="substring-after($input,'&#xA;')"/>
    <xsl:text>&#x20;&#x20;&#x20;&#x20;</xsl:text>
    <xsl:choose>
        <xsl:when test="$escape-out = 'no'">
            <xsl:value-of select="$line" disable-output-escaping="yes"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$line"/>
        </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#xA;</xsl:text>
    <xsl:if test="$remaining-lines != ''">
        <xsl:call-template name="markdown-code-block">
            <xsl:with-param name="input" select="$remaining-lines"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- tables -->

<xsl:template match="table" mode="markdown">
    <xsl:choose>
        <xsl:when test="$table-style = 'break'">
            <xsl:apply-templates select="." mode="break"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="." mode="html"/>
            <xsl:text>&#xA;&#xA;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="table" mode="break">
    <xsl:apply-templates select="*" mode="break"/>
</xsl:template>

<xsl:template match="tr" mode="break">
    <xsl:apply-templates select="*" mode="break"/>
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template match="td" mode="break">
    <xsl:apply-templates select="* | text()" mode="markdown"/>
    <xsl:if test="not(p[last()])">
        <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- unparseable elements (all handled as block level with trailing LFs) -->

<xsl:template match="address | dl | fieldset | form | map | object | script | noscript" mode="markdown">
    <xsl:if test="$unparseables != 'strip'">
        <xsl:apply-templates select="." mode="html"/>
        <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- utilities -->

<xsl:template name="underline-string">
    <xsl:param name="string"/>
    <xsl:param name="underline-char"/>
    <xsl:param name="count" select="1"/>
    <xsl:if test="$count &lt;= string-length(normalize-space($string))">
        <xsl:value-of select="$underline-char"/>
        <xsl:call-template name="underline-string">
            <xsl:with-param name="string" select="$string"/>
            <xsl:with-param name="underline-char" select="$underline-char"/>
            <xsl:with-param name="count" select="$count + 1"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="strip-trailing-line-breaks">
    <xsl:param name="string"/>
    <xsl:variable name="last-char">
        <xsl:value-of select="substring($string, string-length($string), 1)"/>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="$last-char = '&#xA;' or
                        $last-char = '&#xD;'">
            <xsl:call-template name="strip-trailing-line-breaks">
                <xsl:with-param name="string" select="substring($string, 1, string-length($string) - 1)"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$string"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="escape-number-period-space-sequence">
    <xsl:param name="string"/>
    <xsl:choose>
        <xsl:when test="$escape-npss = 'no'">
            <xsl:value-of select="$string"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="number(substring-before($string, '.')) and starts-with(substring-after($string, '.'), ' ')">
                    <xsl:value-of select="number(substring-before($string, '.'))"/>
                    <xsl:text>\.</xsl:text>
                    <xsl:value-of select="substring-after($string, '.')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$string"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
