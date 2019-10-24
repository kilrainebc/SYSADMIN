$source='\\PhPrdCtxTmp01W\c$\broadleaf_deploy'
$destination='\\PhPrdCtxDsk02w\c$\temp\folder''
Copy-Item -Recurse -Filter *.* -path $source -destination $destination -Force
