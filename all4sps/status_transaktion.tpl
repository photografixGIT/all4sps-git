{**
 * @copyright (c) 2006-2010 JTL-Software-GmbH, all rights reserved
 * @author JTL-Software-GmbH (www.jtl-software.de)
 *
 * use is subject to license terms
 * http://jtl-software.de/jtlshop3license.html
 *}

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
   <title>{$meta_title}</title>
   <meta http-equiv="content-type" content="text/html; charset={$JTL_CHARSET}">
   <META NAME="Title" CONTENT="{$meta_title}">
   <META NAME="description" CONTENT="{$meta_description|truncate:1000:"":true}">
   <META NAME="keywords" CONTENT="{$meta_keywords|truncate:255:"":true}">
   <META NAME="author" CONTENT="JTL-Software">
   <META NAME="language" CONTENT="{$meta_language}">
   <META NAME="revisit-after" CONTENT="7 days">
   <META NAME="robots" CONTENT="index, follow, all">
   <META NAME="publisher" CONTENT="{$meta_publisher}">
   <META NAME="copyright" CONTENT="{$meta_copyright}">
   <meta http-equiv="pragma" content="no-cache">
   <meta http-equiv="expires" content="now">
   <meta http-equiv="Content-Language" content="{$meta_language}">
   <link rel="stylesheet" type="text/css" href="{$currentTemplateDir}css/jtlshop3.css">
   <link rel="stylesheet" href="{$currentTemplateDir}css/tab.css" TYPE="text/css" MEDIA="screen">
   <link rel="stylesheet" href="{$currentTemplateDir}css/tab-print.css" TYPE="text/css" MEDIA="print">
   <link rel="shortcut icon" href="{$currentTemplateDir}gfx/favicon.ico" />
   {$headerscript}
</head>
<body {$onload}>
{$inhalt}
</body>
</html>