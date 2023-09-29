//%attributes = {"invisible":true,"publishedWeb":true}
var $user : cs.UserEntity
var $indexIdentifier; $indexPassword : Integer
var $identifier; $password : Text
var $url : Text



WEB GET HTTP HEADER($anames; $avalues)
$indexIdentifier:=Find in array($anames; "identifier")
$identifier:=$avalues{$indexIdentifier}

$indexPassword:=Find in array($anames; "password")
$password:=$avalues{$indexPassword}

WEB SEND TEXT(ds.Utilities.authenticate($identifier; $password))



